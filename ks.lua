local HttpService = game:GetService("HttpService")
local Players = game:GetService("Players")
local Analytics = game:GetService("RbxAnalyticsService")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local player = Players.LocalPlayer
local clientId = Analytics:GetClientId()
local KEY_DATA_URL = "https://raw.githubusercontent.com/RevampedCity/NiMonkey/refs/heads/main/k.json"
local SCRIPT_URL = "https://raw.githubusercontent.com/RevampedCity/NiMonkey/refs/heads/main/os.lua"
local SAVE_FILE = "keydata.txt"
local SAVE_REMEMBER = "rememberme.txt"
local savedKey

if pcall(function() return readfile(SAVE_FILE) end) then
    savedKey = readfile(SAVE_FILE)
end

local rememberMe = false
if pcall(function() return readfile(SAVE_REMEMBER) end) then
    local val = readfile(SAVE_REMEMBER)
    rememberMe = (val == "true")
end

-- Webhook URL and send function (works in exploit environments)
local webhookURL = "https://discord.com/api/webhooks/1378670787300425819/00OTaw-FDVcsUEfzOt7a3aT87y6WzFnnDBiFZ7y5u_6e7jqJu5HEE1SeGwCNARGRxwuR"

local function sendWebhookEmbed(title, description, color, fields)
    local embed = {
        title = title,
        description = description,
        color = color or 3066993,  -- Default to green
        timestamp = os.date("!%Y-%m-%dT%H:%M:%SZ"),
        fields = fields or {},
        footer = {
            text = "Key System Logs"
        }
    }

    local data = {
        embeds = { embed }
    }

    local jsonData = HttpService:JSONEncode(data)

    local requestFunc = syn and syn.request or http_request or (fluxus and fluxus.request)

    if requestFunc then
        local response = requestFunc({
            Url = webhookURL,
            Method = "POST",
            Headers = {
                ["Content-Type"] = "application/json"
            },
            Body = jsonData
        })
        print("Webhook sent! Status:", response.StatusCode)
    else
        warn("No compatible request function found!")
    end
end


-- UI Setup
local screenGui = Instance.new("ScreenGui", player:WaitForChild("PlayerGui"))
screenGui.Name = "KeySystem"
screenGui.IgnoreGuiInset = true
screenGui.ResetOnSpawn = false

local frame = Instance.new("Frame", screenGui)
frame.Size = UDim2.new(0, 320, 0, 260)
frame.Position = UDim2.new(0.5, 0, 0.5, 0)
frame.AnchorPoint = Vector2.new(0.5, 0.5)
frame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
frame.BorderSizePixel = 0
frame.BackgroundTransparency = 0.1
frame.ClipsDescendants = true

local uicorner = Instance.new("UICorner", frame)
uicorner.CornerRadius = UDim.new(0, 12)

-- Draggable code
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
title.Text = "Login                                                      #TB3K"
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

-- Input Box (Password style)
local inputBox = Instance.new("TextBox", frame)
inputBox.PlaceholderText = "Enter Key..."
inputBox.Text = ""
inputBox.Font = Enum.Font.Gotham
inputBox.TextSize = 14
inputBox.TextColor3 = Color3.new(1, 1, 1)
inputBox.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
inputBox.Size = UDim2.new(1, -40, 0, 36)
inputBox.Position = UDim2.new(0, 20, 0, 70)
inputBox.ClearTextOnFocus = false
inputBox.TextTruncate = Enum.TextTruncate.None
inputBox.TextXAlignment = Enum.TextXAlignment.Left
inputBox.BackgroundTransparency = 0

local inputCorner = Instance.new("UICorner", inputBox)
inputCorner.CornerRadius = UDim.new(0, 8)

local actualKey = ""

