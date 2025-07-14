repeat
    task.wait()
until game:IsLoaded()
task.wait(0.1)

if game.PlaceId == 6403373529 then
    if game:GetService("Players").LocalPlayer.leaderstats.Slaps.Value < 15 then
        game:GetService("StarterGui"):SetCore("SendNotification", {Title = "Celerity", Text = "You need atleast 15 slaps to execute The Slap Farm", Duration = 5})
        return
    end
    if getgenv().CeleritySlapFarm then
        print("Already Executed. | Celerity")
        return
    end
    loadstring(game:HttpGet("https://raw.githubusercontent.com/CelerityRBLX/Roblox/refs/heads/main/Slap%20Battles/Slap%20Farm/Regular.lua"))();
    getgenv().CeleritySlapFarm = true
elseif game.PlaceId == 9015014224 then
    if game:GetService("Players").LocalPlayer.leaderstats.Slaps.Value < 15 then
        game:GetService("StarterGui"):SetCore("SendNotification", {Title = "Celerity", Text = "You need atleast 15 slaps to execute The Slap Farm", Duration = 5})
        return
    end
    if getgenv().CeleritySlapFarm then
        print("Already Executed. | Celerity")
        return
    end
    loadstring(game:HttpGet("https://raw.githubusercontent.com/CelerityRBLX/Roblox/refs/heads/main/Slap%20Battles/Slap%20Farm/No%20One%20Shot.lua"))();
    getgenv().CeleritySlapFarm = true
elseif game.PlaceId == 11520107397 then
    if game:GetService("Players").LocalPlayer.leaderstats.Slaps.Value < 15 then
        game:GetService("StarterGui"):SetCore("SendNotification", {Title = "Celerity", Text = "You need atleast 15 slaps to execute The Slap Farm", Duration = 5})
        return
    end
    if getgenv().CeleritySlapFarm then
        print("Already Executed. | Celerity")
        return
    end
    loadstring(game:HttpGet("https://raw.githubusercontent.com/CelerityRBLX/Roblox/refs/heads/main/Slap%20Battles/Slap%20Farm/Killstreak.lua"))();
    getgenv().CeleritySlapFarm = true
elseif game.PlaceId == 124596094333302 then
    if game:GetService("Players").LocalPlayer.leaderstats.Slaps.Value < 15 then
        game:GetService("StarterGui"):SetCore("SendNotification", {Title = "Celerity", Text = "You need atleast 15 slaps to execute The Slap Farm", Duration = 5})
        return
    end
    if getgenv().CeleritySlapFarm then
        print("Already Executed. | Celerity")
        return
    end
    loadstring(game:HttpGet("https://raw.githubusercontent.com/CelerityRBLX/Roblox/refs/heads/main/Slap%20Battles/Slap%20Farm/New%20Players.lua"))();
    getgenv().CeleritySlapFarm = true
else
    game:GetService("StarterGui"):SetCore("SendNotification", {Title = "Celerity", Text = "Invalid PlaceId", Duration = 5})
end
