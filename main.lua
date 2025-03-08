-- Capybara Otomatik Script Enjektörü
-- Bu script, oyun ID'sine göre uygun scripti otomatik olarak enjekte eder

-- Servisler
local Players = game:GetService("Players")
local HttpService = game:GetService("HttpService")

-- Değişkenler
local player = Players.LocalPlayer
local gameId = game.PlaceId
local githubUser = "Fertinal"
local githubRepo = "Fertinal-Hub"
local githubBranch = "main"

-- Bildirim fonksiyonu
local function notify(title, text, duration)
    duration = duration or 5
    game:GetService("StarterGui"):SetCore("SendNotification", {
        Title = title,
        Text = text,
        Duration = duration
    })
end

-- Script yükleme fonksiyonu
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

-- GitHub API'den dosya listesini çekme fonksiyonu
local function getGitHubFiles()
    local apiUrl = "https://api.github.com/repos/" .. githubUser .. "/" .. githubRepo .. "/contents?ref=" .. githubBranch
    
    local success, result = pcall(function()
        return HttpService:JSONDecode(game:HttpGet(apiUrl))
    end)
    
    if success then
        return result
    else
        notify("Capybara Enjektör", "GitHub dosya listesi alınamadı: " .. tostring(result), 5)
        return {}
    end
end

-- Oyun ID'sine göre script adını bulma fonksiyonu
local function findScriptForGame(gameIdStr)
    -- GitHub'dan dosya listesini çek
    local files = getGitHubFiles()
    
    -- Dosya listesinde oyun ID'sine uygun script ara
    for _, file in ipairs(files) do
        if file.type == "file" and file.name:match("^" .. gameIdStr .. "_.+%.lua$") then
            return file.name, file.download_url
        end
    end
    
    -- Özel durum: Belirtilen oyun ID'si için script yoksa, genel script ara
    for _, file in ipairs(files) do
        if file.type == "file" and file.name == "capybaraevolution.lua" then
            return file.name, file.download_url
        end
    end
    
    return nil, nil
end

-- Ana fonksiyon
local function main()
    notify("Fertinal Hub", "Oyun kontrol ediliyor...", 3)
    
    -- Oyun ID'sini string'e çevir
    local gameIdStr = tostring(gameId)
    
    -- Oyun ID'sine göre script adını ve URL'ini bul
    local scriptName, scriptUrl = findScriptForGame(gameIdStr)
    
    if scriptName and scriptUrl then
        notify("Fertinal Hub", "Uyumlu script bulundu: " .. scriptName, 3)
        
        -- Scripti yükle
        notify("Fertinal Hub", "Script yükleniyor...", 3)
        loadScript(scriptUrl)
    else
        -- Özel durum: Belirtilen oyun ID'si için script yoksa, GitHub'dan capybararemake.lua'yı yükle
        if gameIdStr == "134257874794717" then
            notify("Fertinal Hub", "Özel script aranıyor...", 3)
            
            -- GitHub'dan capybararemake.lua'yı yükle
            local capybaraUrl = "https://raw.githubusercontent.com/" .. githubUser .. "/" .. githubRepo .. "/" .. githubBranch .. "/capybaraevolution.lua"
            loadScript(capybaraUrl)
        else
            notify("Fertinal Hub", "Bu oyun için uyumlu script bulunamadı!", 5)
        end
    end
end

-- Scripti çalıştır
main() 
