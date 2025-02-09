# Makefile: Manage system configurations

all: help

.PHONY: help
help: ## Show this help screen.
	@awk 'BEGIN {FS = ":.*##"; printf "\nUsage:\n  make \033[36m<target>\033[0m\n"} /^[a-zA-Z0-9_-]+:.*?##/ { printf "  \033[36m%-25s\033[0m %s\n", $$1, $$2 } /^##@/ { printf "\n\033[1m%s\033[0m\n", substr($$0, 5) } ' $(MAKEFILE_LIST)

ETC := $(shell pwd)/etc
XDG_CONFIG_HOME ?= "$(HOME)/.config"

install: shell x11 apps

##@ Shell

.PHONY: shell bash git ssh gnupg tldr

shell: bash git ssh gnupg tldr
shell: ## All shell programs

bash: TARGET = "$(HOME)/.bashrc"
bash: ## Configure the bash shell
	@sudo apt -y install bash-completion direnv
	@test -L "$(TARGET)" || rm -rf "$(TARGET)"
	@ln -vsf "$(ETC)/bashrc" "$(TARGET)"

tmux: TARGET = "$(HOME)/.tmux.conf"
tmux: ## Configure the tmux shell
	@sudo apt -y install tmux
	@test -L "$(TARGET)" || rm -rf "$(TARGET)"
	@ln -vsf "$(ETC)/tmux.conf" "$(TARGET)"

git: TARGET = "$(XDG_CONFIG_HOME)/git"
git: ## Configure the Git CLI
	@test -L "$(TARGET)" || rm -rf "$(TARGET)"
	@ln -vsfn "$(ETC)/git" "$(TARGET)"

ssh: TARGET = "$(HOME)/.ssh"
ssh: ## Configure the SSH client
	@test -d "$(TARGET)" || mkdir -p "$(TARGET)"
	@test -L "$(TARGET)/config" || rm -rf "$(TARGET)/config"
	@ln -vsf "$(ETC)/ssh_config" "$(TARGET)/config"

gnupg: TARGET = "$(HOME)/.gnupg"
gnupg: ## Configure the GnuPG daemon
	@test -d "$(TARGET)" || mkdir -p "$(TARGET)"
	@chmod 0700 "$(TARGET)"
	@for item in gpg.conf gpg-agent.conf sshcontrol; do \
		ln -vsf $(ETC)/gnupg/$$item $(TARGET)/$$item; \
	done

doas: TARGET = "/etc/doas.conf"
doas: ## Configure keyd and its service
	@sudo apt-get install -y opendoas
	@sudo cp -f "$(ETC)/doas.conf" "$(TARGET)"
	@sudo chown -R root: "$(TARGET)"

tldr: TARGET = "$(XDG_CONFIG_HOME)/tealdeer"
tldr: ## Configure the tealdeer tldr page viewer
	@sudo apt -y install tealdeer
	@test -d "$(TARGET)" || mkdir -p "$(TARGET)"
	@test -L "$(TARGET)/config.toml" || rm -rf "$(TARGET)/config.toml"
	@ln -vsf "$(ETC)/tealdeer.toml" "$(TARGET)/config.toml"

##@ X11

.PHONY: x11 picom dunst spotifyd

x11: picom dunst spotifyd
x11: ## Configure X11
	@ln -vsf "$(ETC)/xinitrc" "$(HOME)/.xinitrc"
	@ln -vsf "$(ETC)/Xresources" "$(HOME)/.Xresources"

i3: TARGET = "$(XDG_CONFIG_HOME)/i3"
i3: ## Configure i3
	@test -L "$(TARGET)" || rm -rf "$(TARGET)"
	@ln -vsfn "$(ETC)/i3" "$(TARGET)"

rofi: TARGET = "$(XDG_CONFIG_HOME)/rofi"
rofi: ## Configure rofi
	@test -L "$(TARGET)" || rm -rf "$(TARGET)"
	@ln -vsfn "$(ETC)/rofi" "$(TARGET)"

picom: TARGET = "$(XDG_CONFIG_HOME)/picom.conf"
picom: ## Configure the Picom compositor
	@test -L "$(TARGET)" || rm -rf "$(TARGET)"
	@ln -vsf "${ETC}/picom.conf" "$(TARGET)"

dunst: TARGET = "$(XDG_CONFIG_HOME)/dunst"
dunst: ## Configure the Dunst notification daemon
	@test -d "$(TARGET)" || mkdir -p "$(TARGET)"
	@test -L "$(TARGET)/dunstrc" || rm -rf "$(TARGET)/dunstrc"
	@ln -vsfn "$(ETC)/dunstrc" "$(TARGET)/dunstrc"

spotifyd: TARGET = "$(XDG_CONFIG_HOME)/spotifyd.conf"
spotifyd: ## Configure the Spotify daemon
	@test -L "$(TARGET)" || rm -rf "$(TARGET)"
	@ln -vsfn "$(ETC)/spotifyd.conf" "$(TARGET)"

##@ Applications

.PHONY: apps emacs doom k9s keyd

apps: emacs k9s keyd
apps: ## Install all applications

emacs: TARGET = "$(XDG_CONFIG_HOME)/emacs"
emacs: doom ## Use Doom to configure Emacs
	@snap install emacs
	@rm -rf "$(HOME)/.emacs.d"
	@if ! test -d "$(TARGET)"; then \
		git clone https://github.com/hlissner/doom-emacs "$(TARGET)"; \
		$(TARGET)/bin/doom install; \
	fi
	@$(TARGET)/bin/doom sync

doom: TARGET = "$(XDG_CONFIG_HOME)/doom"
doom: ## Configure Doom emacs
	@test -L "$(TARGET)" || rm -rf "$(TARGET)"
	@ln -vsfn "$(ETC)/doom" "$(TARGET)"

kubectl: ## Install Kubectl
	snap install kubectl --classic

k9s: TARGET = "$(XDG_CONFIG_HOME)/k9s"
k9s: ## Configure the K9s Kubernetes UI
	@sudo apt-get install -y wget
	@wget https://github.com/derailed/k9s/releases/download/v0.32.5/k9s_linux_amd64.deb
	@sudo apt install ./k9s_linux_amd64.deb
	@rm k9s_linux_amd64.deb
	@test -L "$(TARGET)" || rm -rf "$(TARGET)"
	@ln -vsfn "$(ETC)/k9s" "$(TARGET)"

keyd: TARGET = "/etc/keyd"
keyd: ## Configure keyd and its service
	@sudo mkdir -p "$(TARGET)"
	@test -L "$(TARGET)/default.conf" || sudo rm -rf "$(TARGET)/default.conf"
	@sudo ln -vsfn "$(ETC)/keyd.conf" "$(TARGET)/default.conf"

# Makefile ends herer
