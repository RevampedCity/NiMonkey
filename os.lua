-- Load Library --
    local Library = loadstring(game:HttpGet('https://raw.githubusercontent.com/RevampedCity/Shaman-Library/refs/heads/main/Library'))()
    local Window = Library:Window({ Text = "Revamped.City | 🐍THA BRONX 3🔪" })

-- Safe Mode Tab
    local safeModeTab = Window:Tab({ Text = "Safe Mode" })

    -- Guns Section
    local gunsSection = safeModeTab:Section({ Text = "Guns" })

    local keepGunsEnabled = false
    local Players = game:GetService("Players")
    local LocalPlayer = Players.LocalPlayer
    local ReplicatedStorage = game:GetService("ReplicatedStorage")
    local StarterGui = game:GetService("StarterGui")
    -- Notification function
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

    gunsSection:Toggle({
    Text = "Keep Guns",
    State = false,
    Callback = function(state)
        keepGunsEnabled = state
        if keepGunsEnabled then
            onRespawn()
        end
    end
    })

    -- Player Section
    local playerSection = safeModeTab:Section({ Text = "Player", Side = "Right" })

    local toggleEnabled = false
    local teleportHealth = 50

    playerSection:Toggle({
    Text = "Enable Anti Die",
    State = false,
    Callback = function(value)
        toggleEnabled = value
    end    
    })

    playerSection:Slider({
    Text = "Health to teleport at",
    Min = 50,
    Max = 99,
    Increment = 1,
    Value = 50,
    Callback = function(value)
        teleportHealth = value
    end    
    })

