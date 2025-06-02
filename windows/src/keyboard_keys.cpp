#include <string>
#include <unordered_map>
#include <cctype>
#include <windows.h>
#include <algorithm>
#include "../../include/dart_auto_gui_windows/utils.h"

namespace dag
{

    WORD getKeyCode(const std::string &key)
    {
        if (key.length() == 1)
        {
            char c = key[0];
            switch (c)
            {
            // special characters
            case ' ':
                return 0x20;
            case '\b':
                return 0x08;
            case '\t':
                return 0x09;
            case '\n':
                return 0x0d;

            default:
                if ((c >= '0' && c <= '9') || // numeric
                    (c >= 'A' && c <= 'Z') || // Uppercase Alpha
                    (c >= 'a' && c <= 'z') || // Lowercase Alpha
                    (c >= '!' && c <= '~'))   // All printable ASCII
                {
                    return Utils::convertCharacter(c);
                }
                return static_cast<WORD>(-1); // Unknown key
            }
        }
        // Handle multi-character keys (case-insensitive)
        std::string lowerKey = key;
        std::transform(lowerKey.begin(), lowerKey.end(), lowerKey.begin(), ::tolower);

        // Function keys
        if (lowerKey == "f1")
            return 0x70;
        if (lowerKey == "f2")
            return 0x71;
        if (lowerKey == "f3")
            return 0x72;
        if (lowerKey == "f4")
            return 0x73;
        if (lowerKey == "f5")
            return 0x74;
        if (lowerKey == "f6")
            return 0x75;
        if (lowerKey == "f7")
            return 0x76;
        if (lowerKey == "f8")
            return 0x77;
        if (lowerKey == "f9")
            return 0x78;
        if (lowerKey == "f10")
            return 0x79;
        if (lowerKey == "f11")
            return 0x7A;
        if (lowerKey == "f12")
            return 0x7B;
        if (lowerKey == "f13")
            return 0x7C;
        if (lowerKey == "f14")
            return 0x7D;
        if (lowerKey == "f15")
            return 0x7E;
        if (lowerKey == "f16")
            return 0x7F;
        if (lowerKey == "f17")
            return 0x80;
        if (lowerKey == "f18")
            return 0x81;
        if (lowerKey == "f19")
            return 0x82;
        if (lowerKey == "f20")
            return 0x83;
        if (lowerKey == "f21")
            return 0x84;
        if (lowerKey == "f22")
            return 0x85;
        if (lowerKey == "f23")
            return 0x86;
        if (lowerKey == "f24")
            return 0x87;

        // Navigation keys
        if (lowerKey == "left")
            return 0x25;
        if (lowerKey == "up")
            return 0x26;
        if (lowerKey == "right")
            return 0x27;
        if (lowerKey == "down")
            return 0x28;
        if (lowerKey == "home")
            return 0x24;
        if (lowerKey == "end")
            return 0x23;
        if (lowerKey == "pageup" || lowerKey == "pgup")
            return 0x21;
        if (lowerKey == "pagedown" || lowerKey == "pgdn")
            return 0x22;

        // Modifier keys
        if (lowerKey == "shift")
            return 0x10;
        if (lowerKey == "ctrl")
            return 0x11;
        if (lowerKey == "alt")
            return 0x12;
        if (lowerKey == "shiftleft")
            return 0xA0;
        if (lowerKey == "shiftright")
            return 0xA1;
        if (lowerKey == "ctrlleft")
            return 0xA2;
        if (lowerKey == "ctrlright")
            return 0xA3;
        if (lowerKey == "altleft")
            return 0xA4;
        if (lowerKey == "altright")
            return 0xA5;

        // Special keys
        if (lowerKey == "esc" || lowerKey == "escape")
            return 0x1B;
        if (lowerKey == "enter" || lowerKey == "return")
            return 0x0D;
        if (lowerKey == "backspace")
            return 0x08;
        if (lowerKey == "tab")
            return 0x09;
        if (lowerKey == "delete" || lowerKey == "del")
            return 0x2E;
        if (lowerKey == "insert")
            return 0x2D;
        if (lowerKey == "capslock")
            return 0x14;
        if (lowerKey == "numlock")
            return 0x90;
        if (lowerKey == "scrolllock")
            return 0x91;
        if (lowerKey == "printscreen" || lowerKey == "prtsc" || lowerKey == "prtscr" || lowerKey == "prntscrn")
            return 0x2C;

        // Windows keys
        if (lowerKey == "win" || lowerKey == "super" || lowerKey == "winleft")
            return 0x5B;
        if (lowerKey == "winright")
            return 0x5C;
        if (lowerKey == "apps")
            return 0x5D;

        // Numpad keys
        if (lowerKey == "num0")
            return 0x60;
        if (lowerKey == "num1")
            return 0x61;
        if (lowerKey == "num2")
            return 0x62;
        if (lowerKey == "num3")
            return 0x63;
        if (lowerKey == "num4")
            return 0x64;
        if (lowerKey == "num5")
            return 0x65;
        if (lowerKey == "num6")
            return 0x66;
        if (lowerKey == "num7")
            return 0x67;
        if (lowerKey == "num8")
            return 0x68;
        if (lowerKey == "num9")
            return 0x69;
        if (lowerKey == "multiply")
            return 0x6A;
        if (lowerKey == "add")
            return 0x6B;
        if (lowerKey == "separator")
            return 0x6C;
        if (lowerKey == "subtract")
            return 0x6D;
        if (lowerKey == "decimal")
            return 0x6E;
        if (lowerKey == "divide")
            return 0x6F;

        // Media keys
        if (lowerKey == "volumemute")
            return 0xAD;
        if (lowerKey == "volumedown")
            return 0xAE;
        if (lowerKey == "volumeup")
            return 0xAF;
        if (lowerKey == "nexttrack")
            return 0xB0;
        if (lowerKey == "prevtrack")
            return 0xB1;
        if (lowerKey == "stop")
            return 0xB2;
        if (lowerKey == "playpause")
            return 0xB3;

        return static_cast<WORD>(-1); // Unknown key
    }

}

