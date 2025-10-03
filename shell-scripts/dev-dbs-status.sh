sudo systemctl start postgresql@14-main.service
sudo systemctl status postgresql@14-main.service
sudo systemctl stop postgresql@14-main.service

sudo systemctl start mongod
sudo systemctl status mongod
sudo systemctl stop mongod

mongod --version        `# current version 7.0.24`
pg_config --version     `# current version 14.19`
