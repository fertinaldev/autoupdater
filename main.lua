

local Players = game:GetService("Players")
local HttpService = game:GetService("HttpService")


local player = Players.LocalPlayer
local gameId = game.PlaceId
local githubUser = "Fertinal"
local githubRepo = "Fertinal-Hub"
local githubBranch = "main"


local function notify(title, text, duration)
    duration = duration or 5
    game:GetService("StarterGui"):SetCore("SendNotification", {
        Title = title,
        Text = text,
        Duration = duration
    })
end


local function loadScript(scriptUrl)
    local success, result = pcall(function()
        return loadstring(game:HttpGet(scriptUrl))()
    end)
    
    if success then
        notify("Fertinal Hub", "Script başarıyla yüklendi!", 5)
        return true
    else
        notify("Fertinal Hub", "Script yüklenirken hata: " .. tostring(result), 5)
        return false
    end
end


local function getGitHubFiles()
    local apiUrl = "https://api.github.com/repos/" .. githubUser .. "/" .. githubRepo .. "/contents?ref=" .. githubBranch
    
    local success, result = pcall(function()
        return HttpService:JSONDecode(game:HttpGet(apiUrl))
    end)
    
    if success then
        return result
    else
        notify("Fertinal Hub", "GitHub dosya listesi alınamadı: " .. tostring(result), 5)
        return {}
    end
end

local function findScriptForGame(gameIdStr)

    local files = getGitHubFiles()
    
 
    for _, file in ipairs(files) do
        if file.type == "file" and file.name:match("^" .. gameIdStr .. "_.+%.lua$") then
            return file.name, file.download_url
        end
    end
    
    
    for _, file in ipairs(files) do
        if file.type == "file" and file.name == "capybaraevolution.lua" then
            return file.name, file.download_url
        end
    end
    
    return nil, nil
end


local function main()
    notify("Fertinal Hub", "Oyun kontrol ediliyor...", 3)
    
    
    local gameIdStr = tostring(gameId)
    
   
    local scriptName, scriptUrl = findScriptForGame(gameIdStr)
    
    if scriptName and scriptUrl then
        notify("Fertinal Hub", "Uyumlu script bulundu: " .. scriptName, 3)
        
       
        notify("Fertinal Hub", "Script yükleniyor...", 3)
        loadScript(scriptUrl)
    else
       
        if gameIdStr == "134257874794717" then
            notify("Fertinal Hub", "Özel script aranıyor...", 3)
            
           
            local capybaraUrl = "https://raw.githubusercontent.com/fertinaldev/autoupdater/refs/heads/main/134257874794717_capybaraevolution.lua"
            loadScript(capybaraUrl)
        else
            notify("Fertinal Hub", "Bu oyun için uyumlu script bulunamadı!", 5)
        end
    end
end


main() 
