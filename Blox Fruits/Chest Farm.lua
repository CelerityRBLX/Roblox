local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local TweenService = game:GetService("TweenService")
local RunService = game:GetService("RunService")
local CollectionService = game:GetService("CollectionService")
local MaxVelocity = 370
local Hearbeat = RunService.Heartbeat
local Match = string.match
local DescendantAdded = workspace.DescendantAdded
local Ipairs = ipairs
local Tick = tick
local Wait = task.wait
MaxVelocity -= 5
local XY = Vector3.new(1, 0.2, 1)

local function Character()
	while Wait(1) do
		local x, y = pcall(function()
			local Character = Players.LocalPlayer.Character
			CollectionService:AddTag(Character, "Character")
			local Root = Character:WaitForChild("HumanoidRootPart", 10)
			CollectionService:AddTag(Root, "Root")
		end)
		print(tostring(x).." "..tostring(y))
	end
end

local function SafeTeleport(CF)
	local Root = CollectionService:GetTagged("Root")[1]
	local Distance = ((Root.Position-CF.Position)*XY).Magnitude
	local Time = (Distance/MaxVelocity)+0.5
	local Tween = TweenService:Create(Root, TweenInfo.new(Time, Enum.EasingStyle.Linear, Enum.EasingDirection.InOut), {CFrame = CF})
	Tween:Play()
	local Start = tick()
	repeat
		Root.AssemblyLinearVelocity = Vector3.yAxis
		Hearbeat:Wait()
	until Tick()-Start > Time+0.1
end

workspace.Map["WaterBase-Plane"].Size = Vector3.new(1000, 112, 1000)

local Bounds = 1024*10

local function Added(Descendant)
	if Descendant.Parent == workspace or Descendant:IsDescendantOf(workspace.Map) then
		if Descendant:IsA("TouchTransmitter") and Match(Descendant.Parent.Name, "Chest") then
			CollectionService:AddTag(Descendant, "Chest TouchTransmitter")
			print("(Later) New Chest: "..Descendant.Parent.Name)
		elseif Descendant:IsA("Tool") and Match(Descendant.Name, "Fruit") then
			CollectionService:AddTag(Descendant, "Fruit")
			print("(Later) New Fruit: "..Descendant.Name)
		end
	end
end

local function AutoTag()
	for i, v in Ipairs(workspace.Map:GetDescendants()) do
		local TouchTransmitter = v:FindFirstChildWhichIsA("TouchTransmitter")
    	if Match(v.Name, "Chest") and TouchTransmitter then
			if v.Position.Magnitude < Bounds then
				CollectionService:AddTag(TouchTransmitter, "Chest TouchTransmitter")
				print("(Early) New Chest: "..v.Name)
				Hearbeat:Wait()
			end
		end
	end
	for i, v in Ipairs(workspace:GetChildren()) do
		if v:IsA("Tool") and Match(v.Name, "Fruit") then
			CollectionService:AddTag(v, "Fruit")
			print("(Later) New Fruit: "..v.Name)
    	end
	end
	DescendantAdded:Connect(Added)
end

local function FarmChests()
	repeat
		Wait()
	until CollectionService:GetTagged("Root")[1]
	local Root = CollectionService:GetTagged("Root")[1]
	local MinimumDistance = math.huge
	local Chosen
	for i, v in Ipairs(CollectionService:GetTagged("Chest TouchTransmitter")) do
		local Chest = v.Parent
		local Distance = ((Chest.Position-Root.Position)*XY).Magnitude
		if Distance < MinimumDistance then
			MinimumDistance = Distance
			Chosen = Chest
		end
	end
	if Chosen then
		SafeTeleport(Chosen.CFrame)
	end
end

local function FarmFruits()
	repeat
		Wait()
	until CollectionService:GetTagged("Root")[1]
	local Root = CollectionService:GetTagged("Root")[1]
	local MinimumDistance = math.huge
	local Chosen
	for i, v in Ipairs(CollectionService:GetTagged("Fruit")) do
		local Handle = v:FindFirstChildWhichIsA("BasePart")
		local Distance = ((Handle.Position-Root.Position)*XY).Magnitude
		local Owned = (v.Parent == LocalPlayer.Backpack or v.Parent == LocalPlayer.Character)
		if Distance < MinimumDistance and Owned == false then
			MinimumDistance = Distance
			Chosen = Handle
		end
	end
	if Chosen then
		print("Teleporting To Fruit: "..Chosen.Name)
		SafeTeleport(Chosen.CFrame)
		print("Teleported To Fruit: "..Chosen.Name)
	end
end

AutoTag()

task.spawn(Character)

while true do
	FarmFruits()
	FarmChests()
	Hearbeat:Wait()
end
