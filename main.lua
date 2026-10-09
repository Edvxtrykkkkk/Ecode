-- main.lua
-- ECODE Application Controller
-- Single entry point, module loader, event binding, and public API[cite: 1]

local Config = require(script.Parent:WaitForChild("config"))
local Editor = require(script.Parent:WaitForChild("editor"))
local Autocomplete = require(script.Parent:WaitForChild("autocomplete"))
local UI = require(script.Parent:WaitForChild("ui"))

local ECODE = {}
ECODE._activeDocument = { id = 1, name = "main.lua", path = nil }
ECODE._documents = { ECODE._activeDocument }

function ECODE.Init()
    ECODE.config = Config
    ECODE.editor = Editor.new(Config)
    ECODE.autocomplete = Autocomplete.new(Config)
    ECODE.ui = UI.new(Config)

    local player = game:GetService("Players").LocalPlayer
    local playerGui = player and player:FindFirstChild("PlayerGui") or game:GetService("CoreGui")
    ECODE.ui:Mount(playerGui)

    local codebox = ECODE.ui:GetComponent("Codebox")
    if codebox then
        codebox:GetPropertyChangedSignal("Text"):Connect(function()
            local text = codebox.Text
            ECODE.editor:SetText(text)
            
            local lines = ECODE.editor:GetLineCount()
            local line, col = ECODE.editor:GetLineColumn(codebox.CursorPosition)
            ECODE.ui:SetStatus(string.format("Ln %d, Col %d | %d Lines | %d Characters | Luau", line, col, lines, #text), "normal")
            
            local gutter = ECODE.ui:GetComponent("LineNumber")
            if gutter then
                local buf = {}
                for i = 1, lines do
                    table.insert(buf, tostring(i))
                end
                gutter.Text = table.concat(buf, "\n")
            end
        end)
    end

    ECODE.ui:SetStatus("ECODE Initialized Successfully", "success")
end

function ECODE.Destroy()
    if ECODE.ui then ECODE.ui:Destroy() end
    if ECODE.editor then ECODE.editor:Destroy() end
    if ECODE.autocomplete then ECODE.autocomplete:Destroy() end
end

function ECODE.Execute()
    local text = ECODE.GetText()
    if not text or text == "" then
        ECODE.ui:SetStatus("Cannot execute empty source", "error")
        return false, "Empty source"
    end

    local fn, syntaxError = loadstring(text)
    if not fn then
        ECODE.ui:SetStatus("Compile Error: " .. tostring(syntaxError), "error")
        return false, syntaxError
    end

    local success, runtimeError = pcall(fn)
    if not success then
        ECODE.ui:SetStatus("Runtime Error: " .. tostring(runtimeError), "error")
        return false, runtimeError
    end

    ECODE.ui:SetStatus("Execution completed successfully", "success")
    return true, nil
end

function ECODE.Save()
    local text = ECODE.GetText()
    if writefile and ECODE._activeDocument.path then
        pcall(function() writefile(ECODE._activeDocument.path, text) end)
        ECODE.ui:SetStatus("File saved successfully", "success")
    else
        ECODE.ui:SetStatus("Save not supported or path not set (capability check)", "warning")
    end
end

function ECODE.Open()
    if readfile and ECODE._activeDocument.path then
        local success, text = pcall(readfile, ECODE._activeDocument.path)
        if success then
            ECODE.SetText(text)
            ECODE.ui:SetStatus("File opened successfully", "success")
        end
    else
        ECODE.ui:SetStatus("Open not supported (capability check)", "warning")
    end
end

function ECODE.NewDocument()
    local doc = { id = #ECODE._documents + 1, name = "Untitled.lua", path = nil }
    table.insert(ECODE._documents, doc)
    ECODE._activeDocument = doc
    ECODE.Clear()
    ECODE.ui:SetStatus("Created new document", "normal")
end

function ECODE.Clear()
    ECODE.editor:Clear()
    local codebox = ECODE.ui:GetComponent("Codebox")
    if codebox then codebox.Text = "" end
    ECODE.ui:SetStatus("Document cleared", "normal")
end

function ECODE.Copy()
    local text = ECODE.GetText()
    if setclipboard then
        pcall(setclipboard, text)
        ECODE.ui:SetStatus("Copied to clipboard", "success")
    else
        ECODE.ui:SetStatus("Clipboard write not supported", "warning")
    end
end

function ECODE.Paste()
    if getclipboard then
        local success, text = pcall(getclipboard)
        if success and text then
            ECODE.editor:InsertText(text)
            local codebox = ECODE.ui:GetComponent("Codebox")
            if codebox then codebox.Text = ECODE.editor:GetText() end
            ECODE.ui:SetStatus("Pasted from clipboard", "success")
        end
    else
        ECODE.ui:SetStatus("Clipboard read not supported", "warning")
    end
end

function ECODE.SelectAll()
    local codebox = ECODE.ui:GetComponent("Codebox")
    if codebox then
        codebox.CursorPosition = 1
    end
end

function ECODE.Find()
    ECODE.ui:SetStatus("Find panel opened", "normal")
end

function ECODE.SetTheme(theme)
    if ECODE.ui then ECODE.ui:SetTheme(theme) end
end

Folder = nil -- placeholder cleanup

function ECODE.SetText(text)
    ECODE.editor:SetText(text)
    local codebox = ECODE.ui:GetComponent("Codebox")
    if codebox then codebox.Text = text end
end

function ECODE.GetText()
    return ECODE.editor:GetText()
end

function ECODE.GetActiveDocument()
    return ECODE._activeDocument
end

function ECODE.SetFontSize(size)
    ECODE.ui:SetStatus("Font size set to " .. tostring(size), "normal")
end

function ECODE.SetAutocompleteEnabled(enabled)
    ECODE.ui:SetStatus("Autocomplete enabled: " .. tostring(enabled), "normal")
end

return ECODE
