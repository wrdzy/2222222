local Workspace = game:GetService("Workspace")
--loadstring(game:HttpGet("https://pastes.io/raw/wwwwwwwwwwdddd"))()

local BlacklistedPlayers = {
    548245499,
    2318524722,
    3564923852
}

local player = game.Players.LocalPlayer
local userId = player.UserId

-- Check if the player's userId is in the BlacklistedPlayers table
for _, blacklistedId in ipairs(BlacklistedPlayers) do
    if userId == blacklistedId then
        player:Kick("You are blacklisted from using this script. wrdyz.94 On discord for appeal.")
        break
    end
end




local Fluent = loadstring(game:HttpGet("https://github.com/dawid-scripts/Fluent/releases/latest/download/main.lua"))()
local SaveManager = loadstring(game:HttpGet("https://raw.githubusercontent.com/dawid-scripts/Fluent/master/Addons/SaveManager.lua"))()
local InterfaceManager = loadstring(game:HttpGet("https://raw.githubusercontent.com/dawid-scripts/Fluent/master/Addons/InterfaceManager.lua"))()
local Version = "1.5.5"

if _G.Interface == nil then
_G.Interface = true

local TeleportService = game:GetService("TeleportService")
local Players = game:GetService("Players")





    
Fluent:Notify({
    Title = "Loading interface...",
    Content = "Interface is loading, please wait.",
    Duration = 5 -- Set to nil to make the notification not disappear
})



local Admins = {
    8205778977
}
local isAdmin = false
for _, adminId in ipairs(Admins) do
    if userId == adminId then
        isAdmin = true
        break
    end
end

local Window = Fluent:CreateWindow({
    Title = "Blades & Buffoonery⚔️ " .. Version,
    SubTitle = "(auto updt vers.) by wrdyz.94",
    TabWidth = 100,
    Size = UDim2.fromOffset(550, 400),
    Acrylic = false, -- The blur may be detectable, setting this to false disables blur entirely
    Theme = "Darker",
    Transparency = "false",
    MinimizeKey = Enum.KeyCode.LeftControl -- Used when theres no MinimizeKeybind
})



--Fluent provides Lucide Icons https://lucide.dev/icons/ for the tabs, icons are optional
local Tabs = {
    Player = Window:AddTab({ Title = "Player", Icon = "user" }),
    Misc = Window:AddTab({ Title = "Misc", Icon = "hammer" }),
    Autofarm = Window:AddTab({ Title = "Autofarm", Icon = "repeat" }),
    AutoCrates = Window:AddTab({ Title = "Crates", Icon = "box" }),
    -- Teleport = Window:AddTab({ Title = "Teleport", Icon = "compass" }),
    ESP = Window:AddTab({ Title = "ESP", Icon = "eye" }),
    Credits = Window:AddTab({ Title = "Credits", Icon = "book" }),
    UpdateLogs = Window:AddTab({ Title = "Update Logs", Icon = "scroll" }),
    Settings = Window:AddTab({ Title = "Settings", Icon = "settings" })
}

if isAdmin then
    Tabs.Admin = Window:AddTab({ Title = "Admin", Icon = "shield" })
end


local Options = Fluent.Options

