local uis = game:GetService("UserInputService")
local lp = game.Players.LocalPlayer
local gui = Instance.new("ScreenGui", lp:WaitForChild("PlayerGui"))
gui.Name = "ForsakenMenu"
gui.ResetOnSpawn = false
gui.IgnoreGuiInset = true

-- Основное окно
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

-- Box ESP
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
		for _, m in pairs(workspace.Players.Survivors:GetChildren()) do
			local hrp = m:FindFirstChild("HumanoidRootPart")
			if hrp and not hrp:FindFirstChild("ESP_Survivor") then
				createBoxESP(hrp, Color3.fromRGB(0,255,0), "Survivor")
			end
		end
		for _, m in pairs(workspace.Players.Killers:GetChildren()) do
			local hrp = m:FindFirstChild("HumanoidRootPart")
			if hrp and not hrp:FindFirstChild("ESP_Killer") then
				createBoxESP(hrp, Color3.fromRGB(255,0,0), "Killer")
			end
		end
		for _, o in ipairs(workspace:GetDescendants()) do
			if o:IsA("Model") and o.Name == "Generator" then
				local p = o:FindFirstChildWhichIsA("BasePart")
				if p and not p:FindFirstChild("ESP_Generator") then
					createBoxESP(p, Color3.fromRGB(0,170,255), "Generator")
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

-- TP к ближайшему генератору
local buttonTPGen = Instance.new("TextButton", frame)
buttonTPGen.Size = UDim2.new(1, -20, 0, 40)
buttonTPGen.Position = UDim2.new(0, 10, 0, 100)
buttonTPGen.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
buttonTPGen.BorderSizePixel = 0
buttonTPGen.TextColor3 = Color3.fromRGB(255, 255, 255)
buttonTPGen.Text = "TP к ближайшему генератору"
buttonTPGen.Font = Enum.Font.SourceSans
buttonTPGen.TextSize = 18

buttonTPGen.MouseButton1Click:Connect(function()
	local char = lp.Character or lp.CharacterAdded:Wait()
	local hrp = char:WaitForChild("HumanoidRootPart")
	local nearest, dist = nil, math.huge
	for _, gen in ipairs(workspace:GetDescendants()) do
		if gen:IsA("Model") and gen.Name == "Generator" then
			local p = gen:FindFirstChildWhichIsA("BasePart")
			if p then
				local d = (hrp.Position - p.Position).Magnitude
				if d < dist then
					dist = d
					nearest = p
				end
			end
		end
	end
	if nearest then hrp.CFrame = nearest.CFrame + Vector3.new(0,3,0) end
end)

-- TP спам к выжившим
local tpSpamming = false
local buttonTPSpam = Instance.new("TextButton", frame)
buttonTPSpam.Size = UDim2.new(1, -20, 0, 40)
buttonTPSpam.Position = UDim2.new(0, 10, 0, 150)
buttonTPSpam.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
buttonTPSpam.BorderSizePixel = 0
buttonTPSpam.TextColor3 = Color3.fromRGB(255,255,255)
buttonTPSpam.Text = "TP Spam: OFF"
buttonTPSpam.Font = Enum.Font.SourceSans
buttonTPSpam.TextSize = 20

buttonTPSpam.MouseButton1Click:Connect(function()
	tpSpamming = not tpSpamming
	buttonTPSpam.Text = tpSpamming and "TP Spam: ON" or "TP Spam: OFF"
end)

task.spawn(function()
	while task.wait(2) do
		if tpSpamming then
			local char = lp.Character
			local hrp = char and char:FindFirstChild("HumanoidRootPart")
			if hrp then
				for _, m in ipairs(workspace.Players.Survivors:GetChildren()) do
					local h = m:FindFirstChild("Humanoid")
					local t = m:FindFirstChild("HumanoidRootPart")
					if h and h.Health > 0 and m ~= char and t then
						hrp.CFrame = t.CFrame + Vector3.new(0,3,0)
						break
					end
				end
			end
		end
	end
end)

-- SpeedHack
local speedEnabled = false
local speed = 1

local speedSlider = Instance.new("TextButton", frame)
speedSlider.Size = UDim2.new(1, -20, 0, 40)
speedSlider.Position = UDim2.new(0, 10, 0, 200)
speedSlider.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
speedSlider.BorderSizePixel = 0
speedSlider.TextColor3 = Color3.fromRGB(255, 255, 255)
speedSlider.Text = "Скорость: 1"
speedSlider.Font = Enum.Font.SourceSans
speedSlider.TextSize = 20

speedSlider.MouseButton1Click:Connect(function()
	speed += 1
	if speed > 45 then speed = 1 end
	speedSlider.Text = "Скорость: " .. tostring(speed)
end)

local speedToggle = Instance.new("TextButton", frame)
speedToggle.Size = UDim2.new(1, -20, 0, 40)
speedToggle.Position = UDim2.new(0, 10, 0, 250)
speedToggle.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
speedToggle.BorderSizePixel = 0
speedToggle.TextColor3 = Color3.fromRGB(255, 255, 255)
speedToggle.Text = "SpeedHack: OFF"
speedToggle.Font = Enum.Font.SourceSans
speedToggle.TextSize = 20

