-- Load Library --
    local Library = loadstring(game:HttpGet('https://raw.githubusercontent.com/RevampedCity/Shaman-Library/refs/heads/main/Library'))()
    local Window = Library:Window({ Text = "Tha Bronx 3 Services                       #TB3K" })

-- Player
	local playerTab = Window:Tab({ Text = "Main" })
    local playerSection = playerTab:Section({ Text = "Player Options" })
	playerSection:Button({
    Text = "Instant Prompts",
    Description = "Removes the E Holding Time Anywhere",
    Callback = function()
    local function isInsideMimicATM(obj)
    local parent = obj.Parent
    while parent do
    if parent.Name == "MimicATM" then
    return true
    end
    parent = parent.Parent
    end
    return false
    end
    local function removeHoldDuration(obj)
    if obj:IsA("ProximityPrompt") and not isInsideMimicATM(obj) then
    obj.HoldDuration = 0
    end
    end
    for _, obj in ipairs(game:GetService("Workspace"):GetDescendants()) do
    removeHoldDuration(obj)
    end
    game:GetService("Workspace").DescendantAdded:Connect(function(obj)
    if obj:IsA("ProximityPrompt") then
    removeHoldDuration(obj)
    elseif obj:GetChildren() then
    for _, desc in ipairs(obj:GetDescendants()) do
    removeHoldDuration(desc)
    end
    end
    end)
    end
 	})
	playerSection:Button({
    Text = "Unban Voice Chat",
    Description = "Attempts to rejoin Voice Chat",
    Callback = function()
    local success, result = pcall(function()
    game:GetService("VoiceChatService"):JoinVoice()
    end)
    if success then
    print("Attempted to join voice successfully.")
    else
    warn("Failed to join voice:", result)
    end
    end
    })
	local keepGunsEnabled = false
    local Players = game:GetService("Players")
    local LocalPlayer = Players.LocalPlayer
    local ReplicatedStorage = game:GetService("ReplicatedStorage")
    local StarterGui = game:GetService("StarterGui")
    local function showNotification(message)
    pcall(function()
    StarterGui:SetCore("SendNotification", {
    Title = "Revamped.City",
    Text = message,
    Duration = 5
    })
    end)
    end
    local excludedItems = {
    "Phone", "Fist", "Car Keys", "Gun Permit",
    ".UziMag", ".Bullets", "5.56", "7.62", ".9mm", 
    ".Extended", ".FNMag", ".MacMag", ".TecMag", ".Drum",
    "Lemonade", "FakeCard", "G26", "Shiesty", "RawSteak",
    "Ice-Fruit Bag", "Ice-Fruit Cupz", "FijiWater", "FreshWater",
    "Red Elite Bag", "Black Elite Bag", "Grab", "Blue Elite Bag",
    "Drac Bag", "Yellow RCR Bag", "Black RCR Bag",
    "Red RCR Bag", "Tan RCR Bag", "Black Designer Bag",
    "BluGloves", "WhiteGloves", "BlackGloves",
    "PinkCamoGloves", "RedCamoGloves", "BluCamoGloves",
    "Water", "RawChicken"
    }
    local function normalize(str)
    return str:lower():gsub("%W", "")
    end
    local function isExcluded(toolName)
    local normTool = normalize(toolName)
    for _, excluded in ipairs(excludedItems) do
    if normalize(excluded) == normTool then
    return true
    end
    end
    return false
    end
    local ListWeaponRemote = ReplicatedStorage:WaitForChild("ListWeaponRemote")
    local function sellItem(itemName)
    local args = {
    [1] = itemName,
    [2] = 999999
    }
    ListWeaponRemote:FireServer(unpack(args))
    end
    local function onDeath()
    wait(2.5)
    if keepGunsEnabled then
    task.spawn(function()
    repeat
    local soldSomething = false
    for _, item in pairs(LocalPlayer.Backpack:GetChildren()) do
    if item:IsA("Tool") and not isExcluded(item.Name) then
    sellItem(item.Name)
    soldSomething = true
    task.wait(2)
    end
	end
    task.wait(0.1)
    until not soldSomething
    end)
    end
    end
    local function onRespawn()
    if keepGunsEnabled then
    task.wait(2)
    local playerGui = LocalPlayer:FindFirstChild("PlayerGui")
    if playerGui then
    local marketGui = playerGui:FindFirstChild("Bronx Market 2")
    if marketGui then
    marketGui.Enabled = true
    showNotification("Please Select Your Guns")
    end
    end
    end
    end
    LocalPlayer.CharacterAdded:Connect(function(character)
    local humanoid = character:WaitForChild("Humanoid", 5)
    if humanoid then
    humanoid.Died:Connect(onDeath)
    end
    onRespawn()
    end)
    if LocalPlayer.Character then
    local humanoid = LocalPlayer.Character:FindFirstChild("Humanoid")
    if humanoid then
    humanoid.Died:Connect(onDeath)
    end
    end
    playerSection:Toggle({
    Text = "Keep Guns After Death",
    State = false,
    Callback = function(state)
    keepGunsEnabled = state
    if keepGunsEnabled then
    onRespawn()
    end
    end
    })
    playerSection:Toggle({
    Text = "No Knockback",
    Description = "Disables the knockback permanently",
    Default = false,
    Callback = function(state)
    local function removeKnockback()
    for _, v416 in ipairs(game.Players.LocalPlayer.Character:GetDescendants()) do
    if v416:IsA("BodyVelocity") or v416:IsA("LinearVelocity") or v416:IsA("VectorForce") then
    v416:Destroy()
    end
    end
    if game.ReplicatedStorage:FindFirstChild("AE") then
    game.ReplicatedStorage.AE:Destroy()
    end
    game.Players.LocalPlayer.Character:WaitForChild("HumanoidRootPart").ChildAdded:Connect(
    function(v417)
    if v417:IsA("BodyVelocity") or v417:IsA("LinearVelocity") or v417:IsA("VectorForce") then
    v417:Destroy()
    end
    end
    )
    end
    if state then
    removeKnockback()
    end
    end
    })
    playerSection:Toggle({
    Text = "No Hunger",
    Description = "Disables the hunger system permanently",
    Default = false,
    Callback = function(state)
    local function v151()
    local player = game.Players.LocalPlayer
    if player and player:FindFirstChild("PlayerGui") then
    local hunger = player.PlayerGui:FindFirstChild("Hunger")
    if hunger then
    local hungerScript = hunger:FindFirstChild("Frame") and hunger.Frame:FindFirstChild("Frame") and
    hunger.Frame.Frame:FindFirstChild("Frame") and hunger.Frame.Frame.Frame:FindFirstChild("HungerBarScript")
    if hungerScript then
    hungerScript.Disabled = true
    end
    end
    end
    end
	if state then
    task.spawn(function()
    while state do
    task.wait(1)
    v151()
    end
    end)
    end
    end
    })
    playerSection:Toggle({
    Text = "No Sleep",
    Description = "Disables the sleep system permanently",
    Default = false,
    Callback = function(state)
    local function v152()
    local player = game.Players.LocalPlayer
    if player and player:FindFirstChild("PlayerGui") then
    local sleepGui = player.PlayerGui:FindFirstChild("SleepGui")
    if sleepGui then
    local sleepScript = sleepGui:FindFirstChild("Frame") and sleepGui.Frame:FindFirstChild("sleep") and
    sleepGui.Frame.sleep:FindFirstChild("SleepBar") and sleepGui.Frame.sleep.SleepBar:FindFirstChild("sleepScript")
    if sleepScript then
    sleepScript.Disabled = true
    end
    end
    end
    end
    if state then
    task.spawn(function()
    while state do
    task.wait(1)
    v152()
    end
    end)
    end
    end
        })
        playerSection:Toggle({
        Text = "No Stamina",
        Description = "Disables the stamina system permanently",
        Default = false,
        Callback = function(state)
        local function v154()
        local player = game.Players.LocalPlayer
        if player and player:FindFirstChild("PlayerGui") then
        local stamina = player.PlayerGui:FindFirstChild("Run") and player.PlayerGui.Run:FindFirstChild("Frame") and
        player.PlayerGui.Run.Frame:FindFirstChild("Frame") and
        player.PlayerGui.Run.Frame.Frame:FindFirstChild("Frame") and
        player.PlayerGui.Run.Frame.Frame.Frame:FindFirstChild("StaminaBarScript")
        if stamina then
        stamina.Disabled = true
        end
        end
        end
        if state then
        task.spawn(function()
            while state do
        task.wait(1)
        v154()
        end
        end)
        end
            end
        })
	    local player = game:GetService("Players").LocalPlayer
        local function setupCharacter()
        local character = player.Character or player.CharacterAdded:Wait()
        local humanoid = character:WaitForChild("Humanoid")
        local hrp = character:WaitForChild("HumanoidRootPart")
        return character, humanoid, hrp
        end
        -- No Fall Damage Toggle
        playerSection:Toggle({
            Text = "No Fall",
        Description = "Disables Fall Damage",
        Default = false,
        Callback = function(state)
        local function v150()
        local player = game.Players.LocalPlayer
        if player and player.Character then
        local fallDamage = player.Character:FindFirstChild("FallDamageRagdoll")
            if fallDamage then
        fallDamage.Disabled = true
        end
        end
            end
        if state then
        task.spawn(function()
        while state do
            task.wait(1)
        v150()
        end
        end)
        end
        end
        })
        playerSection:Toggle({
            Text = "No Jail",
        State = false,
        Callback = function(value)
        local jailRemote = ReplicatedStorage:FindFirstChild("JailRemote")
        if value then
        if jailRemote then
        jailRemote:Destroy()
        end
        end
        end
        })
        local AntiRentPayEnabled = false
        playerSection:Toggle({
        Text = "No Rent Pay",
        State = false,
        Callback = function(value)
        AntiRentPayEnabled = value
        if value then
        task.spawn(function()
        while AntiRentPayEnabled do
        task.wait(1)
        local player = LocalPlayer
        local rentGui = player:FindFirstChild("PlayerGui") and player.PlayerGui:FindFirstChild("RentGui")
        if rentGui then
        local rentScript = rentGui:FindFirstChild("LocalScript")
        if rentScript then
        rentScript.Disabled = true
        rentScript:Destroy()
        end
        end
	    end
	    end)
	    end
        end
        })
	    local respawnSection = playerTab:Section({ Text = "Respawn Options", Side = "Right" })


    respawnSection:Toggle({
    Text = "Respawn Where Died",
    Default = false,
    Callback = function(state)
        if state then
            local function setup()
                local character = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
                local humanoid = character:WaitForChild("Humanoid")
                local root = character:WaitForChild("HumanoidRootPart")

                if deathConnection then deathConnection:Disconnect() end
                if respawnConnection then respawnConnection:Disconnect() end

                deathConnection = humanoid.Died:Connect(function()
                    if root then
                        lastPosition = root.CFrame
                    end
                end)

                respawnConnection = LocalPlayer.CharacterAdded:Connect(function(char)
                    local newRoot = char:WaitForChild("HumanoidRootPart")
                    if lastPosition then
                        newRoot.CFrame = lastPosition
                    end
                    setup()
                end)
            end
            setup()
        else
            if respawnConnection then
                respawnConnection:Disconnect()
                respawnConnection = nil
            end
            if deathConnection then
                deathConnection:Disconnect()
                deathConnection = nil
            end
            lastPosition = nil
        end
    end
    })


    local lastPosition = nil
    respawnSection:Button({
    Text = "Set Spawn",
    Callback = function()
    local character = LocalPlayer.Character
    if not character then return end
    local humanoidRootPart = character:FindFirstChild("HumanoidRootPart")
    local humanoid = character:FindFirstChild("Humanoid")
    if not humanoidRootPart or not humanoid then return end
    lastPosition = humanoidRootPart.CFrame
    humanoid.Health = 0
    LocalPlayer.CharacterAdded:Wait()
    local newCharacter = LocalPlayer.Character
    local newRoot = newCharacter:WaitForChild("HumanoidRootPart")
    if lastPosition then
    newRoot.CFrame = lastPosition
    end
    end
    })
    respawnSection:Button({
    Text = "Remove Spawn",
    Callback = function()
    lastPosition = nil
    print("Custom spawn position removed. Next respawn will be normal.")
    end
    })
	local guiSection = playerTab:Section({ Text = "GUIs" })
	local player = game.Players.LocalPlayer
	guiSection:Button({
    Text = "Bronx Clothing",
    Callback = function()
        player.PlayerGui["Bronx CLOTHING"].Enabled = true
    end
	})
	guiSection:Button({
    Text = "Bronx Market",
    Callback = function()
        player.PlayerGui["Bronx Market 2"].Enabled = true
    end
	})

	guiSection:Button({
    Text = "Bronx Pawning",
    Callback = function()
        player.PlayerGui["Bronx PAWNING"].Enabled = true
    end
	})

	guiSection:Button({
    Text = "Bronx Tattoos",
    Callback = function()
        player.PlayerGui["Bronx TATTOOS"].Enabled = true
    end
	})

	guiSection:Button({
    Text = "Bronx Crafting",
    Callback = function()
        player.PlayerGui.CraftGUI.Main.Visible = true
    end
	})

	guiSection:Button({
    Text = "Bronx Garage",
    Callback = function()
        player.PlayerGui.ColorWheel.Enabled = true
        
        local Notification = Instance.new("ScreenGui")
        Notification.Name = "Notification"
        Notification.Parent = player.PlayerGui
        
        local TextLabel = Instance.new("TextLabel")
        TextLabel.Parent = Notification
        TextLabel.Text = "Press 'Back' Unless You Have The Game Pass"
        TextLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
        TextLabel.BackgroundTransparency = 0.5
        TextLabel.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
        TextLabel.Position = UDim2.new(0.5, -150, 0, 20)
        TextLabel.Size = UDim2.new(0, 300, 0, 50)
        TextLabel.TextScaled = true
        TextLabel.AnchorPoint = Vector2.new(0.5, 0)
        
        delay(3, function()
            Notification:Destroy()
        end)
    end
	})


    local miscSection = playerTab:Section({ Text = "Misc", Side = "Right" })
    miscSection:Button({
    Text = "Drop All Tools",
    Callback = function()
    local backpack = LocalPlayer:FindFirstChild("Backpack")
    local character = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
    if backpack then
    for _, tool in ipairs(backpack:GetChildren()) do
    if tool:IsA("Tool") then
    tool.Parent = character
    task.wait(0.1)
    tool.Parent = workspace
    end
    end
    end
    if character then
    for _, tool in ipairs(character:GetChildren()) do
    if tool:IsA("Tool") then
    tool.Parent = workspace
    end
    end
    end
    end
    })
    miscSection:Toggle({
    Text = "Admin Alert",
    Description = "Notifies when an admin joins",
    Default = false,
    Callback = function(v148)
    _G.AdminAlertEnabled = v148
    end
    })
    local function checkForAdmin()
    for _, player in ipairs(game.Players:GetPlayers()) do
    for _, child in ipairs(player:GetChildren()) do
    if child.Name:find("_Tracker") then
    _G.Notify({
    Title = "Admin Alert",
    Content = "User: " .. player.Name .. " is an Admin! Be Careful!",
    Duration = 5
    })
    return
    end
    end
    end
    end
    spawn(function()
    while wait(113 - (17 + 86)) do
    if _G.AdminAlertEnabled then
    checkForAdmin()
    end
    end
    end)
 	local player = game.Players.LocalPlayer
 	local mouse = player:GetMouse()
 	local rs = game:GetService("RunService")
 	local grabToolEnabled = false
 	local grabTool = nil
 	local function createGrabTool()
    local tool = Instance.new("Tool")
    tool.Name = "Grab"
    local handle = Instance.new("Part")
    handle.Size = Vector3.zero
    handle.CanCollide = false
    handle.Transparency = 1
    handle.Name = "Handle"
    handle.Parent = tool
    tool.RequiresHandle = true
    tool.GripPos = Vector3.new()
    local targets = {}
    local holding = false
    local function align(p0, p1)
    local a0, a1 = Instance.new("Attachment", p0), Instance.new("Attachment", p1)
    local al = Instance.new("AlignPosition", p0)
    local ao = Instance.new("AlignOrientation", p0)
    al.Attachment0 = a0
    al.Attachment1 = a1
    al.Responsiveness = math.huge
    al.MaxForce = math.huge
    al.MaxVelocity = math.huge
    ao.Attachment0 = a0
    ao.Attachment1 = a1
    ao.Responsiveness = math.huge
    ao.MaxTorque = math.huge
    ao.MaxAngularVelocity = math.huge
    return a0, a1, al, ao
    end
    local function drop()
    for _, target in ipairs(targets) do
    local t, a0, a1, al, ao = unpack(target)
    if t then
    t.CanCollide = true
    t.Velocity = handle.Velocity
    t.RotVelocity = handle.RotVelocity
    a0:Destroy()
    a1:Destroy()
    al:Destroy()
    ao:Destroy()
    end
    end
    targets = {}
    holding = false
    end
    local function grab()
    local target = mouse.Target
    if target and not target.Anchored and not target:FindFirstChildOfClass("WeldConstraint") then
    local a0, a1, al, ao = align(target, handle)
    table.insert(targets, {target, a0, a1, al, ao})
    target.CanCollide = false
    end
    end
    local selectionBox = Instance.new("SelectionBox", workspace.Terrain)
    selectionBox.Color3 = Color3.new(0, 1, 0)
    selectionBox.LineThickness = 0.01
    rs.Heartbeat:Connect(function()
    local sine = os.clock()
    for _, target in ipairs(targets) do
    local t = target[1]
    if t and t.ReceiveAge == 0 then
    selectionBox.Adornee = t
    t.Velocity = Vector3.new(-25.1 + math.pi * math.sin(sine * 15), 25.1 + math.pi * math.sin(sine * 15), 25.1 + math.pi * math.sin(sine * 15))
    t.RotVelocity = Vector3.new(math.pi / 6 * math.sin(sine * 15), math.pi / 6 * math.sin(sine * 15), math.pi / 6 * math.sin(sine * 15))
    else
    selectionBox.Adornee = nil
    end
    end
    end)
    mouse.Button1Down:Connect(function()
    if holding then grab() end
    end)
    tool.Equipped:Connect(function()
    holding = true
    end)
    tool.Unequipped:Connect(function()
    drop()
    end)
    return tool
 	end
 	miscSection:Toggle({
    Text = "Grab Bags",
    Description = "Gives you the Grab Bags tool and keeps it after respawn",
    Default = false,
    Callback = function(state)
    grabToolEnabled = state
    if state then
    if not grabTool then
    grabTool = createGrabTool()
    end
    grabTool.Parent = player.Backpack
    else
    if grabTool then
    grabTool:Destroy()
    grabTool = nil
    end
    end
    end
 	})
 	player.CharacterAdded:Connect(function()
    if grabToolEnabled then
    task.wait(1)
    if grabTool then
    grabTool.Parent = player.Backpack
    else
    grabTool = createGrabTool()
    grabTool.Parent = player.Backpack
    end
    end
 	end)
 	local deletedParts = {}
 	local cDeleteConnection
 	miscSection:Toggle({
    Text = "C Delete",
    Description = "Deletes objects you click while holding C, restores on untoggle",
    Default = false,
    Callback = function(state)
    local uis = game:GetService("UserInputService")
    local mouse = player:GetMouse()
    if state then
    deletedParts = {}
	cDeleteConnection = mouse.Button1Down:Connect(function()
	if uis:IsKeyDown(Enum.KeyCode.C) and mouse.Target then
    local target = mouse.Target
    if target:IsA("BasePart") then
    table.insert(deletedParts, {
    Name = target.Name,
    Size = target.Size,
    Position = target.Position,
	Orientation = target.Orientation,
    Color = target.Color,
    Material = target.Material,
    Transparency = target.Transparency,
    Reflectance = target.Reflectance,
    Anchored = target.Anchored,
    CanCollide = target.CanCollide,
    Parent = target.Parent,
    CFrame = target.CFrame
    })
    target:Destroy()
    end
    end
    end)
    else
    if cDeleteConnection then
    cDeleteConnection:Disconnect()
    cDeleteConnection = nil
    end
    for _, partData in ipairs(deletedParts) do
    local part = Instance.new("Part")
    for key, value in pairs(partData) do
    if key ~= "Parent" then
    part[key] = value
    end
    end
    part.Parent = partData.Parent
    end
    deletedParts = {}
    end
    end
 	})
