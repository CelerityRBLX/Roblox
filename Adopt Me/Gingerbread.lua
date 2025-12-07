local ChristmasMap = workspace.Interiors["MainMap!Christmas"]
local CollectionService = game:GetService("CollectionService")
local LP = game:GetService("Players").LocalPlayer
local PP = LP.Character.PrimaryPart
local Ipairs = ipairs

local CollectSP = Vector3.new(-286, 33, -1625)

local function GetClosestGingerbread()
	local MD = math.huge
	local Target
	for i, v in Ipairs(CollectionService:GetTagged("Gingerbread")) do
		local Distance = (PP.Position - v.Position).Magnitude
		local Safe = (v.Position - CollectSP).Magnitude > 20
		if v.Transparency == 0 and Distance < MD and Safe then
			MD = Distance
			Target = v
		end
	end
	return Target
end

local function GoToByVelocity(Part, Pos)
	repeat
		Part.CanCollide = false
		Part.AssemblyLinearVelocity = (Pos-Part.Position).Unit*500
		task.wait()
	until (Part.Position-Pos).Magnitude < 5
	Part.CanCollide = true
end

for i, v in Ipairs(ChristmasMap:GetDescendants()) do
	if v:IsA("BasePart") and v.Name == "GingerbreadMan" then
		CollectionService:AddTag(v, "Gingerbread")
		print("New Gingerbread: "..v.Name)
	end
end

local DescendantAdded = ChristmasMap.DescendantAdded

DescendantAdded:Connect(function(v)
	if v:IsA("BasePart") and v.Name == "GingerbreadMan" then
		CollectionService:AddTag(v, "Gingerbread")
		print("New Gingerbread: "..v.Name)
	end
end)

while task.wait(0.11) do
	local Target = GetClosestGingerbread()
	if Target then
		GoToByVelocity(PP, Target.Position)
		print("Collected Gingerbread")
	else
		break
	end
end