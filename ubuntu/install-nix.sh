cd /tmp
# for --no-daemon uncomment aka single user
sudo mkdir nix
sudo chown vagrant nix
sh <(curl -L https://nixos.org/nix/install) --no-daemon

# to be on the safe side add config to home too
mkdir -p $HOME/$1/.config/nix
cat >> $HOME/$1/.config/nix/nix.conf <<EOF
substituters        = https://hydra.iohk.io https://iohk.cachix.org https://cache.nixos.org/
trusted-public-keys = hydra.iohk.io:f/Ea+s+dFdN+3Y/G+FDgSq+a5NEWhJGzdjvKNGv0/EQ= iohk.cachix.org-1:DpRUyj7h7V830dp/i6Nti+NEO2/nhblbov/8MW7Rqoo= cache.nixos.org-1:6NCHdD59X431o0gWypbMrAURkbJ16ZPMQFGspcDShjY=
EOF