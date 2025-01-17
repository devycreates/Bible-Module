--[[
=======================================================
📖 BibleModule.lua - A Public ROBLOX Bible Tool
=======================================================
Welcome to the BibleModule! 🙏✨ This module allows you 
to fetch Bible verses, passages, and perform advanced 
searches. It’s packed with features, debug tools, and 
customization options for any ROBLOX developer.

🛑 IMPORTANT: Do not edit below the "SETTINGS" section 
unless you're an advanced user.

✨ Features:
- Fetch single verses or passages.
- Multi-translation support.
- Advanced search by multiple criteria.
- Debugging tools for troubleshooting.
- Fully customizable with emoji and style options.
- **New**: Audio support for verses and passages.

Created with ❤️ to make your ROBLOX projects inspiring.
=======================================================
--]]

local HttpService = game:GetService("HttpService")
local SoundService = game:GetService("SoundService")

local BibleModule = {}
BibleModule.Cache = {}

--=======================
-- ⚙️ SETTINGS
--=======================
BibleModule.Config = {
    BaseURL = "https://bible-api.com/", -- Replace with a secure and reputable API URL
    TTSBaseURL = "https://text-to-speech-api.com/convert", -- Replace with a secure and reputable TTS API URL
    DefaultTranslation = "kjv", -- Default translation (e.g., "kjv", "niv")
    DebugMode = true, -- Toggle debug messages ON/OFF
    VerseStyle = "emoji", -- Options: "plain", "emoji", "mixed"
    Emojis = { -- Customize emojis for visual enhancement
        Cross = "✝️",
        Bible = "📖",
        Light = "💡",
        PrayerHands = "🙏",
        Heart = "❤️",
    },
    Translations = { -- Supported translations
        ["King James Version"] = "kjv",
        ["New International Version"] = "niv",
        ["English Standard Version"] = "esv",
    },
    AudioCacheExpiration = 3600 -- Cache expiration time in seconds
}

--=======================
-- 📖 MODULE FUNCTIONS
--=======================

-- Debugging utility
function BibleModule:DebugLog(message)
    if self.Config.DebugMode then
        print("[BibleModule Debug] " .. message)
    end
end

-- API connectivity test
function BibleModule:TestAPI()
    self:DebugLog("Testing API connectivity...")
    local success, response = pcall(function()
        return HttpService:GetAsync(self.Config.BaseURL .. "john+3:16")
    end)

    if success then
        self:DebugLog("API Test Successful! Response: " .. response)
        return true
    else
        warn("❌ API Test Failed! Check your BaseURL or network settings.")
        return false
    end
end

-- Add emojis to a verse
function BibleModule:AddEmojis(verse)
    if self.Config.VerseStyle ~= "emoji" then
        return verse
    end
    return string.format(
        "%s %s %s",
        self.Config.Emojis.Bible,
        verse,
        self.Config.Emojis.Cross
    )
end

-- Fetch a specific Bible verse
function BibleModule:FetchVerse(book, chapter, verse, translation)
    local translation = translation or self.Config.DefaultTranslation
    local url = string.format(
        "%s%s+%d:%d?translation=%s",
        self.Config.BaseURL,
        book,
        chapter,
        verse,
        translation
    )

    -- Cache check
    local cacheKey = string.format("%s:%d:%d:%s", book, chapter, verse, translation)
    if self.Cache[cacheKey] and (os.time() - self.Cache[cacheKey].timestamp < self.Config.AudioCacheExpiration) then
        return self.Cache[cacheKey].data
    end

    -- API request
    self:DebugLog("Fetching verse: " .. cacheKey)
    local success, response = pcall(function()
        return HttpService:GetAsync(url)
    end)

    if success then
        local data = HttpService:JSONDecode(response)
        if data and data.text then
            local result = self:AddEmojis(data.text)
            self.Cache[cacheKey] = { data = result, timestamp = os.time() }
            return result
        end
    end

    warn(self.Config.ErrorMessage or "Unable to fetch verse. Please verify the details. 💡")
    return "Unable to fetch verse. Please verify the details. 💡"
