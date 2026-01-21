local Workspace = game:GetService("Workspace")
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer

--cached funcs--
local Spawn = task.spawn
local Wait = task.wait
local Match = string.match
local Normalize = vector.normalize
local Magnitude = vector.magnitude
local Tick = tick()
local Floor = math.floor
local FireTouchInterest = firetouchinterest
local FireProximityPrompt = fireproximityprompt
--cached funcs--

local Bases = Workspace:FindFirstChild("Bases") or Workspace:FindFirstChild("Bases_NEW")
local SelfBase
for i, v in (Bases:GetChildren()) do
    if v:GetAttribute("Holder") == LocalPlayer.UserId then
        SelfBase = v
    end
end
local Slots = SelfBase.Slots

local Gaps = workspace.Misc.Gaps

local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()

local Window = Rayfield:CreateWindow({
   Name = "Silus | Escape Tsunami For Brainrots",
   Icon = 0, -- Icon in Topbar. Can use Lucide Icons (string) or Roblox Image (number). 0 to use no icon (default).
   LoadingTitle = "Rayfield Interface Suite",
   LoadingSubtitle = "by Sirius",
   ShowText = "Rayfield", -- for mobile users to unhide rayfield, change if you'd like
   Theme = "Default", -- Check https://docs.sirius.menu/rayfield/configuration/themes

   ToggleUIKeybind = "K", -- The keybind to toggle the UI visibility (string like "K" or Enum.KeyCode)

   DisableRayfieldPrompts = false,
   DisableBuildWarnings = false, -- Prevents Rayfield from warning when the script has a version mismatch with the interface

   ConfigurationSaving = {
      Enabled = false,
      FolderName = nil, -- Create a custom folder for your hub/game
      FileName = "Big Hub"
   },

   Discord = {
      Enabled = true, -- Prompt the user to join your Discord server if their executor supports it
      Invite = "mnUfGWEbXH", -- The Discord invite code, do not include discord.gg/. E.g. discord.gg/ ABCD would be ABCD
      RememberJoins = true -- Set this to false to make them join the discord every time they load it up
   },

   KeySystem = false, -- Set this to true to use our key system
   KeySettings = {
      Title = "Untitled",
      Subtitle = "Key System",
      Note = "No method of obtaining the key is provided", -- Use this to tell the user how to get a key
      FileName = "Key", -- It is recommended to use something unique as other scripts using Rayfield may overwrite your key file
      SaveKey = false, -- The user's key will be saved, but if you change the key, they will be unable to use your script
      GrabKeyFromSite = false, -- If this is true, set Key below to the RAW site you would like Rayfield to get the key from
      Key = {"Hello"} -- List of keys that will be accepted by the system, can be RAW file links (pastebin, github etc) or simple strings ("hello","key22")
   }
})

Rayfield:Notify({
   Title = "Silus",
   Content = "Subscribe to @CelerityRBLX !",
   Duration = 6.5,
   Image = 4483362458,
})

local Base = Window:CreateTab("Base", "rewind")

local AutoCollect = Base:CreateSection("Auto Collect")

local MoneyCollectToggle = Base:CreateToggle({
   Name = "Auto Collect Money",
   CurrentValue = false,
   Flag = "Toggle1", -- A flag is the identifier for the configuration file, make sure every element has a different flag if you're using configuration saving to ensure no overlaps
   Callback = function(Value)

   end,
})

local US = game:GetService("ReplicatedStorage"):WaitForChild("RemoteFunctions"):WaitForChild("UpgradeSpeed")

local BuySpeed = Base:CreateButton({
   Name = "Buy Speed",
   Callback = function()
    US:InvokeServer(15)
   end,
})

Spawn(function()
    while Wait(0.1) do
        if MoneyCollectToggle.CurrentValue and LocalPlayer.Character then
            local Root = LocalPlayer.Character.PrimaryPart
            if Root then
                if Root.Position.X < 115 then
                    for i, v in (Slots:GetDescendants()) do
                        if v.Name == "Collect" then
                            FireTouchInterest(Root, v, 1)
                            Wait(0.1)
                            FireTouchInterest(Root, v, 0)
                        end
                    end
                end
            end
        end
    end
end)

local Brainrots = Window:CreateTab("Brainrots", "rewind")

local TsunamiEvasion = Brainrots:CreateSection("Tsunami Evasion")

local Gaps = Workspace.Misc.Gaps

local AutoGapTP = Brainrots:CreateToggle({
   Name = "Auto Gap Teleport",
   CurrentValue = false,
   Flag = "Toggle1", -- A flag is the identifier for the configuration file, make sure every element has a different flag if you're using configuration saving to ensure no overlaps
   Callback = function(Value)

   end,
})

