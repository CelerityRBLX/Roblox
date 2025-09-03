    local Players = game:GetService("Players")
    local ReplicatedStorage = game:GetService("ReplicatedStorage")
    local StarterGui = game:GetService("StarterGui")
    local TextChatService = game:GetService("TextChatService")
    local RunService = game:GetService("RunService")
    local Debris = game:GetService("Debris")
    local TweenService = game:GetService("TweenService")
    local LocalPlayer = Players.LocalPlayer
    local GeneralHit = ReplicatedStorage.GeneralHit
    local DiamondHit = ReplicatedStorage.DiamondHit
    local ReaperHit = ReplicatedStorage.ReaperHit
    local DisarmH = ReplicatedStorage.DisarmH
    local BullHit = ReplicatedStorage.BullHit
    local Slapstick = ReplicatedStorage.slapstick
    local Slap = ReplicatedStorage.Assets.Beatdown.slap_anim
    local Idle = ReplicatedStorage.Assets.Pan.panman_idle
    local Lunge = ReplicatedStorage.Assets.Swordfighter.animations.lunge
    local Select = workspace.Sounds.Select
    local SlapCooldown = false
    local RushState = false
    local SlapDelay = 0.5
    local SpeedVariable = 40
    local LastPosition = Vector3.new(0, 0, 0)
    local Grip = CFrame.new(0, -0.75, -1.1) * CFrame.Angles(math.rad(-85), 0, 0)

    Select.Volume = 0
    local function CreateSave(HATE)
        local RawPosition = LocalPlayer.Character.HumanoidRootPart.Position+LocalPlayer.Character.HumanoidRootPart.CFrame.LookVector*3
        local Position = Vector3.new(RawPosition.X, math.clamp(RawPosition.Y, -10, 80), RawPosition.Z)
        local RCP = RaycastParams.new()
        local ExcludeTable = {workspace.Arena.Plate, workspace.DEATHBARRIER, workspace.dedBarrier, unpack(LocalPlayer.Character:GetDescendants())}
        RCP.FilterType = Enum.RaycastFilterType.Exclude
        RCP.FilterDescendantsInstances = ExcludeTable
        for i, v in ipairs(ExcludeTable) do print(v) end
        local Ground = workspace:Raycast(Position, Vector3.new(0, -10, 0), RCP)
        if Ground then
            local CharaFolder = workspace.CharaFolder
            local PastSave = CharaFolder:FindFirstChild("Save")
            if PastSave then PastSave:Destroy() end
            local Save = Instance.new("Part", workspace.CharaFolder)
            local BillboardGui = Instance.new("BillboardGui", Save)
            local ImageLabel = Instance.new("ImageLabel", BillboardGui)
            if HATE then
                ImageLabel.ImageColor3 = Color3.new(0, 0, 0)
            end
            Save.Name = "Save"
            Save.Size = Vector3.new(1, 1, 1)
            BillboardGui.Size = UDim2.new(4, 0, 4, 0)
            ImageLabel.Image = "rbxassetid://133869927687945"
            ImageLabel.BackgroundTransparency = 1
            ImageLabel.Size = UDim2.new(1, 0, 1, 0)
            local Sound = Instance.new("Sound", Save)
            Sound.SoundId = "rbxassetid://80121678514092"
            Save.Anchored = true
            Save.Transparency = 1
            Save.CanCollide = false
            Sound.Name = "SaveSFX"
            Sound.Volume = 3
            Save.Position = Position
            Sound:Play()
        end
    end

    local function Equip(Glove, Badge)
        if LocalPlayer.leaderstats.Glove.Value ~= Glove then
        if Badge then
            for i, v in ipairs(ReplicatedStorage._NETWORK:GetChildren()) do
                if v:IsA("RemoteEvent") and string.match(v.Name, "{") then
                    v:FireServer(Glove)
                end
            end
        else
            fireclickdetector(workspace.Lobby[Glove].ClickDetector)
        end
        end
    end

    local function GetClosestPlayer()
        local ClosestPlayer = Players:GetPlayers()[math.random(1, #Players:GetPlayers())]
        local MinimumDistance = math.huge
        for i, v in ipairs(Players:GetPlayers()) do
            local Character = v.Character
            if Character then
                if Character:FindFirstChildWhichIsA("Humanoid") and Character:FindFirstChild("HumanoidRootPart") and Character:FindFirstChild("Torso") then
                    local Rock = Character:FindFirstChild("rock")
                    local Reversed = Character:FindFirstChild("Reversed")
                    local Immune = Character:FindFirstChild("InLobby")
                    local Counter = v.leaderstats.Glove.Value == "Counter"
                    local Steve = Character:FindFirstChild("stevebody")
                    local Visible = Character.Torso.Transparency < 0.1
                    local Alive = Character:FindFirstChildWhichIsA("Humanoid").Health > 0.1
                    if Rock == nil and Reversed == nil and Immune == nil and v ~= LocalPlayer and Visible and Counter == false and Alive and Steve == nil then
                        local Distance = (Character.HumanoidRootPart.Position-(LocalPlayer.Character.HumanoidRootPart.Position+LocalPlayer.Character.HumanoidRootPart.CFrame.LookVector)).Magnitude
                        if Distance < MinimumDistance then
                            MinimumDistance = Distance
                            ClosestPlayer = v
                        end
                    end
                end
            end
        end
        return ClosestPlayer
    end

    local function GiveKnife()
        local Knife = Instance.new("Part", LocalPlayer.Character)
        local Mesh = Instance.new("SpecialMesh", Knife)
        local Weld = Instance.new("Weld", Knife)
        Knife.CanCollide = false
        Knife.Massless = true
        Mesh.MeshId = "rbxassetid://121944778"
        Mesh.TextureId = "rbxassetid://362719969"
        Knife.Size = Vector3.new(0.5, 3.5, 2)
        Knife.Material = Enum.Material.DiamondPlate
        Weld.Part0 = LocalPlayer.Character["Right Arm"]
        Weld.Part1 = Knife
        Weld.C0 = Grip
    end
    
    local function SetTools3()
        if LocalPlayer.leaderstats.Slaps.Value < 40 then
            StarterGui:SetCore("SendNotification", {
                Title = "N̶̤̓͋̈Ọ̶̟̮͎̼̮̿̅͐̄͌̃͂̄̑͐̆͐̏̎͝T̵̬̀̈͛̓̃̇̎ ̵̧̛̛̻̰̼̼̱̤̘̻̺͉̭͖͊̈́̈͐̿̋͜͠ͅĘ̴̭̲̳͙̬͎̭̤͋́̂͌̓͝Ǹ̵̘̳͍̺͐̃͐O̸̡̥̭̞̫̣̥̜̱̼̣̍̍̈̄́̅̊͌̚͜Ű̷̳̖̰̣̮͚̇̓́̋̚G̵̢͖͇͔͕̞̎̑͐̊̐̐͐̈͂̚̕̚͠͝͠Ḧ̷̩̬͕̜͚̰̮̄̓̄̎̃̈͊̒̏̊̏͐̕͘ ̶̧̜͎̯̲͓͖̞̗͔̲̀̎̌͂̀̃̒̇͋̓͜͜S̷̡̺͚̬̥͍̮̟̬̳͕̟͎̈́̌͛̊͑̓͑̀̅̂̽̎̉̕̕͜ͅḼ̵̛̖̤̍̈́̓̓͋̕Ą̷̛̰͓̦̻̼̜̖̗͍̎̿̉̔̀͝P̵͚͈̝̼̪̹͚͎̫̲̩̖͉͙̿͊̏͊̓̔͐̔͝S̴̢̺̗͔̠̺̣̹̲̈̓̌̑͒̏̈̇̒ͅ",
                Text = "T̵̺͓̖̖̘͇̤̺̜͐͜O̷̢̧̙͉̤̘̠̣̝̳͔̤̍́̊̽̓̿̍͆̓̑́̕͜͝R̵̬̮̞̀̾̈́̋̅̄̒T̵̮͎̘̲͍̠͈͙̓́Ư̴̻͙͉̭̠̰͍͙̤̻̣͍͙̩͙̑͊̉͛͑͊͑̔̐͒̕͝͝R̶̛͍̣͚͈̹̫̜̣̜̥̉͐̐͒Ȩ̴̡̰̩͎̻̰̰̖͚͍̳͎̬͚̈́̇̂̽͝ ̷̧̞̫̮̤̦̦̦̮̻͕̝̘̈́̆̆̀̉ͅͅM̷͎̲̰̟͙̟̻̭̏̆̐̈́͛̀͆͂Ỏ̶̙̤͈͚̘͓͂̆͆̽̑̈̎͛͘Ŕ̴̞̬͇̺͓̮̩͍̟̙̋̓̀̿́̄̋̍͝͝É̵̘̹̮̙͎̗̳̠̮̓̈́̏̈́̏͗̓͠ ̶̨̢͇̹͕̳̭͈̠̥̲͕͕̈́̈́S̷̼̮͋́̒͘͝Ở̸̡̡̠̮͚̥̮͎͓͇̩̰̮̽͜ͅU̸̡̢̢͇͓̝̰̝̼̖͍̙̓͋̾̑͐̀̉̏̔͘͠͠L̵̞̭̻̼͌͂̐̌͝͝͝S̷̨̢̧͎̥̱̟̻̝̙̪̙͈̿͆̎͒́̀͠"
            })
            return
        end
        Equip("Charge", false)
        repeat
            task.wait()
        until LocalPlayer.leaderstats.Glove.Value == "Charge"
        for i, v in ipairs(LocalPlayer.Backpack:GetChildren()) do
            v:Destroy()
        end
        SpeedVariable = 0
        LocalPlayer.Character:FindFirstChildWhichIsA("Humanoid").Health = 0.11
        LocalPlayer.Character:FindFirstChildWhichIsA("Humanoid"):LoadAnimation(workspace.CharaFolder.Invade):Play(0.1, 1, 0.75)
        task.wait(4.5)
        for i, v in ipairs(LocalPlayer.Character.Humanoid:GetPlayingAnimationTracks()) do
            if v.Name == "Invade" or v.Name == "infect" then
                v:AdjustSpeed(0.2)
            end
        end
        TextChatService.TextChannels.RBXGeneral:SendAsync("Free..")
        for i, v in ipairs(LocalPlayer.Character:GetChildren()) do
            if v:IsA("Shirt") or v:IsA("Pants") then
                v:Destroy()
            elseif v:IsA("Part") then
                TweenService:Create(v, TweenInfo.new(3, Enum.EasingStyle.Linear), {Color = Color3.fromRGB(255, 232, 172)}):Play()
            end
        end
        local Shirt = Instance.new("Shirt", LocalPlayer.Character)
        Shirt.ShirtTemplate = "http://www.roblox.com/asset/?id=9744696904"
        local Pants = Instance.new("Pants", LocalPlayer.Character)
        Pants.PantsTemplate = "http://www.roblox.com/asset/?id=9744692610"
        task.wait(6.5)
        TextChatService.TextChannels.RBXGeneral:SendAsync("AT LAST =)")
        SpeedVariable = 128
        for i, v in ipairs(LocalPlayer.Character:GetChildren()) do
            if v:IsA("Part") then
                v.CustomPhysicalProperties = PhysicalProperties.new(50, 0.3, 0.5)
            end
        end
        workspace.CharaFolder.CharaRun.Name = "CharaRunX"
        task.spawn(function()
            repeat
                task.wait()
            until LocalPlayer.Character:FindFirstChildWhichIsA("Humanoid").Health < 0.01
            workspace.CharaFolder.CharaRunX.Name = "CharaRun"
        end)
        local Slash = Instance.new("Tool")
        Slash.Name = "S̷̛̘̰̟͓͒̆͒́̐̽̄̍̈͝͝ͅḼ̵̞̲̩̮̩̥͍̦̉̓́͂̚͜ͅA̷̧͇̹̠͖̳͙̻̘͊̐̈́̂̅͊̕S̴̬̺͈̬̥͖̖͖̟̖͙̪̹̬̔͛͂̓̒Ḩ̶͔͔͍̻͈͂͒̽͌́́"
        Slash.CanBeDropped = false
        Slash.RequiresHandle = false
        Slash.ToolTip = "H̸͇͚̺̆̅͜͜A̵͔͇͔̠̹̙̳̟̱̼̤͙̱̓̓̐̿̇̋̃̐̾͒̿̕͜͠ͅT̶̢̨̛̰̫͎̼̙̜̦̪͉̣̍̊̒͒̋͌̾͒̃͑̿̓̈́E̴̛̥͔͈̻̺̪͚̟̭̜̮͑̈́͒"
        Slash.Parent = LocalPlayer.Backpack
        Slash.Activated:Connect(function()
            if SlapCooldown == false then
                SlapCooldown = true
                LocalPlayer.Character.Humanoid:LoadAnimation(Slap):Play(0.1, 1, (LocalPlayer.Character.Humanoid.WalkSpeed/40)*5)
                for i, v in ipairs(LocalPlayer.Character.Humanoid:GetPlayingAnimationTracks()) do
                    if v.Name == "slap_anim" then
                        v:AdjustSpeed((LocalPlayer.Character.Humanoid.WalkSpeed/40)*5)
                    end
                end
                local GCP = GetClosestPlayer()
                wait()
                Equip("Charge", true)
                GeneralHit:FireServer(GCP.Character.HumanoidRootPart, true)
                print("hit")
                task.wait(SlapDelay)
                SlapCooldown = false
            end
        end)
        
        local TriStrike = Instance.new("Tool")
        TriStrike.Name = "T̴̻̖͇̖̭͚͐̈́̍͘ͅŗ̷̪̥͇͔̊̓̽̽̿͗î̸̝̤̞̹̜̕S̸̮̭̺̩͔̪͕̲̤͌̈́̂͛͌̎̈́̄͊̔͝ṭ̴̢̢͔̖̳͍̹̣̯̺̺̗̽̒͗͝ͅr̶͈̟̰̻͎̯̘̝̫̹̼̿́̋̿̉̒͘͜ĩ̷͔̘͚͚̖̘͚͖̥̙̻̮̙̀̊͋͜k̶̡̢̝͔̠̳̻̰̻̫̱̖͔̔̅̄͜ȅ̶̟̈́͗́̇͐̓͗̔͌̇̓̚̕"
        TriStrike.CanBeDropped = false
        TriStrike.RequiresHandle = false
        TriStrike.ToolTip = "H̸͇͚̺̆̅͜͜A̵͔͇͔̠̹̙̳̟̱̼̤͙̱̓̓̐̿̇̋̃̐̾͒̿̕͜͠ͅT̶̢̨̛̰̫͎̼̙̜̦̪͉̣̍̊̒͒̋͌̾͒̃͑̿̓̈́E̴̛̥͔͈̻̺̪͚̟̭̜̮͑̈́͒"
        TriStrike.Parent = LocalPlayer.Backpack
        TriStrike.Activated:Connect(function()
            if SlapCooldown == false then
                SlapCooldown = true
                workspace.Gravity = 10
                Equip("Charge", true)
                local GCP = GetClosestPlayer()
                local Target = GCP.Character.HumanoidRootPart
                local Offset = 27.5
                local Prediction = 0.2
                local PT = {Vector3.new(Offset, 0, 0), Vector3.new(0, 0, Offset)}
                local Position = PT[math.random(1, 2)]
                local Root = LocalPlayer.Character.HumanoidRootPart
                local Support1 = Instance.new("BodyGyro", LocalPlayer.Character.HumanoidRootPart)
                Debris:AddItem(Support1, 3)
                SpeedVariable = 0
                Root.CFrame = CFrame.lookAt(Target.Position+Target.AssemblyLinearVelocity*Prediction-Position, Target.Position+Target.AssemblyLinearVelocity*Prediction)
                task.wait(0.1)
                GeneralHit:FireServer(GCP.Character.HumanoidRootPart, true)
                LocalPlayer.Character.Humanoid:LoadAnimation(Slap):Play(0.1, 1, (LocalPlayer.Character.Humanoid.WalkSpeed/40)*5)
                print("hit")
                task.wait(0.49)
                Root.CFrame = CFrame.lookAt(Target.Position+Target.AssemblyLinearVelocity*Prediction+Position, Target.Position+Target.AssemblyLinearVelocity*Prediction)
                task.wait(0.1)
                GeneralHit:FireServer(GCP.Character.HumanoidRootPart, true)
                LocalPlayer.Character.Humanoid:LoadAnimation(Slap):Play(0.1, 1, (LocalPlayer.Character.Humanoid.WalkSpeed/40)*5)
                task.wait(0.49)
                Root.CFrame = CFrame.lookAt(Target.Position+Target.AssemblyLinearVelocity*Prediction-Position, Target.Position+Target.AssemblyLinearVelocity*Prediction)
                task.wait(0.1)
                GeneralHit:FireServer(GCP.Character.HumanoidRootPart, true)
                LocalPlayer.Character.Humanoid:LoadAnimation(Slap):Play(0.1, 1, (LocalPlayer.Character.Humanoid.WalkSpeed/40)*5)
                SpeedVariable = 128
                workspace.Gravity = 190
                SlapCooldown = false
            end
        end)

        local RisingDeath = Instance.new("Tool")
        RisingDeath.Name = "R̶͈͇̬͉̳̱͕̦̟̞̄̅͛͜͜Ȉ̷̛̛͙̙̳̯̠͍̩̺̮͕̤̂̑̂́̇̀̌̂̌̌̕S̷̢̨̢̗͔̬͍̯̞̜̳̱̈͗̉̽̈̓̓̋̕̚͘͜Ǐ̶͇̦̃͐͑̈́̇̉̓́̀̓̚͠͝N̷̢͕̱̯̮̠̼͓̪̑͑͌̉̃͘̕Ǵ̸̢̢̳̫͍̱͌͛̐̒̃̔̈̐̆̕ ̴͖̮̠̬͕̞̙̮̪̻̬̑͋̄̾̔̿̎͊̍̓̋̈́͝ͅD̸̡̛̮̬͙̣̘̈́̔̿̏̔͗̒̃́͋È̴͔̣̹͔̘͓̬͉̹̖̭̺̱̔Ă̶̡͔̤̥̙̳͕͈͖̱̖͕̽Ṱ̸̑́̃Ḩ̷͖͕̺͍̗͇̜̩͈͐̊̀̈́͒͗̚͝͠"
        RisingDeath.CanBeDropped = false
        RisingDeath.RequiresHandle = false
        RisingDeath.ToolTip = "H̸͇͚̺̆̅͜͜A̵͔͇͔̠̹̙̳̟̱̼̤͙̱̓̓̐̿̇̋̃̐̾͒̿̕͜͠ͅT̶̢̨̛̰̫͎̼̙̜̦̪͉̣̍̊̒͒̋͌̾͒̃͑̿̓̈́E̴̛̥͔͈̻̺̪͚̟̭̜̮͑̈́͒"
        RisingDeath.Parent = LocalPlayer.Backpack
        RisingDeath.Activated:Connect(function()
            if SlapCooldown == false then
                SlapCooldown = true
                Equip("Charge", true)
                local GCP = GetClosestPlayer()
                local Target = GCP.Character.HumanoidRootPart
                local Prediction = 0.1
                local Root = LocalPlayer.Character.HumanoidRootPart
                local Lock = -1
                SpeedVariable = 0
                local Connection
                Connection = RunService.Heartbeat:Connect(function()
                    Root.CFrame = CFrame.lookAt(Target.Position+Target.AssemblyLinearVelocity*Prediction+Vector3.new(0, 15, 0)*Lock, Target.Position+Target.AssemblyLinearVelocity*Prediction)
                end)
                task.delay(4.25, function()
                    Connection:Disconnect()
                end)
                GeneralHit:FireServer(GCP.Character.HumanoidRootPart, true)
                task.wait(0.6)
                GeneralHit:FireServer(GCP.Character.HumanoidRootPart, true)
                task.wait(0.6)
                GeneralHit:FireServer(GCP.Character.HumanoidRootPart, true)
                task.wait(0.6)
                GeneralHit:FireServer(GCP.Character.HumanoidRootPart, true)
                task.wait(0.6)
                GeneralHit:FireServer(GCP.Character.HumanoidRootPart, true)
                task.wait(0.6)
                Lock = 1
                task.wait(0.2)
                GeneralHit:FireServer(GCP.Character.HumanoidRootPart, true)
                task.wait(1)
                wait()
                Root.AssemblyLinearVelocity = Vector3.zero
                Root.AssemblyAngularVelocity = Vector3.zero
                SpeedVariable = 128
                SlapCooldown = false
            end
        end)
    end

    local function SetTools2()
        Equip("Charge", true)
        repeat
            task.wait()
        until LocalPlayer.leaderstats.Glove.Value == "Charge"
        for i, v in ipairs(LocalPlayer.Backpack:GetChildren()) do
            v:Destroy()
        end
        --TextChatService.TextChannels.RBXGeneral:SendAsync("Greetings =)")
        workspace.CharaFolder.CharaScream:Play()
        wait(workspace.CharaFolder.CharaScream.TimeLength)
        workspace.CharaFolder.CharaSlash:Play()
        wait(workspace.CharaFolder.CharaSlash.TimeLength)
        SpeedVariable = 70
        SlapDelay = 0.45
        local Slash = Instance.new("Tool")
        Slash.Name = "S̷̛̘̰̟͓͒̆͒́̐̽̄̍̈͝͝ͅḼ̵̞̲̩̮̩̥͍̦̉̓́͂̚͜ͅA̷̧͇̹̠͖̳͙̻̘͊̐̈́̂̅͊̕S̴̬̺͈̬̥͖̖͖̟̖͙̪̹̬̔͛͂̓̒Ḩ̶͔͔͍̻͈͂͒̽͌́́"
        Slash.CanBeDropped = false
        Slash.RequiresHandle = false
        Slash.ToolTip = "D̶̡̡̨̡̰͚̭̥̦̘̯̈́̀̓͑͑̌̎̑͌̈́̈́̀̕͘E̴̜̘̫̖̖͍̟̪̻̥͎̩̾̒͐̆̄̏̉̎Ţ̸̡̗̟̘̭̃̔̓̓͌͂̈́̔̍͌̄̇̍͘É̷̩̼̼̱̜̗̠͉̤̘̓̋͗̿̾̏͛͗͒̑̌̽͠͠R̸̢̜̬͔̞̟͚̤̣̬̔͋̈́̄̏̄͑̉̊̌̈̍̚ͅM̸̨̱̹̱͉̘̰͕͕̦̯̐̃̑̃͆̀̏̓̕͜͝I̵̻͈̯̟͕̞̩̞̓̒̆͋͐̋̿̓̈́͝͝͝Ņ̷͚̻̩̦̭̙͊̆͑̊̒̅̎͘A̵̻̤͎̪̥͙̅̏̓̎͛͊͋̅̾͆̇̕T̵̡͙̺̗̼̬̯̦͓̹̜͓̫̂I̸̛͚̠̲̬̭̯͙͓͂̑͋̍̌̓̃̏̑̑̿̕͝Ở̷̳̪̙́͝Ň̶̯͎͇̙̪͚͌͠"
        Slash.Parent = LocalPlayer.Backpack
        Slash.Activated:Connect(function()
            if SlapCooldown == false then
                SlapCooldown = true
                LocalPlayer.Character.Humanoid:LoadAnimation(Slap):Play()
                for i, v in ipairs(LocalPlayer.Character.Humanoid:GetPlayingAnimationTracks()) do
                    if v.Name == "slap_anim" then
                        v:AdjustSpeed((LocalPlayer.Character.Humanoid.WalkSpeed/40)*5)
                    end
                end
                local GCP = GetClosestPlayer()
                wait()
                Equip("Charge", true)
                GeneralHit:FireServer(GCP.Character.HumanoidRootPart)
                print("hit")
                task.wait(SlapDelay)
                SlapCooldown = false
            end
        end)

        local SpinSlash = Instance.new("Tool")
        SpinSlash.Name = "S̸̹̼͈̣̪̔̓̅̃̐̀͒͂̈́͗͛P̸̖̔̋̉̔̐̅̆̇Ȉ̵̬̜̜̭̝̙̖̘̗̣̖̂͂̔̍͊̍̊̍̓̀͘͝͠Ņ̵̡̨̦̹͚͉̖̦̮͉̠̔̒̌͗̈͊̾͆̊͘͜͝ͅ ̶͍̖͓͙̬̪̲̆̎̅̂S̵͈̘͋̓̆͐̀̎̕L̵̖̱̙̰̖̱͉̲͕̩͔͍͚̗͔̀͒̑͆̐̒̒̏́̆̂̚A̴̧̢͖̭̠͛̍S̷̡̺̤͇̪̝̲̹̘̝̭̏͋͌̀̊̂̅͐̀̈́̕͜͜͠Ḩ̴̡͉̟̻͓̺͇̬̙͓̦͉̹͊"
        SpinSlash.CanBeDropped = false
        SpinSlash.RequiresHandle = false
        SpinSlash.ToolTip = "D̶̡̡̨̡̰͚̭̥̦̘̯̈́̀̓͑͑̌̎̑͌̈́̈́̀̕͘E̴̜̘̫̖̖͍̟̪̻̥͎̩̾̒͐̆̄̏̉̎Ţ̸̡̗̟̘̭̃̔̓̓͌͂̈́̔̍͌̄̇̍͘É̷̩̼̼̱̜̗̠͉̤̘̓̋͗̿̾̏͛͗͒̑̌̽͠͠R̸̢̜̬͔̞̟͚̤̣̬̔͋̈́̄̏̄͑̉̊̌̈̍̚ͅM̸̨̱̹̱͉̘̰͕͕̦̯̐̃̑̃͆̀̏̓̕͜͝I̵̻͈̯̟͕̞̩̞̓̒̆͋͐̋̿̓̈́͝͝͝Ņ̷͚̻̩̦̭̙͊̆͑̊̒̅̎͘A̵̻̤͎̪̥͙̅̏̓̎͛͊͋̅̾͆̇̕T̵̡͙̺̗̼̬̯̦͓̹̜͓̫̂I̸̛͚̠̲̬̭̯͙͓͂̑͋̍̌̓̃̏̑̑̿̕͝Ở̷̳̪̙́͝Ň̶̯͎͇̙̪͚͌͠"
        SpinSlash.Parent = LocalPlayer.Backpack
        SpinSlash.Activated:Connect(function()
            if SlapCooldown == false then
                SlapCooldown = true
                local Support = Instance.new("BodyGyro", LocalPlayer.Character.HumanoidRootPart)
                Debris:AddItem(Support, 5)
                task.spawn(function()
                    local Radius = 60
                    local Duration = 0.5
                    local AngularSpeed = (2 * math.pi) / Duration
                    local StartTime = tick()
                    local Connection
                    Connection = RunService.Heartbeat:Connect(function()
                        local t = tick() - StartTime
                        if t > Duration then
                            LocalPlayer.Character.Torso.AssemblyLinearVelocity = Vector3.zero
                            Connection:Disconnect()
                            return
                        end
                        local angle = t * AngularSpeed
	                    local vx = -math.sin(angle) * Radius * AngularSpeed
	                    local vz =  math.cos(angle) * Radius * AngularSpeed

	                    LocalPlayer.Character.Torso.AssemblyLinearVelocity = Vector3.new(vx, 0, vz)
                    end)
                end)
                LocalPlayer.Character.Humanoid:LoadAnimation(workspace.CharaFolder.DashAnimation):Play()
                for i, v in ipairs(LocalPlayer.Character.Humanoid:GetPlayingAnimationTracks()) do
                    if v.Name == "DashAnimation" then
                        v:AdjustSpeed((LocalPlayer.Character.Humanoid.WalkSpeed/40)*2)
                    end
                end
                local GCP = GetClosestPlayer()
                wait()
                Equip("Charge", true)
                GeneralHit:FireServer(GCP.Character.HumanoidRootPart)
                print("hit")
                task.wait(SlapDelay)
                SlapCooldown = false
            end
        end)

        local BackFlash = Instance.new("Tool")
        BackFlash.Name = "Ḇ̶̘̜̝̞̩̫̖̪͙͙͖̿̓͒͑͒̽̽̚̕͘̚͜͝A̷̡̦͕͖͍̻̰͖̱͗̈́̄̀̄̀̐͗̅̂̎̚C̸̛̱̭̣͙̠̀̑̾̉͜K̷̼̞̼̜̖͎̞͙̫̣͛̅̑̀̅̓̐͝ ̸̨̡̱̩̜͈͍͇̗͈̠̜̞̩̭̋̉́̇F̷̫̯̼̮̫͓͑̀̅̿͂̈́̇̄̚͠L̵̢̧̼̞͇̼͍̥̜̼̪̔͐̈́̓̽͒̀̑̄A̴̧̧̨̢̠͎͇̱̻̿̔͐̆̽̔̄̽S̸̡͙̗̙̲̜̫͎͔̊͗̀͛͆̈́̌̋̓̌̕͝͝ͅH̸͈̟̄́̿̒̑̽͛̔̇̂"
        BackFlash.CanBeDropped = false
        BackFlash.RequiresHandle = false
        BackFlash.ToolTip = "D̶̡̡̨̡̰͚̭̥̦̘̯̈́̀̓͑͑̌̎̑͌̈́̈́̀̕͘E̴̜̘̫̖̖͍̟̪̻̥͎̩̾̒͐̆̄̏̉̎Ţ̸̡̗̟̘̭̃̔̓̓͌͂̈́̔̍͌̄̇̍͘É̷̩̼̼̱̜̗̠͉̤̘̓̋͗̿̾̏͛͗͒̑̌̽͠͠R̸̢̜̬͔̞̟͚̤̣̬̔͋̈́̄̏̄͑̉̊̌̈̍̚ͅM̸̨̱̹̱͉̘̰͕͕̦̯̐̃̑̃͆̀̏̓̕͜͝I̵̻͈̯̟͕̞̩̞̓̒̆͋͐̋̿̓̈́͝͝͝Ņ̷͚̻̩̦̭̙͊̆͑̊̒̅̎͘A̵̻̤͎̪̥͙̅̏̓̎͛͊͋̅̾͆̇̕T̵̡͙̺̗̼̬̯̦͓̹̜͓̫̂I̸̛͚̠̲̬̭̯͙͓͂̑͋̍̌̓̃̏̑̑̿̕͝Ở̷̳̪̙́͝Ň̶̯͎͇̙̪͚͌͠"
        BackFlash.Parent = LocalPlayer.Backpack
        BackFlash.Activated:Connect(function()
            if SlapCooldown == false then
                SlapCooldown = true
                local GCP = GetClosestPlayer()
                local Ping = LocalPlayer:GetNetworkPing()
                local Support = Instance.new("BodyGyro", LocalPlayer.Character.HumanoidRootPart)
                Debris:AddItem(Support, 5)
                LocalPlayer.Character.HumanoidRootPart.CFrame = GCP.Character.HumanoidRootPart.CFrame
                LocalPlayer.Character:MoveTo(GCP.Character.HumanoidRootPart.Position+GCP.Character.HumanoidRootPart.CFrame.LookVector*-3+GCP.Character.HumanoidRootPart.AssemblyLinearVelocity*0.1)
                wait(Ping)
                LocalPlayer.Character.Humanoid:LoadAnimation(Slap):Play()
                for i, v in ipairs(LocalPlayer.Character.Humanoid:GetPlayingAnimationTracks()) do
                    if v.Name == "slap_anim" then
                        v:AdjustSpeed((LocalPlayer.Character.Humanoid.WalkSpeed/40)*5)
                    end
                end
                wait()
                Equip("Charge", true)
                GeneralHit:FireServer(GCP.Character.HumanoidRootPart)
                print("hit")
                task.wait(SlapDelay)
                SlapCooldown = false
            end
        end)

        local Rewind = Instance.new("Tool")
        Rewind.Name = "R̶̨̖̲̟̻͖̠̰̹͓̀̔̾͛̔̚̕Ẻ̸̬̲͔̰͕̗͇̣̜̣̬̭̖̈̎͆̀̔́̂̐̓̓̈̌̅͝W̴̨̡̢̡̫̳̻̳̯̪̩̳̭͙͒̋̓̊̈́̈́̇̋̕I̶̡̧̧͚̜͎̣̻̱̳̠͈̱͐̍̂̎̆͗̋̕̕̚͝N̷̡͚͙͚̟͍͓͉͓̗͙̹̅͋̒̚͘ͅḐ̵̢̡̛̻͎̞͓̯̬͈͓̙̝̩͐̌̐̈̊͑̿̅͆̚"
        Rewind.CanBeDropped = false
        Rewind.RequiresHandle = false
        Rewind.ToolTip = "D̶̡̡̨̡̰͚̭̥̦̘̯̈́̀̓͑͑̌̎̑͌̈́̈́̀̕͘E̴̜̘̫̖̖͍̟̪̻̥͎̩̾̒͐̆̄̏̉̎Ţ̸̡̗̟̘̭̃̔̓̓͌͂̈́̔̍͌̄̇̍͘É̷̩̼̼̱̜̗̠͉̤̘̓̋͗̿̾̏͛͗͒̑̌̽͠͠R̸̢̜̬͔̞̟͚̤̣̬̔͋̈́̄̏̄͑̉̊̌̈̍̚ͅM̸̨̱̹̱͉̘̰͕͕̦̯̐̃̑̃͆̀̏̓̕͜͝I̵̻͈̯̟͕̞̩̞̓̒̆͋͐̋̿̓̈́͝͝͝Ņ̷͚̻̩̦̭̙͊̆͑̊̒̅̎͘A̵̻̤͎̪̥͙̅̏̓̎͛͊͋̅̾͆̇̕T̵̡͙̺̗̼̬̯̦͓̹̜͓̫̂I̸̛͚̠̲̬̭̯͙͓͂̑͋̍̌̓̃̏̑̑̿̕͝Ở̷̳̪̙́͝Ň̶̯͎͇̙̪͚͌͠"
        Rewind.Parent = LocalPlayer.Backpack
        Rewind.Activated:Connect(function()
            LocalPlayer.Character:MoveTo(LastPosition)
        end)

        task.spawn(function()
            while task.wait(3) do
                if Rewind:IsDescendantOf(LocalPlayer.Backpack) or Rewind:IsDescendantOf(LocalPlayer.Character) then
                    LastPosition = LocalPlayer.Character.HumanoidRootPart.Position
                    print("Position Saved")
                else
                    print("Loop Broken")
                    break
                end
            end
        end)

        local CursedRush = Instance.new("Tool")
        CursedRush.Name = "C̸̦̣͔͍̮̱̥͈̜͆̈́̈̉͗̈́̋̌̑͐͐͝U̷̢̨̢͕͕̳͓̫͎̙̭͕̩͆̈́͛͝Ŝ̴̛̠͇̤̙̼̘̘͎͓͖͖̿͌̂̇̄̍́̎̀͑̚͜͜Ȩ̶̨̛̣͕̗̭̦̻̘͔̮̝̜̲̤̓͋͂̿̈͗́̋̃D̵͙̭̗͉̮̻̝͙̰̓̀̑́ ̵̨͈̘̥͈̟̝̫̪̅̌̓̋͋̀̿͊Ŗ̵̧͇̰̹͍̫̙̣̲̜̫̼̃̔̄̾́̕͝U̴̺͂̈́͘S̷̻̺͊͒́̑͒̕H̸̪̼͉̼̲̪̝͎̦̬͚̫͐̅̀͒̍̋͝͝"
        CursedRush.CanBeDropped = false
        CursedRush.RequiresHandle = false
        CursedRush.ToolTip = "D̴̢̘̩̱̼͎̭̰͉͐́̾̏̐̎ͅE̴͍̳̥̩̘̞͖̻̭̦̖̹͊Ṭ̸̨͚̘̭̹̞̹͊̈́͂̈́͂́̅͋͆̇͐̓͠Ė̸͎͙͖̮̬̘R̷̛̛͍̫̙̻͔̈́͛̏͊͠M̷̨̗̤̗̳̥͙͇̱̓̿̂̃͗̿́̊̈́̈́̚͝I̶̖̜͇̯̦͇̼͈̠̦̤̗̲͆́̂N̶̗̰̬͖̼̦̬̱͙̝̆̏À̴͓̤̟͇̜͍͓̠́͒̉͒̌͂̋͐̀͋̚͝͝͠T̴̢̩̤̼̟̹̩̬̥͚̟̓͝I̶̡̼̪̤̰͎̳̲͑͑̿͛Ǫ̴̰̩̞̣̭̗̜͓̏̑̉Ǹ̴̛̰̰̀̔͋̽̾̽̂̂̇̌͝"
        CursedRush.Parent = LocalPlayer.Backpack
        CursedRush.Activated:Connect(function()
            if RushState == false then
                RushState = true
                SlapCooldown = true
                SpeedVariable = 80
                local Support1 = Instance.new("BodyGyro", LocalPlayer.Character.HumanoidRootPart)
                local Support2 = Instance.new("Part", LocalPlayer.Character)
                Debris:AddItem(Support1, 11)
                Debris:AddItem(Support2, 11)
                Support2.Transparency = 0.5
                Support2.Anchored = true
                Support2.Size = Vector3.new(40, 4, 40)
                for i, v in ipairs(LocalPlayer.Character:GetChildren()) do
                    if v:IsA("Part") then
                        v.CustomPhysicalProperties = PhysicalProperties.new(10, 0.3, 0.5)
                    end
                end
                task.spawn(function()
                    local p = LocalPlayer.Character.HumanoidRootPart.Position
                    local Y = p.Y-5
                    for i = 1, 100 do
                        local P = LocalPlayer.Character.HumanoidRootPart.Position
                        Support2.Position = Vector3.new(P.X, Y, P.Z)
                        task.wait(0.1)
                    end
                end)
                task.spawn(function()
                    for i = 1, 100 do
                        SpeedVariable += 1
                        workspace.CurrentCamera.FieldOfView = SpeedVariable
                        task.wait(0.1)
                    end
                end)
                task.spawn(function()
                    for i = 1, 18 do
                        local GCP = GetClosestPlayer()
                        Equip("Charge", true)
                        GeneralHit:FireServer(GCP.Character.Head)
                        task.wait(0.58)
                    end
                end)
                task.spawn(function()
                    for i = 1, 4 do
                        workspace.CharaFolder.CharaScream:Play()
                        task.wait(3)
                    end
                end)
                for i, v in ipairs(LocalPlayer.Character:GetChildren()) do
                    if v:IsA("Part") then
                        v.CustomPhysicalProperties = PhysicalProperties.new(0.7, 0.3, 0.5)
                    end
                end
                task.wait(10)
                workspace.CharaFolder.CharaScream:Stop()
                workspace.CurrentCamera.FieldOfView = 70
                SpeedVariable = 70
                task.wait(1)
                SlapCooldown = false
                RushState = false
            end
        end)

        local Save = Instance.new("Tool")
        Save.Name = "S̵͇͕̦͈̫͍̯̮͖̤͓̣͖̦̓́͐̌͜A̶̡̡̼̙̓̀̃̀͋̃̑͌̒̐̆̈́̚͜V̷̬̮͖̤̘͉̘̬͈̍̈́ͅȨ̶͖̻̯̥̲̺͙̥͔̬̠͚͉̳̿̓̽͂̀̊͐͂̕͠͠"
        Save.CanBeDropped = false
        Save.RequiresHandle = false
        Save.ToolTip = "D̴̢̘̩̱̼͎̭̰͉͐́̾̏̐̎ͅE̴͍̳̥̩̘̞͖̻̭̦̖̹͊Ṭ̸̨͚̘̭̹̞̹͊̈́͂̈́͂́̅͋͆̇͐̓͠Ė̸͎͙͖̮̬̘R̷̛̛͍̫̙̻͔̈́͛̏͊͠M̷̨̗̤̗̳̥͙͇̱̓̿̂̃͗̿́̊̈́̈́̚͝I̶̖̜͇̯̦͇̼͈̠̦̤̗̲͆́̂N̶̗̰̬͖̼̦̬̱͙̝̆̏À̴͓̤̟͇̜͍͓̠́͒̉͒̌͂̋͐̀͋̚͝͝͠T̴̢̩̤̼̟̹̩̬̥͚̟̓͝I̶̡̼̪̤̰͎̳̲͑͑̿͛Ǫ̴̰̩̞̣̭̗̜͓̏̑̉Ǹ̴̛̰̰̀̔͋̽̾̽̂̂̇̌͝"
        Save.Parent = LocalPlayer.Backpack
        Save.Activated:Connect(function()
            CreateSave(true)
        end)

        local GiveUp = Instance.new("Tool")
        GiveUp.Name = "GIVE UP =)"
        GiveUp.CanBeDropped = false
        GiveUp.RequiresHandle = false
        GiveUp.ToolTip = "..."
        GiveUp.Parent = LocalPlayer.Backpack
        GiveUp.Activated:Connect(function()
            GiveUp:Destroy()
            SetTools3()
        end)
    end

    local function SetTools()
        SpeedVariable = 40
        SlapDelay = 0.5
        local Slash = Instance.new("Tool")
        Slash.Name = "Slash"
        Slash.CanBeDropped = false
        Slash.RequiresHandle = false
        Slash.ToolTip = "=)"
        Slash.Parent = LocalPlayer.Backpack
        Slash.Activated:Connect(function()
            if SlapCooldown == false then
                SlapCooldown = true
                LocalPlayer.Character.Humanoid:LoadAnimation(Slap):Play()
                for i, v in ipairs(LocalPlayer.Character.Humanoid:GetPlayingAnimationTracks()) do
                    if v.Name == "slap_anim" then
                        v:AdjustSpeed((LocalPlayer.Character.Humanoid.WalkSpeed/40)*5)
                    end
                end
                local GCP = GetClosestPlayer()
                Equip("Diamond", false)
                wait()
                DiamondHit:FireServer(GCP.Character.HumanoidRootPart)
                print("hit")
                task.wait(SlapDelay)
                SlapCooldown = false
            end
        end)

        local UltraSlash = Instance.new("Tool")
        UltraSlash.Name = "Ultra Slash"
        UltraSlash.CanBeDropped = false
        UltraSlash.RequiresHandle = false
        UltraSlash.ToolTip = "=)"
        UltraSlash.Parent = LocalPlayer.Backpack
        UltraSlash.Activated:Connect(function()
            if SlapCooldown == false then
                SlapCooldown = true
                LocalPlayer.Character.Humanoid:LoadAnimation(Slap):Play()
                for i, v in ipairs(LocalPlayer.Character.Humanoid:GetPlayingAnimationTracks()) do
                    if v.Name == "slap_anim" then
                        v:AdjustSpeed((LocalPlayer.Character.Humanoid.WalkSpeed/40)*2)
                    end
                end
                local GCP = GetClosestPlayer()
                Equip("Charge", true)
                task.wait(0.1*2.5)
                GeneralHit:FireServer(GCP.Character.HumanoidRootPart)
                print("hit")
                task.wait(SlapDelay)
                SlapCooldown = false
            end
        end)

        local Dash = Instance.new("Tool")
        Dash.Name = "Dash"
        Dash.CanBeDropped = false
        Dash.RequiresHandle = false
        Dash.ToolTip = "=)"
        Dash.Parent = LocalPlayer.Backpack
        Dash.Activated:Connect(function()
            if SlapCooldown == false then
                SlapCooldown = true
                local Support = Instance.new("BodyGyro", LocalPlayer.Character.HumanoidRootPart)
                Debris:AddItem(Support, 5)
                LocalPlayer.Character.Humanoid:LoadAnimation(workspace.CharaFolder.DashAnimation):Play()
                for i, v in ipairs(LocalPlayer.Character.Humanoid:GetPlayingAnimationTracks()) do
                    if v.Name == "DashAnimation" then
                        v:AdjustSpeed((LocalPlayer.Character.Humanoid.WalkSpeed/40)*2)
                    end
                end
                task.spawn(function()
                    for i = 1, 25 do
                        --local LV = LocalPlayer.Character.Head.CFrame.LookVector*1000
                        local CameraLook = Vector3.new(workspace.CurrentCamera.CFrame.LookVector.X, 0, workspace.CurrentCamera.CFrame.LookVector.Z)
                        local LV = ((LocalPlayer.Character.Head.CFrame.LookVector+CameraLook)/2)*1000
                        local Result = LocalPlayer.Character.Torso.AssemblyLinearVelocity + LV
                        local Cap = (LocalPlayer.Character.Humanoid.WalkSpeed/20)*64
                        --Slapstick:FireServer("fullcharged")
                        LocalPlayer.Character.Torso.AssemblyLinearVelocity = Vector3.new(math.clamp(Result.X, -Cap, Cap), math.clamp(Result.Y, 2, 16), math.clamp(Result.Z, -Cap, Cap))
                        task.wait(0.02)
                    end
                end)
                task.wait(0.02)
                local GCP = GetClosestPlayer()
                wait()
                DiamondHit:FireServer(GCP.Character.HumanoidRootPart)
                GeneralHit:FireServer(GCP.Character.HumanoidRootPart)
                print("hit")
                task.wait(SlapDelay)
                SlapCooldown = false
            end
        end)

        local Save = Instance.new("Tool")
        Save.Name = "Save"
        Save.CanBeDropped = false
        Save.RequiresHandle = false
        Save.ToolTip = "=)"
        Save.Parent = LocalPlayer.Backpack
        Save.Activated:Connect(function()
            CreateSave(false)
        end)

        local Awaken = Instance.new("Tool")
        Awaken.Name = "À̴̤̹̙̝̠̂͋͗́͗W̷̛̺̘̳̞͍̤͖̞̼̱͚̮̿̌͋͒͝A̵̞̿K̵̢̡̡̛͎̝̜̭̝̗̻̯̺̣͉̔͜͠E̷̢̲̺̯̺͓͕̻̟̗̬̩͓̐͋̉̑̌͂̒͛͑̀̈̍͘͝Ņ̸͍̤͔̞̟̹̭̖̂́̈́̏̈́̀͠"
        Awaken.CanBeDropped = false
        Awaken.RequiresHandle = false
        Awaken.ToolTip = "Ḡ̴͓̼͓̉̓̽̆́̀͑̈́̑͐́̓͜I̵̼̘̙̥͉͍̻͂̓V̷͍͍͖̟̠̤̻̖̱̊́͂̋̊̕E̷̘̥̙̫̍̌̌́̓̌̋ ̸̛̠͕̞̞͕̳̠̼̣͗̉̃̈́͂̓̓̈́̈̈́̂͜͝M̴̨̛͙̙̟̤͕̳̠̞̭̏̒̅̉͗́̇͆͠ͅͅȨ̵͙̠̖͇̈́͘̕͜ ̵̣̯̿̀̍̔̑͛͊̅͐̓́̉͠͠C̸͖̱̗͎̭̬͚͇̳͚̹͌͋̎͘͜͜Ơ̵̛͙̒̄̿̏̔̃́̄͘͠͝Ǹ̵̢̰̹̘̝̼͒̀̎̾T̷̡̩̗͚͎͛́̃͋͒̓̊́͆̂̄̏͑͠͠R̸̢̢̛̬͔͎̝̘͙̟̻̪͚͇̫̈́̇͆̓̿̂͛̀̒͘͠O̴͇͈̳̜͓͖̮̻̗̒͒̽̋̒̃͆̽̐L̸̙̘̇̍͌̎̋̕̚̚͜"
        Awaken.Parent = LocalPlayer.Backpack
        Awaken.Activated:Connect(function()
            if LocalPlayer.leaderstats.Slaps.Value < 15 then
                StarterGui:SetCore("SendNotification", {
                    Title = "Not Enough Slaps",
                    Text = "C̷̞̩͉̳̠̙̳̈́̽͜͝O̵̢̯͈͚̺̖̫̪̣̞̜͑̑̃͒̾̄͌͛̎͑́́̚͝L̶̺̐̎̔̿͌̒̍̋͊̍͘͠͝͝L̸͙̭̻̈̓̇̀̈́̇͑̈̒̿Ė̵̛̦͖̲̬̘̥̫̲͙͕͑̽ͅC̶̘̣͍̰̗͖̘͇̎́̄̀T̵̪̭̰͎̥̘͉͕̖̻̟͖͈̄̔̾͋͗̃̆̇̄͛̃͗̈́͘ͅ ̶̺̝̰͉̻̯̻̞̺̗̓̄̐̋͊͋̎͆͐͛͛͘͝M̸̖̹͈̮͔̫̓̃̊̍ͅO̶̮̪̯̜̯̫͉͗̑͋̊͐̂Ȓ̷̡̡̡͉̝̟̥͖͖̯̦̈́͒̎̈̇̌̕͘̕͜͜͠͝E̵͙̬͉̣̣̥̥̬̩͖̖̤͈̊̈͂̐́͐̒͛̊̊ ̵̢̻̮͇͈͈̩̟̦͕̀̔̂́̓͒͗ͅṠ̴̼̼͍͚̘̈̄̍͆̂̊O̸̡̖̤̿̋̃̏͛̓̀̐́̊͒͗̓̎͠Ù̶̢̡͍̦͔̭̝̼̦̺̬̘̫̌̂̄̂̍̍̄̍͐̅̆͂̇̄L̵̢̤͍̒̄͆̈́̒͐́́́͌̕Ş̷̜̤͍͉̣̖̩̦͔̼͉͕̼̉"
                })
            else
                Awaken:Destroy()
                SetTools2()
            end
        end)
    end

    local function MakeRoom()
        local Teleporter = workspace.Lobby.Teleport3:Clone()
        local TeleporterFrame = workspace.Lobby.Teleport3Frame:Clone()

        for i, v in ipairs(workspace:GetChildren()) do if v.Name == "CharaFolder" then v:Destroy() end end

        local CharaFolder = Instance.new("Folder", workspace)
        CharaFolder.Name = "CharaFolder"
        Teleporter.Parent = CharaFolder
        TeleporterFrame.Parent = CharaFolder
        Teleporter.Position += Vector3.new(14, 0, 0)
        TeleporterFrame.Position += Vector3.new(14, 0, 0)
        Teleporter.Color = Color3.fromRGB(0, 0, 0)
        Teleporter.Highlight.OutlineColor = Color3.fromRGB(248, 16, 16)
        Teleporter.BillboardGui.TextLabel.Text = "    CHARA    "
        Teleporter.Touched:Connect(function(Part)
            if Part.Name == "HumanoidRootPart" then
                Part.CFrame = CFrame.new(Vector3.new(0, 10000+2+3, 0))
            end
        end)

        local Run = Instance.new("Animation", CharaFolder)
        Run.Name = "CharaRun"
        Run.AnimationId = "rbxassetid://74136465823078"

        local DashAnimation = Instance.new("Animation", CharaFolder)
        DashAnimation.Name = "DashAnimation"
        DashAnimation.AnimationId = "rbxassetid://15436359788"

        local Scream = Instance.new("Sound", CharaFolder)
        Scream.Name = "CharaScream"
        Scream.SoundId = "rbxassetid://121645935959827"
        Scream.Volume = 3

        local Slash = Instance.new("Sound", CharaFolder)
        Slash.Name = "CharaSlash"
        Slash.SoundId = "rbxassetid://18955378309"
        Slash.Volume = 3

        local CharaRun3 = Instance.new("Animation", CharaFolder)
        CharaRun3.Name = "CharaRun3"
        CharaRun3.AnimationId = "rbxassetid://15775758181"

        local Invade = Instance.new("Animation", CharaFolder)
        Invade.Name = "Invade"
        Invade.AnimationId = "rbxassetid://13675136513"

        local Floor = Instance.new("Part", CharaFolder)
        Floor.Anchored = true
        Floor.Position = Vector3.new(0, 10000, 0)
        Floor.Color = Color3.fromRGB(0, 0, 0)
        Floor.Size = Vector3.new(1024, 4, 1024)
        Floor.Material = Enum.Material.Neon
        local Wall1 = Instance.new("Part", CharaFolder)
        Wall1.Anchored = true
        Wall1.Position = Vector3.new(512, 10000, 0)
        Wall1.Color = Color3.fromRGB(0, 0, 0)
        Wall1.Size = Vector3.new(4, 1024, 1024)
        Wall1.Material = Enum.Material.Neon
        local Wall2 = Instance.new("Part", CharaFolder)
        Wall2.Anchored = true
        Wall2.Position = Vector3.new(-512, 10000, 0)
        Wall2.Color = Color3.fromRGB(0, 0, 0)
        Wall2.Size = Vector3.new(4, 1024, 1024)
        Wall2.Material = Enum.Material.Neon
        local Wall3 = Instance.new("Part", CharaFolder)
        Wall3.Anchored = true
        Wall3.Position = Vector3.new(0, 10000, 512)
        Wall3.Color = Color3.fromRGB(0, 0, 0)
        Wall3.Size = Vector3.new(1024, 1024, 4)
        Wall3.Material = Enum.Material.Neon
        local Wall4 = Instance.new("Part", CharaFolder)
        Wall4.Anchored = true
        Wall4.Position = Vector3.new(0, 10000, -512)
        Wall4.Color = Color3.fromRGB(0, 0, 0)
        Wall4.Size = Vector3.new(1024, 1024, 4)
        Wall4.Material = Enum.Material.Neon
        local Ceiling = Instance.new("Part", CharaFolder)
        Ceiling.Anchored = true
        Ceiling.Position = Vector3.new(0, 10200, 0)
        Ceiling.Color = Color3.fromRGB(0, 0, 0)
        Ceiling.Size = Vector3.new(1024, 4, 1024)
        Ceiling.Material = Enum.Material.Neon

        local ParticleEmitter = Instance.new("ParticleEmitter", Floor)
        ParticleEmitter.Brightness = 1
        ParticleEmitter.LightEmission = 0.5
        ParticleEmitter.LightInfluence = 0.5
        ParticleEmitter.Size = NumberSequence.new(0.09, 0.09)
        ParticleEmitter.Acceleration = Vector3.new(0, 1, 0)
        ParticleEmitter.Lifetime = NumberRange.new(150, 200)
        ParticleEmitter.Rate = 100
        ParticleEmitter.Texture = "rbxassetid://109572108885014"
        ParticleEmitter.Speed = NumberRange.new(2, 2)

        local KnifeStand = Instance.new("Part", CharaFolder)
        KnifeStand.Anchored = true
        KnifeStand.Position = Vector3.new(0, 10000, -100)
        KnifeStand.Size = Vector3.new(4, 10, 4)
        KnifeStand.Material = Enum.Material.SmoothPlastic
        KnifeStand.Color = Color3.fromRGB(255, 255, 255)
        KnifeStand.Touched:Connect(function(Part)
            if Part.Name == "HumanoidRootPart" then
                KnifeStand.CanTouch = false
                SlapDelay = 0.5
                local Standing = LocalPlayer.Character.Humanoid:LoadAnimation(Idle)
                local Moving = LocalPlayer.Character.Humanoid:LoadAnimation(Run)
                local Moving3 = LocalPlayer.Character.Humanoid:LoadAnimation(CharaRun3)
                local PastSave = CharaFolder:FindFirstChild("Save")
                GiveKnife()
                SetTools()
                if PastSave then
                    Part.CFrame = PastSave.CFrame
                else
                    Part.CFrame = CFrame.new(0, 0, 0)
                end
                task.wait(1)
                KnifeStand.CanTouch = true
                task.spawn(function()
                    while task.wait(0.1) do
                        if Part.Parent.Humanoid.Health < 0.1 then
                            print("Loop Break")
                            break
                        elseif Part.Position.Y < -20 and CharaFolder:FindFirstChild("Save") then
                            Part.CFrame = CharaFolder:FindFirstChild("Save").CFrame
                            Part.AssemblyLinearVelocity = Vector3.zero
                            Part.AssemblyAngularVelocity = Vector3.zero
                            CharaFolder:FindFirstChild("Save").SaveSFX:Play()
                        end
                    end
                end)
                LocalPlayer.Character.Humanoid:GetPropertyChangedSignal("MoveDirection"):Connect(function()
                    if LocalPlayer.Character.Humanoid.MoveDirection == Vector3.zero then
                        Moving:Stop()
                        Moving3:Stop()
                        Standing:Play()
                    else
                        Standing:Stop()
                        if Moving.IsPlaying == false and Moving3.IsPlaying == false then
                            if Run.Name == "CharaRun" then
                                Moving:Play()
                            else
                                Moving3:Play()
                            end
                        end
                        for i, v in ipairs(LocalPlayer.Character.Humanoid:GetPlayingAnimationTracks()) do
                            if v.Name == "IceSkate" or v.Name == "UTG_Run" or v.Name == "CharaRun" or v.Name == "CharaRun3" then
                                v:AdjustSpeed((LocalPlayer.Character.Humanoid.WalkSpeed/40)*2)
                            end
                        end
                        LocalPlayer.Character.Humanoid.WalkSpeed = SpeedVariable
                    end
                end)
            end
        end)

        local KnifeStandCover = Instance.new("Part", CharaFolder)
        KnifeStandCover.Anchored = true
        KnifeStandCover.Position = Vector3.new(0, 10000, -100)
        KnifeStandCover.Size = Vector3.new(4.1, 10, 4.1)
        KnifeStandCover.Material = Enum.Material.SmoothPlastic
        KnifeStandCover.Color = Color3.fromRGB(255, 255, 255)

        local KnifeParticles = Instance.new("ParticleEmitter", KnifeStand)
        KnifeParticles.Brightness = 1
        KnifeParticles.LightEmission = 0.5
        KnifeParticles.LightInfluence = 0.5
        KnifeParticles.Speed = NumberRange.new(1, 1)
        KnifeParticles.Size = NumberSequence.new(1, 1)
        KnifeParticles.Squash = NumberSequence.new(30, 30)
        KnifeParticles.Acceleration = Vector3.new(0, 1, 0)
        KnifeParticles.Lifetime = NumberRange.new(25, 25)
        KnifeParticles.Transparency = NumberSequence.new(0, 0.25)
        KnifeParticles.Color = ColorSequence.new(Color3.new(1, 0, 0), Color3.new(0, 0, 0))
        KnifeParticles.Rate = 25
        KnifeParticles.Speed = NumberRange.new(1, 1)
        KnifeParticles.Orientation = Enum.ParticleOrientation.FacingCameraWorldUp

        local DisplayKnife = Instance.new("Part", KnifeStand)
        local DisplayKnifeMesh = Instance.new("SpecialMesh", DisplayKnife)
        local DisplayKnifeLight = Instance.new("PointLight", DisplayKnife)
        DisplayKnife.Name = "RealKnife"
        DisplayKnife.Anchored = true
        DisplayKnife.Orientation = Vector3.new(0, 0, 90)
        DisplayKnife.Position = KnifeStand.Position + Vector3.new(0, 5.1, 0)
        DisplayKnife.Size = Vector3.new(0.5, 3.5, 2)
        DisplayKnife.Material = Enum.Material.DiamondPlate
        DisplayKnifeMesh.MeshId = "rbxassetid://121944778"
        DisplayKnifeMesh.TextureId = "rbxassetid://362719969"
        DisplayKnifeLight.Shadows = true
        DisplayKnifeLight.Range = 10
        DisplayKnifeLight.Brightness = 2
        DisplayKnifeLight.Color = Color3.new(1, 0.75, 0.75)
    end

    MakeRoom()
    print("=)")
