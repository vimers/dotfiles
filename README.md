Manage dot files

# Usage
1. Install stow
```shell
# debian/ubuntu
sudo apt install stow
# centos
sudo yum install -y epel-release
sudo yum install -y stow
```
2. Clone repo
```shell
git clone https://github.com/vimers/dotfiles $HOME/.dotfiles
```
3. Use stow to restore all dot files
```shell
stow zsh
stow ranger
stow lazygit
```
