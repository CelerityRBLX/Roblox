local Nebula = {}
local Workspace = game:GetService("Workspace")
local Players = game:GetService("Players")
local Stats = game:GetService("Stats")
local Network = Stats.Network
local DataPing = Network.ServerStatsItem['Data Ping']
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local UserInputService = game:GetService("UserInputService")
local CollectionService = game:GetService("CollectionService")

local LocalPlayer = Players.LocalPlayer
local Attack = ReplicatedStorage.Modules.Net["RE/RegisterAttack"]
local Hit = ReplicatedStorage.Modules.Net["RE/RegisterHit"]
local Huge = math.huge
local Ipairs = ipairs
local InputBegan = UserInputService.InputBegan
local DescendantAdded = Workspace.DescendantAdded
local Random = math.random
local Wait = task.wait
local Tick = tick
local AcceptedDistance = 59

local UpdatingValues = {
    StatsPing = DataPing:GetValue()*0.0005
}

local function PingUpdater()
    local Start = Tick()
    InputBegan:Connect(function()
        Start += 0.1
        warn("0.1s added by input")
    end)
    while Wait(1) do
        Start = Tick()
        repeat
            Wait(0.1)
        until Tick()-Start > 10
        UpdatingValues.StatsPing = DataPing:GetValue()*0.0005
        warn("Updated StatsPing!")
    end
end

coroutine.resume(coroutine.create(PingUpdater))

for i, v in Ipairs(Workspace:GetDescendants()) do
    if v:IsA("Humanoid") then
        if v.RootPart and v.Health > 0 and v:IsDescendantOf(Players.LocalPlayer.Character) ~= true then
            CollectionService:AddTag(v, "Humanoid")
        end
    end
end

DescendantAdded:Connect(function(v)
    if v:IsA("Humanoid") then
        if v:IsDescendantOf(Players.LocalPlayer.Character) ~= true then
            CollectionService:AddTag(v, "Humanoid")
        end
    end
end)

print(UpdatingValues.StatsPing)

function Nebula:GetClosestCharacter()
    local MinimumDistance = Huge
    local Character
    local SelfRoot = Players.LocalPlayer.Character.PrimaryPart
	local StatsPing = UpdatingValues.StatsPing
	local ClientPosition = SelfRoot.Position
	local SelfPosition = ClientPosition-SelfRoot.AssemblyLinearVelocity*StatsPing
    for i, v in Ipairs(CollectionService:GetTagged("Humanoid")) do
        local Root = v.RootPart
        if v.Health > 0 and Root then
            local RootPosition = Root.Position+Root.AssemblyLinearVelocity*StatsPing
            local Distance = (SelfPosition-RootPosition).Magnitude
            if Distance < MinimumDistance then
                MinimumDistance = Distance
                Character = v.Parent
            end
        end
        --Wait()
    end
    return Character, MinimumDistance
end

function Nebula:Damage(Part)
    Attack:FireServer(0.5)
    Hit:FireServer(Part, {}, nil, "")
end

return Nebula
