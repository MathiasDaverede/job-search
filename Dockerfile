FROM debian:12.12

RUN apt-get upgrade -y && apt-get update -y

# debian:12.10 => Bookworm 12 => Php 8.2 (https://wiki.debian.org/PHP)
RUN apt-get install -y php8.2 php8.2-cli php8.2-xml php8.2-mysql php8.2-mbstring php8.2-intl

# For composer
RUN apt-get install -y zip

RUN apt-get install -y wget git

RUN rm -rf /var/lib/apt/lists/*; \
    apt-get purge -y --auto-remove; \
    apt-get autoremove; \
    apt-get clean;

COPY --from=composer:2.2.25 /usr/bin/composer /usr/bin/composer

RUN wget https://get.symfony.com/cli/installer -O - | bash
RUN mv /root/.symfony5/bin/symfony /usr/local/bin/symfony

ARG USER_NAME
ARG USER_ID
ARG GROUP_ID

RUN echo "_________________________"
RUN echo "USER_NAME : ${USER_NAME}"
RUN echo "USER_ID   : ${USER_ID}"
RUN echo "GROUP_ID  : ${GROUP_ID}"
RUN echo "_________________________"

RUN addgroup ${USER_NAME} --gid ${GROUP_ID}
RUN adduser ${USER_NAME} --uid ${USER_ID} --gid ${GROUP_ID}

USER "${USER_NAME}"

# When Symfony create a new project, it uses composer wich need Git setted
RUN git config --global user.name "${USER_NAME}"
RUN git config --global user.email "dev@job-search.example"

WORKDIR /home/"${USER_NAME}"/

# To create the project
RUN symfony new job-search --version="7.3.x" --webapp

# I'll use mine
RUN rm -r job-search/.git