Post linked in : 
demander des conseil pour le docker-up.sh
    si c'est une bonne idée le find sed ??
demander s'ils ont des idées d'ajout intéressant pour un projet comme ça ?
    Jira/Jenkins etc
Demander si toutes les bonnes pratiques sont respectées ?
Ce qu'utilise les entreprises qui liront le post :
    Jira/Jenkins PSR, etc
    CD (entreprise) : déploie automatiquement sur les serveurs lors de push sur main (PR release mergée)
        Docker Swarm/Kubernetes

chmod +x docker/bin/docker-up.sh
Dans le dockerfile ?
# CRLF => LF
find . -type f -not -path "./.git/*" -not -path "./.vs/*" -exec sed -i 's/\r$//' {} \;
chmod +x bin/console

Demander à grok CRLF


Pour grok :
J'ai un projet Docker/Symfony7.3
basé sur :
FROM debian:12.12

Avec 4 issues :

#1 Initialiser le projet avec Docker et Symfony 7.3
    dockerfile, .env, compose.yaml, CI, README
    
    Ajout de la configuration Docker.
    Initialisation du projet Symfony 7.3.
    Configuration du workflow GitHub Actions.

#2 Afficher la page d’accueil de Symfony
    Récupération des fichiers Symfony générés lors de la feature précédente.
    Paramètrage d'Apache2.
    Ajout du service Traefik.
#3 Implémenter le back-office de génération de lettres de motivation
    sass, bootstrap, fontawesome
    entité, formtype
    tests unitaires
    ci
#4 Implémenter la génération de lettres de motivation en PDF
    KnpSnappyBundle 
    commande symfony pour test avec la CI
#4 Ajouter des liens utiles pour développeurs

...mettre les commit ici comme ça je refais une dernière fois propre

peux-tu me donner un exemple de comment je pourrais mettre en place Symfony messenger dans ce contexte
avec des exemples de tests CI également
Tests unitaires, organisation des commits
découpement des issues etc

ajouter les code ANSI des couleurs d'echo
+ paramétrage du bashrc pour afficher la branche sur laquelle on est
du style dans le readme dernier onglet : pour aller plus loin

demander à grok pour les droits sur le dossier docker/mariadb 999 systemd-journal

Documente dans ton README que le CI est dans .github/workflows/ci.yaml (ex: “Workflow CI configuré dans .github/workflows/ci.yaml pour valider Docker, Composer, et tests unitaires”).

ajouter composer update dans le readme
Différence avec composer update : Contrairement à composer install, la commande composer update met à jour les dépendances en respectant les contraintes de version du composer.json et génère un nouveau composer.lock avec les versions les plus récentes compatibles.

créer une commande symfony pour tester la génération de pdf (Github CI)

Github : protéger le projet :
Protection des branches : Sur GitHub, va dans Settings > Branches > Add rule : Protège main et develop (require PR, status checks, approvals).
approvals => moi

.github/workflows/ci.yml :

# Affiche la version et les commandes disponilbes
composer -v

requete SQL avec le discriminant person::type

docker compose stop
docker system prune -a

bin/console sass:build --watch

    * 
    ajouter le left join address à la requete du readme

    Dans les commandes utiles du readme
    grep -rn "<small>" | grep "\.html.twig"
    # Pour lister toutes les commandes Symfony
    bin/console
    bin/console doctrine:database:drop --force
    fc-list | grep -i arial

    Retrouver les librairies installées via composer
composer show | grep -v "symfony|doctrine|sebastian|phpunit|psr|twig|phpdocumentor"

    * test ux icons ?
    * https://symfony.com/bundles/ux-icons/current/index.html
    * composer require symfony/ux-icons
    * 
    * 
    * ajouter des logos cliquables dans le header (bootstrap, twig, etc).
    * 
    * 
    * Plutot que classement codingame
    * Liste de liens réseaux sociaux ?
    * LinkedIn / Codingame / Github / ?
    * avec les icons :
    * Fontawesome :LinkedIn / Github
    * Codingame : la récupérer qq part
    * 
    * checker si je met des Assert dans les entités
    * 
    * OneToMany unidirectionnel ?
    * 
    * tester les dépendances docker dans le compose pour débugger le démarrage de docker desktop
    * 
    * revoir le breadcrum ? avec une notion de index back index front ?
    * histoire de faire des Back/CV etc
    * sinon ça sert à rien là
    * 
    * 
    * Installer visual studio code via docker ?
    * (pour les extensions genre twig qui a besoin de php8 et composer)
    * 
    * Installer Gedmo ?
    * https://github.com/doctrine-extensions/DoctrineExtensions/blob/main/README.md
    * 
