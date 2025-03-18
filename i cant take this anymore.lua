--loadstring(game:HttpGet("https://pastes.io/raw/wwwwwwwwwwdddd"))()

local Fluent = loadstring(game:HttpGet("https://github.com/dawid-scripts/Fluent/releases/latest/download/main.lua"))()
local SaveManager = loadstring(game:HttpGet("https://raw.githubusercontent.com/dawid-scripts/Fluent/master/Addons/SaveManager.lua"))()
local InterfaceManager = loadstring(game:HttpGet("https://raw.githubusercontent.com/dawid-scripts/Fluent/master/Addons/InterfaceManager.lua"))()
local Version = "1.3.0"




local Window = Fluent:CreateWindow({
    Title = "Blades & Buffoonery⚔️ " .. Version,
    SubTitle = "by wrdyz.94",
    TabWidth = 100,
    Size = UDim2.fromOffset(550, 400),
    Acrylic = false, -- The blur may be detectable, setting this to false disables blur entirely
    Theme = "Darker",
    MinimizeKey = Enum.KeyCode.U -- Used when theres no MinimizeKeybind
})

--Fluent provides Lucide Icons https://lucide.dev/icons/ for the tabs, icons are optional
local Tabs = {
    Player = Window:AddTab({ Title = "Player", Icon = "user" }),
    Misc = Window:AddTab({ Title = "Misc", Icon = "hammer" }),
    Autofarm = Window:AddTab({ Title = "Autofarm", Icon = "repeat" }),
    AutoCrates = Window:AddTab({ Title = "Crates", Icon = "box" }),
    Teleport = Window:AddTab({ Title = "Teleport", Icon = "compass" }),
    Feedback = Window:AddTab({ Title = "Feedback", Icon = "star" }),
    Credits = Window:AddTab({ Title = "Credits", Icon = "book" }),
    Settings = Window:AddTab({ Title = "Settings", Icon = "settings" })
}

local Options = Fluent.Options

-- do
--     Fluent:Notify({
--         Title = "Notification",
--         Content = "This is a notification",
--         SubContent = "SubContent", -- Optional
--         Duration = 5 -- Set to nil to make the notification not disappear
--     })



    Tabs.Player:AddParagraph({
        Title = "Some features won't work together and you might get kicked.",
        Content = ""
    })



    
    

    local secplayer = Tabs.Player:AddSection("Player")

    
    local player = game.Players.LocalPlayer
    local character = player.Character or player.CharacterAdded:Wait()
    local humanoid = character:WaitForChild("Humanoid")
    
    -- WalkSpeed Slider
    local SliderWalk = secplayer:AddSlider("SliderWalk", {
        Title = "Walk Speed",
        Description = "",
        Default = 30,
        Min = 30,
        Max = 150,
        Rounding = 1,
        Callback = function(Value)
            humanoid.WalkSpeed = Value
        end
    })
    
    SliderWalk:SetValue(30)
    
    -- JumpPower Slider
    local SliderJump = secplayer:AddSlider("SliderJump", {
        Title = "Jump Power",
        Description = "",
        Default = 50,
        Min = 50,
        Max = 200,
        Rounding = 1,
        Callback = function(Value)
            humanoid.UseJumpPower = true
            humanoid.JumpPower = Value
        end
    })
    
    SliderJump:SetValue(50)
    
    -- Ensure WalkSpeed stays set
    humanoid:GetPropertyChangedSignal("WalkSpeed"):Connect(function()
        if humanoid.WalkSpeed ~= SliderWalk.Value then
            humanoid.WalkSpeed = SliderWalk.Value
        end
    end)
    
    -- Ensure JumpPower stays set
    humanoid:GetPropertyChangedSignal("JumpPower"):Connect(function()
        if humanoid.JumpPower ~= SliderJump.Value then
            humanoid.JumpPower = SliderJump.Value
        end
    end)
    
    -- Reset values when character respawns
    player.CharacterAdded:Connect(function(character)
        humanoid = character:WaitForChild("Humanoid")
        humanoid.WalkSpeed = SliderWalk.Value
        humanoid:GetPropertyChangedSignal("WalkSpeed"):Connect(function()
            if humanoid.WalkSpeed ~= SliderWalk.Value then
                humanoid.WalkSpeed = SliderWalk.Value
            end
        end)
        humanoid.UseJumpPower = true
        humanoid.JumpPower = SliderJump.Value
    end)


    Tabs.Autofarm:AddParagraph({
        Title = "Disable everything from player section before enabling this.",
        Content = ""
    })

    local secauto = Tabs.Autofarm:AddSection("Heads")

    local Headsinput = secauto:AddInput("Autofarm threshold", {
        Title = "Autofarm threshold",
        Description = "Below 0.08 will resault in a server kick.",
        Default = "0.1",
        Placeholder = "Placeholder",
        Numeric = true, -- Only allows numbers
        Finished = true, -- Only calls callback when you press enter
        -- Callback = function(numberthreshold)
        --     print("Input changed:", numberthreshold)
        -- end
    })
    
    local player = game.Players.LocalPlayer
    local AutofarmCoins = secauto:AddToggle("AutofarmCoins", {Title = "Autofarm heads", Default = false })
    local eventsDeleted = false  -- Variable to track if the events were already deleted
    
    local notificationShown = false
    
    -- Function to disable autofarm and show notification
    local function disableAutofarmWithNotification()
        AutofarmCoins:SetValue(false)
        Fluent:Notify({
            Title = "Autofarm",
            Content = "Disabled due to death.",
            Duration = 5
        })
    end
    
    AutofarmCoins:OnChanged(function()
        if not player or not player.Character then return end -- Ensure player exists
        local characterEvents = player.Character:FindFirstChild("CharacterEvents")
        if not characterEvents then return end -- Ensure CharacterEvents exists
    
        if AutofarmCoins.Value then
            -- Check if player has a weapon
            local weapon = player.Character:FindFirstChildOfClass("Tool")
            if not weapon then
                AutofarmCoins:SetValue(false)
                Fluent:Notify({
                    Title = "Autofarm",
                    Content = "Weapon not found.",
                    Duration = 5
                })
                return  -- Exit early if no weapon
            end

            if humanoid.Health == 0 then
                disableAutofarmWithNotification()  -- Disable autofarm and notify on death
                return
            end
    
            -- Delete events only once
            if not eventsDeleted then
                for _, event in ipairs(characterEvents:GetChildren()) do
                    event:Destroy()  -- Destroy each child (event) in the CharacterEvents folder
                end
                eventsDeleted = true
            end
    
            -- Ensure to disable autofarm on death
            if player.Character:FindFirstChild("Humanoid") then
                player.Character.Humanoid.Died:Connect(function()
                    disableAutofarmWithNotification()  -- Disable autofarm and notify on death
                end)
            end
    
            -- Start the hit loop
            task.spawn(function()
                while AutofarmCoins.Value do
                    for _, tool in ipairs(player.Character:GetChildren()) do
                        if tool:IsA("Tool") then
                            local hitEvent = tool:FindFirstChild("Events") and tool.Events:FindFirstChild("Hit")
                            if hitEvent then
                                local humanoid = player.Character:FindFirstChild("Humanoid")
                                if humanoid then
                                    hitEvent:FireServer(humanoid)
                                end
                            end
                        end
                    end
                    
                    -- Convert input value to a number and check if it's >= 0.8           
                    -- if Headsinput.Value > 0.8 then
                        task.wait(Headsinput.Value)
                    -- end
                end
            end)
            
    
        else
            -- Stop the hit loop
            
            -- Restore the deleted events
            if eventsDeleted then
                local function restoreEvent(name)
                    local event = Instance.new("RemoteEvent")
                    event.Name = name
                    event.Parent = player.Character:FindFirstChild("CharacterEvents")
                end
    
                restoreEvent("Ability")
                restoreEvent("ClientRagdollEvent")
                restoreEvent("Headbutt")
                restoreEvent("Hit")
                restoreEvent("Impulse")
                restoreEvent("Launch")
                restoreEvent("PhysicsEvent")
                restoreEvent("RagdollEvent")
    
                eventsDeleted = false  -- Reset the deletion flag
            end
        end
    end)
    
    -- Ensure Autofarm is off initially
    AutofarmCoins:SetValue(false)
    


    



    
        

    



    local GodMode = secplayer:AddToggle("GodMode", {Title = "God Mode", Default = false })
    local eventsDeletedGod = false  -- Variable to track if the events were already deleted
    local humanoid = nil
    local characterEvents = player.Character:FindFirstChild("CharacterEvents")

    
    GodMode:OnChanged(function(isToggled)
        local player = game.Players.LocalPlayer
        if not player or not player.Character then return end -- Ensure the player exists
    
        local characterEvents = player.Character:FindFirstChild("CharacterEvents")
        if not characterEvents then return end -- Ensure CharacterEvents exists
    
        humanoid = player.Character:FindFirstChild("Humanoid")
        
        if isToggled then
            -- Disable damage
            if humanoid then
                humanoid.Health = humanoid.MaxHealth -- Restore health to max
                humanoid:SetStateEnabled(Enum.HumanoidStateType.Physics, false) -- Disable physics-based damage
            end
            -- Delete the events only once
            if not eventsDeletedGod then
                if characterEvents then
                    for _, event in ipairs(characterEvents:GetChildren()) do
                        event:Destroy()  -- Destroy each child (event) in the CharacterEvents folder
                    end
                end
                eventsDeletedGod = true  -- Mark events as deleted
            end
        else
            -- Enable damage again
            if humanoid then
                humanoid:SetStateEnabled(Enum.HumanoidStateType.Physics, true)  -- Re-enable physics-based damage
            end
    
            -- Restore the deleted events
            if eventsDeletedGod then
                if characterEvents then
                    Instance.new("RemoteEvent", characterEvents).Name = "Ability"
                    Instance.new("RemoteEvent", characterEvents).Name = "ClientRagdollEvent"
                    Instance.new("RemoteEvent", characterEvents).Name = "Headbutt"
                    Instance.new("RemoteEvent", characterEvents).Name = "Hit"
                    Instance.new("RemoteEvent", characterEvents).Name = "Impulse"
                    Instance.new("RemoteEvent", characterEvents).Name = "Launch"
                    Instance.new("RemoteEvent", characterEvents).Name = "PhysicsEvent"
                    Instance.new("RemoteEvent", characterEvents).Name = "RagdollEvent"
                end
    
                eventsDeletedGod = false  -- Reset the deletion flag
            end
        end
    end)
    
    Options.GodMode:SetValue(false)


    local Killaura = secplayer:AddToggle("Killaura", {Title = "Kill aura", Default = false})
