{
  pkgs,
  ...
}:
{
  environment.systemPackages = with pkgs; [
    git
    jujutsu

    # Forge clients
    forgejo-cli
    glab # GitLab CLI
    gh # GitHub CLI
  ];
}
