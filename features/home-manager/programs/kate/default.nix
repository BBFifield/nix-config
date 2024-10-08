{
  pkgs,
  config,
  lib,
  ...
}: {
  options.hm.kate = {
    enable = lib.mkEnableOption "Enable kate configuration";
  };

  config = lib.mkIf config.hm.kate.enable {
    programs.kate = {
      enable = true;
      package = pkgs.kdePackages.kate;
      editor = {
        indent.showLines = false;
        brackets = {
          automaticallyAddClosing = true;
          characters = ''<>(){}[]'"`'';
          flashMatching = true;
        };
        theme.name = "Breeze Dark";
      };
    };
    programs.plasma.configFile."katerc" = {
      ColorPicker = {
        HexLengths = "3,6,9,12";
        NamedColors = false;
        PreviewAfterColor = true;
      };
      ColoredBrackets = {
        color1 = "#1275ef";
        color2 = "#f83c1f";
        color3 = "#9dba1e";
        color4 = "#e219e2";
        color5 = "#37d21c";
      };
      General = {
        "Allow Tab Scrolling" = true;
        "Auto Hide Tabs" = false;
        "Close After Last" = false;
        "Close documents with window" = true;
        "Days Meta Infos" = 30;
        "Diagnostics Limit" = 12000;
        "Diff Show Style" = 0;
        "Elide Tab Text" = false;
        "Expand Tabs" = false;
        "Icon size for left and right sidebar buttons" = 32;
        "Last Session" = "nixos-config";
        "Modified Notification" = false;
        "Mouse back button action" = 0;
        "Mouse forward button action" = 0;
        "Open New Tab To The Right Of Current" = false;
        "Output History Limit" = 100;
        "Recent File List Entry Count" = 10;
        "Restore Window Configuration" = true;
        "SDI Mode" = false;
        "Save Meta Infos" = true;
        "Session Manager Sort Column" = 0;
        "Session Manager Sort Order" = 0;
        "Show Full Path in Title" = false;
        "Show Menu Bar" = true;
        "Show Status Bar" = true;
        "Show Symbol In Navigation Bar" = true;
        "Show Tab Bar" = true;
        "Show Tabs Close Button" = true;
        "Show Url Nav Bar" = true;
        "Show output view for message type" = 1;
        "Show text for left and right sidebar" = false;
        "Show welcome view for new window" = true;
        "Startup Session" = "manual";
        "Stash new unsaved files" = true;
        "Stash unsaved file changes" = false;
        "Sync section size with tab positions" = false;
        "Tab Double Click New Document" = true;
        "Tab Middle Click Close Document" = true;
        "Tabbar Tab Limit" = 0;
      };

      "KTextEditor Renderer" = {
        "Line Height Multiplier" = 1;
        "Show Whole Bracket Expression" = false;
        #"Text Font" = "Hack,10,-1,7,400,0,0,0,0,0,0,0,0,0,0,1";
        "Word Wrap Marker" = false;
      };
      "KTextEditor View" = {
        "Allow Mark Menu" = true;
        "Auto Center Lines" = 0;
        "Auto Completion" = true;
        "Auto Completion Preselect First Entry" = true;
        "Backspace Remove Composed Characters" = false;
        "Bookmark Menu Sorting" = 0;
        "Bracket Match Preview" = false;
        "Default Mark Type" = 1;
        "Dynamic Word Wrap" = true;
        "Dynamic Word Wrap Align Indent" = 80;
        "Dynamic Word Wrap At Static Marker" = false;
        "Dynamic Word Wrap Indicators" = 1;
        "Dynamic Wrap not at word boundaries" = false;
        "Enable Accessibility" = true;
        "Enable Tab completion" = false;
        "Enter To Insert Completion" = true;
        "Fold First Line" = false;
        "Folding Bar" = true;
        "Folding Preview" = true;
        "Icon Bar" = false;
        "Input Mode" = 0;
        "Keyword Completion" = true;
        "Line Modification" = true;
        "Line Numbers" = true;
        "Max Clipboard History Entries" = 20;
        "Maximum Search History Size" = 100;
        "Mouse Paste At Cursor Position" = false;
        "Multiple Cursor Modifier" = 134217728;
        "Persistent Selection" = false;
        "Scroll Bar Marks" = false;
        "Scroll Bar Mini Map All" = true;
        "Scroll Bar Mini Map Width" = 60;
        "Scroll Bar MiniMap" = true;
        "Scroll Bar Preview" = true;
        "Scroll Past End" = false;
        "Search/Replace Flags" = 140;
        "Shoe Line Ending Type in Statusbar" = false;
        "Show Documentation With Completion" = true;
        "Show File Encoding" = true;
        "Show Folding Icons On Hover Only" = true;
        "Show Line Count" = false;
        "Show Scrollbars" = 1;
        "Show Statusbar Dictionary" = true;
        "Show Statusbar Highlighting Mode" = true;
        "Show Statusbar Input Mode" = true;
        "Show Statusbar Line Column" = true;
        "Show Statusbar Tab Settings" = true;
        "Show Word Count" = false;
        "Smart Copy Cut" = true;
        "Statusbar Line Column Compact Mode" = true;
        "Text Drag And Drop" = true;
        "User Sets Of Chars To Enclose Selection" = "";
        "Vi Input Mode Steal Keys" = false;
        "Vi Relative Line Numbers" = false;
        "Word Completion" = true;
        "Word Completion Minimal Word Length" = 3;
        "Word Completion Remove Tail" = true;
      };
      Konsole = {
        AutoSyncronizeMode = 0;
        KonsoleEscKeyBehaviour = true;
        KonsoleEscKeyExceptions = "vi,vim,nvim,git";
        RemoveExtension = false;
        RunPrefix = "";
        SetEditor = false;
      };
      filetree = {
        editShade = "31,81,106";
        listMode = false;
        middleClickToClose = false;
        shadingEnabled = true;
        showCloseButton = false;
        showFullPathOnRoots = false;
        showToolbar = true;
        sortRole = 0;
        viewShade = "81,49,95";
      };
      lspclient = {
        AllowedServerCommandLines = "/run/current-system/sw/bin/nil";
        AutoHover = true;
        AutoImport = true;
        BlockedServerCommandLines = "";
        CompletionDocumentation = true;
        CompletionParens = true;
        Diagnostics = true;
        FormatOnSave = false;
        HighlightGoto = true;
        IncrementalSync = false;
        InlayHints = false;
        Messages = true;
        ReferencesDeclaration = true;
        SemanticHighlighting = true;
        ServerConfiguration = "";
        SignatureHelp = true;
        SymbolDetails = false;
        SymbolExpand = true;
        SymbolSort = false;
        SymbolTree = true;
        TypeFormatting = false;
      };
    };
  };
}
