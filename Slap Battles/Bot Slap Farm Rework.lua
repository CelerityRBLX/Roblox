if getgenv().BSF then
    warn("Already Executed!")
    return
elseif not fireclickdetector or not firetouchinterest then
    warn("Not Compatible!")
    return
end

local Debris = game:GetService("Debris")
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")
local LocalPlayer = Players.LocalPlayer
local Portal = workspace.Lobby.Teleport1
local Reset = LocalPlayer.Reset

local Grass = workspace.Arena["main island"].Grass
local ZeroPosition = Grass.Position
local BotSpeed = 21
local Random = math.random
local Wait = task.wait
local Abs = math.abs

local TargetGlove = "Default"
local SlapRemote = ReplicatedStorage.b
local SlapAnimation = ReplicatedStorage.Slap

local function Stroke(Element, Thickness, ApplyStrokeMode, Transparency)
    local Stroke = Instance.new("UIStroke", Element)
    Stroke.Thickness = Thickness
    Stroke.LineJoinMode = Enum.LineJoinMode.Round
    Stroke.ApplyStrokeMode = ApplyStrokeMode
    Stroke.Transparency = Transparency or 0
end

local function MakeButton(Frame, X, Text)
    local ImageLabel = Instance.new("ImageLabel", Frame)
    ImageLabel.Image = "rbxassetid://17184741588"
    ImageLabel.Size = UDim2.new(0.2, 0, 0.2, 0)
    ImageLabel.AnchorPoint = Vector2.new(0.5, 0.5)
    ImageLabel.Position = UDim2.new(X, 0, 0.2, 0)
    ImageLabel.BackgroundTransparency = 1
    local Button = Instance.new("TextButton", ImageLabel)
    Button.Size = UDim2.new(1, 0, 1, 0)
    Button.AnchorPoint = Vector2.new(0, 0)
    Button.BackgroundTransparency = 1
    Button.Text = Text
    Button.TextSize = 45
    Button.Font = Enum.Font.Bangers
    Button.TextColor3 = Color3.fromRGB(248, 248, 248)
    Stroke(Button, 3, Enum.ApplyStrokeMode.Border)
    Stroke(Button, 3, Enum.ApplyStrokeMode.Contextual)
    local Corner = Instance.new("UICorner", Button)
    Corner.CornerRadius = UDim.new(0, 8)
    return Button
end

local UI = LocalPlayer.PlayerGui:FindFirstChild("Bot Slap Farm UI") or Instance.new("ScreenGui", LocalPlayer.PlayerGui)
UI.Name = "Bot Slap Farm UI"
UI.IgnoreGuiInset = true
UI:ClearAllChildren()
local Frame = Instance.new("ImageLabel", UI)
Frame.Image = "rbxassetid://17184675278"
Frame.AnchorPoint = Vector2.new(0.5, 0.5)
Frame.Position = UDim2.new(0.5, 0, 1.55, 0)
Frame.Size = UDim2.new(0.5, 0, 0.5, 0)
Frame.BackgroundTransparency = 1
local Default = MakeButton(Frame, 0.225, "Default")
local Dual = MakeButton(Frame, 0.5, "Dual")
local Snow = MakeButton(Frame, 0.775, "Snow")
local Selected = Instance.new("TextLabel", Frame)
getgenv().s = "high"
Selected.AnchorPoint = Vector2.new(0.5, 0.5)
Selected.BackgroundTransparency = 1
Selected.Size = UDim2.new(0.8, 0, 0.1, 0)
Selected.Position = UDim2.new(0.5, 0, 0.5, 0)
Selected.Text = "Selected: Default"
Selected.TextColor3 = Color3.fromRGB(248, 248, 248)
Selected.Font = Enum.Font.FredokaOne
Selected.TextSize = 60
Stroke(Selected, 2, Enum.ApplyStrokeMode.Contextual)
local function ButtonUsed(Button)
    Selected.Text = "Selected: "..Button.Text
    TargetGlove = Button.Text
    SlapAnimation = ReplicatedStorage:FindFirstChild(Button.Text.."Slap") or ReplicatedStorage.Slap
    if Button.Text == "Default" then
        SlapRemote = ReplicatedStorage.b
    elseif Button.Text == "Dual" then
        SlapRemote = ReplicatedStorage.GeneralHit
    elseif Button.Text == "Snow" then
        SlapRemote = ReplicatedStorage.SnowHit
    end
    print(TargetGlove)
    print(tostring(SlapRemote))
    print(tostring(SlapAnimation))
end
local function ButtonFunction(Button)
    Button.MouseButton1Click:Connect(function()
        ButtonUsed(Button)
    end)
    Button.TouchTap:Connect(function()
        ButtonUsed(Button)
    end)
