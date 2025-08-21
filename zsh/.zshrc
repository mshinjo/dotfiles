# --- theme (Powerlevel10k) (start) ---
# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi
source ~/.zsh/powerlevel10k/powerlevel10k.zsh-theme
[[ -f ~/.p10k.zsh ]] && source ~/.p10k.zsh
# --- theme (Powerlevel10k) (end) ---

# --- paths & editor (start) ---
export PATH="$HOME/bin:$PATH"
export EDITOR='emacs'
# --- paths & editor (end) ---

# --- aliases (start) ---
alias ll='ls -alF'
alias la='ls -A'
alias l='ls -CF'
alias e='emacs -nw'
# --- aliases (end) ---

# --- history (start) ---
HISTSIZE=10000
SAVEHIST=10000
HISTFILE=~/.zsh_history
# --- history (end) ---

# --- completion (start) ---
autoload -Uz compinit
compinit
# --- completion (end) ---

# --- autosuggestions (start) ---
AUTOSUGGESTIONS="/usr/share/zsh-autosuggestions/zsh-autosuggestions.zsh"
[[ -f "$AUTOSUGGESTIONS" ]] && source "$AUTOSUGGESTIONS"
# --- autosuggestions (end) ---

# --- syntax highlighting (start) ---
SYNTAX_HIGHLIGHTING="/usr/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh"
[[ -f "$SYNTAX_HIGHLIGHTING" ]] && source "$SYNTAX_HIGHLIGHTING"
# --- syntax highlighting (end) ---

# --- misc (start) ---
export GPG_TTY=$(tty)
WORDCHARS='*?_-.[]~=&;!#$%^(){}<>'
# --- misc (end) ---
