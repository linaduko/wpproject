#!/bin/bash

#Запрос на наличие прав суперпользователя у текущего пользователя системы
echo "Before installation make sure that your user has sudo rights"
read -p "Does your user have sudo rights? [y/n]: " ans

if  [ "$ans" = "y" ]; then
        echo "Start wpproject script!"
else
        echo "Warning, get root rights or check the correctness of the entered data and try again"
        exit 1
fi

#Обновление базы данных доступных пакетов
echo "Data update..."
sudo apt update
sudo apt -y upgrade
echo "Completed!"

#Установка Apache
echo "Apache installation..."
sudo apt install -y apache2 apache2-utils
sudo systemctl enable apache2
sudo systemctl start apache2
echo "Completed!"

#Установка UWF - инструментария для настройки и управления брандмауэром
echo "UFW installation..."
sudo apt install -y ufw
echo "Completed!"

#Установка UWF - значений по умолчанию
echo "UWF default setting..."
sudo ufw default deny incoming
sudo ufw default allow outgoing
echo "Completed!"

#Специфическая настройка UWF
echo "UFW setting..."
sudo ufw allow ssh
sudo ufw allow http
sudo ufw allow https
echo "Completed!"

#Включение UWF
echo "Enable UWF..."
sudo ufw enable
echo "Completed!"

#Создание директории для хранения файлов буудщего сайта
hostname=$(hostname)
echo "Creating a site directory..."
sudo mkdir -p /var/www/$hostname
echo "The directory was created if didn't exist..."

#Добавление информации в файл /etc/hosts
echo "Adding information to a file /etc/hosts"
sudo -- sh -c "echo 127.0.0.1 $hostname >> /etc/hosts"
echo "Completed!"

#Настройка текущего пользователя для директории сайта
echo "Setting user rights to the site directory..."
sudo chown -R $USER:$USER /var/www/$hostname
sudo chmod -R 755 /var/www/$hostname
echo "Completed!" 

#Сoздание конфигурационного файла
echo "Creation a configuration file..."
currentdir=$(pwd)
touch $currentdir/$hostname.conf
cat > $currentdir/$hostname.conf << EOF
<VirtualHost *:80>
    ServerAdmin $USER@localhost
    ServerName $hostname
    ServerAlias $hostname
    DocumentRoot /var/www/$hostname
    ErrorLog ${APACHE_LOG_DIR}/error.log
    CustomLog ${APACHE_LOG_DIR}/access.log combined
</VirtualHost>
EOF
sudo mv $currentdir/$hostname.conf /etc/apache2/sites-available/$hostname.conf
echo "Completed!"

#Установка СУБД MariaDB
echo "MariaDB installation"
sudo apt install -y mariadb-client mariadb-server
sudo mysql_secure_installation
echo "Completed!"

#Запрос данных от пользователя для настройки СУБД
echo "The system is asking for some data..."
read -p "Enter MariaDB root-user password: " pmdb
read -p "Enter a name for the new mariaDB database: " newdb
read -p "Enter username of the new database: " userdb
read -p "Enter the password for user of the new database: " userpass
echo "Data saved in the system!"

#Создание базы данных, пользователя БД и определение его прав
echo "Create a new database and a user for it..."
sudo mysql -uroot -p$pmdb -e "CREATE DATABASE $newdb"
sudo mysql -uroot -p$pmdb -e "CREATE USER '$userdb'@'localhost' IDENTIFIED BY '$userpass'; GRANT ALL PRIVILEGES ON $newdb.* TO '$userdb'@'localhost'; FLUSH PRIVILEGES;"
echo "Completed!"

#Установка PHP
echo "PHP installation..."
sudo apt install -y php7.4 php7.4-mysql libapache2-mod-php7.4 php7.4-cli php7.4-cgi php7.4-gd
echo "Completed!"

#Создание стартового php-файла (anyone directory ver.)
echo "Creating a start php file..."
sudo touch $currentdir/info.php
cat > info.php << EOF
<?php
phpinfo();
?>
EOF
sudo mv $currentdir/info.php /var/www/$hostname/info.php
echo "Completed!"

#Подключение нового сайта
echo "Site connection..."
sudo a2ensite $hostname
echo "Completed!"

#Перезапуск Apache
echo "Restart Apache..."
sudo systemctl restart apache2
echo "Completed!"

#Отключение дефолтного сайта
echo "Disabling the default site..."
sudo a2dissite 000-default.conf
sudo apache2ctl configtest
sudo a2enmod rewrite
echo "Completed!"

#Перезапуск Apache
echo "Restart Apache..."
sudo systemctl restart apache2
echo "Completed!"

#Установка Wordpress
echo "Wordpress installation..."
sudo wget -c http://wordpress.org/latest.tar.gz
sudo tar -xzvf latest.tar.gz
sudo mv wordpress/* /var/www/$hostname/
sudo chown -R www-data:www-data /var/www/$hostname
sudo chmod -R 755 /var/www/$hostname
sudo rm -rf latest.tar.gz wordpress
echo "Completed!"