local player = game:GetService("Players").LocalPlayer
local hitEventThread = nil
local notificationShown = false

-- Function to get the nearest player
local function getNearestPlayer()
    local closestPlayer = nil
    local shortestDistance = math.huge
    local myHRP = player.Character and player.Character:FindFirstChild("HumanoidRootPart")
    
    if myHRP then
        for _, p in pairs(game:GetService("Players"):GetPlayers()) do
            if p.Character and p ~= player then
                local targetHRP = p.Character:FindFirstChild("HumanoidRootPart")
                if targetHRP then
                    local distance = (targetHRP.Position - myHRP.Position).Magnitude
                    if distance < shortestDistance then
                        shortestDistance = distance
                        closestPlayer = p
                    end
                end
            end
        end
    end
    return closestPlayer
end

-- Function to fire the hit event
local function fireHitEvent()
    while Killaura.Value do
        local weapon = player.Character and player.Character:FindFirstChildOfClass("Tool")
        if not weapon then
            Killaura:SetValue(false)
            Fluent:Notify({
                Title = "Kill Aura",
                Content = "Weapon not found.",
                Duration = 5
            })
            return
        end
        
        local targetPlayer = getNearestPlayer()
        if targetPlayer then
            weapon.Events.Hit:FireServer(targetPlayer.Character.Humanoid)
        end
        task.wait(.1)
    end
end

-- Function to handle player death
local function handlePlayerDeath()
    if Killaura.Value then
        Killaura:SetValue(false)
        Fluent:Notify({
            Title = "Kill Aura",
            Content = "Disabled due to death.",
            Duration = 5
        })
    end
end

-- Connect to character respawn
player.CharacterAdded:Connect(function(character)
    notificationShown = false  -- Reset flag on respawn
    local humanoid = character:WaitForChild("Humanoid")
    humanoid.Died:Connect(handlePlayerDeath)
end)

-- Handle Killaura toggle
Killaura:OnChanged(function()
    if Killaura.Value then
        local weapon = player.Character and player.Character:FindFirstChildOfClass("Tool")
        if not weapon then
            Killaura:SetValue(false)
            Fluent:Notify({
                Title = "Kill Aura",
                Content = "Weapon not found.",
                Duration = 5
            })
            return
        end
        
        Fluent:Notify({
            Title = "Kill Aura",
            Content = "If you die kill aura will be disabled.",
            Duration = 5
        })
        hitEventThread = task.spawn(fireHitEvent)
    else
        hitEventThread = nil  -- Stop the loop
    end
end)

