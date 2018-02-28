sudo cat >> /lib/systemd/system/pool.service <<EOF
[Unit]
Description=CoiniumServ pool service
After=network.target local-fs.target postgresql.service


[Service]
Type=simple
User=root
WorkingDirectory=/root/coiniumservyescrypt/build/bin/Release/
ExecStart=mono /root/coiniumservyescrypt/build/bin/Release/CoiniumServ.exe
Restart=always

[Install]
WantedBy=multi-user.target
EOF
