# ----------------------
# GLOBAL ARGS
# ----------------------

# set ubuntu version
ARG OS_VERSION_ARG

# ----------------------
# MAIN
# ----------------------

FROM ubuntu:${OS_VERSION_ARG}

COPY etc /etc

# ----------------------
# MAIN ARGS
# ----------------------

ARG DEBIAN_FRONTEND=noninteractive

ARG PHP_VERSION_ARG

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

# update and install system software

RUN apt-get update &&  \
    apt-get install software-properties-common ca-certificates lsb-release apt-transport-https curl dialog gettext sudo bash -y && \
    add-apt-repository -y ppa:ondrej/php && \
    apt-get update

RUN chmod +x /etc/composer.sh && \
    envsubst < /etc/php-package-list > /etc/php-package-list-complete

RUN apt-get install $(grep -vE "^#" /etc/php-package-list-complete | tr "\n" " ") -y
RUN if [ $(echo $PHP_VERSION_ARG | head -c 1) -lt 8 ] ; then /etc/composer.sh ; else apt-get install composer -y ; fi

# add user for docker instanse
RUN groupadd -g 1000 $SYSTEM_USER_GROUP_ARG
RUN useradd -u 1000 -ms /bin/bash -g $SYSTEM_USER_GROUP_ARG $SYSTEM_USER_ARG

# ----------------------
# MAIN RESETS
# ----------------------

RUN apt autoremove

ARG DEBIAN_FRONTEND=interactive

# ----------------------

USER $SYSTEM_USER_ARG
