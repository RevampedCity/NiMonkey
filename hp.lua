local Players = game:GetService("Players")
local player = Players.LocalPlayer

-- Create ScreenGui
local screenGui = Instance.new("ScreenGui", player:WaitForChild("PlayerGui"))
screenGui.Name = "TB3KModeSelector"
screenGui.IgnoreGuiInset = true
screenGui.ResetOnSpawn = false

-- Create main frame
local frame = Instance.new("Frame", screenGui)
frame.Size = UDim2.new(0, 240, 0, 150)
frame.Position = UDim2.new(0.5, 0, 0.5, 0)
frame.AnchorPoint = Vector2.new(0.5, 0.5)
frame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
frame.BackgroundTransparency = 0.1
frame.BorderSizePixel = 0

local corner = Instance.new("UICorner", frame)
corner.CornerRadius = UDim.new(0, 12)

-- Title
local title = Instance.new("TextLabel", frame)
title.Text = "#TB3K | Home Page"
title.Font = Enum.Font.GothamBold
title.TextSize = 16
title.TextColor3 = Color3.fromRGB(200, 200, 200)
title.BackgroundTransparency = 1
title.Size = UDim2.new(1, -20, 0, 30)
title.Position = UDim2.new(0, 10, 0, 10)
title.TextXAlignment = Enum.TextXAlignment.Left

-- Paid Button
local paidBtn = Instance.new("TextButton", frame)
paidBtn.Text = "Paid"
paidBtn.Font = Enum.Font.GothamBold
paidBtn.TextSize = 14
paidBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
paidBtn.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
paidBtn.Size = UDim2.new(1, -40, 0, 30)
paidBtn.Position = UDim2.new(0, 20, 0, 60)

local paidCorner = Instance.new("UICorner", paidBtn)
paidCorner.CornerRadius = UDim.new(0, 8)

-- Free Button
local freeBtn = Instance.new("TextButton", frame)
freeBtn.Text = "Free"
freeBtn.Font = Enum.Font.GothamBold
freeBtn.TextSize = 14
freeBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
freeBtn.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
freeBtn.Size = UDim2.new(1, -40, 0, 30)
freeBtn.Position = UDim2.new(0, 20, 0, 100)

local freeCorner = Instance.new("UICorner", freeBtn)
freeCorner.CornerRadius = UDim.new(0, 8)

-- Close GUI and load script
local function closeAndRun(scriptUrl)
	local success, err = pcall(function()
		loadstring(game:HttpGet(scriptUrl))()
	end)
	if not success then
		warn("Failed to load script:", err)
	end
	screenGui:Destroy()
end

paidBtn.MouseButton1Click:Connect(function()
	closeAndRun("https://raw.githubusercontent.com/RevampedCity/NiMonkey/refs/heads/main/ks.lua")
end)

freeBtn.MouseButton1Click:Connect(function()
	closeAndRun("https://raw.githubusercontent.com/RevampedCity/NiMonkey/refs/heads/main/fks.lua")
end)
