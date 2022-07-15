#!/bin/bash
echo Перед установкой, убедитесь, что ваш пользователь обладает правами sudo
read -p "Ваш пользователь обладает правами sudo? [y/n]: " ans
echo $ans
if  [ "$ans" = "y" ]; then
        echo "ok"
else
        echo "warning"
        exit 1
fi
echo Обновление данных...
sudo apt update
sudo apt -y upgrade
echo Обновление завершено 

echo Установка Apache...
sudo apt install -y apache2 apache2-utils 
sudo systemctl enable apache2
sudo systemctl start apache2
echo Установка завершена 

echo Установка UFW...
sudo apt install -y ufw
echo Установка завершена 

echo Установка дефолтных настройки UFW...
sudo ufw default deny incoming
sudo ufw default allow outgoing
echo Настройка завершена 

echo Настройка UFW...
sudo ufw allow ssh
sudo ufw allow http
sudo ufw allow https
echo Настройка завершена 

echo Включение UFW...
sudo ufw enable 
echo Включение завершено 

hostname=$(hostname)
echo Создание директории сайта...
sudo mkdir -p /var/www/$hostname
echo Директория создана если не существовала 

echo Установка прав пользователя на директорию сайта... 
sudo chown -R $USER:$USER /var/www/$hostname
sudo chmod -R 755 /var/www/$hostname
echo Вы являетесь владельцем директории нового сайта 

echo Создание конфигурационного файла...
touch $hostname.conf
cat > $hostname.conf << EOF
<VirtualHost *:80>
    ServerAdmin $USER@localhost
    ServerName $hostname
    ServerAlias $hostname
    DocumentRoot /var/www/$hostname
    ErrorLog ${APACHE_LOG_DIR}/error.log
    CustomLog ${APACHE_LOG_DIR}/access.log combined
</VirtualHost>
EOF
sudo mv ~/$hostname.conf /etc/apache2/sites-available/$hostname.conf
echo Создание конфигурационного файла завершено 

echo Установка базы данных MariaDB...
sudo apt install -y mariadb-client mariadb-server
sudo mysql_secure_installation
echo Установка завершена 

echo Системе требуются некоторые данные...
read -p "Введите пароль пользователя mariaDB (определен при установке): " pmdb
read -p "Введите название базы данных mariaDB: " newdb
read -p "Введите имя пользователя новой базы данных: " userdb
read -p "Введите пароль пользователя новой базы данных: " userpass
echo Данные записаны в систему 

echo Создание нового пользователя и базу данных...
sudo mysql -uroot -p$pmdb -e "CREATE DATABASE $newdb"
sudo mysql -uroot -p$pmdb -e "CREATE USER '$userdb'@'localhost' IDENTIFIED BY '$userpass'; GRANT ALL PRIVILEGES ON $newdb.* TO '$userdb'@'localhost'; FLUSH PRIVILEGES;"
echo Создание завершено 

echo Установка PHP...
sudo apt install -y php7.4 php7.4-mysql libapache2-mod-php7.4 php7.4-cli php7.4-cgi php7.4-gd
echo Установка завершена 

echo Создание стартового файла php...
sudo touch info.php
cat > info.php << EOF
<?php
phpinfo();
?>
EOF
sudo mv ~/info.php /var/www/$hostname/info.php
echo Создание файла завершено 

echo Подключение сайта...
sudo a2ensite $hostname
echo Подключено 

echo Перезагрузка Apache...
sudo systemctl restart apache2
echo ОК 

echo Выключение дефолтного сайта...
sudo a2dissite 000-default.conf
sudo apache2ctl configtest
sudo a2enmod rewrite
echo ОК 

echo Перезагружаем Apache...
sudo systemctl restart apache2
echo ОК 

echo Начинаем установку Wordpress...
sudo wget -c http://wordpress.org/latest.tar.gz
sudo tar -xzvf latest.tar.gz
sudo rsync -av wordpress/* /var/www/$hostnamename.* 
sudo chown -R www-data:www-data /var/www/$hostnamename
sudo chmod -R 755 /var/www/$hostnamename