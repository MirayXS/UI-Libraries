--[[
    __      __          _      _             _    _ _____   _      _ _                          
    \ \    / /         (_)    (_)           | |  | |_   _| | |    (_) |                         
     \ \  / /   _ _ __  ___  ___ _   _ ___  | |  | | | |   | |     _| |__  _ __ __ _ _ __ _   _ 
      \ \/ / | | | '_ \| \ \/ / | | | / __| | |  | | | |   | |    | | '_ \| '__/ _` | '__| | | |
       \  /| |_| | | | | |>  <| | |_| \__ \ | |__| |_| |_  | |____| | |_) | | | (_| | |  | |_| |
        \/  \__, |_| |_|_/_/\_\_|\__,_|___/  \____/|_____| |______|_|_.__/|_|  \__,_|_|   \__, |
             __/ |                                                                         __/ |
            |___/                                                                         |___/ 

    Vynixius UI Library v1.0.0g

    UI - Vynixu
    Scripting - Vynixu

    [ What's new? ]

    [*] Added seasonal themes [toggleable setting]

]]--

-- Services

local Players = game:GetService("Players")
local TS = game:GetService("TweenService")
local RS = game:GetService("RunService")
local UIS = game:GetService("UserInputService")

-- Variables

local Player = Players.LocalPlayer
local Mouse = Player:GetMouse()

-- Utility

local Utility = {}

Utility.Colors = {
    Add = function(c1, c2)
        local r, g, b = c1.R + c2.R, c1.G + c2.G, c1.B + c2.B
        return Color3.fromRGB(math.min(r*255, 255), math.min(g*255, 255), math.min(b*255, 255))
    end,

    Sub = function(c1, c2)
        local r, g, b = c1.R - c2.R, c1.G - c2.G, c1.B - c2.B
        return Color3.fromRGB(math.max(r*255, 0), math.max(g*255, 0), math.max(b*255, 0))
    end,
}

function Utility:Drag(obj, drag)
    drag.InputBegan:Connect(function(input, processed)
        if not processed and input.UserInputType == Enum.UserInputType.MouseButton1 then
            local Start = Vector2.new(Mouse.X - obj.AbsolutePosition.X, Mouse.Y - obj.AbsolutePosition.Y)
            repeat task.wait()
                TS:Create(obj, TweenInfo.new(.05, Enum.EasingStyle.Linear), {
                    Position = UDim2.new(0, Mouse.X - Start.X, 0, Mouse.Y - Start.Y),
                }):Play()
            until not UIS:IsMouseButtonPressed(Enum.UserInputType.MouseButton1)
        end
    end)
end

function Utility:Create(class, properties, radius)
    local instance = Instance.new(class)

    for i, v in next, properties do
        if i ~= "Parent" then
            if typeof(v) == "Instance" then
                v.Parent = instance
            else
                instance[i] = v
            end
        end
    end

    if radius then
        local uicorner = Instance.new("UICorner", instance)
        uicorner.CornerRadius = radius
    end
    return instance
end

function Utility:GetDate()
    return os.date("*t")
end

-- Library

local Library = {
    Theme = {
        ThemeColor = Color3.fromRGB(0, 255, 0),
        TopbarColor = Color3.fromRGB(20, 20, 20),
        SidebarColor = Color3.fromRGB(15, 15, 15),
        BackgroundColor = Color3.fromRGB(10, 10, 10),
        SectionColor = Color3.fromRGB(20, 20, 20),
        TextColor = Color3.fromRGB(255, 255, 255),
    },
}

function Library:AddWindow(settings)
    assert(not Library.Window, "Library already has a window.")

    local Window = {
        Tabs = {},
        Sidebar = {
            Toggled = false,
            Buttons = {},
        },
        Toggled = settings.toggled or true,
        Key = settings.key or Enum.KeyCode.RightShift,
        Theme = {
            Objects = {},
        },
    }

    Library.Window = Window

    if settings.theme then
        for i, v in next, settings.theme do
            if Library.Theme[i] then
                Library.Theme[i] = v
            end
        end
    end

    Window.Gui = Utility:Create("ScreenGui", {
        Name = settings.title[1].. " ".. settings.title[2],
        ZIndexBehavior = Enum.ZIndexBehavior.Sibling,

        Utility:Create("Frame", {
            Name = "Window",
            BackgroundTransparency = 1,
            ClipsDescendants = true,
            Position = UDim2.new(1, -420, 1, -440),
            Size = UDim2.new(0, 400, 0, 420),

            Utility:Create("Frame", {
                Name = "Holder",
                BackgroundTransparency = 1,
                Size = UDim2.new(0, 400, 0, 420),

                -- Topbar
                Utility:Create("Frame", {
                    Name = "Topbar",
                    BackgroundColor3 = Library.Theme.TopbarColor,
                    Size = UDim2.new(1, 0, 0, 40),

                    Utility:Create("Frame", {
                        Name = "Filling",
                        BackgroundColor3 = Library.Theme.TopbarColor,
                        BorderSizePixel = 0,
                        Position = UDim2.new(0, 0, 0.5, 0),
                        Size = UDim2.new(1, 0, 0.5, 0),
                    }),

                    Utility:Create("Frame", {
                        Name = "Holder",
                        BackgroundTransparency = 1,
                        Position = UDim2.new(0, 5, 0.5, -10),
                        Size = UDim2.new(1, -10, 0, 20),
                        ZIndex = 2,

                        Utility:Create("TextLabel", {
                            Name = "Title1",
                            BackgroundTransparency = 1,
                            Size = UDim2.new(0.5, 0, 1, 0),
                            Font = Enum.Font.SourceSans,
                            Text = settings.title[1].. " -",
                            TextColor3 = Library.Theme.TextColor,
                            TextSize = 20,
                        }),

                        Utility:Create("TextLabel", {
                            Name = "Title2",
                            BackgroundTransparency = 1,
                            Size = UDim2.new(0.5, 0, 1, 0),
                            Font = Enum.Font.SourceSans,
                            Text = settings.title[2],
                            TextColor3 = Library.Theme.ThemeColor,
                            TextSize = 20,
                        }),
                    }),
                }, UDim.new(0, 5)),

                -- Sidebar
                Utility:Create("Frame", {
                    Name = "Sidebar",
                    Active = true,
                    BackgroundColor3 = Library.Theme.SidebarColor,
                    ClipsDescendants = true,
                    Position = UDim2.new(0, 0, 0, 40),
                    Size = UDim2.new(0, 35, 1, -40),
                    ZIndex = 2,

                    Utility:Create("Frame", {
                        Name = "H_Filling",
                        BackgroundColor3 = Library.Theme.SidebarColor,
                        BorderSizePixel = 0,
                        Size = UDim2.new(1, 0, 0, 5),
                    }),

                    Utility:Create("Frame", {
                        Name = "V_Filling",
                        BackgroundColor3 = Library.Theme.SidebarColor,
                        BorderSizePixel = 0,
                        Position = UDim2.new(1, -5, 0, 0),
                        Size = UDim2.new(0, 5, 1, 0),
                        ZIndex = 2,
                    }),

                    Utility:Create("Frame", {
                        Name = "Border",
                        BackgroundColor3 = Library.Theme.BackgroundColor,
                        BorderSizePixel = 0,
                        Position = UDim2.new(1, -5, 0, 0),
                        Size = UDim2.new(0, 5, 1, 0),
                        ZIndex = 2,
                    }),

                    Utility:Create("Frame", {
                        Name = "Line",
                        BackgroundColor3 = Utility.Colors.Add(Library.Theme.SidebarColor, Color3.fromRGB(5, 5, 5)),
                        BorderSizePixel = 0,
                        Position = UDim2.new(0, 5, 0, 29),
                        Size = UDim2.new(1, -15, 0, 2),
                    }),

                    Utility:Create("ScrollingFrame", {
                        Name = "List",
                        Active = true,
                        BackgroundTransparency = 1,
                        BorderSizePixel = 0,
                        Position = UDim2.new(0, 5, 0, 35),
                        Size = UDim2.new(0, 110, 1, -40),
                        CanvasSize = UDim2.new(0, 0, 0, 0),
                        ScrollingDirection = Enum.ScrollingDirection.Y,
                        ScrollBarImageColor3 = Utility.Colors.Add(Library.Theme.SidebarColor, Color3.fromRGB(10, 10, 10)),
                        ScrollBarThickness = 5,

                        Utility:Create("UIListLayout", {
                            SortOrder = Enum.SortOrder.LayoutOrder,
                            Padding = UDim.new(0, 5),
                        }),
                    }),

                    Utility:Create("TextButton", {
                        Name = "Indicator",
                        BackgroundTransparency = 1,
                        Position = UDim2.new(1, -35, 0, 0),
                        Size = UDim2.new(0, 30, 0, 30),
                        Font = Enum.Font.SourceSansBold,
                        Text = "+",
                        TextColor3 = Library.Theme.TextColor,
                        TextSize = 20,
                    })
                }, UDim.new(0, 5)),

                -- Background
                Utility:Create("Frame", {
                    Name = "Background",
                    BackgroundColor3 = Library.Theme.BackgroundColor,
                    Position = UDim2.new(0, 30, 0, 40),
                    Size = UDim2.new(1, -30, 1, -40),

                    Utility:Create("Frame", {
                        Name = "H_Filling",
                        BackgroundColor3 = Library.Theme.BackgroundColor,
                        BorderSizePixel = 0,
                        Size = UDim2.new(1, 0, 0, 5),
                    }),

                    Utility:Create("Frame", {
                        Name = "V_Filling",
                        BackgroundColor3 = Library.Theme.BackgroundColor,
                        BorderSizePixel = 0,
                        Size = UDim2.new(0, 5, 1, 0),
                    }),

                    Utility:Create("Frame", {
                        Name = "Tabs",
                        BackgroundColor3 = Utility.Colors.Add(Library.Theme.BackgroundColor, Color3.fromRGB(5, 5, 5)),
                        Position = UDim2.new(0, 5, 0, 5),
                        Size = UDim2.new(1, -10, 1, -10),
                    }, UDim.new(0, 5)),
                }, UDim.new(0, 5)),
            }),
        }),
    })

    if settings.seasonalThemes then
        Window.Gui.Window.Holder.Topbar.Theme = Utility:Create("ImageLabel", {
            Name = "Theme",
            BackgroundTransparency = 1,
            Size = UDim2.new(1, 0, 1, 0),
        })
        local themeAssets = {
            Halloween = "http://www.roblox.com/asset/?id=8213343470",
            Winter = "http://www.roblox.com/asset/?id=8213130815",
        }        
        local date = os.date("*t")
        if date.month == 10 and Data.day >= 21 then
            Window.Gui.Window.Holder.Topbar.Theme.Image = themeAssets.Winter
        elseif date.month == 12 and date.month >= 15 then
            Window.Gui.Window.Holder.Topbar.Theme.Image = themeAssets.Winter
        end
    end

    -- Variables

    local Gui = Window.Gui
    local WindowHolder = Gui.Window
    local Holder = WindowHolder.Holder
    local Topbar = Holder.Topbar
    local TitleHolder = Topbar.Holder
    local Sidebar = Holder.Sidebar
    local Background = Holder.Background
    local TabsHolder = Background.Tabs

    -- Functions

    local function GetTitleSize()
        local Sizes = {
            Title1 = TitleHolder.Title1.TextBounds.X,
            Title2 = TitleHolder.Title2.TextBounds.X,
        }
        Sizes.Holder = Sizes.Title1 + 3 + Sizes.Title2
        return Sizes
    end

    function Window:SetThemeColor(color)
        local function set(color)
            for i, v in next, Window.Theme.Objects do
                i[v] = color
            end

            for i, v in next, Window.Tabs do
                for i2, v2 in next, v.Sections do
                    for i3, v3 in next, v2.Items do
                        if v3.Type == "Toggle" and v.Toggles[v3.Flag] then
                            v3.Indicator.Indicator.BackgroundColor3 = Utility.Colors.Add(Library.Theme.ThemeColor, Color3.fromRGB(50, 50, 50))

                        elseif v3.Type == "Slider" then
                            v3.Slider.Bar.BackgroundColor3 = Utility.Colors.Sub(Library.Theme.ThemeColor, Color3.fromRGB(50, 50, 50))
                            v3.Slider.Point.BackgroundColor3 = Library.Theme.ThemeColor
                        end
                    end
                end
            end
        end
        
        Library.Theme.ThemeColor = color
        if typeof(color) == "string" then
            color = color:lower()
            if color == "rainbow" then
                Window.Theme.Rainbow = RS.Stepped:Connect(function()
                    set(Color3.fromHSV(tick() % 5 / 5, 1, 1))
                end)
            end

            return
        end

        if Window.Theme.Rainbow then
            Window.Theme.Rainbow:Disconnect()
        end
        set(color)
    end

    function Window:ChangeKey(input)
        assert(typeof(input) == Enum.KeyCode)
        Window.Key = input
    end

    function Window:SelectTab(tab)
        tab:Show()
    end

    function Window:Toggle(bool)
        Window.Toggled = bool

        TS:Create(WindowHolder, TweenInfo.new(.5, Enum.EasingStyle.Quint), {
            Size = UDim2.new(0, bool and 400 or GetTitleSize().Holder + 20, 0, bool and 420 or 40),
        }):Play()

        TS:Create(Topbar, TweenInfo.new(.5, Enum.EasingStyle.Quint), {
            Size = UDim2.new(0, bool and 400 or GetTitleSize().Holder + 20, 0, 40),
        }):Play()
    end

    function Window.Sidebar:Toggle(bool)
        Window.Sidebar.Toggled = bool

        TS:Create(Sidebar, TweenInfo.new(.5, Enum.EasingStyle.Quint), {
            Size = UDim2.new(0, bool and 125 or 35, 1, -40),
        }):Play()

        TS:Create(Sidebar.Indicator, TweenInfo.new(.5, Enum.EasingStyle.Quint), {
            Rotation = bool and 45 or 0,
        }):Play()

        for i, v in next, Window.Sidebar.Buttons do
            TS:Create(v.Button, TweenInfo.new(.5, Enum.EasingStyle.Quint), {
                TextTransparency = bool and 0 or 1,
            }):Play()

            if v.Icon then
                TS:Create(v.Icon, TweenInfo.new(.5, Enum.EasingStyle.Quint), {
                    ImageTransparency = bool and 0 or 1,
                }):Play()
            end
        end
    end

    function Window.Sidebar:GetHeight()
        local Height = 0
        for i, v in next, Window.Sidebar.Buttons do
            Height = Height + v.Button.AbsoluteSize.Y + 5
        end
        return Height - 5
    end

    function Window.Sidebar:UpdateHeight()
        Sidebar.List.CanvasSize = UDim2.new(0, 0, 0, Window.Sidebar:GetHeight())
    end

    -- Scripts

    Window.Gui.Parent = game.CoreGui
    Utility:Drag(WindowHolder, Topbar)

    TitleHolder.Title1.Size = UDim2.new(0, GetTitleSize().Title1, 1, 0)
    TitleHolder.Title2.Size = UDim2.new(0, GetTitleSize().Title2, 1, 0)
    TitleHolder.Title2.Position = UDim2.new(0, GetTitleSize().Title1 + 3, 0, 0)
    Window.Theme.Objects[TitleHolder.Title2] = "TextColor3"
    TitleHolder.Size = UDim2.new(0, GetTitleSize().Holder, 0, 14)
    TitleHolder.Position = UDim2.new(.5, -TitleHolder.AbsoluteSize.X/2, .5, -TitleHolder.AbsoluteSize.Y/2)

    Sidebar.Indicator.MouseButton1Down:Connect(function()
        Sidebar.Indicator.TextSize = 19
    end)

    Sidebar.Indicator.MouseButton1Up:Connect(function()
        Sidebar.Indicator.TextSize = 20
        Window.Sidebar:Toggle(not Window.Sidebar.Toggled)
    end)

    Sidebar.Indicator.MouseLeave:Connect(function()
        Sidebar.Indicator.TextSize = 20
    end)

    UIS.InputBegan:Connect(function(input, processed)
        if not processed and input.KeyCode == Window.Key then
            Window:Toggle(not Window.Toggled)
        end
    end)

    function Window:AddTab(name, settings)
        settings = settings or {}

        local Tab = {
            Name = name,
            Sections = {},
            Toggles = {},
            Button = {
                Name = name,
                Selected = false,
            },
        }

        Tab.Frame = Utility:Create("ScrollingFrame", {
            Name = name,
            Active = true,
            BackgroundTransparency = 1,
            BorderSizePixel = 0,
            Position = UDim2.new(0, 5, 0, 5),
            Size = UDim2.new(1, -10, 1, -10),
            CanvasSize = UDim2.new(0, 0, 0, 0),
            ScrollingDirection = Enum.ScrollingDirection.Y,
            ScrollBarImageColor3 = Utility.Colors.Add(Library.Theme.SectionColor, Color3.fromRGB(10, 10, 10)),
            ScrollBarThickness = 5,
            Visible = false,

            Utility:Create("UIListLayout", {
                SortOrder = Enum.SortOrder.LayoutOrder,
                Padding = UDim.new(0, 5),
            }),
        })

        Tab.Button.Holder = Utility:Create("Frame", {
            Name = name,
            BackgroundTransparency = 1,
            Size = UDim2.new(1, 0, 0, 30),
        })

        Tab.Button.Button = Utility:Create("TextButton", {
            Name = "Button",
            BackgroundTransparency = 1,
            Size = UDim2.new(1, 0, 0, 30),
            Font = Enum.Font.SourceSans,
            Text = name,
            TextColor3 = Utility.Colors.Sub(Library.Theme.TextColor, Color3.fromRGB(100, 100, 100)),
            TextTransparency = Window.Sidebar.Toggled and 0 or 1,
            TextSize = 14,
            TextWrapped = true,
        })

        -- Functions

        function Tab:Show()
            for i, v in next, Window.Tabs do
                local bool = (v.Frame == Tab.Frame)
                v.Frame.Visible = bool
                v.Button.Selected = bool
                v.Button.Button.TextSize = bool and 16 or 14
                Window.Sidebar:Toggle(false)

                TS:Create(v.Button.Button, TweenInfo.new(.25, Enum.EasingStyle.Quint), {
                    TextColor3 = bool and Library.Theme.TextColor or Utility.Colors.Sub(Library.Theme.TextColor, Color3.fromRGB(100, 100, 100)),
                }):Play()
            end
        end

        function Tab:Hide()
            Tab.Frame.Visible = false
            Tab.Button.Selected = false
        end

        function Tab:IsShown()
            return Tab.Frame.Visible
        end

        function Tab:GetHeight()
            local Height = 0
            for i, v in next, Tab.Sections do
                Height = Height + v:GetHeight() + 5
            end
            return Height - 5
        end

        function Tab:UpdateHeight()
            Tab.Frame.CanvasSize = UDim2.new(0, 0, 0, Tab:GetHeight())
        end

        -- Scripts

        table.insert(Window.Tabs, Tab)
        table.insert(Window.Sidebar.Buttons, Tab.Button)
        Tab.Frame.Parent = Background.Tabs
        Tab.Button.Holder.Parent = Sidebar.List
        Tab.Button.Button.Parent = Tab.Button.Holder
        Window.Sidebar:UpdateHeight()

        if settings.icon then
            Tab.Button.Icon = Utility:Create("ImageLabel", {
                Name = "Icon",
                BackgroundTransparency = 1,
                Size = UDim2.new(0, 30, 1, 0),
                Image = settings.icon,
                ImageTransparency = 1,
            })

            Tab.Button.Icon.Parent = Tab.Button.Holder
            Tab.Button.Button.Position = UDim2.new(0, 35, 0, 0)
            Tab.Button.Button.Size = UDim2.new(1, -35, 1, 0)
        end

        if settings.default then
            Tab:Show()
        end

        Tab.Frame.ChildAdded:Connect(function(child)
            if child:IsA("Frame") then
                Tab:UpdateHeight()
            end
        end)

        Tab.Button.Button.MouseEnter:Connect(function()
            if not Tab.Button.Selected then
                Tab.Button.Button.TextSize = 16
            end
        end)

        Tab.Button.Button.MouseLeave:Connect(function()
            if not Tab.Button.Selected then
                Tab.Button.Button.TextSize = 14
            end
        end)

        Tab.Button.Button.MouseButton1Up:Connect(function()
            if not Tab.Button.Selected and Window.Sidebar.Toggled then
                Tab:Show()
            end
        end)

        function Tab:AddSection(name, settings)
            settings = settings or {}
        
            local Section = {
                Name = name,
                Toggled = settings.default or false,
                Items = {},
            }

            Section.Frame = Utility:Create("Frame", {
                Name = name,
                BackgroundColor3 = Library.Theme.SectionColor,
                Size = UDim2.new(1, -10, 0, 40),

                Utility:Create("TextLabel", {
                    Name = "Indicator",
                    BackgroundTransparency = 1,
                    Position = UDim2.new(1, -30, 0, 0),
                    Size = UDim2.new(0, 30, 0, 30),
                    Font = Enum.Font.SourceSansBold,
                    Text = "+",
                    TextColor3 = Library.Theme.TextColor,
                    TextSize = 20,
                    TextWrapped = true,
                }),

                Utility:Create("TextLabel", {
                    Name = "Header",
                    BackgroundTransparency = 1,
                    Position = UDim2.new(0, 10, 0, 8),
                    Size = UDim2.new(1, -45, 0, 14),
                    Font = Enum.Font.SourceSans,
                    Text = name,
                    TextColor3 = Library.Theme.TextColor,
                    TextSize = 14,
                    TextWrapped = true,
                    TextXAlignment = Enum.TextXAlignment.Left,
                }),

                Utility:Create("Frame", {
                    Name = "Line",
                    BackgroundColor3 = Utility.Colors.Add(Library.Theme.SectionColor, Color3.fromRGB(5, 5, 5)),
                    BorderSizePixel = 0,
                    Position = UDim2.new(0, 5, 0, 30),
                    Size = UDim2.new(1, -10, 0, 2),
                }),
            }, UDim.new(0, 5))

            Section.List = Utility:Create("Frame", {
                Name = "List",
                BackgroundTransparency = 1,
                ClipsDescendants = true,
                Position = UDim2.new(0, 5, 0, 40),
                Size = UDim2.new(1, -10, 1, -40),

                Utility:Create("UIListLayout", {
                    SortOrder = Enum.SortOrder.LayoutOrder,
                    Padding = UDim.new(0, 5),
                }),
            })

            -- Functions

            function Section:Toggle(bool)
                Section.Toggled = bool

                TS:Create(Section.Frame, TweenInfo.new(.5, Enum.EasingStyle.Quint), {
                    Size = UDim2.new(1, -10, 0, bool and Section:GetHeight() or 40),
                }):Play()

                TS:Create(Section.Frame.Indicator, TweenInfo.new(.5, Enum.EasingStyle.Quint), {
                    Rotation = bool and 45 or 0,
                }):Play()

                local TabHeight = 0
                for i, v in next, Tab.Sections do
                    TabHeight = TabHeight + v:GetHeight() + 5
                end
                TabHeight = TabHeight - 5
                
                TS:Create(Tab.Frame, TweenInfo.new(.5, Enum.EasingStyle.Quint), {
                    CanvasSize = UDim2.new(0, 0, 0, TabHeight),
                }):Play()
            end

            function Section:GetHeight()
                local SpecialTypes, Height = {"Dropdown", "Colorpicker"}, 40
                if Section.Toggled and #Section.Items > 0 then
                    for i, v in next, Section.Items do
                        if table.find(SpecialTypes, v.Type) then
                            Height = Height + v:GetHeight() + 5
                        else
                            Height = Height + v.Holder.AbsoluteSize.Y + 5
                        end
                    end
                end
                return Height
            end

            function Section:UpdateHeight()
                Section.Frame.Size = UDim2.new(1, -10, 0, Section:GetHeight())

                TS:Create(Section.Frame.Indicator, TweenInfo.new(.5, Enum.EasingStyle.Quint), {
                    Rotation = #Section.Items > 0 and 45 or 0,
                }):Play()
            end

            -- Scripts

            table.insert(Tab.Sections, Section)
            Section.Frame.Parent = Tab.Frame
            Section.List.Parent = Section.Frame
            Section.Frame.Indicator.Rotation = Section.Toggled and 45 or 0

            Section.List.ChildAdded:Connect(function()
                if Section.Toggled then
                    Section:UpdateHeight()
                    Tab:UpdateHeight()
                end
            end)

            Section.Frame.InputBegan:Connect(function(input, processed)
                if not processed and input.UserInputType == Enum.UserInputType.MouseButton1 and #Section.Items > 0 and Mouse.Y - Section.Frame.AbsolutePosition.Y <= 30 then
                    Section:Toggle(not Section.Toggled)
                end
            end)

            -- Button

            function Section:AddButton(name, callback)
                local Button = {
                    Name = name,
                    Type = "Button",
                    Callback = callback,
                }

                Button.Holder = Utility:Create("Frame", {
                    Name = name,
                    BackgroundColor3 = Utility.Colors.Add(Library.Theme.SectionColor, Color3.fromRGB(5, 5, 5)),
                    Size = UDim2.new(1, 0, 0, 30),
                }, UDim.new(0, 5))

                Button.Button = Utility:Create("TextButton", {
                    Name = "Button",
                    AutoButtonColor = false,
                    BackgroundColor3 = Utility.Colors.Add(Library.Theme.SectionColor, Color3.fromRGB(10, 10, 10)),
                    Position = UDim2.new(0, 2, 0, 2),
                    Size = UDim2.new(1, -4, 1, -4),
                    Font = Enum.Font.SourceSans,
                    Text = name,
                    TextColor3 = Library.Theme.TextColor,
                    TextSize = 14,
                    TextWrapped = true,
                }, UDim.new(0, 5))

                -- Functions

                function Button:Highlight(bool)
                    TS:Create(Button.Button, TweenInfo.new(.25, Enum.EasingStyle.Quint), {
                        BackgroundColor3 = bool and Utility.Colors.Add(Library.Theme.SectionColor, Color3.fromRGB(15, 15, 15)) or Utility.Colors.Add(Library.Theme.SectionColor, Color3.fromRGB(10, 10, 10)),
                    }):Play()
                end

                function Button:Visual()
                    task.spawn(function()
                        local Visual = Utility:Create("Frame", {
                            Name = "Visual",
                            AnchorPoint = Vector2.new(.5, .5),
                            BackgroundColor3 = Color3.fromRGB(255, 255, 255),
                            BackgroundTransparency = .9,
                            Position = UDim2.new(.5, 0, .5, 0),
                            Size = UDim2.new(0, 0, 1, 0),
                        }, UDim.new(0, 5))

                        Visual.Parent = Button.Holder.Button
                        TS:Create(Visual, TweenInfo.new(.5), {
                            Size = UDim2.new(1, 0, 1, 0),
                            BackgroundTransparency = 1,
                        }):Play()
                        task.wait(.5)
                        Visual:Destroy()
                    end)
                end
                
                -- Scripts

                table.insert(Section.Items, Button)
                Button.Holder.Parent = Section.List
                Button.Button.Parent = Button.Holder

                Button.Button.MouseEnter:Connect(function()
                    Button:Highlight(true)
                end)

                Button.Button.MouseLeave:Connect(function()
                    Button.Button.TextSize = 14
                    Button:Highlight(false)
                end)

                Button.Button.MouseButton1Down:Connect(function()
                    Button.Button.TextSize = 13
                end)

                Button.Button.MouseButton1Up:Connect(function()
                    Button.Button.TextSize = 14
                    Button:Visual()
                    Button.Callback()
                end)

                return Button
            end

            -- Toggle

            function Section:AddToggle(name, settings, callback)
                assert(not Tab.Toggles[settings.flag or name], "Duplicate flag '".. (settings.flag or name).. "'")

                local Toggle = {
                    Name = name,
                    Type = "Toggle",
                    Flag = settings.flag or name,
                    Callback = callback,
                }

                Toggle.Holder = Utility:Create("Frame", {
                    Name = name,
                    BackgroundColor3 = Utility.Colors.Add(Library.Theme.SectionColor, Color3.fromRGB(5, 5, 5)),
                    Size = UDim2.new(1, 0, 0, 30),

                    Utility:Create("TextLabel", {
                        Name = "Label",
                        BackgroundTransparency = 1,
                        Position = UDim2.new(0, 5, 0.5, -7),
                        Size = UDim2.new(1, -50, 0, 14),
                        Font = Enum.Font.SourceSans,
                        Text = name,
                        TextColor3 = Library.Theme.TextColor,
                        TextSize = 14,
                        TextWrapped = true,
                        TextXAlignment = Enum.TextXAlignment.Left,
                    }),
                }, UDim.new(0, 5))

                Toggle.Indicator = Utility:Create("Frame", {
                    Name = "Holder",
                    BackgroundColor3 = Utility.Colors.Add(Library.Theme.SectionColor, Color3.fromRGB(10, 10, 10)),
                    Position = UDim2.new(1, -42, 0, 2),
                    Size = UDim2.new(0, 40, 0, 26),

                    Utility:Create("ImageLabel", {
                        Name = "Indicator",
                        BackgroundColor3 = Utility.Colors.Add(Library.Theme.SectionColor, Color3.fromRGB(15, 15, 15)),
                        Position = UDim2.new(0, 2, 0, 2),
                        Size = UDim2.new(0, 22, 0, 22),

                        Utility:Create("ImageLabel", {
                            Name = "Overlay",
                            AnchorPoint = Vector2.new(0.5, 0.5),
                            BackgroundTransparency = 1,
                            Position = UDim2.new(0.5, 0, 0.5, 0),
                            Size = UDim2.new(0, 0, 0, 0),
                            Image = "http://www.roblox.com/asset/?id=7827504335",
                        }),
                    }, UDim.new(0, 5)),
                }, UDim.new(0, 5))

                -- Functions

                function Toggle:Set(bool)
                    Tab.Toggles[Toggle.Flag] = bool

                    TS:Create(Toggle.Indicator.Indicator, TweenInfo.new(.25, Enum.EasingStyle.Quint), {
                        Position = bool and UDim2.new(1, -24, 0, 2) or UDim2.new(0, 2, 0, 2),
                        BackgroundColor3 = bool and Utility.Colors.Add(Library.Theme.ThemeColor, Color3.fromRGB(50, 50, 50)) or Utility.Colors.Add(Library.Theme.SectionColor, Color3.fromRGB(15, 15, 15)),
                    }):Play()

                    TS:Create(Toggle.Indicator.Indicator.Overlay, TweenInfo.new(.25, Enum.EasingStyle.Quint), {
                        Size = bool and UDim2.new(1, 0, 1, 0) or UDim2.new(0, 0, 0, 0),
                    }):Play()

                    Toggle.Callback(bool)
                end

                -- Scripts

                table.insert(Section.Items, Toggle)
                Toggle.Holder.Parent = Section.List
                Toggle.Indicator.Parent = Toggle.Holder
                Tab.Toggles[Toggle.Flag] = settings.default or false
                Toggle:Set(Tab.Toggles[Toggle.Flag])

                Toggle.Holder.InputBegan:Connect(function(input, processed)
                    if not processed and input.UserInputType == Enum.UserInputType.MouseButton1 then
                        Toggle:Set(not Tab.Toggles[Toggle.Flag])
                    end
                end)

                return Toggle
            end

            -- Label

            function Section:AddLabel(name, settings)
                settings = settings or {}
                
                local Label = {
                    Name = name,
                    Type = "Label",
                    Alignment = settings.alignment or Enum.TextXAlignment.Center,
                }

                Label.Holder = Utility:Create("Frame", {
                    Name = name,
                    BackgroundColor3 = Utility.Colors.Add(Library.Theme.SectionColor, Color3.fromRGB(5, 5, 5)),
                    Size = UDim2.new(1, 0, 0, 20)
                }, UDim.new(0, 5))

                Label.Label = Utility:Create("TextLabel", {
                    Name = "Label",
                    BackgroundTransparency = 1,
                    Position = UDim2.new(0, 5, 0.5, -7),
                    Size = UDim2.new(1, -10, 0, 14),
                    Font = Enum.Font.SourceSans,
                    Text = name,
                    TextColor3 = Library.Theme.TextColor,
                    TextSize = 14,
                    TextWrapped = true,
                    TextXAlignment = Label.Alignment,
                })
                
                -- Scripts
                
                table.insert(Section.Items, Label)
                Label.Holder.Parent = Section.List
                Label.Label.Parent = Label.Holder

                return Label
            end

            -- DualLabel

            function Section:AddDualLabel(name)
                local DualLabel = {
                    Names = {
                        Label1 = name[1],
                        Label2 = name[2],
                    },
                    Type = "DualLabel",
                }

                DualLabel.Holder = Utility:Create("Frame", {
                    Name = name[1].. " ".. name[2],
                    BackgroundColor3 = Utility.Colors.Add(Library.Theme.SectionColor, Color3.fromRGB(5, 5, 5)),
                    Size = UDim2.new(1, 0, 0, 20)
                }, UDim.new(0, 5))

                DualLabel.Label1 = Utility:Create("TextLabel", {
                    Name = "Label1",
                    BackgroundTransparency = 1,
                    Position = UDim2.new(0, 5, 0.5, -7),
                    Size = UDim2.new(0.5, -5, 0, 14),
                    Font = Enum.Font.SourceSans,
                    Text = name[1],
                    TextColor3 = Library.Theme.TextColor,
                    TextSize = 14,
                    TextWrapped = true,
                    TextXAlignment = Enum.TextXAlignment.Left,
                })

                DualLabel.Label2 = Utility:Create("TextLabel", {
                    Name = "Label2",
                    BackgroundTransparency = 1,
                    Position = UDim2.new(0.5, 0, 0.5, -7),
                    Size = UDim2.new(0.5, -5, 0, 14),
                    Font = Enum.Font.SourceSans,
                    Text = name[2],
                    TextColor3 = Library.Theme.TextColor,
                    TextSize = 14,
                    TextWrapped = true,
                    TextXAlignment = Enum.TextXAlignment.Right,
                })

                -- Scripts

                table.insert(Section.Items, DualLabel)
                DualLabel.Holder.Parent = Section.List
                DualLabel.Label1.Parent = DualLabel.Holder
                DualLabel.Label2.Parent = DualLabel.Holder

                return DualLabel
            end

            -- ClipboardLabel

            function Section:AddClipboardLabel(name, settings)
                settings = settings or {}
                
                local ClipboardLabel = {
                    Name = name,
                    Type = "ClipboardLabel",
                    Alignment = settings.alignment or Enum.TextXAlignment.Center,
                    Button = {
                        Mouse = false,
                    },
                }

                ClipboardLabel.Holder = Utility:Create("Frame", {
                    Name = name,
                    BackgroundColor3 = Utility.Colors.Add(Library.Theme.SectionColor, Color3.fromRGB(5, 5, 5)),
                    Size = UDim2.new(1, 0, 0, 20)
                }, UDim.new(0, 5))

                ClipboardLabel.Label = Utility:Create("TextLabel", {
                    Name = "Label",
                    BackgroundTransparency = 1,
                    Position = UDim2.new(0, 5, 0.5, -7),
                    Size = UDim2.new(1, -10, 0, 14),
                    Font = Enum.Font.SourceSans,
                    Text = name,
                    TextColor3 = Library.Theme.TextColor,
                    TextSize = 14,
                    TextWrapped = true,
                    TextXAlignment = ClipboardLabel.Alignment,
                })

                ClipboardLabel.Button.Button = Utility:Create("ImageButton", {
                    Name = "Copy",
                    AutoButtonColor = false,
                    BackgroundTransparency = 1,
                    Position = UDim2.new(1, -18, 0, 2),
                    Size = UDim2.new(0, 16, 0, 16),
                    Image = "http://www.roblox.com/asset/?id=7832104884",
                    ImageColor3 = Utility.Colors.Add(Library.Theme.SectionColor, Color3.fromRGB(25, 25, 25)),
                })

                -- Functions

                function ClipboardLabel:Highlight(bool)
                    TS:Create(ClipboardLabel.Button.Button, TweenInfo.new(.25, Enum.EasingStyle.Quint), {
                        ImageColor3 = bool and Utility.Colors.Add(Library.Theme.SectionColor, Color3.fromRGB(45, 45, 45)) or Utility.Colors.Add(Library.Theme.SectionColor, Color3.fromRGB(25, 25, 25)),
                    }):Play()
                end

                function ClipboardLabel:Visual()
                    TS:Create(ClipboardLabel.Button.Button, TweenInfo.new(.25, Enum.EasingStyle.Quint), {
                        ImageColor3 = Color3.fromRGB(255, 255, 255),
                    }):Play()
                    task.wait(.25)

                    TS:Create(ClipboardLabel.Button.Button, TweenInfo.new(.25, Enum.EasingStyle.Quint), {
                        ImageColor3 = ClipboardLabel.Button.Mouse and Utility.Colors.Add(Library.Theme.SectionColor, Color3.fromRGB(45, 45, 45)) or Utility.Colors.Add(Library.Theme.SectionColor, Color3.fromRGB(25, 25, 25)),
                    }):Play()
                end
                
                -- Scripts
                
                table.insert(Section.Items, ClipboardLabel)
                ClipboardLabel.Holder.Parent = Section.List
                ClipboardLabel.Label.Parent = ClipboardLabel.Holder
                ClipboardLabel.Button.Button.Parent = ClipboardLabel.Holder

                ClipboardLabel.Holder.MouseEnter:Connect(function()
                    ClipboardLabel.Button.Mouse = true
                    ClipboardLabel:Highlight(true)
                end)

                ClipboardLabel.Holder.MouseLeave:Connect(function()
                    ClipboardLabel.Button.Mouse = false
                    ClipboardLabel:Highlight(false)
                end)

                ClipboardLabel.Holder.InputBegan:Connect(function(input, processed)
                    if not processed and input.UserInputType == Enum.UserInputType.MouseButton1 then
                        if setclipboard then
                            ClipboardLabel:Visual()
                            setclipboard(ClipboardLabel.Label.Text)
                        else
                            -- Notify : missing required function 'setclipboard'
                        end
                    end
                end)

                return ClipboardLabel
            end

            -- Box

            function Section:AddBox(name, settings, callback)
                local Box = {
                    Name = name,
                    Type = "Box",
                    Callback = callback,
                }

                Box.Holder = Utility:Create("Frame", {
                    Name = name,
                    BackgroundColor3 = Utility.Colors.Add(Library.Theme.SectionColor, Color3.fromRGB(5, 5, 5)),
                    Size = UDim2.new(1, 0, 0, 30),

                    Utility:Create("TextLabel", {
                        Name = "Label",
                        BackgroundTransparency = 1,
                        Position = UDim2.new(0, 5, 0.5, -7),
                        Size = UDim2.new(1, -135, 0, 14),
                        Font = Enum.Font.SourceSans,
                        Text = name,
                        TextColor3 = Library.Theme.TextColor,
                        TextSize = 14,
                        TextWrapped = true,
                        TextXAlignment = Enum.TextXAlignment.Left,
                    }),

                    Utility:Create("Frame", {
                        Name = "Holder",
                        BackgroundColor3 = Utility.Colors.Add(Library.Theme.SectionColor, Color3.fromRGB(10, 10, 10)),
                        Position = UDim2.new(1, -125, 0.5, -10),
                        Size = UDim2.new(0, 120, 0, 20),

                        Utility:Create("TextLabel", {
                            Name = "Icon",
                            BackgroundTransparency = 1,
                            Position = UDim2.new(0, 3, 0, 3),
                            Size = UDim2.new(0, 14, 0, 14),
                            Font = Enum.Font.SourceSansBold,
                            Text = "T",
                            TextColor3 = Utility.Colors.Add(Library.Theme.SectionColor, Color3.fromRGB(30, 30, 30)),
                            TextSize = 18,
                            TextWrapped = true,
                        }),
                    }, UDim.new(0, 5)),
                }, UDim.new(0, 5))

                Box.Box = Utility:Create("TextBox", {
                    Name = "Box",
                    BackgroundTransparency = 1,
                    ClearTextOnFocus = settings.clearOnFocus or false,
                    Position = UDim2.new(0, 2, 0, 0),
                    Size = UDim2.new(1, -4, 1, 0),
                    Font = Enum.Font.SourceSans,
                    Text = "",
                    TextColor3 = Library.Theme.TextColor,
                    TextSize = 14,
                    TextWrapped = true,
                }, UDim.new(0, 5))

                -- Functions

                function Box:GetExpansionSize(bool)
                    local MaxSize = Box.Holder.AbsoluteSize.X - 15 - Box.Holder.Label.TextBounds.X
                    return math.min(bool and 200 or 120, MaxSize)
                end

                function Box:Focus(bool)
                    TS:Create(Box.Holder.Holder, TweenInfo.new(.5, Enum.EasingStyle.Quint), {
                        Size = UDim2.new(0, Box:GetExpansionSize(bool), 0, 20),
                        Position = UDim2.new(1, -Box:GetExpansionSize(bool) - 5, .5, -10),
                    }):Play()

                    TS:Create(Box.Holder.Holder.Icon, TweenInfo.new(.5, Enum.EasingStyle.Quint), {
                        TextColor3 = bool and Utility.Colors.Add(Library.Theme.SectionColor, Color3.fromRGB(50, 50, 50)) or Utility.Colors.Add(Library.Theme.SectionColor, Color3.fromRGB(30, 30, 30)),
                    }):Play()
                end

                -- Scripts

                table.insert(Section.Items, Box)
                Box.Holder.Parent = Section.List
                Box.Box.Parent = Box.Holder.Holder

                Box.Holder.MouseEnter:Connect(function()
                    Box:Focus(true)
                end)

                Box.Holder.MouseLeave:Connect(function()
                    if Box.Box:IsFocused() then
                        Box.Box.FocusLost:Wait()
                    end
                    Box:Focus(false)
                end)

                Box.Box.FocusLost:Connect(function()
                    if Box.Box.Text == "" and not settings.callbackIfEmpty then
                        return
                    end
                    Box.Callback(Box.Box.Text)
                end)

                return Box
            end

            -- NumBox

            function Section:AddNumBox(name, settings, callback)
                local NumBox = {
                    Name = name,
                    Type = "NumBox",
                    Callback = callback,
                }

                NumBox.Holder = Utility:Create("Frame", {
                    Name = name,
                    BackgroundColor3 = Utility.Colors.Add(Library.Theme.SectionColor, Color3.fromRGB(5, 5, 5)),
                    Size = UDim2.new(1, 0, 0, 30),

                    Utility:Create("TextLabel", {
                        Name = "Label",
                        BackgroundTransparency = 1,
                        Position = UDim2.new(0, 5, 0.5, -7),
                        Size = UDim2.new(1, -135, 0, 14),
                        Font = Enum.Font.SourceSans,
                        Text = name,
                        TextColor3 = Library.Theme.TextColor,
                        TextSize = 14,
                        TextWrapped = true,
                        TextXAlignment = Enum.TextXAlignment.Left,
                    }),

                    Utility:Create("Frame", {
                        Name = "Holder",
                        BackgroundColor3 = Utility.Colors.Add(Library.Theme.SectionColor, Color3.fromRGB(10, 10, 10)),
                        Position = UDim2.new(1, -125, 0.5, -10),
                        Size = UDim2.new(0, 120, 0, 20),

                        Utility:Create("ImageLabel", {
                            Name = "Icon",
                            BackgroundTransparency = 1,
                            Position = UDim2.new(0, 3, 0, 3),
                            Size = UDim2.new(0, 14, 0, 14),
                            Image = "http://www.roblox.com/asset/?id=7865555617",
                            ImageColor3 = Utility.Colors.Add(Library.Theme.SectionColor, Color3.fromRGB(30, 30, 30)),
                        }),
                    }, UDim.new(0, 5)),
                }, UDim.new(0, 5))

                NumBox.Box = Utility:Create("TextBox", {
                    Name = "Box",
                    BackgroundTransparency = 1,
                    ClearTextOnFocus = settings.clearOnFocus or false,
                    Position = UDim2.new(0, 20, 0, 0),
                    Size = UDim2.new(1, -22, 1, 0),
                    Font = Enum.Font.SourceSans,
                    Text = "",
                    TextColor3 = Library.Theme.TextColor,
                    TextSize = 14,
                    TextWrapped = true,
                }, UDim.new(0, 5))

                -- Functions

                function NumBox:GetExpansionSize(bool)
                    local MaxSize = NumBox.Holder.AbsoluteSize.X - 15 - NumBox.Holder.Label.TextBounds.X
                    return math.min(bool and 200 or 120, MaxSize)
                end

                function NumBox:Focus(bool)
                    TS:Create(NumBox.Holder.Holder, TweenInfo.new(.5, Enum.EasingStyle.Quint), {
                        Size = UDim2.new(0, NumBox:GetExpansionSize(bool), 0, 20),
                        Position = UDim2.new(1, -NumBox:GetExpansionSize(bool) - 5, .5, -10),
                    }):Play()

                    TS:Create(NumBox.Holder.Holder.Icon, TweenInfo.new(.5, Enum.EasingStyle.Quint), {
                        ImageColor3 = bool and Utility.Colors.Add(Library.Theme.SectionColor, Color3.fromRGB(50, 50, 50)) or Utility.Colors.Add(Library.Theme.SectionColor, Color3.fromRGB(30, 30, 30)),
                    }):Play()
                end

                -- Scripts

                table.insert(Section.Items, NumBox)
                NumBox.Holder.Parent = Section.List
                NumBox.Box.Parent = NumBox.Holder.Holder

                NumBox.Holder.MouseEnter:Connect(function()
                    NumBox:Focus(true)
                end)

                NumBox.Holder.MouseLeave:Connect(function()
                    if NumBox.Box:IsFocused() then
                        NumBox.Box.FocusLost:Wait()
                    end
                    NumBox:Focus(false)
                end)

                NumBox.Box.FocusLost:Connect(function()
                    if NumBox.Box.Text == "" and not settings.callbackIfEmpty then
                        return
                    elseif tonumber(NumBox.Box.Text) then
                        NumBox.Callback(tonumber(NumBox.Box.Text))
                    end
                end)

                return NumBox
            end
            
            -- PlayerBox

            function Section:AddPlayerBox(name, settings, callback)
                local PlayerBox = {
                    Name = name,
                    Type = "PlayerBox",
                    Callback = callback,
                }

                PlayerBox.Holder = Utility:Create("Frame", {
                    Name = name,
                    BackgroundColor3 = Utility.Colors.Add(Library.Theme.SectionColor, Color3.fromRGB(5, 5, 5)),
                    Size = UDim2.new(1, 0, 0, 30),

                    Utility:Create("TextLabel", {
                        Name = "Label",
                        BackgroundTransparency = 1,
                        Position = UDim2.new(0, 5, 0.5, -7),
                        Size = UDim2.new(1, -135, 0, 14),
                        Font = Enum.Font.SourceSans,
                        Text = name,
                        TextColor3 = Library.Theme.TextColor,
                        TextSize = 14,
                        TextWrapped = true,
                        TextXAlignment = Enum.TextXAlignment.Left,
                    }),

                    Utility:Create("Frame", {
                        Name = "Holder",
                        BackgroundColor3 = Utility.Colors.Add(Library.Theme.SectionColor, Color3.fromRGB(10, 10, 10)),
                        Position = UDim2.new(1, -125, 0.5, -10),
                        Size = UDim2.new(0, 120, 0, 20),

                        Utility:Create("ImageLabel", {
                            Name = "Icon",
                            BackgroundTransparency = 1,
                            Position = UDim2.new(0, 3, 0, 3),
                            Size = UDim2.new(0, 14, 0, 14),
                            Image = "http://www.roblox.com/asset/?id=7860874011",
                            ImageColor3 = Utility.Colors.Add(Library.Theme.SectionColor, Color3.fromRGB(30, 30, 30)),
                        }),
                    }, UDim.new(0, 5)),
                }, UDim.new(0, 5))

                PlayerBox.Box = Utility:Create("TextBox", {
                    Name = "Box",
                    BackgroundTransparency = 1,
                    Position = UDim2.new(0, 20, 0, 0),
                    Size = UDim2.new(1, -22, 1, 0),
                    Font = Enum.Font.SourceSans,
                    Text = "",
                    TextColor3 = Library.Theme.TextColor,
                    TextSize = 14,
                    TextWrapped = true,
                }, UDim.new(0, 5))

                -- Functions

                function PlayerBox:GetExpansionSize(bool)
                    local MaxSize = PlayerBox.Holder.AbsoluteSize.X - 15 - PlayerBox.Holder.Label.TextBounds.X
                    return math.min(bool and 200 or 120, MaxSize)
                end

                function PlayerBox:Focus(bool)
                    TS:Create(PlayerBox.Holder.Holder, TweenInfo.new(.5, Enum.EasingStyle.Quint), {
                        Size = UDim2.new(0, PlayerBox:GetExpansionSize(bool), 0, 20),
                        Position = UDim2.new(1, -PlayerBox:GetExpansionSize(bool) - 5, .5, -10),
                    }):Play()

                    TS:Create(PlayerBox.Holder.Holder.Icon, TweenInfo.new(.5, Enum.EasingStyle.Quint), {
                        ImageColor3 = bool and Utility.Colors.Add(Library.Theme.SectionColor, Color3.fromRGB(50, 50, 50)) or Utility.Colors.Add(Library.Theme.SectionColor, Color3.fromRGB(30, 30, 30)),
                    }):Play()
                end

                function PlayerBox:GetPlayer()
                    for i, v in next, Players:GetPlayers() do
                        if v.Name:lower():find(PlayerBox.Box.Text:lower()) then
                            if v == Player and settings.excludeLocal then
                                return
                            end
                            return v
                        end
                    end
                end

                -- Scripts

                table.insert(Section.Items, PlayerBox)
                PlayerBox.Holder.Parent = Section.List
                PlayerBox.Box.Parent = PlayerBox.Holder.Holder

                PlayerBox.Holder.MouseEnter:Connect(function()
                    PlayerBox:Focus(true)
                end)

                PlayerBox.Holder.MouseLeave:Connect(function()
                    if PlayerBox.Box:IsFocused() then
                        PlayerBox.Box.FocusLost:Wait()
                    end
                    PlayerBox:Focus(false)
                end)

                PlayerBox.Box.FocusLost:Connect(function()
                    if PlayerBox.Box.Text == "" and not settings.callbackIfEmpty then
                        return
                        
                    elseif PlayerBox:GetPlayer() then
                        PlayerBox.Box.Text = PlayerBox:GetPlayer().Name
                        PlayerBox.Callback(PlayerBox:GetPlayer())
                    end
                end)

                return PlayerBox
            end

            -- Bind

            function Section:AddBind(name, bind, settings, callback)
                local Bind = {
                    Name = name,
                    Type = "Bind",
                    Bind = bind,
                    Callback = callback,
                }

                Bind.Holder = Utility:Create("Frame", {
                    Name = name,
                    BackgroundColor3 = Utility.Colors.Add(Library.Theme.SectionColor, Color3.fromRGB(5, 5, 5)),
                    Size = UDim2.new(1, 0, 0, 30),

                    Utility:Create("TextLabel", {
                        Name = "Label",
                        BackgroundTransparency = 1,
                        Position = UDim2.new(0, 5, 0.5, -7),
                        Size = UDim2.new(0, 247, 0, 14),
                        Font = Enum.Font.SourceSans,
                        Text = name,
                        TextColor3 = Library.Theme.TextColor,
                        TextSize = 14,
                        TextWrapped = true,
                        TextXAlignment = Enum.TextXAlignment.Left,
                    }),

                    Utility:Create("Frame", {
                        Name = "Holder",
                        BackgroundColor3 = Utility.Colors.Add(Library.Theme.SectionColor, Color3.fromRGB(10, 10, 10)),
                        Position = UDim2.new(1, -96, 0.5, -10),
                        Size = UDim2.new(0, 91, 0, 20),

                        Utility:Create("ImageLabel", {
                            Name = "Icon",
                            BackgroundTransparency = 1,
                            Position = UDim2.new(0, 6, 0, 6),
                            Size = UDim2.new(0, 14, 0, 14),
                            Image = "http://www.roblox.com/asset/?id=7867015035",
                            ImageColor3 = Utility.Colors.Add(Library.Theme.SectionColor, Color3.fromRGB(30, 30, 30)),
                        }),
                    }, UDim.new(0, 5)),
                }, UDim.new(0, 5))

                Bind.Box = Utility:Create("TextBox", {
                    Name = "Box",
                    BackgroundTransparency = 1,
                    ClearTextOnFocus = false,
                    Position = UDim2.new(0, 26, 0, 0),
                    Size = UDim2.new(1, -31, 1, 0),
                    Font = Enum.Font.SourceSans,
                    Text = bind.Name,
                    TextColor3 = Library.Theme.TextColor,
                    TextEditable = false,
                    TextSize = 14,
                })

                -- Functions

                local function UpdateBox(text)
                    Bind.Box.Text = text

                    Bind.Holder.Holder.Size = UDim2.new(0, math.max(Bind.Box.TextBounds.X + 5 + (not settings.bindable and 0 or 26), 26), 0, 20)
                    Bind.Holder.Holder.Position = UDim2.new(1, -Bind.Holder.Holder.AbsoluteSize.X - 5, .5, -10)
                    Bind.Holder.Label.Size = UDim2.new(0, 340 - 12 - Bind.Holder.Holder.AbsoluteSize.X, 0, 14)
                end

                function Bind:Highlight(bool)
                    TS:Create(Bind.Holder.Holder.Icon, TweenInfo.new(.5, Enum.EasingStyle.Quint), {
                        TextColor3 = bool and Utility.Colors.Add(Library.Theme.SectionColor, Color3.fromRGB(50, 50, 50)) or Utility.Colors.Add(Library.Theme.SectionColor, Color3.fromRGB(30, 30, 30)),
                    }):Play()
                end

                function Bind:BindInput()
                    UpdateBox("...")
                    
                    local Connection
                    Connection = UIS.InputBegan:Connect(function(input, processed)
                        if not processed and not tostring(input.UserInputType):find("Mouse") then
                            Connection:Disconnect()
                            Bind:Set(input.KeyCode)
                        end
                    end)
                end

                function Bind:Set(bind)
                    Bind.Bind = bind
                    UpdateBox(bind.Name)
                end

                -- Scripts

                table.insert(Section.Items, Bind)
                Bind.Holder.Parent = Section.List
                Bind.Box.Parent = Bind.Holder.Holder
                Bind:Set(Bind.Bind)

                if not settings.bindable then
                    Bind.Holder.Holder.Icon:Destroy()
                    Bind.Box.Size = UDim2.new(1, -4, 1, -4)
                    Bind.Box.Position = UDim2.new(0, 2, 0, 2)
                    UpdateBox(Bind.Box.Text)
                end

                UIS.InputBegan:Connect(function(input, processed)
                    if not processed and input.KeyCode == Bind.Bind then
                        Bind.Callback()
                    end
                end)

                Bind.Holder.InputBegan:Connect(function(input, processed)
                    if settings.bindable ~= false and not processed and input.UserInputType == Enum.UserInputType.MouseButton1 then
                        Bind:BindInput()
                    end
                end)

                return Bind
            end

            -- Slider

            function Section:AddSlider(name, settings, callback)
                local Slider = {
                    Name = name,
                    Type = "Slider",
                    Min = settings.min,
                    Max = settings.max,
                    Value = settings.default or settings.min,
                    Callback = callback,
                    Slider = {},
                }

                Slider.Holder = Utility:Create("Frame", {
                    Name = name,
                    BackgroundColor3 = Utility.Colors.Add(Library.Theme.SectionColor, Color3.fromRGB(5, 5, 5)),
                    Size = UDim2.new(1, 0, 0, 40),

                    Utility:Create("TextLabel", {
                        Name = "Label",
                        BackgroundTransparency = 1,
                        Position = UDim2.new(0, 5, 0, 5),
                        Size = UDim2.new(1, -75, 0, 14),
                        Font = Enum.Font.SourceSans,
                        Text = name,
                        TextColor3 = Library.Theme.TextColor,
                        TextSize = 14,
                        TextWrapped = true,
                        TextXAlignment = Enum.TextXAlignment.Left,
                    }),

                    Utility:Create("TextBox", {
                        Name = "Value",
                        BackgroundTransparency = 1,
                        Position = UDim2.new(1, -65, 0, 5),
                        Size = UDim2.new(0, 60, 0, 14),
                        Font = Enum.Font.SourceSans,
                        Text = "",
                        TextColor3 = Library.Theme.TextColor,
                        TextSize = 14,
                        TextWrapped = true,
                        TextXAlignment = Enum.TextXAlignment.Right,
                    }),
                }, UDim.new(0, 5))

                Slider.Slider.Holder = Utility:Create("Frame", {
                    Name = "Holder",
                    BackgroundTransparency = 1,
                    Position = UDim2.new(0, 5, 0, 24),
                    Size = UDim2.new(1, -10, 0, 10),
                }, UDim.new(0, 5))

                Slider.Slider.Background = Utility:Create("Frame", {
                    Name = "Background",
                    BackgroundColor3 = Utility.Colors.Add(Library.Theme.SectionColor, Color3.fromRGB(10, 10, 10)),
                    ClipsDescendants = true,
                    Size = UDim2.new(1, 0, 1, 0),
                }, UDim.new(0, 5))

                Slider.Slider.Bar = Utility:Create("Frame", {
                    Name = "Bar",
                    BackgroundColor3 = Utility.Colors.Sub(Library.Theme.ThemeColor, Color3.fromRGB(50, 50, 50)),
                    Size = UDim2.new(0.5, 0, 1, 0),
                }, UDim.new(0, 5))

                Slider.Slider.Point = Utility:Create("Frame", {
                    Name = "Point",
                    AnchorPoint = Vector2.new(0.5, 0.5),
                    BackgroundColor3 = Library.Theme.ThemeColor,
                    Position = UDim2.new(0.5, 0, 0.5, 0),
                    Size = UDim2.new(0, 12, 0, 12),
                }, UDim.new(0, 5))

                -- Functions

                function Slider:GetValidValue(val)
                    val = math.min(val, Slider.Max)
                    val = math.max(val, -Slider.Min)

                    if settings.rounded then
                        val = math.floor(val + .5)
                    end

                    return val
                end

                function Slider:Set(val, forced)
                    val = Slider:GetValidValue(val)

                    if val ~= Slider.Value or forced then
                        Slider.Value = val
                        Slider.Holder.Value.Text = tostring(val)

                        local Percent = 1 - ((Slider.Max - val) / (Slider.Max - Slider.Min))
                        TS:Create(Slider.Slider.Bar, TweenInfo.new(.25, Enum.EasingStyle.Quint), {
                            Position = UDim2.new(0, 0, 0, 0),
                            Size = UDim2.new(Percent, 0, 1, 0),
                        }):Play()
                        
                        local pointPadding = 1 / Slider.Slider.Holder.AbsoluteSize.X * 5
                        TS:Create(Slider.Slider.Point, TweenInfo.new(.25, Enum.EasingStyle.Quint), {
                            Position = UDim2.new(math.clamp(Percent, pointPadding, 1 - pointPadding), 0, .5, 0),
                        }):Play()

                        Slider.Callback(val)
                    end
                end

                function Slider:SetMin(val)
                    Slider.Min = math.max(val, Slider.Max)
                    Slider:Set(Slider.Value, true)
                end

                function Slider:SetMax(val)
                    Slider.Min = math.min(val, Slider.Min)
                    Slider:Set(Slider.Value, true)
                end

                -- Scripts

                table.insert(Section.Items, Slider)
                Slider.Holder.Parent = Section.List
                Slider.Slider.Holder.Parent = Slider.Holder
                Slider.Slider.Background.Parent = Slider.Slider.Holder
                Slider.Slider.Bar.Parent = Slider.Slider.Background
                Slider.Slider.Point.Parent = Slider.Slider.Holder
                Slider:Set(Slider.Value, true)

                Slider.Slider.Holder.InputBegan:Connect(function(input, processed)
                    if not processed and input.UserInputType == Enum.UserInputType.MouseButton1 then
                        repeat wait()
                            local Percent = math.clamp((Mouse.X - Slider.Slider.Holder.AbsolutePosition.X) / Slider.Slider.Holder.AbsoluteSize.X, 0, 1)
                            Slider:Set(math.floor((Slider.Min + (Percent * (Slider.Max - Slider.Min))) * 10) / 10)
                        until not UIS:IsMouseButtonPressed(Enum.UserInputType.MouseButton1)
                    end
                end)

                Slider.Holder.Value.FocusLost:Connect(function()
                    if Slider.Holder.Value.Text == "" then
                        Slider:Set(Slider.Value, true)
                    elseif tonumber(Slider.Holder.Value.Text) then
                        Slider:Set(tonumber(Slider.Holder.Value.Text), true)
                    end
                end)

                return Slider
            end

            -- Dropdown

            function Section:AddDropdown(name, items, callback)
                local Dropdown = {
                    Name = name,
                    Type = "Dropdown",
                    Items = {},
                    Toggled = false,
                    Callback = callback,
                }

                Dropdown.Holder = Utility:Create("Frame", {
                    Name = name,
                    BackgroundColor3 = Utility.Colors.Add(Library.Theme.SectionColor, Color3.fromRGB(5, 5, 5)),
                    ClipsDescendants = true,
                    Size = UDim2.new(1, 0, 0, 40),

                    Utility:Create("Frame", {
                        Name = "Holder",
                        BackgroundTransparency = 1,
                        Size = UDim2.new(1, 0, 0, 40),

                        Utility:Create("Frame", {
                            Name = "Line",
                            BackgroundColor3 = Utility.Colors.Add(Library.Theme.SectionColor, Color3.fromRGB(10, 10, 10)),
                            BorderSizePixel = 0,
                            Position = UDim2.new(0, 5, 0, 30),
                            Size = UDim2.new(1, -10, 0, 2),
                        }),

                        Utility:Create("TextLabel", {
                            Name = "Label",
                            BackgroundTransparency = 1,
                            Position = UDim2.new(0, 5, 0, 8),
                            Size = UDim2.new(1, -40, 0, 14),
                            Font = Enum.Font.SourceSans,
                            Text = name,
                            TextColor3 = Library.Theme.TextColor,
                            TextSize = 14,
                            TextWrapped = true,
                            TextXAlignment = Enum.TextXAlignment.Left,
                        }),

                        Utility:Create("TextLabel", {
                            Name = "Selected",
                            BackgroundTransparency = 1,
                            Position = UDim2.new(0.5, -10, 0, 8),
                            Size = UDim2.new(0.5, -20, 0, 14),
                            Font = Enum.Font.SourceSans,
                            Text = "",
                            TextColor3 = Library.Theme.TextColor,
                            TextSize = 14,
                            TextWrapped = true,
                            TextXAlignment = Enum.TextXAlignment.Right,
                        }),

                        Utility:Create("TextLabel", {
                            Name = "Indicator",
                            BackgroundTransparency = 1,
                            Position = UDim2.new(1, -30, 0, 0),
                            Size = UDim2.new(0, 30, 0, 30),
                            Font = Enum.Font.SourceSansBold,
                            Text = "+",
                            TextColor3 = Library.Theme.TextColor,
                            TextSize = 20,
                            TextWrapped = true,
                        }),
                    }),
                }, UDim.new(0, 5))

                Dropdown.List = Utility:Create("ScrollingFrame", {
                    Name = "List",
                    Active = true,
                    BackgroundTransparency = 1,
                    BorderSizePixel = 0,
                    Position = UDim2.new(0, 0, 0, 40),
                    Size = UDim2.new(1, 0, 1, -40),
                    CanvasSize = UDim2.new(0, 0, 0, 0),
                    ClipsDescendants = true,
                    ScrollingDirection = Enum.ScrollingDirection.Y,
                    ScrollBarImageColor3 = Utility.Colors.Add(Library.Theme.SectionColor, Color3.fromRGB(15, 15, 15)),
                    ScrollBarThickness = 5,

                    Utility:Create("UIListLayout", {
                        SortOrder = Enum.SortOrder.LayoutOrder,
                        Padding = UDim.new(0, 5),
                    }),

                    Utility:Create("UIPadding", {
                        PaddingLeft = UDim.new(0, 5),
                        PaddingRight = UDim.new(0, 5),
                    }),
                })

                -- Variables

                local MaxVisibleItems = 10

                -- Functions

                function Dropdown:GetHeight()
                    local Height = 40
                    if Dropdown.Toggled and #Dropdown.Items > 0 then   
                        for i = 1, math.min(#Dropdown.Items, MaxVisibleItems) do
                            Height = Height + Dropdown.Items[i].Button.AbsoluteSize.Y + 5
                        end
                    end
                    return Height
                end

                function Dropdown:UpdateHeight()
                    local MaxHeight = 40 + 10 * 25
                    Dropdown.Holder.Size = UDim2.new(1, 0, 0, math.min(Dropdown:GetHeight(), MaxVisibleItems))
                    Dropdown:UpdateList()
                    Section:UpdateHeight()
                    Tab:UpdateHeight()
                    
                    TS:Create(Dropdown.Holder.Holder.Indicator, TweenInfo.new(.5, Enum.EasingStyle.Quint), {
                        Rotation = #Dropdown.Items > 0 and 45 or 0,
                    }):Play()
                end

                function Dropdown:UpdateList()
                    Dropdown.List.CanvasSize = UDim2.new(1, 0, 0, #Dropdown.Items * 25)
                end

                function Dropdown:Toggle(bool)
                    Dropdown.Toggled = bool

                    TS:Create(Dropdown.Holder, TweenInfo.new(.5, Enum.EasingStyle.Quint), {
                        Size = UDim2.new(1, 0, 0, bool and Dropdown:GetHeight() or 40),
                    }):Play()

                    TS:Create(Dropdown.Holder.Holder.Indicator, TweenInfo.new(.5, Enum.EasingStyle.Quint), {
                        Rotation = bool and 45 or 0,
                    }):Play()

                    TS:Create(Section.Frame, TweenInfo.new(.5, Enum.EasingStyle.Quint), {
                        Size = UDim2.new(1, -10, 0, Section:GetHeight()),
                    }):Play()

                    TS:Create(Tab.Frame, TweenInfo.new(.5, Enum.EasingStyle.Quint), {
                        CanvasSize = UDim2.new(1, -10, 0, Tab:GetHeight()),
                    }):Play()
                end

                function Dropdown:Select(item)
                    Dropdown.Selected = item
                    Dropdown.Holder.Holder.Selected.Text = item.Name
                    
                    if Dropdown.Toggled then
                        Dropdown:Toggle(false)
                    end

                    if item.Callback then
                        item.Callback()
                    else
                        Dropdown.Callback(item)
                    end
                end

                function Dropdown:Add(name, callback)
                    local Item = {
                        Name = name,
                        Callback = callback,
                    }

                    Item.Button = Utility:Create("TextButton", {
                        Name = "Item",
                        BackgroundTransparency = 1,
                        Size = UDim2.new(1, 0, 0, 20),
                        Font = Enum.Font.SourceSans,
                        Text = name,
                        TextColor3 = Library.Theme.TextColor,
                        TextSize = 14,
                        TextWrapped = true,
                    })

                    -- Scripts

                    Item.Button.MouseEnter:Connect(function()
                        Item.Button.TextSize = 15
                    end)

                    Item.Button.MouseLeave:Connect(function()
                        Item.Button.TextSize = 14
                    end)

                    Item.Button.MouseButton1Click:Connect(function()
                        if Dropdown.Toggled then
                            Dropdown:Select(Item)
                        end
                    end)

                    table.insert(Dropdown.Items, Item)
                    Item.Button.Parent = Dropdown.List
                    Dropdown:UpdateList()
                end

                function Dropdown:Remove(name)
                    for i, v in next, Dropdown.Items do
                        if v.Name == name then
                            v.Button:Destroy()
                            table.remove(Dropdown.Items, i)
                            Dropdown:UpdateHeight()
                            break
                        end
                    end
                end

                function Dropdown:GetItems()
                    return Dropdown.Items
                end

                -- Scripts

                table.insert(Section.Items, Dropdown)
                Dropdown.Holder.Parent = Section.List
                Dropdown.List.Parent = Dropdown.Holder

                for i, v in next, items do
                    Dropdown:Add(v)
                end

                Dropdown.Holder.InputBegan:Connect(function(input, processed)
                    if not processed and input.UserInputType == Enum.UserInputType.MouseButton1 and #Dropdown.Items > 0 and Mouse.Y - Dropdown.Holder.AbsolutePosition.Y <= 30 then
                        Dropdown:Toggle(not Dropdown.Toggled)
                    end
                end)

                return Dropdown
            end

            -- Colorpicker

            return Section
        end

        return Tab
    end

    return Window
end

return Library
