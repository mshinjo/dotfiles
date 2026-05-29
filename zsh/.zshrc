# --- prompt (start) ---
autoload -Uz colors vcs_info
colors

setopt prompt_subst

# Git branch + dirty marker
zstyle ':vcs_info:*' enable git
zstyle ':vcs_info:git:*' formats ' %F{magenta} %b%f'
zstyle ':vcs_info:git:*' actionformats ' %F{magenta} %b|%a%f'

precmd() {
  vcs_info

  local git_dirty=""
  if git rev-parse --is-inside-work-tree &>/dev/null; then
    if [[ -n "$(git status --porcelain 2>/dev/null)" ]]; then
      git_dirty=" %F{yellow}●%f"
    else
      git_dirty=" %F{green}✓%f"
    fi
  fi

  PROMPT="%F{cyan}%n%f@%F{blue}%m%f %F{green}%~%f${vcs_info_msg_0_}${git_dirty}
%F{red}%#%f "
}
# --- prompt (end) ---

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
