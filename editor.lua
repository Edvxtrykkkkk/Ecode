-- editor.lua
-- ECODE Editor Buffer Engine
-- Manages source buffers, line/column metrics, search engine, and tokenization[cite: 1]

local Editor = {}
Editor.__index = Editor

function Editor.new(config)
    local self = setmetatable({}, Editor)
    self.config = config or {}
    self.buffer = ""
    self.cursorPosition = 1
    self.searchQuery = ""
    self.searchResults = {}
    self.searchIndex = 0
    return self
end

function Editor:SetText(text)
    self.buffer = text or ""
    self.cursorPosition = math.clamp(self.cursorPosition, 1, #self.buffer + 1)
end

function Editor:GetText()
    return self.buffer
end

function Editor:InsertText(text)
    if not text or text == "" then return end
    local left = string.sub(self.buffer, 1, self.cursorPosition - 1)
    local right = string.sub(self.buffer, self.cursorPosition)
    self.buffer = left .. text .. right
    self.cursorPosition = self.cursorPosition + #text
end

function Editor:Clear()
    self.buffer = ""
    self.cursorPosition = 1
    self.searchResults = {}
    self.searchIndex = 0
end

function Editor:GetLineCount()
    local count = 1
    for _ in string.gmatch(self.buffer, "\n") do
        count = count + 1
    end
    return count
end

function Editor:GetLineColumn(pos)
    pos = math.clamp(pos, 1, #self.buffer + 1)
    local line = 1
    local col = 1
    for i = 1, pos - 1 do
        local char = string.sub(self.buffer, i, i)
        if char == "\n" then
            line = line + 1
            col = 1
        else
            col = col + 1
        end
    end
    return line, col
end

function Editor:Search(query)
    self.searchQuery = query or ""
    self.searchResults = {}
    self.searchIndex = 0
    if self.searchQuery == "" then return 0 end

    local startPos = 1
    while true do
        local s, e = string.find(self.buffer, self.searchQuery, startPos, true)
        if not s then break end
        table.insert(self.searchResults, {start = s, finish = e})
        startPos = e + 1
    end

    if #self.searchResults > 0 then
        self.searchIndex = 1
    end
    return #self.searchResults
end

function Editor:NextMatch()
    if #self.searchResults == 0 then return nil end
    self.searchIndex = self.searchIndex + 1
    if self.searchIndex > #self.searchResults then
        self.searchIndex = 1
    end
    return self.searchResults[self.searchIndex]
end

function Editor:PreviousMatch()
    if #self.searchResults == 0 then return nil end
    self.searchIndex = self.searchIndex - 1
    if self.searchIndex < 1 then
        self.searchIndex = #self.searchResults
    end
    return self.searchResults[self.searchIndex]
end

function Editor:Tokenize()
    return self.buffer
end

function Editor:Destroy()
    self.buffer = ""
    self.searchResults = {}
end

return Editor
