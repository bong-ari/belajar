#update and upgrade
sudo apt-get update && apt-get upgrade -y

#install git and wget
sudo apt install wget git -y

#install zsh
sudo apt install -y zsh

#installing zsh
sh -c "$(wget https://raw.github.com/robbyrussell/oh-my-zsh/master/tools/install.sh -O -)"

# Add aliases to the .zshrc file
echo 'alias ll="ls -ltra"' >> ~/.zshrc
echo 'alias gd="git diff"' >> ~/.zshrc
echo 'alias gcmsg="git commit -m"' >> ~/.zshrc
echo 'alias gitc="git checkout"' >> ~/.zshrc
echo 'alias gitm="git checkout master"' >> ~/.zshrc

# Source the updated .zshrc file to make the aliases available in the current terminal session
source ~/.zshrc

# End of script