-- Ensure the death event is connected if the character already exists
if player.Character then
    local humanoid = player.Character:FindFirstChild("Humanoid")
    if humanoid then
        humanoid.Died:Connect(handlePlayerDeath)
    end
end







local secHitbox = Tabs.Misc:AddSection("Hitbox")

local hitcolor = secHitbox:AddColorpicker("hitcolor", {
    Title = "Hitbox color",
    Transparency = 0,
    Default = Color3.fromRGB(255, 0, 0)
})

local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer

-- Table to store original HumanoidRootPart sizes
local OriginalSizes = {}

-- Function to safely get the default size of HumanoidRootPart
local function GetDefaultHumanoidRootPartSize(player)
    if player and player.Character then
        local rootPart = player.Character:FindFirstChild("HumanoidRootPart")
        if rootPart then
            return rootPart.Size
        end
    end
    return Vector3.new(2, 2, 1) -- Fallback size
end

-- Set default size based on local player (if available)
local DefaultHitboxSize = GetDefaultHumanoidRootPartSize(LocalPlayer).X
local HitboxSize = DefaultHitboxSize -- Current hitbox size (modifiable via slider)
local HitboxEnabled = false -- Track if hitbox resizing is enabled

-- Function to resize hitboxes for other players
local function ResizeHitboxesForPlayer(player)
    if not HitboxEnabled or player == LocalPlayer then return end -- Ensure toggle is ON and ignore local player

    if player.Character then
        local humanoidRootPart = player.Character:FindFirstChild("HumanoidRootPart")
        if humanoidRootPart then
            -- Store original size before resizing
            if not OriginalSizes[player] then
                OriginalSizes[player] = humanoidRootPart.Size
            end

            local newSize = Vector3.new(HitboxSize, HitboxSize, HitboxSize)

            humanoidRootPart.Size = newSize
            humanoidRootPart.CanCollide = false
            humanoidRootPart.Transparency = 1 -- Make it invisible

            -- Add visualizer if not already present
            local hitboxVisualizer = humanoidRootPart:FindFirstChild("HitboxVisualizer")
            if not hitboxVisualizer then
                hitboxVisualizer = Instance.new("SelectionBox")
                hitboxVisualizer.Name = "HitboxVisualizer"
                hitboxVisualizer.Adornee = humanoidRootPart
                hitboxVisualizer.Parent = humanoidRootPart

                -- Set initial color when visualizer is created
                local color = hitcolor.Value
                local r, g, b = math.floor(color.R * 255), math.floor(color.G * 255), math.floor(color.B * 255)
                
                hitboxVisualizer.Color3 = Color3.fromRGB(r, g, b)
                hitboxVisualizer.SurfaceColor3 = Color3.fromRGB(r, g, b)
                
                hitboxVisualizer.SurfaceTransparency = 1 -- Outline only
                hitboxVisualizer.LineThickness = 0.1
            end
        end
    end
end

-- Function to reset hitbox to original size
local function RevertHitboxSize(player)
    if player == LocalPlayer then return end -- Ignore local player
    
    if player.Character then
        local humanoidRootPart = player.Character:FindFirstChild("HumanoidRootPart")
        if humanoidRootPart and OriginalSizes[player] then
            humanoidRootPart.Size = OriginalSizes[player] -- Reset size
            humanoidRootPart.Transparency = 0 -- Restore transparency
            humanoidRootPart.CanCollide = true -- Restore collision
            
            -- Remove hitbox visualizer if it exists
            local hitboxVisualizer = humanoidRootPart:FindFirstChild("HitboxVisualizer")
            if hitboxVisualizer then
                hitboxVisualizer:Destroy()
            end
        end
    end
end

-- Function to resize all players except local player
local function ApplyHitboxResizing()
    for _, player in pairs(Players:GetPlayers()) do
        if player ~= LocalPlayer then
            ResizeHitboxesForPlayer(player)
        end
    end
end

-- Function to update the color of the hitbox visualizer for all players
local function UpdateHitboxColor()
    local color = hitcolor.Value
    local r, g, b = math.floor(color.R * 255), math.floor(color.G * 255), math.floor(color.B * 255)

    -- Iterate through all players and update their visualizers
    for _, player in pairs(Players:GetPlayers()) do
        if player ~= LocalPlayer and player.Character then
            local humanoidRootPart = player.Character:FindFirstChild("HumanoidRootPart")
            if humanoidRootPart then
                local hitboxVisualizer = humanoidRootPart:FindFirstChild("HitboxVisualizer")
                if hitboxVisualizer then
                    hitboxVisualizer.Color3 = Color3.fromRGB(r, g, b)
                    hitboxVisualizer.SurfaceColor3 = Color3.fromRGB(r, g, b)
                    hitboxVisualizer.Transparency = hitcolor.Transparency
                end
            end
        end
    end
end

-- Handle new player joining and respawning
Players.PlayerAdded:Connect(function(player)
    player.CharacterAdded:Connect(function()
        task.wait(1) -- Ensure character is fully loaded
        if HitboxEnabled then
            ResizeHitboxesForPlayer(player)
        end
    end)
end)

-- Apply respawn handling for all players except local player
for _, player in pairs(Players:GetPlayers()) do
    if player ~= LocalPlayer then
        player.CharacterAdded:Connect(function()
            task.wait(1) -- Ensure character is fully loaded
            if HitboxEnabled then
                ResizeHitboxesForPlayer(player)
            end
        end)
    end
end

-- UI Elements (Initialized AFTER variables are defined)
local SliderHitboxSize = secHitbox:AddSlider("SliderHitboxSize", {
    Title = "Hitbox Size",
    Description = "",
    Default = DefaultHitboxSize,
    Min = 10,  -- Minimum size
    Max = 70, -- Maximum size
    Rounding = 1,
    Callback = function(Value)
        if Value then
            HitboxSize = Value -- Update hitbox size
            if HitboxEnabled then
                ApplyHitboxResizing()
            end
        end
    end
})

-- Ensure slider starts at default size
SliderHitboxSize:SetValue(DefaultHitboxSize)

-- Toggle to enable/disable hitbox resizing (AFTER slider)
local ToggleHitboxResize = secHitbox:AddToggle("ToggleHitboxResize", {
    Title = "Hitbox Expander",
    Default = false
})

