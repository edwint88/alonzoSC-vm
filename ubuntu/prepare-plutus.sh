mkdir -p $HOME/git
# Prepare VIM
curl -fLo ~/.vim/autoload/plug.vim --create-dirs \
    https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
vim +'PlugInstall --sync' +qa 2>&1

cd $HOME/git
git clone https://github.com/input-output-hk/plutus
git clone https://github.com/input-output-hk/plutus-starter.git
git clone https://github.com/input-output-hk/plutus-pioneer-program.git
touch updatePlutus.sh
echo "nix build -f default.nix plutus.haskell.packages.plutus-core.components.library" >> updatePlutus.sh
echo "nix-build -A plutus-playground.client" >> updatePlutus.sh
echo "nix-build -A plutus-playground.server" >> updatePlutus.sh
echo "nix-build -A plutus-playground.generate-purescript" >> updatePlutus.sh
echo "nix-build -A plutus-playground.start-backend" >> updatePlutus.sh
echo "nix-build -A plutus-pab" >> updatePlutus.sh
echo "nix-shell --command \"cd plutus-pab; plutus-playground-generate-purs; cd ..; cd plutus-playground-server; plutus-playground-generate-purs\"" >> updatePlutus.sh
cd ./plutus
/bin/bash ../updatePlutus.sh
# Add host 0.0.0.0 -> to access the frontend in browser 192.168.5.x
cp plutus-playground-client/package.json plutus-playground-client/package.json.bak 
sed 's/--mode=development/--mode=development --host 0.0.0.0/g' plutus-playground-client/package.json.bak > plutus-playground-client/package.json