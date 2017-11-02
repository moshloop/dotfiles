

cd $ZSH

install_plugin() {
  plugin=plugins/$(basename $1)
  if [ ! -e  $plugin ]; then
      git subtree add --prefix  plugin  https://github.com/$1.git  master --squash
  fi
  entry=`echo $plugin/*.plugin.zsh`
  if [ ! -e  $entry ]; then
    entry=`echo $plugin/*.zsh`
  fi
  echo "source $ZSH/$entry " >> $ZSH/zsh/plugins.zsh

}

rm $ZSH/zsh/plugins.zsh
for plugin in `cat $ZSH/zsh/plugins`; do
        install_plugin $plugin
done