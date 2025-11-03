# Recherche d'emploi

![Docker](https://img.shields.io/badge/Docker-28.1-blue)
![Symfony](https://img.shields.io/badge/Symfony-7.3-blue)
![PHP](https://img.shields.io/badge/PHP-8.2-777BB4)
![License](https://img.shields.io/badge/License-MIT-green)

Outil pour générer des lettres de motivation en PDF et regrouper des liens utiles aux développeurs.

## Prérequis

- Git
- Docker et Docker Compose

## Contact

Retrouvez-moi sur [LinkedIn](https://www.linkedin.com/in/mathias-daverede) pour discuter de ce projet ou d'opportunités professionnelles !

> [!IMPORTANT]
> Le dossier du projet est monté en tant que données persistantes,  
> ce qui signifie que tout ce que vous ajoutez/modifiez/supprimez dans /var/www/ (du conteneur),  
> le sera également dans le dossier du projet !
>
> **Extrait de [compose.yaml](compose.yaml) :**
>
> ```yaml
> services:
>   web:
>     volumes:
>       - .:/var/www/
> ```

## Sommaire

[Versions du projet](#versions-du-projet)  
[Initialiser le projet](#initialiser-le-projet)

## Versions du projet

Créé depuis un environnement Windows 11 / WSL2 (Ubuntu 24.04).

### Docker

Docker version 28.1.1  
Docker Compose version v2.35.1-desktop.1

### Images

Web : Debian 12.12 (Bookworm 12)

### Projet

Composer 2.2.25  
Symfony 7.3  
Php 8.2

## Initialiser le projet

### Cloner le projet

`git clone git@github.com:MathiasDaverede/job-search.git`

## Créez un fichier .env.local à la racine du projet

Pour que le projet Symfony soit créé avec les droits de l'utilisateur connecté dans le conteneur.
USER_NAME=votre_nom_d_utilisateur (`whoami`)  
USER_ID=votre_uid (`id -u`)  
GROUP_ID=votre_gid (`id -g`)

### Démarrer le projet

Se placer dans le projet :  
`cd emplacement/job-search/`

Construire l'image et démarrer le conteneur en mode détaché :  
`docker compose --env-file .env.local up -d`

Se connecter au conteneur  
`docker exec -it job-search-web-1 bash`

Vérifier que le projet Symfony ait bien été créé :  
`ls -la job-search/`

Potentiellement, lancer les commandes :  
`cd job-search/`  
`composer install` (mais dans notre cas les dépendances ont déjà été installées)  
`symfony check:requirements`  
`symfony check:security`  
`bin/console importmap:audit`

Prochaine étape pour la feature suivante :  
Déplacer le contenu du projet Symfony dans notre dossier de travail :  
(toujours en étant dans le conteneur `docker exec -it job-search-web-1 bash`)  
`cp -rp job-search/. /var/www/`

Et faire quelques ajustements pour afficher la page d'accueil.
