{
  # std:rolling-begin
  version = "GE-Proton11-12";
  # std:variants-begin
  variants = {
    aarch64 = "sha256-0+ChUSgJa1IUl4yUIYAxP6hbY1oY48zzJYZkAcQZ/0Q=";
    x86_64 = "sha256-i20g9lDz7bR0SXWmvHZHztN4m8AHkcD0/OVGSC4ZzI8=";
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
