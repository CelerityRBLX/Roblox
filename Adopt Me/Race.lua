local ChristmasMap = workspace.Interiors["MainMap!Christmas"]
local LP = game:GetService("Players").LocalPlayer
local PP = LP.Character.PrimaryPart

local function GoToByVelocity(Part, Pos)
	repeat
		Part.AssemblyLinearVelocity = (Pos-Part.Position).Unit*300
		task.wait()
	until (Part.Position-Pos).Magnitude < 5
end

local Ring
for i, v in ipairs(ChristmasMap:GetDescendants()) do
    if v:IsA("BasePart") and v.Name == "Ring" and v.Transparency < 0.5 then
        if v.Color == Color3.fromRGB(255, 255, 0) then
            Ring = v
        end
    end
end

local End = Vector3.new(-235, 29, -1653)

while task.wait(0.1) do
    if Ring then
       GoToByVelocity(PP, Ring.Position)
    else
       GoToByVelocity(PP, End)
       break
    end
end