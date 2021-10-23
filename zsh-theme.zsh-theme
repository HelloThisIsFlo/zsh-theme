# ZSH Theme - Preview: http://gyazo.com/8becc8a7ed5ab54a0262a470555c3eed.png
local return_code="%(?..%{$fg[red]%}%? ↵%{$reset_color%})"


if [[ $UID -eq 0 ]]; then
    local user_host='%{$terminfo[bold]$fg[red]%}%n@%m%{$reset_color%}'
    local user_symbol='#'
else
    local user_host='%{$terminfo[bold]$fg[green]%}%n@%m%{$reset_color%}'
    local user_symbol='$'
fi

local current_dir='%{$terminfo[bold]$fg[blue]%}%~%{$reset_color%}'

# Ruby
local rvm_ruby=''
if which rvm-prompt &> /dev/null; then
  rvm_ruby='%{$fg[red]%}‹$(rvm-prompt i v g)›%{$reset_color%}'
else
  if which rbenv &> /dev/null; then
    rvm_ruby='%{$fg[red]%}‹$(rbenv version | sed -e "s/ (set.*$//")›%{$reset_color%}'
  fi
fi


# Python - Pipenv
local pipenv_python=''
if which pipenv &> /dev/null; then
    if [ "$PIPENV_ACTIVE" = 1 ]; then
        local venv="$(echo $VIRTUAL_ENV | sed 's/.*\///' | sed 's/-.*//')"
        pipenv_python="%{$fg[magenta]%}‹Pipenv: $venv›%{$reset_color%}"
    fi
fi

# AWS Cli
aws_active_profile="☁️  %{$fg[cyan]%}$AWS_PROFILE%{$reset_color%}"

function git_info {
    CODURANCE_EMR_PROJECT='emr'
    if [[ $PWD =~ $CODURANCE_EMR_PROJECT ]]; then
        echo "%{[33m%}‹Skipped: EMR>%{[00m%}"
    else
        printf '$(git_prompt_info)'
    fi
}

PROMPT="╭─${user_host} ${current_dir} ${rvm_ruby} $(git_info)"
PROMPT="$PROMPT
│ $aws_active_profile"
if [ "$pipenv_python" != "" ]; then
    PROMPT="$PROMPT ${pipenv_python}"
fi
PROMPT="$PROMPT
╰─%B${user_symbol}%b "

RPS1="%B${return_code}%b"

ZSH_THEME_GIT_PROMPT_PREFIX="%{$fg[yellow]%}‹"
ZSH_THEME_GIT_PROMPT_SUFFIX="› %{$reset_color%}"