-- Combat
    local combatTab = Window:Tab({ Text = "Combat" })
    local gunModsSection = combatTab:Section({ Text = "Gun Options" })
    local player = game.Players.LocalPlayer
    local function getToolSettings()
	local tool = player.Character and player.Character:FindFirstChildOfClass("Tool")
	if tool then
	local success, settings = pcall(function()
	return require(tool:FindFirstChild("Setting"))
	end)
	if success and type(settings) == "table" then
	return settings
	else
	warn("Could not require settings from tool.")
	end
	else
	warn("No tool found in character.")
	end
	return nil
    end
    local function setInfiniteAmmo(state)
	local settings = getToolSettings()
	if settings then
	if state then
	settings.LimitedAmmoEnabled = false
	settings.MaxAmmo = 9e9
	settings.AmmoPerMag = 9e9
	settings.Ammo = 9e9
	print("Infinite Ammo enabled.")
	else
	print("Infinite Ammo disabled.")
	end
	end
    end
    local function setNoRecoil(state)
	local settings = getToolSettings()
	if settings then
	if state then
	settings.Recoil = 0
	print("No Recoil enabled.")
	else
	print("No Recoil disabled.")
	end
	end
    end
    local function setFullAuto(state)
	local settings = getToolSettings()
	if settings then
	if state then
	settings.Auto = true
	print("Full Auto enabled.")
	else
	print("Full Auto disabled.")
	end
	end
    end
    local function setInstantFire(state)
	local settings = getToolSettings()
	if settings then
	if state then
	settings.FireRate = 0
	print("Instant Fire enabled.")
	else
	print("Instant Fire disabled.")
	end
	end
    end
    gunModsSection:Toggle({
	Text = "Infinite Ammo",
	State = false,
	Callback = function(state)
	setInfiniteAmmo(state)
	end
    })
    gunModsSection:Toggle({
	Text = "No Recoil",
	State = false,
	Callback = function(state)
	setNoRecoil(state)
	end
    })
    gunModsSection:Toggle({
	Text = "Full Auto",
	State = false,
	Callback = function(state)
	setFullAuto(state)
	end
    })
    gunModsSection:Toggle({
	Text = "Instant Fire",
	State = false,
	Callback = function(state)
	setInstantFire(state)
	end
    })


