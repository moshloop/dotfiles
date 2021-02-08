

cd $HOME/.dotfiles/zsh

install_plugin() {
  plugin=$HOME/.dotfiles/plugins/$(basename $1)
  if [ ! -e  $plugin ]; then
      git clone --depth 1 https://github.com/$1.git  $plugin
  fi
  entry=`echo $plugin/*.plugin.zsh`
  if [ ! -e  $entry ]; then
    entry=`echo $plugin/*.zsh`
  fi
  echo "source $entry " >> plugins.zsh

}

mkdir -p $HOME/.config
ln -s $HOME/.dotfiles/zsh/starship.toml $HOME/.config/
for plugin in `cat plugins.txt`; do
        install_plugin $plugin
done