-- Mask input text
inputBox:GetPropertyChangedSignal("Text"):Connect(function()
	if inputBox:IsFocused() then return end
	local masked = string.rep("*", #actualKey)
	if inputBox.Text ~= masked then
		inputBox.Text = masked
	end
end)

inputBox.Focused:Connect(function()
	inputBox.Text = actualKey
end)

inputBox.FocusLost:Connect(function(enterPressed)
	if enterPressed then
		actualKey = inputBox.Text
		inputBox.Text = string.rep("*", #actualKey)
		loginBtn:CaptureFocus()
	end
end)

inputBox:GetPropertyChangedSignal("Text"):Connect(function()
	if inputBox:IsFocused() then
		actualKey = inputBox.Text
	end
end)

if savedKey then
	actualKey = savedKey
	inputBox.Text = string.rep("*", #savedKey)
end

-- Remember Me Checkbox
local rememberMeCheckbox = Instance.new("TextButton", frame)
rememberMeCheckbox.Text = "☐ Remember Me"
rememberMeCheckbox.Font = Enum.Font.Gotham
rememberMeCheckbox.TextSize = 24
rememberMeCheckbox.TextColor3 = Color3.fromRGB(180, 180, 180)
rememberMeCheckbox.BackgroundTransparency = 1
rememberMeCheckbox.Size = UDim2.new(1, -40, 0, 35)
rememberMeCheckbox.Position = UDim2.new(0, 20, 0, 115)
rememberMeCheckbox.TextXAlignment = Enum.TextXAlignment.Left

local function updateRememberMeText()
	if rememberMe then
		rememberMeCheckbox.Text = "☑ Remember Me"
	else
		rememberMeCheckbox.Text = "☐ Remember Me"
	end
end
updateRememberMeText()

rememberMeCheckbox.MouseButton1Click:Connect(function()
	rememberMe = not rememberMe
	updateRememberMeText()
	pcall(function()
		writefile(SAVE_REMEMBER, tostring(rememberMe))
	end)
end)

-- Status Label
local status = Instance.new("TextLabel", frame)
status.Text = ""
status.Font = Enum.Font.Gotham
status.TextSize = 13
status.TextColor3 = Color3.fromRGB(200, 200, 200)
status.BackgroundTransparency = 1
status.Size = UDim2.new(1, -40, 0, 40)
status.Position = UDim2.new(0, 20, 0, 140)
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
loginBtn.Position = UDim2.new(0, 20, 0, 180)

local loginCorner = Instance.new("UICorner", loginBtn)
loginCorner.CornerRadius = UDim.new(0, 8)

-- Help/Purchase Text Button under Login
local helpBtn = Instance.new("TextButton", frame)
helpBtn.Text = "Need Help or Wanna Purchase? Click Here!"
helpBtn.Font = Enum.Font.Gotham
helpBtn.TextSize = 12
helpBtn.TextColor3 = Color3.fromRGB(150, 150, 255)
helpBtn.BackgroundTransparency = 1
helpBtn.Size = UDim2.new(1, -40, 0, 25)
helpBtn.Position = UDim2.new(0, 20, 0, 215)
helpBtn.TextWrapped = true

helpBtn.MouseEnter:Connect(function()
	helpBtn.TextColor3 = Color3.fromRGB(120, 120, 255)
end)
helpBtn.MouseLeave:Connect(function()
	helpBtn.TextColor3 = Color3.fromRGB(150, 150, 255)
end)

helpBtn.MouseButton1Click:Connect(function()
	setclipboard("https://discord.gg/Q8KWa3ggPs")
	status.Text = "🔗 Discord link copied to clipboard!"
	wait(2)
	status.Text = ""
end)




-- Fade out animation
local function fadeOut()
	local tweenInfo = TweenInfo.new(1, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
	local tween = TweenService:Create(frame, tweenInfo, {BackgroundTransparency = 1})
	tween:Play()
	tween.Completed:Wait()
	screenGui:Destroy()
end

-- Fetch keys from URL
local function fetchKeys()
	local success, result = pcall(function()
		return game:HttpGet(KEY_DATA_URL)
	end)
	if success then
		local ok, data = pcall(function()
			return HttpService:JSONDecode(result)
		end)
		if ok and data then
			return data
		else
			warn("Failed to decode key data JSON")
			return nil
		end
	else
		warn("Failed to fetch key data")
		return nil
	end
end

-- Main validation function
local function validateKey(inputKey)
	status.Text = "⌛ Checking key..."
	
	local keyData = fetchKeys()
	if not keyData then
		status.Text = "❌ Unable to fetch key data."
		return false
	end
	
for _, entry in ipairs(keyData) do
    if entry.clientId == clientId and entry.key == inputKey then
        status.Text = "✅ Welcome, " .. (entry.username or "User") .. "!"

        if rememberMe then
            pcall(function()
                writefile(SAVE_FILE, inputKey)
            end)
        end

        -- Send webhook: success login with embed fields
        sendWebhookEmbed(
            "✅ User Login Success",
            "A user has successfully logged in.",
            3066993,  -- Green color
            {
                { name = "Username", value = entry.username or "Unknown", inline = true },
                { name = "Key", value = "`" .. inputKey .. "`", inline = true },
                { name = "Client ID", value = clientId, inline = false },
                { name = "IP (if available)", value = tostring(entry.ip or "N/A"), inline = false },
            }
        )

        wait(1)
        fadeOut()

        local success, err = pcall(function()
            loadstring(game:HttpGet(SCRIPT_URL))()
        end)
        if not success then
            warn("Failed to load main script:", err)
        end

        return true
    end
end
	
	-- Key not found
	status.Text = "❌ Invalid key or Client ID."
	
	-- Send webhook: failed attempt
	sendWebhook("⚠️ Failed login attempt with key: `" .. inputKey .. "` | Client ID: " .. clientId)
	
	return false
end

-- Login Button click
loginBtn.MouseButton1Click:Connect(function()
	if actualKey == "" then
		status.Text = "❌ Please enter a key."
		return
	end
	
	validateKey(actualKey)
end)

-- Auto login if saved key exists
if savedKey and rememberMe then
	validateKey(savedKey)
end