local BlockTsunami = Brainrots:CreateToggle({
   Name = "Block Tsunami",
   CurrentValue = false,
   Flag = "Toggle1", -- A flag is the identifier for the configuration file, make sure every element has a different flag if you're using configuration saving to ensure no overlaps
   Callback = function(Value)

   end,
})

local StableSpeed = Brainrots:CreateToggle({
   Name = "Stable Speed",
   CurrentValue = false,
   Flag = "Toggle1", -- A flag is the identifier for the configuration file, make sure every element has a different flag if you're using configuration saving to ensure no overlaps
   Callback = function(Value)

   end,
})

local TsunamiEvasion = Brainrots:CreateSection("Collect Brainrots")

local AutoGrab = Brainrots:CreateToggle({
   Name = "Auto Grab",
   CurrentValue = false,
   Flag = "Toggle1", -- A flag is the identifier for the configuration file, make sure every element has a different flag if you're using configuration saving to ensure no overlaps
   Callback = function(Value)

   end,
})

local XZ = vector.create(1, 0, 1)

local Raise = vector.create(0, 6.5, 0)

local DodgeGap = vector.create(1 , 0, 0)

local StandHeight = vector.create(0, 3, 0)

local CFNEW = CFrame.new

local NetS = settings():GetService("NetworkSettings")

Workspace.ChildAdded:Connect(function(C)
    if Match(C.Name, "Wave") and BlockTsunami.CurrentValue then
        local Wave = C:WaitForChild("TsunamiWave")
        local SPS = 20
        Wait(0.1)
        local FP = Wave.Position
        Wait(0.2)
        local LP = Wave.Position
        SPS = Magnitude(FP-LP)*5
        local BlockPart = Instance.new("Part", Wave)
        local Weld = Instance.new("Weld", BlockPart)
        Weld.Part0 = Wave
        Weld.Part1 = BlockPart
        local NP = LocalPlayer:GetNetworkPing()*1.1
        local Push = SPS*(NP*2)+2
        print(Push)
        Weld.C1 = CFNEW(DodgeGap*Push)
        BlockPart.Massless = true
        local OldSize = Wave.Size
        local XMult = 1+OldSize.Y*0.01
        BlockPart.Size = vector.create(OldSize.X*XMult, OldSize.Y*0.96, OldSize.Z*1.1)
        Wave.CanTouch = false
        Wave.CanCollide = true
        BlockPart.Color = Color3.fromRGB(255, 32, 192)
        BlockPart.Material = Enum.Material.ForceField
    end
end)

Spawn(function()
    while Wait(0.02) do
        local SelfChar = LocalPlayer.Character
        local Loaded = SelfChar:FindFirstChild("Head") and SelfChar:FindFirstChild("HumanoidRootPart")
        if AutoGapTP.CurrentValue and SelfChar and Loaded then
            local Root = LocalPlayer.Character.PrimaryPart
            local Hum = LocalPlayer.Character.Humanoid
            local SelfPos = Root.Position
            for i, v in (Workspace:GetChildren()) do
                if Match(v.Name, "Wave") then
                    local Wave = v.TsunamiWave
                    local WavePos = Wave.Position
                    local Diff = WavePos.X-SelfPos.X
                    if Diff < 70 and Diff > 1 then
                        local MD = 70
                        local Pick
                        for i, v in (Gaps:GetChildren()) do
                            local Pos = v:GetPivot().Position
                            local Dist = Magnitude(SelfPos-Pos)
                            if Dist < MD then
                                MD = Dist
                                Pick = Pos
                            end
                        end
                        if Pick and SelfPos.Y > 0 and SelfPos.X > 150 then
                            Root.CFrame = CFNEW(Pick)
                        end
                    end
                end
            end
        end
    end
end)

local Strong = PhysicalProperties.new(7, 0.3, 0.25, 1, 1)
local Default = PhysicalProperties.new(0.7, 0.3, 0.5, 1, 1)

local Rots = Workspace.ActiveBrainrots

Spawn(function()
    while Wait(0.2) do
        local SelfChar = LocalPlayer.Character
        local SelfRoot = SelfChar:FindFirstChild("HumanoidRootPart")
        local SelfPos = SelfRoot.Position
        local Loaded = SelfChar:FindFirstChild("Head") and SelfRoot
        if Loaded then
            if StableSpeed.CurrentValue then
                SelfChar.PrimaryPart.CustomPhysicalProperties = Strong
            end
            if AutoGrab.CurrentValue then
                for i, v in (Rots:GetDescendants()) do
                    local Root = v:FindFirstChild("Root")
                    if Root then
                        local Prompt = Root:WaitForChild("TakePrompt")
                        local Dist = Magnitude(SelfPos-Root.Position)
                        if Dist < 12 then
                            FireProximityPrompt(Prompt)
                            warn("grabbed brainrot")
                        end
                    end
                end
            end
        end
    end
end)
