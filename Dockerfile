FROM debian:12.12

# Each RUN instruction in a Dockerfile creates a new layer in the resulting image.
RUN apt-get update -y && apt-get upgrade -y; \
    apt-get install -y apache2; \
    # debian:12.10 => Bookworm 12 => Php 8.2 (https://wiki.debian.org/PHP)
    apt-get install -y php8.2 php8.2-cli php8.2-xml php8.2-mysql php8.2-mbstring php8.2-intl; \
    # For composer
    apt-get install -y zip; \
    apt-get install -y wget; \
    # Clean temporary files
    rm -rf /var/lib/apt/lists/*; \
    apt-get purge -y --auto-remove; \
    apt-get autoremove; \
    apt-get clean;

# For Composer commands (composer install, etc.)
COPY --from=composer:2.2.25 /usr/bin/composer /usr/bin/composer

# For Symfony commands (symfony check:requirements, etc.)
RUN wget https://get.symfony.com/cli/installer -O - | bash; \
    mv /root/.symfony5/bin/symfony /usr/local/bin/symfony;

ARG USER_NAME
ARG USER_ID
ARG GROUP_ID

RUN addgroup ${USER_NAME} --gid ${GROUP_ID}; \
    useradd ${USER_NAME} --uid ${USER_ID} --gid ${GROUP_ID} --create-home;

# AH00558: apache2: Could not reliably determine the server's fully qualified domain name, using x.x.x.x. Set the 'ServerName' directive globally to suppress this message
RUN echo "ServerName localhost" > /etc/apache2/conf-available/servername.conf; \
    a2enconf servername.conf;

COPY ./docker/server/apache/site.conf /etc/apache2/sites-available/000-default.conf

RUN chown -R ${USER_NAME} /var/run/apache2/ /var/log/apache2/

# Comment this line and rebuild if you need root access
USER "${USER_NAME}"

WORKDIR /var/www/

CMD ["/usr/sbin/apache2ctl", "-D", "FOREGROUND"]
