{
  version = "GE-Proton11-6";
  # std:variants-begin
  variants = {
    aarch64 = "sha256-sIwM++9FJzpIq4LkYQDL1TIfPFEnaVowrGT/3JPfPZk=";
    x86_64 = "sha256-rX27DUrrrHtR1cgyr/424m9JPjrdASIisVGv2vWzMAs=";
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
