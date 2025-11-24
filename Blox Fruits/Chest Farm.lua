local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local Character = Players.LocalPlayer.Character
local Root = Character.PrimaryPart
local OldCFrame = Character:GetPivot()
local MaxVelocity = 370
local Wait = task.wait
MaxVelocity -= 5
local XY = Vector3.new(1, 0, 1)

local function SafeTeleport(CF)
	local Distance = ((Root.Position-CF.Position)*XY).Magnitude
	local Time = Distance/MaxVelocity
	local Tween = TweenService:Create(Root, TweenInfo.new(Time, Enum.EasingStyle.Linear, Enum.EasingDirection.InOut), {CFrame = CF})
	Tween:Play()
	local Start = tick()
	repeat
		Root.AssemblyLinearVelocity = Vector3.zero
		Wait(0.06)
	until tick()-Start > Time+0.2
end

workspace.Map["WaterBase-Plane"].Size = Vector3.new(1000, 112, 1000)

local FarmFrames = {}

local function NewFarmFrames()
	local NewFarmFrames = {}
	for i, v in ipairs(workspace:GetDescendants()) do
		if v.Parent then
    		if v:IsA("TouchTransmitter") and string.match(v.Parent.Name, "Chest") then
				table.insert(NewFarmFrames, v.Parent.CFrame)
    		end
		end
	end
	FarmFrames = NewFarmFrames
end

local function Farm()
	local MinimumDistance = math.huge
	local PickedFrame
	local Index
	for i, v in ipairs(FarmFrames) do
		local Distance = (v.Position-Root.Position).Magnitude
		if Distance < MinimumDistance then
			MinimumDistance = Distance
			PickedFrame = v
			Index = i
		end
	end
	if PickedFrame then
		table.remove(FarmFrames, Index)
		SafeTeleport(PickedFrame)
	end
end

NewFarmFrames()

repeat
	Farm()
	Wait(0.06)
until #FarmFrames == 0

SafeTeleport(OldCFrame)