-- Toggle behavior (AFTER slider)
ToggleHitboxResize:OnChanged(function(Value)
    if Value == nil then return end -- Prevent nil value errors

    HitboxEnabled = Value

    if HitboxEnabled then
        ApplyHitboxResizing() -- Apply resizing if enabled
    else
        -- Revert all players except local player to their original hitbox sizes
        for _, player in pairs(Players:GetPlayers()) do
            if player ~= LocalPlayer then
                RevertHitboxSize(player)
            end
        end
    end
end)

-- Update color whenever the colorpicker value changes
hitcolor:OnChanged(function()
    UpdateHitboxColor()
end)







local secmisc = Tabs.Misc:AddSection("Misc")


local brickk = secmisc:AddToggle("BrickToggle", {Title = "Big Brick", Description = "Brick on top of lava", Default = false})

brickk:OnChanged(function()
    if brickk.Value then
        -- Define position and size when toggle is enabled
        local position = Vector3.new(50, -47, 1000)
        local size = Vector3.new(10000, 10, 10000) -- Massive brick
        
        -- Create the brick
        local brick = Instance.new("Part")
        brick.Size = size
        brick.Position = position
        brick.Anchored = true
        brick.CanCollide = true
        brick.Transparency = .5 -- Fully visible
        brick.BrickColor = BrickColor.new("Bright orange")
        brick.Name = "BigBrick" -- Set a unique name for the brick
        brick.Parent = game.Workspace
    else
        -- Remove the brick if toggle is turned off
        local existingBrick = game.Workspace:FindFirstChild("BigBrick") -- Use the name set earlier
        if existingBrick then
            existingBrick:Destroy()
        end
    end
end)





    -- -- Create Auto-Click ToggleA
    -- local TeleportService = game:GetService("TeleportService")
    -- local Players = game:GetService("Players")
    -- local LocalPlayer = Players.LocalPlayer
    
    -- local Autorejoin = secmisc:AddToggle("Autorejoin", {Title = "Auto rejoin", Description = "Instantly rejoins when kicked", Default = false})
    
    -- Autorejoin:OnChanged(function()
    --     if Autorejoin.Value then
    --         -- Detect when the player is kicked by overriding the Kick function
    --         local mt = getrawmetatable(game)
    --         setreadonly(mt, false)
    --         local oldNamecall = mt.__namecall
    
    --         mt.__namecall = newcclosure(function(self, ...)
    --             local method = getnamecallmethod()
    --             if method == "Kick" and self == LocalPlayer then
    --                 task.spawn(function()
    --                     TeleportService:Teleport(game.PlaceId) -- Instantly rejoin
    --                 end)
    --                 return
    --             end
    --             return oldNamecall(self, ...)
    --         end)
    
    --         -- Handle teleport failure and attempt rejoin
    --         LocalPlayer.OnTeleport:Connect(function(status)
    --             if status == Enum.TeleportState.Failed then
    --                 TeleportService:Teleport(game.PlaceId) -- Instantly attempt to rejoin
    --             end
    --         end)
    --     end
    -- end)
    
    

    -- Options.Autorejoin:SetValue(false)



local Players = game:GetService("Players")
local VirtualUser = game:GetService("VirtualUser")

local player = Players.LocalPlayer
local AntiAFKEnabled = false  -- Starts as disabled
local AntiAFKLoop  -- Variable to store the loop thread

-- UI Toggle Setup
local Antiafk = secmisc:AddToggle("Antiafk", {Title = "Anti AFK", Default = false })

Antiafk:OnChanged(function()
    AntiAFKEnabled = Options.Antiafk.Value  -- Sync with UI Toggle

    if AntiAFKEnabled then
        -- Start Anti-AFK loop
        AntiAFKLoop = task.spawn(function()
            while AntiAFKEnabled do
                VirtualUser:CaptureController()
                VirtualUser:ClickButton2(Vector2.new()) -- Simulates right-click to stay active
                print("Anti-AFK: Prevented afk kick.")
                task.wait(300) -- Every 5 minutes (300 seconds)
            end
        end)
    else
        -- Stop Anti-AFK loop
        AntiAFKEnabled = false
        if AntiAFKLoop then
            task.cancel(AntiAFKLoop) -- Stop the active loop
            AntiAFKLoop = nil
        end
    end
end)

Antiafk:SetValue(false) -- Default state is OFF

-- Prevent AFK kick by responding to "Idle" events
player.Idled:Connect(function()
    if AntiAFKEnabled then
        VirtualUser:CaptureController()
        VirtualUser:ClickButton2(Vector2.new())
    end
end)




    

-- 📌 UI Section
local secauto2 = Tabs.Autofarm:AddSection("Boxes")


-- 📌 Variables
local player = game.Players.LocalPlayer
local TweenService = game:GetService("TweenService")  
local character = player.Character or player.CharacterAdded:Wait()
local teleporting = false
local notificationShown = false

-- 📌 Function to calculate distance
local function GetDistance(position1, position2)
    return (position1 - position2).Magnitude
end

-- 📌 Dropdown for Teleport Method
local DTPM = secauto2:AddDropdown("DTPM", {
    Title = "Teleportation Method",
    Description = "Choose teleport method",
    Values = {"Lerp (Stable)", "Tween (Unstable)"},
    Multi = false,
    Default = 1,
})

local selectedMethod = "Lerp (Stable)"
DTPM:SetValue(selectedMethod)
DTPM:OnChanged(function(value)
    selectedMethod = value  
end)

-- Declare stepammount globally first with a default value
local stepammount = 0.005

local StepValue = secauto2:AddInput("StepValue", {
    Title = "Step Size",
    Description = "Default setting if unfamiliar.",
    Default = "0.005",
    Placeholder = "Placeholder",
    Numeric = true, -- Only allows numbers
    Finished = true, -- Only calls callback when you press enter
    Callback = function(Value)
    end
})

-- Properly update the global stepammount when the input changes
StepValue:OnChanged(function()
    stepammount = tonumber(StepValue.Value) or 0.005 -- Convert to number with fallback
    print("Step amount updated to:", stepammount)
end)

-- 📌 Toggle for Autofarm
local TTPM = secauto2:AddToggle("TTPM", {Title = "Autofarm boxes (Speed depends on FPS)", Default = false})

-- Add the missing GetDistance function if it's not defined elsewhere
local function GetDistance(pos1, pos2)
    return (pos1 - pos2).Magnitude
end

