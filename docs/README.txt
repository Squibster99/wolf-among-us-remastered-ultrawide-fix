THE WOLF AMONG US REMASTERED — ULTRAWIDE FIX
Version 0.1.0 • Community test release • 30 October 2026

WHAT IT DOES

Removes the game's forced 16:9 rendering restriction and adds common ultrawide resolutions to its graphics menu. A small Windows setup tool lets you add your own resolution too.

QUICK START

1. Extract this entire archive to a normal folder. Do not run setup from inside the archive.
2. Close the game before running setup.
3. Run "Ultrawide Setup.exe". Windows asks for administrator permission because setup may need to write to the game's protected installation folder.
4. Check the game folder. Use Browse if your game is installed elsewhere.
5. Choose a preset, or select "Custom / detected display" and enter your width and height. The detected size is for your primary display; check it if you play on another monitor.
6. Click "Install / update".
7. Start the game normally. Open Settings > Graphics, select your desired resolution, and apply it using the game's normal controls.

Setup adds the listed presets plus your selected custom resolution. It does not automatically change your saved resolution or other preferences. If the picture is the wrong size, first check that you selected your monitor's native resolution in the game and are using your preferred fullscreen/windowed mode.

RESOLUTIONS AND WHAT HAS ACTUALLY BEEN TESTED

  2560 x 1080 — available for testing; not confirmed in-game
  3440 x 1440 — the underlying rendering fix is player-confirmed at this size
  3840 x 1600 — available for testing; not confirmed in-game
  5120 x 1440 — experimental 32:9 option; not confirmed in-game
  Custom      — available for testing; choose a mode your monitor supports

A resolution appearing in the menu does not prove that your display, driver or every game scene supports it correctly. Setup can accept custom dimensions between 800–16384 wide and 600–8640 high; those input limits are not a claim that all such modes work.

The new setup's preset/custom generation, bytecode/archive output, installation, update, exact undo, prior-version restoration and changed-file checks were tested on private game-copy fixtures. The setup window itself has not had a desktop interaction test. The new generalized menu package has not received a complete in-game playthrough. Treat this as an initial test release, not a guarantee of flawless support for every screen.

KNOWN LIMITATIONS

- Menus retain their original centred 16:9 artwork and layout.
- Wider views can expose scenery or transition edges that were outside the intended framing. This has been seen in parts of the opening sequence.
- Very wide 32:9 screens may reveal more framing problems. They have not been verified.
- Dialogue, QTE placement, cinematics, every episode and alternate scenes have not been exhaustively tested.
- Setup detects your primary display, not necessarily the monitor you use for the game.
- Other mods that replace Menu_settings.lua may conflict with this resolution-menu addon.

SUPPORTED GAME BUILD

This release supports the specific Windows x64 executable investigated with resource build PCS.18.3.7585. A matching version label alone is not enough: setup checks the entire executable before making its one-byte change.

Original executable SHA-256:
  e8cedcf34066760e480689d44964dc5596f5585c77a19a2627786a8163a65616

Executable with this exact correction:
  460b789149554cf31dfbef60b16cf503a7afd19a3b3f1f79a6bd119b4821a615

Different or otherwise modified executables are refused. If setup says your build is unsupported, do not force this patch or manually apply its offset to another version.

The setup tool is a 64-bit Windows .NET Framework application. The setup executable is an unsigned community tool.

CHANGING YOUR CUSTOM RESOLUTION

Close the game, run the same setup again, enter the new dimensions, and click "Install / update". Then select that resolution in the game. The usual presets remain available. There is no need to edit game scripts yourself.

UNDO

Close the game, run the setup, choose the same game folder, and click "Undo setup changes".

Undo restores the executable and the two ultrawide addon files to their state immediately before the first installation with this setup. If a recognized ultrawide fix was already installed, undo restores that previous state.

Setup records ownership and file hashes in UltrawideFix.install.xml. Backups are kept in a dated UltrawideFix-backup-* folder beside the game executable. Keep the receipt and backup folder until you no longer need undo. Setup refuses to overwrite or undo addon files that have changed unexpectedly. Backups are retained after undo.

Your current saves and display preferences are not restored from an old backup. They are preserved. Your chosen ultrawide resolution may remain selected after undo; choose an original supported mode in-game if necessary.

WHAT IS CHANGED

- One executable byte disables the forced-ratio flag on the supported build.
- Archives/Fables_pc_Ultrawide_ar_all.ttarch2 is generated with the chosen custom mode.
- Archives/_resdesc_50_Ultrawide.lua loads that resolution-menu addon.
- A setup receipt and dated backup folder support undo.

The menu addon preserves the game's enumerated display modes, adds the presets/custom mode, and retains current saved dimensions in the list. It does not change camera zoom or apply an image-stretching filter. Setup does not modify unrelated mods, save files, other preferences.

IF YOU REPORT A PROBLEM

Please include your resolution, monitor aspect ratio, fullscreen/windowed mode, where the problem occurs, and whether setup accepted the executable. Describe stretched characters, cropping, misplaced interaction targets or exposed scenery separately. A screenshot helps. Please do not upload your full game executable or private saves as part of an ordinary report.

This is an unofficial community modification, not an official game update. See THIRD-PARTY-NOTICES.txt for implementation credits.
