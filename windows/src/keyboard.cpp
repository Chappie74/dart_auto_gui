#include <windows.h>
#include <string>
#include <list>
#include <iostream>
#include <vector>
#include "../include/dart_auto_gui_windows/keyboard.h"
#include "../include/dart_auto_gui_windows/keyboard_keys.h"
#include "../include/dart_auto_gui_windows/mouse.h"
#include "../include/dart_auto_gui_windows/utils.h"
namespace dag
{
    void Keyboard::keyUp(const std::string &key)
    {
        WORD mappedKey = getKeyCode(key);
        const UINT scanCode = MapVirtualKey(LOBYTE(mappedKey), MAPVK_VK_TO_VSC);
        if (scanCode == 0)
        {
            return;
        }
        KEYBDINPUT input;
        ZeroMemory(&input, sizeof(input));
        input.wScan = (WORD)scanCode;
        input.dwFlags = KEYEVENTF_SCANCODE | KEYEVENTF_KEYUP;
        executeKeyboardEvent(input);
    }

    // Sets the [key] to Down position
    void Keyboard::keyDown(const std::string &key)
    {
        WORD mappedKey = getKeyCode(key);
        // converts the virtual keycode to scan code
        const UINT scanCode = MapVirtualKey(LOBYTE(mappedKey), 0);
        std::list<KEYBDINPUT> keyboardInputs;
        KEYBDINPUT input;
        ZeroMemory(&input, sizeof(input));

        // check high order byte to see if shift key is pressed (for upper case letters)
        if (mappedKey & 0x100)
        {
            // shift down input
            input.wScan = (WORD)MapVirtualKey(VK_LSHIFT, 0);
            input.dwFlags = KEYEVENTF_SCANCODE;
            keyboardInputs.push_back(input);

            // current key down
            ZeroMemory(&input, sizeof(input));
            input.wScan = (WORD)scanCode;
            input.dwFlags = KEYEVENTF_SCANCODE;
            keyboardInputs.push_back(input);

            // shift up input
            ZeroMemory(&input, sizeof(input));
            input.wScan = (WORD)MapVirtualKey(VK_LSHIFT, 0);
            input.dwFlags = KEYEVENTF_SCANCODE | KEYEVENTF_KEYUP;
            keyboardInputs.push_back(input);
            Keyboard::executeKeyboardEvent(keyboardInputs);
        }
        else
        {
            // current key down
            ZeroMemory(&input, sizeof(input));
            input.wScan = (WORD)scanCode;
            input.dwFlags = KEYEVENTF_SCANCODE;
            Keyboard::executeKeyboardEvent(input);
        }
    }

    // Sets a [key] to Down then Up position for a given amount of [time]
    // with [interval] delay between each action
    void Keyboard::press(const std::string &key, const int times, const int interval)
    {
        for (int i = 0; i < times; i++)
        {
            Keyboard::keyDown(key);
            Keyboard::keyUp(key);
            ::Sleep(interval);
            if (Mouse::failSafeTriggered())
            {
                return;
            }
        }
    }

    // Presses the corresponding key for each letter in [text] with [interval] delay
    // between each pres`s
    void Keyboard::write(const std::string &text, const int interval)
    {
        for (int i = 0; i < text.length(); i++)
        {
            Keyboard::press(std::string(1, text[i]), 1, 0);
            ::Sleep(interval);
            if (Mouse::failSafeTriggered())
            {
                return;
            }
        }
    }

    // Sets a [key] to Down then Up position for a given amount of [time]
    // with [interval] delay between each action
    void Keyboard::hotkey(const std::vector<std::string> &keys, const int interval)
    {
        // Press all keys in order
        for (auto key : keys)
        {
            Keyboard::keyDown(key);
            ::Sleep(interval);

            if (Mouse::failSafeTriggered())
            {
                return;
            }
        }

        // Release all keys in reverse order
        for (auto it = keys.rbegin(); it != keys.rend(); ++it)
        {
            Keyboard::keyUp(*it);
            if (Mouse::failSafeTriggered())
            {
                return;
            }
        }
    }

    // private

    // General function to execute send input keyboard events ()
    void Keyboard::executeKeyboardEvent(const std::list<KEYBDINPUT> &keyboardInputs)
    {
        std::vector<INPUT> inputs;
        inputs.reserve(keyboardInputs.size());

        for (const auto &kbInput : keyboardInputs)
        {
            INPUT in = {0};
            in.type = INPUT_KEYBOARD;
            in.ki = kbInput;
            inputs.push_back(in);
        }
        if (!inputs.empty())
        {
            SendInput(static_cast<UINT>(inputs.size()), inputs.data(), sizeof(INPUT));
        }
    }

    void Keyboard::executeKeyboardEvent(const KEYBDINPUT &keyboardInput)
    {
        INPUT input = {0};
        input.type = INPUT_KEYBOARD;
        input.ki = keyboardInput;
        SendInput(1, &input, sizeof(INPUT));
    }
}

extern "C"
{
    __declspec(dllexport) void key_up(const char *key)
    {
        dag::Keyboard::keyUp(std::string(key));
    }

    __declspec(dllexport) void key_down(const char *key)
    {
        dag::Keyboard::keyDown(std::string(key));
    }

    __declspec(dllexport) void press(const char *key, int times, const int interval)
    {
        dag::Keyboard::press(std::string(key), times, interval);
    }

    __declspec(dllexport) void write(const char *key, const int interval)
    {
        dag::Keyboard::write(std::string(key), interval);
    }

    __declspec(dllexport) void hotkey(const char **keys, const int keys_count, const int interval)
    {
        std::vector<std::string> keysVector;
        for (int i = 0; i < keys_count; i++)
        {
            keysVector.push_back(keys[i]);
        }
        dag::Keyboard::hotkey(
            keysVector, interval);
    }
}