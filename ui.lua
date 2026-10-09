-- ui.lua
-- ECODE UI Module Contract
-- Builds visual elements, window layout, toolbar, tabs, editor workspace, search & output panels[cite: 1]

local UI = {}
UI.__index = UI

function UI.new(config)
    local self = setmetatable({}, UI)
    self.config = config or {}
    self.theme = self.config.Theme or {}
    self.connections = {}
    self.components = {}
    return self
end

function UI:Mount(parent)
    local theme = self.theme

    local screenGui = Instance.new("ScreenGui")
    screenGui.Name = "ECODE_GUI"
    screenGui.ResetOnSpawn = false
    screenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    screenGui.Parent = parent

    local mainFrame = Instance.new("Frame")
    mainFrame.Name = "MainFrame"
    mainFrame.Size = UDim2.new(0, self.config.Window.DefaultWidth or 850, 0, self.config.Window.DefaultHeight or 550)
    mainFrame.Position = UDim2.new(0.5, -425, 0.5, -275)
    mainFrame.BackgroundColor3 = theme.Background
    mainFrame.BorderSizePixel = 0
    mainFrame.Parent = screenGui

    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, self.config.Sizes.CornerRadius or 6)
    corner.Parent = mainFrame

    local stroke = Instance.new("UIStroke")
    stroke.Color = theme.Border
    stroke.Thickness = 1
    stroke.Parent = mainFrame

    -- Header
    local header = Instance.new("Frame")
    header.Name = "Header"
    header.Size = UDim2.new(1, 0, 0, self.config.Sizes.TitleBarHeight or 36)
    header.BackgroundColor3 = theme.Surface
    header.BorderSizePixel = 0
    header.Parent = mainFrame

    local headerCorner = Instance.new("UICorner")
    headerCorner.CornerRadius = UDim.new(0, self.config.Sizes.CornerRadius or 6)
    headerCorner.Parent = header

    local titleLabel = Instance.new("TextLabel")
    titleLabel.Name = "TitleLabel"
    titleLabel.Size = UDim2.new(0, 200, 1, 0)
    titleLabel.Position = UDim2.new(0, 12, 0, 0)
    titleLabel.BackgroundTransparency = 1
    titleLabel.Font = self.config.Fonts.UI or Enum.Font.GothamBold
    titleLabel.Text = (self.config.Name or "ECODE") .. " v" .. (self.config.Version or "1.0.0")
    titleLabel.TextColor3 = theme.TextPrimary
    titleLabel.TextSize = 14
    titleLabel.TextXAlignment = Enum.TextXAlignment.Left
    titleLabel.Parent = header

    -- Toolbar
    local toolbar = Instance.new("Frame")
    toolbar.Name = "Toolbar"
    toolbar.Size = UDim2.new(1, 0, 0, self.config.Sizes.ToolbarHeight or 40)
    toolbar.Position = UDim2.new(0, 0, 0, self.config.Sizes.TitleBarHeight or 36)
    toolbar.BackgroundColor3 = theme.SurfaceSecondary
    toolbar.BorderSizePixel = 0
    toolbar.Parent = mainFrame

    local toolbarLayout = Instance.new("UIListLayout")
    toolbarLayout.FillDirection = Enum.FillDirection.Horizontal
    toolbarLayout.HorizontalAlignment = Enum.HorizontalAlignment.Left
    toolbarLayout.VerticalAlignment = Enum.VerticalAlignment.Center
    toolbarLayout.SortOrder = Enum.SortOrder.LayoutOrder
    toolbarLayout.Padding = UDim.new(0, 4)
    toolbarLayout.Parent = toolbar

    -- Tab Bar
    local tabBar = Instance.new("Frame")
    tabBar.Name = "TabBar"
    tabBar.Size = UDim2.new(1, 0, 0, self.config.Sizes.TabBarHeight or 32)
    tabBar.Position = UDim2.new(0, 0, 0, (self.config.Sizes.TitleBarHeight or 36) + (self.config.Sizes.ToolbarHeight or 40))
    tabBar.BackgroundColor3 = theme.Surface
    tabBar.BorderSizePixel = 0
    tabBar.Parent = mainFrame

    -- Editor Workspace
    local workspace = Instance.new("Frame")
    workspace.Name = "EditorWorkspace"
    workspace.Size = UDim2.new(1, 0, 1, -((self.config.Sizes.TitleBarHeight or 36) + (self.config.Sizes.ToolbarHeight or 40) + (self.config.Sizes.TabBarHeight or 32) + (self.config.Sizes.StatusBarHeight or 24)))
    workspace.Position = UDim2.new(0, 0, 0, (self.config.Sizes.TitleBarHeight or 36) + (self.config.Sizes.ToolbarHeight or 40) + (self.config.Sizes.TabBarHeight or 32))
    workspace.BackgroundColor3 = theme.Background
    workspace.BorderSizePixel = 0
    workspace.Parent = mainFrame

    -- Line Number Gutter
    local gutter = Instance.new("TextLabel")
    gutter.Name = "LineNumber"
    gutter.Size = UDim2.new(0, self.config.Sizes.GutterWidth or 48, 1, 0)
    gutter.BackgroundColor3 = theme.Surface
    gutter.BorderSizePixel = 0
    gutter.Font = self.config.Fonts.Code or Enum.Font.Code
    gutter.Text = "1"
    gutter.TextColor3 = theme.TextMuted
    gutter.TextSize = self.config.Sizes.FontSize or 14
    gutter.TextYAlignment = Enum.TextYAlignment.Top
    gutter.Parent = workspace

    -- Codebox TextBox
    local codebox = Instance.new("TextBox")
    codebox.Name = "Codebox"
    codebox.Size = UDim2.new(1, -(self.config.Sizes.GutterWidth or 48), 1, 0)
    codebox.Position = UDim2.new(0, self.config.Sizes.GutterWidth or 48, 0, 0)
    codebox.BackgroundTransparency = 1
    codebox.ClearTextOnFocus = false
    codebox.MultiLine = true
    codebox.Font = self.config.Fonts.Code or Enum.Font.Code
    codebox.Text = ""
    codebox.TextColor3 = theme.TextPrimary
    codebox.TextSize = self.config.Sizes.FontSize or 14
    codebox.TextXAlignment = Enum.TextXAlignment.Left
    codebox.TextYAlignment = Enum.TextYAlignment.Top
    codebox.Parent = workspace

    -- Status Bar
    local statusBar = Instance.new("Frame")
    statusBar.Name = "StatusBar"
    statusBar.Size = UDim2.new(1, 0, 0, self.config.Sizes.StatusBarHeight or 24)
    statusBar.Position = UDim2.new(1, 0, 1, -(self.config.Sizes.StatusBarHeight or 24))
    statusBar.AnchorPoint = Vector2.new(1, 1)
    statusBar.BackgroundColor3 = theme.Surface
    statusBar.BorderSizePixel = 0
    statusBar.Parent = mainFrame

    local statusLabel = Instance.new("TextLabel")
    statusLabel.Name = "StatusLabel"
    statusLabel.Size = UDim2.new(1, -12, 1, 0)
    statusLabel.Position = UDim2.new(0, 6, 0, 0)
    statusLabel.BackgroundTransparency = 1
    statusLabel.Font = self.config.Fonts.UI or Enum.Font.Gotham
    statusLabel.Text = "Ln 1, Col 1 | 1 Lines | 0 Characters | Luau"
    statusLabel.TextColor3 = theme.TextSecondary
    statusLabel.TextSize = 12
    statusLabel.TextXAlignment = Enum.TextXAlignment.Left
    statusLabel.Parent = statusBar

    self.components.ScreenGui = screenGui
    self.components.MainFrame = mainFrame
    self.components.Codebox = codebox
    self.components.LineNumber = gutter
    self.components.StatusLabel = statusLabel
end

function UI:GetComponent(name)
    return self.components[name]
end

function UI:SetStatus(message, kind)
    local label = self.components.StatusLabel
    if label then
        label.Text = message
        if kind == "error" then
            label.TextColor3 = self.theme.Error or Color3.fromRGB(231, 76, 60)
        elseif kind == "success" then
            label.TextColor3 = self.theme.Success or Color3.fromRGB(46, 204, 113)
        else
            label.TextColor3 = self.theme.TextSecondary or Color3.fromRGB(180, 180, 200)
        end
    end
end

function UI:SetTheme(theme)
    self.theme = theme or {}
end

function UI:SetWindowSize(width, height)
    local frame = self.components.MainFrame
    if frame then
        frame.Size = UDim2.new(0, width, 0, height)
    end
end

function UI:Destroy()
    for _, conn in ipairs(self.connections) do
        if conn.Disconnect then
            conn:Disconnect()
        end
    end
    self.connections = {}
    if self.components.ScreenGui then
        self.components.ScreenGui:Destroy()
    end
end

return UI
