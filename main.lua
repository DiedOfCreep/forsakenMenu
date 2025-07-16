local uis = game:GetService("UserInputService")
local lp = game.Players.LocalPlayer
local char = lp.Character or lp.CharacterAdded:Wait()
local gui = Instance.new("ScreenGui", lp:WaitForChild("PlayerGui"))
gui.Name = "ForsakenMenu"
gui.ResetOnSpawn = false
gui.IgnoreGuiInset = true

-- Окно
local frame = Instance.new("Frame", gui)
frame.Size = UDim2.new(0, 300, 0, 440)
frame.Position = UDim2.new(0, 20, 0.5, -220)
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

local y = 50
local function addButton(name, callback)
    local b = Instance.new("TextButton", frame)
    b.Size = UDim2.new(1, -20, 0, 40)
    b.Position = UDim2.new(0, 10, 0, y)
    b.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
    b.BorderSizePixel = 0
    b.TextColor3 = Color3.fromRGB(255, 255, 255)
    b.Text = name
    b.Font = Enum.Font.SourceSans
    b.TextSize = 20
    b.MouseButton1Click:Connect(callback)
    y += 50
    return b
end

-- ESP
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

local espEnabled = false
addButton("ESP", function()
	espEnabled = not espEnabled
	if espEnabled then
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
		for _, v in ipairs(workspace:GetDescendants()) do
			if v:IsA("BoxHandleAdornment") and v.Name:match("^ESP_") then
				v:Destroy()
			end
		end
	end
end)

-- TP к ближайшему генератору
addButton("TP к ближайшему генератору", function()
	local char = lp.Character or lp.CharacterAdded:Wait()
	local hrp = char:WaitForChild("HumanoidRootPart")
	local nearest, minDist = nil, math.huge
	for _, obj in ipairs(workspace:GetDescendants()) do
		if obj:IsA("Model") and obj.Name == "Generator" then
			local part = obj:FindFirstChildWhichIsA("BasePart")
			if part then
				local dist = (hrp.Position - part.Position).Magnitude
				if dist < minDist then
					minDist = dist
					nearest = part
				end
			end
		end
	end
	if nearest then
		hrp.CFrame = nearest.CFrame + Vector3.new(0, 3, 0)
	end
end)

-- TP спам к выжившим
local spam = false
addButton("TP SPAM ON/OFF", function()
	spam = not spam
end)

task.spawn(function()
	while task.wait(2) do
		if spam then
			local hrp = lp.Character and lp.Character:FindFirstChild("HumanoidRootPart")
			if not hrp then continue end
			local survivors = workspace.Players:WaitForChild("Survivors")
			for _, model in survivors:GetChildren() do
				local humanoid = model:FindFirstChild("Humanoid")
				local targetHRP = model:FindFirstChild("HumanoidRootPart")
				if humanoid and targetHRP and humanoid.Health > 0 and model ~= lp.Character then
					hrp.CFrame = targetHRP.CFrame + Vector3.new(0, 3, 0)
					break
				end
			end
		end
	end
end)

-- Удаление детекторов
addButton("Удалить античит-детекторы", function()
	local char = lp.Character or lp.CharacterAdded:Wait()
	for _, obj in ipairs(char:GetDescendants()) do
		if obj:IsA("BasePart") and (obj.Name == "VisibilityDetector" or obj.Name == "NoclipDetector") then
			obj:Destroy()
		end
	end
end)

-- Рывок (на G)
local lastDash = 0
uis.InputBegan:Connect(function(input, gp)
	if input.KeyCode == Enum.KeyCode.G and not gp then
		local now = tick()
		if now - lastDash >= 2 then
			local hrp = lp.Character and lp.Character:FindFirstChild("HumanoidRootPart")
			if hrp then
				hrp.CFrame = hrp.CFrame + hrp.CFrame.LookVector * 25
				lastDash = now
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
