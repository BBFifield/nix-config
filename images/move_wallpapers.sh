#!/run/current-system/sw/bin/bash

src_path=$( cd "$(dirname "${BASH_SOURCE[0]}")" ; pwd -P )
dest_path="/home/$USER/Pictures"

mkdir -p "$dest_path"

echo "Attempting to move wallpapers to ~/pictures directory."
if [ "$(ls -1|wc -l)" -gt 0 ]; then
  cp -r "$src_path"/wallpapers "$dest_path"
  echo "Wallpapers moved to $dest_path."
else 
  echo "Wallpaper directory is empty."
fi