end
ButtonFunction(Default)
ButtonFunction(Dual)
ButtonFunction(Snow)
local Start = Instance.new("TextButton", Frame)
Start.AnchorPoint = Vector2.new(0.5, 0.5)
Start.Position = UDim2.new(0.5, 0, 0.8, 0)
Start.Size = UDim2.new(0.75, 0, 0.15, 0)
Start.BackgroundColor3 = Color3.fromRGB(75, 218, 52)
Start.Font = Enum.Font.FredokaOne
Start.TextColor3 = Color3.fromRGB(254, 254, 254)
Start.TextSize = 60
Start.Text = "Start Farming!"
Start.MouseButton1Click:Connect(function()
    getgenv().BSF = true
end)
Start.TouchTap:Connect(function()
    getgenv().BSF = true
end)
Stroke(Start, 2, Enum.ApplyStrokeMode.Contextual)
Stroke(Start, 6, Enum.ApplyStrokeMode.Border)
local Corner = Instance.new("UICorner", Start)
Corner.CornerRadius = UDim.new(0, 8)
TweenService:Create(Frame, TweenInfo.new(1.5, Enum.EasingStyle.Quart, Enum.EasingDirection.InOut), {Position = UDim2.new(0.5, 0, 0.5, 0)}):Play()

repeat
    Wait(0.05)
until getgenv().BSF
TweenService:Create(Frame, TweenInfo.new(1.5, Enum.EasingStyle.Quart, Enum.EasingDirection.InOut), {Position = UDim2.new(0.5, 0, 1.55, 0)}):Play()

local LocalHumanoid
local Animation

local function CharacterLoaded(Character)
    local Humanoid = Character:WaitForChild("Humanoid", 10)
    LocalHumanoid = Humanoid
    Animation = (Humanoid:FindFirstChild("Animator") or Humanoid):LoadAnimation(SlapAnimation)
    Humanoid.AutomaticScalingEnabled = false
    Humanoid.HipHeight = 0.1
    local Support = Instance.new("BodyPosition", Humanoid.RootPart)
    Support.Position = ZeroPosition
    Support.MaxForce = Vector3.new(200, 0, 200)
    Support.Name = "Bot Support"
end

if LocalPlayer.Character then
    CharacterLoaded(LocalPlayer.Character)
end

LocalPlayer.CharacterAdded:Connect(CharacterLoaded)

local function ReturnValidVector3Unit(Vector)
    if Vector.Magnitude == 0 then
        return Vector3.zero
    end
    return Vector.Unit
end

local Amp = math.clamp(BotSpeed*0.1, 2, 4)

local RoamRange = 120

local function GetClosestPlayer()
    local MinimumDistance = 512
    local ClosestPlayer
    local LocalRoot = LocalHumanoid.RootPart
    local TempAmp = LocalPlayer:GetNetworkPing()*21
    for i, v in ipairs(Players:GetPlayers()) do
        local Character = v.Character
        if v ~= LocalPlayer and Character and LocalPlayer:IsFriendsWith(v.UserId) == false then
            local Humanoid = Character:FindFirstChildWhichIsA("Humanoid")
            if Humanoid then
                local Root = Humanoid.RootPart or Character:WaitForChild("Head", 1)
                local RootPosition = Root.Position+ReturnValidVector3Unit(Root.AssemblyLinearVelocity)*TempAmp
                local VisionPosition = LocalRoot.Position-ReturnValidVector3Unit(LocalRoot.AssemblyLinearVelocity)
                local InMap = (Root.Position-ZeroPosition).Magnitude < RoamRange
                local InLobby = Character:FindFirstChild("InLobby")
                local Rock = Character:FindFirstChild("rock")
                local Reverse = Character:FindFirstChild("Reversed")
                local Skull = Character:FindFirstChild("Skull")
                local Counter = Character:FindFirstChild("Counterd")
                local Steve = Character:FindFirstChild("stevebody")
                local Visible = Character:FindFirstChild("CarKeysCar") or (Character:FindFirstChild("Head") or Character:FindFirstChildWhichIsA("BasePart")).Transparency == 0
                local BuddyBox = Character.Head:FindFirstChild("BuddyBox")
                local Alive = Humanoid.Health > 0
                local Ragdolled = Character:FindFirstChild("FakePart Right Arm")
                local AppropiateHeight = Abs(VisionPosition.Y-RootPosition.Y) < 10
                local Distance = (VisionPosition-Root.Position).Magnitude
                local Approved = (InMap and not Rock and not Reverse and not Steve and not Skull and Visible and not BuddyBox and not Ragdolled and not InLobby and Alive and not Counter and AppropiateHeight) and Distance < MinimumDistance
                if Approved then
                    MinimumDistance = Distance
                    ClosestPlayer = v
                end
            end
        end
    end
    return ClosestPlayer, MinimumDistance
end

local Glove = workspace.Lobby[TargetGlove]

local function Equip()
    fireclickdetector(Glove:FindFirstChildOfClass("ClickDetector") or Glove:FindFirstChildWhichIsA("ClickDetector") or Glove:WaitForChild("ClickDetector", 1))
end