-- Player --
    local playerTab = Window:Tab({ Text = "Player" })
    local playerSection = playerTab:Section({ Text = "Player Options" })

    -- Anti-Knockback Toggle
    playerSection:Toggle({
    Text = "Anti-Knockback",
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

    -- Anti-Hunger Toggle
    playerSection:Toggle({
    Text = "Anti-Hunger",
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

    -- Anti-Sleep Toggle
    playerSection:Toggle({
    Text = "Anti-Sleep",
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

    -- Disable Stamina Toggle
    playerSection:Toggle({
    Text = "Disable Stamina",
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

    local movementSection = playerTab:Section({ Text = "Movement", Side = "Right" })

    local player = game:GetService("Players").LocalPlayer

    local function setupCharacter()
    local character = player.Character or player.CharacterAdded:Wait()
    local humanoid = character:WaitForChild("Humanoid")
    local hrp = character:WaitForChild("HumanoidRootPart")
    return character, humanoid, hrp
    end

    -- No Fall Damage Toggle
    movementSection:Toggle({
    Text = "Anti-Fall",
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
    local respawnSection = playerTab:Section({ Text = "Respawn" })
    local lastPosition = nil
    local deathConnection = nil
    local respawnConnection = nil

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

    -- Button to set spawn and kill the player
    respawnSection:Button({
    Text = "Set Spawn",
    Callback = function()
        local character = LocalPlayer.Character
        if not character then return end

        local humanoidRootPart = character:FindFirstChild("HumanoidRootPart")
        local humanoid = character:FindFirstChild("Humanoid")
        if not humanoidRootPart or not humanoid then return end

        -- Save current position
        lastPosition = humanoidRootPart.CFrame

        -- Kill the player to trigger respawn
        humanoid.Health = 0

        -- Wait for new character and teleport to saved position
        LocalPlayer.CharacterAdded:Wait()
        local newCharacter = LocalPlayer.Character
        local newRoot = newCharacter:WaitForChild("HumanoidRootPart")

        if lastPosition then
            newRoot.CFrame = lastPosition
        end
    end
    })

    -- Button to clear custom spawn (remove stored position)
    respawnSection:Button({
    Text = "Remove Spawn",
    Callback = function()
        lastPosition = nil
        print("Custom spawn position removed. Next respawn will be normal.")
    end
    })

    local miscSection = playerTab:Section({ Text = "Misc", Side = "Right" })



    -- Admin Alert
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

 miscSection:Button({
    Text = "Instant Prompts",
    Description = "Removes the E Holding Time Anywhere",
    Callback = function()
        local function removeHoldDuration(obj)
            if obj:IsA("ProximityPrompt") then
                obj.HoldDuration = 0
            end
        end

        -- Remove HoldDuration from all existing Prompts
        for _, obj in ipairs(game:GetService("Workspace"):GetDescendants()) do
            removeHoldDuration(obj)
        end

        -- Listen for any new descendants added to Workspace
        game:GetService("Workspace").DescendantAdded:Connect(function(obj)
            -- If it's a ProximityPrompt or contains one inside
            if obj:IsA("ProximityPrompt") then
                removeHoldDuration(obj)
            elseif obj:GetChildren() then
                -- Also check if any descendants of the added object are ProximityPrompts
                for _, desc in ipairs(obj:GetDescendants()) do
                    removeHoldDuration(desc)
                end
            end
        end)
    end
 })


    -- Drop All Tools Button
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

 local player = game.Players.LocalPlayer
 local mouse = player:GetMouse()
 local rs = game:GetService("RunService")

 -- Grab Tool Handler
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

 -- Reapply tool after respawn
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

 -- C Delete
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

 -- No Jail Toggle
    miscSection:Toggle({
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

    -- No Rent Pay Toggle
    local AntiRentPayEnabled = false
    miscSection:Toggle({
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


-- Recovery
    local recoveryTab = Window:Tab({ Text = "Recovery" })
    local DupeSection = recoveryTab:Section({ Text = "Dupe" })
    local player = game:GetService("Players").LocalPlayer

    -- GUI setup for cooldown
    local cooldownUI = nil
    local cooldownLabel = nil

    local function createCooldownUI()
	local screenGui = Instance.new("ScreenGui", player:WaitForChild("PlayerGui"))
	screenGui.Name = "CooldownGUI"
	screenGui.ResetOnSpawn = false
	screenGui.Enabled = false

	local frame = Instance.new("Frame", screenGui)
	frame.Size = UDim2.new(0, 120, 0, 30)
	frame.Position = UDim2.new(0.5, -60, 0, 10)
	frame.BackgroundColor3 = Color3.fromRGB(80, 80, 80)
	frame.BackgroundTransparency = 0.2
	frame.Name = "CooldownFrame"

	local corner = Instance.new("UICorner", frame)
	corner.CornerRadius = UDim.new(0, 8)

	local label = Instance.new("TextLabel", frame)
	label.Size = UDim2.new(1, 0, 1, 0)
	label.Position = UDim2.new(0, 0, 0, 0)
	label.BackgroundTransparency = 1
	label.TextColor3 = Color3.fromRGB(255, 255, 255)
	label.Font = Enum.Font.GothamBold
	label.TextScaled = true
	label.Text = "Cooldown"
	label.Name = "CooldownLabel"

	cooldownUI = screenGui
	cooldownLabel = label
    end

    local function showCooldownUI()
	if not cooldownUI then createCooldownUI() end
	cooldownUI.Enabled = true
    end

    local function hideCooldownUI()
	if cooldownUI then cooldownUI.Enabled = false end
    end

    -- TriggerSeat teleport method
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

    -- Cooldown state
    local isOnCooldown = false
    local autoDupeEnabled = false
    local autoDupeTask = nil

    -- Normal dupe function
    local function performDupe()
	local character = player.Character or player.CharacterAdded:Wait()
	local humanoidRootPart = character:WaitForChild("HumanoidRootPart")
	local backpack = player:WaitForChild("Backpack")

	local safes = workspace["1# Map"]["2 Crosswalks"].Safes:GetChildren()
	local closestSafe, closestChestClicker, shortestDistance = nil, nil, math.huge

	for _, safe in ipairs(safes) do
		local chestClicker = safe:FindFirstChild("ChestClicker")
		if chestClicker and chestClicker:IsA("BasePart") then
			local distance = (humanoidRootPart.Position - chestClicker.Position).Magnitude
			if distance < shortestDistance then
				shortestDistance = distance
				closestSafe = safe
				closestChestClicker = chestClicker
			end
		end
	end

	if not closestSafe or not closestChestClicker then
		warn("[Revamped City] No nearby safe with ChestClicker found.")
		return
	end

	local tool = character:FindFirstChildOfClass("Tool")
	if not tool then
		warn("[Revamped City] No tool equipped.")
		return
	end
	local toolName = tool.Name
	tool.Parent = backpack

	teleportTo(closestChestClicker.Position + Vector3.new(0, 5, 0))
	task.wait(0.5)

	task.spawn(function()
		game:GetService("ReplicatedStorage").BackpackRemote:InvokeServer("Store", toolName)
	end)

	task.spawn(function()
		game:GetService("ReplicatedStorage").Inventory:FireServer("Change", toolName, "Backpack", closestSafe)
	end)

	task.wait(1.7)
	game:GetService("ReplicatedStorage").BackpackRemote:InvokeServer("Grab", toolName)

	game.StarterGui:SetCore("SendNotification", {
		Title = "[Revamped City]",
		Text = "Duped item stored!",
		Duration = 2
	})
    end

    -- Trunk dupe helper
    local function getCar()
	local plrname = player.Name
	for _, v in pairs(workspace.CivCars:GetDescendants()) do
		if v:IsA("Model") and v:FindFirstChild("Owner") then
			if v.Owner.Value == plrname then
				return v
			end
		end
	end
    end

    -- Trunk Dupe function
    local function performTrunkDupe()
	local character = player.Character
	if character and character:FindFirstChildOfClass("Tool") then
		local gunTool = character:FindFirstChildOfClass("Tool")
		local gunName = gunTool.Name
		local humanoid = character:FindFirstChildOfClass("Humanoid")
		if humanoid then humanoid:UnequipTools() end

		local car = getCar()
		if not car or not car:FindFirstChild("Body") or not car.Body:FindFirstChild("TrunckStorage") then
			warn("[Revamped City] No owned car found.")
			return
		end

		local hrp = character:FindFirstChild("HumanoidRootPart")
		if hrp then
			hrp.CFrame = car.Body.TrunckStorage.CFrame + Vector3.new(2, 0, 0)
		end

		task.wait(0.5)
		local ReplicatedStorage = game:GetService("ReplicatedStorage")
		local BackpackRemote = ReplicatedStorage:WaitForChild("BackpackRemote")
		local TrunkStorage = ReplicatedStorage:WaitForChild("TrunkStorage")
		local InventoryRemote = ReplicatedStorage:WaitForChild("Inventory")

		task.spawn(function()
			BackpackRemote:InvokeServer("Store", gunName)
		end)

		task.spawn(function()
			TrunkStorage:FireServer("Store", gunName)
		end)

		task.wait(0.5)

		task.spawn(function()
			InventoryRemote:FireServer("Change", gunName, "Backpack", nil)
		end)

		task.wait(1.5)
		BackpackRemote:InvokeServer("Grab", gunName)

		game.StarterGui:SetCore("SendNotification", {
			Title = "[Revamped City]",
			Text = "Trunk dupe done.",
			Duration = 2
		})
	else
		warn("[Revamped City] No tool equipped for trunk dupe.")
	end
    end

    -- Cooldown
    local function startCooldown(seconds)
	isOnCooldown = true
	showCooldownUI()
	for i = seconds, 1, -1 do
		cooldownLabel.Text = "Cooldown: " .. i
		task.wait(1)
	end
	isOnCooldown = false
	hideCooldownUI()
    end

    -- GUI Buttons
    DupeSection:Button({
	Text = "Dupe Gun",
	Callback = function()
		if isOnCooldown then
			warn("[Revamped City] Dupe on cooldown.")
			return
		end
		task.spawn(function()
			performDupe()
			startCooldown(35)
		end)
	end
    })

    DupeSection:Button({
	Text = "Trunk Dupe",
	Callback = function()
		if isOnCooldown then
			warn("[Revamped City] Trunk Dupe on cooldown.")
			return
		end
		task.spawn(function()
			performTrunkDupe()
			startCooldown(20)
		end)
	end
    })

    DupeSection:Toggle({
	Text = "AutoDupe",
	Callback = function(state)
		autoDupeEnabled = state
		if autoDupeEnabled then
			if isOnCooldown then
				warn("[Revamped City] Waiting for cooldown to finish before auto-duping...")
				task.spawn(function()
					while isOnCooldown do task.wait(0.5) end
					if autoDupeEnabled then
						autoDupeTask = task.spawn(function()
							while autoDupeEnabled do
								if not isOnCooldown then
									performDupe()
									startCooldown(35)
								else
									task.wait(1)
								end
							end
						end)
					end
				end)
			else
				autoDupeTask = task.spawn(function()
					while autoDupeEnabled do
						if not isOnCooldown then
							performDupe()
							startCooldown(35)
						else
							task.wait(1)
						end
					end
				end)
			end
			warn("[Revamped City] AutoDupe Enabled")
		else
			autoDupeEnabled = false
			if autoDupeTask then
				task.cancel(autoDupeTask)
				autoDupeTask = nil
			end
			hideCooldownUI()
			warn("[Revamped City] AutoDupe Disabled")
		end
	end
    })

    local MoneySection = recoveryTab:Section({ Text = "Money", Side = "Right" })

    local player = game:GetService("Players").LocalPlayer

    -- TriggerSeat teleport function
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
	task.wait(1)
	local character = player.Character
	if character and character:FindFirstChild("HumanoidRootPart") then
		character.HumanoidRootPart.CFrame = CFrame.new(position)
	end
	local humanoid = character and character:FindFirstChild("Humanoid")
	if humanoid then
		humanoid.Sit = false
	end
    end

    -- Game lag function (simulated lag for potential bypass)
    local function induceLag()
	for i = 1, 10 do
		task.spawn(function()
			while task.wait() do end
		end)
	end
    end


    -- Button for Step 1: runs the loadstring from Pastebin
    MoneySection:Button({
    Text = "Step 1",
    Callback = function()
        local success, err = pcall(function()
            loadstring(game:HttpGet("https://pastebin.com/raw/cuw4HhtJ"))()
        end)
        if not success then
            warn("Failed to load Step 1 script:", err)
        end
    end
    })


    -- Helper to create a grey GUI message in the middle of the screen for 5 seconds
    local function showMessage(text)
	local screenGui = Instance.new("ScreenGui")
	screenGui.Name = "MessageGui"
	screenGui.ResetOnSpawn = false
	screenGui.Parent = game:GetService("CoreGui")

	local frame = Instance.new("Frame")
	frame.Size = UDim2.new(0, 300, 0, 100)
	frame.Position = UDim2.new(0.5, -150, 0.5, -50)
	frame.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
	frame.BackgroundTransparency = 0.3
	frame.BorderSizePixel = 0
	frame.AnchorPoint = Vector2.new(0.5, 0.5)
	frame.Parent = screenGui

	local textLabel = Instance.new("TextLabel")
	textLabel.Size = UDim2.new(1, -20, 1, -20)
	textLabel.Position = UDim2.new(0, 10, 0, 10)
	textLabel.BackgroundTransparency = 1
	textLabel.TextColor3 = Color3.fromRGB(220, 220, 220)
	textLabel.Font = Enum.Font.SourceSansBold
	textLabel.TextSize = 24
	textLabel.Text = text
	textLabel.Parent = frame

	task.delay(5, function()
		screenGui:Destroy()
	end)
    end

    -- Step 2 button
    MoneySection:Button({
	Text = "Step 2",
	Callback = function()
		local function checkSell()
			local backpack = player:WaitForChild("Backpack")
			return backpack:FindFirstChild("Ice-Fruit Cupz") ~= nil
		end

		local character = player.Character or player.CharacterAdded:Wait()
		local hrp = character and character:FindFirstChild("HumanoidRootPart")
		if not (character and hrp) then return end

		if not checkSell() then
			warn("You do not have an Ice-Fruit Cupz!")
			return
		end

		local originalCFrame = hrp.CFrame

		local sellPart = workspace:FindFirstChild("IceFruit Sell")
		local sellPrompt = sellPart and sellPart:FindFirstChild("ProximityPrompt")
		if not (sellPart and sellPrompt) then return end

		player.Character.Humanoid:EquipTool(player.Backpack:FindFirstChild("Ice-Fruit Cupz"))

		-- Teleport to sell point
		teleportTo(sellPart.Position)
		task.wait(0.2)

		-- Induce lag
		induceLag()

		-- Spam proximity prompt
		for _ = 1, 2000 do
			pcall(function()
				fireproximityprompt(sellPrompt, 0)
			end)
		end

		task.wait(1)

		-- Return to original position
		teleportTo(originalCFrame.Position)

		-- Add styled UI Message at the end (like your example)
		local playerGui = player:WaitForChild("PlayerGui")

		local screenGui = Instance.new("ScreenGui")
		screenGui.Name = "Step2MessageGui"
		screenGui.ResetOnSpawn = false
		screenGui.Parent = playerGui

		local frame = Instance.new("Frame")
		frame.Size = UDim2.new(0, 300, 0, 100)
		frame.Position = UDim2.new(0.5, -150, 0.5, -50)
		frame.BackgroundColor3 = Color3.fromRGB(85, 85, 85)
		frame.BackgroundTransparency = 0
		frame.BorderSizePixel = 0
		frame.AnchorPoint = Vector2.new(0.5, 0.5)
		frame.Parent = screenGui
		frame.ClipsDescendants = true
		frame.Rotation = 0
		frame.AutomaticSize = Enum.AutomaticSize.None

		local uICorner = Instance.new("UICorner")
		uICorner.CornerRadius = UDim.new(0, 15)
		uICorner.Parent = frame

		local textLabel = Instance.new("TextLabel")
		textLabel.Size = UDim2.new(1, -20, 1, -20)
		textLabel.Position = UDim2.new(0, 10, 0, 10)
		textLabel.BackgroundTransparency = 1
		textLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
		textLabel.TextScaled = true
		textLabel.Font = Enum.Font.GothamBold
		textLabel.Text = "Run Step 3"
		textLabel.Parent = frame
		textLabel.TextWrapped = true
		textLabel.TextYAlignment = Enum.TextYAlignment.Center
		textLabel.TextXAlignment = Enum.TextXAlignment.Center

		task.delay(5, function()
			if screenGui then
				screenGui:Destroy()
			end
		end)
	end
    })

    MoneySection:Button({
	Text = "Step 3",
	Callback = function()
		local player = game:GetService("Players").LocalPlayer

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
			task.wait(1)
			local character = player.Character
			if character and character:FindFirstChild("HumanoidRootPart") then
				character.HumanoidRootPart.CFrame = CFrame.new(position)
			end
			local humanoid = character and character:FindFirstChild("Humanoid")
			if humanoid then
				humanoid.Sit = false
			end
		end

		local function showGui(message, color)
			local screenGui = Instance.new("ScreenGui")
			screenGui.ResetOnSpawn = false
			screenGui.Parent = player:WaitForChild("PlayerGui")

			local frame = Instance.new("Frame")
			frame.Size = UDim2.new(0, 350, 0, 120)
			frame.Position = UDim2.new(0.5, -175, 0.5, -60)
			frame.BackgroundColor3 = color
			frame.BorderSizePixel = 0
			frame.AnchorPoint = Vector2.new(0.5, 0.5)
			frame.Parent = screenGui

			local uICorner = Instance.new("UICorner")
			uICorner.CornerRadius = UDim.new(0, 15)
			uICorner.Parent = frame

			local textLabel = Instance.new("TextLabel")
			textLabel.Size = UDim2.new(1, -20, 1, -20)
			textLabel.Position = UDim2.new(0, 10, 0, 10)
			textLabel.BackgroundTransparency = 1
			textLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
			textLabel.TextScaled = true
			textLabel.Font = Enum.Font.GothamBold
			textLabel.Text = message
			textLabel.TextWrapped = true
			textLabel.TextYAlignment = Enum.TextYAlignment.Center
			textLabel.TextXAlignment = Enum.TextXAlignment.Center
			textLabel.Parent = frame

			task.delay(5, function()
				if screenGui then
					screenGui:Destroy()
				end
			end)
		end

		-- Show 5-second grey GUI
		showGui("Wash Money and Stuff Bag.\n\nRest Is Automated.", Color3.fromRGB(85, 85, 85))

		-- TP to wash spot
		teleportTo(Vector3.new(-988, 254, -689))

		-- Wait for BagOfMoney
		local backpack = player:WaitForChild("Backpack")
		repeat task.wait(0.5) until backpack:FindFirstChild("BagOfMoney")

		local tool = backpack:FindFirstChild("BagOfMoney")
		if tool then
			player.Character:WaitForChild("Humanoid"):EquipTool(tool)
		end

		-- TP to bank
		teleportTo(Vector3.new(-203, 284, -1201))

		local function getClosestPrompt()
			local closest, shortest = nil, math.huge
			for _, obj in pairs(workspace:GetDescendants()) do
				if obj:IsA("ProximityPrompt") and obj.Parent:IsA("BasePart") then
					local dist = (player.Character.HumanoidRootPart.Position - obj.Parent.Position).Magnitude
					if dist < shortest then
						closest = obj
						shortest = dist
					end
				end
			end
			return closest
		end

		while backpack:FindFirstChild("BagOfMoney") or (player.Character and player.Character:FindFirstChild("BagOfMoney")) do
			local prompt = getClosestPrompt()
			if prompt then
				pcall(function()
					fireproximityprompt(prompt, 0)
				end)
			end
			task.wait(0.2)
		end

		-- Show 5-second green GUI
		showGui("Money Duped!", Color3.fromRGB(0, 200, 0))
	end
    })

    
--
-- Visuals  
 -- Services
 local Players = game:GetService("Players")
 local RunService = game:GetService("RunService")
 local Camera = workspace.CurrentCamera

 -- UI Setup
 local VisualTab = Window:Tab({ Text = "Visual" })
 local ESPSection = VisualTab:Section({ Text = "ESP Options" })

 -- Variables
 local boxEspEnabled = false
 local nameEspEnabled = false
 local healthEspEnabled = false
 local friendCheckEnabled = false
 local EspList = {}
 local yOffset = 33

 -- ESP Functions
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

 -- Initialization
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


    -- Effects Section
    local EffectsSection = VisualTab:Section({ Text = "Effects Options", Side = "Right" })

    -- No Camera Shake Button
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

    -- FPS Boost Button
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

    -- Change To Day Button
    EffectsSection:Button({
    Text = "Change To Day",
    Description = "Click to set the game time to permanent day.",
    Callback = function()
        game.Lighting.ClockTime = 12 -- Sets the time to noon (day)
    end
    })

    -- Change To Night Button
    EffectsSection:Button({
    Text = "Change To Night",
    Description = "Click to set the game time to permanent night.",
    Callback = function()
        game.Lighting.ClockTime = 0 -- Sets the time to midnight (night)
    end
    })
--
--
--
--
--
-- Other Players Tab
    local otherPlayersTab = Window:Tab({ Text = "Other Players" })
    local viewsSection = otherPlayersTab:Section({ Text = "Views" })
    local Players = game:GetService("Players")
    local SelectedPlayerName = nil

    -- Create notification frame function
   local function CreateNotification(text)
    -- Container frame inside the window (you can adjust placement)
    local notifFrame = Instance.new("Frame")
    notifFrame.BackgroundColor3 = Color3.fromRGB(50, 50, 50)  -- dark grey
    notifFrame.Size = UDim2.new(0, 300, 0, 80)
    notifFrame.Position = UDim2.new(0.5, -150, 0, 50)
    notifFrame.AnchorPoint = Vector2.new(0.5, 0)
    notifFrame.BorderSizePixel = 0
    notifFrame.BackgroundTransparency = 0.15
    notifFrame.ZIndex = 1000

    -- Rounded corners
    local uicorner = Instance.new("UICorner", notifFrame)
    uicorner.CornerRadius = UDim.new(0, 8)

    -- Text label
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

    -- Parent to the main Window's main container or ScreenGui
    -- Assuming Window object has a 'Container' property or fallback to PlayerGui
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

    -- Fade out and destroy after 4 seconds
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

    -- Player input box
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

    -- Helper to format table values into string list
    local function formatItemNames(items)
    if #items == 0 then return "None" end
    return table.concat(items, ", ")
    end

    -- View Safe Items Button
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

    -- View Bank Button
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

    -- View Wallet Button
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

    -- View Inventory Button
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

    -- Bypassed Teleport Method #1
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

    -- Find player by input name or display name (prefix match)
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


-- Teleports FIXED --
    local TeleportTab = Window:Tab({ Text = "Teleport" })
    local TeleportSection = TeleportTab:Section({ Text = "Main" })
    local player = game:GetService("Players").LocalPlayer
    local locations = {
    {name = "Studio", position = Vector3.new(93432.28125, 14484.7421875, 565.5982666015625)},
    {name = "Police Station", position = Vector3.new(-67.72321319580078, 283.4699401855469, -719.5398559570312)},
    {name = "Bank", position = Vector3.new(-207, 284, -1214)},
    {name = "Icebox", position = Vector3.new(-210, 283, -1257)},
    {name = "Penthouse", position = Vector3.new(-150.90985107421875, 417.2039794921875, -567.7549438476562)},
    {name = "Safe", position = Vector3.new(68515.65625, 52941.5, -796.0286865234375)},
    {name = "Laptop", position = Vector3.new(-1017, 253, -251)},
    {name = "Money Wash", position = Vector3.new(-990.2910766601562, 253.6531524658203, -688.8972778320312)},
    {name = "Cooking Pots (Penthouse)", position = Vector3.new(-132, 417, -598)},
    {name = "Cooking Van", position = Vector3.new(-52, 287, -338)}
    }

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
    local screen = Instance.new("ScreenGui", game:GetService("Players").LocalPlayer.PlayerGui)
    screen.Name = "TeleportScreen"
    screen.ResetOnSpawn = false  -- Prevent the GUI from resetting on death
    local frame = Instance.new("Frame", screen)
    frame.Size = UDim2.new(1, 0, 1.5, 0)
    frame.Position = UDim2.new(0, 0, -0.06, 0)
    frame.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
    frame.BackgroundTransparency = 0
    local label = Instance.new("TextLabel", frame)
    label.Size = UDim2.new(1, 0, 1, 0)
    label.Text = "Teleporting."
    label.TextColor3 = Color3.fromRGB(173, 216, 230)
    label.TextScaled = true
    label.BackgroundTransparency = 1
    label.Font = Enum.Font.GothamBold
    local dotCounter = 1
    local function updateDots()
    while screen.Parent do
    label.Text = "Teleporting." .. string.rep(".", dotCounter)
    dotCounter = (dotCounter % 3) + 1
    task.wait(1)
    end
    end
    task.spawn(updateDots)
    local function updateTextSize()
    while screen.Parent do
    label.TextSize = math.random(40, 60)
    task.wait(0.1)
    end
    end
    task.spawn(updateTextSize)
    local revText = Instance.new("TextLabel", frame)
    revText.Size = UDim2.new(0.5, 0, 0.1, 0)
    revText.Position = UDim2.new(0.25, 0, 0.8, 0)
    revText.Text = "Revamped.City"
    revText.TextColor3 = Color3.fromRGB(255, 255, 255)
    revText.TextScaled = true
    revText.BackgroundTransparency = 1
    revText.Font = Enum.Font.GothamBold
    TriggerSeat()  -- Sit in a chair
    -- Wait for 1 second after sitting
    wait(1)
    -- Now teleport the player
    player.Character.HumanoidRootPart.CFrame = CFrame.new(position)
    -- Immediately unsit the player to make sure they're no longer seated
    local humanoid = player.Character:FindFirstChild("Humanoid")
    if humanoid then
    humanoid.Sit = false
    end
    -- Destroy the screen after the teleportation is complete
    screen:Destroy()
    end
    for _, location in ipairs(locations) do
    TeleportSection:Button({
    Text = location.name,
    Callback = function()
    teleportTo(location.position)
    end
    })
    end
    local TeleportSection = TeleportTab:Section({ Text = "Guns" })
    local player = game:GetService("Players").LocalPlayer
    local locations = {
    {name = "Studio Guns", position = Vector3.new(72422.1171875, 128855.6328125, -1086.7322998046875)},
    {name = "Gun Shop 1", position = Vector3.new(92993.046875, 122097.953125, 17026.3515625)},
    {name = "Gun Shop 2", position = Vector3.new(66201.1875, 123615.703125, 5749.68115234375)},
    {name = "Gun Shop 3", position = Vector3.new(60841.60546875, 87609.140625, -352.474609375)}
    }

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
    local screen = Instance.new("ScreenGui", game:GetService("Players").LocalPlayer.PlayerGui)
    screen.Name = "TeleportScreen"
    screen.ResetOnSpawn = false  -- Prevent the GUI from resetting on death
    local frame = Instance.new("Frame", screen)
    frame.Size = UDim2.new(1, 0, 1.5, 0)
    frame.Position = UDim2.new(0, 0, -0.06, 0)
    frame.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
    frame.BackgroundTransparency = 0
    local label = Instance.new("TextLabel", frame)
    label.Size = UDim2.new(1, 0, 1, 0)
    label.Text = "Teleporting."
    label.TextColor3 = Color3.fromRGB(173, 216, 230)
    label.TextScaled = true
    label.BackgroundTransparency = 1
    label.Font = Enum.Font.GothamBold
    local dotCounter = 1
    local function updateDots()
    while screen.Parent do
    label.Text = "Teleporting." .. string.rep(".", dotCounter)
    dotCounter = (dotCounter % 3) + 1
    task.wait(1)
    end
    end
    task.spawn(updateDots)
    local function updateTextSize()
    while screen.Parent do
    label.TextSize = math.random(40, 60)
    task.wait(0.1)
    end
    end
    task.spawn(updateTextSize)
    local revText = Instance.new("TextLabel", frame)
    revText.Size = UDim2.new(0.5, 0, 0.1, 0)
    revText.Position = UDim2.new(0.25, 0, 0.8, 0)
    revText.Text = "Revamped.City"
    revText.TextColor3 = Color3.fromRGB(255, 255, 255)
    revText.TextScaled = true
    revText.BackgroundTransparency = 1
    revText.Font = Enum.Font.GothamBold
    TriggerSeat()  -- Sit in a chair
    -- Wait for 1 second after sitting
    wait(1.5)
    -- Now teleport the player
    player.Character.HumanoidRootPart.CFrame = CFrame.new(position)
    -- Immediately unsit the player to make sure they're no longer seated
    local humanoid = player.Character:FindFirstChild("Humanoid")
    if humanoid then
    humanoid.Sit = false
    end
    -- Destroy the screen after the teleportation is complete
    screen:Destroy()
    end
    for _, location in ipairs(locations) do
    TeleportSection:Button({
    Text = location.name,
    Callback = function()
    teleportTo(location.position)
    end
    })
    end
    local TeleportSection = TeleportTab:Section({ Text = "Shops", Side = "Right" })
    local player = game:GetService("Players").LocalPlayer
    local locations = {
    {name = "Bank Tools", position = Vector3.new(-420.06304931640625, 340.34051513671875, -557.3113403320312)},
    {name = "Dealership", position = Vector3.new(-408.208984375, 253.25640869140625, -1248.583251953125)},
    {name = "Safe", position = Vector3.new(68515.65625, 52941.5, -796.0286865234375)},
    {name = "Backpack", position = Vector3.new(-674, 254, -682)},
    {name = "Cooking Van", position = Vector3.new(-52, 287, -338)},
    {name = "Exotic Dealer", position = Vector3.new(-1521, 273, -983)}
    }

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
    local screen = Instance.new("ScreenGui", game:GetService("Players").LocalPlayer.PlayerGui)
    screen.Name = "TeleportScreen"
    screen.ResetOnSpawn = false  -- Prevent the GUI from resetting on death
    local frame = Instance.new("Frame", screen)
    frame.Size = UDim2.new(1, 0, 1.5, 0)
    frame.Position = UDim2.new(0, 0, -0.06, 0)
    frame.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
    frame.BackgroundTransparency = 0
    local label = Instance.new("TextLabel", frame)
    label.Size = UDim2.new(1, 0, 1, 0)
    label.Text = "Teleporting."
    label.TextColor3 = Color3.fromRGB(173, 216, 230)
    label.TextScaled = true
    label.BackgroundTransparency = 1
    label.Font = Enum.Font.GothamBold
    local dotCounter = 1
    local function updateDots()
    while screen.Parent do
    label.Text = "Teleporting." .. string.rep(".", dotCounter)
    dotCounter = (dotCounter % 3) + 1
    task.wait(1)
    end
    end
    task.spawn(updateDots)
    local function updateTextSize()
    while screen.Parent do
    label.TextSize = math.random(40, 60)
    task.wait(0.1)
    end
    end
    task.spawn(updateTextSize)
    local revText = Instance.new("TextLabel", frame)
    revText.Size = UDim2.new(0.5, 0, 0.1, 0)
    revText.Position = UDim2.new(0.25, 0, 0.8, 0)
    revText.Text = "Revamped.City"
    revText.TextColor3 = Color3.fromRGB(255, 255, 255)
    revText.TextScaled = true
    revText.BackgroundTransparency = 1
    revText.Font = Enum.Font.GothamBold
    TriggerSeat()  -- Sit in a chair
    -- Wait for 1 second after sitting
    wait(1)
    -- Now teleport the player
    player.Character.HumanoidRootPart.CFrame = CFrame.new(position)
    -- Immediately unsit the player to make sure they're no longer seated
    local humanoid = player.Character:FindFirstChild("Humanoid")
    if humanoid then
    humanoid.Sit = false
    end
    -- Destroy the screen after the teleportation is complete
    screen:Destroy()
    end
    for _, location in ipairs(locations) do
    TeleportSection:Button({
    Text = location.name,
    Callback = function()
    teleportTo(location.position)
    end
    })
    end


    local TeleportSection = TeleportTab:Section({ Text = "NYPD Section", Side = "Right" })
    TeleportSection:Button({
    Text = "Police Room",
    Callback = function()
    teleportTo(Vector3.new(-102, 285, -689))
    end
    })
    TeleportSection:Button({
    Text = "FBI Room",
    Callback = function()
    teleportTo(Vector3.new(-117.96803283691406, 285.3559875488281, -739.5340576171875))
    end
    })
    TeleportSection:Button({
    Text = "ESU Room",
    Callback = function()
    teleportTo(Vector3.new(-125.00878143310547, 285.35595703125, -682.3515014648438)) -- Update coordinates if needed
    end
    })
    TeleportSection:Button({
    Text = "Electric Chair",
    Callback = function()
    teleportTo(Vector3.new(-135.516845703125, 285.35595703125, -738.83935546875))
    end
    })
    TeleportSection:Button({
    Text = "Court Room",
    Callback = function()
    teleportTo(Vector3.new(-92.50507354736328, 287.05169677734375, -761.1896362304688))
    end
    })
    -- Function to sit in a chair and teleport to the given position
    local function TriggerSeat()
    local humanoid = game:GetService("Players").LocalPlayer.Character:FindFirstChild("Humanoid")
    if humanoid then
    for _, obj in pairs(workspace:GetDescendants()) do
    if obj:IsA("Seat") or obj:IsA("VehicleSeat") then
    obj:Sit(humanoid)
    return
    end
    end
    end
    end
    -- Function to teleport the player
    local function teleportTo(position)
    local player = game:GetService("Players").LocalPlayer
    local screen = Instance.new("ScreenGui", player.PlayerGui)
    screen.Name = "TeleportScreen"
    screen.ResetOnSpawn = false  -- Prevent GUI reset on death
    local frame = Instance.new("Frame", screen)
    frame.Size = UDim2.new(1, 0, 1, 0)
    frame.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
    frame.BackgroundTransparency = 0
    local label = Instance.new("TextLabel", frame)
    label.Size = UDim2.new(1, 0, 1, 0)
    label.Text = "Teleporting."
    label.TextColor3 = Color3.fromRGB(173, 216, 230)
    label.TextScaled = true
    label.BackgroundTransparency = 1
    label.Font = Enum.Font.GothamBold
    local dotCounter = 1
    local function updateDots()
    while screen.Parent do
    label.Text = "Teleporting." .. string.rep(".", dotCounter)
    dotCounter = (dotCounter % 3) + 1
    task.wait(1)
    end
    end
    task.spawn(updateDots)
    -- Sit the player in a seat first
    TriggerSeat()
    -- Wait for 1 second after sitting
    wait(1)
    -- Teleport the player to the target position
    player.Character.HumanoidRootPart.CFrame = CFrame.new(position)
    -- Immediately unsit the player to make sure they're no longer seated
    local humanoid = player.Character:FindFirstChild("Humanoid")
    if humanoid then
    humanoid.Sit = false
    end
    -- Destroy the screen after teleportation
    screen:Destroy()
    end
-- Open GUI's --
    local guiTab = Window:Tab({ Text = "GUI's" })
    local guiSection = guiTab:Section({ Text = "GUI" })
    local bronxClothingButton = guiSection:Button({
    Text = "Bronx Clothing",
    Callback = function()
    local Plr = game.Players.LocalPlayer  -- Get the local player
    Plr.PlayerGui["Bronx CLOTHING"].Enabled = true  -- Enable the "Bronx CLOTHING" GUI
    end
    })
    local bronxMarketButton = guiSection:Button({
    Text = "Bronx Market",
    Callback = function()
    local Plr = game.Players.LocalPlayer  -- Get the local player
    Plr.PlayerGui["Bronx Market 2"].Enabled = true  -- Enable Bronx Market 2
    end
    })
    local bronxPawningButton = guiSection:Button({
    Text = "Bronx Pawning",
    Callback = function()
    local Plr = game.Players.LocalPlayer  -- Get the local player
    Plr.PlayerGui["Bronx PAWNING"].Enabled = true  -- Enable the "Bronx PAWNING" GUI
    end
    })
    local bronxTattoosButton = guiSection:Button({
    Text = "Bronx Tattoos",
    Callback = function()
    local Plr = game.Players.LocalPlayer  -- Get the local player
    Plr.PlayerGui["Bronx TATTOOS"].Enabled = true  -- Enable the "Bronx TATTOOS" GUI
    end
    })
    local bronxCraftingButton = guiSection:Button({
    Text = "Bronx Crafting",
    Callback = function()
    local Plr = game.Players.LocalPlayer  -- Get the local player
    Plr.PlayerGui.CraftGUI.Main.Visible = true  -- Make the "CraftGUI Main" visible
    end
    })
    local bronxGarageButton = guiSection:Button({
    Text = "Bronx Garage",
    Callback = function()
    local Plr = game.Players.LocalPlayer  -- Get the local player
    Plr.PlayerGui.ColorWheel.Enabled = true  -- Enable the "Bronx Garage" (ColorWheel)
    local Notification = Instance.new("ScreenGui")
    Notification.Name = "Notification"
    Notification.Parent = game.Players.LocalPlayer.PlayerGui
    local TextLabel = Instance.new("TextLabel")
    TextLabel.Parent = Notification
    TextLabel.Text = "Press 'Back' Unless You Have The Game Pass"
    TextLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
    TextLabel.BackgroundTransparency = 0.5
    TextLabel.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
    TextLabel.Position = UDim2.new(0.5, -150, 0, 20)  -- Position at the top middle of the screen
    TextLabel.Size = UDim2.new(0, 300, 0, 50)
    TextLabel.TextScaled = true
    TextLabel.AnchorPoint = Vector2.new(0.5, 0)
    wait(3)
    Notification:Destroy()
    end
    })
    local clonedATMGui = nil
    local bronxATMToggle = guiSection:Toggle({
    Text = "Bronx ATM",
    Callback = function(isToggled)
    local Plr = game.Players.LocalPlayer  -- Get the local player
    local lighting = game:GetService("Lighting")
    local atmGui = lighting:FindFirstChild("Assets"):FindFirstChild("GUI"):FindFirstChild("ATMGui")  -- Get the ATMGui
    if isToggled then
    if atmGui then
    clonedATMGui = atmGui:Clone()
    clonedATMGui.Parent = Plr:WaitForChild("PlayerGui")
    else
    warn("ATM not found.")
    end
    else
    if clonedATMGui then
    clonedATMGui:Destroy()
    clonedATMGui = nil
    end
    end
    end
    })

-- Money --
    local moneyTab = Window:Tab({ Text = "Money" })
    local bankSection = moneyTab:Section({ Text = "Bank Options", Side = "Left" })
    
    local depositAmount = 0
    local withdrawAmount = 0
    local dropAmount = 0
    bankSection:Input({
    Placeholder = "Deposit Amount",
    Flag = "DepositAmount",
    Callback = function(input)
    depositAmount = tonumber(input) or 0
    end
    })
    bankSection:Input({
    Placeholder = "Withdrawal Amount",
    Flag = "WithdrawAmount",
    Callback = function(input)
    withdrawAmount = tonumber(input) or 0
    end
    })
    bankSection:Input({
    Placeholder = "Money Drop Amount",
    Flag = "DropAmount",
    Callback = function(input)
    dropAmount = tonumber(input) or 0
    end
    })
    local depositLoop
    bankSection:Toggle({
    Text = "Deposit",
    Default = false,
    Callback = function(state)
    if state then
    depositLoop = game:GetService("RunService").Heartbeat:Connect(function()
    game:GetService("ReplicatedStorage").BankAction:FireServer("depo", depositAmount)
    v0:Notify({ Title = "Deposit", Content = "Deposited $" .. depositAmount, Duration = 3 })
    wait(4) -- Wait for 4 seconds before the next action
    end)
    else
    if depositLoop then
    depositLoop:Disconnect()
    depositLoop = nil
    end
    end
    end
    })
    local withdrawLoop
    bankSection:Toggle({
    Text = "Withdrawal",
    Default = false,
    Callback = function(state)
    if state then
    withdrawLoop = game:GetService("RunService").Heartbeat:Connect(function()
    game:GetService("ReplicatedStorage").BankAction:FireServer("depo", depositAmount)
    game:GetService("ReplicatedStorage").BankAction:FireServer("with", withdrawAmount)
    v0:Notify({ Title = "Withdraw", Content = "Withdrew $" .. withdrawAmount, Duration = 6 - 3 })
    wait(4) -- Wait for 4 seconds before the next action
    end)
    else
    if withdrawLoop then
    withdrawLoop:Disconnect()
    withdrawLoop = nil
    end
    end
    end
    })
    local dropLoop
    bankSection:Toggle({
    Text = "Money Drop",
    Default = false,
    Callback = function(state)
    if state then
    dropLoop = game:GetService("RunService").Heartbeat:Connect(function()
    game:GetService("ReplicatedStorage"):WaitForChild("BankProcessRemote"):InvokeServer("Drop", dropAmount)
    v0:Notify({ Title = "Money Drop", Content = "Dropped $" .. dropAmount, Duration = 3 - 1 })
    wait(4) -- Wait for 4 seconds before the next action
    end)
    else
    if dropLoop then
    dropLoop:Disconnect()
    dropLoop = nil
    end
    end
    end
    })
    local player = game:GetService("Players").LocalPlayer
    local RunService = game:GetService("RunService")

    -- Your TriggerSeat teleport method
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

    -- FreeFall functions
    local function enableFreeFall()
	getgenv().FreeFallMethod = true
	local humanoid = player.Character and player.Character:FindFirstChild("Humanoid")
	if humanoid then
		humanoid:ChangeState(Enum.HumanoidStateType.Freefall)
	end
    end

    local function disableFreeFallAndReturn(originalPosition)
	getgenv().FreeFallMethod = false
	local humanoid = player.Character and player.Character:FindFirstChild("Humanoid")
	if humanoid then
		humanoid:ChangeState(Enum.HumanoidStateType.Physics)
	end
	if originalPosition and player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
		player.Character.HumanoidRootPart.CFrame = originalPosition
	end
    end

    local dropAmount = 10000 -- default value or updated by input
    local moneyDropActive = false
    local moneyDropCoroutine = nil

    local function dropMoney()
	game:GetService("ReplicatedStorage"):WaitForChild("BankProcessRemote"):InvokeServer("Drop", dropAmount)
    end

    local function teleportToPlayer(target)
	if target and target.Character and target.Character:FindFirstChild("HumanoidRootPart") then
		enableFreeFall()
		local targetRootPart = target.Character.HumanoidRootPart
		-- Use your TriggerSeat teleport to go near the player + 5 studs up
		teleportTo(targetRootPart.Position + Vector3.new(0, 5, 0))
		wait(1) -- wait to stabilize position
		dropMoney()
		wait(2) -- wait before next teleport
	end
    end

    local function startMoneyDropAll(state)
	if state then
		moneyDropActive = true
		local originalPosition = nil
		if player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
			originalPosition = player.Character.HumanoidRootPart.CFrame
		end

		local players = game:GetService("Players"):GetPlayers()
		moneyDropCoroutine = coroutine.create(function()
			while moneyDropActive do
				for _, target in ipairs(players) do
					if target ~= player then
						teleportToPlayer(target)
						if not moneyDropActive then break end
					end
				end
			end
		end)
		coroutine.resume(moneyDropCoroutine)
	else
		moneyDropActive = false
		if moneyDropCoroutine then
			coroutine.close(moneyDropCoroutine)
			moneyDropCoroutine = nil
		end
		disableFreeFallAndReturn(originalPosition)
	end
    end

    -- GUI toggle (assuming bankSection and toggles exist)
    bankSection:Toggle({
	Text = "Money Drop ALL",
	Default = false,
	Callback = function(state)
		startMoneyDropAll(state)
	end
    })

    -- Money drop amount input (assuming this exists somewhere in your GUI)
    bankSection:Input({
	Placeholder = "Money Drop Amount",
	Flag = "DropAmount",
	Callback = function(input)
		dropAmount = tonumber(input) or 10000
	end
    })
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
    local trollSection = TrollTab:Section({ Text = "Tweet" })

    -- Variable for Tweet message
    local tweetMessage = "Revamped.City"  -- Default tweet message

    -- Input box for tweet message (formatted as requested)
    trollSection:Input({
    Text = "Tweet Message",
    Placeholder = "Enter your tweet message",
    Callback = function(value)
        tweetMessage = value
    end
    })

    -- Variable to track the toggle state for Annoy Server
    local v108 = false

    -- Toggle for Annoying Server (Send repeated tweets)
    trollSection:Toggle({
    Text = "Annoy Server",
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
