sudo apt-get -y update
sudo apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv 9DA31620334BD75D9DCB49F368818C72E52529D4
echo "deb [ arch=amd64 ] https://repo.mongodb.org/apt/ubuntu bionic/mongodb-org/4.0 multiverse" | sudo tee /etc/apt/sources.list.d/mongodb-org-4.0.list
sudo apt-get -y update && sudo apt-get install -y curl && curl -sL https://deb.nodesource.com/setup_12.x | sudo bash -
sudo apt-get install -y build-essential nodejs mongodb-org graphicsmagick
sudo apt-get install -y npm
sudo npm install -g inherits n && sudo n 12.14.0
curl -L https://github.com/MC2-Universe/releases/releases/download/Web-3.8.0-canary.0/universe.chat.latest.tar.gz -o /tmp/universe.chat.tgz
tar -xzf /tmp/universe.chat.tgz -C /tmp
cd /tmp/Web-3.8.0-canary.rc.0/server && npm install
sudo mv /tmp/Web-3.8.0-canary.rc.0 /var/www/universe.chat
sudo useradd -M universechat && sudo usermod -L universechat
sudo chown -R universechat:universechat /var/www/universe.chat
cat << EOF |sudo tee -a /lib/systemd/system/universechat.service
[Unit]
Description=The Universe.Chat server
After=network.target remote-fs.target nss-lookup.target nginx.target mongod.target
[Service]
ExecStart=/usr/local/bin/node /var/www/universe.chat/bundle/main.js
StandardOutput=syslog
StandardError=syslog
SyslogIdentifier=universechat
User=universechat
Environment=MONGO_URL=mongodb://localhost:27017/universechat?replicaSet=rs01 MONGO_OPLOG_URL=mongodb://localhost:27017/local?replicaSet=rs01 ROOT_URL=http://localhost:3000/ PORT=3000
[Install]
WantedBy=multi-user.target
EOF
MONGO_URL=mongodb://localhost:27017/universechat?replicaSet=rs01
MONGO_OPLOG_URL=mongodb://localhost:27017/local?replicaSet=rs01
ROOT_URL=http://localhost:3000
PORT=3000
sudo sed -i "s/^#  engine:/  engine: mmapv1/"  /etc/mongod.conf
sudo sed -i "s/^#replication:/replication:\n  replSetName: rs01/" /etc/mongod.conf
sudo systemctl enable mongod && sudo systemctl start mongod
mongo --eval "printjson(rs.initiate())"
sudo systemctl enable universechat && sudo systemctl start universechat