# Personal lib
{}: {
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
  createImports = item_list: item_dir:
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
}