-- Recovery 
    local recoveryTab = Window:Tab({ Text = "Recovery" })
    local DupeSection = recoveryTab:Section({ Text = "Dupe" })

    local Players = game:GetService("Players")
    local LocalPlayer = Players.LocalPlayer
    local ReplicatedStorage = game:GetService("ReplicatedStorage")
    local StarterGui = game:GetService("StarterGui")

    local keepGunsEnabled = false

        local excludedItems = {
    "Phone", "Fist", "Car Keys", "Gun Permit",
    ".UziMag", ".Bullets", "5.56", "7.62", ".9mm", 
    ".Extended", ".FNMag", ".MacMag", ".TecMag", ".Drum",
    "Lemonade", "FakeCard", "G26", "Shiesty", "RawSteak",
    "Ice-Fruit Bag", "Ice-Fruit Cupz", "FijiWater", "FreshWater",
    "Red Elite Bag", "Black Elite Bag", "Grab", "Blue Elite Bag",
    "Drac Bag", "Yellow RCR Bag", "Black RCR Bag",
    "Red RCR Bag", "Tan RCR Bag", "Black Designer Bag",
    "BluGloves", "WhiteGloves", "BlackGloves",
    "PinkCamoGloves", "RedCamoGloves", "BluCamoGloves",
    "Water", "RawChicken"
        }

    local function normalize(str)
    return str:lower():gsub("%W", "")
    end

    local function isExcluded(toolName)
    local normTool = normalize(toolName)
    for _, excluded in ipairs(excludedItems) do
        if normalize(excluded) == normTool then
            return true
        end
    end
    return false
    end

    local ListWeaponRemote = ReplicatedStorage:WaitForChild("ListWeaponRemote")

    local function sellItem(itemName)
    local args = {
        [1] = itemName,
        [2] = 999999
    }
    ListWeaponRemote:FireServer(unpack(args))
    end

    local function startSellingGuns()
    task.spawn(function()
        repeat
            local soldSomething = false
            for _, item in pairs(LocalPlayer.Backpack:GetChildren()) do
                if item:IsA("Tool") and not isExcluded(item.Name) then
                    sellItem(item.Name)
                    soldSomething = true
                    task.wait(3.3)
                end
            end
            task.wait(0.1)
        until not soldSomething
    end)
    end

    local function showNotification(message)
    pcall(function()
        StarterGui:SetCore("SendNotification", {
            Title = "Revamped.City",
            Text = message,
            Duration = 5
        })
    end)
    end

    local function onDeath()
    wait(0)
    if keepGunsEnabled then
        startSellingGuns()
    end
    end

    local function onRespawn()
    if keepGunsEnabled then
        keepGunsEnabled = false
        local playerGui = LocalPlayer:FindFirstChild("PlayerGui")
        if playerGui then
            local marketGui = playerGui:FindFirstChild("Bronx Market 2")
            if marketGui then
                marketGui.Enabled = true
                showNotification("Please Select Your Guns")
            end
        end
    end
    end

    LocalPlayer.CharacterAdded:Connect(function(character)
    local humanoid = character:WaitForChild("Humanoid", 5)
    if humanoid then
        humanoid.Died:Connect(onDeath)
    end
    onRespawn()
    end)

    if LocalPlayer.Character then
    local humanoid = LocalPlayer.Character:FindFirstChild("Humanoid")
    if humanoid then
        humanoid.Died:Connect(onDeath)
    end
    end

    local function setSpawn()
    local character = LocalPlayer.Character
    if not character then return end

    local humanoidRootPart = character:FindFirstChild("HumanoidRootPart")
    local humanoid = character:FindFirstChild("Humanoid")
    if not humanoidRootPart or not humanoid then return end

    local lastPosition = humanoidRootPart.CFrame
    humanoid.Health = 0

    LocalPlayer.CharacterAdded:Wait()
    local newCharacter = LocalPlayer.Character
    local newRoot = newCharacter:WaitForChild("HumanoidRootPart")

    if lastPosition then
        newRoot.CFrame = lastPosition
    end
    end

    -- Your button
    DupeSection:Button({
    Text = "Dupe Inventory",
    Callback = function()
        if not keepGunsEnabled then
            keepGunsEnabled = true
            showNotification("Keep guns enabled until next respawn!")
            setSpawn()
        else
            showNotification("Already enabled! It will reset on next respawn.")
        end
    end
    })


    local MoneySection = recoveryTab:Section({ Text = "Max Money", Side = "Right" })
    MoneySection:Button({
    Text = "Cook (Step 1)",
    Callback = function()
    local success, err = pcall(function()
    loadstring(game:HttpGet("https://pastebin.com/raw/cuw4HhtJ"))()
    end)
    if not success then
    warn("Failed to load Step 1 script:", err)
    end
    end
    })
    MoneySection:Button({
    Text = "Sell (Step 2)",
    Callback = function()
    local success, err = pcall(function()
    loadstring(game:HttpGet("http://pastebin.com/raw/ndC2kNgP"))()
	end)
    if not success then
    warn("Failed to load Step 2 script:", err)
    end
    end
    })
    MoneySection:Button({
    Text = "Wash (Step 3)",
    Callback = function()
    local success, err = pcall(function()
    loadstring(game:HttpGet("https://pastebin.com/raw/RnqJLmSW"))()
    end)
    if not success then
    warn("Failed to load Step 3 script:", err)
    end
    end
    })
    local ATMSection = recoveryTab:Section({ Text = "Grab ATM", Side = "Right" })
    local player = game:GetService("Players").LocalPlayer
    local TweenService = game:GetService("TweenService")
    local RunService = game:GetService("RunService")
    local UserInputService = game:GetService("UserInputService")

    local atmLocations = {
	Vector3.new(-1012, 254, -1155),
	Vector3.new(-720, 287, -791),
	Vector3.new(-397, 254, -1108),
    }
    local drillLocation = Vector3.new(-396, 340, -562)
    local roofPlacementLocation = Vector3.new(-1254, 253, -5445)

    local autoGrabEnabled = false
    local autoGrabConnection = nil
    local movementDisabled = false
    local atmBusy = false

    -- Prevent movement if needed
    local function setMovementEnabled(enabled)
	movementDisabled = not enabled
    end

    UserInputService.InputBegan:Connect(function(input, gameProcessed)
	if movementDisabled and not gameProcessed then
		if input.UserInputType == Enum.UserInputType.Keyboard or input.UserInputType == Enum.UserInputType.MouseMovement then
			local blockedKeys = {
				Enum.KeyCode.W, Enum.KeyCode.A, Enum.KeyCode.S, Enum.KeyCode.D,
				Enum.KeyCode.Up, Enum.KeyCode.Down, Enum.KeyCode.Left, Enum.KeyCode.Right,
				Enum.KeyCode.Space, Enum.KeyCode.LeftShift, Enum.KeyCode.LeftControl
			}
			for _, key in ipairs(blockedKeys) do
				if input.KeyCode == key then return end
			end
		end
	end
    end)

    -- Utilities
    local function TriggerSeat()
	local humanoid = player.Character and player.Character:FindFirstChild("Humanoid")
	if humanoid then
		for _, obj in pairs(workspace:GetDescendants()) do
			if obj:IsA("Seat") or obj:IsA("VehicleSeat") then
				obj:Sit(humanoid)
				return true
			end
		end
	end
	return false
    end

    local function teleportTo(pos)
	local humanoid = player.Character and player.Character:FindFirstChild("Humanoid")
	local hrp = player.Character and player.Character:FindFirstChild("HumanoidRootPart")
	if not humanoid or not hrp then return end
	setMovementEnabled(false)
	if TriggerSeat() then task.wait(1) end
	if typeof(pos) == "Vector3" then hrp.CFrame = CFrame.new(pos)
	elseif typeof(pos) == "CFrame" then hrp.CFrame = pos end
	task.wait(1)
	humanoid.Sit = false
	task.wait(1)
	setMovementEnabled(true)
	if (hrp.Position - (typeof(pos) == "Vector3" and pos or pos.Position)).Magnitude > 10 then
		teleportTo(pos)
	end
    end

    local function sexyNotification(message, duration)
	local screenGui = Instance.new("ScreenGui", player:WaitForChild("PlayerGui"))
	screenGui.Name = "SexyNotification"
	screenGui.ResetOnSpawn = false
	local textLabel = Instance.new("TextLabel", screenGui)
	textLabel.Size = UDim2.new(0.4, 0, 0.08, 0)
	textLabel.Position = UDim2.new(0.3, 0, 0.9, 0)
	textLabel.Text = message
	textLabel.BackgroundTransparency = 1
	textLabel.TextScaled = true
	textLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
	textLabel.Font = Enum.Font.GothamBold
	textLabel.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
	textLabel.BorderSizePixel = 0
	local fadeIn = TweenService:Create(textLabel, TweenInfo.new(0.5), {BackgroundTransparency = 0.2, TextTransparency = 0})
	fadeIn:Play()
	fadeIn.Completed:Wait()
	task.wait(duration or 2)
	local fadeOut = TweenService:Create(textLabel, TweenInfo.new(0.5), {BackgroundTransparency = 1, TextTransparency = 1})
	fadeOut:Play()
	fadeOut.Completed:Wait()
	screenGui:Destroy()
 end

    local function getPromptBasePart(prompt)
	local current = prompt.Parent
	while current and not current:IsA("BasePart") do
		current = current.Parent
	end
	return current
    end

    local function findPromptNearPosition(filterText, position, maxDistance)
	maxDistance = maxDistance or 15
	local closestPrompt, closestDistance = nil, math.huge
	for _, obj in pairs(workspace:GetDescendants()) do
		if obj:IsA("ProximityPrompt") and obj.Enabled then
			local action = string.lower(obj.ActionText or "")
			local object = string.lower(obj.ObjectText or "")
			if string.find(action, filterText) or string.find(object, filterText) then
				local part = getPromptBasePart(obj)
				if part then
					local dist = (part.Position - position).Magnitude
					if dist <= maxDistance and dist < closestDistance then
						closestDistance = dist
						closestPrompt = obj
					end
				end
			end
		end
	end
	return closestPrompt
    end

    local function firePromptWithHold(prompt)
	if not prompt then return false end
	if prompt.HoldDuration and prompt.HoldDuration > 0 then
		prompt:InputHoldBegin()
		task.wait(prompt.HoldDuration)
		prompt:InputHoldEnd()
	else
		fireproximityprompt(prompt, true)
		task.wait(0.1)
		fireproximityprompt(prompt, false)
	end
	return true
 end

 local function hasTool(toolName)
	return player.Backpack:FindFirstChild(toolName) or (player.Character and player.Character:FindFirstChild(toolName))
 end

 local function isHoldingTool(toolName)
	return player.Character and player.Character:FindFirstChild(toolName) ~= nil
 end

 local function equipTool(toolName)
	local tool = player.Backpack:FindFirstChild(toolName) or (player.Character and player.Character:FindFirstChild(toolName))
	if tool and player.Character and player.Character:FindFirstChild("Humanoid") then
		player.Character.Humanoid:EquipTool(tool)
		task.wait(0.3)
		return true
	end
	return false
 end

 local function countdownNotification(seconds)
	local gui = Instance.new("ScreenGui", player.PlayerGui)
	gui.Name = "CountdownNotification"
	gui.ResetOnSpawn = false
	local label = Instance.new("TextLabel", gui)
	label.Size = UDim2.new(0.4, 0, 0.08, 0)
	label.Position = UDim2.new(0.3, 0, 0.9, 0)
	label.BackgroundTransparency = 0.2
	label.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
	label.TextColor3 = Color3.fromRGB(255, 255, 255)
	label.Font = Enum.Font.GothamBold
	label.TextScaled = true
	for i = seconds, 1, -1 do
		label.Text = "⏳ " .. i .. "s remaining..."
		task.wait(1)
	end
	gui:Destroy()
 end

 -- Main Grab Function
 local function grabATM()
	if atmBusy then return end
	atmBusy = true

	local hasDrill = hasTool("Drill")
	if not hasDrill then
		local buyPrompt = findPromptNearPosition("buy drill", drillLocation, 15)
		if buyPrompt then
			teleportTo(drillLocation)
			if not firePromptWithHold(buyPrompt) then
				sexyNotification("❌ Failed to buy Drill", 2)
				atmBusy = false
				return false
			end
			task.wait(1.5)
		else
			sexyNotification("❌ No Drill to Buy Here!", 2)
			atmBusy = false
			return false
		end
	end

	if not isHoldingTool("Drill") then
		teleportTo(drillLocation)
		if not equipTool("Drill") then
			sexyNotification("❌ Couldn't equip Drill", 2)
			atmBusy = false
			return false
		end
	end

	local atmPos, atmPrompt
	for _, pos in ipairs(atmLocations) do
		local prompt = findPromptNearPosition("atm", pos, 15)
		if prompt then
			atmPos = pos
			atmPrompt = prompt
			break
		end
	end
	if not atmPrompt then
		sexyNotification("❌ No ATM Prompt Found", 2)
		atmBusy = false
		return false
	end

	teleportTo(atmPos)
	if not firePromptWithHold(atmPrompt) then
		sexyNotification("❌ Failed to drill ATM", 2)
		teleportTo(roofPlacementLocation)
		atmBusy = false
		return false
	end

	teleportTo(roofPlacementLocation)
	countdownNotification(57)

	local atmBase = getPromptBasePart(atmPrompt)
	teleportTo(atmBase and atmBase.CFrame or atmPos)

	local checkPrompt = findPromptNearPosition("atm", atmPos, 15)
	if checkPrompt then
		firePromptWithHold(checkPrompt)
	end

	teleportTo(roofPlacementLocation)
	sexyNotification("✅ ATM Grab Complete", 3)
	atmBusy = false
	return true
 end

 ATMSection:Button({
	Text = "Grab ATM",
	Callback = function()
		grabATM()
	end,
 })

 local teleportedMimics = {}
 local ignoreHistory = false
 local safeZonePosition = Vector3.new(-1268, 253, -5439) -- Custom safe zone


 local teleportedMimics = {}
