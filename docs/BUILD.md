# Building the setup

Use 64-bit Windows with .NET Framework 4.x and PowerShell. From the repository root, run:

```powershell
.\Build.ps1
```

This creates `package/Ultrawide Setup.exe` using the included compatible Lua template. It does not install or modify a game. The template is stripped to remove local source paths and debug information. The source of the modified script is in `source/Menu_settings.lua`.

To rebuild the Lua script after editing it, pass a compatible compiler:

```powershell
.\Build.ps1 -LuaCompiler 'C:\Tools\compatible-lua-5.2\luac.exe'
```

This game uses a custom Lua 5.2 ABI: 32-bit int, size_t, instructions and floating-point numbers. A stock modern Lua compiler is not interchangeable. The build checks the header and refuses incompatible output. The original local compiler came from the TTG Tools workflow; no compiler executable is redistributed here.

The .NET compiler and debug/source-path metadata can change output bytes. A byte-for-byte match with the release executable is not claimed. The existing release archive is published unchanged with its checksum.

## Validation

`tests/validation.json` summarizes the private-fixture tests. Private game copies and saves are not part of the repository. Tests covered supported-build patch/undo, repeated updates, restoration of a recognized previous addon, unsupported executable refusal, modified addon refusal, mode substitution and archive/bytecode validity.

The initial release has not had exhaustive graphical-setup or full-game compatibility testing. Only the underlying rendering correction at 3440×1440 is player-confirmed. Reports should identify the resolution, mode, scene and observed issue.


Version 0.1.2 adds source/FormatChecks.cs. Compile it with Core.cs and Blowfish.cs as a console executable, embedding the template and descriptor under resource names template and descriptor. Its first argument is an output folder. It validates the independent CRC64 filename identifier and decrypts the final stored archive payload, comparing it with the generated Lua chunk. Validate the emitted chunks with a compatible Lua compiler. No game installation is required for format checks.
