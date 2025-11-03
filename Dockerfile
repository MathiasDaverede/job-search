FROM debian:12.12

# Each RUN instruction in a Dockerfile creates a new layer in the resulting image.
RUN apt-get update -y && apt-get upgrade -y; \
    # debian:12.10 => Bookworm 12 => Php 8.2 (https://wiki.debian.org/PHP)
    apt-get install -y php8.2 php8.2-cli php8.2-xml php8.2-mysql php8.2-mbstring php8.2-intl; \
    # For composer
    apt-get install -y zip; \
    apt-get install -y wget; \
    apt-get install -y git; \
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

# Comment this line and rebuild if you need root access
USER "${USER_NAME}"

# When Symfony create a new project, it uses composer wich need Git setted
RUN git config --global user.name "${USER_NAME}"
RUN git config --global user.email "dev@job-search.example"

WORKDIR /home/"${USER_NAME}"/

# To create the project
RUN symfony new job-search --version="7.3.x" --webapp

# I'll use mine
RUN rm -r job-search/.git
