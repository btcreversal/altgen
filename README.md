UNIX - create custom coin

- Description of files
    config.sh ... here you can set all desired altcoin params

    00-install-dependencies.sh ... install dependencies necessary for unix build

    01-code.sh ... contains script for downloading and customizind the litecoin code

    02-compilation.sh ... compiles the coin for unix

    03-unixinstall.sh ... will install coin on your build computer

    04-crosscompilation.sh ... automatically grab libraries for win and crosscompiles for 32 and 64 bit

    DNSSeedsMain.txt ... DNSSeedNodes mainnet domains (one per line)

    DNSSeedsTest.txt ... DNSSeedNodes testnet domains (one per line)

    seeds/nodes_main.txt ... SeedNodes mainnet ips:ports (one per line)

    seeds/nodes_test.txt ... SeedNodes testnet ips:ports (one per line)

- Coin generation process

  sudo apt-get install git  
  git clone https://niedoluk@bitbucket.org/niedoluk/altcoingenerator.git
  cd altcoingenerator
  # Customize params in config.sh
  # You can customize DNSSeedNodes domains. Place them one domain per line to the DNSSeedsMain.txt file for main net and to the DNSSeedsTest.txt for testnet.
  # Also you can customize SeedNodes ips. Just place them one ip per line to the seeds/nodes_main.txt file for main net and to the seeds/nodes_test.txt for testnet
  # You just place ips and domains to the above mentioned files and script automatically generate the code
  # Run:
  ./00-install-dependencies.sh
  ./01-code.sh
  ./02-compilation.sh
  # unixinstall contains unix binaries
  # Coin code is stored in the folder with your coins name.



  - Next files which serves as configuration files for your coin generation (those are generated automatically through script and then stores all the necessary values):
      genesis/*
      magicbytes/*
      seeds/nodes_main.txt
      seeds/nodes_test.txt
      seeds/chainparamsseeds.h should contain hard coded seed servers. This file you can generate with script placed in coin folder /contrib/seeds/generate-seeds.py

UNIX INSTALL

- If you would like to install coin on your build computer just run ./03-unixinstall.sh

CROSS-COMPILATION

- Fire up the Ubuntu 14.04
- Grab the whole "altcoingenerator" folder with already generated custom coin or just clone, customize and run ./01-code.sh
- Run ./04-crosscompilation.sh
- win64install and win32install contains windows installation binaries