local ignoredMimics = {}
local ignoreHistory = false
local toolActive = false
local selectorTool = nil
local safeZonePosition = Vector3.new(-1268, 253, -5439)

-- Toggle for Ignore ATM Tool
ATMSection:Toggle({
    Text = "Ignore ATM Tool",
    Default = false,
    Callback = function(state)
        toolActive = state
        if state then
            -- Give selection tool
            if not selectorTool then
                selectorTool = Instance.new("Tool")
                selectorTool.RequiresHandle = false
                selectorTool.Name = "ATMIgnoreSelector"
                selectorTool.CanBeDropped = false

                selectorTool.Activated:Connect(function()
                    local mouse = game.Players.LocalPlayer:GetMouse()
                    local target = mouse.Target
                    if target and (target.Name == "MimicATM" or target.Name:match("^MimicATM%d+$")) then
                        if ignoredMimics[target] then
                            ignoredMimics[target] = nil
                            if target:FindFirstChild("IgnoreHighlight") then
                                target.IgnoreHighlight:Destroy()
                            end
                        else
                            ignoredMimics[target] = true
                            local highlight = Instance.new("SelectionBox", target)
                            highlight.Adornee = target
                            highlight.Name = "IgnoreHighlight"
                            highlight.LineThickness = 0.08
                            highlight.SurfaceTransparency = 0.5
                            highlight.Color3 = Color3.fromRGB(255, 0, 0)
                        end
                    end
                end)
            end
            selectorTool.Parent = game.Players.LocalPlayer.Backpack
            sexyNotification("🛠️ Click a MimicATM to ignore or un-ignore.", 4)
        else
            if selectorTool then
                selectorTool.Parent = nil
            end
        end
    end
})

