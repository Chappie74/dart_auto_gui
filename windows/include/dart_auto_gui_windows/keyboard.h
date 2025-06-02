#pragma once
#include <windows.h>
#include <string>
#include <list>
#include <windows.h>
#include <string>
#include <list>

namespace dag
{
    class Keyboard
    {
    public:
        static void write(const std::string &text, const int interval = 10);
        static void keyUp(const std::string &key);
        static void keyDown(const std::string &key);
        static void press(const std::string &key, const int time = 1, const int interval = 10);
        static void hotkey(const std::vector<std::string> &keys, const int interval = 10);

    private:
        static void executeKeyboardEvent(const std::list<KEYBDINPUT> &keyboardInputs);
        static void executeKeyboardEvent(const KEYBDINPUT &keyboardInput);
    };
};
