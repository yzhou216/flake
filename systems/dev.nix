{
  pkgs,
  ...
}:
{
  environment.systemPackages = with pkgs; [
    # source code tagging
    universal-ctags
    cscope

    # toolchain
    gcc
    gdb
    gnumake
    cmake
    libtool

    # manuals
    man-pages
    man-pages-posix

    # C
    libclang
    bear

    # Bash
    bash-language-server
    shfmt

    # Rust
    rustup
    bacon
    dioxus-cli

    # Go
    go
    gopls
    delve
    gofumpt
    golines

    # Lisp
    guile
    akkuPackages.scheme-langserver
    racket
    sbcl

    # Python
    rustpython
    uv
    pylyzer
    python3.pkgs.debugpy

    # Haskell
    ihaskell # bin/ghci
    haskellPackages.stack
    haskellPackages.haskell-language-server

    # Java
    temurin-bin # OpenJDK
    jdt-language-server

    # WWW
    vscode-langservers-extracted

    # SQL
    sqlite
    sqls

    # Markdown
    glow
    marksman

    # Nix
    nil
    nixfmt-rfc-style
    devenv
  ];
}
