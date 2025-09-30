# ===================================================================
# 1. ENVIRONMENT VARIABLES
# ===================================================================
# Set variabel dasar dan batas rekursi di paling awal.
export FUNCNEST=1000
export ZSH="$HOME/.oh-my-zsh"
export VOLTA_HOME="$HOME/.volta"
export ANDROID_HOME="$HOME/Android/Sdk"
export PNPM_HOME="/home/liyan/.local/share/pnpm"

# ===================================================================
# 2. PATH CONFIGURATION
# ===================================================================
# Semua modifikasi PATH dikumpulkan di sini.
# Urutan penting: Volta harus dimuat paling pertama.
export PATH="$VOLTA_HOME/bin:$PATH"
export PATH="$HOME/.cargo/bin:$PATH"
export PATH="$PNPM_HOME:$PATH"
export PATH="$HOME/.local/bin:$PATH" # Dari pipx
export PATH="$PATH:$HOME/SDKs/flutter/bin"
export PATH="$PATH:$ANDROID_HOME/platform-tools"
     export GOROOT=/usr/lib/go
    export GOPATH=$HOME/go
    export PATH=$PATH:$GOROOT/bin:$GOPATH/bin
export PATH="/usr/local/bin:$PATH"


# ===================================================================
# 3. OH MY ZSH CONFIGURATION
# ===================================================================
# Tema Oh My Zsh dinonaktifkan untuk memberi jalan pada Oh My Posh.
# ZSH_THEME="agnosterzak"

plugins=(
    git
    archlinux
    zsh-autosuggestions
    zsh-syntax-highlighting
)

# Load Oh My Zsh. Harus setelah variabel dan PATH di-set.
source $ZSH/oh-my-zsh.sh

# ===================================================================
# 4. ALIASES & FUNCTIONS
# ===================================================================
# -- General Tools --
alias cat='bat --paging=never'
alias ff="fastfetch -c $HOME/.config/fastfetch/config.jsonc"
alias st="kitty --class special_term" # Untuk scratchpad terminal

# -- eza (pengganti ls) --
if command -v eza &> /dev/null; then
    alias ls='eza --icons'
    alias l='eza -l --icons'
    alias la='eza -la --icons'
    alias lt='eza --tree --level=2 --icons'
else
    alias ls='ls --color=auto'
fi

# -- Config Shortcuts --
alias zshrc='nvim ~/.zshrc'
alias gozsh='source ~/.zshrc'
alias hyprland='nvim ~/.config/hypr/hyprland.conf'
alias hypr='cd ~/.config/hypr'
alias conf='cd ~/.config'
alias hyconf='cd ~/.config/hypr/UserConfigs'
alias hykeyb='nvim ~/.config/hypr/UserConfigs/UserKeybinds.conf'
alias hyenv='nvim ~/.config/hypr/UserConfigs/ENVariables.conf'
alias hydecor='nvim ~/.config/hypr/UserConfigs/UserDecorations.conf'
alias nvkitty='nvim ~/.config/kitty/kitty.conf'
alias cdwaybar='cd ~/.config/waybar'


alias arch='distrobox enter dev-box'
# -- Custom Functions --
mkcd () {
    mkdir -p "$@" && cd "$_";
}

# ===================================================================
# 5. TOOL INITIALIZATIONS
# ===================================================================
# Inisialisasi tool-tool interaktif di bagian paling akhir.

# -- FZF Configuration --
source /usr/share/fzf/key-bindings.zsh
source /usr/share/fzf/completion.zsh
export FZF_DEFAULT_COMMAND='rg --files --hidden --glob "!.git/*"'
export FZF_CTRL_T_OPTS="--preview 'bat -n --color=always {}' --preview-window 'right:50%:wrap'"

# -- Zoxide (Smart cd) --
eval "$(zoxide init zsh)"

# -- Oh My Posh Prompt --
#eval "$(oh-my-posh init zsh --config ~/.config/oh-my-posh/themes/quick-term.omp.json)"
eval "$(oh-my-posh init zsh --config ~/.config/oh-my-posh/themes/wallust.omp.json)"

# ===================================================================
# 6. HISTORY SETTINGS
# ===================================================================
HISTFILE=~/.zsh_history
HISTSIZE=10000
SAVEHIST=10000
setopt appendhistory

# Load custom environment variables
if [ -f ~/.keyenv ]; then
  source ~/.keyenv
fi

