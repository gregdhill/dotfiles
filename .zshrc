autoload -Uz compinit
compinit

source ~/.zsh_plugins.sh
source ~/.zsh/zsh-autosuggestions/zsh-autosuggestions.zsh 
export ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE="fg=1"

if [ $commands[helm] ]; then
  source <(helm completion zsh)
fi

if [ $commands[kubectl] ]; then
  source <(kubectl completion zsh)
fi

# git commit --signoff (-s)
# git config commit.gpgsign true
# git config --global commit.gpgsign true

alias tcopy='xclip -sel clip'
alias fcopy='xclip -sel clip <'
alias merge='gs -dBATCH -dNOPAUSE -q -sDEVICE=pdfwrite -dAutoRotatePages=/None -sOutputFile=finished.pdf'

b64d () { echo $1 | base64 -d }
function mkcd () { mkdir -p "$@" && eval cd "\"\$$#\""; }

# DOCKER
# ------

alias dlc='docker container ls'
alias dkc='docker kill $(docker ps -q)'
alias ddc='docker rm $(docker ps -a -q)'
alias ddi='docker rmi $(docker images -q)'


# KUBERNETES
# ----------

alias k='kubectl'
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
alias krm='kubectl delete pod'
alias wkgp='watch -n 1 kubectl get pods'

ksh () {kubectl exec -it $1 sh}

koy () {
	output=$(kubectl get deployments $1 --output yaml 2> /dev/null)
	if [[ $? -ne 0 ]]; then output=$(kubectl get replicasets $1 --output yaml 2> /dev/null); fi
	if [[ $? -ne 0 ]]; then output=$(kubectl get pods $1 --output yaml 2> /dev/null); fi
	if [[ $? -ne 0 ]]; then output=$(kubectl get configmaps $1 --output yaml 2> /dev/null); fi
	if [[ $? -ne 0 ]]; then output=$(kubectl get secrets $1 --output yaml 2> /dev/null); fi
	echo $output
}

kgn () {
	current_namespace=$(kubectl config get-contexts --no-headers | awk '{print $5}')
	kubectl get namespaces | awk '{if ($0 ~ /'"$current_namespace"'/) { print $0, "\t<-----" } else { print $0 }}'
}
# alias kcn="kubectl config get-contexts --no-headers | awk '{print \$5}'"

ksn () {kubectl config set-context $(kubectl config current-context) --namespace=$1 && kubectl get pods}
_kube_namespaces () {
	compadd "${(@)${(f)$(kubectl get namespaces --no-headers | awk '{print $1}')}}"
}
compdef _kube_namespaces ksn


# HELM
# ----

hgr () {
	printf '%-40s %-10s %-10s %-25s\n' "NAME" "REVISION" "STATUS" "NAMESPACE"
	helm ls | awk 'FNR > 1 { printf "%-40s %-10s %-10s %-25s\n", $1, $2, $8, $NF }'
}

alias hdr='helm delete --purge'


# GIT
# ---

alias g='git'
alias gaa='git add --all'
alias gst='git status'
alias gcam='git commit --signoff -a -m'
alias gpush='git push'
alias gpull='git pull'
alias gf='git fetch'
alias gcfd='git clean -fd'
alias gcb='git checkout -b'

export GOPATH=$HOME/go
export GOROOT=/usr/local/go
export GOBIN=$GOROOT/bin
export PATH=$PATH:$GOBIN
export PATH=$PATH:$GOPATH/bin

#ssh-add -t 12h ~/.ssh/github

export LC_CTYPE=en_US.UTF-8

#zstyle ':completion:*' completer _complete _ignored
#zstyle :compinstall filename '/home/greg/.zshrc'

HISTFILE=~/.zsh_history
HISTSIZE=5000
SAVEHIST=5000
setopt    appendhistory
setopt    sharehistory
setopt    incappendhistory

# The next line updates PATH for the Google Cloud SDK.
if [ -f '/home/greg/tools/google-cloud-sdk/path.zsh.inc' ]; then . '/home/greg/tools/google-cloud-sdk/path.zsh.inc'; fi

# The next line enables shell command completion for gcloud.
if [ -f '/home/greg/tools/google-cloud-sdk/completion.zsh.inc' ]; then . '/home/greg/tools/google-cloud-sdk/completion.zsh.inc'; fi

[[ -n "${key[Up]}" ]] && bindkey "${key[Up]}" history-beginning-search-backward
[[ -n "${key[Down]}" ]] && bindkey "${key[Down]}" history-beginning-search-forward

# secrets & other vars
[[ -f ~/.zshrc.secrets ]] && source ~/.zshrc.secrets

