local Nebula = {}

local Workspace = game:GetService("Workspace")
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local GeneralHit = ReplicatedStorage.GeneralHit
local LocalPlayer = Players.LocalPlayer
local ExceptionInstances = {"InLobby", "rock", "Reversed", "Counterd", "stevebody"}

local GloveToRemoteStore = {
    Default = "b",
    Diamond = "DiamondHit",
    ZZZZZZZ = "ZZZZZZZHit",
    Extended = "b",
    Dual = "GeneralHit",
    Brick = "BrickHit",
    Snow = "SnowHit",
    Pull = "PullHit",
    Flash = "FlashHit",
    Spring = "springhit",
}

local SlapQueue = {}

local Ipairs = ipairs
local OParams = OverlapParams.new()
local Wait = task.wait
local Spawn = task.spawn
local Remove = table.remove
local Insert = table.insert
local Huge = math.huge
local Massive = 1024

local AverageOneWay = 0.075

function Nebula.ReturnRemoteForGlove(Glove)
    Glove = Glove or LocalPlayer.leaderstats.Glove.Value
    return ReplicatedStorage:FindFirstChild(GloveToRemoteStore[Glove])
end

local function GetBestRemote(Remote)
    local BestRemote = Remote or Nebula.ReturnRemoteForGlove() or GeneralHit
    return BestRemote
end

local function ApproveCharacter(Character)
    local Approved = true
    for _, Instances in Ipairs(ExceptionInstances) do
        if Character:FindFirstChild(Instances) then
            Approved = false
        end
    end
    if Character:FindFirstChildWhichIsA("Humanoid").Health <= 0 or Character:FindFirstChild("Head").Transparency > 0 then
        Approved = false
    end
    return Approved
end

local function ReturnUnit(Vector)
    local Unit = Vector3.zero
    if Vector.Magnitude > 0 then
        Unit = Vector.Unit
    end
    return Unit
end

function Nebula.GetClosestPlayer(RagdollCheck, MaxRange)
    local MinimumDistance = MaxRange or Massive
    local ClosestPlayer
    if not LocalPlayer.Character then
        return ClosestPlayer, MinimumDistance
    elseif not LocalPlayer.Character.PrimaryPart then
        return ClosestPlayer, MinimumDistance
    end
    local PrimaryPart = LocalPlayer.Character.PrimaryPart
    local SelfPosition = PrimaryPart.Position
    for _, v in Ipairs(Players:GetPlayers()) do
        if v ~= LocalPlayer and v.Character then
            local Root = v.Character:FindFirstChild("HumanoidRootPart")
            if not Root then 
                continue
            end
            local PredictedPosition = Root.Position+ReturnUnit(Root.AssemblyLinearVelocity)--+Root.AssemblyLinearVelocity*AverageOneWay
            local Distance = (SelfPosition-PredictedPosition).Magnitude
            local RP = v.Character:FindFirstChild("FakePart Right Arm")
            local CA = ApproveCharacter(v.Character)
            if Distance < MinimumDistance and not (RagdollCheck and RP) and CA then
                MinimumDistance = Distance
                ClosestPlayer = v
            end
        end
    end
    return ClosestPlayer, MinimumDistance
end

function Nebula.GetClosestCharacter(RagdollCheck, MaxRange)
    local MinimumDistance = MaxRange or Massive
    local ClosestCharacter
    if not LocalPlayer.Character then
        return ClosestCharacter, MinimumDistance
    elseif not LocalPlayer.Character.PrimaryPart then
        return ClosestCharacter, MinimumDistance
    end
    local PrimaryPart = LocalPlayer.Character.PrimaryPart
    local SelfPosition = PrimaryPart.Position
    local Rad = Workspace:GetPartBoundsInRadius(SelfPosition, MaxRange or Massive, OParams)
    for _, v in Ipairs(Rad) do
        local Character = v.Parent
        if Character ~= LocalPlayer.Character and Character:IsA("Model") then
            local IsHumanoid = Character:FindFirstChildWhichIsA("Humanoid")
            if not IsHumanoid then
                continue
            end
            local Root = v
            local PredictedPosition = Root.Position+ReturnUnit(Root.AssemblyLinearVelocity)--+Root.AssemblyLinearVelocity*AverageOneWay
            local Distance = (SelfPosition-PredictedPosition).Magnitude
            local RP = Character:FindFirstChild("FakePart Right Arm")
            local CA = ApproveCharacter(Character)
            if Distance < MinimumDistance and not (RP and RagdollCheck) and CA then
                MinimumDistance = Distance
                ClosestCharacter = Character
            end
        end
    end
    return ClosestCharacter, MinimumDistance
end

function Nebula.QueueSlap(Part)
    Insert(SlapQueue, Part)
    print("Queued Slap")
end

function Nebula.Slap(Part, Remote)
    Remote = GetBestRemote(Remote)
    Remote:FireServer(Part)
    print("Slapped Via Slap Function")
end

Spawn(function()
    local CachedSlap = Nebula.Slap
    while Wait() do
        if #SlapQueue > 3 then
            repeat
                Remove(SlapQueue, 1)
            until #SlapQueue <= 3
            print("Removing Excess Slap Request From Queue")
        end
        if #SlapQueue > 0 then
            local CurrentSlap = SlapQueue[1]
			Remove(SlapQueue, 1)
            CachedSlap(CurrentSlap, GetBestRemote())
            print("Slapped Via Slap Queue")
            Wait(0.55)
        end
    end
end)


local randomassstring = "43567true hipa dih"
print("upd status: "..randomassstring)

return Nebula
--yes youre allowed to skid it
