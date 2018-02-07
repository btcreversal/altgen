UNIX - create custom coin

- Please use the script altcoin.sh for new coin creation
- You can set various params in the top of the file.


  sudo apt-get install git  
  git clone https://niedoluk@bitbucket.org/niedoluk/altcoingenerator.git
  cd altcoingenerator
  # customize params in altcoin.sh
  ./altcoin.sh


  - Coin code is stored in the folder with your coins name.

  - Following files serves as configuration files for your coin generation:
      genesiscoinbase.pem
      genesiscoinbase.hex
      maingenesis.txt
      mainmerkle.txt
      mainnonce.txt
      testgenesis.txt
      testmerkle.txt
      testnonce.txt
      regrestgenesis.txt
      regtestmerkle.txt
      regtestnonce.txt

      chainparamsseeds.h should contain hard coded seed servers. This file you can generate with script placed in coin folder /contrib/seeds/generate-seeds.py

CROSS-COMPILATION

- Grab the whole "altcoingenerator" folder with already generated custom coin
- Fire up the Ubuntu 14.04
- Copy altcoingenerator to your home folder