-- 📌 Function to find nearest box
local function FindNearestBox()
    local rootPart = character:FindFirstChild("HumanoidRootPart")
    if not rootPart then return nil end

    local boxPositions = game.Workspace:FindFirstChild("BoxPositions")
    if not boxPositions then return nil end

    local nearestBox, nearestDistance = nil, math.huge  
    for _, boxpos in pairs(boxPositions:GetChildren()) do
        if boxpos:IsA("BasePart") and #boxpos:GetChildren() > 0 then
            local distance = GetDistance(rootPart.Position, boxpos.Position)
            if distance < nearestDistance then
                nearestBox, nearestDistance = boxpos, distance
            end
        end
    end
    return nearestBox
end

-- 📌 Direct TP Function (Lerp)
local player = game.Players.LocalPlayer
local character = player.Character or player.CharacterAdded:Wait()  -- Ensure character exists
local humanoid = character:WaitForChild("Humanoid")

-- Function to handle player's respawn and re-enable the teleportation toggle
local function onPlayerRespawn()
    -- Ensure that TTPM is enabled again when the player respawns
    TTPM:SetValue(true)
end

-- Connect respawn event
player.CharacterAdded:Connect(function(newCharacter)
    character = newCharacter  -- Update character reference
    humanoid = character:WaitForChild("Humanoid")

    -- Connect to the new humanoid's Died event to disable autofarm on death
    humanoid.Died:Connect(function()
        TTPM:SetValue(false)
        Fluent:Notify({
            Title = "Autofarm",
            Content = "Disabled due to player death.",
            SubContent = "", -- Optional
            Duration = 5 -- Set to nil to make the notification not disappear
        })
    end)
end)

local function DirectTeleportToNearestCrate()
    local rootPart = character:FindFirstChild("HumanoidRootPart")
    local tool = character:FindFirstChildOfClass("Tool")
    
    if not rootPart then return end
    
    local nearestBox = FindNearestBox()
    if not nearestBox then return end
    
    if humanoid.Health <= 0 then
        TTPM:SetValue(false)
        Fluent:Notify({
            Title = "Autofarm",
            Content = "Disabled due to player death.",
            Duration = 5
        })
        return
    end
    
    if not tool then
        Fluent:Notify({
            Title = "Autofarm",
            Content = "Weapon not found.",
            Duration = 5
        })
        TTPM:SetValue(false)
        return
    end
    
    local maxSpeed, minSpeed, distanceThreshold = 500, 200, 70
    
    local startPos = rootPart.Position
    local endPos = nearestBox.Position + Vector3.new(0, 2, 0)
    local distance = GetDistance(startPos, endPos)
    
    -- Calculate speed based on distance - slower when further away
    local speed = maxSpeed
    if distance > distanceThreshold then
        local factor = math.clamp((distance - distanceThreshold) / distanceThreshold, 0, 1)
        speed = maxSpeed - factor * (maxSpeed - minSpeed)
    end
    
    local stepSize = speed * stepammount
    local totalSteps = math.ceil(distance / stepSize)
    
    -- Precompute random offsets for better performance
    local randomOffsets = {}
    for i = 1, totalSteps do
        randomOffsets[i] = Vector3.new(math.random(), math.random(), math.random())
    end
    
    for i = 1, totalSteps do
        rootPart.CFrame = CFrame.new(startPos:Lerp(endPos + randomOffsets[i], i / totalSteps))
        tool:Activate()
        task.wait(stepammount)
    end
    
    tool:Activate()
end

-- Add the connection for the toggle to run the teleport function
TTPM:OnChanged(function()
    if TTPM.Value then
        -- Create a loop that runs while the toggle is enabled
        task.spawn(function()
            while TTPM.Value do
                DirectTeleportToNearestCrate()
                task.wait(0.1) -- Small delay between teleports
            end
        end)
    end
end)


-- 📌 Tween TP Function (with subtle path variation)
local function TweenTeleportToNearestCrate()
    local rootPart = character:FindFirstChild("HumanoidRootPart")
    if not rootPart then return end

    local nearestBox = FindNearestBox()
    if not nearestBox then return end
    
    local tool = character:FindFirstChildOfClass("Tool")
    if not tool then
        TTPM:SetValue(false)
        Fluent:Notify({
            Title = "Autofarm",
            Content = "Weapon not found.",
            Duration = 5
        })
        return
    end

    -- Check if player is alive
    if humanoid.Health <= 0 then
        TTPM:SetValue(false)
        Fluent:Notify({
            Title = "Autofarm",
            Content = "Disabled due to player death.",
            Duration = 5
        })
        return
    end

    local distance = GetDistance(rootPart.Position, nearestBox.Position)
    local constantSpeed = 150
    local tweenInfo = TweenInfo.new(
        distance / constantSpeed, 
        Enum.EasingStyle.Linear, 
        Enum.EasingDirection.Out
    )

    local adjustedEndPos = nearestBox.Position + Vector3.new(0, 2, 0)
    
    local tween = TweenService:Create(rootPart, tweenInfo, {Position = adjustedEndPos})
    tween:Play()
    
    -- Connect completion event to activate tool once
    tween.Completed:Connect(function()
        tool:Activate()
    end)
    
    -- Also activate at the start for faster response
    tool:Activate()
end

-- 📌 Function to start teleport loop
local function StartTeleportLoop()
    if teleporting then return end
    teleporting = true

    while TTPM.Value do
        if selectedMethod == "Lerp (Stable)" then
            DirectTeleportToNearestCrate()
        else
            TweenTeleportToNearestCrate()
        end
        task.wait()  -- No delay added here
    end
    teleporting = false
end


-- Listening for the TTPM value change
    TTPM:OnChanged(function()
        if TTPM.Value then 
            local tool = character:FindFirstChildOfClass("Tool")
        if not tool then
            TTPM:SetValue(false)
            Fluent:Notify({
                Title = "Autofarm",
                Content = "Weapon not found.",
                SubContent = "", -- Optional
                Duration = 5 -- Set to nil to make the notification not disappear
            })
        else
            StartTeleportLoop() 
        end
    end
end)

TTPM:SetValue(false)


Tabs.AutoCrates:AddParagraph({
    Title = "Disabled autofarm heads before enabling this.",
    Content = ""
})

local seccrate = Tabs.AutoCrates:AddSection("Crates")

-- Get the names of all children in the folder
local crateFolder = game.ReplicatedStorage:FindFirstChild("Crates")
local crateNames = {}

if crateFolder then
    for _, child in ipairs(crateFolder:GetChildren()) do
        table.insert(crateNames, child.Name)
    end
end

