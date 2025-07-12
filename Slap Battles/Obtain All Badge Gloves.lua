repeat
    wait()
until game:IsLoaded()
wait(0.3)

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Args = {"Bomb", "Bubble", "CULT", "Chain", "Detonator", "Disarm", "Dominance", "Hybrid", "Jet", "Jupiter", "Link", "MEGAROCK", "Mitten", "Moon", "Phase", "Plague", "Rage", "Shard", "Slapple", "Spy", "Trap", "Warp", "[REDACTED]", "bob", "buddies", "bus", "Hallow Jack", "Rattlebones", "Charge", "Tycoon", "Confusion", "Glitch", "Snowball", "Elude", "RNG", "fish", "🗿", "Obby", "Voodoo", "Goofy", "Leash", "Flamarang", "Kinetic", "Berserk", "Sparky", "Boogie", "Recall", "Quake", "Psycho", "Kraken", "Counter", "Hammer", "rob", "Rhythm", "Rojo", "Hitman", "Retro", "Null", "Lure", "Tinkerer", "Necromancer", "Alchemist", "Druid", "Jester", "Scythe", "Santa", "Iceskate", "Blasphemy", "Pan", "Admin", "Joust", "Firework", "Run", "Glovel", "Divebomb", "Lamp", "Knockoff", "Frostbite", "Plank", "Spoonful", "the schlob", "Siphon", "Wrench", "Hunter", "Relude", "Avatar", "Water", "Fan", "Boxer", "MATERIALIZE", "Bind", "Poltergeist", "MeshPart", "Clock", "Untitled Tag Glove", "Pillow", "Angler", "Jerry", "Snowroller", "Draw4", "Mouse", "Hexa", "Metaverse", "Swordfighter", "Tank", "Eggler", "Slender", "Swashbuckler", "Silly", "Slasher", "potato", "Car Keys", "Suction"}

for i, v in ipairs(ReplicatedStorage:GetDescendants()) do
    if v:IsA("RemoteEvent") and string.match(v.Name, "{") then
        for a, b in ipairs(Args) do
            v:FireServer(b)
        end
    end
end
