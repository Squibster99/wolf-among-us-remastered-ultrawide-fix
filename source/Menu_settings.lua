require("uiz_Setting.lua")
require("Menu_Downloads.lua")
if IsToolBuild() then
  require("Menu_Pause_Debug.lua")
end
local isPC = IsPlatformPC() or IsPlatformMac() or IsPlatformWin10()
local isTablet = IsPlatformIOS() or IsEngineAndroid()
local isConsole = not isPC and not isTablet
local mbMenuDeactivated = false
local mReturnedToRoot = false
local mLastMenu
local mIsPause = false
local mButtonSizeModifier = 0.424
local SettingsMenu = function(name, title)
  local menu = UIZ_ListMenu(name)
  AgentSetProperty(name, "Menu Alignment", "Center")
  UIZ_Title(title)
  if mReturnedToRoot then
    UIZ_ConsoleButton_Refresh()
    print("refresh apply prompt")
  end
  UIZ_Widget("ui_horizontalstripe_bg")
  OnSetInputMode(Input_UseCursor())
  
  function menu:activate()
    UIZ_BackButton("SettingsCheck()")
    print("menu activate: settings menu")
    print("Confirm prompt")
    print(mConfirmPrompt)
    if mConfirmPrompt then
      mLastMenu = menu
      UIZ_Widget_Suppress("ui_button_applyChanges")
      mConfirmPrompt = false
      UIZ_PopMenu()
      return
    end
    HorizontalBar_Show(true)
    if mLastMenu == nil then
      if Input_UseCursor() then
        UIZ_Widget_Unsuppress("ui_button_applyChanges")
        UIZ_ConsoleButton("stick_left_slide", "navhelp_adjust", menu)
        UIZ_ConsoleButton("facebutton_down", "navhelp_apply", "ApplySettingsChanges()", menu)
        UIZ_ConsoleButton("facebutton_right", "navhelp_previousmenu", "SettingsCheck()", menu)
      else
        UIZ_ConsoleButton("stick_left_slide", "navhelp_adjust", menu)
        UIZ_ConsoleButton("facebutton_down", "navhelp_apply", "ApplySettingsChanges()", menu)
        UIZ_ConsoleButton("facebutton_right", "navhelp_previousmenu", "SettingsCheck()", menu)
        UIZ_SetWidgetsActive(menu)
      end
    end
    Callback_OnSetInputMode:Add(OnSetInputMode)
  end
  
  function menu:deactivate()
    print("menu deactivate : settings menu")
    if not mConfirmPrompt then
      AgentHide("ui_button_applyChanges", true, true)
      HorizontalBar_Show(false)
    end
    if mConfirmPrompt then
      AgentHide("ui_button_applyChanges", true, true)
      UIZ_Widget_Suppress("ui_button_applyChanges")
      mConfirmPrompt = false
      mReturnedToRoot = true
    end
  end
  
  return menu
end
local CreateSettingsButton = function(name, text, command, bIsNew, bIsLocked, bMenu)
  local button = NewButton(name, text, command, bIsNew, bIsLocked, bMenu)
  AgentSetProperty(name, kTextScale, mButtonSizeModifier)
  return button
end
-- Retain native modes, add trial ultrawide presets, and the setup-selected custom mode.
local getResolutions = function()
  local txts, seen = {}, {}
  local add = function(mode)
    if type(mode) ~= "string" then return end
    local w, h = string.match(mode, "^(%d+)x(%d+)$")
    w, h = tonumber(w), tonumber(h)
    if w and h and w >= 800 and h >= 600 and not seen[mode] then
      seen[mode] = true
      table.insert(txts, mode)
    end
  end
  for _, v in ipairs(RenderGetDisplayResolutions()) do
    add(v.x .. "x" .. v.y)
  end
  for _, mode in ipairs({"2560x1080", "3440x1440", "3840x1600", "5120x1440", "CUSTOM_ULTRAWIDE_MODE"}) do add(mode) end
  local prefs = GetPreferences()
  for _, key in ipairs({"Window Size", "Fullscreen Size"}) do
    local v = prefs[key]
    if v and v.x and v.y then add(v.x .. "x" .. v.y) end
  end
  return txts