-- Create the dropdown with dynamically fetched values
local Dropdowncrate = seccrate:AddDropdown("Dropdowncrate", {
    Title = "Crate rarity",
    Description = "",
    Values = crateNames,
    Multi = false,
    Default = nil,
})


local Togglecrate = seccrate:AddToggle("ToggleCrate", {Title = "Auto open", Default = false })

Togglecrate:OnChanged(function()
    while Togglecrate.Value do
        local args = {
            [1] = Dropdowncrate.Value
        }
        game:GetService("ReplicatedStorage").RemoteEvents.BuyCrate:FireServer(unpack(args))

        task.wait(.125)
    end
end)

Options.ToggleCrate:SetValue(false)

local UItogglecrate = seccrate:AddToggle("UItogglecrate", {Title = "Disable Crate Ui", Default = false })

UItogglecrate:OnChanged(function()
    while UItogglecrate.Value do
        if game:GetService("Players").LocalPlayer.PlayerGui.OpenedCrateGui.Enabled == true then
            game:GetService("Players").LocalPlayer.PlayerGui.OpenedCrateGui.Enabled = false
        end
        task.wait()
    end
end)

Options.UItogglecrate:SetValue(false)







local MapTeleport = Tabs.Teleport:AddSection("Map")

local DropdownTP1 = MapTeleport:AddDropdown("Dropdown", {
    Title = "Teleport Locations",
    Description = "Select a location to teleport",
    Values = {
        "Spawn", "Middle", "Volcano", "House", "Orange area", "Green area", 
        "House Island", "Volcano Island", "Green Island", "Orange Island", 
        "Cursed Easter egg", "MrKrabs Easter egg", "Patrick Easter egg", 
        "Squidward Easter egg", "Hidden Place"
    },
    Multi = false,
    Default = nil, -- No default selection
})

-- Table storing predefined teleport positions (Replace with actual coordinates)
local TeleportPositions = {
    Spawn = Vector3.new(-119.48295593261719, -82, -633.8499145507812),
    Middle = Vector3.new(-121.56722259521484, 30, 627.26806640625),
    Volcano = Vector3.new(-58.984901428222656, 55, 379.8953552246094),
    House = Vector3.new(-313.7142028808594, 65, 799.8230590820312),
    ["Orange area"] = Vector3.new(113.75994873046875, 40, 568.0531616210938),
    ["Green area"] = Vector3.new(-297.9775695800781, 60, 351.818115234375),
    ["House Island"] = Vector3.new(-269.5734558105469, 40, 929.2530517578125),
    ["Volcano Island"] = Vector3.new(6.409029960632324, 25, 133.85360717773438),
    ["Green Island"] = Vector3.new(-453.35491943359375, 40, 475.5623779296875),
    ["Orange Island"] = Vector3.new(159.71475219726562, 40, 871.1873779296875),
    ["Cursed Easter egg"] = Vector3.new(-30.23427391052246, -29, 752.7457885742188),
    ["MrKrabs Easter egg"] = Vector3.new(-355.552001953125, -68, 599.7149047851562),
    ["Patrick Easter egg"] = Vector3.new(-7.87994384765625, -55, 635.6487426757812),
    ["Squidward Easter egg"] = Vector3.new(-152.22637939453125, -25, 424.02178955078125),
    ["Hidden Place"] = Vector3.new(-40.115821838378906, -66, 293.3738098144531),
}

-- Function to teleport using Lerp
local function TeleportToSelectedLocation(locationName)
    DropdownTP1:SetValue(nil)  -- Reset dropdown selection
    if not locationName or not TeleportPositions[locationName] then return end -- Ensure a valid selection

    local player = game.Players.LocalPlayer
    if not player or not player.Character then return end

    local character = player.Character
    local rootPart = character:FindFirstChild("HumanoidRootPart")
    if not rootPart then return end

    local targetPosition = TeleportPositions[locationName]

    local speed = 225 -- Fixed speed (adjustable for balance)
    local stepInterval, stepSize = 0.005, speed * 0.005
    local startPos, endPos = rootPart.Position, targetPosition + Vector3.new(0, 2, 0)
    local totalSteps = math.ceil((startPos - endPos).Magnitude / stepSize)

    for i = 1, totalSteps do
        -- Slightly modify the path for unpredictability
        local adjustedEndPos = endPos + Vector3.new(math.random() * 0.1 - 0.05, 0, math.random() * 0.1 - 0.05)

        -- Lerp movement
        rootPart.CFrame = CFrame.new(startPos:Lerp(adjustedEndPos, i / totalSteps))
        task.wait(stepInterval)
    end
end

-- Connect dropdown selection to teleport function
DropdownTP1:OnChanged(function(selectedLocation)
    if selectedLocation then
        TeleportToSelectedLocation(selectedLocation)
    end
end)


local PlayerTeleport = Tabs.Teleport:AddSection("Players")

-- Function to get all player names (excluding LocalPlayer)
local function GetPlayerNames()
    local playerNames = {}
    local localPlayer = game.Players.LocalPlayer
    for _, player in ipairs(game.Players:GetPlayers()) do
        if player ~= localPlayer then -- Exclude local player
            table.insert(playerNames, player.Name)
        end
    end
    return playerNames
end

-- Create the dropdown with dynamic player names
local DropdownTP1 = PlayerTeleport:AddDropdown("Dropdown", {
    Title = "Players",
    Description = "Select a player to teleport to",
    Values = GetPlayerNames(),
    Multi = false,
    Default = nil, -- No default selection
})

-- Function to update the dropdown when players join/leave
local function UpdateDropdown()
    DropdownTP1:SetValues(GetPlayerNames())
end

game.Players.PlayerAdded:Connect(UpdateDropdown)
game.Players.PlayerRemoving:Connect(UpdateDropdown)

-- Function to smoothly teleport to the selected player with dynamic speed
local function TeleportToPlayer(playerName)
    DropdownTP1:SetValue(nil) -- Reset dropdown selection
    local localPlayer = game.Players.LocalPlayer
    if not localPlayer or not localPlayer.Character then return end

    local character = localPlayer.Character
    local rootPart = character:FindFirstChild("HumanoidRootPart")
    if not rootPart then return end

    local targetPlayer = game.Players:FindFirstChild(playerName)
    if not targetPlayer or not targetPlayer.Character then return end

    local targetRoot = targetPlayer.Character:FindFirstChild("HumanoidRootPart")
    if not targetRoot then return end

    local startPos, endPos = rootPart.Position, targetRoot.Position + Vector3.new(0, 2, 0)
    local distance = (startPos - endPos).Magnitude

    -- Adjust speed based on distance (closer = faster, farther = slower)
    local minSpeed, maxSpeed = 500, 200 -- Min and max movement speed
    local speed = math.clamp(distance * 1.5, minSpeed, maxSpeed) -- Scale speed based on distance

    local stepInterval, stepSize = 0.005, speed * 0.005
    local totalSteps = math.ceil(distance / stepSize)

    for i = 1, totalSteps do
        -- Slightly modify the path for unpredictability
        local adjustedEndPos = endPos + Vector3.new(math.random() * 0.1 - 0.05, 0, math.random() * 0.1 - 0.05)

        -- Lerp movement
        rootPart.CFrame = CFrame.new(startPos:Lerp(adjustedEndPos, i / totalSteps))
        task.wait(stepInterval)
    end
