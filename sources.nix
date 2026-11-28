{
  # std:rolling-begin
  version = "GE-Proton11-14";
  # std:variants-begin
  variants = {
    aarch64 = {
      url = "https://github.com/GloriousEggroll/proton-ge-custom/releases/download/GE-Proton11-14/GE-Proton11-14-aarch64.tar.gz";
      hash = "sha256-n51sElFtNZQRJOpWdH1jpg+H0Wq7Q6TjCtg1wl3a44Y=";
    };
    x86_64 = {
      url = "https://github.com/GloriousEggroll/proton-ge-custom/releases/download/GE-Proton11-14/GE-Proton11-14-x86_64.tar.gz";
      hash = "sha256-Bru3l0AqrvDl+XYC1dYhmy5XqKP49yFjWVJwZzel60Q=";
    };
  };
  # std:variants-end
  # std:rolling-end
  pins = {
    # std:pins-begin
    "GE-Proton10-34" = {
      variants = {
        x86_64 = "sha256-lzPsYYcrp5NoT3B0WFj3o10Z7tXx7xva1wEP3edeuqM=";
      };
    };
    "GE-Proton9-27" = {
      variants = {
        x86_64 = "sha256-70au1dx9co3X+X7xkBCDGf1BxEouuw3zN+7eDyT7i5c=";
      };
    };
    "GE-Proton8-32" = {
      variants = {
        x86_64 = "sha256-ZBOF1N434pBQ+dJmzfJO9RdxRndxorxbJBZEIifp0w4=";
      };
    };
    "GE-Proton7-55" = {
      variants = {
        x86_64 = "sha256-6CL+9X4HBNoB/yUMIjA933XlSjE6eJC86RmwiJD6+Ws=";
      };
    };
    # std:pins-end
  };
}
