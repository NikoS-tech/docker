# Docker compose for laravel local development

## Starter guide

In order to start local development:

1. [Install docker and docker compose plugin](#docker-installation-for-ubuntu)
2. [Run docker compose](#run-docker-compose)
3. [Setup new laravel project](#setup-new-laravel-project)
4. [Setup nginx config](#setup-nginx-config)

### Docker installation for Ubuntu

```shell
sudo apt-get update
sudo apt-get install docker.io -y
sudo apt-get install docker-compose-plugin -y
```

Check installed versions:

```shell
sudo docker -v
sudo docker compose version
```

### Run docker compose

Build docker compose (once, while has no changes in dockerfiles):

```shell
docker compose build --build-arg SYSTEM_USER_ARG=$(id -un) --build-arg SYSTEM_USER_GROUP_ARG=$(id -gn)
```

Run demonized (in background) docker compose:

```shell
docker compose up -d
```

### Setup new laravel project

#### Create laravel instance

```shell
docker exec -ti app /bin/sh
composer create-project laravel/laravel $PROJECT_NAME
cd $PROJECT_NAME
```

Depending on laravel version, you may need to run:

```shell
chmod -R 777 storage/
php artisan key:generate
```

- ``$PROJECT_NAME`` - abstract variable which should be replaced with real project name.  
  F.x. use ``example-app`` instead

#### Set laravel instance .env

Set `APP_URL` value in `.env` as a local link you want:

```dotenv
APP_URL=http://$PROJECT_URL
```

F.x `$PROJECT_URL` may be `test.laravel.loc`. 
`$PROJECT_URL` will be used for ngix conf setup and local hosts alias list. 

Replace `DB_HOST` value in `.env` with `db`:

```dotenv
DB_HOST=db
```

Set `DB_PASSWORD` value as `SQL_ROOT_PASSWORD` variable from `.env` in project root dir:

```dotenv
DB_PASSWORD=root
```

Fully customize all other variables in `.env` if needed:

```dotenv
...
APP_NAME=my_project
...
DB_DATABASE=my_database
...
```

#### Run migration command

```shell
php artisan migrate
```

- Depending on laravel version, you may need to create database manually before migration command run.

Exit from the docker container: 

```shell
exit
```

### Setup nginx config

Copy example as a config file:

```shell
cp ./configs/nginx/app.conf.example ./configs/nginx/app.conf
```

Change `server_name` option value to `$PROJECT_URL`:

```
server_name test.laravel.loc;
```

Change `root` option value to `/var/www/$PROJECT_NAME/public`:

```
root /var/www/example-app/public;
```

Restart webserver:

```shell
docker compose restart webserver
```

Add to `/etc/hosts` file line `127.0.0.1 $PROJECT_URL`:

```
...
127.0.0.1 test.laravel.loc
...
```

Browse your application using link as `http://$PROJECT_URL/` 
F.x.: `http://test.laravel.loc/`

## Helpful commands

Build all docker compose servers:

```shell
docker compose build
```

Build only fpm docker compose server:

```shell
docker compose build fpm
```

Build only fpm docker compose server passing custom args list:

```shell
docker compose build --build-arg ARG1=VALUE1 --build-arg ARG2=VALUE2 ... fpm
```

Start all docker compose servers:

```shell
docker compose up
```

Start all docker compose servers in a background:

```shell
docker compose up -d
```

Restart docker compose servers:

```shell
docker compose restart
```

Restart docker compose server:

```shell
docker compose restart app
docker compose restart webserver
```

Connect to docker compose server cli:

```shell
docker exec -ti app /bin/sh
docker exec -ti node /bin/sh
```

Connect to `phpmyadmin` by `http://localhost:8090/` link.

