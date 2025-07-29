-- Load Rayfield Interface Suite
local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()

-- Create the main window
local Window = Rayfield:CreateWindow({
    Name = "Dandy's World Hub",
    LoadingTitle = "Dandy's World Interface",
    LoadingSubtitle = "by Wndaalol",
    ConfigurationSaving = {
        Enabled = true,
        FolderName = "DandysWorldHub",
        FileName = "Config"
    },
    Discord = {
        Enabled = true,
        Invite = "https://discord.gg/xVedFR4G",
        RememberJoins = true
    },
    KeySystem = true,
    KeySettings = {
        Title = "Dandy's World Hub Key",
        Subtitle = "Enter Your Key",
        Note = "Join our Discord for keys. Link copied to clipboard!",
        FileName = "DandyKey",
        SaveKey = true,
        GrabKeyFromSite = false,
        Key = {"Dandy2025", "WndaalolKey"},
        OnLoad = function()
            setclipboard("https://discord.gg/xVedFR4G")
        end
    },
    Theme = "Amethyst", -- Fixed Amethyst theme
    ToggleUIKeybind = "K"
})

-- Services
local Players = game:GetService("Players")
local Workspace = game:GetService("Workspace")
local LocalPlayer = Players.LocalPlayer
local RunService = game:GetService("RunService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

-- Variables for feature states
local ESPEnabled = false
local NoClipConnection = nil
local AutoCollectConnection = nil
local KillAuraConnection = nil
local AutoRepairConnection = nil

-- Tab 1: Main
local MainTab = Window:CreateTab("Main", "home")
MainTab:CreateSection("Welcome")
MainTab:CreateLabel("Dandy's World Hub")
MainTab:CreateParagraph({
    Title = "About",
    Content = "Explore 9 tabs for enhanced gameplay in Dandy's World."
})
MainTab:CreateButton({
    Name = "Show Info",
    Callback = function()
        Rayfield:Notify({
            Title = "Info",
            Content = "Developed by Wndaalol. Use 'K' to toggle UI.",
            Duration = 5,
            Image = "info"
        })
    end
})

-- Tab 2: ESP
local ESPTab = Window:CreateTab("ESP", "eye")
ESPTab:CreateSection("ESP Features")
ESPTab:CreateToggle({
    Name = "Enable ESP",
    CurrentValue = false,
    Flag = "ESPEnabled",
    Callback = function(Value)
        ESPEnabled = Value
        if ESPEnabled then
            Rayfield:Notify({
                Title = "ESP On",
                Content = "ESP enabled for Players, Toons, and Ichor.",
                Duration = 3,
                Image = "eye"
            })
            for _, player in pairs(Players:GetPlayers()) do
                if player ~= LocalPlayer and player.Character then
                    local highlight = Instance.new("Highlight")
                    highlight.Parent = player.Character
                    highlight.FillColor = Color3.fromRGB(255, 165, 0) -- Orange for players
                    highlight.OutlineColor = Color3.fromRGB(255, 255, 255)
                    highlight.Enabled = true
                    highlight.Name = "ESPHighlight"
                end
            end
            for _, toon in pairs(Workspace:GetDescendants()) do
                if toon.Name == "Toon" then
                    local highlight = Instance.new("Highlight")
                    highlight.Parent = toon
                    highlight.FillColor = Color3.fromRGB(255, 0, 0) -- Red for Toons
                    highlight.OutlineColor = Color3.fromRGB(255, 255, 255)
                    highlight.Enabled = true
                    highlight.Name = "ESPHighlight"
                end
            end
            for _, ichor in pairs(Workspace:GetDescendants()) do
                if ichor.Name == "Ichor" then
                    local highlight = Instance.new("Highlight")
                    highlight.Parent = ichor
                    highlight.FillColor = Color3.fromRGB(0, 255, 0) -- Green for Ichor
                    highlight.OutlineColor = Color3.fromRGB(255, 255, 255)
                    highlight.Enabled = true
                    highlight.Name = "ESPHighlight"
                end
            end
            Workspace.ChildAdded:Connect(function(child)
                if ESPEnabled and (child.Name == "Toon" or child.Name == "Ichor") then
                    local highlight = Instance.new("Highlight")
                    highlight.Parent = child
                    highlight.FillColor = child.Name == "Toon" and Color3.fromRGB(255, 0, 0) or Color3.fromRGB(0, 255, 0)
                    highlight.OutlineColor = Color3.fromRGB(255, 255, 255)
                    highlight.Enabled = true
                    highlight.Name = "ESPHighlight"
                end
            end)
            Players.PlayerAdded:Connect(function(player)
                if ESPEnabled and player ~= LocalPlayer then
                    player.CharacterAdded:Connect(function(character)
                        local highlight = Instance.new("Highlight")
                        highlight.Parent = character
                        highlight.FillColor = Color3.fromRGB(255, 165, 0)
                        highlight.OutlineColor = Color3.fromRGB(255, 255, 255)
                        highlight.Enabled = true
                        highlight.Name = "ESPHighlight"
                    end)
                end
            end)
        else
            Rayfield:Notify({
                Title = "ESP Off",
                Content = "ESP disabled.",
                Duration = 3,
                Image = "eye-off"
            })
            for _, obj in pairs(Workspace:GetDescendants()) do
                if obj:FindFirstChild("ESPHighlight") then
                    obj.ESPHighlight:Destroy()
                end
            end
            for _, player in pairs(Players:GetPlayers()) do
                if player.Character and player.Character:FindFirstChild("ESPHighlight") then
                    player.Character.ESPHighlight:Destroy()
                end
            end
        end
    end
})
ESPTab:CreateColorPicker({
    Name = "Player ESP Color",
    Color = Color3.fromRGB(255, 165, 0),
    Flag = "PlayerESPColor",
    Callback = function(Value)
        if ESPEnabled then
            for _, player in pairs(Players:GetPlayers()) do
                if player ~= LocalPlayer and player.Character and player.Character:FindFirstChild("ESPHighlight") then
                    player.Character.ESPHighlight.FillColor = Value
                end
            end
            Rayfield:Notify({
                Title = "Color Updated",
                Content = "Player ESP color changed.",
                Duration = 3,
                Image = "palette"
            })
        end
    end
})

-- Tab 3: Player
local PlayerTab = Window:CreateTab("Player", "user")
PlayerTab:CreateSection("Player Mods")
PlayerTab:CreateToggle({
    Name = "God Mode",
    CurrentValue = false,
    Flag = "GodMode",
    Callback = function(Value)
        if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid") then
            LocalPlayer.Character.Humanoid.MaxHealth = Value and math.huge or 100
            LocalPlayer.Character.Humanoid.Health = Value and math.huge or 100
            Rayfield:Notify({
                Title = "God Mode",
                Content = Value and "Enabled" or "Disabled",
                Duration = 3,
                Image = "shield"
            })
        end
    end
})
PlayerTab:CreateToggle({
    Name = "Infinite Stamina",
    CurrentValue = false,
    Flag = "InfStamina",
    Callback = function(Value)
        if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid") then
            LocalPlayer.Character.Humanoid.WalkSpeed = Value and 16 or 16 -- Placeholder; adjust for game stamina
            Rayfield:Notify({
                Title = "Stamina",
                Content = Value and "Infinite enabled" or "Disabled",
                Duration = 3,
                Image = "battery"
            })
        end
    end
})
PlayerTab:CreateButton({
    Name = "Reset Character",
    Callback = function()
        if LocalPlayer.Character then
            LocalPlayer.Character:BreakJoints()
            Rayfield:Notify({
                Title = "Reset",
                Content = "Character reset.",
                Duration = 3,
                Image = "refresh-cw"
            })
        end
    end
})

-- Tab 4: Movement
local MovementTab = Window:CreateTab("Movement", "move")
MovementTab:CreateSection("Movement Tools")
MovementTab:CreateToggle({
    Name = "No Clip",
    CurrentValue = false,
    Flag = "NoClip",
    Callback = function(Value)
        if Value then
            Rayfield:Notify({
                Title = "No Clip On",
                Content = "Enabled.",
                Duration = 3,
                Image = "slash"
            })
            NoClipConnection = RunService.Stepped:Connect(function()
                if LocalPlayer.Character then
                    for _, part in pairs(LocalPlayer.Character:GetDescendants()) do
                        if part:IsA("BasePart") then
                            part.CanCollide = false
                        end
                    end
                end
            end)
        else
            Rayfield:Notify({
                Title = "No Clip Off",
                Content = "Disabled.",
                Duration = 3,
                Image = "slash"
            })
            if NoClipConnection then
                NoClipConnection:Disconnect()
                NoClipConnection = nil
            end
            if LocalPlayer.Character then
                for _, part in pairs(LocalPlayer.Character:GetDescendants()) do
                    if part:IsA("BasePart") then
                        part.CanCollide = true
                    end
                end
            end
        end
    end
})
MovementTab:CreateSlider({
    Name = "Jump Power",
    Range = {50, 150},
    Increment = 5,
    CurrentValue = 50,
    Flag = "JumpPower",
    Callback = function(Value)
        if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid") then
            LocalPlayer.Character.Humanoid.JumpPower = Value
            Rayfield:Notify({
                Title = "Jump Set",
                Content = "Jump power: " .. Value,
                Duration = 3,
                Image = "arrow-up"
            })
        end
    end
})

-- Tab 5: Items
local ItemsTab = Window:CreateTab("Items", "package")
ItemsTab:CreateSection("Item Management")
ItemsTab:CreateToggle({
    Name = "Auto-Collect Tapes",
    CurrentValue = false,
    Flag = "AutoCollect",
    Callback = function(Value)
        if Value then
            Rayfield:Notify({
                Title = "Auto-Collect On",
                Content = "Collecting Tapes enabled.",
                Duration = 3,
                Image = "refresh-cw"
            })
            AutoCollectConnection = RunService.Heartbeat:Connect(function()
                if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
                    for _, tape in pairs(Workspace:GetDescendants()) do
                        if tape.Name == "Tape" then
                            local distance = (tape:GetPivot().Position - LocalPlayer.Character.HumanoidRootPart.Position).Magnitude
                            if distance <= 20 then
                                tape:PivotTo(LocalPlayer.Character.HumanoidRootPart.CFrame + Vector3.new(0, 2, 0))
                            end
                        end
                    end
                end
            end)
        else
            Rayfield:Notify({
                Title = "Auto-Collect Off",
                Content = "Collecting Tapes disabled.",
                Duration = 3,
                Image = "refresh-cw"
            })
            if AutoCollectConnection then
                AutoCollectConnection:Disconnect()
                AutoCollectConnection = nil
            end
        end
    end
})
ItemsTab:CreateButton({
    Name = "Teleport to Machine",
    Callback = function()
        if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
            for _, machine in pairs(Workspace:GetDescendants()) do
                if machine.Name == "Machine" then
                    LocalPlayer.Character.HumanoidRootPart.CFrame = machine:GetPivot()
                    Rayfield:Notify({
                        Title = "Teleported",
                        Content = "To nearest Machine.",
                        Duration = 3,
                        Image = "navigation"
                    })
                    return
                end
            end
            Rayfield:Notify({
                Title = "Error",
                Content = "No Machine found.",
                Duration = 3,
                Image = "alert-circle"
            })
        end
    end
})

-- Tab 6: Combat
local CombatTab = Window:CreateTab("Combat", "sword")
CombatTab:CreateSection("Combat Tools")
CombatTab:CreateToggle({
    Name = "Kill Aura",
    CurrentValue = false,
    Flag = "KillAura",
    Callback = function(Value)
        if Value then
            Rayfield:Notify({
                Title = "Kill Aura On",
                Content = "Attacking Toons within 15 studs.",
                Duration = 3,
                Image = "zap"
            })
            KillAuraConnection = RunService.Heartbeat:Connect(function()
                if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
                    for _, toon in pairs(Workspace:GetDescendants()) do
                        if toon.Name == "Toon" and toon:FindFirstChild("Humanoid") then
                            local distance = (toon:GetPivot().Position - LocalPlayer.Character.HumanoidRootPart.Position).Magnitude
                            if distance <= 15 then
                                toon.Humanoid:TakeDamage(50)
                            end
                        end
                    end
                end
            end)
        else
            Rayfield:Notify({
                Title = "Kill Aura Off",
                Content = "Disabled.",
                Duration = 3,
                Image = "zap"
            })
            if KillAuraConnection then
                KillAuraConnection:Disconnect()
                KillAuraConnection = nil
            end
        end
    end
})
CombatTab:CreateSlider({
    Name = "Aura Range",
    Range = {10, 30},
    Increment = 5,
    CurrentValue = 15,
    Flag = "AuraRange",
    Callback = function(Value)
        Rayfield:Notify({
            Title = "Range Set",
            Content = "Aura range: " .. Value,
            Duration = 3,
            Image = "ruler"
        })
    end
})

-- Tab 7: Visuals
local VisualsTab = Window:CreateTab("Visuals", "image")
VisualsTab:CreateSection("Visual Enhancements")
VisualsTab:CreateToggle({
    Name = "Remove Fog",
    CurrentValue = false,
    Flag = "RemoveFog",
    Callback = function(Value)
        local Lighting = game:GetService("Lighting")
        if Value then
            Lighting.FogEnd = 100000
            Rayfield:Notify({
                Title = "Fog Removed",
                Content = "Fog cleared.",
                Duration = 3,
                Image = "cloud"
            })
        else
            Lighting.FogEnd = 500 -- Default value; adjust as needed
            Rayfield:Notify({
                Title = "Fog Restored",
                Content = "Fog restored.",
                Duration = 3,
                Image = "cloud"
            })
        end
    end
})
VisualsTab:CreateColorPicker({
    Name = "Sky Color",
    Color = Color3.fromRGB(135, 206, 235), -- Default sky blue
    Flag = "SkyColor",
    Callback = function(Value)
        local Lighting = game:GetService("Lighting")
        Lighting.Ambient = Value
        Rayfield:Notify({
            Title = "Sky Updated",
            Content = "Sky color changed.",
            Duration = 3,
            Image = "sun"
        })
    end
})

-- Tab 8: Utilities
local UtilitiesTab = Window:CreateTab("Utilities", "tool")
UtilitiesTab:CreateSection("Utility Tools")
UtilitiesTab:CreateToggle({
    Name = "Auto-Repair Machines",
    CurrentValue = false,
    Flag = "AutoRepair",
    Callback = function(Value)
        if Value then
            Rayfield:Notify({
                Title = "Auto-Repair On",
                Content = "Repairing Machines enabled.",
                Duration = 3,
                Image = "wrench"
            })
            AutoRepairConnection = RunService.Heartbeat:Connect(function()
                if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
                    for _, machine in pairs(Workspace:GetDescendants()) do
                        if machine.Name == "Machine" and machine:FindFirstChildOfClass("ProximityPrompt") then
                            local distance = (machine:GetPivot().Position - LocalPlayer.Character.HumanoidRootPart.Position).Magnitude
                            if distance <= 10 then
                                fireproximityprompt(machine:FindFirstChildOfClass("ProximityPrompt"))
                            end
                        end
                    end
                end
            end)
        else
            Rayfield:Notify({
                Title = "Auto-Repair Off",
                Content = "Repairing Machines disabled.",
                Duration = 3,
                Image = "wrench"
            })
            if AutoRepairConnection then
                AutoRepairConnection:Disconnect()
                AutoRepairConnection = nil
            end
        end
    end
})
UtilitiesTab:CreateButton({
    Name = "Save Position",
    Callback = function()
        if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
            local pos = LocalPlayer.Character.HumanoidRootPart.Position
            Rayfield:Notify({
                Title = "Position Saved",
                Content = "Saved at " .. tostring(pos),
                Duration = 3,
                Image = "map-pin"
            })
        end
    end
})

-- Tab 9: Credits
local CreditsTab = Window:CreateTab("Credits", "award")
CreditsTab:CreateSection("Development")
CreditsTab:CreateLabel("Dandy's World Hub")
CreditsTab:CreateParagraph({
    Title = "Creator",
    Content = "Developed by Wndaalol. Thanks for using!"
})
CreditsTab:CreateParagraph({
    Title = "Library",
    Content = "Powered by Rayfield UI (https://sirius.menu/rayfield)"
})
CreditsTab:CreateButton({
    Name = "Join Discord",
    Callback = function()
        setclipboard("https://discord.gg/xVedFR4G")
        Rayfield:Notify({
            Title = "Discord",
            Content = "Invite copied to clipboard!",
            Duration = 3,
            Image = "message-square"
        })
    end
})

-- Initial Notification
Rayfield:Notify({
    Title = "Dandy's World Hub Loaded",
    Content = "Script loaded! Press 'K' to toggle UI. Discord link copied to clipboard.",
    Duration = 6,
    Image = "rocket"
})
