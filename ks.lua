local HttpService = game:GetService("HttpService")
local Players = game:GetService("Players")
local Analytics = game:GetService("RbxAnalyticsService")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")

local player = Players.LocalPlayer
local clientId = Analytics:GetClientId()

-- CONFIG
local KEY_DATA_URL = "https://raw.githubusercontent.com/RevampedCity/NiMonkey/refs/heads/main/k.json"
local SCRIPT_URL = "https://raw.githubusercontent.com/RevampedCity/NiMonkey/refs/heads/main/os.lua"

-- Save key path
local SAVE_FILE = "keydata.txt"

-- Load saved key if available
local savedKey
if pcall(function() return readfile(SAVE_FILE) end) then
    savedKey = readfile(SAVE_FILE)
end

-- UI Setup
local screenGui = Instance.new("ScreenGui", player:WaitForChild("PlayerGui"))
screenGui.Name = "KeySystem"
screenGui.IgnoreGuiInset = true
screenGui.ResetOnSpawn = false

local frame = Instance.new("Frame", screenGui)
frame.Size = UDim2.new(0, 320, 0, 210)
frame.Position = UDim2.new(0.5, 0, 0.5, 0)
frame.AnchorPoint = Vector2.new(0.5, 0.5)
frame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
frame.BorderSizePixel = 0
frame.BackgroundTransparency = 0.1
frame.ClipsDescendants = true

local uicorner = Instance.new("UICorner", frame)
uicorner.CornerRadius = UDim.new(0, 12)

-- Make draggable
local dragging = false
local dragInput, dragStart, startPos

local function update(input)
	if dragging then
		local delta = input.Position - dragStart
		frame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X,
								 startPos.Y.Scale, startPos.Y.Offset + delta.Y)
	end
end

frame.InputBegan:Connect(function(input)
	if input.UserInputType == Enum.UserInputType.MouseButton1 then
		dragging = true
		dragStart = input.Position
		startPos = frame.Position
		
		input.Changed:Connect(function()
			if input.UserInputState == Enum.UserInputState.End then
				dragging = false
			end
		end)
	end
end)

frame.InputChanged:Connect(function(input)
	if input.UserInputType == Enum.UserInputType.MouseMovement then
		dragInput = input
	end
end)

UserInputService.InputChanged:Connect(update)

-- Title
local title = Instance.new("TextLabel", frame)
title.Text = "Login Page"
title.Font = Enum.Font.GothamBold
title.TextSize = 16
title.TextColor3 = Color3.fromRGB(200, 200, 200)
title.BackgroundTransparency = 1
title.Size = UDim2.new(1, -20, 0, 24)
title.Position = UDim2.new(0, 10, 0, 10)
title.TextXAlignment = Enum.TextXAlignment.Left

-- Client ID Label
local clientIdLabel = Instance.new("TextLabel", frame)
clientIdLabel.Text = "Client ID: " .. clientId
clientIdLabel.Font = Enum.Font.Gotham
clientIdLabel.TextSize = 12
clientIdLabel.TextColor3 = Color3.fromRGB(180, 180, 180)
clientIdLabel.BackgroundTransparency = 1
clientIdLabel.Size = UDim2.new(0.75, -20, 0, 20)
clientIdLabel.Position = UDim2.new(0, 20, 0, 40)
clientIdLabel.TextXAlignment = Enum.TextXAlignment.Left
clientIdLabel.TextTruncate = Enum.TextTruncate.AtEnd

-- Copy Button
local copyBtn = Instance.new("TextButton", frame)
copyBtn.Text = "Copy"
copyBtn.Font = Enum.Font.GothamBold
copyBtn.TextSize = 12
copyBtn.TextColor3 = Color3.fromRGB(220, 220, 220)
copyBtn.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
copyBtn.Size = UDim2.new(0.23, 0, 0, 20)
copyBtn.Position = UDim2.new(0.75, 0, 0, 40)

local copyCorner = Instance.new("UICorner", copyBtn)
copyCorner.CornerRadius = UDim.new(0, 6)

