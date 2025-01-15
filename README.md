
# 📖 Bible Module for ROBLOX
Welcome to the **Bible Module**—a feature-rich, developer-friendly tool designed for ROBLOX developers to integrate Bible functionality into their games. This module allows fetching Bible verses, searching passages, using multiple translations, and much more.

---

## ✨ Features
- **Fetch Bible Verses**: Retrieve specific verses by book, chapter, and verse.
- **Multi-Translation Support**: Includes KJV, NIV, ESV (easily extendable).
- **Bible Passage Fetching**: Get multiple verses in a range (e.g., John 3:16–18).
- **Advanced Search**: Search by book, keyword, or translation.
- **Debugging Tools**: Connectivity tests and detailed logs for developers.
- **Customizable Emojis and Style**: Add emojis or switch to plain/mixed text.

---

## 🚀 Getting Started
### Prerequisites
- ROBLOX Studio installed.
- HTTP Requests enabled in your game:
  1. Open ROBLOX Studio.
  2. Go to `Home > Game Settings > Security`.
  3. Toggle **Allow HTTP Requests** to ON.

### Installation
1. Download the **BibleModule.lua** file from this repository.
2. Add it to your ROBLOX game:
   - Place it in `ReplicatedStorage`.
   - Rename it to `BibleModule` (if necessary).

---

## 🛠️ Usage
### Importing the Module
```lua
local Bible = require(game.ReplicatedStorage.BibleModule)
```

### Fetch a Verse
```lua
local verse = Bible:GetVerse("John", 3, 16)
print("John 3:16:", verse)
```

### Fetch a Passage
```lua
local passage = Bible:GetPassage("Psalms", 23, 1, 3)
print("Psalms 23:1-3:", passage)
```

### Advanced Search
```lua
local results = Bible:SearchKeyword({book = "Matthew", keyword = "faith"})
for i, v in ipairs(results) do
    print("Search Result:", v)
end
```

### Test API Connectivity
```lua
Bible:TestAPIConnection()
```

---

## ⚙️ Configuration
Customize the module by editing the `Config` table in `BibleModule.lua`. Key options include:
- **DefaultTranslation**: Choose the default Bible translation.
- **DebugMode**: Toggle verbose logging.
- **VerseStyle**: Select `"plain"`, `"emoji"`, or `"mixed"` display styles.
- **Emojis**: Modify emojis for Cross, Bible, etc.

Example:
```lua
BibleModule.Config = {
    DefaultTranslation = "niv", -- Change to NIV
    DebugMode = true,           -- Enable debug logs
    VerseStyle = "emoji",       -- Add emojis to verses
    Emojis = {                  -- Customize emojis
        Cross = "✝️",
        Bible = "📖",
        Heart = "❤️"
    }
}
```

---

## 💡 Contributing
We welcome contributions! To contribute:
1. **Fork this repository** and clone it locally.
2. Make changes or add features in a new branch:
   ```bash
   git checkout -b feature-new-feature
   ```
3. Test your changes in ROBLOX Studio.
4. Push the branch to your fork and create a Pull Request.

### Contributor Guidelines
- Follow the existing code structure and style.
- Add comments for new functions or configurations.
- Test your changes thoroughly before submitting a PR.

### Reporting Issues
If you encounter a bug or have a feature request:
1. Check if it’s already reported in the [Issues](https://github.com/devycreates/BibleModule/issues) tab.
2. If not, create a new issue with:
   - A descriptive title.
   - Steps to reproduce the issue.
   - Screenshots or logs, if applicable.

---

## 📜 License
This project is licensed under the MIT License. See the [LICENSE](LICENSE) file for details.

---

## ❤️ Acknowledgements
- Thanks to [Bible-API](https://bible-api.com/) for powering the scripture data.
- To our contributors and users, your support makes this project possible.

---

## 🛡️ Disclaimer
This module is designed for educational and inspirational purposes. Please respect the API's terms of use and ROBLOX community standards when integrating this module into your games.
```

