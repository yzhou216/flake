{
  pkgs,
  ...
}:
{
  services.emacs.enable = true;
  programs.vim.enable = true;
  environment.systemPackages = with pkgs; [ neovim ];
}
