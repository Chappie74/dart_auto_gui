#include <windows.h>
#include <string>
#include <chrono>
#include <thread>
#include "../include/dart_auto_gui_windows/mouse.h"
#include <utils.h>

namespace dag
{
    POINT Mouse::mousePosition()
    {
        POINT p;
        GetCursorPos(&p);
        return p;
    }

    void Mouse::move(std::list<POINT> points, int sleep)
    {
        for (POINT p : points)
        {
            if (failSafeTriggered())
            {
                return;
            }
            MOUSEINPUT input;
            ZeroMemory(&input, sizeof(input));
            input.dx = ::MulDiv(p.x, 65536, GetSystemMetrics(SM_CXVIRTUALSCREEN) - 1);
            input.dy = ::MulDiv(p.y, 65536, GetSystemMetrics(SM_CYVIRTUALSCREEN) - 1);
            input.dwFlags = MOUSEEVENTF_MOVE | MOUSEEVENTF_VIRTUALDESK | MOUSEEVENTF_ABSOLUTE;
            Mouse::executeMouseEvent(input);
            ::Sleep(sleep);
        }
    }

    void Mouse::mouseDown(DWORD button)
    {
        MOUSEINPUT input;
        ZeroMemory(&input, sizeof(input));
        input.dwFlags = button;
        Mouse::executeMouseEvent(input);
    }

    void Mouse::mouseUp(DWORD button)
    {
        MOUSEINPUT input;
        ZeroMemory(&input, sizeof(input));
        input.dwFlags = button;
        Mouse::executeMouseEvent(input);
    }

    void Mouse::click(DWORD button, int clicks, int interval)
    {
        for (int i = 0; i < clicks; i++)
        {
            if (failSafeTriggered())
            {
                return;
            }
            mouseDown(button);
            mouseUp(Utils::inverseMouseButton(button));
            ::Sleep(interval);
        }
    }

    void Mouse::scroll(int clicks, DWORD axis)
    {
        MOUSEINPUT input;
        ZeroMemory(&input, sizeof(input));
        input.dwFlags = axis;
        input.mouseData = WHEEL_DELTA * clicks;
        executeMouseEvent(input);
    }

    bool Mouse::failSafeTriggered()
    {
        POINT p = mousePosition();
        return (p.x == 0 && p.y == 0);
    }

    // private
    void Mouse::executeMouseEvent(MOUSEINPUT mouseInput)
    {
        INPUT input;
        ZeroMemory(&input, sizeof(input));
        input.type = INPUT_MOUSE;
        input.mi = mouseInput;
        SendInput(1, &input, sizeof(input));
    }

}

extern "C"
{
    __declspec(dllexport) C_POINT mouse_position()
    {
        POINT p = dag::Mouse::mousePosition();
        return C_POINT{p.x, p.y};
    }

    __declspec(dllexport) void move(C_POINT *points, int count, int sleep)
    {
        std::list<POINT> pointsList;
        for (int i = 0; i < count; i++)
        {
            POINT p;
            p.x = points[i].x;
            p.y = points[i].y;
            pointsList.push_back(p);
        }
        dag::Mouse::move(pointsList, sleep);
    }

    __declspec(dllexport) void mouse_down(MouseButton button)
    {
        dag::Mouse::mouseDown(dag::Utils::convertMouseButton(button, false));
    }

    __declspec(dllexport) void mouse_up(MouseButton button)
    {
        dag::Mouse::mouseUp(dag::Utils::convertMouseButton(button, true));
    }

    __declspec(dllexport) void click(MouseButton button, int clicks, int interval)
    {
        dag::Mouse::click(dag::Utils::convertMouseButton(button, false), clicks, interval);
    }

    __declspec(dllexport) void scroll(int clicks, ScrollAxis axis)
    {
        dag::Mouse::scroll(clicks, dag::Utils::convertScrollAxis(axis));
    }
}