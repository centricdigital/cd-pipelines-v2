FROM php:7-cli

# Let the container know that there is no tty
#ENV DEBIAN_FRONTEND noninteractive
ENV COMPOSER_NO_INTERACTION 1

RUN add-apt-repository ppa:ondrej/php

# Update Distro
RUN apt-get update \
    && apt-get install -my \
       wget \
       git \
       libpng-dev \
       gnupg \
       jq \
       zip \
       unzip \
       php7.2-gd 

# Install Composer
RUN curl -sS https://getcomposer.org/installer \
	  -o composer-setup.php \
	&& php composer-setup.php \
		--install-dir=/usr/local/bin \
		--filename=composer

# Install Node & NPM
RUN curl -sL https://deb.nodesource.com/setup_8.x | bash - \
    	&& apt-get install -y nodejs

# Install aws-cli
RUN curl "https://s3.amazonaws.com/aws-cli/awscli-bundle.zip" -o "awscli-bundle.zip" \
    && unzip awscli-bundle.zip \
    && ./awscli-bundle/install -b ~/bin/aws \
    && export PATH=~/bin:$PATH \
    && ln -s ~/bin/aws /usr/bin/aws

# Download ECS deployer and install
RUN curl https://s3-us-west-2.amazonaws.com/cdg-devops/ecs-deploy -o /tmp/ecs-deploy  \
    && chmod +x /tmp/ecs-deploy
