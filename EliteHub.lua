--[[
    OUTFIT_ELITE_HUB.lua
    Version: 2.0.1 (2026)
    Developer: Gemini & Expert User
    Function: Advanced FE Outfit Loader & Body Morph
--]]

-- [ CONFIGURATION & SERVICES ]
local Players = game:GetService("Players")
local HttpService = game:GetService("HttpService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local LocalPlayer = Players.LocalPlayer
local FileName = "Elite_Data_Store.json"

-- [ DATA STORAGE SYSTEM ]
local function SaveData(data)
    if writefile then
        writefile(FileName, HttpService:JSONEncode(data))
    end
end

local function LoadData()
    if isfile and isfile(FileName) then
        return HttpService:JSONDecode(readfile(FileName))
    end
    return {}
end

local Outfits = LoadData()

-- [ CORE ENGINES ]
local function ApplyFE(type, id)
    local remote = ReplicatedStorage:FindFirstChild("RE", true) -- Brookhaven Logic
    if remote then
        pcall(function()
            remote:FireServer("CatalogItem", {["Type"] = type, ["ID"] = tonumber(id)})
        end)
    end
end

local function ApplyBodyFE(id, partName)
    local char = LocalPlayer.Character
    local hum = char and char:FindFirstChildOfClass("Humanoid")
    if hum then
        local desc = hum:GetAppliedDescription()
        pcall(function()
            desc[partName] = tonumber(id)
            hum:ApplyDescription(desc)
        end)
    end
end

-- [ UI FRAMEWORK ]
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "EliteHub_UI"
ScreenGui.Parent = (gethui and gethui()) or game.CoreGui

local MainFrame = Instance.new("Frame")
MainFrame.Size = UDim2.new(0, 380, 0, 500)
MainFrame.Position = UDim2.new(0.5, -190, 0.5, -250)
MainFrame.BackgroundColor3 = Color3.fromRGB(18, 18, 18)
MainFrame.BorderSizePixel = 0
MainFrame.Active = true
MainFrame.Draggable = true
MainFrame.Parent = ScreenGui

local UICorner = Instance.new("UICorner", MainFrame)
UICorner.CornerRadius = UDim.new(0, 12)

local Title = Instance.new("TextLabel", MainFrame)
Title.Size = UDim2.new(1, 0, 0, 50)
Title.Text = "ELITE OUTFIT HUB V2"
Title.TextColor3 = Color3.new(1, 1, 1)
Title.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
Title.Font = Enum.Font.GothamBold
Title.TextSize = 18

-- [ SCROLLING LIST ]
local ScrollFrame = Instance.new("ScrollingFrame", MainFrame)
ScrollFrame.Size = UDim2.new(0.9, 0, 0.45, 0)
ScrollFrame.Position = UDim2.new(0.05, 0, 0.12, 0)
ScrollFrame.BackgroundColor3 = Color3.fromRGB(12, 12, 12)
ScrollFrame.CanvasSize = UDim2.new(0, 0, 5, 0)
ScrollFrame.ScrollBarThickness = 3

local UIList = Instance.new("UIListLayout", ScrollFrame)
UIList.Padding = UDim.new(0, 6)

-- [ INPUTS ]
local NameInput = Instance.new("TextBox", MainFrame)
NameInput.Size = UDim2.new(0.9, 0, 0, 40)
NameInput.Position = UDim2.new(0.05, 0, 0.6, 0)
NameInput.PlaceholderText = "Outfit Name..."
NameInput.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
NameInput.TextColor3 = Color3.new(1,1,1)

local IDInput = Instance.new("TextBox", MainFrame)
IDInput.Size = UDim2.new(0.9, 0, 0, 40)
IDInput.Position = UDim2.new(0.05, 0, 0.7, 0)
IDInput.PlaceholderText = "Asset ID (Clothes/Body)..."
IDInput.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
IDInput.TextColor3 = Color3.new(1,1,1)

-- [ ACTION BUTTONS ]
local SaveBtn = Instance.new("TextButton", MainFrame)
SaveBtn.Size = UDim2.new(0.43, 0, 0, 45)
SaveBtn.Position = UDim2.new(0.05, 0, 0.82, 0)
SaveBtn.Text = "SAVE"
SaveBtn.BackgroundColor3 = Color3.fromRGB(46, 204, 113)
SaveBtn.Font = Enum.Font.GothamBold

local ApplyBtn = Instance.new("TextButton", MainFrame)
ApplyBtn.Size = UDim2.new(0.43, 0, 0, 45)
ApplyBtn.Position = UDim2.new(0.52, 0, 0.82, 0)
ApplyBtn.Text = "FORCE FE"
ApplyBtn.BackgroundColor3 = Color3.fromRGB(52, 152, 219)
ApplyBtn.Font = Enum.Font.GothamBold

-- [ REFRESH LOGIC ]
local function RefreshList()
    for _, item in pairs(ScrollFrame:GetChildren()) do
        if item:IsA("TextButton") then item:Destroy() end
    end
    for name, data in pairs(Outfits) do
        local btn = Instance.new("TextButton", ScrollFrame)
        btn.Size = UDim2.new(1, 0, 0, 35)
        btn.Text = " 📦 " .. name
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
