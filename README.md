# The Wolf Among Us Remastered — Ultrawide Fix

An unofficial ultrawide fix for the supported Windows x64 build. The setup removes the forced 16:9 rendering restriction, adds common ultrawide resolutions to the graphics menu, and accepts custom dimensions.

## Download

[GitHub releases](https://github.com/saqibahmad765-commits/wolf-among-us-remastered-ultrawide-fix/releases) contain the player package. You can also [download version 0.1.0 directly](releases/The-Wolf-Among-Us-Remastered-Ultrawide-Fix-0.1.0.7z?raw=true) and its [SHA-256 checksum](releases/The-Wolf-Among-Us-Remastered-Ultrawide-Fix-0.1.0.7z.sha256).

Extract the archive, close the game, run **Ultrawide Setup.exe**, select the game folder and your resolution, then click **Install / update**. Select the resolution inside the game's graphics settings afterwards. Use **Undo setup changes** to restore the pre-install state.

## PowerShell alternative

Prefer a console menu? Download the **[PowerShell edition 0.1.1](https://github.com/saqibahmad765-commits/wolf-among-us-remastered-ultrawide-fix/releases/tag/v0.1.1-powershell)** and choose the `.7z` file under Assets. It includes the full package and player instructions; you do not need to clone this repository.

Extract the complete folder, close the game, and run **Ultrawide Setup.ps1** using **Windows PowerShell 5.1** (`powershell.exe`, not PowerShell 7). It offers presets, custom dimensions, build checks, backups and undo. Select your resolution inside the game afterwards. See the [PowerShell player README](powershell/README.txt) for permissions, script-policy troubleshooting and removal.

This edition ships readable PowerShell/C# source and a compatible Lua template, with no bundled EXE or DLL. Windows compiles the helpers locally. The source is in [`powershell/`](powershell/); no separate build step is needed. Both setup editions share the same installation receipt and backup format. Choose whichever interface you prefer for the same ultrawide correction.

PowerShell loading, display detection and installation/update/undo checks passed private-copy tests. A new full gameplay test has not been performed. The existing resolution/framing limitations apply to both editions.

## Support and limitations

- **3440×1440:** the underlying rendering correction is player-confirmed.
- **2560×1080 and 3840×1600:** offered for testing; not confirmed in-game.
- **5120×1440:** experimental 32:9 option.
- **Custom dimensions:** offered for testing; choose a mode supported by your display.

Menus retain their original centred layout. Wider views can expose scenery and transition edges. All episodes, cinematics, dialogue and QTE layouts have not been exhaustively tested. This is an initial **test release**. The setup's install/update/undo, archive generation and refusal checks passed private-fixture tests; the graphical setup and generalized menu have not received a complete desktop/gameplay test.

Setup checks the entire executable and refuses other builds. Supported original SHA-256:

```text
e8cedcf34066760e480689d44964dc5596f5585c77a19a2627786a8163a65616
```

See the [full player readme](docs/README.txt) for installation, compatibility, backups and undo details.

## Source and build

- `source/Core.cs`: exact-build patch, resolution generator, install/update/undo checks.
- `source/Setup.cs`: Windows Forms interface.
- `source/Menu_settings.lua`: modified resolution-menu script.
- `source/Blowfish.cs`: existing TTG Tools encryption implementation, with upstream credits retained.
- `assets/Menu_settings.template.luac`: stripped, compatible Lua bytecode for building without a Lua compiler.
- `Build.ps1`: portable Windows build script; [build details](docs/BUILD.md).
- `tests/validation.json`: validation summary and honest limits.

Original setup code, upstream cryptography and game-derived script material have different provenance. See [third-party notices](THIRD-PARTY-NOTICES.txt); no blanket licence is asserted over the game-derived or upstream material.