//  enum class KeyCode
//     {
//         // Special keys
//         BACKSPACE = 0x08,    // VK_BACK
//         SUPER = 0x5B,        // VK_LWIN
//         TAB = 0x09,          // VK_TAB
//         CLEAR = 0x0C,        // VK_CLEAR
//         ENTER = 0x0D,        // VK_RETURN
//         SHIFT = 0x10,        // VK_SHIFT
//         CTRL = 0x11,         // VK_CONTROL
//         ALT = 0x12,          // VK_MENU
//         PAUSE = 0x13,        // VK_PAUSE
//         CAPSLOCK = 0x14,     // VK_CAPITAL
//         KANA = 0x15,         // VK_KANA
//         HANGUEL = 0x15,      // VK_HANGUEL
//         HANGUL = 0x15,       // VK_HANGUL
//         JUNJA = 0x17,        // VK_JUNJA
//         FINAL = 0x18,        // VK_FINAL
//         HANJA = 0x19,        // VK_HANJA
//         KANJI = 0x19,        // VK_KANJI
//         ESCAPE = 0x1B,       // VK_ESCAPE
//         CONVERT = 0x1C,      // VK_CONVERT
//         NONCONVERT = 0x1D,   // VK_NONCONVERT
//         ACCEPT = 0x1E,       // VK_ACCEPT
//         MODECHANGE = 0x1F,   // VK_MODECHANGE
//         SPACE = 0x20,        // VK_SPACE
//         PAGE_UP = 0x21,      // VK_PRIOR
//         PAGE_DOWN = 0x22,    // VK_NEXT
//         END = 0x23,          // VK_END
//         HOME = 0x24,         // VK_HOME
//         LEFT = 0x25,         // VK_LEFT
//         UP = 0x26,           // VK_UP
//         RIGHT = 0x27,        // VK_RIGHT
//         DOWN = 0x28,         // VK_DOWN
//         SELECT = 0x29,       // VK_SELECT
//         PRINT = 0x2A,        // VK_PRINT
//         EXECUTE = 0x2B,      // VK_EXECUTE
//         PRINT_SCREEN = 0x2C, // VK_SNAPSHOT
//         INSERT = 0x2D,       // VK_INSERT
//         DEL = 0x2E,          // VK_DELETE
//         HELP = 0x2F,         // VK_HELP
//         WIN_LEFT = 0x5B,     // VK_LWIN
//         WIN_RIGHT = 0x5C,    // VK_RWIN
//         APPS = 0x5D,         // VK_APPS
//         SLEEP = 0x5F,        // VK_SLEEP

