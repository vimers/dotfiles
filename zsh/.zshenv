# set ruby path
. "$HOME/.cargo/env"
# set go path
export GOPATH=$HOME/.go
# update PATH, $HOME/.local/bin has higher priority
new_paths=($HOME/.local/bin $GOPATH/bin)
path=(${new_paths:|path} $path)
