#include <windows.h>
#include <string>
#include <list>
#include "mouse.h"

#pragma once
namespace dag
{
    class Utils
    {
    public:
        // std::list<POINT> parsePointsList(flutter::EncodableList list);
        static DWORD convertMouseButton(MouseButton button, bool isInUpState);
        static DWORD inverseMouseButton(DWORD button);
        static DWORD convertScrollAxis(ScrollAxis axis);
        static SHORT convertCharacter(CHAR ch);
        static void sleep(int duration);
    };
};
