# Recherche d'emploi

![Docker](https://img.shields.io/badge/Docker-28.1-blue)
![Symfony](https://img.shields.io/badge/Symfony-7.3-blue)
![PHP](https://img.shields.io/badge/PHP-8.2-777BB4)
![License](https://img.shields.io/badge/License-MIT-green)

Outil pour générer des lettres de motivation en PDF et regrouper des liens utiles aux développeurs.

## Fonctionnalités

- Back-office pour la création de lettres de motivation.
- Génération de ces lettres en PDF avec `KnpSnappyBundle`.
- Liens utiles pour les développeurs.

## Prérequis

- Git
- Docker et Docker Compose

## Captures d’écran

![Entête et première partie du back-office](screenshots/backoffice1.png)
![Deuxième partie du back-office](screenshots/backoffice2.png)
![Troisième partie du back-office et pied de page](screenshots/backoffice3.png)

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
[Comment l'utiliser](#comment-lutiliser)  
[Démarrer le projet](#démarrer-le-projet)  
[Accéder au projet](#accéder-au-projet)  
[Modifier le projet](#modifier-le-projet)  
[Tests unitaires](#tests-unitaires)  
[Git](#git)  
[SQL](#sql)  
[Commandes utiles](#commandes-utiles)  
[Markdown](#markdown)

## Versions du projet

Créé depuis un environnement Windows 11 / WSL2 (Ubuntu 24.04).

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

[DoctrineFixtures 4.3](https://packagist.org/packages/doctrine/doctrine-fixtures-bundle)  
`composer require --dev doctrine/doctrine-fixtures-bundle`

[KnpSnappy 1.10](https://packagist.org/packages/knplabs/knp-snappy-bundle)  
`composer require knplabs/knp-snappy-bundle`

### Assets installées via importmap

[Bootstrap 5.3.8](https://www.npmjs.com/package/bootstrap)  
`bin/console importmap:require bootstrap`

- Installe automatiquement "@popperjs/core 2.11.8".

[Fontawesome-free 7.1.0](https://www.npmjs.com/package/@fortawesome/fontawesome-free)  
`bin/console importmap:require @fortawesome/fontawesome-free/css/all.min.css`

- Nous prenons seulement le fichier "all.min.css" du package (pour éviter des bugs).

## Comment l'utiliser

[Retour au sommaire](#sommaire)

Clonez le projet :  
`git clone git@github.com:MathiasDaverede/job-search.git`

## Créez un fichier .env.local à la racine du projet

Symfony charge d'abord .env, puis .env.local (s'il existe),  
et remplace les variables identiques par celles de .env.local pour l'environnement local.

Il faut quand même, au minimum, les données dont docker aura besoin puisqu'on utilisera par la suite la commande :  
`docker compose --env-file .env.local up -d`

### Données utilisateur

Pour que lorsque vous lancez des commandes qui écrivent des fichiers dans le projet,  
telles que `bin/console make:entity`,  
les fichiers soient écrits avec les mêmes droits que l'utilisateur connecté sur le système hôte

USER_NAME=votre_nom_d_utilisateur (`whoami`)  
USER_ID=votre_uid (`id -u`)  
GROUP_ID=votre_gid (`id -g`)

### Données pour la base de données

MARIADB_ROOT_PASSWORD=un_mot_de_passe  
MARIADB_DATABASE_NAME=un_nom_pour_la_base_de_donnees

## Démarrer le projet

[Retour au sommaire](#sommaire)

Placez-vous dans le projet :  
`cd emplacement/job-search/`

> [!CAUTION]
> Selon comment vous avez cloné le projet,  
> il se peut que les fichiers exécutables ne le soient pas (SourceTree sur Windows avec Ubuntu (WSL)).

```bash
# Vérifiez les droits des fichiers
ls -l bin/

# Rendre les fichiers exécutables
chmod +x bin/*
```

Construisez les images et démarrez les conteneurs en mode détachés :  
`docker compose --env-file .env.local up -d`

- Il arrive que ça plante car l'un des serveurs ne répont (momentanément) pas.  
   Si c'est le cas, relancez la commande.

Si par la suite, vous modifiez le Dockerfile,  
ou que vous avez oublié de créer le .env.local avant de lancer la commande up  
vous devrez lancez la commande build,  
c.-à-d. :  
Soit :

```bash
docker compose --env-file .env.local build
docker compose --env-file .env.local up -d
```

Soit :  
`docker compose --env-file .env.local up --build -d`

Accédez au conteneur web lorsqu'il est démarré (Container job-search-web-1 Started) :  
`docker exec -it job-search-web-1 bash`

Puis lancez les commandes :

Installation des dépendances Symfony :  
`composer install`

> [!NOTE]
> La commande `composer install`  se base sur les fichiers composer.lock et symfony.lock.  
> Composer commence par lire composer.lock.  
> Ensuite, Symfony Flex intervient (si activé dans le projet)  
> et utilise symfony.lock pour appliquer les recettes associées à ces dépendances.
>
> - composer.lock
>   - Contient les versions exactes des dépendances PHP (packages et leurs sous-dépendances)  
>     installées dans le projet.
>   - Composer lit composer.lock (s'il existe) pour installer les versions précises des dépendances listées,  
>     ignorant les contraintes de version du composer.json pour ces dépendances.  
>     - Si composer.lock n’existe pas,  
>       Composer utilise les contraintes du composer.json pour télécharger les versions compatibles  
>       et crée un nouveau composer.lock.
> - symfony.lock
>   - Spécifique à Symfony Flex,  
>     enregistre les versions des recettes (fichiers de configuration automatisés) associées aux packages installés.  
>     Ces recettes configurent les bundles, créent des fichiers (comme config/packages/*.yaml),  
>     ou modifient des fichiers comme .gitignore.
>     - Symfony Flex, qui est un plugin de Composer,  
>       lit symfony.lock pour appliquer les recettes dans l’état exact où elles ont été installées initialement.  
>       Cela garantit que les configurations spécifiques à Symfony (comme les fichiers de configuration ou les scripts d’initialisation)  
>       sont appliquées de manière cohérente.
>
> En résumé :  
> composer.lock s’occupe des dépendances (les bibliothèques PHP elles-mêmes).  
> symfony.lock s’occupe des configurations (recettes) appliquées à ces dépendances pour intégrer correctement les bundles ou packages.
>
> La commande `composer install` lance également les commandes :
>
> - `bin/console cache:clear`
>   - Vide le cache (var/cache/).
> - `bin/console assets:install public`
>   - Copie les fichiers statiques des bundles installés (fichier composer.lock)  
>     dans le dossier "public/bundles/".
> - `bin/console importmap:install`
>   - Installe les dépendances Javascript/CSS (fichier importmap.php)  
>     dans le dossier "assets/vendor/".

Mise à jour de la base de données  
(déjà créée automatiquement lors du premier démarrage de son conteneur) :  
`bin/console doctrine:migrations:migrate --no-interaction`

Génération des assets Sass :  
`bin/console sass:build`

Contrôle de l'installation  
(éléments requis et audit) :  
`symfony check:requirements`  
`symfony check:security`  
`bin/console importmap:audit`

## Accéder au projet

[Retour au sommaire](#sommaire)

Si les conteneurs sont stoppés (vous reprenez le projet un autre jour ou vous redémarrez votre PC),  
relancez la commande :  
`docker compose --env-file .env.local up -d`

Vérifiez leurs états :  
`docker ps`

### Pages web

[Page "placeholder" Symfony 7.3](http://jobsearch.localhost)  
[Lettre de motivation](http://jobsearch.localhost/lettre-de-motivation)  
[Liens utiles](http://jobsearch.localhost/liens-utiles)

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

```bash
# Le projet web basé sur le Dockerfile (Symfony/Php/Apache2/etc.)
docker exec -it job-search-web-1 bash

# La base de donnée MariaDB
docker exec -it job-search-database-1 bash
```

## Modifier le projet

[Retour au sommaire](#sommaire)

Placez vous dans le projet :  
`cd emplacement/job-search/`

Etant donné que c'est un projet basé sur le Framework Symfony,  
si vous modifiez les entités (ou que vous en ajoutez de nouvelles),  
lancez la commande :  
`bin/console make:migration`

- Pour ajouter les modifications au versioning (migrations/).

Pour prendre en compte ces modifications,  
lancez la commande :  
`bin/console doctrine:migrations:migrate --no-interaction`

Alternative (développement uniquement),  
pour des tests rapides en développement local,  
À la place des deux commandes précédentes,  
vous pouvez utiliser :  
`bin/console doctrine:schema:update --force`

Si vous modifiez l'un des fichiers Sass (.scss),
lancez la commande (une fois) :  
`bin/console sass:build --watch`

- Tant que le terminal est ouvert avec la commande lancée dedans,  
  vos modifications seront mises à jour automatiquement.
- Ctrl + c pour quitter

Si vous ajoutez des fichiers Sass,  
ajoutez le chemin du fichier dans [symfonycasts_sass.yaml](config/packages/symfonycasts_sass.yaml),  
puis, relancez la commande :  
`bin/console sass:build --watch`

## Tests unitaires

[Retour au sommaire](#sommaire)

Les tests unitaires sont lancés automatiquement lors de la création de pull requests sur Github.  
Les commandes lancées, que vous pouvez retrouver dans le fichier [project.yml](.github/workflows/project.yml), sont :

> [!NOTE]
> Ces commandes sont à lancer dans le conteneur du projet :  
> `docker exec -it job-search-web-1 bash`

Création de la base de données de test :  
`bin/console --env=test doctrine:database:create`

Création des tables/colonnes dans la base de données de test :  
`bin/console --env=test doctrine:schema:create`

Initialisation de la base de données de test :  
`bin/console --env=test doctrine:fixtures:load --no-interaction`

Lancement des tests :  
`bin/phpunit`

Pour information, la création d'un test unitaire se fait grâce à la commande :  
`bin/console make:test`

## Git

[Retour au sommaire](#sommaire)

### Sourcetree

Dans les lignes suivantes, remplacez "user" par votre user_name,  
ou simplement que cela coïncide avec le chemin où vous clonez le projet.

New tab > Clone  
Source Path / URL : git@github.com:MathiasDaverede/job-search.git  
Destination Path : \\wsl$\Ubuntu-24.04\home\user\job-search  
(ou destination Path : Z:\home\user\job-search)

Terminal :  
`git config --global --add safe.directory '%(prefix)///wsl$/Ubuntu-24.04/home/user/job-search'`  
(ou `git config --global --add safe.directory '%(prefix)///wsl.localhost/Ubuntu-24.04/home/user/job-search'`)

- En fonction de la popup d'erreur que vous avez,  
  cela ajoute la configuration au niveau de Windows (C:\Users\user\.gitconfig)

Créez ou importez une clé SSH :  
Tools > Create or Import SSH Keys  
Cela va ouvrir PuTTY Key Generator  
A partir de là vous pouvez importer ou générer une paire de clé public/private.

Dans les paramètres de votre GitHub, ajoutez la clé publique :  
Cliquez sur votre icône (en haut à droite) > Settings > SSH and GPG Keys > New SSH Key

### Github

#### Paramétrage

Création d'un repository.

Protection des branches develop et main :

- Settings (du repository) >
  - Rules > Rulesets > New ruleset
    - Require a pull request before merging

Donner la permission à GitHub Actions de créer des PRs  
(pour la création automatique de PR de synchronisation) :

- Settings (du repository) >
  - Actions > General > Workflow permissions
    - Allow GitHub Actions to create and approve pull requests

#### Pull requests (PR)

Il semblerait que les bonnes pratiques soient de :  

- "Squash and merge" les features vers develop
- "Merge pull request" pour les releases et hotfixes vers main

Pour ce projet, j'ai fait le choix de "Squash and merge" toutes les PRs.

Pour que la CI que j'ai mise en place fonctionne,  
il faut que les titres et descriptions de PRs de release ou hotfix vers main,  
suivent une convention que j'ai mise en place.

Pour les titres :

- version_type : X.Y.Z - summary
  - Release : 1.0.0 - First release's summary
  - Hotfix : 1.0.1 - First bug correction's summary

> [!NOTE]
> Pour les titres de PRs de feature vers develop,  
> j'utilise le format : type(scope optionnel): résumé (ref #numero_issue)

Pour les descriptions, étant donné que c'est un petit projet sur lequel je suis seul,  
j'ai utilisé une version simplifiée,  
mais voici les modèles recommandés, les plus couramment utilisés.  
Ils suivent une structure logique pour répondre aux questions clés que doit se poser un relecteur :  
Pourquoi ? Quoi ? Comment le vérifier ?.

Modèle pour PRs de features vers develop :

```markdown
Titre : feat(setup): initialize Docker and Symfony 7.3 project (ref #1)

Description :

**Context**
This PR initializes Docker and Symfony7.3 project.

**Changes**
- feat(setup): initialize Docker and Symfony 7.3 project (ref #1)
- docs: create README.md (ref #1)

**How to Test**
1. Run the project: `docker compose --env-file .env.local up -d`
2. Access the web container: `docker exec -it job-search-web-1 bash`
3. Verify Symfony files are present: `ls -l job-search/`

**Checklist** :
- [] Docker service (web) is running (docker ps)
- [] The 'web' container user matches the host user (based on .env.local data) (whoami, id -u, id -g)

**Reviewer Notes**
We are using **mounted volumes** (`.:/var/www/`) so that in next feature we move Symfony files directly in the host project folder.
When we'll use Symfony commands, like `bin/console make:entity`, it'll create files directly in the host project folder.
```

Modèle pour PRs de releases vers main :

```markdown
titre : Release : 1.0.0 - Cover letters managment, PDFs generation and CI

Description :

**Context**
This PR prepares the v1.0.0 production release.

**New Features**
- feat(setup): initialize Docker and Symfony 7.3 project (close #1)
- feat(setup): display Symfony placeholder page (close #2)
- feat: create cover letters back-office (close #3)
- feat: generate cover letters PDFs (close #4)
- ci: implement CI for testing Symfony project (close #5)
- ci: implement CI to manage version and changelog (close #6)
- ci: implement CI for GitHub Tagging and Release Creation (close #7)
- ci: implement CI to manage merged branches (close #8)

**Bug Fixes & Chore**
(just for acknowledge nut there are no bugs yet, seens it's the first release)
- chore(CI): fix something in CI (ref #5)

**Testing Summary**
(example) :
All features have passed QA testing on the staging environment (`release/1.0.0`).

**Instructions for Review**
Final check on the generated version tag and changelog contents before merging to `main`.
```

Modèle pour PRs de hotfixes vers main :

```markdown
titre : Hotfix : 1.0.1 - Fix KnpSnappy wkhtmltopdf binary path

Description :

**Context**
A critical misconfiguration in knp_snappy.yaml was preventing the PDF generator
from locating the wkhtmltopdf binary in the production environment (main branch),
leading to a 500 server error when requesting a cover letter PDF. This fix must be deployed ASAP.

**Changes**
- fix(config): update wkhtmltopdf binary path in knp_snappy.yaml (fix #13)
- fix(docker): ensure wkhtmltopdf is globally accessible in web container (ref #13)

**Impact**
- PDF generation for all cover letters is restored to normal functionality.
- The fix is applied to both the main and develop branches via CI synchronization.

**Testing Instructions**
1. Clear the cache: bin/console c:c
2. Access the back-office.
3. Click the "Générer le PDF" link.
4. Verify that the PDF is generated and downloaded without error.

**Deployment Notes**
Merging this PR will trigger the immediate creation of the v1.0.1 tag and production release.
```

> [!NOTE]
> j'utilise les actions de fermeture d'issues (close, fix, resolve)  
> uniquement dans les descriptions de PRs vers main (release ou hotfix).  
> Ainsi les issues seront fermées automatiquement  
> une fois la PR mergée (vers main et donc en production).
>
> Dans ces descriptions (de PRs vers main),  
> les lignes qui correspondent au pattern "- type(scope optionnel): résumé (action #numero_issue)"  
> seront intégrées dans le changelog.
> Pour les résumés, comme pour les titres des issues,  
> préférez un verbe d'action (implement, add, update, fix) :
>
> - "- feat: feature's summary (close #1)"
> - "- chore(CI): a chore's summary (ref #1)"
> - "- chore: another chore's summary"
> - "- fix: bug fix's summary (fix #2)"
> - "- fix: another bug fix's summary (resolve #3)"
>
> Liste des types :
>
> - feat : utilisé pour ajouter une nouvelle fonctionnalité ou un changement significatif
> - fix : utilisé pour corriger un bug
> - chore : utilisé pour des tâches techniques ou des modifications mineures
> - docs : utilisé pour des modifications dans la documentation (README, commentaires, etc.).
> - style : utilisé pour des changements qui affectent le style du code (formatage, indentation, etc.)
> - refactor : utilisé pour des modifications dans le code qui améliorent la structure
> - test : utilisé pour ajouter ou modifier des tests (unitaires, intégration, etc.).
> - ci : utilisé pour des changements liés à l'intégration continue ou au pipeline CI/CD.
> - perf : utilisé pour des améliorations qui optimisent les performances.
>
> Liste des scopes :
>
> - Domaines Fonctionnels : cover-letter, links, person
> - Couches Techniques : api, database, service, entity, cache
> - Interfaces : ui, ux, design, front
> - Environnement/Build : ci, docker, config, infra, deps, setup, cleanup, sync
> - Autres : doc, tests, security, routing

#### Actions

Description de la CI (Github Actions) mise en place :

[project.yml](.github/workflows/project.yml)

Se lance à chaque PR, créée ou mise à jour, d'une branche vers develop ou vers main

- Test du projet
  - installation des dépendances
  - mise à jour de la base de données
  - audit et vérifications
  - tests unitaires

[version-changelog.yml](.github/workflows/version-changelog.yml)

Se lance à chaque PR, créée ou mise à jour, d'une branche (release ou hotfix) vers main

- Mise à jour des fichiers VERSION.md et CHANGELOG.md

J'ai fait le choix que la création du changelog se base sur les informations des PRs,  
car le titre et description des PRs sont modifiables même une fois fermés.  
En cas d'erreurs, il sera toujours possible d'avoir un changelog propre.  
Il est recréé à chaque fois pour pouvoir modifier sa structure au besoin.

[tag-release.yml](.github/workflows/tag-release.yml)

Se lance à chaque PR mergée vers main

- Création d'un tag et d'une release GitHub

[merged-branches.yml](.github/workflows/merged-branches.yml)

Se lance à chaque PR mergée

- Feature mergée sur develop
  - suppression de la branche
- Release ou hotfix mergée sur main
  - création d'une PR de la branche vers develop pour synchronisation
- Release ou hotfix mergée sur develop
  - suppression de la branche

### Git flow

J'utilise personnellement SourceTree sur Windows qui gère le projet sur Ubuntu (WSL)  
Mais voici un résumé d'un cycle de vie :

Création d'issues sur le repository en fonction des besoins (ajout de fonctionnalités, correction de bugs)

#### Feature

Nouvelle fonctionnalité

Création d'une branche feature/[issue_number]-feature-name à partir de develop.

- feature/1-my-first-feature

Développement de la fonctionnalité

Exemple de commits :

- feat: initialize Docker/Symfony7.3 project (ref #1)
- docs: update README.md (ref #1)
- chore : implement unit tests (ref #1)

puis on pousse la branche sur le dépot.

On créé ensuite une PR de cette branche vers develop,

- titre : feat: initialize Docker/Symfony7.3 project (ref #1)
- description : description de la nouvelle fonctionnalité si besoin

on résout les conflits potentiels (en mettant à jour notre branche develop puis en la mergeant dans notre feature puis re push),
on attend que les tests de la CI soient validés.

puis on "Squash and merge" avec un message qui reflète la feature :

- feat: initialize Docker/Symfony7.3 project (ref #1)

### Release

Contient les fonctionnalités (features) à déployer

> [!NOTE]
> Étant donné que les branches main et develop sont protégées (pull requests only)  
> On ne peut pas utiliser la fonctionnalité git flow `git flow release finish 'X.Y.Z'`  
> qui merge la release dans main, puis dans develop, puis la supprime

Création d'une branche release/X.Y.Z à partir de develop (qui contient les nouvelles features).  
release/1.0.0

Déploiement de la release sur un environnement de test (pré-prod).

Après validation du bon fonctionnement des fonctionnalités contenues dans la release,  
ouverture d'une PR de release/X.Y.Z vers main.  
titre : Release : 1.0.0 - First release's summary  
description : une description contenant la liste des features au format présenté plus haut

on résout les conflits potentiels (en mergeant main dans notre release puis re push),  
on attend que les tests de la CI soient validés (tests du projet + mise à jour des .md).

puis on "Squash and merge" avec un message qui reflète la release :

- Release : 1.0.0 - First release's summary

Ca va créer automatiquement une PR de la release vers develop (via la CI)  
on résout les conflits potentiels

- en mettant à jour notre branche release/ locale (la mise à jour auto des .md a généré un commit)
- en mergeant develop dans notre branche
- puis re push

### Hotfix

Même principe qu'une release sauf qu'il contient une (ou plusieurs) correction de bug important qu'il faut corriger rapidement.

Création d'une branche hotfix/X.Y.Z à partir de main.  
hotfix/1.0.1

Déploiement du hotfix sur un environnement de test (pré-prod).

Après validation du bon fonctionnement du (des) correctif contenu dans le hotfix,  
ouverture d'une PR de hotfix/X.Y.Z vers main.  
titre : Hotfix : 1.0.1 - Résumé du correctif  
description : une description contenant la liste des correctifs au format présenté plus haut

on résout les conflits potentiels (en mergeant main dans notre hotfix puis re push),  
on attend que les tests de la CI soient validés (tests du projet + mise à jour des .md).

puis on "Squash and merge" avec un message qui reflète le hotfix :

- Hotfix : 1.0.1 - Résumé du (des) correctif

Ca va créer automatiquement une PR du hotfix vers develop (via la CI)  
on résout les conflits potentiels

- en mettant à jour notre branche hotfix/ locale (la mise à jour auto des .md a généré un commit)
- en mergeant develop dans notre branche
- puis re push

## SQL

[Retour au sommaire](#sommaire)

```sql
SELECT
    s.type, CONCAT(s.first_name, ' ', s.last_name) AS 'Expéditeur', s.phone, a.*,
    r.type, CONCAT(r.first_name, ' ', r.last_name) AS 'Destinataire', r.company, r.job, ar.*,
    cl.object AS 'Objet de la lettre', cl.letter AS 'Lettre'
FROM
    cover_letter cl
    # Sender
    INNER JOIN person s ON s.id = cl.sender_id
    INNER JOIN address a ON a.id = s.address_id
    # Recipient
    INNER JOIN person r ON r.id = cl.recipient_id
    LEFT JOIN address ar ON ar.id = r.address_id

SELECT * FROM messenger_messages
```

## Commandes utiles

[Retour au sommaire](#sommaire)

### Commandes Symfony

Pour toutes les commandes symfony et bin/console vous pouvez utiliser une version abrégée si ce n'est pas ambigu  
telle que `bin/console c:c` pour `bin/console cache:clear`

Visualiser la liste des commandes disponibles

```bash
symfony help
bin/console
```

Éléments requis et audit

```bash
symfony check:requirements
symfony check:security
bin/console importmap:audit
```

Base de données

```bash
bin/console doctrine:database:drop --force
bin/console doctrine:database:create
bin/console make:migration
bin/console doctrine:migrations:migrate
bin/console doctrine:schema:update --force
```

Vider le cache :  
`bin/console cache:clear`

### Commandes Composer

```bash
# Affiche la version et les commandes disponibles
composer #(ou composer -v)

# Installe les dépendances du projet (vendor/) en ce basant sur le composer.lock
composer install

# Installe les dépendances du projet (vendor/) en ce basant sur le composer.json,
# et recherche les dernières versions compatibles avec les règles définies (par exemple, ^6.0 ou ~1.2).
# et il met à jour le composer.lock
composer update

# Met à jour Composer vers sa dernière version stable
composer self-update

# Retrouver les bibliothèques installées via composer
# Le grep -v c'est histoire qu'il y en ait un peu moins qui s'affiche car la liste est longue
# À adapter
composer show | grep -v "symfony\|doctrine\|sebastian\|phpunit\|psr\|twig\|phpdocumentor"
```

### Commandes Git

```bash
#Pour annuler un (des) commit non poussé :
git reset --soft HEAD~

# Git ne suit pas toutes les permissions des fichiers.
# Par défaut, Git ne versionne que le bit d'exécution (+x) pour les fichiers
# (et uniquement si le fichier est marqué comme exécutable ou non).
git config core.fileMode true

# Ou globalement
git config --global core.fileMode true

git config --get core.fileMode

git ls-files --stage | grep bin/ | grep .github/bin/

git add --chmod=+x bin/* .github/bin/*

# Alias (par exemple pour pouvoir faire "git st" pour "git status")
git config --global alias.co checkout
git config --global alias.br branch
git config --global alias.ci commit
git config --global alias.st status
```

### Commandes Docker

> [!TIP]
> **Gestion des Utilisateurs et des Droits :**  
> L'utilisateur et les permissions dans le conteneur (`chown`, `useradd`)  
> sont gérés automatiquement via les arguments `USER_ID`, `GROUP_ID`, et `USER_NAME` lus depuis le `.env.local`.  
> Ces commandes sont exécutées lors de la construction de l'image.  
> Vous pouvez retrouver la logique complète dans le [Dockerfile](Dockerfile).

#### Commandes courantes

```bash
docker # liste toutes les commandes disponibles
docker -v

docker compose stop # Arrête les conteneurs sans les supprimer.
docker compose down # Arrête et supprime les conteneurs, les réseaux, et optionnellement les volumes.

# Forcer un (re)build
docker compose --env-file .env.local build --no-cache

docker compose --env-file .env.local build
docker compose --env-file .env.local up -d

docker compose --env-file .env.local up --build -d

docker exec -it job-search-web-1 bash

docker compose --env-file .env.local up
docker compose --env-file .env.local up web

docker logs job-search-web-1 -f
```

#### Affichage

```bash
docker ps
docker ps -a
docker container ls

docker images
docker image ls

docker network ls
```

#### Suppression/Nettoyage

```bash
docker stop $(docker ps -a -q)

docker rmi id_ou_nom_de_l_image
docker rm id_ou_nom_du_container

docker rm $(docker ps -a -q)
docker rmi $(docker images -q)
docker network rm $(docker network ls -q)

docker container prune
docker image prune
docker system prune -a
```

### Linux

Recherche de mots ou de pattern (REGEX)

- grep (sans options) : Expression régulière de base (BRE)
- grep -E : Expression régulière étendue (ERE)
- grep -P : Expressions régulières compatibles Perl (PCRE)
- grep -r : recherche récursive
- grep -n : affiche le numéro de ligne

```bash
grep -rn --exclude-dir=a/directory/to/exclude "un_mot_ou_une_regex" /un/chemin/
grep -rn --exclude-dir=var "HammersmithOne" .

grep -rn "<h2>" | grep "\.html.twig"

# Liste les fonts installées sur le système, mais n'affiche que celles qui contiennent le mot "arial" (insensible à la casse)
fc-list | grep -i arial
```

### Logs

```bash
tail -f /var/log/apache2/error.log
tail -f /var/log/apache2/access.log

tail -f /var/log/apache2/error.log  | grep "un_mot_ou_une_regex"
tail -f /var/log/apache2/error.log  | grep -i "error\|crit\|fatal\|500\|403"

cat /var/log/apache2/error.log  | grep "warn"

cd path/to/your/SymfonyProjectDirectory/
tail -f var/log/dev.log
tail -f var/log/prod.log

# Suppression des logs de développement (le fichier peut vite devenir lourd)
rm var/log/dev.log
```

### Réseau/Ports

```bash
# Afficher les ports en écoute (si Traefik ou Apache ne répond pas)
sudo netstat -tuln | grep 80
```

### Processus (Débogage de performance)

```bash
# Afficher les processus en cours (utile si le CPU monte)
ps aux

# Ou pour une vue dynamique interactive (q pour quitter)
top
top -o %CPU
top -o %MEM

# Comme top mais coloré et plus lisible (q pour quitter)
htop
```

### .bashrc

Vous pouvez ajouter dans votre .bashrc (home/votre_username/.bashrc) :

Afficher la branche git sur laquelle vous êtes actuellement.  
Au niveau du code existant :

```bash
if [ "$color_prompt" = yes ]; then
    PS1='${debian_chroot:+($debian_chroot)}\[\033[01;32m\]\u@\h\[\033[00m\]:\[\033[01;34m\]\w\[\033[00m\]\$ '
else
    PS1='${debian_chroot:+($debian_chroot)}\u@\h:\w\$ '
fi
```

Ajoutez :

```bash
# Ajoutez cette fonction au dessus du if
parse_git_branch() {
  git branch 2> /dev/null | sed -e '/^[^*]/d' -e 's/* \(.*\)/(\1)/'
}


if [ "$color_prompt" = yes ]; then
    # Commentez cette ligne (au cas où xD)
    # PS1='${debian_chroot:+($debian_chroot)}\[\033[01;32m\]\u@\h\[\033[00m\]:\[\033[01;34m\]\w\[\033[00m\]\$ '

    # Et mettez à la place
    legendary_orange='\033[1;38;5;208m'
    PS1="${debian_chroot:+($debian_chroot)}\[\033[01;32m\]\u@\h\[\033[00m\]:\[\033[01;34m\]\w\[${legendary_orange}\]\$(parse_git_branch)\[\033[00m\]\$ "

    # La partie "\$(parse_git_branch)" :
    # on échappe le $ pour qu'à l'interprétation cela affiche concrètement "$(parse_git_branch)"
    # Puis si on lance la commande bash, ou bien qu'on ouvre un terminal, à ce moment la fonction sera appelée
else
    PS1='${debian_chroot:+($debian_chroot)}\u@\h:\w\$ '
fi
```

À la fin du fichier,  
pour se placer automatiquement dans un dossier à l'ouverture d'un terminal :  
`cd ~/job-search`

## Markdown

[Retour au sommaire](#sommaire)

Saut de ligne : 2 espaces à la fin ou \ ou <br\>

The background color is `#ffffff` for light mode and `#000000` for dark mode.

> [!NOTE]
> Une note.

> [!TIP]
> Un conseil.

> [!IMPORTANT]
> Quelque chose d'important.

> [!WARNING]
> Un avertissement.

> [!CAUTION]
> Prudence.

## Styles

**Gras** : ** ** ou __ __  
*Italique* : * * ou _ _  
~~Barré~~ :	~~ ~~  
**Gras et _italique imbriqué_**	: ** _ _ **  
***Tout en gras et italique*** : *** ***  
Indice : `<sub> </sub>` => H<sub>2</sub>O  
Exposant : `<sup> </sup>` => x<sup>2</sup>  
<ins>Souligné</ins> : `<ins> </ins>`
