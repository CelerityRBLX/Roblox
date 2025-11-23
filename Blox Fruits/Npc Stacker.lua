local Players = game:GetService("Players")
local Enemies = workspace.Enemies
local RunService = game:GetService("RunService")

local CachedEnemies = {}

local function ReturnUnit(V)
    if V.Magnitude < 0.1 then
        return Vector3.zero
    end
    return V.Unit
end
workspace.Map["WaterBase-Plane"].Size = Vector3.new(1000, 112, 1000)

local ExploitNetCheck = isnetworkowner

local function NetworkOwnerQuestion(Part)
    local Root = Players.LocalPlayer.Character:WaitForChild("HumanoidRootPart", 10)
    local NiceDistance = (Root.Position-Part.Position).Magnitude < 30

    return ExploitNetCheck(Part) and NiceDistance
end

local function CacheEnemies()
    local NewCache = {}
    for i, v in ipairs(Enemies:GetChildren()) do
        local hum = v:FindFirstChildWhichIsA("Humanoid")
        local enemyroot = v:WaitForChild("HumanoidRootPart", 10)
        if hum and enemyroot then
            hum.WalkSpeed = 64
            if NetworkOwnerQuestion(enemyroot) then
                table.insert(NewCache, v)
            end
        end
    end
    CachedEnemies = NewCache
end

task.spawn(function()
    while task.wait(0.2) do
        CacheEnemies()
    end
end)

while true do
    if Players.LocalPlayer.Character then
        local Root = Players.LocalPlayer.Character:WaitForChild("HumanoidRootPart", 10)
        for i, v in ipairs(CachedEnemies) do
            local hum = v:FindFirstChildWhichIsA("Humanoid")
            if hum and i < 6 and NetworkOwnerQuestion(hum.RootPart) then
                hum.RootPart.AssemblyLinearVelocity = Vector3.zero
                hum.RootPart.CFrame = CFrame.new(Root.Position+Vector3.yAxis*5.1*i+ReturnUnit(Root.AssemblyLinearVelocity))
            end
        end
    end
    RunService.RenderStepped:Wait()
end