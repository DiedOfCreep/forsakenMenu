local uis = game:GetService("UserInputService")
local lp = game.Players.LocalPlayer
local gui = Instance.new("ScreenGui", lp:WaitForChild("PlayerGui"))
gui.Name = "ForsakenMenu"
gui.ResetOnSpawn = false
gui.IgnoreGuiInset = true

-- Окно
local frame = Instance.new("Frame", gui)
frame.Size = UDim2.new(0, 300, 0, 360)
frame.Position = UDim2.new(0, 20, 0.5, -180)
frame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
frame.BorderSizePixel = 0
frame.Name = "MainFrame"
frame.Active = true
frame.Draggable = true

local title = Instance.new("TextLabel", frame)
title.Size = UDim2.new(1, 0, 0, 40)
title.BackgroundTransparency = 1
title.Text = "Forsaken Cheat Menu"
title.TextColor3 = Color3.fromRGB(255, 255, 255)
title.TextScaled = true
title.Font = Enum.Font.SourceSansBold

-- Box ESP функция
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

-- ESP кнопка
local buttonESP = Instance.new("TextButton", frame)
buttonESP.Size = UDim2.new(1, -20, 0, 40)
buttonESP.Position = UDim2.new(0, 10, 0, 50)
buttonESP.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
buttonESP.BorderSizePixel = 0
buttonESP.TextColor3 = Color3.fromRGB(255, 255, 255)
buttonESP.Text = "ESP ON"
buttonESP.Font = Enum.Font.SourceSans
buttonESP.TextSize = 20

local espEnabled = false
buttonESP.MouseButton1Click:Connect(function()
	espEnabled = not espEnabled
	if espEnabled then
		buttonESP.Text = "ESP ON"
		local survivors = workspace.Players:WaitForChild("Survivors")
		for _, model in pairs(survivors:GetChildren()) do
			local hrp = model:FindFirstChild("HumanoidRootPart")
			if hrp and not hrp:FindFirstChild("ESP_Survivor") then
				createBoxESP(hrp, Color3.fromRGB(0, 255, 0), "Survivor")
			end
		end
		local killers = workspace.Players:WaitForChild("Killers")
		for _, model in pairs(killers:GetChildren()) do
			local hrp = model:FindFirstChild("HumanoidRootPart")
			if hrp and not hrp:FindFirstChild("ESP_Killer") then
				createBoxESP(hrp, Color3.fromRGB(255, 0, 0), "Killer")
			end
		end
		for _, obj in ipairs(workspace:GetDescendants()) do
			if obj:IsA("Model") and obj.Name == "Generator" then
				local mainPart = obj:FindFirstChildWhichIsA("BasePart")
				if mainPart and not mainPart:FindFirstChild("ESP_Generator") then
					createBoxESP(mainPart, Color3.fromRGB(0, 170, 255), "Generator")
				end
			end
		end
	else
		buttonESP.Text = "ESP OFF"
		for _, v in ipairs(workspace:GetDescendants()) do
			if v:IsA("BoxHandleAdornment") and v.Name:match("^ESP_") then
				v:Destroy()
			end
		end
	end
end)

-- Кнопка ТП к генератору
local buttonTP = Instance.new("TextButton", frame)
buttonTP.Size = UDim2.new(1, -20, 0, 40)
buttonTP.Position = UDim2.new(0, 10, 0, 100)
buttonTP.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
buttonTP.BorderSizePixel = 0
buttonTP.TextColor3 = Color3.fromRGB(255, 255, 255)
buttonTP.Text = "TP к генератору"
buttonTP.Font = Enum.Font.SourceSans
buttonTP.TextSize = 20

buttonTP.MouseButton1Click:Connect(function()
	local char = lp.Character or lp.CharacterAdded:Wait()
	local hrp = char:WaitForChild("HumanoidRootPart")
	for _, obj in ipairs(workspace:GetDescendants()) do
		if obj:IsA("Model") and obj.Name == "Generator" then
			local part = obj:FindFirstChildWhichIsA("BasePart")
			if part then
				hrp.CFrame = part.CFrame + Vector3.new(0, 3, 0)
				break
			end
		end
	end
end)

-- Спидхак логика
local speedEnabled = false
local speed = 1

local slider = Instance.new("TextButton", frame)
slider.Size = UDim2.new(1, -20, 0, 40)
slider.Position = UDim2.new(0, 10, 0, 150)
slider.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
slider.BorderSizePixel = 0
slider.TextColor3 = Color3.fromRGB(255, 255, 255)
slider.Text = "Скорость: 1"
slider.Font = Enum.Font.SourceSans
slider.TextSize = 20

slider.MouseButton1Click:Connect(function()
	speed += 5
	if speed > 40 then speed = 1 end
	slider.Text = "Скорость: " .. tostring(speed)
end)

local buttonSpeed = Instance.new("TextButton", frame)
buttonSpeed.Size = UDim2.new(1, -20, 0, 40)
buttonSpeed.Position = UDim2.new(0, 10, 0, 200)
buttonSpeed.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
buttonSpeed.BorderSizePixel = 0
buttonSpeed.TextColor3 = Color3.fromRGB(255, 255, 255)
buttonSpeed.Text = "SpeedHack: OFF"
buttonSpeed.Font = Enum.Font.SourceSans
buttonSpeed.TextSize = 20

buttonSpeed.MouseButton1Click:Connect(function()
	speedEnabled = not speedEnabled
	buttonSpeed.Text = speedEnabled and "SpeedHack: ON" or "SpeedHack: OFF"
end)

-- Реализация спидхака
task.spawn(function()
	while task.wait(0.05) do
		if speedEnabled then
			local hrp = lp.Character and lp.Character:FindFirstChild("HumanoidRootPart")
			if hrp then
				hrp.Velocity = hrp.CFrame.LookVector * speed
			end
		end
	end
end)

-- Insert — показать/скрыть
uis.InputBegan:Connect(function(input, gp)
	if input.KeyCode == Enum.KeyCode.Insert and not gp then
		frame.Visible = not frame.Visible
	end
end)
