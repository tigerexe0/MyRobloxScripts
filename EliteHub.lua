local HttpService = game:GetService("HttpService")
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local LocalPlayer = Players.LocalPlayer
local FileName = "EliteData.json"

local function Save(d)
    if writefile then writefile(FileName, HttpService:JSONEncode(d)) end
end

local function Load()
    if isfile and isfile(FileName) then
        return HttpService:JSONDecode(readfile(FileName))
    end
    return {}
end

local Outfits = Load()

local function ApplyFE(t, id)
    local r = ReplicatedStorage:FindFirstChild("RE", true)
    if r then
        pcall(function()
            r:FireServer("CatalogItem", {["Type"] = t, ["ID"] = tonumber(id)})
        end)
    end
end

local function ApplyBody(id, p)
    local c = LocalPlayer.Character
    local h = c and c:FindFirstChildOfClass("Humanoid")
    if h then
        local d = h:GetAppliedDescription()
        pcall(function()
            d[p] = tonumber(id)
            h:ApplyDescription(d)
        end)
    end
end

local Gui = Instance.new("ScreenGui")
Gui.Name = "EH_" .. math.random(100,999)
Gui.Parent = (gethui and gethui()) or game.CoreGui

local Main = Instance.new("Frame", Gui)
Main.Size = UDim2.new(0, 350, 0, 450)
Main.Position = UDim2.new(0.5, -175, 0.5, -225)
Main.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
Main.Active = true
Main.Draggable = true

Instance.new("UICorner", Main).CornerRadius = UDim.new(0, 10)

local Title = Instance.new("TextLabel", Main)
Title.Size = UDim2.new(1, 0, 0, 40)
Title.Text = "ELITE HUB"
Title.TextColor3 = Color3.new(1, 1, 1)
Title.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
Title.Font = Enum.Font.GothamBold

local Scroll = Instance.new("ScrollingFrame", Main)
Scroll.Size = UDim2.new(0.9, 0, 0.4, 0)
Scroll.Position = UDim2.new(0.05, 0, 0.12, 0)
Scroll.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
Scroll.CanvasSize = UDim2.new(0, 0, 10, 0)
Scroll.ScrollBarThickness = 2

Instance.new("UIListLayout", Scroll).Padding = UDim.new(0, 5)

local InName = Instance.new("TextBox", Main)
InName.Size = UDim2.new(0.9, 0, 0, 35)
InName.Position = UDim2.new(0.05, 0, 0.55, 0)
InName.PlaceholderText = "Name"
InName.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
InName.TextColor3 = Color3.new(1,1,1)

local InID = Instance.new("TextBox", Main)
InID.Size = UDim2.new(0.9, 0, 0, 35)
InID.Position = UDim2.new(0.05, 0, 0.65, 0)
InID.PlaceholderText = "Asset ID"
InID.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
InID.TextColor3 = Color3.new(1,1,1)

local SBtn = Instance.new("TextButton", Main)
SBtn.Size = UDim2.new(0.43, 0, 0, 40)
SBtn.Position = UDim2.new(0.05, 0, 0.8, 0)
SBtn.Text = "SAVE"
SBtn.BackgroundColor3 = Color3.fromRGB(0, 150, 70)

local ABtn = Instance.new("TextButton", Main)
ABtn.Size = UDim2.new(0.43, 0, 0, 40)
ABtn.Position = UDim2.new(0.52, 0, 0.8, 0)
ABtn.Text = "APPLY"
ABtn.BackgroundColor3 = Color3.fromRGB(0, 100, 200)

local function Refresh()
    for _, i in pairs(Scroll:GetChildren()) do
        if i:IsA("TextButton") then i:Destroy() end
    end
    for n, d in pairs(Outfits) do
        local b = Instance.new("TextButton", Scroll)
        b.Size = UDim2.new(1, 0, 0, 30)
        b.Text = n
        b.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
        b.TextColor3 = Color3.new(1,1,1)
        b.MouseButton1Click:Connect(function()
            InName.Text = n
            if d.S then ApplyFE("Shirt", d.S) end
            if d.P then ApplyFE("Pants", d.P) end
        end)
    end
end

SBtn.MouseButton1Click:Connect(function()
    if InName.Text ~= "" then
        local c = LocalPlayer.Character
        local s = c:FindFirstChildOfClass("Shirt")
        local p = c:FindFirstChildOfClass("Pants")
        Outfits[InName.Text] = {
            S = s and s.ShirtTemplate:match("%d+") or "",
            P = p and p.PantsTemplate:match("%d+") or ""
        }
        Save(Outfits)
        Refresh()
    end
end)

ABtn.MouseButton1Click:Connect(function()
    local id = tonumber(InID.Text)
    if id then
        ApplyFE("Shirt", id)
        ApplyBody(id, "Torso")
    end
end)

Refresh()
 " .. name
        btn.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
        btn.TextColor3 = Color3.new(1,1,1)
        btn.Font = Enum.Font.Gotham
        Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 6)
        
        btn.MouseButton1Click:Connect(function()
            NameInput.Text = name
            if data.Shirt then ApplyFE("Shirt", data.Shirt) end
            if data.Pants then ApplyFE("Pants", data.Pants) end
        end)
    end
end

-- [ BUTTON EVENTS ]
SaveBtn.MouseButton1Click:Connect(function()
    local name = NameInput.Text
    if name ~= "" then
        local char = LocalPlayer.Character
        local s = char:FindFirstChildOfClass("Shirt")
        local p = char:FindFirstChildOfClass("Pants")
        Outfits[name] = {
            Shirt = s and s.ShirtTemplate:match("%d+") or "",
            Pants = p and p.PantsTemplate:match("%d+") or ""
        }
        SaveData(Outfits)
        RefreshList()
    end
end)

ApplyBtn.MouseButton1Click:Connect(function()
    local id = tonumber(IDInput.Text)
    if id then
        ApplyFE("Shirt", id)
        ApplyBodyFE(id, "Torso") -- Example for Body Part
    end
end)

-- [ INITIALIZE ]
RefreshList()
print("Elite Outfit Script Loaded. Ready for GitHub Hosting.")