end

-- Connect dropdown selection to teleport function
DropdownTP1:OnChanged(function(selectedPlayer)
    if selectedPlayer then
        TeleportToPlayer(selectedPlayer)
    end
end)





local Feedbackw = Tabs.Feedback:AddDropdown("Feedbackw", {
    Title = "Rate this script",
    Description = "Give an honest rating for future imporvements",
    Values = {"⭐", "⭐⭐", "⭐⭐⭐", "⭐⭐⭐⭐", "⭐⭐⭐⭐⭐"},
    Multi = false,
    Default = nil,
})

local Feedbackz = Tabs.Feedback:AddInput("Feedbackz", {
    Title = "Reason for rating",
    Default = "",
    Placeholder = "Give us your feedback",
    Numeric = false, -- Only allows numbers
    Finished = true, -- Only calls callback when you press enter
    Callback = function(Value)
    end
})

-- Variables to store current feedback state
local currentRating = nil
local currentFeedbackText = ""
local messageId = nil -- To store the ID of the sent message for updates
local hasRating = false
local feedbackUpdateTimer = nil
local feedbackSent = false

local function SendFeedbackToWebhook(isUpdate)
    -- Don't send if we don't have a rating
    if not currentRating then return end
    
    local webhookUrl = "https://discord.com/api/webhooks/1350787764874121217/Jv3AwSgD-viEpIu8cfjEm1MxFqJ62e9kEdIyDVKuf4gH2Hl6Hf3fwBJHok3Qouhwo3TE"
    
    local function CreateEmbed()
        local player = game.Players.LocalPlayer
        local username = player.Name
        local username2 = player.DisplayName
        local placeId = game.PlaceId
        local placeName = game:GetService("MarketplaceService"):GetProductInfo(placeId).Name
        local deviceType = "Unknown"

        if game:GetService("UserInputService"):IsKeyDown(Enum.KeyCode.ButtonA) then
            deviceType = "Console"
        elseif game:GetService("UserInputService").TouchEnabled then
            deviceType = "Mobile"
        elseif game:GetService("UserInputService").KeyboardEnabled then
            deviceType = "PC"
        end

        -- Create a subtle embed
        return {
            ["title"] = "Feedback: " .. placeName,
            ["description"] = "Feedback from " .. username2,
            ["color"] = 3447003,
            ["fields"] = {
                {
                    ["name"] = "Display Name",
                    ["value"] = username2,
                    ["inline"] = true
                },
                {
                    ["name"] = "Username",
                    ["value"] = username,
                    ["inline"] = true
                },
                {
                    ["name"] = "Device",
                    ["value"] = deviceType,
                    ["inline"] = true
                },
                {
                    ["name"] = "Rating",
                    ["value"] = currentRating,
                    ["inline"] = true
                },
                {
                    ["name"] = "Comments",
                    ["value"] = currentFeedbackText ~= "" and currentFeedbackText or "No comments provided",
                    ["inline"] = false
                },
                {
                    ["name"] = "Place",
                    ["value"] = placeName .. " (" .. tostring(placeId) .. ")",
                    ["inline"] = true
                }
            },
            ["footer"] = {
                ["text"] = "Version: " .. Version
            },
            ["timestamp"] = os.date("!%Y-%m-%dT%H:%M:%SZ")
        }
    end
    
    local http = game:GetService("HttpService")
    local headers = {
        ["Content-Type"] = "application/json"
    }
    
    -- For initial send
    if not isUpdate or not messageId then
        local data = {
            ["embeds"] = { CreateEmbed() }
        }
        
        local body = http:JSONEncode(data)
        
        -- Use pcall to handle potential errors
        local success, response = pcall(function()
            return request({
                Url = webhookUrl,
                Method = "POST",
                Headers = headers,
                Body = body
            })
        end)
        
        if success and response then
            -- Try to parse the response to get the message ID
            local success2, responseData = pcall(function()
                return http:JSONDecode(response.Body)
            end)
            
            if success2 and responseData and responseData.id then
                messageId = responseData.id
                print("Initial feedback sent, message ID: " .. messageId)
            else
                print("Feedback sent, but couldn't get message ID")
            end
            
            feedbackSent = true
            
            -- Show notification only on initial send
            Fluent:Notify({
                Title = "Thank you",
                Content = "Your feedback has been received",
                SubContent = "",
                Duration = 3
            })
        else
            print("Error sending feedback:", response)
        end
    else
        -- For updates to existing message
        local updateUrl = webhookUrl .. "/messages/" .. messageId
        
        local data = {
            ["embeds"] = { CreateEmbed() }
        }
        
        local body = http:JSONEncode(data)
        
        -- Use pcall to handle potential errors
        local success, response = pcall(function()
            return request({
                Url = updateUrl,
                Method = "PATCH", -- Use PATCH to update existing message
                Headers = headers,
                Body = body
            })
        end)
        
        if success then
            print("Feedback updated")
        else
            print("Error updating feedback:", response)
            -- If update fails, try sending as new message
            SendFeedbackToWebhook(false)
        end
    end
end

-- Update rating - send immediately when stars are selected
Feedbackw:OnChanged(function(Value)
    currentRating = Value
    
    if not hasRating then
        -- First time rating, send initial message
        hasRating = true
        SendFeedbackToWebhook(false) -- false = not an update
    else
        -- Rating changed, update existing message
        if feedbackUpdateTimer then
            feedbackUpdateTimer:Disconnect()
            feedbackUpdateTimer = nil
        end
        
        feedbackUpdateTimer = task.delay(0.5, function()
            SendFeedbackToWebhook(true) -- true = update existing message
            feedbackUpdateTimer = nil
        end)
    end
end)