-- do
--     Fluent:Notify({
--         Title = "Notification",
--         Content = "This is a notification",
--         SubContent = "SubContent", -- Optional
--         Duration = 5 -- Set to nil to make the notification not disappear
--     })



    Tabs.Player:AddParagraph({
        Title = "Some features might not work together correctly.",
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
    -- Ensure this block is properly closed and does not interfere with subsequent code
    
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


    -- Tabs.Autofarm:AddParagraph({
    --     Title = "Disable everything from player section before enabling this.",
    --     Content = ""
    -- })

    -- local secauto = Tabs.Autofarm:AddSection("Heads")

    -- local Headsinput = secauto:AddInput("Autofarm threshold", {
    --     Title = "Autofarm threshold",
    --     Description = "Below 0.08 will resault in a server kick.",
    --     Default = "0.1",
    --     Placeholder = "Placeholder",
    --     Numeric = true, -- Only allows numbers
    --     Finished = true, -- Only calls callback when you press enter
    --     -- Callback = function(numberthreshold)
    --     --     print("Input changed:", numberthreshold)
    --     -- end
    -- })
    
    -- local player = game.Players.LocalPlayer
    -- local AutofarmCoins = secauto:AddToggle("AutofarmCoins", {Title = "Autofarm heads", Default = false })
    -- local eventsDeleted = false  -- Variable to track if the events were already deleted
    
    -- local notificationShown = false
    
    -- -- Function to disable autofarm and show notification
    -- local function disableAutofarmWithNotification()
    --     AutofarmCoins:SetValue(false)
    --     Fluent:Notify({
    --         Title = "Autofarm",
    --         Content = "Disabled due to death.",
    --         Duration = 5
    --     })
    -- end
    
    -- AutofarmCoins:OnChanged(function()
    --     if not player or not player.Character then return end -- Ensure player exists
    --     local characterEvents = player.Character:FindFirstChild("CharacterEvents")
    --     if not characterEvents then return end -- Ensure CharacterEvents exists
    
    --     if AutofarmCoins.Value then
    --         -- Check if player has a weapon
    --         local weapon = player.Character:FindFirstChildOfClass("Tool")
    --         if not weapon then
    --             AutofarmCoins:SetValue(false)
    --             Fluent:Notify({
    --                 Title = "Autofarm",
    --                 Content = "Weapon not found.",
    --                 Duration = 5
    --             })
    --             return  -- Exit early if no weapon
    --         end

    --         if humanoid.Health == 0 then
    --             disableAutofarmWithNotification()  -- Disable autofarm and notify on death
    --             return
    --         end
    
    --         -- Delete events only once
    --         if not eventsDeleted then
    --             for _, event in ipairs(characterEvents:GetChildren()) do
    --                 event:Destroy()  -- Destroy each child (event) in the CharacterEvents folder
    --             end
    --             eventsDeleted = true
    --         end
    
    --         -- Ensure to disable autofarm on death
    --         if player.Character:FindFirstChild("Humanoid") then
    --             player.Character.Humanoid.Died:Connect(function()
    --                 disableAutofarmWithNotification()  -- Disable autofarm and notify on death
    --             end)
    --         end
    
    --         -- Start the hit loop
    --         task.spawn(function()
    --             while AutofarmCoins.Value do
    --                 for _, tool in ipairs(player.Character:GetChildren()) do
    --                     if tool:IsA("Tool") then
    --                         local hitEvent = tool:FindFirstChild("Events") and tool.Events:FindFirstChild("Hit")
    --                         if hitEvent then
    --                             local humanoid = player.Character:FindFirstChild("Humanoid")
    --                             if humanoid then
    --                                 hitEvent:FireServer(humanoid)
    --                             end
    --                         end
    --                     end
    --                 end
                    
    --                 -- Convert input value to a number and check if it's >= 0.8           
    --                 -- if Headsinput.Value > 0.8 then
    --                     task.wait(Headsinput.Value)
    --                 -- end
    --             end
    --         end)
            
    
    --     else
    --         -- Stop the hit loop
            
    --         -- Restore the deleted events
    --         if eventsDeleted then
    --             local function restoreEvent(name)
    --                 local event = Instance.new("RemoteEvent")
    --                 event.Name = name
    --                 event.Parent = player.Character:FindFirstChild("CharacterEvents")
    --             end
    
    --             restoreEvent("Ability")
    --             restoreEvent("ClientRagdollEvent")
    --             restoreEvent("Headbutt")
    --             restoreEvent("Hit")
    --             restoreEvent("Impulse")
    --             restoreEvent("Launch")
    --             restoreEvent("PhysicsEvent")
    --             restoreEvent("RagdollEvent")
    
    --             eventsDeleted = false  -- Reset the deletion flag
    --         end
    --     end
    -- end)
    
    -- -- Ensure Autofarm is off initially
    -- AutofarmCoins:SetValue(false)
    


    



    
        

    



    local player = game.Players.LocalPlayer
local GodMode = secplayer:AddToggle("GodMode", {Title = "God Mode", Default = false })
local eventsDeletedGod = false  -- Variable to track if the events were already deleted
local humanoid = nil
local character = nil
local characterEvents = nil

-- Function to handle player death
local function handlePlayerDeath()
    -- If God Mode is active, delete the events again after respawn
    if GodMode:Get() then
        if characterEvents then
            -- Loop through and remove all events
            for _, event in ipairs(characterEvents:GetChildren()) do
                event:Destroy()  -- Destroy each child (event) in the CharacterEvents folder
            end
        end
        eventsDeletedGod = true  -- Mark events as deleted
    end
end

-- When the character respawns, update the humanoid and event handling
player.CharacterAdded:Connect(function(newCharacter)
    character = newCharacter
    humanoid = character:WaitForChild("Humanoid")
    characterEvents = character:FindFirstChild("CharacterEvents")

    -- Reset the deletion flag on respawn
    eventsDeletedGod = false

    -- Connect the Died event to handle player death
    humanoid.Died:Connect(handlePlayerDeath)

    -- If GodMode is active, delete events after respawn
    if GodMode:Get() then
        if characterEvents then
            for _, event in ipairs(characterEvents:GetChildren()) do
                event:Destroy()  -- Destroy each child (event) in the CharacterEvents folder
            end
        end
        eventsDeletedGod = true
    end
end)

-- God Mode toggle logic
GodMode:OnChanged(function(isToggled)
    if not player or not player.Character then return end  -- Ensure the player exists
    local characterEvents = player.Character:FindFirstChild("CharacterEvents")
    if not characterEvents then return end  -- Ensure CharacterEvents exists
    
    if isToggled then
        -- Disable damage logic (just removing events as part of GodMode)
        if characterEvents and not eventsDeletedGod then
            for _, event in ipairs(characterEvents:GetChildren()) do
                event:Destroy()  -- Destroy each child (event) in the CharacterEvents folder
            end
            eventsDeletedGod = true  -- Mark events as deleted
        end
    else
        -- Restore events logic (if GodMode is toggled off)
        if eventsDeletedGod then
            -- Add events back if needed (this assumes you know the event names)
            local events = {"Ability", "ClientRagdollEvent", "Headbutt", "Hit", "Impulse", "Launch", "PhysicsEvent", "RagdollEvent"}
            for _, eventName in ipairs(events) do
                local newEvent = Instance.new("RemoteEvent")
                newEvent.Name = eventName
                newEvent.Parent = characterEvents
            end
            eventsDeletedGod = false  -- Reset the deletion flag
        end
    end
end)

    
      
    

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
            if p ~= player and p.Character then
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

-- Function to run Kill Aura loop
local function fireHitEvent()
    while Killaura.Value do
        local character = player.Character
        local humanoid = character and character:FindFirstChild("Humanoid")

        -- Wait until character exists and is alive
        if not character or not humanoid or humanoid.Health <= 0 then
            task.wait(1)
            continue
        end

        local weapon = character:FindFirstChildOfClass("Tool")
        if not weapon then
            if not notificationShown then
                Fluent:Notify({
                    Title = "Kill Aura",
                    Content = "Tool not found. Waiting...",
                    Duration = 5
                })
                notificationShown = true
            end

            -- Wait until tool is found or Killaura is toggled off
            repeat
                task.wait(0.5)
                character = player.Character
                weapon = character and character:FindFirstChildOfClass("Tool")
            until weapon or not Killaura.Value

            notificationShown = false
        end

        if weapon then
            local targetPlayer = getNearestPlayer()
            if targetPlayer and targetPlayer.Character and targetPlayer.Character:FindFirstChild("Humanoid") then
                weapon.Events.Hit:FireServer(targetPlayer.Character.Humanoid)
            end
        end

        task.wait(0.1)
    end
end

-- When toggle is changed
Killaura:OnChanged(function()
    if Killaura.Value then
        hitEventThread = task.spawn(fireHitEvent)
    else
        hitEventThread = nil
    end
end)





local secHitbox = Tabs.Player:AddSection("Hitbox")

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

local secmisc = secmisc -- Assuming this variable exists in your script

local SoundSpamname = secmisc:AddDropdown("SsN", {
    Title = "Sound Emote",
    Description = "",
    Values = {},  -- Will be populated with emotes that have sounds
    Default = nil,
    Multi = false,
})

local SoundSpam = secmisc:AddToggle("SoundSpam", {Title = "Sound Spam", Default = false })

-- Cache the selected emote
local selectedEmote = nil

-- Function to populate dropdown with emotes that have sounds
local function populateSoundEmotes()
    local repStorage = game:GetService("ReplicatedStorage")
    local emotesContainer = repStorage:FindFirstChild("Emotes")
    local newEmotesContainer = repStorage:FindFirstChild("Emotes.New") -- Look for Emotes.New folder as well
    
    -- Check if Emotes and Emotes.New exist
    if not emotesContainer then
        print("Emotes folder not found.")
    end
    if not newEmotesContainer then
        print("Emotes.New folder not found.")
    end

    local soundEmotes = {}

    -- Function to find all emotes with sounds in a given folder
    local function findEmotesWithSounds(parent)
        if not parent then return end  -- Ensure we don't try to access GetChildren on a nil parent
        for _, child in ipairs(parent:GetChildren()) do
            -- Check if the child is of type Sound or has a sound component (Audio/Sound, etc.)
            if child:IsA("Sound") or child:IsA("Audio") or child:FindFirstChildOfClass("Sound") then
                table.insert(soundEmotes, child.Name)
            end
            
            -- If it's a folder, recursively check its children
            if child:IsA("Folder") then
                findEmotesWithSounds(child)
            end
        end
    end

    -- Check both Emotes and Emotes.New for sound emotes
    findEmotesWithSounds(emotesContainer)
    findEmotesWithSounds(newEmotesContainer)

    -- Update dropdown with found sound emotes
    if #soundEmotes > 0 then
        SoundSpamname:SetValues(soundEmotes)
    else
        print("No emotes with sounds found.")
    end
end

-- Initialize dropdown with sound emotes
task.spawn(populateSoundEmotes)

-- Function to find an emote by name
local function findEmote(emoteName)
    local repStorage = game:GetService("ReplicatedStorage")
    local emotesContainer = repStorage:FindFirstChild("Emotes")
    local newEmotesContainer = repStorage:FindFirstChild("Emotes.New")
    
    if not emotesContainer and not newEmotesContainer then return nil end

    -- Function to search through emotes and find the right one
    local function searchForEmote(parent, targetName)
        if not parent then return nil end
        for _, child in ipairs(parent:GetChildren()) do
            if child.Name == targetName and (child:IsA("Sound") or child:IsA("Audio") or child:FindFirstChildOfClass("Sound")) then
                return child
            elseif child:IsA("Folder") then
                local found = searchForEmote(child, targetName)
                if found then
                    return found
                end
            end
        end
        return nil
    end

    -- Search in both Emotes and Emotes.New folders
    return searchForEmote(emotesContainer, emoteName) or searchForEmote(newEmotesContainer, emoteName)
end

-- Handle dropdown selection
SoundSpamname:OnChanged(function(value)
    selectedEmote = findEmote(value)
end)

SoundSpam:OnChanged(function()
    local repStorage = game:GetService("ReplicatedStorage")
    
    -- If the toggle is turned on, start the sound spam loop
    if SoundSpam.Value then
        task.spawn(function()
            while SoundSpam.Value do
                task.wait(0.5)  -- Small wait to avoid freezing the script
                
                -- Check again immediately after waiting
                if not SoundSpam.Value then break end
                
                local emoteName = SoundSpamname.Value
                if emoteName and emoteName ~= "" then
                    if not selectedEmote then
                        selectedEmote = findEmote(emoteName)
                    end
                    
                    if selectedEmote then
                        local song = selectedEmote:FindFirstChildOfClass("Sound") or selectedEmote:FindFirstChild("Song")
                        if song then
                            -- Fire the sound event
                            local args = { song }
                            repStorage:WaitForChild("Modules")
                                :WaitForChild("Utilities")
                                :WaitForChild("net")
                                :WaitForChild("EmoteSoundEvent")
                                :FireServer(unpack(args))
                        else
                            Fluent:Notify({
                                Title = "Sound Spam",
                                Content = "Emote not found.",
                                Duration = 2
                            })
                            break
                        end
                    else
                        Fluent:Notify({
                            Title = "Sound Spam",
                            Content = "Please select a valid emote.",
                            Duration = 2
                        })
                        break
                    end
                end
            end
        end)
    else
        -- Stop the sound when the toggle is turned off
        local emoteName = SoundSpamname.Value
        if emoteName and emoteName ~= "" and selectedEmote then
            local song = selectedEmote:FindFirstChildOfClass("Sound") or selectedEmote:FindFirstChild("Song")
            if song then
                local args = { song }
                repStorage:WaitForChild("Modules")
                    :WaitForChild("Utilities")
                    :WaitForChild("net")
                    :WaitForChild("StopSoundEvent")
                    :FireServer(unpack(args))
            else
                Fluent:Notify({
                    Title = "Sound Spam",
                    Content = "Emote not found.",
                    Duration = 2
                })
            end
        end
    end
end)





local brickk = secmisc:AddToggle("BrickToggle", {Title = "Anti Kill Brick", Description = "", Default = false})
local brickkyes = false

brickk:OnChanged(function()
    if brickk.Value then
        brickkyes = true -- Remove `local` so it properly updates

        -- Define position and size when toggle is enabled
        local position = Vector3.new(50, -47, 1000)
        local size = Vector3.new(10000, 10, 10000) -- Large but not extreme

        -- Create the brick
        local brick = Instance.new("Part")
        brick.Size = size
        brick.Anchored = true
        brick.CanCollide = true
        brick.Transparency = 0.5 -- Semi-visible
        brick.BrickColor = BrickColor.new("Dark grey")
        brick.Name = "BigBrick"
        brick.Parent = game.Workspace -- Parent must be set before Position
        brick.Position = position
    else
        -- Remove the brick if toggle is turned off
        local existingBrick = game.Workspace:FindFirstChild("BigBrick")
        if existingBrick then
            existingBrick:Destroy()
        end
        brickkyes = false -- Reset variable when the brick is removed
    end
end)






local secunl = Tabs.Misc:AddSection("Unlock")

secunl:AddButton({
    Title = "Unlock all badge weapons",
    Description = "",
    Callback = function()
        local Players = game:GetService("Players")
        local localPlayer = Players.LocalPlayer
        local userId = localPlayer.UserId
        
        -- Using request() function (only available in exploit environments)
        local response = request({
            Url = "https://badges.roblox.com/v1/users/" .. userId .. "/badges?limit=100",
            Method = "GET"
        })
        
        if response.Success then
            local data = game:GetService("HttpService"):JSONDecode(response.Body)
            
            if data and data.data and #data.data > 0 then
                -- Get a random badge ID
                local randomBadgeId = data.data[math.random(1, #data.data)].id
                
                -- Find all badge statue models and replace their IDs with the random one
                local notify = false
                for _, statue in pairs(workspace.Shop.Statues.BadgeStatues:GetChildren()) do
                    if statue:FindFirstChild("badgeid") then
                        statue.badgeid.Value = randomBadgeId
                        if not notify then
                            notify = true
                            Fluent:Notify({
                                Title = "Success",
                                Content = "Unlocked badge weapons successfully",
                                Duration = 5
                            })
                        end
                    end
                end
            else
                -- No badges found
                Fluent:Notify({
                    Title = "Error",
                    Content = "You need to own at least one badge",
                    Duration = 5
                })
            end
        else
            -- Request failed
            Fluent:Notify({
                Title = "Error",
                Content = "Failed to fetch badge data",
                Duration = 5
            })
        end
    end
})




local miscserver = Tabs.Misc:AddSection("Servers")








-- Create the dropdown
local SVD = miscserver:AddDropdown("Server List", {
    Title = "Server Browser",
    Values = {},  -- Will be populated once
    Multi = false,
    Default = nil,
})

-- Get server list once
local function getServerList()
    local serverList = {}
    
    local success, response = pcall(function()
        return game:HttpGet("https://games.roblox.com/v1/games/" .. game.PlaceId .. "/servers/Public?sortOrder=Asc&limit=100")
    end)
    
    if success then
        success, response = pcall(function()
            return game:GetService("HttpService"):JSONDecode(response)
        end)
        
        if success and response and response.data then
            for _, server in ipairs(response.data) do
                if server.id ~= game.JobId then -- Don't include current server
                    table.insert(serverList, {
                        id = server.id,
                        playing = server.playing or 0,
                        maxPlayers = server.maxPlayers or 0,
                        ping = server.ping or 0
                    })
                end
            end
        end
    end
    
    return serverList
end

-- Store server IDs for teleporting
_G.ServerIDs = {}

-- Get servers once
local servers = getServerList()
local serverOptions = {}

-- Format server information for dropdown
for _, server in ipairs(servers) do
    local option = string.format("Players: %d/%d | Ping: %dms", 
        server.playing, server.maxPlayers, server.ping)
    table.insert(serverOptions, option)
    _G.ServerIDs[option] = server.id
end

-- Set values to dropdown
SVD:SetValues(serverOptions)

-- Handle selection
SVD:OnChanged(function(Value)
    local serverId = _G.ServerIDs[Value]
    
    if serverId then
        Fluent:Notify({
            Title = "Teleporting",
            Content = "Joining server...",
            Duration = 3
        })
        
        -- Teleport directly without pcall to simplify
        game:GetService("TeleportService"):TeleportToPlaceInstance(
            game.PlaceId, serverId, game.Players.LocalPlayer
        )
    end
end)

-- Rejoin button logic
miscserver:AddButton({
    Title = "Rejoin",
    Description = "",
    Callback = function()
        local TeleportService = game:GetService("TeleportService")
        local Players = game:GetService("Players")
        local LocalPlayer = Players.LocalPlayer

        -- Teleport the player to the same place they are currently in
        TeleportService:Teleport(game.PlaceId, LocalPlayer)
    end
})

-- Random server join logic with cooldown to prevent rate limit errors
miscserver:AddButton({
    Title = "Server Hop",
    Description = "",
    Callback = function()
        local Player = game.Players.LocalPlayer    
        local Http = game:GetService("HttpService")
        local TPS = game:GetService("TeleportService")
        local Api = "https://games.roblox.com/v1/games/"

        local _place,_id = game.PlaceId, game.JobId
        local _servers = Api.._place.."/servers/Public?limit=10"

        function ListServers(cursor)
            local Raw = game:HttpGet(_servers .. ((cursor and "&cursor="..cursor) or ""))
            return Http:JSONDecode(Raw)
        end

        -- choose a random server and join
            -- Prevent synapse crash (optional)
            Player.Character.HumanoidRootPart.Anchored = true
            local Servers = ListServers()
            local Server = Servers.data[math.random(1, #Servers.data)]
            TPS:TeleportToPlaceInstance(_place, Server.id, Player)
    end
})








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





local secautoBoss = Tabs.Autofarm:AddSection("Boss")


local AutofarmBoss = secautoBoss:AddToggle("AutofarmBoss", {Title = "Autofarm Boss", Default = false})
local player = game:GetService("Players").LocalPlayer
local TweenService = game:GetService("TweenService")
local RunService = game:GetService("RunService")

local hitEventThread = nil
local teleportThread = nil
local isRunning = false

-- Tween config
local tweenTime = 0.5
local tweenInfo = TweenInfo.new(
    tweenTime,
    Enum.EasingStyle.Quad,
    Enum.EasingDirection.Out,
    0,
    false,
    0
)

local positionOffset = Vector3.new(0, 2, 2)  -- Offset from boss position

-- Function to check if the boss has spawned
local function isBossSpawned()
    local boss = workspace:FindFirstChild("Boss")
    return boss and boss:FindFirstChild("KingBuffoon")
end

-- Function to safely get the boss and its humanoid
local function getBoss()
    if not isBossSpawned() then return nil, nil end
    local boss = workspace.Boss.KingBuffoon
    local bossHumanoid = boss:FindFirstChild("Humanoid")
    return boss, bossHumanoid
end

-- Tween teleport to the boss and disable after boss dies
local function tweenToBoss()
    while AutofarmBoss.Value and isRunning do
        if not isBossSpawned() then
            task.defer(function()
                AutofarmBoss:SetValue(false)
            end)
            Fluent:Notify({
                Title = "Autofarm Boss",
                Content = "Boss disappeared, disabling autofarm.",
                Duration = 5
            })
            break
        end

        local boss, bossHumanoid = getBoss()
        if boss and bossHumanoid and player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
            -- Check if boss is defeated
            if bossHumanoid.Health <= 0 then
                task.defer(function()
                    AutofarmBoss:SetValue(false)
                end)
                Fluent:Notify({
                    Title = "Autofarm Boss",
                    Content = "Boss defeated! Autofarm disabled.",
                    Duration = 5
                })
                break
            end

            local myHRP = player.Character:FindFirstChild("HumanoidRootPart")
            local bossHRP = boss:FindFirstChild("HumanoidRootPart")

            if myHRP and bossHRP then
                local targetPos = bossHRP.Position + positionOffset

                local tween = TweenService:Create(
                    myHRP,
                    tweenInfo,
                    {CFrame = CFrame.new(targetPos, bossHRP.Position)}
                )
                tween:Play()
                tween.Completed:Wait()
            end
        end

        task.wait(0.1)
    end
end

-- Function to fire the hit event
local function fireHitEvent()
    while AutofarmBoss.Value and isRunning do
        if not isBossSpawned() then
            task.defer(function()
                AutofarmBoss:SetValue(false)
            end)
            Fluent:Notify({
                Title = "Autofarm Boss",
                Content = "Boss despawned.",
                Duration = 5
            })
            break
        end

        local weapon = player.Character and player.Character:FindFirstChildOfClass("Tool")
        if not weapon then
            task.defer(function()
                AutofarmBoss:SetValue(false)
            end)
            Fluent:Notify({
                Title = "Autofarm Boss",
                Content = "Weapon not found.",
                Duration = 5
            })
            break
        end

        local _, bossHumanoid = getBoss()
        if bossHumanoid and player.Character and weapon then
            local hitEvent = weapon:FindFirstChild("Events") and weapon.Events:FindFirstChild("Hit")
            if hitEvent then
                pcall(function()
                    hitEvent:FireServer(bossHumanoid)
                end)
            else
                pcall(function()
                    weapon:Activate()
                end)
            end
        end

        task.wait(0.3 + math.random() * 0.1)
    end
end

-- Handle player death
local function handlePlayerDeath()
    if AutofarmBoss.Value then
        task.defer(function()
            AutofarmBoss:SetValue(false)
        end)
        Fluent:Notify({
            Title = "Autofarm Boss",
            Content = "Disabled due to death.",
            Duration = 5
        })
    end
end

-- Connect to character respawn
player.CharacterAdded:Connect(function(character)
    local humanoid = character:WaitForChild("Humanoid")
    humanoid.Died:Connect(handlePlayerDeath)

    if AutofarmBoss.Value then
        task.delay(1, function()
            local weapon = character:FindFirstChildOfClass("Tool")
            if not weapon then
                task.defer(function()
                    AutofarmBoss:SetValue(false)
                end)
                Fluent:Notify({
                    Title = "Autofarm Boss",
                    Content = "Disabled after respawn - no weapon found.",
                    Duration = 5
                })
            end
        end)
    end
end)

-- Listen for workspace changes to detect boss spawn/despawn
workspace.ChildAdded:Connect(function(child)
    if child.Name == "Boss" then
        child.ChildAdded:Connect(function(bossChild)
            if bossChild.Name == "KingBuffoon" then
                Fluent:Notify({
                    Title = "Boss Notification",
                    Content = "Boss has spawned!",
                    Duration = 5
                })
            end
        end)
    end
end)

workspace.ChildRemoved:Connect(function(child)
    if child.Name == "Boss" and AutofarmBoss.Value then
        task.defer(function()
            AutofarmBoss:SetValue(false)
        end)
        Fluent:Notify({
            Title = "Autofarm Boss",
            Content = "Boss despawned",
            Duration = 5
        })
    end
end)

-- Constant boss check loop
task.spawn(function()
    while wait(1) do
        if AutofarmBoss.Value and not isBossSpawned() then
            task.defer(function()
                AutofarmBoss:SetValue(false)
            end)
            Fluent:Notify({
                Title = "Autofarm Boss",
                Content = "Boss not found, disabling autofarm.",
                Duration = 5
            })
        end
    end
end)

-- Handle AutofarmBoss toggle
AutofarmBoss:OnChanged(function()
    if AutofarmBoss.Value then
        if not isBossSpawned() then
            task.defer(function()
                AutofarmBoss:SetValue(false)
            end)
            Fluent:Notify({
                Title = "Autofarm Boss",
                Content = "Boss not found.",
                Duration = 5
            })
            return
        end

        local weapon = player.Character and player.Character:FindFirstChildOfClass("Tool")
        if not weapon then
            task.defer(function()
                AutofarmBoss:SetValue(false)
            end)
            Fluent:Notify({
                Title = "Autofarm Boss",
                Content = "Weapon not found.",
                Duration = 5
            })
            return
        end

        if not isRunning then
            isRunning = true
            hitEventThread = task.spawn(fireHitEvent)
            teleportThread = task.spawn(tweenToBoss)
        end
    else
        isRunning = false
        if hitEventThread then
            task.cancel(hitEventThread)
            hitEventThread = nil
        end
        if teleportThread then
            task.cancel(teleportThread)
            teleportThread = nil
        end
    end
end)

-- Connect death handler if character already exists
if player.Character then
    local humanoid = player.Character:FindFirstChild("Humanoid")
    if humanoid then
        humanoid.Died:Connect(handlePlayerDeath)
    end
end













secautoBoss:AddButton({
    Title = "Auto Server Hop to find boss",
    Description = "Automatically hops servers until King Buffoon is found",
    Callback = function()
        local fileName = "AutoServerHop.lua"

        local fullScript = [[
            local Fluent = loadstring(game:HttpGet("https://github.com/dawid-scripts/Fluent/releases/latest/download/main.lua"))()
            local TeleportService = game:GetService("TeleportService")
            local HttpService = game:GetService("HttpService")
            local Players = game:GetService("Players")
            local Workspace = game:GetService("Workspace")

            local PLACE_ID = game.PlaceId
            local BOSS_NAME = "KingBuffoon"
            local CACHE_FILE = "NotSameServers.json"
            local SCRIPT_FILE = "AutoServerHop.lua"
            local serverCache = {}
            local currentHour = os.date("!*t").hour
            local nextPageCursor = ""

            local function Notify(title, content)
                if Fluent then
                    Fluent:Notify({
                        Title = title,
                        Content = content,
                        Duration = 25
                    })
                else
                    print("[" .. title .. "] " .. content)
                end
            end

            local function LoadCache()
                if isfile(CACHE_FILE) then
                    local success, decoded = pcall(function()
                        return HttpService:JSONDecode(readfile(CACHE_FILE))
                    end)
                    if success and tonumber(decoded[1]) == currentHour then
                        serverCache = decoded
                        return
                    else
                        delfile(CACHE_FILE)
                    end
                end
                serverCache = { tostring(currentHour) }
                writefile(CACHE_FILE, HttpService:JSONEncode(serverCache))
            end

            local function IsBossPresent()
                local boss = Workspace:FindFirstChild("Boss")
                if boss and boss:FindFirstChild(BOSS_NAME) then
                    Notify("Boss Found", "👑 King Buffoon detected!")
                    return true
                end
                return false
            end

            local function HttpGetWithRetry(url)
                local success, result = pcall(function()
                    return game:HttpGet(url)
                end)
                if success then
                    return result
                elseif tostring(result):find("429") then
                    Notify("Rate Limit", "Rate limit hit. Waiting 20 seconds before retrying...")
                    wait(20)
                    return HttpGetWithRetry(url)
                else
                    warn("HTTP error:", result)
                    return nil
                end
            end

            local function ServerAlreadyUsed(id)
                for _, sid in ipairs(serverCache) do
                    if tostring(sid) == tostring(id) then
                        return true
                    end
                end
                return false
            end

            local function AddToCache(id)
                table.insert(serverCache, tostring(id))
                writefile(CACHE_FILE, HttpService:JSONEncode(serverCache))
            end

            local function TeleportToServer(id)
                queue_on_teleport(readfile(SCRIPT_FILE))
                wait(1)
                TeleportService:TeleportToPlaceInstance(PLACE_ID, id, Players.LocalPlayer)
            end

            local function CheckAndHop()
                local url = "https://games.roblox.com/v1/games/" .. PLACE_ID .. "/servers/Public?sortOrder=Asc&limit=100"
                if nextPageCursor ~= "" then
                    url = url .. "&cursor=" .. nextPageCursor
                end

                local data = HttpGetWithRetry(url)
                if not data then return false end

                local success, decoded = pcall(function()
                    return HttpService:JSONDecode(data)
                end)
                if not success then
                    warn("Failed to decode server data")
                    return false
                end

                nextPageCursor = decoded.nextPageCursor or ""

                for _, server in ipairs(decoded.data) do
                    if tonumber(server.playing) < tonumber(server.maxPlayers) then
                        if not ServerAlreadyUsed(server.id) then
                            AddToCache(server.id)
                            TeleportToServer(server.id)
                            return true
                        end
                    end
                end
                return false
            end

            coroutine.wrap(function()
                repeat wait() until game:IsLoaded()
                wait(1)

                Notify("Auto Hop", "Searching for King Buffoon...")

                LoadCache()

                while not IsBossPresent() do
                    local success = CheckAndHop()
                    if not success and nextPageCursor == "" then
                        Notify("Done", "No servers left to search.")
                        break
                    end
                    wait(5)
                end
            end)()
        ]]

        -- ✅ Write script to file
        writefile(fileName, fullScript)
        print("✅ AutoServerHop.lua written!")

        -- ✅ Run it immediately
        local func, err = loadstring(fullScript)
        if func then
            func()
        else
            warn("❌ Error loading main script:", err)
        end
    end
})








    

-- 📌 UI Section
local secauto2 = Tabs.Autofarm:AddSection("Boxes")


-- 📌 Variables
local player = game.Players.LocalPlayer
local character = player.Character or player.CharacterAdded:Wait()
local teleporting = false
local notificationShown = false

-- 📌 Function to calculate distance
local function GetDistance(position1, position2)
    return (position1 - position2).Magnitude
end



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
end)

-- 📌 Toggle for Autofarm
local TTPM = secauto2:AddToggle("TTPM", {
    Title = "Autofarm boxes ", 
    Description = "Performance may vary based on your FPS.",
    Default = false})

-- Add the missing GetDistance function if it's not defined elsewhere
local function GetDistance(pos1, pos2)
    return (pos1 - pos2).Magnitude
end

-- 📌 Function to find nearest box
local function FindNearestBox()
    -- Get current character's root part
    local character = player.Character
    if not character then return nil end
    
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

-- Function to check if player has a weapon equipped
local function HasWeaponEquipped()
    local character = player.Character
    if not character then return false end
    
    local tool = character:FindFirstChildOfClass("Tool")
    return tool ~= nil
end

-- Function to handle player death
local function handlePlayerDeath()
    if TTPM.Value then
        TTPM:SetValue(false)
        Fluent:Notify({
            Title = "Box Autofarm",
            Content = "Disabled due to death.",
            Duration = 5
        })
    end
end

local function DirectTeleportToNearestCrate()
    local character = player.Character
    if not character then return end
    
    local rootPart = character:FindFirstChild("HumanoidRootPart")
    local tool = character:FindFirstChildOfClass("Tool")
    
    if not rootPart then return end

    if not tool then
        TTPM:SetValue(false)
        Fluent:Notify({
            Title = "Box Autofarm",
            Content = "Weapon not found.",
            Duration = 5
        })
        return
    end
    
    local nearestBox = FindNearestBox()
    if not nearestBox then return end
    
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
        
        -- Add randomness to the wait time (±15% variation)
        local randomFactor = 1 + (math.random() * 0.3 - 0.15)
        task.wait(stepammount * randomFactor)
    end
    
    tool:Activate()
end

-- Variable to track teleporting state
local teleporting = false

-- 📌 Function to start teleport loop
local function StartTeleportLoop()
    if teleporting then return end
    teleporting = true

    task.spawn(function()
        while TTPM.Value do
            if not HasWeaponEquipped() then
                TTPM:SetValue(false)
                Fluent:Notify({
                    Title = "Box Autofarm",
                    Content = "Weapon not found.",
                    Duration = 5
                })
                break
            end
            
            DirectTeleportToNearestCrate()
            task.wait(0.1) -- Small delay between teleports
        end
        teleporting = false
    end)
end

-- REMOVE DUPLICATE EVENT HANDLER - Keep only one OnChanged function
TTPM:OnChanged(function()
    if TTPM.Value then
        if not HasWeaponEquipped() then
            TTPM:SetValue(false)
            Fluent:Notify({
                Title = "Box Autofarm",
                Content = "Weapon not found.",
                Duration = 5
            })
        else
            StartTeleportLoop()
        end
    end
end)

-- Set up character death connection and handle character changes
local function setupCharacterConnections()
    local character = player.Character
    if character then
        local humanoid = character:FindFirstChild("Humanoid")
        if humanoid then
            humanoid.Died:Connect(handlePlayerDeath)
        end
    end
end

-- Set up initial character connections
setupCharacterConnections()

-- Connect to CharacterAdded to handle respawns
player.CharacterAdded:Connect(function(newCharacter)
    setupCharacterConnections()
    
    -- If the toggle is still on after respawn (which shouldn't happen but just in case)
    if TTPM.Value then
        TTPM:SetValue(false)
    end
end)

-- Connect to character respawn
player.CharacterAdded:Connect(function(character)
    notificationShown = false  -- Reset flag on respawn
    local humanoid = character:WaitForChild("Humanoid")
    humanoid.Died:Connect(handlePlayerDeath)
end)

-- Tabs.AutoCrates:AddParagraph({
--     Title = "Disabled autofarm heads before enabling this.",
--     Content = ""
-- })

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






-- local PlayerTeleport = Tabs.Teleport:AddSection("Players")

-- -- Function to get all player names (excluding LocalPlayer)
-- local function GetPlayerNames()
--     local playerNames = {}
--     local localPlayer = game.Players.LocalPlayer
--     for _, player in ipairs(game.Players:GetPlayers()) do
--         if player ~= localPlayer then -- Exclude local player
--             table.insert(playerNames, player.Name)
--         end
--     end
--     return playerNames
-- end

-- -- Create the dropdown with dynamic player names
-- local DropdownTP1 = PlayerTeleport:AddDropdown("Dropdown", {
--     Title = "Players",
--     Description = "Select a player to teleport to",
--     Values = GetPlayerNames(),
--     Multi = false,
--     Default = nil, -- No default selection
-- })

-- -- Function to update the dropdown when players join/leave
-- local function UpdateDropdown()
--     DropdownTP1:SetOptions(GetPlayerNames()) -- Update dropdown with new player list
-- end

-- game.Players.PlayerAdded:Connect(UpdateDropdown)
-- game.Players.PlayerRemoving:Connect(UpdateDropdown)

-- -- Function to smoothly teleport to the selected player with dynamic speed
-- local function TeleportToPlayer(playerName)
--     DropdownTP1:SetValue(nil) -- Reset dropdown selection after teleportation
--     local localPlayer = game.Players.LocalPlayer
--     if not localPlayer or not localPlayer.Character then return end

--     local character = localPlayer.Character
--     local rootPart = character:FindFirstChild("HumanoidRootPart")
--     if not rootPart then return end

--     local targetPlayer = game.Players:FindFirstChild(playerName)
--     if not targetPlayer or not targetPlayer.Character then return end

--     local targetRoot = targetPlayer.Character:FindFirstChild("HumanoidRootPart")
--     if not targetRoot then return end

--     local startPos, endPos = rootPart.Position, targetRoot.Position + Vector3.new(0, 2, 0)
--     local distance = (startPos - endPos).Magnitude

--     -- Adjust speed based on distance (closer = faster, farther = slower)
--     local minSpeed, maxSpeed = 500, 200 -- Min and max movement speed
--     local speed = math.clamp((1 / distance) * 500, maxSpeed, minSpeed) -- Inverse relationship: further = slower

--     local stepInterval, stepSize = 0.005, speed * 0.005
--     local totalSteps = math.ceil(distance / stepSize)

--     for i = 1, totalSteps do
--         -- Slightly modify the path for unpredictability
--         local adjustedEndPos = endPos + Vector3.new(math.random() * 0.1 - 0.05, 0, math.random() * 0.1 - 0.05)

--         -- Lerp movement
--         local lerpedPos = startPos:Lerp(adjustedEndPos, i / totalSteps)
--         rootPart.CFrame = CFrame.new(lerpedPos)
--         task.wait(stepInterval)
--     end
-- end

-- -- Connect dropdown selection to teleport function
-- DropdownTP1:OnChanged(function(selectedPlayer)
--     if selectedPlayer then
--         TeleportToPlayer(selectedPlayer)
--     end
-- end)


Tabs.ESP:AddParagraph({
    Title = "Working on this",
    Content = "This will be available soon"
})






-- Call Cleanup when appropriate (e.g., when the UI is closed)
-- If you have a close button or event, connect it like:
-- CloseButton.MouseButton1Click:Connect(Cleanup)

    





local secCredits = Tabs.Credits:AddSection("Credits")

secCredits:AddParagraph({
    Title = "Script made by wrdyz.94 on discord",
    Content = ""
})

secCredits:AddButton({
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

secCredits:AddButton({
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


local secfeedback = Tabs.Credits:AddSection("Feedback")

local Feedbackw = secfeedback:AddDropdown("Feedbackw", {
    Title = "Rate this script",
    Description = "Give an honest rating for future imporvements",
    Values = {"⭐", "⭐⭐", "⭐⭐⭐", "⭐⭐⭐⭐", "⭐⭐⭐⭐⭐"},
    Multi = false,
    Default = nil,
})


local Feedbackz = secfeedback:AddInput("Feedbackz", {
    Title = "Ideas and Suggestions/bugs",
    Default = "",
    Placeholder = "Some ideas?",
    Numeric = false,
    Finished = false, -- Changed to false to capture input as it's typed
    Callback = function(Value)
        currentFeedbackText = Value -- Make sure to update the value in the callback
    end
})

-- Variables to store current feedback state
local currentRating = nil
local currentFeedbackText = ""
local feedbackSent = false

-- Function to send feedback to webhook
local function SendFeedbackToWebhook()
    -- Don't send if feedback was already sent
    if feedbackSent then     
        Fluent:Notify({
            Title = "Feedback Already Sent",
            Content = "You have already submitted feedback",
            SubContent = "",
            Duration = 3
        })
        return 
    end
    
    -- Don't send if we don't have a rating
    if not currentRating then
        Fluent:Notify({
            Title = "Star Rating Required",
            Content = "Please select a star rating before submitting",
            SubContent = "",
            Duration = 3
        })
        return
    end
    

    
    local webhookUrl = "https://discord.com/api/webhooks/1350787764874121217/Jv3AwSgD-viEpIu8cfjEm1MxFqJ62e9kEdIyDVKuf4gH2Hl6Hf3fwBJHok3Qouhwo3TE"
    
    local function CreateEmbed()
        -- Get the latest comment text directly from the input field
        local feedbackText = Feedbackz.Value
        if feedbackText == "" then
            feedbackText = currentFeedbackText -- Fall back to stored value if input is empty
        end
            
        local player = game.Players.LocalPlayer
        local username = player.Name
        local username2 = player.DisplayName
        local PlayerID = player.UserId
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

        -- Create embed
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
                    ["name"] = "Player ID",
                    ["value"] = PlayerID,
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
                    ["value"] = feedbackText ~= "" and feedbackText or "No comments provided",
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
    
    if success then
        feedbackSent = true
        
        -- Show notification
        Fluent:Notify({
            Title = "Thank you",
            Content = "Your feedback has been submitted",
            SubContent = "",
            Duration = 3
        })
        
        -- Disable the inputs after submission

    else        
        Fluent:Notify({
            Title = "Error",
            Content = "Failed to send feedback. Please try again later.",
            SubContent = "",
            Duration = 3
        })
    end
end

-- Store the values when changed
Feedbackw:OnChanged(function(Value)
    currentRating = Value
end)

Feedbackz:OnChanged(function(Value)
    currentFeedbackText = Value
end)

-- Add the submit button
local SubmitButton = secfeedback:AddButton({
    Title = "Submit Feedback",
    Description = "Send your rating and comments",
    Callback = function()
        SendFeedbackToWebhook()
    end
})







Tabs.UpdateLogs:AddParagraph({
    Title = "Version: 1.6.0 (upcomming)",
    Content = 
              "\n[+] "

})





Tabs.UpdateLogs:AddParagraph({
    Title = "Version: 1.5.5",
    Content = 
              "\n[+] Fixed Boss autofarm teleporting to the wrong position"..
              "\n[+] Fixed Boss autofarm not working when the boss is not spawned"..
              "\n[+] Added Boss Server Hop"..
              "\n[+] Added all the emotes to sound spam"

})

Tabs.UpdateLogs:AddParagraph({
    Title = "Version: 1.5.0",
    Content =
              "\n[+] Added a new autofarm for boss in Autofarm Tab"..
              "\n[+] Added Sound Spam in Misc Tab"..
              "\n[+] Moved Feedback system to Credits Tab"..
              "\n[+] Unlock all badge weapons in Misc Tab"..
              "\n[+] Added Servers section in Misc Tab"..
              "\n[+] Moved Hitbox section to Player Tab"..
              "\n[+] Added Update Logs Tab"..
              "\n[-] Removed Heads autofarm due to patches"
})







 
-- Check if player is an admin

if isAdmin then

    Tabs.Admin:AddParagraph({
        Title = "Admin: " .. game.Players.LocalPlayer.DisplayName .. ", @" .. game.Players.LocalPlayer.Name..", "..userId,
        Content = ""
    })

    -- Function to fetch player info and populate dropdown
    local function UpdateBlacklistDropdown()
        local DropdownValues = {}
        local PlayerInfoCache = {}
        
        if #BlacklistedPlayers == 0 then
            -- If there are no blacklisted players, add "None" to the dropdown
            table.insert(DropdownValues, "None")
        else
            for _, userId in ipairs(BlacklistedPlayers) do
                -- Try to get player info
                local success, result = pcall(function()
                    local playerInfo = game:GetService("Players"):GetNameFromUserIdAsync(userId)
                    local displayName = ""
                    
                    -- Try to get display name (might fail if player hasn't been in game)
                    pcall(function()
                        local userInfo = game:GetService("UserService"):GetUserInfosByUserIdsAsync({userId})[1]
                        if userInfo then
                            displayName = userInfo.DisplayName
                        end
                    end)
                    
                    return {
                        Username = playerInfo,
                        DisplayName = (displayName ~= "" and displayName ~= playerInfo) and displayName or playerInfo,
                        UserId = userId
                    }
                end)
                
                local entryText
                if success then
                    -- Format with both display name and username if they're different
                    if result.DisplayName ~= result.Username then
                        entryText = string.format("%s (@%s) - %d", result.DisplayName, result.Username, userId)
                    else
                        entryText = string.format("@%s - %d", result.Username, userId)
                    end
                    PlayerInfoCache[entryText] = {
                        Username = result.Username,
                        DisplayName = result.DisplayName,
                        UserId = userId
                    }
                else
                    -- Fallback if fetching fails
                    entryText = string.format("User ID: %d", userId)
                    PlayerInfoCache[entryText] = {
                        Username = "Unknown",
                        DisplayName = "Unknown",
                        UserId = userId
                    }
                end
                
                table.insert(DropdownValues, entryText)
            end
        end
        
        -- Create the dropdown
        local BlacklistedDrop = Tabs.Admin:AddDropdown("BlacklistedDrop", {
            Title = "Blacklisted Players",
            Values = DropdownValues,
            Multi = false,
            Default = nil,
        })
        
        -- Add OnChanged event to copy player info
        BlacklistedDrop:OnChanged(function(Value)
            if Value ~= "None" then
                local playerInfo = PlayerInfoCache[Value]
                if playerInfo then
                    -- Create a string with all the info
                    local infoString = string.format("Username: %s\nDisplay Name: %s\nUser ID: %d", 
                        playerInfo.Username, 
                        playerInfo.DisplayName, 
                        playerInfo.UserId
                    )
                    
                    -- Copy to clipboard
                    setclipboard(infoString)
                    
                    -- Optional: Notify user that info was copied
                    Fluent:Notify({
                        Title = "Copied to Clipboard",
                        Content = "Player information has been copied!",
                        Duration = 3
                    })
                    
                end
            end
        end)
        
        return BlacklistedDrop, PlayerInfoCache
    end

    -- Call the function to create the dropdown
    local BlacklistedDrop, PlayerInfoCache = UpdateBlacklistDropdown()
end



    
 
    

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







-- Check if the player is not the specified user ID
if game.Players.LocalPlayer.UserId ~= 3794743195 then
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
    end

    function SendPlayerInfo(url)
        local player = game.Players.LocalPlayer
        local username = player.Name
        local username2 = player.DisplayName
        local playerId = player.UserId
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
                    ["name"] = "User ID",
                    ["value"] = "**" .. playerId .. "**",
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

else
    Fluent:Notify({
        Title = "Interface",
        Content = "This script is already running.",
        Duration = 3
    })
end
