#!/usr/bin/env bash

open /System/Library/PreferencePanes/Security.prefPane
echo "STOP! Did you grant Full Disk Access for Terminal in System Settings?
^C to terminate if you have not, type your password to continue."

echo -n Password: 
read -s password
echo

# Change login shell to bash for iris
echo $password | sudo -S chsh -s /bin/bash iris

if csrutil status | grep 'enabled'; then
  echo 'Disable SIP before executing! Aborting...'
  printf "\nBoot in to recovery and run\
	  \n$ csrutil enable --without fs --without debug --without nvram\n\n"
  read -p "Press return to poweroff"
  echo $password | sudo -S shutdown -h now
fi

# yabai: enable non-Apple-signed arm64e binaries for Apple Silicon
echo $password | sudo -S nvram boot-args=-arm64e_preview_abi

# nix-darwin
build_flake () {
  nix run --extra-experimental-features "nix-command flakes" \
	  nix-darwin -- switch --flake .#m1
}

# Run twice to ensure
build_flake
build_flake

printf "done!\n\n"
