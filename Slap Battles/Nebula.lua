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
local Huge = math.huge
local Massive = 1024

function Nebula.ReturnRemoteForGlove(Glove)
    return ReplicatedStorage:FindFirstChild(GloveToRemoteStore[Glove or LocalPlayer.leaderstats.Glove.Value])
end

function Nebula.GetClosestPlayer(RagdollCheck, MaxRange)
    local MinimumDistance = MaxRange or Massive
    local ClosestPlayer
    if not LocalPlayer.Character then
        return ClosestPlayer, MinimumDistance
    elseif not LocalPlayer.Character.PrimaryPart then
        return ClosestPlayer, MinimumDistance
    end
    local SelfPosition = LocalPlayer.Character.PrimaryPart.Position
    for _, v in Ipairs(Players:GetPlayers()) do
        if v ~= LocalPlayer and v.Character then
            local Root = v.Character:FindFirstChild("HumanoidRootPart")
            if not Root then 
                continue
            end
            local Distance = (SelfPosition-Root.Position).Magnitude
            local RP = v.Character:FindFirstChild("FakePart Right Arm")
            local Exception
            for _, Instances in Ipairs(ExceptionInstances) do
                if v.Character:FindFirstChild(Instances) then
                    Exception = true
                end
            end
            if Distance < MinimumDistance and not (RagdollCheck and RP) and not Exception then
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
    local SelfPosition = LocalPlayer.Character.PrimaryPart.Position
    local Rad = Workspace:GetPartBoundsInRadius(SelfPosition, MaxRange or Massive, OParams)
    for _, v in Ipairs(Rad) do
        local Character = v.Parent
        if Character ~= LocalPlayer.Character and Character:IsA("Model") then
            local IsHumanoid = Character:FindFirstChildWhichIsA("Humanoid")
            if not IsHumanoid then
                continue
            end
            local Root = v
            local Distance = (SelfPosition-Root.Position).Magnitude
            local RP = Character:FindFirstChild("FakePart Right Arm")
            local Exception
            for _, Instances in Ipairs(ExceptionInstances) do
                if Character:FindFirstChild(Instances) then
                    Exception = true
                end
            end
            if Distance < MinimumDistance and not (RP and RagdollCheck) and not Exception then
                MinimumDistance = Distance
                ClosestCharacter = Character
            end
        end
    end
    return ClosestCharacter, MinimumDistance
end

local QueueRemote = Nebula.ReturnRemoteForGlove() or GeneralHit

function Nebula.QueueSlap(Part, Remote)
    QueueRemote = Remote or QueueRemote
    table.insert(SlapQueue, Part)
    print("Queued Slap")
end

function Nebula.Slap(Part, Remote)
    Remote = Remote or GeneralHit
    Remote:FireServer(Part)
    print("Slapped Via Slap Function")
end

Spawn(function()
    while Wait() do
        if #SlapQueue > 0 then
            local CurrentSlap = SlapQueue[1]
			table.remove(SlapQueue, 1)
            Nebula.Slap(CurrentSlap, QueueRemote)
            print("Slapped Via Slap Queue")
            Wait(0.55)
        end
    end
end)


local randomassstring = "nih"
print("upd status: "..randomassstring)

return Nebula
--yes youre allowed to skid it