-- Grab MimicATM button
ATMSection:Button({
    Text = "Grab MimicATM",
    Callback = function()
        local mimicATMList = {}
        for _, obj in pairs(workspace:GetDescendants()) do
            if (obj.Name == "MimicATM" or obj.Name:match("^MimicATM%d+$")) and not ignoredMimics[obj] then
                table.insert(mimicATMList, obj)
            end
        end

        if #mimicATMList == 0 then
            sexyNotification("❌ No valid MimicATM found", 3)
            return
        end

        local nextATM = nil
        if ignoreHistory then
            nextATM = mimicATMList[math.random(#mimicATMList)]
        else
            for _, atm in ipairs(mimicATMList) do
                if not teleportedMimics[atm] then
                    nextATM = atm
                    break
                end
            end
            if not nextATM then
                teleportedMimics = {}
                nextATM = mimicATMList[1]
            end
        end

        if nextATM and nextATM:IsA("BasePart") then
            teleportTo(nextATM.Position)
            teleportedMimics[nextATM] = true

            local prompt = findPromptNearPosition("atm", nextATM.Position, 15)
            if not prompt then
                sexyNotification("❌ No ATM Prompt Found", 2)
                return
            end

            if prompt.HoldDuration and prompt.HoldDuration > 0 then
                prompt:InputHoldBegin()
                task.wait(prompt.HoldDuration)
                prompt:InputHoldEnd()
            else
                fireproximityprompt(prompt, true)
                task.wait(0.1)
                fireproximityprompt(prompt, false)
            end

            task.wait(0.2)
            if hasTool("ATM") or isHoldingTool("ATM") then
                teleportTo(safeZonePosition)
                sexyNotification("✅ ATM grabbed. Teleported to safe zone.", 3)
            end
        else
            sexyNotification("❌ Failed to teleport to MimicATM", 3)
        end
    end
})

    local MarketSection = recoveryTab:Section({
	Text = "Market",
	Side = "Left"
    })

    -- Variables to store input
    local selectedTool = ""
    local selectedAmount = 1
    local selectedPrice = 100

    -- Input: Tool Name
    MarketSection:Input({
	Placeholder = "Enter Tool Name",
	Flag = "ToolName",
	Callback = function(text)
		selectedTool = text
	end
    })

    -- Input: Amount
    MarketSection:Input({
	Placeholder = "Enter Amount",
	Flag = "SellAmount",
	Callback = function(text)
		local num = tonumber(text)
		if num and num > 0 then
			selectedAmount = num
		else
			selectedAmount = 1
		end
	end
    })

    -- Input: Price
    MarketSection:Input({
	Placeholder = "Enter Price",
	Flag = "SellPrice",
	Callback = function(text)
		local num = tonumber(text)
		if num and num >= 0 then
			selectedPrice = num
		else
			selectedPrice = 100
		end
	end
    })

    -- Button: Sell
    MarketSection:Button({
	Text = "Sell Tool",
	Tooltip = "Sells tool every 3.5 seconds.",
	Callback = function()
		local ReplicatedStorage = game:GetService("ReplicatedStorage")
		local ListWeaponRemote = ReplicatedStorage:FindFirstChild("ListWeaponRemote")

		if not ListWeaponRemote then
			warn("ListWeaponRemote not found!")
			return
		end

		if selectedTool ~= "" and selectedAmount > 0 and selectedPrice >= 0 then
			task.spawn(function()
				for i = 1, selectedAmount do
					ListWeaponRemote:FireServer(selectedTool, selectedPrice)
					print("Selling", selectedTool, "at $" .. selectedPrice)
					task.wait(3.5)
				end
			end)
		else
			warn("Invalid tool name, amount, or price.")
		end
	end
    })


    local bankSection = recoveryTab:Section({ Text = "Bank Options" })
	-- Bronx ATM Toggle
	local clonedATMGui = nil
	bankSection:Toggle({
    Text = "Bronx ATM",
    Callback = function(isToggled)
    local player = game.Players.LocalPlayer
    local lighting = game:GetService("Lighting")
    local atmGui = lighting:FindFirstChild("Assets") and lighting.Assets:FindFirstChild("GUI") and lighting.Assets.GUI:FindFirstChild("ATMGui")
    if isToggled then
    if atmGui then
    clonedATMGui = atmGui:Clone()
    clonedATMGui.Parent = player:WaitForChild("PlayerGui")
    else
    warn("ATM GUI not found.")
    end
    else
    if clonedATMGui then
    clonedATMGui:Destroy()
    clonedATMGui = nil
    end
    end
    end
	})
	-- Single input box for amount
	local amount = 0
	bankSection:Input({
    Placeholder = "Enter Amount",
    Flag = "TransactionAmount",
    Callback = function(input)
    amount = tonumber(input) or 0
    end
    })
	-- Deposit toggle with loop
	local depositLoop
	bankSection:Toggle({
    Text = "Deposit (30K Max)",
    Default = false,
    Callback = function(state)
    if state then
    depositLoop = game:GetService("RunService").Heartbeat:Connect(function()
    game:GetService("ReplicatedStorage").BankAction:FireServer("depo", amount)
    v0:Notify({ Title = "Deposit", Content = "Deposited $" .. amount, Duration = 3 })
    wait(4)
    end)
    else
    if depositLoop then
    depositLoop:Disconnect()
    depositLoop = nil
    end
    end
    end
	})
	-- Withdrawal toggle with loop
	local withdrawLoop
	bankSection:Toggle({
    Text = "Withdrawal (90K Max)",
    Default = false,
    Callback = function(state)
    if state then
    withdrawLoop = game:GetService("RunService").Heartbeat:Connect(function()
    game:GetService("ReplicatedStorage").BankAction:FireServer("with", amount)
    v0:Notify({ Title = "Withdraw", Content = "Withdrew $" .. amount, Duration = 3 })
    wait(4)
    end)
    else
    if withdrawLoop then
    withdrawLoop:Disconnect()
    withdrawLoop = nil
    end
    end
    end
	})
	-- Money Drop toggle with loop
	local dropLoop
	bankSection:Toggle({
    Text = "Money Drop (10K Max)",
    Default = false,
    Callback = function(state)
    if state then
    dropLoop = game:GetService("RunService").Heartbeat:Connect(function()
    game:GetService("ReplicatedStorage"):WaitForChild("BankProcessRemote"):InvokeServer("Drop", amount)
    v0:Notify({ Title = "Money Drop", Content = "Dropped $" .. amount, Duration = 2 })
    wait(4)
    end)
    else
    if dropLoop then
    dropLoop:Disconnect()
    dropLoop = nil
    end
    end
    end
	})

-- Visuals  
 	local Players = game:GetService("Players")
 	local RunService = game:GetService("RunService")
 	local Camera = workspace.CurrentCamera
 	local VisualTab = Window:Tab({ Text = "Visual" })
 	local ESPSection = VisualTab:Section({ Text = "ESP Options" })
 	local boxEspEnabled = false
 	local nameEspEnabled = false
 	local healthEspEnabled = false
 	local friendCheckEnabled = false
 	local EspList = {}
 	local yOffset = 33
 	local function createESP(Player)
    local Box = Drawing.new("Square")
    Box.Thickness = 1
    Box.Filled = false
    local function setColor()
    if friendCheckEnabled and Players.LocalPlayer:IsFriendsWith(Player.UserId) then
    Box.Color = Color3.fromRGB(162, 97, 243) -- Purple for friends
    else
    Box.Color = Color3.fromRGB(44, 84, 212) -- Baby blue
    end
    end
    local function update()
    local Character = Player.Character
    if Character then
    local Humanoid = Character:FindFirstChildOfClass("Humanoid")
    if Humanoid and Humanoid.Health > 0 then
    local Pos, OnScreen = Camera:WorldToViewportPoint(Character.Head.Position)
    if OnScreen then
    Box.Size = Vector2.new(2450 / Pos.Z, 3850 / Pos.Z)
    Box.Position = Vector2.new(Pos.X - Box.Size.X / 2, Pos.Y - Box.Size.Y / 9)
    Box.Visible = boxEspEnabled
    setColor()
    return
    end
    end
    end
    Box.Visible = false
    end
    update()
    local Connection1 = Player.CharacterAdded:Connect(update)
    local Connection2 = Player.CharacterRemoving:Connect(function() Box.Visible = false end)
    return {
    update = update,
    disconnect = function()
    Box:Remove()
    Connection1:Disconnect()
    Connection2:Disconnect()
    end,
    setColor = setColor
    }
 	end
 	local function createNameESP(Player)
    local Name = Drawing.new("Text")
    Name.Text = Player.Name
    Name.Size = 10
    Name.Outline = true
    Name.Center = true
    local function setColor()
    if friendCheckEnabled and Players.LocalPlayer:IsFriendsWith(Player.UserId) then
    Name.Color = Color3.fromRGB(162, 97, 243)
    else
    Name.Color = Color3.fromRGB(44, 84, 212)
    end
    end
    local function update()
    local Character = Player.Character
    if Character then
    local Humanoid = Character:FindFirstChildOfClass("Humanoid")
    if Humanoid and Humanoid.Health > 0 then
    local Pos, OnScreen = Camera:WorldToViewportPoint(Character.Head.Position)
    if OnScreen then
    Name.Position = Vector2.new(Pos.X, Pos.Y - yOffset)
    Name.Visible = nameEspEnabled
    setColor()
    return
    end
    end
    end
    Name.Visible = false
    end
    update()
    local Connection1 = Player.CharacterAdded:Connect(update)
    local Connection2 = Player.CharacterRemoving:Connect(function() Name.Visible = false end)
    return {
    update = update,
    disconnect = function()
    Name:Remove()
    Connection1:Disconnect()
    Connection2:Disconnect()
    end,
    setColor = setColor,
    Name = Name
    }
 	end
 	local function createHealthBar(Player)
    if Player == Players.LocalPlayer then return end
    local function addBar()
    local Character = Player.Character
    if not Character then return end
    local Humanoid = Character:FindFirstChildOfClass("Humanoid")
    local Head = Character:FindFirstChild("Head")
    if not (Humanoid and Head) then return end
    local gui = Instance.new("BillboardGui")
    gui.Name = "HealthBar"
    gui.Adornee = Head
    gui.Size = UDim2.new(5, 0, .3, 0)
    gui.StudsOffset = Vector3.new(0, -5.7, 0)
    gui.AlwaysOnTop = true
    gui.Parent = Head
    local frame = Instance.new("Frame")
    frame.Size = UDim2.new(Humanoid.Health / Humanoid.MaxHealth, 0, 1, 0)
    frame.BackgroundColor3 = Color3.fromRGB(44, 84, 212)
    frame.BorderSizePixel = 0
    frame.Parent = gui
    Humanoid.HealthChanged:Connect(function()
    if frame then
    frame.Size = UDim2.new(Humanoid.Health / Humanoid.MaxHealth, 0, 1, 0)
    end
    end)
    end
    if Player.Character then
    addBar()
    end
    Player.CharacterAdded:Connect(function()
    task.wait(0.5)
    addBar()
    end)
 	end
 	-- ESP Toggles
 	ESPSection:Toggle({
    Text = "Enable Box ESP",
    State = false,
    Callback = function(state)
    boxEspEnabled = state
    for _, esp in ipairs(EspList) do
    esp.update()
    end
    end
 	})
 	ESPSection:Toggle({
    Text = "Enable Names ESP",
    State = false,
    Callback = function(state)
    nameEspEnabled = state
    for _, esp in ipairs(EspList) do
    if esp.Name then
    esp.Name.Visible = state
    end
    end
    end
 	})
 	ESPSection:Toggle({
    Text = "Enable Health ESP",
    State = false,
    Callback = function(state)
    healthEspEnabled = state
    for _, player in ipairs(Players:GetPlayers()) do
    if player ~= Players.LocalPlayer then
    if state then
    createHealthBar(player)
    else
    if player.Character and player.Character:FindFirstChild("Head") then
    local hb = player.Character.Head:FindFirstChild("HealthBar")
    if hb then hb:Destroy() end
    end
    end
    end
    end
    end
 	})
 	ESPSection:Toggle({
    Text = "Friend Check (Purple ESP)",
    State = false,
    Callback = function(state)
    friendCheckEnabled = state
    for _, esp in ipairs(EspList) do
    if esp.setColor then
    esp.setColor()
    end
    end
    end
 	})
 	local function createAllESP()
    for _, player in ipairs(Players:GetPlayers()) do
    if player ~= Players.LocalPlayer then
    table.insert(EspList, createESP(player))
    table.insert(EspList, createNameESP(player))
    if healthEspEnabled then
    createHealthBar(player)
    end
    end
    end
 	end
 	Players.PlayerAdded:Connect(function(player)
    if player ~= Players.LocalPlayer then
    table.insert(EspList, createESP(player))
    table.insert(EspList, createNameESP(player))
    if healthEspEnabled then
    createHealthBar(player)
    end
    end
 	end)
 	createAllESP()
 	RunService.RenderStepped:Connect(function()
    for _, esp in ipairs(EspList) do
    esp.update()
    end
 	end)
    local EffectsSection = VisualTab:Section({ Text = "Effects Options", Side = "Right" })
    EffectsSection:Button({
    Text = "Anti-CameraShake",
    Description = "Disables the camera shake effect permanently",
    Callback = function()
    local v155 = 0 - 0
    local v156
    while true do
    if (v155 == 1) then
    task.spawn(
    function()
    while true do
    task.wait(1)
    v156()
    end
    end
    )
    break
    end
	if (0 == v155) then
    v156 = nil
    function v156()
    local v562 = 580 - (361 + 219)
    local v563
    while true do
    if (v562 == 0) then
    v563 = game.Players.LocalPlayer
    if (v563 and v563.Character) then
    local v706 = 320 - (53 + 267)
    local v707
    while true do
    if (v706 == 0) then
    v707 = v563.Character:FindFirstChild("CameraBobbing")
	if v707 then
    v707:Destroy()
    end
	break
	end
	end
    end
    break
    end
    end
    end
    v155 = 1 + 0
    end
    end
    end
    })
    EffectsSection:Button({
    Text = "Boost FPS (Potato PC)",
    Description = "Deletes all specific effects from Lighting permanently",
    Callback = function()
    local function v7()
    if game.Lighting then
    for v518, v519 in pairs(game.Lighting:GetChildren()) do
    if (v519:IsA("PostEffect") or v519:IsA("BloomEffect") or v519:IsA("SunRaysEffect") or
    v519:IsA("DepthOfFieldEffect")) then
    pcall(function()
    v519:Destroy()
    end)
    end
    end
    end
    end
    local function v8(v144)
    game.Lighting.ClockTime = v144
    if _G.LockTimeConnection then
    _G.LockTimeConnection:Disconnect()
    end
    _G.LockTimeConnection =
    game.Lighting:GetPropertyChangedSignal("ClockTime"):Connect(
    function()
    if (game.Lighting.ClockTime ~= v144) then
    game.Lighting.ClockTime = v144
    end
    end
    )
    end
    task.spawn(function()
    pcall(function()
    loadstring(
    game:HttpGet(
	"https://raw.githubusercontent.com/RevampedCity/Shaman-Library/refs/heads/main/Remove%20Lighting"
    )
    )()
    end)
    end)
    v7()
    end
    })
    EffectsSection:Button({
    Text = "Change To Day",
    Description = "Click to set the game time to permanent day.",
    Callback = function()
    game.Lighting.ClockTime = 12 -- Sets the time to noon (day)
    end
    })
    EffectsSection:Button({
    Text = "Change To Night",
    Description = "Click to set the game time to permanent night.",
    Callback = function()
    game.Lighting.ClockTime = 0 -- Sets the time to midnight (night)
    end
    })

-- Other Players Tab
    local otherPlayersTab = Window:Tab({ Text = "Other" })
    local viewsSection = otherPlayersTab:Section({ Text = "Views" })
    local Players = game:GetService("Players")
    local SelectedPlayerName = nil
   	local function CreateNotification(text)
    local notifFrame = Instance.new("Frame")
    notifFrame.BackgroundColor3 = Color3.fromRGB(50, 50, 50)  -- dark grey
    notifFrame.Size = UDim2.new(0, 300, 0, 80)
    notifFrame.Position = UDim2.new(0.5, -150, 0, 50)
    notifFrame.AnchorPoint = Vector2.new(0.5, 0)
    notifFrame.BorderSizePixel = 0
    notifFrame.BackgroundTransparency = 0.15
    notifFrame.ZIndex = 1000
    local uicorner = Instance.new("UICorner", notifFrame)
    uicorner.CornerRadius = UDim.new(0, 8)
    local label = Instance.new("TextLabel", notifFrame)
    label.Size = UDim2.new(1, -20, 1, -20)
    label.Position = UDim2.new(0, 10, 0, 10)
    label.BackgroundTransparency = 1
    label.Text = text
    label.TextColor3 = Color3.fromRGB(255, 255, 255)  -- white text
    label.TextWrapped = true
    label.Font = Enum.Font.SourceSansSemibold
    label.TextSize = 14
    label.TextXAlignment = Enum.TextXAlignment.Left
    label.TextYAlignment = Enum.TextYAlignment.Top
    label.ZIndex = 1001
    local playerGui = Players.LocalPlayer:FindFirstChildOfClass("PlayerGui")
    if playerGui then
	local screenGui = playerGui:FindFirstChild("RevampedCityNotificationGui")
    if not screenGui then
    screenGui = Instance.new("ScreenGui")
    screenGui.Name = "RevampedCityNotificationGui"
    screenGui.ResetOnSpawn = false
    screenGui.Parent = playerGui
    end
    notifFrame.Parent = screenGui
    else
    notifFrame.Parent = game.CoreGui -- fallback, but PlayerGui is better
    end
    task.spawn(function()
    task.wait(4)
    for i = 1, 10 do
    notifFrame.BackgroundTransparency = notifFrame.BackgroundTransparency + 0.08
    label.TextTransparency = label.TextTransparency + 0.08
    task.wait(0.05)
    end
    notifFrame:Destroy()
    end)
    end
    viewsSection:Input({
    Text = "Target Player",
    Placeholder = "Enter player name or display name",
    Callback = function(input)
    input = input:lower()
    local found = nil
    for _, player in ipairs(Players:GetPlayers()) do
    if player.Name:lower():find(input) or player.DisplayName:lower():find(input) then
    found = player.Name
    break
    end
    end
    SelectedPlayerName = found
    end
    })
    local function getTargetPlayer()
    if SelectedPlayerName then
    return Players:FindFirstChild(SelectedPlayerName)
    end
    return nil
    end
    local function formatItemNames(items)
    if #items == 0 then return "None" end
    return table.concat(items, ", ")
    end
    viewsSection:Button({
    Text = "View Safe Items",
    Callback = function()
    local target = getTargetPlayer()
    if target and target:FindFirstChild("InvData") then
    local invItems = target.InvData:GetChildren()
    local itemNames = {}
    for _, item in ipairs(invItems) do
    table.insert(itemNames, item.Name)
    end
    CreateNotification("Safe Items for "..target.Name..":\n"..formatItemNames(itemNames))
    else
    CreateNotification("Safe data unavailable for player.")
    end
    end
    })
    viewsSection:Button({
    Text = "View Bank",
    Callback = function()
    local target = getTargetPlayer()
    if target and target:FindFirstChild("stored") and target.stored:FindFirstChild("Bank") then
    CreateNotification("Bank Balance for "..target.Name..": $"..target.stored.Bank.Value)
    else
    CreateNotification("Bank data unavailable for player.")
    end
    end
    })
    viewsSection:Button({
    Text = "View Wallet",
    Callback = function()
    local target = getTargetPlayer()
    if target and target:FindFirstChild("stored") and target.stored:FindFirstChild("Money") then
    CreateNotification("Wallet for "..target.Name..": $"..target.stored.Money.Value)
    else
    CreateNotification("Wallet data unavailable for player.")
    end
    end
    })
    viewsSection:Button({
    Text = "View Inventory",
    Callback = function()
    local target = getTargetPlayer()
    if target and target:FindFirstChild("Backpack") then
    local backpackItems = target.Backpack:GetChildren()
    local itemNames = {}
    for _, item in ipairs(backpackItems) do
    table.insert(itemNames, item.Name)
	end
    CreateNotification("Inventory for "..target.Name..":\n"..formatItemNames(itemNames))
    else
    CreateNotification("Inventory data unavailable for player.")
    end
    end
    })
 
    local teleportSection = otherPlayersTab:Section({ Text = "Teleport", Side = "Right" })
    local function TriggerSeat()
    local humanoid = player.Character and player.Character:FindFirstChild("Humanoid")
    if humanoid then
    for _, obj in pairs(workspace:GetDescendants()) do
    if obj:IsA("Seat") or obj:IsA("VehicleSeat") then
    obj:Sit(humanoid)
    return
    end
    end
    end
    end
    local function teleportTo(position)
    TriggerSeat()
    wait(1)
    if player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
    player.Character.HumanoidRootPart.CFrame = CFrame.new(position)
    end
    local humanoid = player.Character and player.Character:FindFirstChild("Humanoid")
    if humanoid then
    humanoid.Sit = false
    end
    end
    local function findPlayer(input)
    input = input:lower()
    for _, targetPlayer in pairs(Players:GetPlayers()) do
    if targetPlayer.Name:lower():sub(1, #input) == input or targetPlayer.DisplayName:lower():sub(1, #input) == input then
    return targetPlayer
    end
    end
    return nil
    end
    local playerName = ""
    teleportSection:Input({
    Text = "Enter Player Name",
    Placeholder = "Player Name",
    Callback = function(value)
    playerName = value
    end
    })
    teleportSection:Button({
    Text = "Teleport to Player",
    Callback = function()
    local targetPlayer = findPlayer(playerName)
    if targetPlayer and targetPlayer.Character and targetPlayer.Character:FindFirstChild("HumanoidRootPart") then
    teleportTo(targetPlayer.Character.HumanoidRootPart.Position)
    end
    end
    })

-- Teleport Tab
 local TeleportTab = Window:Tab({ Text = "Teleport" })
 local player = game:GetService("Players").LocalPlayer
 local function setMovementEnabled(enabled)
 end
 local function TriggerSeat()
	local humanoid = player.Character and player.Character:FindFirstChild("Humanoid")
	if humanoid then
	for _, obj in pairs(workspace:GetDescendants()) do
	if obj:IsA("Seat") or obj:IsA("VehicleSeat") then
	obj:Sit(humanoid)
	return true
	end
	end
	end
	return false
	end
	local function teleportTo(positionOrCFrame)
	local humanoid = player.Character and player.Character:FindFirstChild("Humanoid")
	local hrp = player.Character and player.Character:FindFirstChild("HumanoidRootPart")
    if not humanoid or not hrp then return end
    setMovementEnabled(false)
    local sat = TriggerSeat()
    if sat then
        task.wait(1)
    end
    if typeof(positionOrCFrame) == "Vector3" then
        hrp.CFrame = CFrame.new(positionOrCFrame)
    elseif typeof(positionOrCFrame) == "CFrame" then
        hrp.CFrame = positionOrCFrame
    end
    task.wait(1)
    humanoid.Sit = false
    task.wait(1)
    setMovementEnabled(true)
    if (hrp.Position - (typeof(positionOrCFrame) == "Vector3" and positionOrCFrame or positionOrCFrame.Position)).Magnitude > 10 then
        teleportTo(positionOrCFrame)
    end
    end

    -- Helper to create teleport buttons using teleportTo
    local function createTeleportButtons(section, locations)
    for _, loc in ipairs(locations) do
        section:Button({
            Text = loc.name,
            Callback = function()
                teleportTo(loc.position)
            end
        })
    end
    end

    -- Safe Locations --
    local SafeSection = TeleportTab:Section({ Text = "Safe Locations" })
    local safeLocations = {
    {name = "Open Field", position = Vector3.new(-1248, 256, -5431)},
    {name = "Bank Tools", position = Vector3.new(-384, 340, -556)},
    {name = "Safe", position = Vector3.new(68517, 52942, -794)}
    }
    createTeleportButtons(SafeSection, safeLocations)

    -- Gun Shops --
    local GunSection = TeleportTab:Section({ Text = "Gun Shops", Side = "Right" })
    local gunLocations = {
    {name = "Xotic Guns", position = Vector3.new(60823, 87609, -350)},
    {name = "Studio Guns", position = Vector3.new(72422, 128856, -1087)},
    {name = "The Gun Shop 1", position = Vector3.new(-201, 284, -795)},
    {name = "The Gun Shop 2", position = Vector3.new(-1004, 254, -814)}
    }
    createTeleportButtons(GunSection, gunLocations)

    -- Shops --
    local ShopSection = TeleportTab:Section({ Text = "Shops" })
    local shopLocations = {
    {name = "Frozen", position = Vector3.new(-193, 284, -1171)},
    {name = "DeliStore", position = Vector3.new(-52, 283, -1053)},
    {name = "Dealership", position = Vector3.new(-387, 253, -1240)},
    {name = "Dollar Central", position = Vector3.new(-391, 254, -1075)},
    {name = "McDronalds", position = Vector3.new(-1014, 255, -1125)},
    {name = "Drip Shop", position = Vector3.new(67464, 10489, 550)},
    {name = "Barber Shop", position = Vector3.new(-745, 254, -763)},
    {name = "Tattoo Shop", position = Vector3.new(-632, 254, -598)},
    {name = "Jamaican Food", position = Vector3.new(-670, 254, -805)},
    {name = "Deli & Grill", position = Vector3.new(-739, 254, -901)},
    {name = "Chicken & Wings", position = Vector3.new(-961, 253, -818)},
    {name = "Backpack Shop", position = Vector3.new(-675, 254, -685)},
    {name = "Super Deli", position = Vector3.new(-913, 254, -816)},
    {name = "Gas Station 1", position = Vector3.new(-365, 253, -782)},
    {name = "Gas Station 2", position = Vector3.new(-462, 254, -587)},
    {name = "Gas Station 3", position = Vector3.new(-671, 255, -1146)},
    {name = "Gas Station 4", position = Vector3.new(-688, 255, -524)},
    {name = "Gas Station 5", position = Vector3.new(-1765, 253, -1249)},
    {name = "Gas Station 6", position = Vector3.new(-1446, 254, -3464)}
    }
    createTeleportButtons(ShopSection, shopLocations)

    -- Apartments --
    local AptSection = TeleportTab:Section({ Text = "Apartments", Side = "Right" })
    local aptLocations = {
    {name = "Penthouse", position = Vector3.new(-115, 417, -545)},
    {name = "Apartment 1", position = Vector3.new(-77, 284, -740)},
    {name = "Apartment 2", position = Vector3.new(-1032, 253, -278)},
    {name = "Apartment 3", position = Vector3.new(-1022, 258, -505)},
    {name = "Apartment 4", position = Vector3.new(-1587, 254, -260)},
    {name = "Apartment 5", position = Vector3.new(-1566, 254, -502)},
    {name = "Garden Villas", position = Vector3.new(-704, 254, -312)},
    {name = "Tha Bronx Hotel", position = Vector3.new(-136, 283, -526)},
    {name = "Fashion Homes", position = Vector3.new(-579, 254, -486)},
    {name = "Hot & Cod", position = Vector3.new(-583, 253, -673)}
    }
    createTeleportButtons(AptSection, aptLocations)

    -- Jobs --
    local JobsSection = TeleportTab:Section({ Text = "Jobs" })
    local jobLocations = {
    {name = "Bank", position = Vector3.new(-203, 284, -1215)},
    {name = "Pawnshop", position = Vector3.new(-1052, 253, -817)},
    {name = "Money Wash", position = Vector3.new(-987, 254, -676)},
    {name = "Paint Job", position = Vector3.new(-75, 295, -1153)},
    {name = "Koolaid Sell Truck", position = Vector3.new(-56, 287, -338)},
    {name = "IceBox Rob", position = Vector3.new(-214, 283, -1256)},
    {name = "Door Break", position = Vector3.new(-585, 254, -595)},
    {name = "Construction", position = Vector3.new(-1732, 371, -1176)},
    {name = "Card/Swiper", position = Vector3.new(-601, 256, -1220)},
    {name = "Laptop", position = Vector3.new(-1016, 254, -251)},
    {name = "Warehouse", position = Vector3.new(-1561, 258, -1174)},
    {name = "On Tha Radar", position = Vector3.new(93377, 14485, 566)}
    }
    createTeleportButtons(JobsSection, jobLocations)

    -- Bronx Police --
    local BronxPoliceSection = TeleportTab:Section({ Text = "Bronx Police", Side = "Right" })
    local policeLocations = {
    {name = "Police Station", position = Vector3.new(-1407, 255, -3125)},
    {name = "Prison", position = Vector3.new(-1183, 256, -3382)},
    {name = "Loadout Room", position = Vector3.new(-1436, 255, -3140)},
    {name = "Court Room", position = Vector3.new(-1383, 256, -3152)},
    {name = "Break Room", position = Vector3.new(-1387, 255, -3175)},
    {name = "Empty Room", position = Vector3.new(-1419, 255, -3181)},
    {name = "Interrogation Room", position = Vector3.new(-1369, 254, -3187)},
    {name = "FBI Room", position = Vector3.new(-1420, 255, -3207)},
    {name = "ESU Room", position = Vector3.new(-1446, 255, -3206)}
    }
    createTeleportButtons(BronxPoliceSection, policeLocations)

    -- Maybe Coming Soon --
    local ComingSoonSection = TeleportTab:Section({ Text = "Maybe Coming Soon" })
    local comingSoonLocations = {
    {name = "End Of Map", position = Vector3.new(-1302, 253, -3532)},
    {name = "General Sales", position = Vector3.new(-1463, 255, -567)},
    {name = "???", position = Vector3.new(-1396, 262, -696)},
    {name = "Tha Food Shop", position = Vector3.new(-1046, 253, -674)},
    {name = "Studio", position = Vector3.new(-1013, 254, -675)},
    {name = "Flat Fix", position = Vector3.new(-924, 253, -1015)},
    {name = "Deli Grocery", position = Vector3.new(-738, 254, -798)},
    {name = "Woodys Pizza", position = Vector3.new(-759, 254, -946)},
    {name = "Its Up INC", position = Vector3.new(-585, 254, -595)},
    {name = "Its Up INC 2", position = Vector3.new(-757, 254, -818)},
    {name = "Jerome Express", position = Vector3.new(-462, 254, -587)},
    {name = "Richard Cleaners", position = Vector3.new(-218, 284, -1134)},
    {name = "Bounce House", position = Vector3.new(-124, 285, -884)},
    {name = "Random Garage", position = Vector3.new(-57, 283, -262)},
    {name = "WoodyShopp", position = Vector3.new(-198, 283, -721)},
    {name = "Deli Crop", position = Vector3.new(-198, 283, -689)},
    {name = "Deli Corp 2", position = Vector3.new(-742, 254, -680)},
    {name = "Car Wash", position = Vector3.new(-396, 254, -966)},
    {name = "Customize Car", position = Vector3.new(-341, 253, -1249)},
    {name = "99 Cents And Up", position = Vector3.new(-460, 254, -529)},
    {name = "Halal Meat", position = Vector3.new(-460, 253, -555)},
    {name = "Nail Salon", position = Vector3.new(-692, 254, -830)}
    }
    createTeleportButtons(ComingSoonSection, comingSoonLocations)

    -- Roof Tops --
    local RoofSection = TeleportTab:Section({ Text = "Roof Tops", Side = "Right" })
    local roofLocations = {
    {name = "Rooftop 1", position = Vector3.new(-1612, 477, -507)},
    {name = "Rooftop 2", position = Vector3.new(-1727, 408, -1173)},
    {name = "Rooftop 3", position = Vector3.new(-1635, 443, -263)},
    {name = "Rooftop 4", position = Vector3.new(-1528, 476, -162)},
    {name = "Rooftop 5", position = Vector3.new(-1034, 423, -245)},
    {name = "Rooftop 6", position = Vector3.new(-1030, 379, -471)},
    {name = "Rooftop 7", position = Vector3.new(-686, 378, -317)},
    {name = "Rooftop 8", position = Vector3.new(-119, 442, -516)},
    {name = "Rooftop 9", position = Vector3.new(-79, 398, -712)},
    {name = "Rooftop 10", position = Vector3.new(-181, 437, -1153)}
    }
    createTeleportButtons(RoofSection, roofLocations)

--
-- Shop --
    local shopTab = Window:Tab({ Text = "Shop" })
    local exoticDealerSection = shopTab:Section({ Text = "Exotic Dealer" })
    local function purchaseItem(itemName)
    game:GetService("ReplicatedStorage"):WaitForChild("ExoticShopRemote"):InvokeServer(itemName)
    end
    exoticDealerSection:Button({ Text = "Lemonade $500", Callback = function()
    purchaseItem("Lemonade")
    end })
    exoticDealerSection:Button({ Text = "FakeCard $700", Callback = function()
    purchaseItem("FakeCard")
    end })
    exoticDealerSection:Button({ Text = "G26 $550", Callback = function()
    purchaseItem("G26")
    end })
    exoticDealerSection:Button({ Text = "Shiesty $75", Callback = function()
    purchaseItem("Shiesty")
    end })
    exoticDealerSection:Button({ Text = "RawSteak $10", Callback = function()
    purchaseItem("RawSteak")
    end })
    exoticDealerSection:Button({ Text = "Ice-Fruit Bag $2500", Callback = function()
    purchaseItem("Ice-Fruit Bag")
    end })
    exoticDealerSection:Button({ Text = "Ice-Fruit Cupz $150", Callback = function()
    purchaseItem("Ice-Fruit Cupz")
    end })
    exoticDealerSection:Button({ Text = "FijiWater $48", Callback = function()
    purchaseItem("FijiWater")
    end })
    exoticDealerSection:Button({ Text = "FreshWater $48", Callback = function()
    purchaseItem("FreshWater")
    end })

 local backpackShopSection = shopTab:Section({ Text = "Backpack Shop", Side = "Right" })
 local player = game:GetService("Players").LocalPlayer
 local userInputService = game:GetService("UserInputService")
 
 local function TriggerSeat()
    local humanoid = player.Character and player.Character:FindFirstChild("Humanoid")
    if humanoid then
        for _, obj in pairs(workspace:GetDescendants()) do
            if obj:IsA("Seat") or obj:IsA("VehicleSeat") then
                obj:Sit(humanoid)
                return
            end
        end
    end
 end
 
 local function teleportTo(position)
    TriggerSeat()  -- Sit in a chair
    task.wait(1)   -- Wait 1 second while seated
 
    if player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
        player.Character.HumanoidRootPart.CFrame = CFrame.new(position)
    end
 
    local humanoid = player.Character and player.Character:FindFirstChild("Humanoid")
    if humanoid then
        humanoid.Sit = false
    end
 end
 
 local function waitForEPress()
    return userInputService.InputBegan:Wait().KeyCode == Enum.KeyCode.E
 end
 
 local function buyBackpack(position)
    local originalPosition = player.Character and player.Character:FindFirstChild("HumanoidRootPart") and player.Character.HumanoidRootPart.Position
    teleportTo(position)  -- Teleport to backpack shop location
 
    repeat
        local keyPressed = waitForEPress()
    until keyPressed
 
    if originalPosition then
        repeat
            teleportTo(originalPosition)
            task.wait(0.5)
        until (player.Character and player.Character:FindFirstChild("HumanoidRootPart") and (player.Character.HumanoidRootPart.Position - originalPosition).Magnitude < 5)
    end
 end
 
 local backpacks = {
    { name = "Red Elite Bag $500", position = Vector3.new(-681, 254, -692) },
    { name = "Black Elite Bag $500", position = Vector3.new(-680, 254, -691) },
    { name = "Blue Elite Bag $500", position = Vector3.new(-676, 254, -690) },
    { name = "Drac Bag $700", position = Vector3.new(-673, 254, -691) },
    { name = "Yellow RCR Bag $2000", position = Vector3.new(-673, 254, -691) },
    { name = "Black RCR Bag $2000", position = Vector3.new(-672, 254, -690) },
    { name = "Red RCR Bag $2000", position = Vector3.new(-669, 254, -691) },
    { name = "Tan RCR Bag $2000", position = Vector3.new(-666, 254, -694) },
    { name = "Black Designer Bag $2000", position = Vector3.new(-668, 254, -692) }
 }
 
 for _, bag in ipairs(backpacks) do
    backpackShopSection:Button({
        Text = bag.name,
        Callback = function()
            buyBackpack(bag.position)
        end
    })
 end

-- Rage
 local RageTab = Window:Tab({ Text = "Rage" })
 local ExploitSection = RageTab:Section({ Text = "Exploit" })
 local playerPositions = {}
 local bringPlayersActive = false  -- Track bring players toggle state

 local function BringPlayersInFront()
    local players = game.Players:GetPlayers()
    local angleStep = 360 / math.max(#players, 1)  -- Avoid division by zero
    local radius = 10  -- Radius of the circle around the local player

    for i, player in ipairs(players) do
        if player ~= game.Players.LocalPlayer then
            local character = player.Character
            if character and character:FindFirstChild("HumanoidRootPart") then
                local humanoidRootPart = character.HumanoidRootPart
                local humanoid = character:FindFirstChild("Humanoid")
                if humanoid and not humanoid.SeatPart and humanoid.Health > 0 then
                    if not playerPositions[player] then
                        playerPositions[player] = humanoidRootPart.Position
                    end
                    local angle = math.rad(angleStep * i)
                    local xOffset = math.cos(angle) * radius
                    local zOffset = math.sin(angle) * radius
                    humanoidRootPart.CFrame = game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame * CFrame.new(xOffset, 0, zOffset)
                end
            end
        end
    end
 end

 local function ReturnPlayersToOriginalPosition()
    for player, originalPosition in pairs(playerPositions) do
        local character = player.Character
        if character and character:FindFirstChild("HumanoidRootPart") then
            character.HumanoidRootPart.CFrame = CFrame.new(originalPosition)
        end
    end
    playerPositions = {}  -- Clear the stored positions
 end

 local BringPlayersToggle = ExploitSection:Toggle({
    Text = "Bring All Players in Circle",  -- Text for the toggle
    Callback = function(toggleState)
        bringPlayersActive = toggleState  -- Update the tracking variable
        if bringPlayersActive then
            task.spawn(function()  -- Run in a separate thread to prevent UI lag
                while bringPlayersActive do
                    BringPlayersInFront()
                    wait(0.1)  -- Adjust the loop speed as needed
                end
            end)
        else
            ReturnPlayersToOriginalPosition()
        end
    end
 })

-- Troll --
    local TrollTab = Window:Tab({ Text = "Troll" })
    local twitterSection = TrollTab:Section({ Text = "Twitter" })

    -- Variable for Tweet message
    local tweetMessage = "Revamped.City"  -- Default tweet message

    -- Input box for tweet message (formatted as requested)
    twitterSection:Input({
    Text = "Tweet Message",
    Placeholder = "Enter your tweet message",
    Callback = function(value)
        tweetMessage = value
    end
    })

    -- Variable to track the toggle state for Annoy Server
    local v108 = false

    -- Toggle for Annoying Server (Send repeated tweets)
    twitterSection:Toggle({
    Text = "Spam Tweet",
    Description = "Send repeated tweets to annoy people in the server.",
    Default = false,
    Callback = function(toggleState)
        v108 = toggleState
        if v108 then
            -- Start sending the tweets repeatedly
            coroutine.wrap(
                function()
                    while v108 do
                        game:GetService("ReplicatedStorage"):WaitForChild("Resources"):WaitForChild("#Phone"):WaitForChild("Main"):FireServer(
                            "Tweet",
                            {"CreateTweet", tweetMessage}
                        )
                        wait(772.4 - (326 + 445)) -- Adjusted wait time
                    end
                end
            )()
        end
    end
    })




    local spammingRepost = false
    local spammingHeart = false

    local function TwitterAll(Type)
    for _, v in ipairs(game:GetService("Players").LocalPlayer.PlayerGui.Phone.Frame.Phone.Main.Twitter.ScrollingFrame:GetChildren()) do
        if v:IsA("Frame") then
            game:GetService("ReplicatedStorage"):WaitForChild("Resources"):WaitForChild("#Phone"):WaitForChild("Main"):FireServer(
                "Tweet",
                {[1] = Type, [2] = true, [3] = v.Name}
            )
        end
    end
    end

    -- Toggle to spam Repost All
    twitterSection:Toggle({
    Text = "Spam Repost All",
    Description = "Continuously repost all tweets.",
    Default = false,
    Callback = function(state)
        spammingRepost = state
        if spammingRepost then
            spammingHeart = false -- Disable Heart spam if active
            coroutine.wrap(function()
                while spammingRepost do
                    TwitterAll("Repost")
                    wait(.2) -- Adjust delay as needed
                end
            end)()
        end
    end
    })

    -- Toggle to spam Heart All
    twitterSection:Toggle({
    Text = "Spam Heart All",
    Description = "Continuously heart all tweets.",
    Default = false,
    Callback = function(state)
        spammingHeart = state
        if spammingHeart then
            spammingRepost = false -- Disable Repost spam if active
            coroutine.wrap(function()
                while spammingHeart do
                    TwitterAll("Liked")
                    wait(.2) -- Adjust delay as needed
                end
            end)()
        end
    end
    })

 local messagesSection = TrollTab:Section({ Text = "Messages" })

 -- Variables
 local messageText = "hello"
 local targetPlayerName = "Theyknowmyg"
 local delayBetween = 2
 local spamOne = false
 local spamAll = false

 -- Input: Message 
 messagesSection:Input({
    Text = "Message to Send",
    Placeholder = "Enter your message here",
    Callback = function(value)
        messageText = value
    end
 })

 -- Input: Target Player Name
 messagesSection:Input({
    Text = "Target Player Username",
    Placeholder = "Exact username (case sensitive)",
    Callback = function(value)
        targetPlayerName = value
    end
 })

 -- Slider: Delay between sends
 messagesSection:Slider({
    Text = "Delay Between Messages (Seconds)",
    Min = 1,
    Max = 10,
    Default = 2,
    Callback = function(value)
        delayBetween = value
    end
 })

 -- Toggle: Spam One Player
 messagesSection:Toggle({
    Text = "Spam Target Player",
    Description = "Repeatedly sends message to the selected player.",
    Default = false,
    Callback = function(state)
        spamOne = state
        if spamOne then
            spamAll = false
            coroutine.wrap(function()
                while spamOne do
                    local target = game:GetService("Players"):FindFirstChild(targetPlayerName)
                    if target then
                        local args = {
                            "Messaging",
                            {
                                "SentMessage",
                                messageText,
                                target
                            }
                        }
                        game:GetService("ReplicatedStorage")
                            :WaitForChild("Resources")
                            :WaitForChild("#Phone")
                            :WaitForChild("Main")
                            :FireServer(unpack(args))
                    end
                    wait(delayBetween)
                end
            end)()
        end
    end
 })

 -- Toggle: Spam All Players
 messagesSection:Toggle({
    Text = "Spam All Players",
    Description = "Sends message to all players one by one, repeatedly.",
    Default = false,
    Callback = function(state)
        spamAll = state
        if spamAll then
            spamOne = false
            coroutine.wrap(function()
                while spamAll do
                    for _, player in ipairs(game:GetService("Players"):GetPlayers()) do
                        if player ~= game.Players.LocalPlayer then
                            local args = {
                                "Messaging",
                                {
                                    "SentMessage",
                                    messageText,
                                    player
                                }
                            }
                            game:GetService("ReplicatedStorage")
                                :WaitForChild("Resources")
                                :WaitForChild("#Phone")
                                :WaitForChild("Main")
                                :FireServer(unpack(args))
                            wait(delayBetween)
                        end
                    end
                end
            end)()
        end
    end
 })