copyBtn.MouseButton1Click:Connect(function()
	setclipboard(clientId)
	copyBtn.Text = "Copied!"
	wait(1.5)
	copyBtn.Text = "Copy"
end)

-- Input Box
local inputBox = Instance.new("TextBox", frame)
inputBox.PlaceholderText = "Enter Key..."
inputBox.Text = ""
inputBox.Font = Enum.Font.Gotham
inputBox.TextSize = 14
inputBox.TextColor3 = Color3.new(1, 1, 1)
inputBox.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
inputBox.Size = UDim2.new(1, -40, 0, 36)
inputBox.Position = UDim2.new(0, 20, 0, 70)

local inputCorner = Instance.new("UICorner", inputBox)
inputCorner.CornerRadius = UDim.new(0, 8)

-- Set saved key if available
if savedKey then
	inputBox.Text = savedKey
end

-- Status Label
local status = Instance.new("TextLabel", frame)
status.Text = ""
status.Font = Enum.Font.Gotham
status.TextSize = 13
status.TextColor3 = Color3.fromRGB(200, 200, 200)
status.BackgroundTransparency = 1
status.Size = UDim2.new(1, -40, 0, 20)
status.Position = UDim2.new(0, 20, 0, 115)
status.TextWrapped = true
status.TextYAlignment = Enum.TextYAlignment.Top

-- Login Button
local loginBtn = Instance.new("TextButton", frame)
loginBtn.Text = "Login"
loginBtn.Font = Enum.Font.GothamBold
loginBtn.TextSize = 14
loginBtn.TextColor3 = Color3.fromRGB(100, 150, 255)
loginBtn.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
loginBtn.Size = UDim2.new(1, -40, 0, 30)
loginBtn.Position = UDim2.new(0, 20, 0, 140)

local loginCorner = Instance.new("UICorner", loginBtn)
loginCorner.CornerRadius = UDim.new(0, 6)

loginBtn.MouseEnter:Connect(function()
	loginBtn.TextColor3 = Color3.fromRGB(80, 130, 220)
end)
loginBtn.MouseLeave:Connect(function()
	loginBtn.TextColor3 = Color3.fromRGB(100, 150, 255)
end)

-- Fade out GUI function
local function fadeOut()
	local tween = TweenService:Create(frame, TweenInfo.new(0.4), {BackgroundTransparency = 1})
	tween:Play()
	for _, child in pairs(frame:GetChildren()) do
		if child:IsA("TextLabel") or child:IsA("TextBox") or child:IsA("TextButton") then
			TweenService:Create(child, TweenInfo.new(0.4), {TextTransparency = 1, BackgroundTransparency = 1}):Play()
		end
	end
	wait(0.5)
	screenGui:Destroy()
end

-- Validate Key Function
local function validateKey(inputKey)
	status.Text = "🔄 Validating..."
	
	local httpSuccess, httpResult = pcall(function()
		return game:HttpGet(KEY_DATA_URL)
	end)
	
	if not httpSuccess then
		status.Text = "❌ HTTP request failed: " .. tostring(httpResult)
		return
	end
	
	local decodeSuccess, result = pcall(function()
		return HttpService:JSONDecode(httpResult)
	end)
	
	if not decodeSuccess then
		status.Text = "❌ JSON decode failed: " .. tostring(result)
		return
	end
	
	for _, entry in pairs(result) do
		if entry.clientId == clientId and entry.key == inputKey then
			status.Text = "✅ Welcome, " .. (entry.username or "User") .. "!"
			
			pcall(function()
				writefile(SAVE_FILE, inputKey)
			end)

			wait(1)
			fadeOut()
			
			local success, scriptResult = pcall(function()
				local code = game:HttpGet(SCRIPT_URL)
				return loadstring(code)()
			end)
			
			if not success then
				warn("Failed to load external script: ", scriptResult)
			end
			
			return
		end
	end
	
	status.Text = "❌ Invalid key or client."
end

-- Login Button Clicked
loginBtn.MouseButton1Click:Connect(function()
	local key = inputBox.Text
	if key and #key > 0 then
		validateKey(key)
	else
		status.Text = "⚠️ Please enter a key."
	end
end)
