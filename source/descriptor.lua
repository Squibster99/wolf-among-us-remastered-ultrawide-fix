-- Ultrawide Fix 0.1.0: resolution menu addon, PCS.18.3.7585
local set = {}
set.name = "Ultrawide"
set.setName = "Ultrawide"
set.descriptionFilenameOverride = ""
set.logicalName = "<Ultrawide>"
set.logicalDestination = "<>"
set.priority = 110
set.localDir = _currentDirectory
set.enableMode = "constant"
set.version = "UltrawideFix-0.1.0"
set.descriptionPriority = 0
set.gameDataName = "Ultrawide Game Data"
set.gameDataPriority = 0
set.gameDataEnableMode = "constant"
set.localDirIncludeBase = false
set.localDirRecurse = false
set.gameDataArchives = {_currentDirectory .. "Fables_pc_Ultrawide_ar_all.ttarch2"}
RegisterSetDescription(set)
