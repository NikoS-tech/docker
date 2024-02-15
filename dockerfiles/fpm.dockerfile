# ----------------------
# GLOBAL ARGS
# ----------------------

# set ubuntu version
ARG PHP_VERSION_ARG

# ----------------------
# MAIN
# ----------------------

FROM php:${PHP_VERSION_ARG}-fpm

# ----------------------
# MAIN ARGS
# ----------------------

ARG DEBIAN_FRONTEND=noninteractive

ARG SYSTEM_USER_ARG
ARG SYSTEM_USER_GROUP_ARG

# ----------------------
# MAIN ENVS
# ----------------------

ENV LC_ALL=C.UTF-8

ENV TZ=Etc/UTC

ENV PHP_VERSION_ENV=$PHP_VERSION_ARG

# ----------------------
# MAIN ARGS
# ----------------------

WORKDIR /var/www

# update and install system software

RUN apt-get update && apt-get install build-essential locales curl sudo bash -y

# add user for docker instanse
# add user for docker instanse
RUN groupadd -g 1000 $SYSTEM_USER_GROUP_ARG
RUN useradd -u 1000 -ms /bin/bash -g $SYSTEM_USER_GROUP_ARG $SYSTEM_USER_ARG

COPY ./projects /var/www

# ----------------------
# MAIN RESETS
# ----------------------

RUN apt autoremove

ARG DEBIAN_FRONTEND=interactive

# ----------------------

USER $SYSTEM_USER_ARG

EXPOSE 9000

CMD ["php-fpm"]