*/


use Symfony\Component\HttpFoundation\HeaderUtils;
$disposition = HeaderUtils::makeDisposition(
    HeaderUtils::DISPOSITION_INLINE,
    'foo.pdf'
);

$response = new Response($pdfContent, Response::HTTP_OK);
$response->headers->set('Content-Disposition', $disposition);



1. Conventions de commits : quand utiliser feat, chore, fix, etc.
Les Conventional Commits sont une norme qui aide à structurer les messages de commit pour qu'ils soient clairs et exploitables (par exemple, pour générer des changelogs automatiquement). Chaque type de commit a une signification spécifique. Voici les principaux types, avec des explications et des exemples :

feat (feature) : Utilisé pour ajouter une nouvelle fonctionnalité ou un changement significatif dans le code qui apporte une valeur ajoutée pour l'utilisateur ou le système.

Exemple : feat: add user authentication system
Exemple dans ton cas : feat: add Symfony 7.3 support in project setup
Quand l'utiliser : Si tu implémentes une nouvelle feature, comme une nouvelle route, un nouveau composant, ou une nouvelle configuration qui impacte le comportement de l'application.


fix : Utilisé pour corriger un bug ou un problème dans le code ou la configuration.

Exemple : fix: resolve issue with session timeout in authentication
Exemple dans ton cas : fix: correct Apache2 configuration to handle Symfony routes
Quand l'utiliser : Si tu corriges quelque chose qui ne fonctionnait pas comme prévu.


chore : Utilisé pour des tâches techniques ou des modifications mineures qui n'impactent ni les fonctionnalités ni les performances, mais qui sont liées à la maintenance ou à l'organisation du projet.

Exemple : chore: update Dockerfile to include latest dependencies
Exemple dans ton cas : chore: configure Apache2 in Dockerfile
Quand l'utiliser : Pour des changements comme la mise à jour de dépendances, la configuration d'outils, ou des ajustements dans les fichiers de configuration (sans impact direct sur l'utilisateur).


docs : Utilisé pour des modifications dans la documentation (README, commentaires, etc.).

Exemple : docs: update README with Traefik configuration instructions
Quand l'utiliser : Si tu modifies des fichiers de documentation ou des commentaires dans le code.


style : Utilisé pour des changements qui affectent le style du code (formatage, indentation, etc.) sans modifier la logique.

Exemple : style: format code with Prettier
Quand l'utiliser : Si tu fais des changements cosmétiques (par exemple, aligner le code selon un linter).


refactor : Utilisé pour des modifications dans le code qui améliorent la structure sans ajouter de nouvelles fonctionnalités ni corriger de bugs.

Exemple : refactor: simplify controller logic for better readability
Quand l'utiliser : Si tu réorganises ou optimises le code sans changer son comportement.


test : Utilisé pour ajouter ou modifier des tests (unitaires, intégration, etc.).

Exemple : test: add unit tests for user service
Quand l'utiliser : Si tu travailles sur des tests.


ci : Utilisé pour des changements liés à l'intégration continue ou au pipeline CI/CD.

Exemple : ci: update GitHub Actions workflow for Docker build
Quand l'utiliser : Si tu modifies des fichiers de configuration CI/CD.


perf : Utilisé pour des améliorations qui optimisent les performances.

Exemple : perf: optimize database queries in user repository
Quand l'utiliser : Si tu travailles sur des optimisations de performance.

pousser un .md => tutos utiles pour moi 
et pour les autres du coup ?
du style paramétrage sourcetree LF : dans le terminal sourcetree : git config --global core.autocrlf input