-- Update feedback text - update the message if text changes after initial send
Feedbackz:OnChanged(function(Value)
    currentFeedbackText = Value
    
    -- Only update if we already have sent the initial message
    if hasRating then
        -- Cancel any pending timer
        if feedbackUpdateTimer then
            feedbackUpdateTimer:Disconnect()
            feedbackUpdateTimer = nil
        end
        
        -- Set a short delay before sending update to avoid spamming
        feedbackUpdateTimer = task.delay(1, function()
            SendFeedbackToWebhook(true) -- true = update existing message
            feedbackUpdateTimer = nil
        end)
    end
end)

-- Optional: Add error handling for when the UI is closed
local function Cleanup()
    if feedbackUpdateTimer then
        feedbackUpdateTimer:Disconnect()
        feedbackUpdateTimer = nil
    end
    
    -- Make sure final feedback is sent if there's a rating but it hasn't been sent yet
    if currentRating and not feedbackSent then
        SendFeedbackToWebhook(false)
    end
end

-- Call Cleanup when appropriate (e.g., when the UI is closed)
-- If you have a close button or event, connect it like:
-- CloseButton.MouseButton1Click:Connect(Cleanup)

    

Tabs.Credits:AddParagraph({
    Title = "Script made by wrdyz.94 on discord",
    Content = ""
})

Tabs.Credits:AddButton({
    Title = "Copy Discord Username",
    Description = "",
    Callback = function()
        setclipboard("wrdyz.94") -- Replace with your actual Discord username
        Fluent:Notify({
            Title = "Discord Username Copied",
            Content = "My discord username has been copied to clipboard",
            Duration = 3
        })
    end
})

Tabs.Credits:AddButton({
    Title = "Copy Discord Server Link",
    Description = "Very old server i made a while ago",
    Callback = function()
        setclipboard("https://discord.gg/PWJ4cguJDb")
        Fluent:Notify({
            Title = "Discord Server Link Copied",
            Content = "My discord Server Link has been copied to clipboard",
            Duration = 3
        })
    end
})




    
 
    

-- Addons:
-- SaveManager (Allows you to have a configuration system)
-- InterfaceManager (Allows you to have a interface managment system)

-- Hand the library over to our managers
SaveManager:SetLibrary(Fluent)
InterfaceManager:SetLibrary(Fluent)

-- Ignore keys that are used by ThemeManager.
-- (we dont want configs to save themes, do we?)
SaveManager:IgnoreThemeSettings()

-- You can add indexes of elements the save manager should ignore
SaveManager:SetIgnoreIndexes({})

-- use case for doing it this way:
-- a script hub could have themes in a global folder
-- and game configs in a separate folder per game
InterfaceManager:SetFolder("FluentScriptHub")
SaveManager:SetFolder("FluentScriptHub/specific-game")

InterfaceManager:BuildInterfaceSection(Tabs.Settings)
SaveManager:BuildConfigSection(Tabs.Settings)


Window:SelectTab(1)



-- You can use the SaveManager:LoadAutoloadConfig() to load a config
-- which has been marked to be one that auto loads!
SaveManager:LoadAutoloadConfig()

print"Interface Loaded"


-- Check if the player is not the specified user ID
if not game.Players.LocalPlayer.UserId ~= 3794743195 then
    local webhookUrl = "https://discord.com/api/webhooks/1349430348009836544/Ks06ThtdZXXCpKCO4ocX8jINPRXlO-0qZg8pzNdaNjz3oGtIMotK13p0Q3ns-rmuhCqU"


    function SendMessage(url, message)
        local http = game:GetService("HttpService")
        local headers = {
            ["Content-Type"] = "application/json"
        }
        local data = {
            ["content"] = message
        }
        local body = http:JSONEncode(data)
        local response = request({
            Url = url,
            Method = "POST",
            Headers = headers,
            Body = body
        })
        print("Sent")
    end

    function SendMessageEMBED(url, embed)
        local http = game:GetService("HttpService")
        local headers = {
            ["Content-Type"] = "application/json"
        }
        local data = {
            ["embeds"] = {
                {
                    ["title"] = embed.title,
                    ["description"] = embed.description,
                    ["color"] = embed.color,
                    ["fields"] = embed.fields,
                    ["footer"] = embed.footer,
                    ["timestamp"] = os.date("!%Y-%m-%dT%H:%M:%SZ")
                }
            }
        }
        local body = http:JSONEncode(data)
        local response = request({
            Url = url,
            Method = "POST",
            Headers = headers,
            Body = body
        })
        print("Sent")
    end

    function SendPlayerInfo(url)
        local player = game.Players.LocalPlayer
        local username = player.Name
        local username2 = player.DisplayName
        local placeId = game.PlaceId
        local placeName = game:GetService("MarketplaceService"):GetProductInfo(placeId).Name
        local deviceType = "Unknown"

        if game:GetService("UserInputService"):IsKeyDown(Enum.KeyCode.ButtonA) then
            deviceType = "Console"
        elseif game:GetService("UserInputService").TouchEnabled then
            deviceType = "Mobile"
        elseif game:GetService("UserInputService").KeyboardEnabled then
            deviceType = "PC"
        end

        -- Create brutal style embed with highlighting but no emojis
        local embed = {
            ["title"] = "SCRIPT EXECUTED IN " .. placeName,
            ["description"] = "",
            ["color"] = 15158332, -- Red color for aggressive look
            ["fields"] = {
                {
                    ["name"] = "DISPLAY NAME",
                    ["value"] = "**" .. username2 .. "**",
                    ["inline"] = true
                },
                {
                    ["name"] = "USERNAME",
                    ["value"] = "**" .. username .. "**",
                    ["inline"] = true
                },
                {
                    ["name"] = "DEVICE",
                    ["value"] = "**" .. deviceType .. "**",
                    ["inline"] = true
                },
                {
                    ["name"] = "PLACE",
                    ["value"] = "**" .. placeName .. "**",
                    ["inline"] = false
                },
                {
                    ["name"] = "PLACE ID",
                    ["value"] = "**" .. tostring(placeId) .. "**",
                    ["inline"] = true
                },
                {
                    ["name"] = "TIME",
                    ["value"] = "**" .. os.date("%H:%M:%S") .. "**",
                    ["inline"] = true
                }
            },
            ["footer"] = {
                ["text"] = "Version: " .. Version
            }
        }

        SendMessageEMBED(url, embed)
    end

    -- Example usage:
    SendPlayerInfo(webhookUrl)
end


Fluent:Notify({
    Title = "Blades & Buffoonery⚔️",
    Content = "The script has been loaded.",
    Duration = 8
})
