--by 神青 公开此源码
local Players = game:GetService("Players")
local player = Players.LocalPlayer
local petsFolder = player.petsFolder
local rarePets = petsFolder.Rare
local petNameInput = ""
local copyCount = 1
Main:Input({
    Title = "宠物名字",
    Desc = "必须自己拥有的",
    Value = "",
    Placeholder = "例如: Red Dragon",
    Color = Color3.fromRGB(0, 170, 255),
    Callback = function(input)
        petNameInput = input
    end
})

Main:Input({
    Title = "复制次数",
    Desc = "写",
    Value = "1",
    Placeholder = "例如: 5",
    Color = Color3.fromRGB(0, 170, 255),
    Callback = function(input)
        copyCount = tonumber(input) or 1
    end
})

Main:Button({
    Title = "复制宠物",
    Desc = "pet6666",
    Color = Color3.fromRGB(0, 170, 255),
    Callback = function()
        if petNameInput and petNameInput ~= "" then
            local targetPet = rarePets[petNameInput]
            if targetPet then
                for i = 1, copyCount do
                    local petClone = targetPet:Clone()
                    petClone.Parent = rarePets
                    petClone.Name = petNameInput .. " (Copy " .. i .. ")"
                    task.wait(0.1)
                end
            else
           
            end
        else
        end
    end
})