speedToggle.MouseButton1Click:Connect(function()
	speedEnabled = not speedEnabled
	speedToggle.Text = speedEnabled and "SpeedHack: ON" or "SpeedHack: OFF"
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

-- Удаление детекторов
local removeButton = Instance.new("TextButton", frame)
removeButton.Size = UDim2.new(1, -20, 0, 40)
removeButton.Position = UDim2.new(0, 10, 0, 300)
removeButton.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
removeButton.BorderSizePixel = 0
removeButton.TextColor3 = Color3.fromRGB(255,255,255)
removeButton.Text = "Удалить детекторы"
removeButton.Font = Enum.Font.SourceSans
removeButton.TextSize = 20

removeButton.MouseButton1Click:Connect(function()
	local char = lp.Character or lp.CharacterAdded:Wait()
	for _, obj in ipairs(char:GetChildren()) do
		if obj.Name == "VisibilityDetector" or obj.Name == "NoclipDetector" then
			obj:Destroy()
		end
	end
end)

-- Рывок вперёд
local dashButton = Instance.new("TextButton", frame)
dashButton.Size = UDim2.new(1, -20, 0, 40)
dashButton.Position = UDim2.new(0, 10, 0, 350)
dashButton.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
dashButton.BorderSizePixel = 0
dashButton.TextColor3 = Color3.fromRGB(255,255,255)
dashButton.Text = "Рывок вперёд"
dashButton.Font = Enum.Font.SourceSans
dashButton.TextSize = 20

dashButton.MouseButton1Click:Connect(function()
	local hrp = lp.Character and lp.Character:FindFirstChild("HumanoidRootPart")
	if hrp then
		hrp.CFrame = hrp.CFrame + hrp.CFrame.LookVector * 25
	end
end)

-- Телепорт на 250 вверх
local tpUpButton = Instance.new("TextButton", frame)
tpUpButton.Size = UDim2.new(1, -20, 0, 40)
tpUpButton.Position = UDim2.new(0, 10, 0, 400)
tpUpButton.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
tpUpButton.BorderSizePixel = 0
tpUpButton.TextColor3 = Color3.fromRGB(255,255,255)
tpUpButton.Text = "TP вверх на 250"
tpUpButton.Font = Enum.Font.SourceSans
tpUpButton.TextSize = 20

tpUpButton.MouseButton1Click:Connect(function()
	local hrp = lp.Character and lp.Character:FindFirstChild("HumanoidRootPart")
	if hrp then
		task.spawn(function()
			hrp.Anchored = false
			task.wait(0.25)
			hrp.Anchored = true
			hrp.Position += Vector3.new(0, 250, 0)
					task.wait(0.25)
					hrp.Anchored = false
		end)
	end
end)

--Аи бот
local pathfinding = game:GetService("PathfindingService")
local runService = game:GetService("RunService")

local botEnabled = false
local buttonBot = Instance.new("TextButton", frame)
buttonBot.Size = UDim2.new(1, -20, 0, 40)
buttonBot.Position = UDim2.new(0, 10, 0, 445) -- ниже последней кнопки
buttonBot.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
buttonBot.BorderSizePixel = 0
buttonBot.TextColor3 = Color3.fromRGB(255, 255, 255)
buttonBot.Text = "AFK-Бот: OFF"
buttonBot.Font = Enum.Font.SourceSans
buttonBot.TextSize = 20

buttonBot.MouseButton1Click:Connect(function()
	botEnabled = not botEnabled
	buttonBot.Text = botEnabled and "AFK-Бот: ON" or "AFK-Бот: OFF"
end)

task.spawn(function()
	while true do
		task.wait(1)
		if not botEnabled then continue end

		local char = lp.Character
		local hrp = char and char:FindFirstChild("HumanoidRootPart")
		local hum = char and char:FindFirstChild("Humanoid")
		if not hrp or not hum or hum.Health <= 0 then continue end

		-- ищем выжившего
		local target = nil
		local dist = math.huge
		for _, m in ipairs(workspace.Players.Survivors:GetChildren()) do
			local h = m:FindFirstChild("Humanoid")
			local t = m:FindFirstChild("HumanoidRootPart")
			if h and h.Health > 0 and t and m ~= lp.Character then
				local d = (hrp.Position - t.Position).Magnitude
				if d < dist then
					dist = d
					target = t
				end
			end
		end

		if not target then continue end

		-- проверка на убийцу поблизости
		for _, killer in ipairs(workspace.Players.Killers:GetChildren()) do
			local khrp = killer:FindFirstChild("HumanoidRootPart")
			if khrp and (khrp.Position - hrp.Position).Magnitude < 15 then
				task.spawn(function()
					hrp.Anchored = false
					task.wait(0.1)
					hrp.Anchored = true
					hrp.Position += Vector3.new(0, 250, 0)
					task.wait(0.2)
					hrp.Anchored = false
				end)
				break
			end
		end

		-- если далеко — включить спидхак
		speedEnabled = dist > 100
		speed = 35

		-- двигаемся через Pathfinding
		local path = pathfinding:CreatePath()
		path:ComputeAsync(hrp.Position, target.Position)

		if path.Status == Enum.PathStatus.Success then
			for _, waypoint in ipairs(path:GetWaypoints()) do
				if not botEnabled then break end
				hum:MoveTo(waypoint.Position)
				hum.MoveToFinished:Wait()

				-- проверка цели
				if (hrp.Position - target.Position).Magnitude < 6 then
					break -- цель достигнута
				end
			end
		end
	end
end)

-- Кнопка Insert — показать/скрыть
uis.InputBegan:Connect(function(input, gp)
	if input.KeyCode == Enum.KeyCode.Insert and not gp then
		frame.Visible = not frame.Visible
	end
end)
