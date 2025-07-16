local uis = game:GetService("UserInputService")
local lp = game.Players.LocalPlayer
local gui = Instance.new("ScreenGui", lp:WaitForChild("PlayerGui"))
gui.Name = "ForsakenMenu"
gui.ResetOnSpawn = false
gui.IgnoreGuiInset = true

-- Главное окно
local frame = Instance.new("Frame", gui)
frame.Size = UDim2.new(0, 300, 0, 500)
frame.Position = UDim2.new(0, 20, 0.5, -250)
frame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
frame.BorderSizePixel = 0
frame.Name = "MainFrame"
frame.Active = true
frame.Draggable = true
frame.Visible = true

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

-- ESP
local espEnabled = false
addButton("ESP ON", function(btn)
	espEnabled = not espEnabled
	btn.Text = espEnabled and "ESP ON" or "ESP OFF"
	if espEnabled then
		for _, model in pairs(workspace.Players.Survivors:GetChildren()) do
			local hrp = model:FindFirstChild("HumanoidRootPart")
			if hrp then
				local adorn = Instance.new("BoxHandleAdornment")
				adorn.Adornee = hrp
				adorn.Size = hrp.Size + Vector3.new(0.2,0.2,0.2)
				adorn.Color3 = Color3.new(0,1,0)
				adorn.Transparency = 0.4
				adorn.AlwaysOnTop = true
				adorn.ZIndex = 10
				adorn.Name = "ESP_Survivor"
				adorn.Parent = hrp
			end
		end
		for _, model in pairs(workspace.Players.Killers:GetChildren()) do
			local hrp = model:FindFirstChild("HumanoidRootPart")
			if hrp then
				local adorn = Instance.new("BoxHandleAdornment")
				adorn.Adornee = hrp
				adorn.Size = hrp.Size + Vector3.new(0.2,0.2,0.2)
				adorn.Color3 = Color3.new(1,0,0)
				adorn.Transparency = 0.4
				adorn.AlwaysOnTop = true
				adorn.ZIndex = 10
				adorn.Name = "ESP_Killer"
				adorn.Parent = hrp
			end
		end
		for _, obj in ipairs(workspace:GetDescendants()) do
			if obj:IsA("Model") and obj.Name == "Generator" then
				local part = obj:FindFirstChildWhichIsA("BasePart")
				if part then
					local adorn = Instance.new("BoxHandleAdornment")
					adorn.Adornee = part
					adorn.Size = part.Size + Vector3.new(0.2,0.2,0.2)
					adorn.Color3 = Color3.new(0,0.6,1)
					adorn.Transparency = 0.4
					adorn.AlwaysOnTop = true
					adorn.ZIndex = 10
					adorn.Name = "ESP_Generator"
					adorn.Parent = part
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

-- TP к генератору
addButton("TP к генератору", function()
	local hrp = lp.Character and lp.Character:FindFirstChild("HumanoidRootPart")
	if not hrp then return end
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

-- Speed
local speed = 1
local speedEnabled = false
addButton("Скорость: 1", function(btn)
	speed += 1
	if speed > 45 then speed = 1 end
	btn.Text = "Скорость: " .. speed
end)

addButton("SpeedHack OFF", function(btn)
	speedEnabled = not speedEnabled
	btn.Text = speedEnabled and "SpeedHack ON" or "SpeedHack OFF"
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

-- TP вверх
addButton("Blink вверх (250)", function()
	local hrp = lp.Character and lp.Character:FindFirstChild("HumanoidRootPart")
	if hrp then
		hrp.Anchored = true
		task.wait(0.1)
		hrp.Position += Vector3.new(0, 250, 0)
		task.wait(0.1)
		hrp.Anchored = false
	end
end)

-- TP к следующему выжившему
local survivorIndex = 1
addButton("След. выживший", function()
	local hrp = lp.Character and lp.Character:FindFirstChild("HumanoidRootPart")
	local survivors = workspace:FindFirstChild("Players") and workspace.Players:FindFirstChild("Survivors")
	if not (hrp and survivors) then return end
	local list = survivors:GetChildren()
	if #list == 0 then return end
	survivorIndex = survivorIndex > #list and 1 or survivorIndex
	local target = list[survivorIndex]
	survivorIndex += 1
	local targetHRP = target and target:FindFirstChild("HumanoidRootPart")
	if targetHRP then
		hrp.CFrame = targetHRP.CFrame + Vector3.new(0, 5, 0)
	end
end)

-- Flash вперед
addButton("Flash вперед", function()
	local hrp = lp.Character and lp.Character:FindFirstChild("HumanoidRootPart")
	if hrp then
		hrp.CFrame = hrp.CFrame + hrp.CFrame.LookVector * 10
	end
end)

-- Удалить античит-детекторы
addButton("Удалить детекторы", function()
	local char = lp.Character
	if not char then return end
	for _, v in ipairs(char:GetChildren()) do
		if v.Name:lower():find("detector") then
			v:Destroy()
		end
	end
end)

-- Insert — скрыть / показать
uis.InputBegan:Connect(function(input, gp)
	if input.KeyCode == Enum.KeyCode.Insert and not gp then
		frame.Visible = not frame.Visible
	end
end)