local function ManualEquip()
    local UI = Instance.new("ScreenGui", LocalPlayer.PlayerGui)
    Debris:AddItem(UI, 10)
    local Text = Instance.new("TextLabel", UI)
    Text.Size = UDim2.new(0.6, 0, 0.15, 0)
    Text.AnchorPoint = Vector2.new(0.5, 0.5)
    Text.Position = UDim2.new(0.5, 0, 1.1, 0)
    Text.BackgroundTransparency = 1
    Text.TextScaled = true
    Text.TextColor3 = Color3.fromRGB(254, 36, 47)
    Text.Text = "Click! (Move Around If You Cant.)"
    Text.Font = Enum.Font.FredokaOne
    Stroke(Text, 2, Enum.ApplyStrokeMode.Contextual)
    TweenService:Create(Text, TweenInfo.new(1.5, Enum.EasingStyle.Quart, Enum.EasingDirection.InOut), {Position = UDim2.new(0.5, 0, 0.7, 0)}):Play()
    Glove.Transparency = 0
    Glove.Color = Color3.fromRGB(0, 255, 255)
    Glove.Material = Enum.Material.Neon
    Glove.Position = LocalHumanoid.RootPart.Position + LocalHumanoid.RootPart.CFrame.LookVector*5
    local Start = tick()
    repeat
        Wait(0.05)
    until LocalPlayer.leaderstats.Glove.Value == TargetGlove or tick()-Start > 5
    TweenService:Create(Text, TweenInfo.new(1.5, Enum.EasingStyle.Quart, Enum.EasingDirection.InOut), {Position = UDim2.new(0.5, 0, 1.1, 0)}):Play()
end

local SlapCooldown = false

local function BehaviourLoop()
    while true do
        local AcceptableDistance = 19
        local Character = LocalPlayer.Character
        if LocalHumanoid then
            if not Character:FindFirstChild("InLobby") then
                local ClosestPlayer, Distance = GetClosestPlayer()
                Distance = Distance
                if ClosestPlayer then
                    local CarHitbox = ClosestPlayer.Character:FindFirstChild("CarKeysCar")
                    if CarHitbox then
                        CarHitbox = CarHitbox:FindFirstChild("Hitbox")
                    end
                    local TargetRoot = ClosestPlayer.Character:FindFirstChildWhichIsA("Humanoid").RootPart
                    if LocalHumanoid.Health > 0 then
                        local TargetPosition = TargetRoot.Position+ReturnValidVector3Unit(TargetRoot.AssemblyLinearVelocity)
                        LocalHumanoid:MoveTo(TargetPosition)
                        if Distance < AcceptableDistance and SlapCooldown == false then
                            SlapCooldown = true
                            local TRNG = Random(50, 60)*0.01
                            Animation:Play()
                            SlapRemote:FireServer(CarHitbox or TargetRoot)
                            task.delay(TRNG, function()
                                SlapCooldown = false
                            end)
                        end
                    end
                else
                    LocalHumanoid:MoveTo(ZeroPosition)
                end
            else
                if LocalPlayer.leaderstats.Glove.Value ~= TargetGlove then
                    local Success, _ = xpcall(Equip, function() warn("Automatic Equip Failed") end)
                    if not Success then
                        ManualEquip()
                        local Start = tick()
                        repeat
                            Wait(0.05)
                        until LocalPlayer.leaderstats.Glove.Value == TargetGlove or tick()-Start > 5
                    end
                else
                    LocalHumanoid:MoveTo(Portal.Position)
                end
            end
            local Speed = BotSpeed*2-math.clamp(LocalHumanoid.RootPart.AssemblyLinearVelocity.Magnitude, 0, BotSpeed)
            LocalHumanoid.WalkSpeed = Speed
        end
        RunService.RenderStepped:Wait()
    end
end

Grass.Size *= Vector3.new(1, 1.05, 1.05)

local Adaptation = 1.5

local function AntiAbuseLoop()
    while Wait(0.3) do
        local Character = LocalPlayer.Character
        if LocalHumanoid then
            Wait(0.05)
            if not Character:FindFirstChild("InLobby") then
                for i, v in ipairs(Character:GetChildren()) do
                    if v:IsA("BasePart") then
                        v.CanTouch = false
                    end
                end
                Wait(0.05)
            end
            local Root = LocalHumanoid.RootPart or Character:WaitForChild("Head", 1)
            if LocalHumanoid.Sit then
                LocalHumanoid.Sit = false
            end
            if Root.Position.Magnitude > 1536 or Root.Position.Y < -20 then
                Reset:FireServer()
                LocalHumanoid.Health = 0
                Wait(1)
            end
            if LocalHumanoid.Health == 0 then
                RoamRange /= Adaptation
                BotSpeed *= Adaptation
                print("RoamRange Decreased To: "..RoamRange)
                Wait(3)
                task.delay(60, function()
                    RoamRange *= Adaptation
                    BotSpeed /= Adaptation
                    print("RoamRange Increased To: "..RoamRange)
                end)
            end
            if not Character:FindFirstChildWhichIsA("Tool") and LocalPlayer.Backpack:FindFirstChildWhichIsA("Tool") then
                LocalPlayer.Backpack:FindFirstChildWhichIsA("Tool").Parent = Character
            end
        end
    end
end

coroutine.resume(coroutine.create(BehaviourLoop))
coroutine.resume(coroutine.create(AntiAbuseLoop))
