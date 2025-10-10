# Recherche d'emploi
<a name="top"></a>

![Docker](https://img.shields.io/badge/Docker-28.1-blue)
![Symfony](https://img.shields.io/badge/Symfony-7.3-blue)
![License](https://img.shields.io/badge/License-MIT-green)

Outil pour générer des lettres de motivation en PDF et regrouper des liens utiles pour développeurs. 

> [!IMPORTANT]
> Le dossier du projet est monté en tant que données persistantes.  
> Ce qui signifie que tout ce que vous ajoutez/modifiez/supprimez dans /var/www/ (du conteneur),  
> le sera également dans le dossier du projet !
> - compose.yaml :
>   - services:
>     - web:
>       - volumes:
>          - .:/var/www/

[Versions du projet](#project-versions)  
[Initialiser le projet](#initialize-project)

## Versions du projet
<a name="project-versions"></a>

Créé depuis un environnement Windows 11 /WSL2 (Ubuntu 24.04).

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
<a name="initialize-project"></a>
[Retour en haut de page](#top)

### Cloner le projet

`git clone git@github.com:MathiasDaverede/job-search.git`

### Remplir le .env

Pour que le projet Symfony soit créé avec les droits de l'utilisateur connecté dans le conteneur.

USER_NAME=votre_nom_d_utilisateur (`whoami`)  
USER_ID=votre_uid (`id -u`)  
GROUP_ID=votre_gid (`id -g`)

### Démarrer le projet

Se placer dans le projet :  
`cd emplacement/job-search/`

Construire l'image et démarrer le conteneur en mode détaché :  
`docker compose up -d`

Se connecter au conteneur  
`docker exec -it job-search-web-1 bash`  

Vérifier que le projet Symfony ait bien été créé :  
`ls -la job-search/`

Potentiellement, lancer les commandes qui seront lancées par "GitHub Actions workflow" :  
(les commandes contenues dans .github/workflows/ci.yml)  
`cd job-search/`  
`composer install` (mais dans notre cas les dépendances ont déjà été installées)  
`symfony check:requirements`  

Prochaine étape pour la feature suivante :  
Déplacer le contenu du projet Symfony dans notre dossier de travail :  
(toujours en étant dans le conteneur)  
`cp -rp /home/votre_user_name/job-search/. /var/www/`

Et faire quelques ajustements pour afficher la page d'accueil.