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
[Comment l'utiliser](#how-to-use)  
[Démarrer le projet](#start-project)  
[Accéder au projet](#access-project)

## Versions du projet
<a name="project-versions"></a>

Créé depuis un environnement Windows 11 /WSL2 (Ubuntu 24.04).

### Docker

Docker version 28.1.1  
Docker Compose version v2.35.1-desktop.1

### Images

Reverse proxy : Traefik 3.4.0  
Web : Debian 12.12 (Bookworm 12)  
Database : MariaDB 11.7.2

### Projet

Composer 2.2.25  
Symfony 7.3  
Php 8.2


## Comment l'utiliser
<a name="how-to-use"></a>
[Retour en haut de page](#top)

### Cloner le projet

`git clone git@github.com:MathiasDaverede/job-search.git`

### Remplir le .env

#### Données utilisateur

Pour que lorsque vous lancez des commandes qui écrivent des fichiers dans le projet,  
telles que `bin/console make:entity`,  
les fichiers soient écrit avec les bons droits sur le système hôte.

USER_NAME=votre_nom_d_utilisateur (`whoami`)  
USER_ID=votre_uid (`id -u`)  
GROUP_ID=votre_gid (`id -g`)

#### Données pour la base de données

MARIADB_DATABASE_NAME=un_nom_pour_la_base_de_donnees  
MARIADB_ROOT_PASSWORD=un_mot_de_passe

## Démarrer le projet
<a name="start-project"></a>
[Retour en haut de page](#top)

Se placer dans le projet :  
`cd emplacement/job-search/`

Construire les images et démarrer les conteneurs en mode détachés :  
`docker compose up -d`
 + Il arrive que ça plante car l'un des serveurs ne répont (momentanément) pas.  
   Si c'est le cas, relancez la commande.

Accéder au conteneur web lorsqu'il est démarré (Container job-search-web-1 Started) :  
`docker exec -it job-search-web-1 bash`

Puis lancer les commandes :

Installation des dépendances Symfony :  
`composer install`

> [!NOTE]
> La commande `composer install`  se base sur les fichiers composer.lock et symfony.lock.  
> Composer commence par lire composer.lock.  
> Ensuite, Symfony Flex intervient (si activé dans le projet)  
  et utilise symfony.lock pour appliquer les recettes associées à ces dépendances.  
>
> + composer.lock
>   + Contient les versions exactes des dépendances PHP (packages et leurs sous-dépendances)  
      installées dans le projet.
>   + Composer lit composer.lock (s'il existe) pour installer les versions précises des dépendances listées,  
>     ignorant les contraintes de version du composer.json pour ces dépendances.  
>       + Si composer.lock n’existe pas,  
>         Composer utilise les contraintes du composer.json pour télécharger les versions compatibles  
>         et crée un nouveau composer.lock.
> + symfony.lock
>   + Spécifique à Symfony Flex,  
>     enregistre les versions des recettes (fichiers de configuration automatisés) associées aux packages installés.  
>     Ces recettes configurent les bundles, créent des fichiers (comme config/packages/*.yaml),  
>     ou modifient des fichiers comme .gitignore.
>       + Symfony Flex, qui est un plugin de Composer,  
>         lit symfony.lock pour appliquer les recettes dans l’état exact où elles ont été installées initialement.  
>         Cela garantit que les configurations spécifiques à Symfony (comme les fichiers de configuration ou les scripts d’initialisation)  
>         sont appliquées de manière cohérente.
>
> En résumé :  
> composer.lock s’occupe des dépendances (les bibliothèques PHP elles-mêmes).  
> symfony.lock s’occupe des configurations (recettes) appliquées à ces dépendances pour intégrer correctement les bundles ou packages.
>
> La commande `composer install` lance également les commandes :  
> + `bin/console cache:clear`
>   + Vide le cache (var/cache/).
> + `bin/console assets:install public`
>   + Copie les fichiers statiques des bundles installés (fichier composer.lock)  
      dans le dossier "public/bundles/".
> + `bin/console importmap:install`
>   + Installe les dépendances Javascript/CSS (fichier importmap.php)  
      dans le dossier "assets/vendor/".

Contrôle de l'installation  
(éléments requis et audit) :  
`symfony check:requirements`  
`symfony check:security`  
`bin/console importmap:audit`

## Accéder au projet
<a name="access-project"></a>
[Retour en haut de page](#top)

Si les conteneurs sont stoppés (vous reprenez le projet un autre jour ou vous redémarrer votre pc),  
Relancer la commande :  
`docker compose up -d`

Vérifier leurs états avec la commande :  
`docker ps`

### Pages web

[Page d'accueil Symfony 7.3](http://jobsearch.localhost)

[Traefik (reverse proxy)](http://traefik.localhost:8080/dashboard/#/)

### Conteneurs

Syntaxe pour accéder au conteneur :  
`docker exec -it nom_conteneur bash`

Lister les conteneurs lancés :  
`docker ps`  

> Nom des conteneurs (colonne NAMES) :  
> job-search-web-1  
> job-search-database-1

```
# Le projet web basé sur le Dockerfile (Symfony/Php/Apache2/etc.)
docker exec -it job-search-web-1 bash

# La base de donnée  MariaDB  
docker exec -it job-search-database-1 bash
```
