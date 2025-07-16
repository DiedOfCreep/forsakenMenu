local uis = game:GetService("UserInputService")
local lp = game.Players.LocalPlayer
local gui = Instance.new("ScreenGui", lp:WaitForChild("PlayerGui"))
gui.Name = "ForsakenMenu"
gui.ResetOnSpawn = false
gui.IgnoreGuiInset = true

-- === Окно ===
local frame = Instance.new("Frame", gui)
frame.Size = UDim2.new(0, 250, 0, 320)
frame.Position = UDim2.new(0, 20, 0.5, -160)
frame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
frame.BorderSizePixel = 0
frame.Name = "MainFrame"
frame.Active = true
frame.Draggable = true

-- === Заголовок ===
local title = Instance.new("TextLabel", frame)
title.Size = UDim2.new(1, 0, 0, 40)
title.BackgroundTransparency = 1
title.Text = "Forsaken Cheat Menu"
title.TextColor3 = Color3.fromRGB(255, 255, 255)
title.TextScaled = true
title.Font = Enum.Font.SourceSansBold

-- === Кнопка: ВХ ===
local button = Instance.new("TextButton", frame)
button.Size = UDim2.new(1, -20, 0, 40)
button.Position = UDim2.new(0, 10, 0, 60)
button.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
button.BorderSizePixel = 0
button.TextColor3 = Color3.fromRGB(255, 255, 255)
button.Text = "ESP ON"
button.Font = Enum.Font.SourceSans
button.TextSize = 20

local espEnabled = false

-- === ESP функция ===
local function createBoxESP(part, color, name)
	local adorn = Instance.new("BoxHandleAdornment")
	adorn.Adornee = part
	adorn.AlwaysOnTop = true
	adorn.ZIndex = 10
	adorn.Size = part.Size + Vector3.new(0.2, 0.2, 0.2)
	adorn.Color3 = color
	adorn.Transparency = 0.4
	adorn.Name = "ESP_" .. name
	adorn.Parent = part
end

local function enableESP()
	local survivors = workspace:WaitForChild("Players"):WaitForChild("Survivors")
	for _, model in pairs(survivors:GetChildren()) do
		local hrp = model:FindFirstChild("HumanoidRootPart")
		if hrp and not hrp:FindFirstChild("ESP_Survivor") then
			createBoxESP(hrp, Color3.fromRGB(0, 255, 0), "Survivor")
		end
	end

	local killers = workspace:WaitForChild("Players"):WaitForChild("Killers")
	for _, model in pairs(killers:GetChildren()) do
		local hrp = model:FindFirstChild("HumanoidRootPart")
		if hrp and not hrp:FindFirstChild("ESP_Killer") then
			createBoxESP(hrp, Color3.fromRGB(255, 0, 0), "Killer")
		end
	end

	local genFolder = workspace:FindFirstChild("Map") and workspace.Map:FindFirstChild("InGame") and workspace.Map.InGame:FindFirstChild("Map")
	if genFolder then
		for _, obj in pairs(genFolder:GetChildren()) do
			if obj.Name == "Generator" and obj:IsA("Model") then
				local mainPart = obj:FindFirstChildWhichIsA("BasePart")
				if mainPart and not mainPart:FindFirstChild("ESP_Generator") then
					createBoxESP(mainPart, Color3.fromRGB(0, 170, 255), "Generator")
				end
			end
		end
	end
end

button.MouseButton1Click:Connect(function()
	espEnabled = not espEnabled
	if espEnabled then
		button.Text = "ESP ON"
		enableESP()
	else
		button.Text = "ESP OFF"
		for _, v in ipairs(workspace:GetDescendants()) do
			if v:IsA("BoxHandleAdornment") and v.Name:match("^ESP_") then
				v:Destroy()
			end
		end
	end
end)

-- === Toggle меню на Insert ===
uis.InputBegan:Connect(function(input, gp)
	if input.KeyCode == Enum.KeyCode.Insert and not gp then
		frame.Visible = not frame.Visible
	end
end)