//         // Numpad keys
//         NUM0 = 0x60,      // VK_NUMPAD0
//         NUM1 = 0x61,      // VK_NUMPAD1
//         NUM2 = 0x62,      // VK_NUMPAD2
//         NUM3 = 0x63,      // VK_NUMPAD3
//         NUM4 = 0x64,      // VK_NUMPAD4
//         NUM5 = 0x65,      // VK_NUMPAD5
//         NUM6 = 0x66,      // VK_NUMPAD6
//         NUM7 = 0x67,      // VK_NUMPAD7
//         NUM8 = 0x68,      // VK_NUMPAD8
//         NUM9 = 0x69,      // VK_NUMPAD9
//         MULTIPLY = 0x6A,  // VK_MULTIPLY
//         ADD = 0x6B,       // VK_ADD
//         SEPARATOR = 0x6C, // VK_SEPARATOR
//         SUBTRACT = 0x6D,  // VK_SUBTRACT
//         DECIMAL = 0x6E,   // VK_DECIMAL
//         DIVIDE = 0x6F,    // VK_DIVIDE

//         // Function keys
//         F1 = 0x70,  // VK_F1
//         F2 = 0x71,  // VK_F2
//         F3 = 0x72,  // VK_F3
//         F4 = 0x73,  // VK_F4
//         F5 = 0x74,  // VK_F5
//         F6 = 0x75,  // VK_F6
//         F7 = 0x76,  // VK_F7
//         F8 = 0x77,  // VK_F8
//         F9 = 0x78,  // VK_F9
//         F10 = 0x79, // VK_F10
//         F11 = 0x7A, // VK_F11
//         F12 = 0x7B, // VK_F12
//         F13 = 0x7C, // VK_F13
//         F14 = 0x7D, // VK_F14
//         F15 = 0x7E, // VK_F15
//         F16 = 0x7F, // VK_F16
//         F17 = 0x80, // VK_F17
//         F18 = 0x81, // VK_F18
//         F19 = 0x82, // VK_F19
//         F20 = 0x83, // VK_F20
//         F21 = 0x84, // VK_F21
//         F22 = 0x85, // VK_F22
//         F23 = 0x86, // VK_F23
//         F24 = 0x87, // VK_F24

//         // Lock keys
//         NUMLOCK = 0x90,    // VK_NUMLOCK
//         SCROLLLOCK = 0x91, // VK_SCROLL

//         // Modifier keys with left/right variants
//         SHIFT_LEFT = 0xA0,  // VK_LSHIFT
//         SHIFT_RIGHT = 0xA1, // VK_RSHIFT
//         CTRL_LEFT = 0xA2,   // VK_LCONTROL
//         CTRL_RIGHT = 0xA3,  // VK_RCONTROL
//         ALT_LEFT = 0xA4,    // VK_LMENU
//         ALT_RIGHT = 0xA5,   // VK_RMENU

//         // Browser keys
//         BROWSER_BACK = 0xA6,      // VK_BROWSER_BACK
//         BROWSER_FORWARD = 0xA7,   // VK_BROWSER_FORWARD
//         BROWSER_REFRESH = 0xA8,   // VK_BROWSER_REFRESH
//         BROWSER_STOP = 0xA9,      // VK_BROWSER_STOP
//         BROWSER_SEARCH = 0xAA,    // VK_BROWSER_SEARCH
//         BROWSER_FAVORITES = 0xAB, // VK_BROWSER_FAVORITES
//         BROWSER_HOME = 0xAC,      // VK_BROWSER_HOME

//         // Media keys
//         VOLUME_MUTE = 0xAD, // VK_VOLUME_MUTE
//         VOLUME_DOWN = 0xAE, // VK_VOLUME_DOWN
//         VOLUME_UP = 0xAF,   // VK_VOLUME_UP
//         NEXT_TRACK = 0xB0,  // VK_MEDIA_NEXT_TRACK
//         PREV_TRACK = 0xB1,  // VK_MEDIA_PREV_TRACK
//         STOP = 0xB2,        // VK_MEDIA_STOP
//         PLAY_PAUSE = 0xB3,  // VK_MEDIA_PLAY_PAUSE

//         // Application keys
//         LAUNCH_MAIL = 0xB4,         // VK_LAUNCH_MAIL
//         LAUNCH_MEDIA_SELECT = 0xB5, // VK_LAUNCH_MEDIA_SELECT
//         LAUNCH_APP1 = 0xB6,         // VK_LAUNCH_APP1
//         LAUNCH_APP2 = 0xB7          // VK_LAUNCH_APP2
//     };