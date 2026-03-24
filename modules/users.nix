_:
{
  users.users.pi = {
    isNormalUser = true;
    extraGroups = [ "wheel" ];
    initialPassword = "raspberry";
  };
}
