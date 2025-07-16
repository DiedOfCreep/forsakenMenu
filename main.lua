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

-- === createBoxESP ===
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

-- === ESP ===
local espEnabled = false
local function toggleESP()
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

	for _, obj in ipairs(workspace:GetDescendants()) do
		if obj:IsA("Model") and obj.Name == "Generator" then
			local mainPart = obj:FindFirstChildWhichIsA("BasePart")
			if mainPart and not mainPart:FindFirstChild("ESP_Generator") then
				createBoxESP(mainPart, Color3.fromRGB(0, 170, 255), "Generator")
			end
		end
	end
end

-- === Кнопка ESP ===
local buttonESP = Instance.new("TextButton", frame)
buttonESP.Size = UDim2.new(1, -20, 0, 40)
buttonESP.Position = UDim2.new(0, 10, 0, 60)
buttonESP.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
buttonESP.BorderSizePixel = 0
buttonESP.TextColor3 = Color3.fromRGB(255, 255, 255)
buttonESP.Text = "ESP ON"
buttonESP.Font = Enum.Font.SourceSans
buttonESP.TextSize = 20

buttonESP.MouseButton1Click:Connect(function()
	espEnabled = not espEnabled
	if espEnabled then
		buttonESP.Text = "ESP ON"
		toggleESP()
	else
		buttonESP.Text = "ESP OFF"
		for _, v in ipairs(workspace:GetDescendants()) do
			if v:IsA("BoxHandleAdornment") and v.Name:match("^ESP_") then
				v:Destroy()
			end
		end
	end
end)

-- === Кнопка TP к генератору ===
local buttonTP = Instance.new("TextButton", frame)
buttonTP.Size = UDim2.new(1, -20, 0, 40)
buttonTP.Position = UDim2.new(0, 10, 0, 110)
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

-- === Insert toggle GUI ===
uis.InputBegan:Connect(function(input, gp)
	if input.KeyCode == Enum.KeyCode.Insert and not gp then
		frame.Visible = not frame.Visible
	end
end)
