{}:
# personal lib
{
  pathToAttrs = prefix_path: insertArgs:
    builtins.listToAttrs (builtins.map (folder: {
        name = folder;
        value = insertArgs "${prefix_path}/${folder}" "${folder}";
      })
      (builtins.attrNames (builtins.readDir prefix_path)));
}
