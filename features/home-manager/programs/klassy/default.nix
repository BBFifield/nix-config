{
  config,
  lib,
  ...
}: {
  options.hm.klassy = {
    enable = lib.mkEnableOption "Enable klassy configuration";
  };

  config = lib.mkIf config.hm.klassy.enable {
    home.file = {
      ".config/klassy/windecopresetsrc" = {
        text = ''
          [Windeco Preset Breeze Actual]
          ActiveTitleBarOpacity=100
          AdjustBackgroundColorOnPoorContrastActive=false
          AdjustBackgroundColorOnPoorContrastInactive=false
          AnimationsEnabled=true
          AnimationsSpeedRelativeSystem=0
          ApplyOpacityToHeader=true
          BlurTransparentTitleBars=true
          BoldButtonIcons=BoldIconsFine
          ButtonBackgroundColorsActive=TitleBarTextNegativeClose
          ButtonBackgroundColorsInactive=TitleBarTextNegativeClose
          ButtonBackgroundOpacityActive=100
          ButtonBackgroundOpacityInactive=100
          ButtonCornerRadius=SameAsWindow
          ButtonCustomCornerRadius=1
          ButtonIconColorsActive=TitleBarText
          ButtonIconColorsInactive=TitleBarText
          ButtonIconOpacityActive=100
          ButtonIconOpacityInactive=100
          ButtonIconStyle=StyleOxygen
          ButtonOverrideColorsActiveApplicationMenu=
          ButtonOverrideColorsActiveClose={"BackgroundHover":[255,152,162],"BackgroundNormal":["TitleBarBackgroundAuto",0],"BackgroundPress":[108,33,40],"IconHover":["TitleBarBackgroundAuto"],"IconPress":[54,52,58]}
          ButtonOverrideColorsActiveContextHelp=
          ButtonOverrideColorsActiveKeepAbove=
          ButtonOverrideColorsActiveKeepBelow=
          ButtonOverrideColorsActiveMaximize={"BackgroundPress":[104,107,110],"IconPress":[45,49,53]}
          ButtonOverrideColorsActiveMenu=
          ButtonOverrideColorsActiveMinimize={"BackgroundPress":[104,107,110],"IconPress":[45,49,53]}
          ButtonOverrideColorsActiveOnAllDesktops=
          ButtonOverrideColorsActiveShade=
          ButtonOverrideColorsInactiveApplicationMenu=
          ButtonOverrideColorsInactiveClose={"BackgroundHover":[218,68,83],"BackgroundNormal":["TitleBarBackgroundAuto",0],"IconHover":["TitleBarBackgroundAuto"]}
          ButtonOverrideColorsInactiveContextHelp=
          ButtonOverrideColorsInactiveKeepAbove=
          ButtonOverrideColorsInactiveKeepBelow=
          ButtonOverrideColorsInactiveMaximize=
          ButtonOverrideColorsInactiveMenu=
          ButtonOverrideColorsInactiveMinimize=
          ButtonOverrideColorsInactiveOnAllDesktops=
          ButtonOverrideColorsInactiveShade=
          ButtonOverrideColorsLockStatesActive=
          ButtonOverrideColorsLockStatesInactive=
          ButtonShape=ShapeSmallCircle
          ButtonSpacingLeft=2
          ButtonSpacingRight=3
          ButtonStateCheckedActive=Hover
          ButtonStateCheckedInactive=Hover
          CloseButtonIconColorActive=AsSelected
          CloseButtonIconColorInactive=WhiteWhenHoverPress
          CloseFullHeightButtonWidthMarginRelative=100
          ColorizeThinWindowOutlineWithButton=false
          CornerRadius=1.5
          DrawBackgroundGradient=false
          DrawBorderOnMaximizedWindows=false
          DrawTitleBarSeparator=false
          ForceColorizeSystemIcons=true
          FullHeightButtonSpacingLeft=1
          FullHeightButtonSpacingRight=1
          FullHeightButtonWidthMarginLeft=3
          FullHeightButtonWidthMarginRight=9
          IconSize=IconMedium
          InactiveTitleBarOpacity=100
          IntegratedRoundedRectangleBottomPadding=1
          KlassyDarkIconThemeInherits=breeze-dark
          KlassyIconThemeInherits=breeze
          KwinBorderSize=None
          LockButtonBehaviourActiveInactive=true
          LockButtonColorsActiveInactive=false
          LockButtonSpacingLeftRight=false
          LockCloseButtonBehaviourActive=false
          LockCloseButtonBehaviourInactive=false
          LockFullHeightButtonSpacingLeftRight=true
          LockFullHeightButtonWidthMargins=false
          LockThinWindowOutlineCustomColorActiveInactive=true
          LockThinWindowOutlineStyleActiveInactive=true
          LockTitleBarLeftRightMargins=true
          LockTitleBarTopBottomMargins=true
          NegativeCloseBackgroundHoverPressActive=true
          NegativeCloseBackgroundHoverPressInactive=true
          OnPoorIconContrastActive=TitleBarBackground
          OnPoorIconContrastInactive=TitleBarBackground
          OpaqueMaximizedTitleBars=true
          OverrideActiveTitleBarOpacity=false
          OverrideInactiveTitleBarOpacity=false
          PercentMaximizedTopBottomMargins=100
          PoorBackgroundContrastThresholdActive=1.1
          PoorBackgroundContrastThresholdInactive=1.1
          PoorIconContrastThresholdActive=1.5
          PoorIconContrastThresholdInactive=1.5
          RoundBottomCornersWhenNoBorders=false
          ScaleBackgroundPercent=105
          ShadowColor=0,0,0
          ShadowSize=ShadowLarge
          ShadowStrength=255
          ShowBackgroundNormallyActive=false
          ShowBackgroundNormallyInactive=false
          ShowBackgroundOnHoverActive=true
          ShowBackgroundOnHoverInactive=true
          ShowBackgroundOnPressActive=true
          ShowBackgroundOnPressInactive=true
          ShowCloseBackgroundNormallyActive=true
          ShowCloseBackgroundNormallyInactive=true
          ShowCloseBackgroundOnHoverActive=true
          ShowCloseBackgroundOnHoverInactive=true
          ShowCloseBackgroundOnPressActive=true
          ShowCloseBackgroundOnPressInactive=true
          ShowCloseIconNormallyActive=true
          ShowCloseIconNormallyInactive=true
          ShowCloseIconOnHoverActive=true
          ShowCloseIconOnHoverInactive=true
          ShowCloseIconOnPressActive=true
          ShowCloseIconOnPressInactive=true
          ShowCloseOutlineNormallyActive=false
          ShowCloseOutlineNormallyInactive=false
          ShowCloseOutlineOnHoverActive=false
          ShowCloseOutlineOnHoverInactive=false
          ShowCloseOutlineOnPressActive=false
          ShowCloseOutlineOnPressInactive=false
          ShowIconNormallyActive=true
          ShowIconNormallyInactive=true
          ShowIconOnHoverActive=true
          ShowIconOnHoverInactive=true
          ShowIconOnPressActive=true
          ShowIconOnPressInactive=true
          ShowOutlineNormallyActive=false
          ShowOutlineNormallyInactive=false
          ShowOutlineOnHoverActive=false
          ShowOutlineOnHoverInactive=false
          ShowOutlineOnPressActive=false
          ShowOutlineOnPressInactive=false
          SystemIconSize=SystemIcon16
          ThinWindowOutlineCustomColorActive=94,97,100
          ThinWindowOutlineCustomColorInactive=94,97,100
          ThinWindowOutlineStyleActive=WindowOutlineCustomColor
          ThinWindowOutlineStyleInactive=WindowOutlineCustomColor
          ThinWindowOutlineThickness=1.5
          TitleAlignment=AlignCenterFullWidth
          TitleBarBottomMargin=2
          TitleBarLeftMargin=2
          TitleBarRightMargin=2
          TitleBarTopMargin=2
          TitleSidePadding=2
          UseHoverAccentActive=false
          UseHoverAccentInactive=false
          UseTitleBarColorForAllBorders=false
          VaryColorBackgroundActive=MoreTitleBar
          VaryColorBackgroundInactive=MoreTitleBar
          VaryColorCloseBackgroundActive=Light
          VaryColorCloseBackgroundInactive=Light
          VaryColorCloseIconActive=No
          VaryColorCloseIconInactive=No
          VaryColorCloseOutlineActive=No
          VaryColorCloseOutlineInactive=No
          VaryColorIconActive=No
          VaryColorIconInactive=No
          VaryColorOutlineActive=No
          VaryColorOutlineInactive=No
          WindowOutlineAccentColorOpacityActive=67
          WindowOutlineAccentColorOpacityInactive=25
          WindowOutlineAccentWithContrastOpacityActive=50
          WindowOutlineAccentWithContrastOpacityInactive=20
          WindowOutlineContrastOpacityActive=60
          WindowOutlineContrastOpacityInactive=25
          WindowOutlineCustomColorOpacityActive=100
          WindowOutlineCustomColorOpacityInactive=100
          WindowOutlineCustomWithContrastOpacityActive=100
          WindowOutlineCustomWithContrastOpacityInactive=25
          WindowOutlineShadowColorOpacity=20
        '';
      };
      ".config/klassy/klassyrc" = {
        text = ''
          [ButtonBehaviour]
          ButtonStateCheckedActive=Hover
          ButtonStateCheckedInactive=Hover
          LockCloseButtonBehaviourActive=false
          LockCloseButtonBehaviourInactive=false
          ShowCloseBackgroundNormallyActive=true
          ShowCloseBackgroundNormallyInactive=true
          ShowCloseOutlineOnHoverActive=false
          ShowCloseOutlineOnHoverInactive=false
          ShowCloseOutlineOnPressActive=false
          ShowCloseOutlineOnPressInactive=false
          ShowOutlineOnHoverActive=false
          ShowOutlineOnHoverInactive=false
          ShowOutlineOnPressActive=false
          ShowOutlineOnPressInactive=false
          VaryColorBackgroundActive=MoreTitleBar
          VaryColorBackgroundInactive=MoreTitleBar
          VaryColorCloseBackgroundActive=Light
          VaryColorCloseBackgroundInactive=Light
          VaryColorCloseOutlineActive=No
          VaryColorCloseOutlineInactive=No
          VaryColorOutlineActive=No
          VaryColorOutlineInactive=No

          [ButtonColors]
          AdjustBackgroundColorOnPoorContrastActive=false
          AdjustBackgroundColorOnPoorContrastInactive=false
          ButtonBackgroundColorsActive=TitleBarTextNegativeClose
          ButtonBackgroundColorsInactive=TitleBarTextNegativeClose
          ButtonBackgroundOpacityActive=100
          ButtonBackgroundOpacityInactive=100
          ButtonOverrideColorsActiveClose={"BackgroundHover":[255,152,162],"BackgroundNormal":["TitleBarBackgroundAuto",0],"BackgroundPress":[108,33,40],"IconHover":["TitleBarBackgroundAuto"],"IconPress":[54,52,58]}
          ButtonOverrideColorsActiveMaximize={"BackgroundPress":[104,107,110],"IconPress":[45,49,53]}
          ButtonOverrideColorsActiveMinimize={"BackgroundPress":[104,107,110],"IconPress":[45,49,53]}
          ButtonOverrideColorsInactiveClose={"BackgroundHover":[218,68,83],"BackgroundNormal":["TitleBarBackgroundAuto",0],"IconHover":["TitleBarBackgroundAuto"]}
          CloseButtonIconColorActive=AsSelected
          LockButtonColorsActiveInactive=false
          NegativeCloseBackgroundHoverPressActive=true
          NegativeCloseBackgroundHoverPressInactive=true

          [ButtonSizing]
          ButtonSpacingLeft=2
          ButtonSpacingRight=3
          FullHeightButtonWidthMarginRight=9
          ScaleBackgroundPercent=105

          [Style]
          MenuOpacity=70

          [TitleBarSpacing]
          TitleBarBottomMargin=2
          TitleBarLeftMargin=2
          TitleBarRightMargin=2
          TitleBarTopMargin=2

          [Windeco]
          BoldButtonIcons=BoldIconsFine
          ButtonIconStyle=StyleOxygen
          ButtonShape=ShapeSmallCircle
          ColorizeThinWindowOutlineWithButton=false
          CornerRadius=1.5
          IconSize=IconMedium
          UseTitleBarColorForAllBorders=false

          [WindowOutlineStyle]
          LockThinWindowOutlineStyleActiveInactive=true
          ThinWindowOutlineCustomColorActive=94,97,100
          ThinWindowOutlineCustomColorInactive=94,97,100
          ThinWindowOutlineStyleActive=WindowOutlineCustomColor
          ThinWindowOutlineStyleInactive=WindowOutlineCustomColor
          ThinWindowOutlineThickness=1.5
          WindowOutlineContrastOpacityActive=60
          WindowOutlineCustomColorOpacityActive=100
          WindowOutlineCustomColorOpacityInactive=100
          WindowOutlineCustomWithContrastOpacityActive=100
        '';
      };
    };
  };
}