end

-- Fetch a passage of multiple verses
function BibleModule:FetchPassage(book, chapter, startVerse, endVerse, translation)
    self:DebugLog(string.format("Fetching passage: %s %d:%d-%d", book, chapter, startVerse, endVerse))
    local verses = {}
    for i = startVerse, endVerse do
        table.insert(verses, self:FetchVerse(book, chapter, i, translation))
    end
    return table.concat(verses, " ")
end

-- Validate and sanitize input for URL
function BibleModule:SanitizeInput(input)
    return input:gsub("[^%w+]", "")
end

-- Generate TTS audio URL
function BibleModule:GenerateTTSURL(text, translation)
    local sanitizedText = self:SanitizeInput(text)
    local params = HttpService:UrlEncode(string.format("text=%s&translation=%s", sanitizedText, translation))
    return self.Config.TTSBaseURL .. "?" .. params
end

-- Play audio for a specific verse
function BibleModule:PlayVerseAudio(book, chapter, verse, translation)
    local translation = translation or self.Config.DefaultTranslation
    local verseText = self:FetchVerse(book, chapter, verse, translation)

    if verseText then
        local audioURL = self:GenerateTTSURL(verseText, translation)
        self:DebugLog("Playing audio for verse: " .. audioURL)

        local success, response = pcall(function()
            return HttpService:GetAsync(audioURL)
        end)

        if success then
            local sound = Instance.new("Sound", SoundService)
            sound.SoundId = "rbxassetid://" .. response
            sound:Play()
            return true
        else
            warn("❌ Failed to fetch audio. Possible causes: network issues, invalid URLs, or missing assets. Please check your TTS API or network settings.")
            return false
        end
    else
        warn("❌ Verse not found. Please verify the details.")
        return false
    end
end

-- Play audio for a passage of multiple verses
function BibleModule:PlayPassageAudio(book, chapter, startVerse, endVerse, translation)
    self:DebugLog(string.format("Playing audio for passage: %s %d:%d-%d", book, chapter, startVerse, endVerse))

    for i = startVerse, endVerse do
        local success = self:PlayVerseAudio(book, chapter, i, translation)
        if not success then
            warn("❌ Audio for verse " .. chapter .. ":" .. i .. " is unavailable.")
        end
    end
end

-- Search Bible verses by multiple criteria
function BibleModule:SearchByCriteria(criteria)
    local url = self.Config.BaseURL .. "search?"

    if criteria.book then
        url = url .. "book=" .. HttpService:UrlEncode(criteria.book) .. "&"
    end
    if criteria.keyword then
        url = url .. "q=" .. HttpService:UrlEncode(criteria.keyword) .. "&"
    end
    if criteria.translation then
        url = url .. "translation=" .. HttpService:UrlEncode(criteria.translation)
    end

    self:DebugLog("Generated Search URL: " .. url)
    local success, response = pcall(function()
        return HttpService:GetAsync(url)
    end)

    if success then
        local data = HttpService:JSONDecode(response)
        if data and data.verses then
            local results = {}
            for _, verse in ipairs(data.verses) do
                table.insert(results, self:AddEmojis(verse.text))
            end
            return results
        end
    end

    warn("🚨 Search failed. Check your input or API configuration.")
    return {}
end

--=======================
-- 🌟 PUBLIC INTERFACE
--=======================
BibleModule.GetVerse = BibleModule.FetchVerse
BibleModule.GetPassage = BibleModule.FetchPassage
BibleModule.SearchKeyword = BibleModule.SearchByCriteria
BibleModule.TestAPIConnection = BibleModule.TestAPI
BibleModule.PlayAudioForVerse = BibleModule.PlayVerseAudio
BibleModule.PlayAudioForPassage = BibleModule.PlayPassageAudio

return BibleModule
