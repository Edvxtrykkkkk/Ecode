-- config.lua
-- ECODE Modern Modular Roblox Luau Code Editor & Autocomplete System
-- Centralized Design Tokens, Theme, Configuration, and API Databases[cite: 1]

local Config = {
    Name = "ECODE",
    Version = "1.0.0",

    Theme = {
        Background = Color3.fromRGB(18, 18, 24),
        Surface = Color3.fromRGB(26, 26, 35),
        SurfaceSecondary = Color3.fromRGB(34, 34, 46),
        SurfaceElevated = Color3.fromRGB(45, 45, 60),
        Border = Color3.fromRGB(60, 60, 80),
        TextPrimary = Color3.fromRGB(240, 240, 255),
        TextSecondary = Color3.fromRGB(180, 180, 200),
        TextMuted = Color3.fromRGB(110, 110, 135),
        Accent = Color3.fromRGB(0, 122, 255),
        AccentHover = Color3.fromRGB(50, 150, 255),
        Success = Color3.fromRGB(46, 204, 113),
        Warning = Color3.fromRGB(241, 196, 15),
        Error = Color3.fromRGB(231, 76, 60),
        Keyword = Color3.fromRGB(249, 38, 114),
        String = Color3.fromRGB(230, 219, 116),
        Number = Color3.fromRGB(174, 129, 255),
        Comment = Color3.fromRGB(117, 113, 94),
        Operator = Color3.fromRGB(249, 38, 114),
        Function = Color3.fromRGB(102, 217, 239),
        Property = Color3.fromRGB(166, 226, 46),
    },

    Fonts = {
        UI = Enum.Font.Gotham,
        Code = Enum.Font.Code,
    },

    Sizes = {
        TitleBarHeight = 36,
        ToolbarHeight = 40,
        TabBarHeight = 32,
        StatusBarHeight = 24,
        FontSize = 14,
        LineHeight = 20,
        GutterWidth = 48,
        ScrollbarSize = 12,
        CornerRadius = 6,
    },

    Spacing = {
        Padding = 8,
        ElementGap = 6,
    },

    Window = {
        DefaultWidth = 850,
        DefaultHeight = 550,
        MinWidth = 500,
        MinHeight = 350,
    },

    Editor = {
        TabSize = 4,
        AutoIndent = true,
        WordWrap = false,
    },

    Search = {
        CaseSensitive = false,
    },

    Autocomplete = {
        Enabled = true,
        MaxSuggestions = 10,
    },

    Scrollbar = {
        MinHandleSize = 20,
    },

    Output = {
        MaxLines = 200,
    },

    Icons = {
        Logo = "rbxassetid://6031075931",
        New = "rbxassetid://6034818372",
        Open = "rbxassetid://6034818379",
        Save = "rbxassetid://6034818391",
        Copy = "rbxassetid://6034818360",
        Paste = "rbxassetid://6034818366",
        Clear = "rbxassetid://6034818353",
        SelectAll = "rbxassetid://6034818376",
        Undo = "rbxassetid://6034818396",
        Redo = "rbxassetid://6034818385",
        Find = "rbxassetid://6034818362",
        Previous = "rbxassetid://6034818374",
        Next = "rbxassetid://6034818370",
        Execute = "rbxassetid://6034818357",
        Settings = "rbxassetid://6034818388",
        Minimize = "rbxassetid://6034818368",
        Maximize = "rbxassetid://6034818364",
        Close = "rbxassetid://6034818355",
        ScrollUp = "rbxassetid://6034818392",
        ScrollDown = "rbxassetid://6034818356",
        ScrollLeft = "rbxassetid://6034818361",
        ScrollRight = "rbxassetid://6034818378",
        ScrollbarHandle = "",
    },

    Keywords = {
        "and", "break", "continue", "do", "else", "elseif", "end",
        "export", "false", "for", "function", "if", "in", "local", "nil",
        "not", "or", "repeat", "return", "then", "true", "type", "until", "while"
    },

    Builtins = {
        "assert", "collectgarbage", "error", "getmetatable", "ipairs", "loadstring",
        "next", "pairs", "pcall", "print", "rawequal", "rawget", "rawlen", "rawset",
        "select", "setmetatable", "tonumber", "tostring", "type", "typeof", "unpack", "warn", "xpcall"
    },

    API = {
        Global = {
            {name = "game", kind = "variable", description = "The root DataModel of the game.", detail = "DataModel"},
            {name = "workspace", kind = "variable", description = "The physical world container.", detail = "Workspace"},
            {name = "script", kind = "variable", description = "The currently executing script object.", detail = "Instance"},
            {name = "Enum", kind = "class", description = "Container for all enums.", detail = "Enum"},
            {name = "Instance", kind = "class", description = "Base class for all Roblox objects.", detail = "Instance"},
            {name = "Vector2", kind = "class", description = "2D vector representation.", detail = "Vector2"},
            {name = "Vector3", kind = "class", description = "3D vector representation.", detail = "Vector3"},
            {name = "CFrame", kind = "class", description = "Coordinate frame for 3D positioning.", detail = "CFrame"},
            {name = "Color3", kind = "class", description = "RGB color representation.", detail = "Color3"},
            {name = "UDim2", kind = "class", description = "2D UI dimension representation.", detail = "UDim2"},
            {name = "task", kind = "library", description = "Roblox task scheduler library.", detail = "table"},
            {name = "math", kind = "library", description = "Standard math library.", detail = "table"},
            {name = "string", kind = "library", description = "Standard string manipulation library.", detail = "table"},
            {name = "table", kind = "library", description = "Standard table manipulation library.", detail = "table"}
        },
        Methods = {
            ["GetService"] = {name = "GetService", kind = "method", description = "Returns a service by name.", detail = "function game:GetService(className)"},
            ["FindFirstChild"] = {name = "FindFirstChild", kind = "method", description = "Finds child by name.", detail = "function Instance:FindFirstChild(name)"},
            ["WaitForChild"] = {name = "WaitForChild", kind = "method", description = "Waits for child by name.", detail = "function Instance:WaitForChild(name)"},
            ["GetChildren"] = {name = "GetChildren", kind = "method", description = "Returns array of children.", detail = "function Instance:GetChildren()"},
            ["IsA"] = {name = "IsA", kind = "method", description = "Checks class inheritance.", detail = "function Instance:IsA(className)"},
            ["Destroy"] = {name = "Destroy", kind = "method", description = "Destroys the instance.", detail = "function Instance:Destroy()"}
        }
    }
}

return Config
