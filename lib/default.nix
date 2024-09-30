# Personal lib
{lib}: rec {
  /*
  Creates a list of sets with attribute keys based on directory names and corresponding values from a callback function.
  Args:
    prefix_path - The path from which to get the directory names.
    insertArgs - The callback function.
  Returns: The created attribute list.
  */
  pathToAttrs = prefix_path: insertArgs:
    builtins.listToAttrs (builtins.map (folder: {
        name = folder;
        value = insertArgs "${prefix_path}/${folder}" "${folder}";
      })
      (builtins.attrNames (builtins.readDir prefix_path)));

  /*
  Creates an imports list from a mix of file and directory names.
  Args:
    item_list - List of file and directory names.
    item_dir - Path to be prepended to each item.
  Returns: The created imports list.
  */
  mkImports = item_list: item_dir:
    builtins.map (
      item: let
        path = item_dir + ("/" + item + ".nix");
        result = builtins.tryEval (builtins.pathExists path);
      in
        if result.success
        then
          if result.value
          then path
          else item_dir + ("/" + item)
        else "Error checking file existence"
    )
    item_list;

  /*
  A recursive function which reates a package name (Ex: pkgs.kdePackages.breeze-icons) of type package
  from a string list of the form [ "packageSet" "subPackageSet" "package" ].
  Args:
    count ? 1 - Just an integer that counts up from 1 as the function iterates through the list from right to left.
    prefix ? pkgs - The package set being worked with.
    attr_list - The string list which contains the package set and subpackage names.
  Returns: The created package name of type package.
  */
  mkPkgName = let
    getElem = with builtins; count: attr_list: elemAt attr_list ((length attr_list) - count);
  in
    with builtins;
      {count ? 1}: prefix: attr_list: (
        if (getElem count attr_list) == (elemAt attr_list 0)
        then (head (lib.attrsets.attrVals [(getElem count attr_list)] prefix))
        else
          (
            head (lib.attrsets.attrVals [(getElem count attr_list)] (mkPkgName {count = count + 1;} prefix attr_list))
          )
      );

  /*
  mkPkgName = with builtins; let
    getElem = count: attr_list: elemAt attr_list ((length attr_list) - count);

    mkPkgNameHelper = {count ? 1}: prefix: attr_list: (
      if (getElem count attr_list) == (elemAt attr_list 0)
      then (head (lib.attrsets.attrVals [(getElem count attr_list)] prefix))
      else
        (
          head (lib.attrsets.attrVals [(getElem count attr_list)] (mkPkgNameHelper {count = count + 1;} prefix attr_list))
        )
    );
  in
    {count ? 1}: prefix: attr_list:
      mkPkgNameHelper {inherit count;} prefix attr_list;
  */
}
