# Ultimate Bible Module

**Version:** 1.2.1  
**Created By:** @devycreates  

---

## Description
The **Ultimate Bible Module** provides advanced Bible-related functionalities, including verse statistics, trivia generation, character profiles, and now a bookmark system, making it a versatile tool for any ROBLOX game that incorporates Bible content.

---

## Features

- **Bible Verse Fetching:** Retrieve verses with translation options.
- **Verse Analytics:** Track the most-read and bookmarked verses.
- **Bible Trivia System:** Generate trivia questions based on Bible books.
- **Character Profiles:** Access detailed profiles of key Biblical characters.
- **Bookmark System:** Bookmark and retrieve verses.

---

## Setup Instructions

1. Copy the `BibleModule` script into your ROBLOX project.
2. Enable HTTP requests in your game's settings:
   - Go to **Game Settings** > **Security** > **Enable Studio Access to API Services** and enable it.
3. Require the module in your script and start using its functionalities.

---

## Functions and Examples

### 1. **Fetching a Verse**
Fetch a specific Bible verse using a reference (e.g., "John 3:16") and an optional translation.

```lua
local BibleModule = require(path_to_module)
local verse = BibleModule:GetVerse("John 3:16", "KJV")
print(verse) -- Outputs the verse text
