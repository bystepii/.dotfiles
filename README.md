# Installation

```bash
# clone dotfiles
nix-shell -p git --command "git clone https://github.com/bystepii/.dotfiles.git"
cd .dotfiles

# create disk
sudo nix run --extra-experimental-features "nix-command flakes" "github:nix-community/disko" -- --mode disko hosts/host/system/disko.nix --arg device '"/dev/sdX"'

# install nixos
sudo nix-shell -p git --command "nixos-install --no-root-passwd --flake .#hostname"

# change user password
sudo nixos-enter --root /mnt --command "passwd user"
# or if impermanence is activated
sudo mkdir -p /mnt/persist/passwords
mkpasswd -m sha-512 | tr -d '\n' | sudo tee /mnt/persist/passwords/user
sudo chmod 600 /mnt/persist/passwords/user

# copy dotfiles
cd .. && cp -r .dotfiles /mnt/home/user

# reboot
sudo reboot

# install home-manager
nix run home-manager/master -- switch --flake .dotfiles
```
