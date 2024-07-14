{...}:
{
services.static-web-server = {
  enable = true;
  root = builtins.toString ./.;
};
}
