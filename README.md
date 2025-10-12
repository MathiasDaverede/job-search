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
[Modifier le projet](#modify-project)

## Versions du projet
<a name="project-versions"></a>

Créé depuis un environnement Windows 11 /WSL2 (Ubuntu 24.04).

### Docker

Docker version 28.1.1  
Docker Compose version v2.35.1-desktop.1

### Images

Reverse proxy : Traefik 3.4.0  
Web : Debian 12.12 (Bookworm 12)  
Database : MariaDB 11.7.2 / PhpMyAdmin 5.2.2-apache

### Projet

Composer 2.2.25  
Symfony 7.3  
Php 8.2

### Bundles installés via Composer

[Sass 0.8.3](https://packagist.org/packages/symfonycasts/sass-bundle)  
`composer require symfonycasts/sass-bundle`

### Assets installées via importmap

[Bootstrap 5.3.8](https://www.npmjs.com/package/bootstrap)  
`bin/console importmap:require bootstrap`
+ Installe automatiquement "@popperjs/core 2.11.8".

[Fontawesome-free 7.1.0](https://www.npmjs.com/package/@fortawesome/fontawesome-free)  
`bin/console importmap:require @fortawesome/fontawesome-free/css/all.min.css`
+ On ne prend que le all.min.css du package, j'avais des bugs sinon

## Comment l'utiliser
<a name="how-to-use"></a>
[Retour en haut de page](#top)

Clonez le projet :  
`git clone git@github.com:MathiasDaverede/job-search.git`

Remplissez le .env :  
MARIADB_DATABASE_NAME=un_nom_pour_la_base_de_donnees  
MARIADB_ROOT_PASSWORD=un_mot_de_passe

## Démarrer le projet
<a name="start-project"></a>
[Retour en haut de page](#top)

Placez vous dans le projet :  
`cd emplacement/job-search/`

Assurez vous que le script de démarrage des conteneurs est en LF :  
`sed -i 's/\r$//' docker/bin/docker-up.sh`

Rendez le script exécutable :  
`chmod +x docker/bin/docker-up.sh`

Construisez les images et démarrez les conteneurs en mode détachés :  
`./docker/bin/docker-up.sh`
 + Il arrive que ça plante car l'un des serveurs ne répont (momentanément) pas.  
   Si c'est le cas, relancez la commande.

Accédez au conteneur web lorsqu'il est démarré (Container job-search-web-1 Started) :  
`docker exec -it job-search-web-1 bash`

Puis lancez les commandes :

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

Mise à jour de la base de données  
(déjà créée automatiquement lors du premier démarrage de son conteneur) :  
`bin/console doctrine:migrations:migrate`

Génération des assets Sass :  
`bin/console sass:build`

Contrôle de l'installation  
(éléments requis et audit) :  
`symfony check:requirements`  
`symfony check:security`  
`bin/console importmap:audit`

## Accéder au projet
<a name="access-project"></a>
[Retour en haut de page](#top)

Si les conteneurs sont stoppés (vous reprenez le projet un autre jour ou vous redémarrer votre pc),  
relancez la commande :  
`./docker/bin/docker-up.sh`

Vérifiez leurs états :  
`docker ps`

### Pages web

[Page d'accueil Symfony 7.3](http://jobsearch.localhost)
[Lettre de motivation](http://jobsearch.localhost/lettre-de-motivation)

[Traefik (reverse proxy)](http://traefik.localhost:8080/dashboard/#/)  
[PhpMyAdmin](http://phpmyadmin.localhost)

### Conteneurs

Syntaxe pour accéder au conteneur :  
`docker exec -it nom_conteneur bash`

Listez les conteneurs lancés :  
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

## Modifier le projet
<a name="modify-project"></a>
[Retour en haut de page](#top)

Placez vous dans le projet :  
`cd emplacement/job-search/`

Etant donné que c'est un projet basé sur le Framework Symfony,  
si vous modifiez les entités (ou que vous en ajoutez de nouvelles),  
lancez la commande :  
`bin/console make:migration`  
+ Pour ajouter les modifications au versioning (migrations/).  

Pour prendre en compte ces modifications,  
lancez la commande :  
`bin/console doctrine:migrations:migrate`  

Alternative (développement uniquement),  
pour des tests rapides en développement local,  
À la place des deux commandes précédentes,  
vous pouvez utiliser :  
`bin/console doctrine:schema:update --force`  

Si vous modifiez l'un des fichiers Sass (.scss),
lancez la commande (une fois) :  
`bin/console sass:build --watch`  
+ Tant que le terminal est ouvert avec la commande lancée dedans,  
vos modifications seront mises à jour automatiquement.
