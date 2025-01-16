--[[
=======================================================
?? BibleModule.lua - A Public ROBLOX Bible Tool
=======================================================
Welcome to the BibleModule! ??? This module allows you 
to fetch Bible verses, passages, and perform advanced 
searches. It’s packed with features, debug tools, and 
customization options for any ROBLOX developer.

?? IMPORTANT: Do not edit below the "SETTINGS" section 
unless you're an advanced user.

? Features:
- Fetch single verses or passages.
- Multi-translation support.
- Advanced search by multiple criteria.
- Debugging tools for troubleshooting.
- Fully customizable with emoji and style options.

Created with ?? to make your ROBLOX projects inspiring.
=======================================================
--]]

local HttpService = game:GetService("HttpService")

local BibleModule = {}
BibleModule.Cache = {}

--=======================
-- ?? SETTINGS
--=======================
BibleModule.Config = {
	BaseURL = "https://bible-api.com/", -- Replace with a valid API URL
	DefaultTranslation = "kjv", -- Default translation (e.g., "kjv", "niv")
	DebugMode = true, -- Toggle debug messages ON/OFF
	VerseStyle = "emoji", -- Options: "plain", "emoji", "mixed"
	Emojis = { -- Customize emojis for visual enhancement
		Cross = "??",
		Bible = "??",
		Light = "??",
		PrayerHands = "??",
		Heart = "??",
	},
	Translations = { -- Supported translations
		["King James Version"] = "kjv",
		["New International Version"] = "niv",
		["English Standard Version"] = "esv",
	}
}

--=======================
-- ?? MODULE FUNCTIONS
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
		warn("? API Test Failed! Check your BaseURL or network settings.")
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
	if self.Cache[cacheKey] then
		return self.Cache[cacheKey]
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
			self.Cache[cacheKey] = result
			return result
		end
	end

	warn(self.Config.ErrorMessage)
	return "Unable to fetch verse. Please verify the details. ??"
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

	warn("?? Search failed. Check your input or API configuration.")
	return {}
end

--=======================
-- ?? PUBLIC INTERFACE
--=======================
BibleModule.GetVerse = BibleModule.FetchVerse
BibleModule.GetPassage = BibleModule.FetchPassage
BibleModule.SearchKeyword = BibleModule.SearchByCriteria
BibleModule.TestAPIConnection = BibleModule.TestAPI

return BibleModule
