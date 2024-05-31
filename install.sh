#!/usr/bin/zsh

mkdir -p ~/.zsh/completion

if [[ ! -f ~/.zshrc ]]; then
	echo "Please install zsh before using boxer"
	exit 1
fi


if [[ ! -d ~/.boxer ]]; then
	mkdir ~/.boxer
	cp ./boxer.sh ~/.boxer
	echo "source ~/.boxer/boxer.sh" >> ~/.zshrc
	cp ./_boxer ~/.zsh/completion

	source ~/.zshrc
fi
