{
  version = "GE-Proton11-12";
  # std:variants-begin
  variants = {
    aarch64 = "sha256-0+ChUSgJa1IUl4yUIYAxP6hbY1oY48zzJYZkAcQZ/0Q=";
    x86_64 = "sha256-i20g9lDz7bR0SXWmvHZHztN4m8AHkcD0/OVGSC4ZzI8=";
  };
  # std:variants-end
  pins = {
    "GE-Proton10-34" = {
      variants = {
        x86_64 = "sha256-lzPsYYcrp5NoT3B0WFj3o10Z7tXx7xva1wEP3edeuqM=";
      };
    };
    "GE-Proton9-21" = {
      variants = {
        x86_64 = "sha256-WNOl0pu3xcEObxSK054u4e3hTWtA/51mH25uQih0+a0=";
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
  };
}
