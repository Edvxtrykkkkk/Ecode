-- autocomplete.lua
-- ECODE Autocomplete Engine
-- Context-aware completion, keyword matching, and suggestion dropdown handling[cite: 1]

local Autocomplete = {}
Autocomplete.__index = Autocomplete

function Autocomplete.new(config)
    local self = setmetatable({}, Autocomplete)
    self.config = config or {}
    self.selectedIndex = 1
    self.activeSuggestions = {}
    return self
end

function Autocomplete:GetPrefix(text, cursorPosition)
    local sub = string.sub(text, 1, cursorPosition - 1)
    local prefix = string.match(sub, "[%w_]+$")
    return prefix or ""
end

function Autocomplete:GetContext(text, cursorPosition)
    local sub = string.sub(text, 1, cursorPosition - 1)
    if string.match(sub, "game%s*:%s*[^%w_]*$") then
        return "game"
    elseif string.match(sub, "[%w_]+%s*:%s*[^%w_]*$") then
        return "method"
    elseif string.match(sub, "%.%s*[^%w_]*$") then
        return "member"
    end
    return "global"
end

function Autocomplete:GetSuggestions(text, cursorPosition)
    local prefix = self:GetPrefix(text, cursorPosition)
    local context = self:GetContext(text, cursorPosition)
    local suggestions = {}

    local apiConfig = self.config.API or {}
    local keywords = self.config.Keywords or {}
    local builtins = self.config.Builtins or {}

    if context == "game" or context == "method" then
        for _, method in pairs(apiConfig.Methods or {}) do
            table.insert(suggestions, method)
        end
    else
        for _, item in ipairs(apiConfig.Global or {}) do
            table.insert(suggestions, item)
        end
        for _, kw in ipairs(keywords) do
            table.insert(suggestions, {name = kw, kind = "keyword", description = "Luau keyword", detail = "keyword"})
        end
        for _, b in ipairs(builtins) do
            table.insert(suggestions, {name = b, kind = "function", description = "Built-in function", detail = "function"})
        end
    end

    if prefix ~= "" then
        local filtered = {}
        local lowerPrefix = string.lower(prefix)
        for _, item in ipairs(suggestions) do
            if string.sub(string.lower(item.name), 1, #lowerPrefix) == lowerPrefix then
                table.insert(filtered, item)
            end
        end
        suggestions = filtered
    end

    self.activeSuggestions = suggestions
    self.selectedIndex = math.clamp(self.selectedIndex, 1, math.max(1, #suggestions))
    return suggestions
end

function Autocomplete:MoveSelection(direction)
    if #self.activeSuggestions == 0 then return end
    self.selectedIndex = self.selectedIndex + direction
    if self.selectedIndex > #self.activeSuggestions then
        self.selectedIndex = 1
    elseif self.selectedIndex < 1 then
        self.selectedIndex = #self.activeSuggestions
    end
end

function Autocomplete:GetSelectedSuggestion()
    return self.activeSuggestions[self.selectedIndex]
end

function Autocomplete:AcceptSuggestion(text, cursorPosition)
    local suggestion = self:GetSelectedSuggestion()
    if not suggestion then return text, cursorPosition end

    local prefix = self:GetPrefix(text, cursorPosition)
    local left = string.sub(text, 1, cursorPosition - 1 - #prefix)
    local right = string.sub(text, cursorPosition)

    local newText = left .. suggestion.name .. right
    local newPos = cursorPosition - #prefix + #suggestion.name
    return newText, newPos
end

function Autocomplete:Dismiss()
    self.activeSuggestions = {}
    self.selectedIndex = 1
end

function Autocomplete:Destroy()
    self:Dismiss()
end

return Autocomplete