end

function Menu_Settings_RestorePurchases()
  PlatformShowActivityIndicator("Restoring purchases...")
  PurchaseManager_RestorePurchases()
  ConnectedContentManager_UpdateDLC()
  Yield()
  PlatformHideActivityIndicator()
end

function Menu_Settings(bIsPause)
  mIsPause = bIsPause == true
  local menu = UIZ_ListMenu("ui_menu_settings", nil, -0.14)
  AgentSetProperty(menu, "Menu Alignment", "Left")
  UIZ_Title("header_settings")
  UIZ_BackButton()
  UIZ_ConsoleButton("facebutton_down", "navhelp_select")
  UIZ_ConsoleButton("facebutton_right", "navhelp_previousmenu", "UIZ_PopMenu()")
  
  function menu:activate()
    print("Menu Activate (root")
    if mLastMenu then
      Callback_OnSetInputMode:Remove(OnSetInputMode)
      UIZ_ConsoleButton_Clear(mLastMenu)
      print("console button Apply settings, cleared, Root menu activate")
      UIZ_ConsoleButton_Refresh()
      AgentSetProperty("ui_title", "UIZ - Show chore", "")
      mLastMenu = nil
      mReturnedToRoot = true
    end
  end
  
  function menu:deactivate()
    print("Menu deactivate (root")
    mbMenuDeactivated = true
  end
  
  function menu:populate()
    if not mbDirty then
      CachePreferences()
      print("populating")
    end
    CreateSettingsButton("ui_buttonControls", "label_controls", "Menu_ControlsHelp()")
    CreateSettingsButton("ui_menu_settings_av", "label_audiovideo", "UIZ_PushMenu('ui_menu_av')")
    CreateSettingsButton("ui_menu_settings_gameplay", "label_gameplay", "UIZ_PushMenu('ui_menu_gameplay')")
    if isPC then
      CreateSettingsButton("ui_menu_settings_graphics", "label_graphics", "UIZ_PushMenu('ui_menu_graphics')")
    end
    if not IsShipping() and not mIsPause then
      CreateSettingsButton("ui_buttonDebugOptions", "debug_debugOptions_title", "Menu_DebugOptions()")
    end
    for i, v in ipairs(menu.registeredWidgets) do
      print(AgentGetName(v))
    end
  end
  
  local menuAudioVideo = SettingsMenu("ui_menu_av", "header_audiovideo")
  
  function menuAudioVideo:populate()
    mbMenuDeactivated = false
    local slider1, slider2, slider3, slider4
    slider1 = uiz_Setting_Slider("ui_soundMaster", "label_volume_master", nil, "Volume Master")
    slider2 = uiz_Setting_Slider("ui_music", "label_volume_music", nil, "Volume Music")
    AgentHide(slider1, true, true)
    AgentHide(slider2, true, true)
    if mIsPause == false then
      slider3 = uiz_Setting_Toggle("ui_subtitles", "label_subtitles", nil, nil, "Enable Subtitles", "onOff")
      AgentHide(slider3, true, true)
      local languageOptions, languageValues
      if IsShipping() then
        languageOptions = {
          "label_language_english",
          "label_language_french",
          "label_language_german",
          "label_language_spanish"
        }
        languageValues = {
          "english",
          "french",
          "german",
          "spanish"
        }
      else
        languageOptions = {
          "label_language_english",
          "label_language_french",
          "label_language_german",
          "label_language_spanish",
          "label_language_italian"
        }
        languageValues = {
          "english",
          "french",
          "german",
          "spanish",
          "italian"
        }
      end
      slider4 = uiz_Setting_Toggle("ui_language", "label_language", languageOptions, nil, "Game Language", languageValues)
      AgentHide(slider4, true, true)
    else
      local bDisplaySubtitleSetting = not PropertyGet("project_general.prop", kDeletedScenesEnabled) and not LogicGet("DeletedScenes")
      if bDisplaySubtitleSetting then
        slider3 = uiz_Setting_Toggle("ui_subtitles", "label_subtitles", nil, nil, "Enable Subtitles", "onOff")
        AgentHide(slider3, true, true)
      end
    end
    local applyButton = UIZ_Button("ui_button_applyChanges", "label_apply", "ApplySettingsChanges()")
    UIZ_Widget_CursorOnly(applyButton)
    AgentSetProperty(applyButton, "Text Scale", 0.45)
  end
  
  local audiovideoParentActivate = menuAudioVideo.activate
  
  function menuAudioVideo:activate()
    if audiovideoParentActivate then
      audiovideoParentActivate(menuAudioVideo)
    end
    AgentSetPos(AgentFind("ui_button_applyChanges"), Vector(0, -4, 0))
  end
  
  function menuAudioVideo:deactivate()
    mbMenuDeactivated = true
    AgentHide("ui_button_applyChanges", true, true)
    if not mConfirmPrompt then
      HorizontalBar_Show(false)
    end
  end
  
  local menuGameplay = SettingsMenu("ui_menu_gameplay", "header_gameplay")
  
  function menuGameplay:populate()
    mbMenuDeactivated = false
    local slider1
    if not isTablet then
      slider1 = uiz_Setting_Toggle("ui_inverty", "label_inverty", nil, nil, "Reticle - Invert Joystick Y Axis", "onOff")
      AgentHide(slider1, true, true)
    end
    local slider2 = uiz_Setting_Toggle("ui_showDots", "label_displayselectables", nil, nil, "Enable Reticle Hint Dots", "onOff")
    AgentHide(slider2, true, true)
    if not rawget(_G, "IsSGFDemo") or not IsSGFDemo() then
      local rumbleOptions = {
        "label_rumbleOff",
        "label_rumbleWeak",
        "label_rumbleNormal",
        "label_rumbleStrong"
      }
      local slider3 = uiz_Setting_Toggle("ui_Rumble", "label_rumbleLevel", rumbleOptions, nil, "Rumble - Strength", {
        0,
        0.35,
        1,
        1.35
      })
      AgentHide(slider3, true, true)
      local slider4 = uiz_Setting_Toggle("ui_struggleAssist", "label_struggleAssist", nil, nil, "Struggle Assist", "onOff")
      AgentHide(slider4, true, true)
      local sizeOptions = {
        "label_qteSize_small",
        "label_qteSize_default",
        "label_qteSize_big"
      }
      local slider5 = uiz_Setting_Toggle("ui_qteSize", "label_qteSize", sizeOptions, nil, "QTE UI Scale", {
        0.7,
        1,
        1.35
      })
      AgentHide(slider5, true, true)
    end
    local slider6 = uiz_Setting_Toggle("ui_noir", "label_noirFilter", nil, nil, "Filter - Noir", "onOff")
    AgentHide(slider6, true, true)
    local applyButton = UIZ_Button("ui_button_applyChanges", "label_apply", "ApplySettingsChanges()")
    UIZ_Widget_CursorOnly(applyButton)
    AgentSetProperty(applyButton, "Text Scale", 0.45)
  end
  
  local gameplayParentActivate = menuGameplay.activate
  
  function menuGameplay:activate()
    if gameplayParentActivate then
      gameplayParentActivate(menuGameplay)
    end
    AgentSetPos(AgentFind("ui_button_applyChanges"), Vector(0, -4, 0))
  end
  
  function menuGameplay:deactivate()
    print("menu gameplay settings deactivate")
    mbMenuDeactivated = true
    AgentHide("ui_button_applyChanges", true, true)
    if not mConfirmPrompt then
      HorizontalBar_Show(false)
    end
  end
  
  if isPC then
    local graphicsMenu = SettingsMenu("ui_menu_graphics", "header_graphics")
    local slider1, slider2, slider3, slider4, res
    
    function graphicsMenu:populate()
      mbMenuDeactivated = false
      slider1 = uiz_Setting_Toggle("ui_gq", "label_graphicsquality", {"label_high", "label_low"}, nil, "Render Quality", "highLowGraphics")
      slider2 = uiz_Setting_Toggle("ui_tq", "label_texturequality", {
        "label_high",
        "label_medium",
        "label_low"
      }, nil, "Texture Quality", "highMediumLow")
      slider3 = uiz_Setting_Toggle("ui_antialiasing", "label_antialiasing", nil, nil, "FX anti-aliasing", "onOff")
      slider4 = uiz_Setting_Toggle("ui_fullscreen", "lable_windowed", nil, nil, "Windowed", "inverted")
      if not IsPlatformWin10() then
        res = uiz_Setting_Toggle("ui_resolution", "label_resolution", getResolutions(), true)
        local resButton = UIZ_GetInstance("text", nil, res)
        
        function resButton:activate()
          local r = GetPreferences().Windowed and GetPreferences()["Window Size"] or GetPreferences()["Fullscreen Size"]
          local bSetValue = false
          for i, v in ipairs(res.options) do
            local i1, i2, x, y = string.find(v, "(%d+)x(%d+)")
            if tonumber(x) == r.x and tonumber(y) == r.y then
              res:setValue(i)
              bSetValue = true
              break
            end
          end
          if not bSetValue then
            res:setValue(1)
          end
          PropertySet(GetPreferences(), "Fullscreen Size", r)
          PropertySet(GetPreferences(), "Window Size", r)
          AgentHide(self, false)
        end
      end
      AgentHide(slider1, true, true)
      AgentHide(slider2, true, true)
      AgentHide(slider3, true, true)
      AgentHide(slider4, true, true)
      if not IsPlatformWin10() then
        AgentHide(res, true, true)
      end
      local applyButton = UIZ_Button("ui_button_applyChanges", "label_apply", "ApplySettingsChanges()")
      UIZ_Widget_CursorOnly(applyButton)
      AgentSetProperty(applyButton, "Text Scale", 0.45)
    end
    
    local graphicsParentActivate = graphicsMenu.activate
    
    function graphicsMenu:activate()
      if graphicsParentActivate then
        graphicsParentActivate(graphicsMenu)
      end
      AgentSetPos(AgentFind("ui_button_applyChanges"), Vector(0, -4, 0))
    end
    
    function graphicsMenu:deactivate()
      mbMenuDeactivated = true
      AgentHide("ui_button_applyChanges", true, true)
      if not mConfirmPrompt then
        HorizontalBar_Show(false)
        if not mbRestored and not IsPlatformWin10() and res.value then
          local r = {}
          local i
          i, i, r.x, r.y = string.find(res.options[res.value], "(%d+)x(%d+)")
          local lastRes = GetPreferences().Windowed and GetPreferences()["Window Size"] or GetPreferences()["Fullscreen Size"]
          if lastRes.x ~= r.x or lastRes.y ~= r.y then
            PropertySet(GetPreferences(), "Fullscreen Size", r)
            PropertySet(GetPreferences(), "Window Size", r)
            local aspectRatio = r.x / r.y
            RenderSetAspectRatio(aspectRatio)
            if 1.7 < aspectRatio then
              ChorePlay("ui_menu_widescreen_main.chore")
            else
              ChorePlay("ui_menu_default_main.chore")
            end
          end
        end
        mbRestored = false
      end
    end
  end
  UIZ_PushMenu("ui_menu_settings")
end

function OnSetInputMode(bUseCursor)
  if bUseCursor then
    UIZ_Widget_Unsuppress("ui_button_applyChanges")
  else
    UIZ_Widget_Suppress("ui_button_applyChanges")
  end
end
