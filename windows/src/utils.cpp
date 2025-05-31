#include <windows.h>
#include <string>
#include <list>
#include <chrono>
#include <thread>
#include "../include/dart_auto_gui_windows/mouse/mouse.h"
#include "../include/dart_auto_gui_windows/utils.h"
namespace dag
{

    DWORD Utils::convertMouseButton(MouseButton button, bool isInUpState)
    {
        switch (button)
        {
        case MOUSE_BUTTON_LEFT:
            return isInUpState ? MOUSEEVENTF_LEFTUP : MOUSEEVENTF_LEFTDOWN;
        case MOUSE_BUTTON_RIGHT:
            return isInUpState ? MOUSEEVENTF_RIGHTUP : MOUSEEVENTF_RIGHTDOWN;
        case MOUSE_BUTTON_MIDDLE:
            return isInUpState ? MOUSEEVENTF_MIDDLEUP : MOUSEEVENTF_MIDDLEDOWN;
        default:
            return isInUpState ? MOUSEEVENTF_LEFTUP : MOUSEEVENTF_LEFTDOWN;
        }
    }

    DWORD Utils::inverseMouseButton(DWORD button)
    {
        // If it's a DOWN event, return the corresponding UP event (value * 2)
        // If it's an UP event, return the corresponding DOWN event (value / 2)
        return (button & 1) ? (button >> 1) : (button << 1);
    }

    DWORD Utils::convertScrollAxis(ScrollAxis axis)
    {
        switch (axis)
        {
        case VERTICAL:
            return MOUSEEVENTF_WHEEL;
        case HORIZONTAL:
            return MOUSEEVENTF_HWHEEL;
        default:
            return MOUSEEVENTF_WHEEL;
        }
    }

    SHORT Utils::convertCharacter(CHAR ch)
    {
        HKL kbl = GetKeyboardLayout(0);
        SHORT vk = VkKeyScanEx(ch, kbl);
        return vk;
    }

}