local uis = game:GetService("UserInputService")
local lp = game.Players.LocalPlayer
local gui = Instance.new("ScreenGui", lp:WaitForChild("PlayerGui"))
gui.Name = "ForsakenMenu"
gui.ResetOnSpawn = false
gui.IgnoreGuiInset = true

-- Главное окно
local frame = Instance.new("Frame", gui)
frame.Size = UDim2.new(0, 300, 0, 700)
frame.Position = UDim2.new(0, 20, 0.5, -350)
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
local function addButton(text, callback)
	local btn = Instance.new("TextButton", frame)
	btn.Size = UDim2.new(1, -20, 0, 40)
	btn.Position = UDim2.new(0, 10, 0, y)
	btn.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
	btn.BorderSizePixel = 0
	btn.TextColor3 = Color3.fromRGB(255, 255, 255)
	btn.Text = text
	btn.Font = Enum.Font.SourceSans
	btn.TextSize = 20
	btn.MouseButton1Click:Connect(function()
		callback(btn)
	end)
	y += 50
end

-- TP к ближайшему генератору
addButton("TP к ближайшему генератору", function()
	local hrp = lp.Character and lp.Character:FindFirstChild("HumanoidRootPart")
	if not hrp then return end
	local closestGen, shortestDist = nil, math.huge
	for _, obj in ipairs(workspace:GetDescendants()) do
		if obj:IsA("Model") and obj.Name == "Generator" then
			local part = obj:FindFirstChildWhichIsA("BasePart")
			if part then
				local dist = (part.Position - hrp.Position).Magnitude
				if dist < shortestDist then
					shortestDist = dist
					closestGen = part
				end
			end
		end
	end
	if closestGen then
		hrp.CFrame = closestGen.CFrame + Vector3.new(0, 3, 0)
	end
end)

-- TP вверх на 250
addButton("TP вверх на 250", function()
	local hrp = lp.Character and lp.Character:FindFirstChild("HumanoidRootPart")
	if hrp then
		hrp.Anchored = false
		task.wait(1)
		hrp.Anchored = true
		hrp.Position += Vector3.new(0, 250, 0)
	end
end)

-- TP спам ко всем выжившим
local tpSpam = false
addButton("TP спам ко всем", function(btn)
	tpSpam = not tpSpam
	btn.Text = tpSpam and "TP спам: ON" or "TP спам: OFF"
	task.spawn(function()
		while tpSpam do
			local char = lp.Character
			local hrp = char and char:FindFirstChild("HumanoidRootPart")
			local survivors = workspace:FindFirstChild("Players") and workspace.Players:FindFirstChild("Survivors")
			if hrp and survivors then
				for _, model in ipairs(survivors:GetChildren()) do
					local target = model:FindFirstChild("HumanoidRootPart")
					if target then
						hrp.CFrame = target.CFrame + Vector3.new(0, 3, 0)
						task.wait(1)
					end
				end
			end
			task.wait(1)
		end
	end)
end)

-- SpeedHack
local speedEnabled = false
local speed = 1
addButton("SpeedHack: OFF", function(btn)
	speedEnabled = not speedEnabled
	btn.Text = speedEnabled and "SpeedHack: ON" or "SpeedHack: OFF"
end)

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

addButton("Увеличить скорость", function(btn)
	speed += 1
	if speed > 45 then speed = 1 end
	btn.Text = "Скорость: " .. speed
end)

-- TP к выбранному игроку
addButton("TP к игроку", function()
	local win = Instance.new("Frame", gui)
	win.Size = UDim2.new(0, 300, 0, 400)
	win.Position = UDim2.new(0, 340, 0.5, -200)
	win.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
	win.BorderSizePixel = 0
	win.Name = "PlayerSelect"
	win.Active = true
	win.Draggable = true

	local t = Instance.new("TextLabel", win)
	t.Size = UDim2.new(1, 0, 0, 40)
	t.Text = "Выбери игрока"
	t.TextColor3 = Color3.fromRGB(255, 255, 255)
	t.TextScaled = true
	t.Font = Enum.Font.SourceSansBold
	t.BackgroundTransparency = 1

	local py = 50
	for _, plr in ipairs(game.Players:GetPlayers()) do
		if plr ~= lp then
			local b = Instance.new("TextButton", win)
			b.Size = UDim2.new(1, -20, 0, 40)
			b.Position = UDim2.new(0, 10, 0, py)
			b.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
			b.BorderSizePixel = 0
			b.TextColor3 = Color3.fromRGB(255, 255, 255)
			b.Text = plr.Name
			b.Font = Enum.Font.SourceSans
			b.TextSize = 20
			b.MouseButton1Click:Connect(function()
				local myHRP = lp.Character and lp.Character:FindFirstChild("HumanoidRootPart")
				local theirHRP = plr.Character and plr.Character:FindFirstChild("HumanoidRootPart")
				if myHRP and theirHRP then
					myHRP.CFrame = theirHRP.CFrame + Vector3.new(0, 3, 0)
				end
			end)
			py += 45
		end
	end
end)

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
addButton("ESP ON/OFF", function(btn)
	espEnabled = not espEnabled
	if espEnabled then
		btn.Text = "ESP ON"
		local survivors = workspace.Players:FindFirstChild("Survivors")
		for _, model in pairs(survivors:GetChildren()) do
			local hrp = model:FindFirstChild("HumanoidRootPart")
			if hrp and not hrp:FindFirstChild("ESP_Survivor") then
				createBoxESP(hrp, Color3.fromRGB(0, 255, 0), "Survivor")
			end
		end
		local killers = workspace.Players:FindFirstChild("Killers")
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
		btn.Text = "ESP OFF"
		for _, v in ipairs(workspace:GetDescendants()) do
			if v:IsA("BoxHandleAdornment") and v.Name:match("^ESP_") then
				v:Destroy()
			end
		end
	end
end)

-- Удаление античит-детекторов
addButton("Удалить детекторы", function()
	local char = lp.Character
	if char then
		for _, v in ipairs(char:GetDescendants()) do
			if v:IsA("BasePart") and (v.Name == "VisibilityDetector" or v.Name == "NoclipDetector") then
				v:Destroy()
			end
		end
	end
end)

-- Dash (рывок) по G
local dashCooldown = false
uis.InputBegan:Connect(function(input, gp)
	if input.KeyCode == Enum.KeyCode.G and not gp and not dashCooldown then
		local hrp = lp.Character and lp.Character:FindFirstChild("HumanoidRootPart")
		if hrp then
			dashCooldown = true
			hrp.CFrame = hrp.CFrame + hrp.CFrame.LookVector * 25
			task.wait(2)
			dashCooldown
			end
		end
	end)

uis.InputBegan:Connect(function(input,gp)
if input.KeyCode == Enum.KeyCode.Insert and not gp then
			frame.Visible = not frame.Visible
	end
	end)
