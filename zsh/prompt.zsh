autoload colors && colors
# cheers, @ehrenmurdick
# http://github.com/ehrenmurdick/config/blob/master/zsh/prompt.zsh

if (( $+commands[git] ))
then
  git="$commands[git]"
else
  git="/usr/bin/git"
fi

git_branch() {
  echo $($git symbolic-ref HEAD 2>/dev/null | awk -F/ {'print $NF'})
}

git_dirty() {
  st=$($git status 2>/dev/null | tail -n 1)
  if [[ $st == "" ]]
  then
    echo ""
  else
    if [[ "$st" =~ ^nothing ]]
    then
      echo "on %{$fg_bold[green]%}$(git_prompt_info)%{$reset_color%}"
    else
      echo "on %{$fg_bold[red]%}$(git_prompt_info)%{$reset_color%}"
    fi
  fi
}

git_prompt_info () {
 ref=$($git symbolic-ref HEAD 2>/dev/null) || return
# echo "(%{\e[0;33m%}${ref#refs/heads/}%{\e[0m%})"
 echo "${ref#refs/heads/}"
}

unpushed () {
  $git cherry -v @{upstream} 2>/dev/null
}

need_push () {
  if [[ $(unpushed) == "" ]]
  then
    echo " "
  else
    echo " with %{$fg_bold[magenta]%}unpushed%{$reset_color%} "
  fi
}

py_prompt() {
  [ $VIRTUAL_ENV ] && echo "%{$fg[cyan]%}py:%{$reset_color%}%{$fg_bold[cyan]%}$(basename $VIRTUAL_ENV)%{$reset_color%}%{$fg[cyan]%}/%{$reset_color%}"
}

rb_prompt() {
  if (( $+commands[rbenv] ))
  then
    echo "%{$fg[red]%}rb:%{$reset_color%}%{$fg_bold[red]%}$(rbenv gemset active 2>/dev/null | awk '{print $1}')@$(rbenv version | awk '{print $1}')%{$reset_color%}%{$fg[red]%}/%{$reset_color%}"
	else
	  echo ""
  fi
}

directory_name(){
  echo "%{$fg_bold[cyan]%}%1/%\/%{$reset_color%}"
}

export PROMPT=$'\n$(py_prompt) $(rb_prompt) in $(directory_name) $(git_dirty)$(need_push)› '
set_prompt () {
  export RPROMPT="%{$fg_bold[cyan]%}%{$reset_color%}"
}

precmd() {
  title "zsh" "%m" "%55<...<%~"
  set_prompt
}
