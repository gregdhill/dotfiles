export ZSH="/home/greg/.oh-my-zsh"

ZSH_THEME="geometry/geometry"
export TERM="xterm-256color"

plugins=(
  git
  zsh-syntax-highlighting
  zsh-autosuggestions
)

source $ZSH/oh-my-zsh.sh

# git commit --signoff (-s)
# git config commit.gpgsign true
# git config --global commit.gpgsign true

alias tcopy='xclip -sel clip'
alias fcopy='xclip -sel clip <'
alias merge='gs -dBATCH -dNOPAUSE -q -sDEVICE=pdfwrite -dAutoRotatePages=/None -sOutputFile=finished.pdf'

alias kc='kubectl'
alias kg='kubectl get'

alias kgd='kubectl get deployments'
alias kgr='kubectl get replicasets'
alias kgsec='kubectl get secrets'
alias kgsrv='kubectl get services'
alias kgc='kubectl get configmaps'
alias kgp='kubectl get pods'
alias kgi='kubectl get ingresses.extensions'
alias kge='kubectl get endpoints'
alias kl='kubectl logs'
alias klf='kubectl logs -f'
alias kd='kubectl describe'
alias kdp='kubectl describe pod'

kgn () {
	current_namespace=$(kubectl config get-contexts --no-headers | awk '{print $5}')
	kubectl get namespaces | awk '{if ($0 ~ /'"$current_namespace"'/) { print $0, "\t<-----" } else { print $0 }}'
}
#alias kcn="kubectl config get-contexts --no-headers | awk '{print \$5}'"

ksn () {kubectl config set-context $(kubectl config current-context) --namespace=$1 && kubectl get pods}
_kube_namespaces () {
	compadd "${(@)${(f)$(kubectl get namespaces --no-headers | awk '{print $1}')}}"
}
compdef _kube_namespaces ksn

hgr () {
	printf '%-40s %-10s %-10s %-25s\n' "NAME" "REVISION" "STATUS" "NAMESPACE"
	helm ls | awk 'FNR > 1 { printf "%-40s %-10s %-10s %-25s\n", $1, $2, $8, $NF }'
}

function mkcd () { mkdir -p "$@" && eval cd "\"\$$#\""; }

# gst 	: git status
# gcam	: git commit -a -m
# gp	: git push

alias gcam='git commit --signoff -a -m'

export GOPATH=$HOME/go
export GOROOT=/usr/local/go
export GOBIN=$GOROOT/bin
export PATH=$PATH:$GOBIN
export PATH=$PATH:$GOPATH/bin

export bosmarmot=$GOPATH/src/github.com/monax/bosmarmot
export burrow=$GOPATH/src/github.com/hyperledger/burrow
export hoard=$GOPATH/src/github.com/monax/hoard
export monax=$GOPATH/src/github.com/monax

alias dkc='docker kill $(docker ps -q)'
alias ddc='docker rm $(docker ps -a -q)'
alias ddi='docker rmi $(docker images -q)'

source <(kubectl completion zsh)
export ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE="fg=1"
if [ $commands[helm] ]; then
  source <(helm completion zsh)
fi

#ssh-add -t 12h ~/.ssh/github
