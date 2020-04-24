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

alias tcopy='xclip -sel clip'
alias fcopy='xclip -sel clip <'
alias paste='xclip -sel clip -o'
alias merge='gs -dBATCH -dNOPAUSE -q -sDEVICE=pdfwrite -dAutoRotatePages=/None -sOutputFile=finished.pdf'

function json_escape () {
    printf '%s' "$1" | python -c 'import json,sys; print(json.dumps(sys.stdin.read()))'
}

function b64d () { echo $1 | base64 -d }
function mkcd () { mkdir -p "$@" && eval cd "\"\$$#\""; }
function port () { lsof -i :$1 }
alias cdtemp='cd $(mktemp -d)'
alias redo='sudo $(fc -ln -1)'

function download () {
	scratch=$(mktemp -d)
	zshexit() {"rm -rf $scratch"}
	curl -sSL $1 -o $scratch/package
	tar -xf $scratch/package -C $scratch/
	files=$(find $scratch -executable -type f)
	if [ $EUID != 0 ]; then
    		sudo chmod +x $files
		sudo mv $files /usr/local/bin
	fi
}

alias ll='swaymsg output eDP-1 pos 0 0 && swaymsg output DP-2 pos 1920 0'
alias lr='swaymsg output eDP-1 pos 1920 0 && swaymsg output DP-2 pos 0 0' 

# CONTAINERS
# ----------

alias dls='docker container ls'
alias dkc='docker kill $(docker ps -q)'
alias ddc='docker rm $(docker ps -a -q)'
alias ddi='docker rmi $(docker images -q)'
alias ddv='docker volume rm $(docker volume ls -q)'
alias dl='docker logs'

dsh () { docker exec -it $1 sh }

_docker_containers () {
	compadd "${(@)${(f)$(docker container ls --format='{{ .Names }}')}}"
}

compdef _docker_containers dsh


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
alias krm='kubectl delete'
alias krmp='kubectl delete pod'
alias krms='kubectl delete secrets'
alias krmc='kubectl delete configmaps'
alias kpf='kubectl port-forward'
alias wkgp='watch -n 1 kubectl get pods'

kcp () { kubectl cp $1:$2 $2 }

kbd () { kubectl get deployments $1 -o yaml > $1.yaml }

knp () { kubectl get pods --all-namespaces  --no-headers --field-selector spec.nodeName=$1 }

ksh () { kubectl exec -it $1 sh }

ksn () { kubectl config set-context $(kubectl config current-context) --namespace=$1 && kubectl get pods }

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

_kube_namespaces () {
	compadd "${(@)${(f)$(kubectl get namespaces --no-headers | awk '{print $1}')}}"
}

_kube_deployments () {
	compadd "${(@)${(f)$(kubectl get deployments --no-headers | awk '{print $1}')}}"
}

_kube_pods () {
	compadd "${(@)${(f)$(kubectl get pods --no-headers | awk '{print $1}')}}"
}

compdef _kube_namespaces ksn
compdef _kube_deployments kbd
compdef _kube_pods ksh

# HELM
# ----

hgr () {
	printf '%-40s %-10s %-10s %-25s\n' "NAME" "REVISION" "STATUS" "NAMESPACE"
	helm ls | awk 'FNR > 1 { printf "%-40s %-10s %-10s %-25s\n", $1, $2, $8, $NF }'
}

alias hdr='helm delete'

# GCLOUD
# ------

snap () {
	ZONE=$(gcloud compute disks list --filter="name=($1)" --format="value(zone)")
	if [[ ! -z $2 ]]; then ZONE=$2; fi
	gcloud compute disks snapshot $1 --zone $ZONE
}

# GIT
# ---

# gpg --list-secret-keys --keyid-format LONG
# git config --global user.signingkey <key>
# git config --global commit.gpgsign true

alias g='git'
alias gaa='git add --all'
alias gst='git status'
alias gcm='git commit -sS -m'
alias gcam='git commit -sS -a -m'
alias gpush='git push'
alias gpull='git pull'
alias gf='git fetch'
alias gcfd='git clean -fd'
alias gco='git checkout'
alias gcb='git checkout -b'
alias gu='git fetch && git pull'
alias grc='git rebase --continue'
alias ghead='git rev-parse HEAD'

# GOLANG
# ------

export PATH=$PATH:/usr/local/go/bin
export GOPATH=$HOME/go
export PATH=$PATH:$GOPATH/bin
export GO111MODULE=on

alias gru='go run'
alias grd='go run .'

# RUST
# ----

source $HOME/.cargo/env


# NODE
# ----

export PATH=$PATH:$HOME/.npm-global/bin
alias mocha_ts='NODE_ENV=test TS_NODE_FILES=true mocha -r ts-node/register'

# DATABASES
# ---------

alias postgres='
  docker run --network host \
    -e "PGADMIN_DEFAULT_EMAIL=monax" \
    -e "PGADMIN_DEFAULT_PASSWORD=monax" \
    -v "/home/greg/.pgadmin:/var/lib/pgadmin" \
    -v "/home/greg/database/servers.json:/servers.json" \
    -d dpage/pgadmin4
'


#ssh-add -t 12h ~/.ssh/github

export LC_CTYPE="en_US.UTF-8"
export LC_ALL="en_US.UTF-8"

#zstyle ':completion:*' completer _complete _ignored
#zstyle :compinstall filename '/home/greg/.zshrc'

HISTFILE=~/.zsh_history
HISTSIZE=10000
SAVEHIST=10000
setopt    appendhistory
setopt    sharehistory
setopt    incappendhistory

[[ -n "${key[Up]}" ]] && bindkey "${key[Up]}" history-beginning-search-backward
[[ -n "${key[Down]}" ]] && bindkey "${key[Down]}" history-beginning-search-forward

setxkbmap gb
autoload -U up-line-or-beginning-search
autoload -U down-line-or-beginning-search
zle -N up-line-or-beginning-search
zle -N down-line-or-beginning-search
bindkey "^[[A" up-line-or-beginning-search # Up
bindkey "^[[B" down-line-or-beginning-search # Down
bindkey "\e[3~" delete-char

# session secrets
eval `keychain --agents ssh -q --eval github --eval gitlab`
[[ -f ~/.zshrc.secrets ]] && source ~/.zshrc.secrets
[[ -f ~/.zshrc.keys ]] && source ~/.zshrc.keys

# The next line updates PATH for the Google Cloud SDK.
if [ -f '/usr/local/google-cloud-sdk/path.zsh.inc' ]; then . '/usr/local/google-cloud-sdk/path.zsh.inc'; fi

# The next line enables shell command completion for gcloud.
if [ -f '/usr/local/google-cloud-sdk/completion.zsh.inc' ]; then . '/usr/local/google-cloud-sdk/completion.zsh.inc'; fi

export PATH="$HOME/.yarn/bin:$HOME/.config/yarn/global/node_modules/.bin:$PATH"
