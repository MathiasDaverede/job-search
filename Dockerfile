FROM debian:12.12

RUN apt-get upgrade -y && apt-get update -y

RUN apt-get install -y apache2

# debian:12.10 => Bookworm 12 => Php 8.2 (https://wiki.debian.org/PHP)
RUN apt-get install -y php8.2 php8.2-cli php8.2-xml php8.2-mysql php8.2-mbstring php8.2-intl

# For composer
RUN apt-get install -y zip

RUN apt-get install -y wget

# Allow to view the commands manuals
RUN apt-get install -y man

RUN apt-get install -y vim

# ifconfig, arp, netstat, nameif, route.
RUN apt-get install net-tools

RUN rm -rf /var/lib/apt/lists/*; \
    apt-get purge -y --auto-remove; \
    apt-get autoremove; \
    apt-get clean;

# For Composer commands (composer install, etc.)
COPY --from=composer:2.2.25 /usr/bin/composer /usr/bin/composer

# For Symfony commands (symfony check:requirements, etc.)
RUN wget https://get.symfony.com/cli/installer -O - | bash
RUN mv /root/.symfony5/bin/symfony /usr/local/bin/symfony

ARG USER_NAME
ARG USER_ID
ARG GROUP_ID

RUN addgroup ${USER_NAME} --gid ${GROUP_ID}
RUN adduser ${USER_NAME} --uid ${USER_ID} --gid ${GROUP_ID}

# AH00558: apache2: Could not reliably determine the server's fully qualified domain name, using x.x.x.x. Set the 'ServerName' directive globally to suppress this message
RUN touch /home/apache2.conf
RUN echo "ServerName localhost" > /home/apache2.conf
RUN mv  /home/apache2.conf /etc/apache2/conf-available/
RUN a2enconf apache2.conf

COPY ./docker/server/apache/site.conf /etc/apache2/sites-available/000-default.conf

RUN chown -R ${USER_NAME} /var/run/apache2/
RUN chown -R ${USER_NAME} /var/log/apache2/

# Comment this line and rebuild if you need root access
USER "${USER_NAME}"

WORKDIR /var/www/

CMD ["/usr/sbin/apache2ctl", "-D", "FOREGROUND"]
