{
  pkgs,
  ...
}:
{
  environment.systemPackages = with pkgs; [
    git
    jujutsu

    # Forge clients
    codeberg-cli
    glab # GitLab CLI
    gh # GitHub CLI
  ];
}
