# The Wolf Among Us Remastered - Ultrawide Fix

**Use version 0.1.2 or newer.** Earlier public packages had script-packaging errors that could prevent a save from loading into gameplay. Version 0.1.2 fixes both errors. The corrected graphical test build was confirmed to load into gameplay at 3440 x 1440; other modes and a complete playthrough remain unverified.

## Download and install

Choose one setup interface for the same fix:

- **[Graphical setup 0.1.2](https://github.com/saqibahmad765-commits/wolf-among-us-remastered-ultrawide-fix/releases/tag/v0.1.2)**: download the `.7z` under Assets, extract it, close the game and run `Ultrawide Setup.exe`.
- **[PowerShell setup 0.1.2](https://github.com/saqibahmad765-commits/wolf-among-us-remastered-ultrawide-fix/releases/tag/v0.1.2-powershell)**: extract the complete folder and run `Ultrawide Setup.ps1` in **Windows PowerShell 5.1** (`powershell.exe`, not PowerShell 7). Read its instructions for protected-folder permissions and script-policy troubleshooting.

Choose the game folder and your resolution, then Install / update. Afterwards select that resolution in the game's graphics settings. Use the `.7z` player package, rather than GitHub's automatic Source code downloads. Both editions include a README and checksum. The PowerShell edition includes readable C# helpers compiled locally and bundles no EXE or DLL.

## Updating or undoing

Close the game, run the new setup and choose the same folder/resolution, then Install / update. A recognised existing setup can be updated directly, including the earlier broken public versions. If you already used Undo, install normally. No new game is required.

Keep `UltrawideFix.install.xml` and the dated backup folders beside the game executable. Do not manually replace addon files: their hashes are recorded for guarded updates/removal. Undo returns to the state before the first installation recorded in the receipt, which can include an older ultrawide addon. Saves and current preferences are preserved.

## Features and limits

Removes the supported executable's forced 16:9 rendering restriction and adds ultrawide presets plus a custom mode to its graphics menu.

- **3440 x 1440:** corrected graphical test build confirmed loading a save into gameplay.
- **2560 x 1080 and 3840 x 1600:** offered for testing; not confirmed in-game.
- **5120 x 1440:** experimental 32:9 option.
- **Custom dimensions:** choose a mode your display supports; input limits do not guarantee compatibility.

Menus retain their original centred layout, and wider views can expose scenery or transition edges outside the intended framing. All episodes, cinematics, dialogue and QTE layouts have not been exhaustively tested. Other mods replacing `Menu_settings.lua` can conflict. These remain community test releases.

Setup supports the investigated Windows x64 executable associated with resource build PCS.18.3.7585 and checks its complete hash. Supported original SHA-256: `e8cedcf34066760e480689d44964dc5596f5585c77a19a2627786a8163a65616`.

Full instructions: [graphical README](docs/README.txt), [PowerShell README](powershell/README.txt).

## What changed in 0.1.2

Corrected the menu script's TTARCH2 resource identifier. Also corrected encryption verification to decrypt a copy, preserving the encrypted bytes that are written into the game addon. Previously, the check mutated the output into plaintext while retaining an encrypted marker.

Regression checks now validate the independent filename identifier and decrypt the actual final archive payload, compare it with the generated Lua chunk and parse it with the compatible compiler. Both editions generate identical addon bytes for four presets and a custom test mode. Private install/update/undo, refusal checks and migration from the old broken graphical setup passed. The stripped release script matches the player-tested corrected script without its debug metadata.

## Source and build

- `source/Core.cs`: guarded patch, generator, installation and undo.
- `source/Setup.cs`: graphical interface.
- `source/FormatChecks.cs`: final archive regression checks.
- `source/Menu_settings.lua` and `assets/Menu_settings.template.luac`: readable menu source and compatible stripped template.
- `powershell/`: complete PowerShell source/package, including C# helpers.
- `Build.ps1`: portable graphical build script; [build details](docs/BUILD.md).
- `tests/validation.json`: validation scope and limits.

See [third-party notices](THIRD-PARTY-NOTICES.txt) for provenance. No blanket licence is asserted over upstream or game-derived material. The game executable and private test fixtures are not distributed.
