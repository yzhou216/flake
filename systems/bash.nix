{
  pkgs,
  lib,
  ...
}:
let
  # Remove new line character from default prompt PS1
  # Show git branch in Bash PS1
  bashPrompt = ''
    if [ "$TERM" != "dumb" ] || [ -n "$INSIDE_EMACS" ]; then
      PROMPT_COLOR="1;31m"
      ((UID)) && PROMPT_COLOR="1;32m"
      if [ -n "$INSIDE_EMACS" ]; then
        # Emacs term mode doesn't support xterm title escape sequence (\e]0;)
        PS1="\[\033[$PROMPT_COLOR\][\u@\h:\w]\\$\[\033[0m\] "
      else
        PS1='\[\033[$PROMPT_COLOR\][\[\e]0;\u@\h: \w\a\]\u@\h:\w$(source ${lib.getBin pkgs.git}/share/bash-completion/completions/git-prompt.sh; __git_ps1 " (%s)")]\\$\[\033[0m\] '
      fi
      if test "$TERM" = "xterm"; then
        PS1="\[\033]2;\h:\u:\w\007\]$PS1"
      fi
    fi
  '';
  inherit (pkgs) stdenv;
in
{
  programs.bash = {
    enable = true;
    completion.enable = true;
  }
  // (
    if stdenv.isLinux then
      { promptInit = bashPrompt; }
    else if stdenv.isDarwin then
      { interactiveShellInit = bashPrompt; }
    else
      { }
  );
}
