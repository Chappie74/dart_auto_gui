#pragma once
#include <windows.h>
#include <string>
#include <list>

typedef struct
{
    int32_t x;
    int32_t y;
} C_POINT;

typedef enum
{
    MOUSE_BUTTON_LEFT,
    MOUSE_BUTTON_RIGHT,
    MOUSE_BUTTON_MIDDLE
} MouseButton;

typedef enum
{
    VERTICAL,
    HORIZONTAL
} ScrollAxis;

namespace dag
{
    class Mouse
    {
    public:
        // Mouse Event Methods
        static POINT mousePosition();
        static void move(std::list<POINT> points, int sleep);
        // static void drag(std::list<POINT> points, int sleep, std::string button);
        static void mouseDown(DWORD button);
        static void mouseUp(DWORD button);
        static void click(DWORD button, int clicks, int interval);
        static void scroll(int clicks, DWORD axis);
        static bool failSafeTriggered();

    private:
        static void executeMouseEvent(MOUSEINPUT input);
    };
};
