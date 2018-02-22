Mining pool installation
====================

# Install mono

Look at this link or if you are on Ubuntu 14.04, just follow steps below
[http://www.mono-project.com/download/stable/](Mono download)

```bash
sudo apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv-keys 3FA7E0328081BFF6A14DA29AA6A19B38D3D831EF
echo "deb http://download.mono-project.com/repo/ubuntu stable-trusty main" | sudo tee /etc/apt/sources.list.d/mono-official-stable.list
sudo apt-get update
sudo apt-get install mono-devel mono-complete mono-dbg referenceassemblies-pcl mono-xsp4 ca-certificates-mono
```

Install mysql and set up privileges. Suppose the user is root.
[https://linode.com/docs/databases/mysql/how-to-install-mysql-on-debian-7/](Mysql installation example)

```bash
mysql -u root -p
# set following
CREATE DATABASE coinium;
GRANT ALL PRIVILEGES ON coinium.* TO 'root'@'localhost' WITH GRANT OPTION;
GRANT ALL ON coinium.* TO 'root'@'localhost' WITH GRANT OPTION;
GRANT ALL ON coinium TO 'root'@'localhost' WITH GRANT OPTION;
```

Install Redis memory database

[https://www.digitalocean.com/community/tutorials/how-to-install-and-use-redis](Redis install)

Build Coinium

```bash
sudo apt-get install git
git clone https://github.com/lukasniedoba/CoiniumServ.git
cd CoiniumServ
xbuild CoiniumServ.sln /p:Configuration="Release"
cp src/CoiniumServ/Algorithms/Implementations/libyescrypt.so build/bin/Release
```
Configure coinium
[https://github.com/bonesoul/CoiniumServ/wiki/Configuration](Configure coinium)
