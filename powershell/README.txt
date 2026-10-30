THE WOLF AMONG US REMASTERED - ULTRAWIDE FIX
PowerShell edition 0.1.0 - community test release

WHAT IT DOES

Removes the supported game's forced 16:9 rendering restriction and adds common ultrawide resolutions to its graphics menu. A console menu lets you pick a preset or enter custom dimensions. Setup can also undo its changes.

This edition uses Windows PowerShell 5.1 and included readable C# helper source. PowerShell compiles that source locally using the Windows .NET Framework, then loads it. It is still runnable code: removing the separate setup executable does not make the package automatically trusted or guarantee Nexus approval.

QUICK START

1. Extract the entire archive to a normal folder. Keep the Data folder beside "Ultrawide Setup.ps1".
2. Close the game.
3. Right-click "Ultrawide Setup.ps1" and choose "Run with PowerShell".
4. Enter the game folder, or press Enter to accept the displayed default.
5. Choose Install or update, then choose a resolution or enter custom dimensions.
6. Start the game and select that resolution in Settings > Graphics.

If the game is in a protected folder such as Program Files and you see an access-denied message, open Windows PowerShell as administrator and run the script from there. Open Start, search for "Windows PowerShell", then choose "Run as administrator". Use the full path to the extracted script, for example:

  & "C:\Mods\Ultrawide-Fix-PowerShell-0.1.0\Ultrawide Setup.ps1"

Use Windows PowerShell (powershell.exe), not PowerShell 7 (pwsh.exe). You can also open Windows PowerShell, change to the extracted folder and run:

  & ".\Ultrawide Setup.ps1"

POWERSHELL SCRIPT POLICY

Some systems block local scripts by default. A process-only RemoteSigned setting can be used for this run:

  powershell.exe -NoProfile -ExecutionPolicy RemoteSigned -File "C:\Mods\Ultrawide-Fix-PowerShell-0.1.0\Ultrawide Setup.ps1"

This setting applies to that PowerShell process, not the saved system policy. RemoteSigned still applies its checks to files marked as downloaded; managed policies can also prevent script execution. The mod does not alter execution policy, registry or antivirus settings itself. An execution-policy block and a Nexus quarantine are different checks; this script edition does not establish that an uploaded file has passed Nexus review.

RESOLUTIONS

- 2560 x 1080: available for testing; not confirmed in-game.
- 3440 x 1440: the underlying rendering fix is player-confirmed.
- 3840 x 1600: available for testing; not confirmed in-game.
- 5120 x 1440: experimental 32:9 option.
- Custom / detected primary display: available for testing; check the dimensions against the monitor you actually use.

Setup adds the common presets plus your selected custom mode. Select a mode your display supports. The allowed custom input range is 800-16384 wide and 600-8640 high; it is not a claim that every such mode works. To change the custom mode later, close the game and run setup again.

KNOWN LIMITS

Menus keep their original centred layout. Wider scenes can expose scenery and transition edges outside the intended framing. Every episode, cinematic, dialogue layout and QTE has not been exhaustively tested. Other mods replacing Menu_settings.lua may conflict. This PowerShell edition has not had a new full in-game playthrough.

SUPPORTED BUILD

Supports the investigated Windows x64 executable, associated with resource build PCS.18.3.7585. Setup checks the entire executable, not just its version label.

Original SHA-256:
  e8cedcf34066760e480689d44964dc5596f5585c77a19a2627786a8163a65616

With the exact one-byte rendering correction:
  460b789149554cf31dfbef60b16cf503a7afd19a3b3f1f79a6bd119b4821a615

Other executable builds or modifications are refused.

UNDO AND BACKUPS

Close the game, run the script again, choose the same game folder, then choose "Undo setup changes".

It restores the executable and the two ultrawide addon files to their state before the first setup installation. If a recognized ultrawide fix was already present, undo restores that prior state. Keep UltrawideFix.install.xml and the dated UltrawideFix-backup-* folder beside the game executable so undo can verify and restore the files.

This edition shares the same receipt and backup format as the graphical setup, so either edition can update or undo a recognized installation from the other. Setup refuses to overwrite or remove addon files that have changed unexpectedly. Your current saves and display preferences are preserved; after undo you may need to select a standard resolution in-game.

COMMAND-LINE OPTIONS (OPTIONAL)

Compatibility check, without installing:
  & ".\Ultrawide Setup.ps1" -Action Check -GameFolder "C:\Games\The Wolf Among Us Remastered" -NonInteractive

Install/update a custom mode:
  & ".\Ultrawide Setup.ps1" -Action Install -GameFolder "C:\Games\The Wolf Among Us Remastered" -Width 3840 -Height 1600 -NonInteractive

Undo:
  & ".\Ultrawide Setup.ps1" -Action Undo -GameFolder "C:\Games\The Wolf Among Us Remastered" -NonInteractive

HOW THIS EDITION WORKS

Ultrawide Setup.ps1 provides the console menu. Data/Initialize.ps1 loads Core.cs, Blowfish.cs and PowerShellBridge.cs. The helpers retain exact-build checks, a verified one-byte executable edit, addon generation, backups and undo. The compatible Lua template supplies the menu script; Menu_settings.lua is included as readable reference source.

No internet connection is used by setup. Files installed in the game are the same two ultrawide addon filenames, the one-byte executable correction, and the setup receipt/backups. No game save or preference file is edited.

VALIDATION

Windows PowerShell 5.1 loaded the helper source and correctly detected the primary display. Private-fixture tests passed for all four presets, custom mode generation, encrypted-script round trips, installation, repeated updates, exact undo, restoration of a recognized prior addon, unsupported-build refusal, changed-file refusal and preservation of unrelated files. Generated Lua bytecode and TTARCH2 structure are checked separately. These are installation/generation checks, not proof of every resolution's in-game behaviour or Nexus approval.

This is an unofficial community modification. See THIRD-PARTY-NOTICES.txt for implementation credits.
