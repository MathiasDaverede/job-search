verifier les hash de cache CI
ca n'a plus l'air de fonctionner

Pour annuler un commit non poussé :
git resest --soft HEAD~

Paramétrage Sourcetree :

git config --global --add safe.directory '%(prefix)///wsl$/Ubuntu-24.04/home/mathias/job-search'

# Git ne suit pas toutes les permissions des fichiers. Par défaut, Git ne versionne que le bit d'exécution (+x) pour les fichiers (et uniquement si le fichier est marqué comme exécutable ou non).
git config core.fileMode true
git config --global core.fileMode true # ou globalement

git config --get core.fileMode

git add --chmod=+x bin/* .github/bin/*

git ls-files --stage | grep bin/ | grep .github/bin/

ajouter dans le readme
    git flow ?
    logique CI :
        pull request  :
            created/updated :
                 develop :
                    project.yml
                main :
                    project.yml
                    version-changelog.yml
            closed :
                tag.yml

Questions linkedIn 


remettre PostgreSQL (et du coup phpmyadmin => phpPgAdmin)

commande test knpsnappy
ci 

mieux service CommandeTest
comme ça je lance tous les test avec juste bin/phpunit


Tests unitaires (#3) : Mentionner les tests unitaires est excellent, mais pour un recruteur, il serait intéressant de préciser le type de tests (par exemple, PHPUnit) et le pourcentage de couverture. Cela renforce l’aspect professionnel.

Rendre le projet attractif : Ajoute des captures d’écran ou une courte vidéo démo dans ton dépôt GitHub et sur LinkedIn. Cela permettra aux recruteurs de visualiser le résultat final (par exemple, la page d’accueil, le back-office, un PDF généré).

Mise en avant sur LinkedIn : Pour maximiser l’impact :

Publie un post LinkedIn avec un lien vers ton dépôt GitHub et une description claire de ce que fait le projet.
Mentionne les technologies clés et les compétences (Docker, Symfony, CI/CD, tests, PDF).
Ajoute un appel à l’action, par exemple : “Je suis à la recherche d’opportunités en tant que développeur PHP/Symfony, contactez-moi pour discuter !”


LinkedIn : Quand tu publieras sur LinkedIn, utilise des hashtags comme #Symfony, #PHP, #Docker, #WebDev, et #JobSearch pour augmenter la visibilité. Mentionne aussi que le projet est open-source sur GitHub avec un lien direct.

Ajouter dans les liens utiles des liens pour la préparation des entretiens d'embauche

Supprimer l'affichage du changelog
    Ajouter le lien vers le changelog.md sur github

docker compose stop
docker system prune -a

chmod +x docker/bin/docker-up.sh
./docker/bin/docker-up.sh

docker exec -it job-search-web-1 bash

bin/console sass:build --watch

sudo find job-search/ -not -path "job-search/" -not -path "job-search/.git" -not -path "job-search/.git/*" -not -path "job-search/.vs" -not -path "job-search/.vs/*"
sudo find job-search/ -not -path "job-search/" -not -path "job-search/.git" -not -path "job-search/.git/*" -not -path "job-search/.vs" -not -path "job-search/.vs/*" -exec rm -rf {} +

Paramètrage github
    protections des branches main et develop (pull request)
    auto suppression des features une fois merge


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
    feature/1-docker-symfony-init
    dockerfile, .env, compose.yaml, CI, README
    
    Ajout de la configuration Docker.
    Initialisation du projet Symfony 7.3.
    Configuration du workflow GitHub Actions.

#2 Afficher la page d’accueil de Symfony
    feature/2-display-symfony-home
    Récupération des fichiers Symfony générés lors de la feature précédente.
    Paramètrage d'Apache2.
    Ajout du service Traefik.
#3 Implémenter le back-office de génération de lettres de motivation
    feature/3-back-cover-letter
    sass, bootstrap, fontawesome
    entité, formtype
    tests unitaires
    ci
#4 Implémenter la génération de lettres de motivation en PDF
    feature/4-pdf-generation
    KnpSnappyBundle 
    commande symfony pour test avec la CI
#5 Afficher le changelog et la version sur le site
    feature/5-display-version-changelog
    footer : version => clique dessus => frontcontroller changelog
#6 Ajouter des liens utiles pour développeurs
    feature/6-useful-links

...mettre les commit ici comme ça je refais une dernière fois propre

release 1.0.0
    ajout du changelog et version (mais pas d'affichage)
    #1 à #4
release 1.1.0
    #5 et #6


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

Création d'un PAT 
    clique sur mon avatar > Settings > Developer settings > Personal access tokens > Tokens (classic) > Generate new token > Generate new token (classic)
        le nommé genre pat_repo_workflow
        expiration:  90 jours
        scopes repo/workflow
Intégrer ce token aux secrets du repo :
    Settings (du repo) > Secrets and variables > Actions > New repository secret
        Name : PAT_REPO_WORKFLOW
        Secrets : le token qu'on en voit qu'une fois lors de la génération dans l'étape précédente


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


sauvegarde du CHANGELOG.md au cas où :
# Changelog

All notable changes to this project are documented in this file.

## v1.1.0 - 2025-10-13
[Release v1.1.0](https://github.com/MathiasDaverede/job-search/releases/tag/v1.1.0)

- feature [#5](https://github.com/MathiasDaverede/job-search/issues/5) Display version in footer
- feature [#6](https://github.com/MathiasDaverede/job-search/issues/6) Useful links for developers

## v1.0.0 - 2025-10-13
[Release v1.0.0](https://github.com/MathiasDaverede/job-search/releases/tag/v1.0.0)

- feature [#1](https://github.com/MathiasDaverede/job-search/issues/1) Initialize Project
- feature [#2](https://github.com/MathiasDaverede/job-search/issues/2) Display Symfony placeholder page
- feature [#3](https://github.com/MathiasDaverede/job-search/issues/3) Create cover letters back-office
- feature [#4](https://github.com/MathiasDaverede/job-search/issues/4) Generate cover letters PDF

https://github.com/symfony/symfony/releases

Les fichiers executables doivent etre executables chmod +x et en LF

1. Bonnes pratiques pour les commits
Pour maintenir un historique clair et faciliter la génération du CHANGELOG, je recommande d’utiliser la convention Conventional Commits. Voici les bonnes pratiques :
Structure d’un message de commit
text<type>(<portée>): <description courte>

[Corps optionnel avec plus de détails]

[Footer optionnel, ex: Référence à une issue]
Types de commits courants

feat: Nouvelle fonctionnalité (ex: feat(auth): add OAuth2 login support).
fix: Correction de bug (ex: fix(database): resolve migration issue with user table).
chore: Tâches de maintenance ou changements mineurs (ex: chore(deps): update PHPUnit to 10.5).
docs: Mise à jour de la documentation (ex: docs(readme): update installation instructions).
style: Changements de mise en forme, sans impact fonctionnel (ex: style(css): format code with Prettier).
refactor: Refactorisation du code sans changement fonctionnel (ex: refactor(controller): simplify user controller logic).
test: Ajout ou modification de tests (ex: test(auth): add unit tests for login endpoint).
ci: Modifications des workflows CI/CD (ex: ci(github): add PHPStan to CI pipeline).

Bonnes pratiques

Soyez descriptif mais concis : La première ligne du commit doit être claire et ne pas dépasser 50-72 caractères.
Utilisez une portée (scope) : Indiquez le module ou la partie du projet concernée (ex: auth, database, frontend).
Ajoutez des détails dans le corps : Expliquez pourquoi le changement est nécessaire si besoin.
Liez aux issues : Si le commit ferme une issue, utilisez Closes #123 dans le footer.
Évitez les commits vagues : Par exemple, évitez fix: bug et préférez fix(auth): correct redirect after login failure.

Exemple
bashfeat(api): add endpoint for user profile retrieval

- Implement GET /api/users/{id} endpoint
- Add validation for user permissions
- Update API documentation

Closes #45

2. Bonnes pratiques pour les titres et descriptions des Pull Requests
Les Pull Requests (PR) doivent être claires pour faciliter la revue de code et la compréhension des changements. Voici des recommandations pour les PR dans ton contexte Git Flow (feature → develop, release → main).
PR de feature vers develop

Titre : Utilisez un format similaire aux Conventional Commits, en résumant le but de la feature.

Ex: feat(auth): Implement OAuth2 login support
Soyez précis et évitez des titres trop généraux comme Add new feature.


Description :

Contexte : Pourquoi cette feature est nécessaire (ex: lien vers une issue ou une spécification).
Changements : Liste des principaux changements (ex: nouveaux endpoints, modifications de la base de données, etc.).
Instructions de test : Comment tester la feature (ex: étapes manuelles ou tests automatisés).
Impact : Mentionnez si cela affecte d’autres parties du projet (ex: migrations de base de données nécessaires).
Checklist (optionnel) : Une liste pour confirmer que les standards sont respectés (tests passing, code formaté, etc.).


Labels : Ajoutez des labels comme feature, enhancement, ou bug pour catégoriser la PR.

Exemple :
markdown**Titre** : feat(auth): Implement OAuth2 login support

**Description** :
- Ajout de l'authentification OAuth2 via Google.
- Mise à jour des routes API dans `config/routes.yaml`.
- Ajout de tests unitaires pour le service OAuth.

**Instructions de test** :
1. Configurer les variables d'environnement pour Google OAuth.
2. Tester l'endpoint `/api/login/oauth` avec un compte Google.
3. Vérifier que le token JWT est retourné.

**Impact** :
- Nécessite une mise à jour des variables d'environnement dans `.env`.
- Compatible avec Symfony 7.3.

**Checklist** :
- [x] Tests unitaires passent
- [x] Code formaté avec PHP-CS-Fixer
- [x] Documentation mise à jour

Closes #45
PR de release vers main

Titre : Indiquez le numéro de version et un résumé des changements majeurs.

Ex: Release 1.5.3: OAuth2 support and bug fixes


Description :

Résumé des changements : Liste des features, fixes, et autres changements inclus dans la release (souvent basé sur le CHANGELOG).
Type de release : Mentionnez si c’est une release majeure, mineure ou patch (selon SemVer).
Instructions de déploiement : Notez tout ce qui est nécessaire pour déployer (migrations, mise à jour des dépendances, etc.).


Labels : Utilisez des labels comme release ou version.

Exemple :
markdown**Titre** : Release 1.5.3: OAuth2 support and bug fixes

**Description** :
Cette release inclut :
- Nouvelle fonctionnalité : Support de l'authentification OAuth2 (#45).
- Correction de bugs dans la gestion des sessions (#47).
- Mise à jour des dépendances Symfony.

**Instructions de déploiement** :
1. Exécuter `php bin/console doctrine:migrations:migrate`.
2. Mettre à jour `.env` avec les nouvelles variables OAuth.
3. Vérifier que le serveur Redis est en cours d'exécution.

**Changelog** :
- feat(auth): add OAuth2 login support
- fix(session): resolve session timeout issue
- chore(deps): update Symfony to 7.3.2

Explication de la partie du code
Voici le fragment de code dans la fonction get_pr_changes du script update_changelog.sh :
bash# Check for breaking change label
if echo "$labels" | grep -q "breaking"; then
  breaking+="- $title\n"
fi
Contexte
Ce code fait partie de la boucle qui parcourt les Pull Requests (PR) associées aux commits dans une plage donnée (par exemple, entre deux tags Git ou jusqu’à HEAD). Pour chaque PR, le script récupère :

Le titre de la PR (ex: feat(auth): add OAuth2 login support).
Les labels associés à la PR, via la commande gh pr list --json title,labels,mergedAt.

Les labels sont récupérés sous forme d’une liste de noms séparés par des barres verticales () dans la variable $labels (par exemple, feature|bug si la PR a les labels feature et bug).
Que fait ce code ?

Vérification du label breaking :

La ligne echo "$labels" | grep -q "breaking" vérifie si le mot breaking apparaît dans la liste des labels de la PR.
grep -q est une version "silencieuse" de grep : elle ne produit pas de sortie, mais définit un code de retour (0 si le motif est trouvé, 1 sinon).
La condition if vérifie donc si le label breaking est présent parmi les labels de la PR.


Ajout à la section Breaking Changes :

Si le label breaking est trouvé, le titre de la PR (stocké dans $title) est ajouté à la variable breaking avec le format - <titre>\n.
La variable breaking est utilisée plus tard pour générer la section ### Breaking Changes dans le CHANGELOG.md si elle n’est pas vide.


Pourquoi cette section ? :

Les breaking changes (changements cassants) sont des modifications qui peuvent casser la compatibilité avec les versions précédentes (par exemple, une modification d’API, une suppression de fonctionnalité, ou un changement dans la structure de la base de données).
Selon Semantic Versioning (SemVer), ces changements justifient une incrémentation de la version majeure (ex: de 1.5.3 à 2.0.0).
En les mettant dans une section dédiée (Breaking Changes), tu rends le CHANGELOG plus clair pour les utilisateurs, qui peuvent voir immédiatement les changements nécessitant une attention particulière.

Voici les recommandations en fonction des bonnes pratiques :
1. Pour les features (branches comme feature/xyz, bugfix/xyz)

Meilleure pratique : Squash and merge :

Les branches de features contiennent souvent des commits intermédiaires (ex. : WIP, fix tests, update docs) qui n’ont pas besoin d’être dans l’historique de main.
Le squash merge combine ces commits en un seul, avec un message clair (ex. : Add user authentication feature), ce qui rend l’historique lisible.
Exemple de message : Add feature XYZ (#123) (où #123 est le numéro de la PR).


Pourquoi :

Réduit le bruit dans main.
Aligne avec ton objectif de clarté.
Les features ne nécessitent généralement pas de synchronisation avec develop via cherry-pick, donc le squash ne pose pas de problème.


Mise en œuvre :

Dans GitHub, configure la règle de protection de branche pour main pour permettre “Allow squash merging” (Settings > Branches > Branch protection rules > main).
Assure-toi que les développeurs rédigent des titres de PR clairs, car ils deviennent le message du commit squashé.



2. Pour les releases (branches comme release/X.Y.Z)

Meilleure pratique : Merge commit :

Pour les releases, il est préférable d’utiliser un merge commit standard (pas squash ni rebase) pour fusionner release/X.Y.Z dans main.
Cela crée un commit de merge avec un message comme Merge branch 'release/X.Y.Z', que ton script create_pr_to_sync_develop.sh peut détecter pour extraire les commits à cherry-pick dans develop.


Pourquoi :

Ton workflow tag-release-sync.yml repose sur l’identification du merge commit pour synchroniser release/X.Y.Z avec develop.
Un merge commit préserve l’historique des commits de la branche release, ce qui est utile pour retracer les changements (ex. : pour auditer ou déboguer).
Le squash merge aplatit tout, ce qui casse la logique de cherry-pick dans ton script (comme vu avec l’erreur ^2).


Mise en œuvre :

Dans GitHub, coche “Allow merge commits” pour main (et éventuellement décoche “Allow squash merging” pour les releases si tu veux forcer la discipline).
Configure un message de merge standard ou utilise le titre de la PR pour le merge commit.



3. Pour les hotfixes (branches comme hotfix/X.Y.Z)

Meilleure pratique : Merge commit (similaire aux releases) :

Les hotfixes sont similaires aux releases dans Git Flow : ils doivent être mergés dans main et synchronisés avec develop.
Un merge commit facilite la détection dans ton script (en ajustant le grep pour inclure hotfix/$version).


Alternative : Si tu veux utiliser squash pour les hotfixes (pour un historique encore plus propre), modifie le script pour gérer les hotfixes comme les releases (voir ci-dessous).


aze


VS code clique gauche ouverture fichier dans un nouvel onglet :
Ouvrez les paramètres : Fichier > Préférences > Paramètres (ou Ctrl + ,).
Dans la barre de recherche en haut, tapez "workbench.editor.enablePreview".
Décochez la case pour Workbench > Editor: Enable Preview (elle doit passer à false).
Faites de même pour Workbench > Editor: Enable Preview From Quick Open si vous utilisez souvent Ctrl + P pour ouvrir des fichiers.

Paramétrage github
 After pull requests are merged, you can have head branches deleted automatically.
    Automatically delete head branches => NON
        CI pour supprimer auto les features mergée dans develop
        mais les release/X.Y.Z ou hotfix/X.Y.Z, il vaut mieux les garder après merge dans main via PR
        comme ça script CI sync release dans develop => PR et une fois mergée dans develop => suppression :

            dit moi ce que tu penses de ça :
            en général dans les entreprises les features sont ensuite intégrées via des PR sur develop
            ces PR sont validées par un lead dev via code review, du coup une fois mergées les branches feature/ n'ont pas grand intérêt à être gardées
            D'autant plus qu'après il y a création d'une release qui intègre ces features cette release est souvent déployée sur un environnement de test
            et s'il y a des retours de PR ils sont fait dans la release directement.
            On peut donc mettre en place une ci "on PR closed and branche feature/ merged sur develop => suppression de la branche"
            Par contre il vaut mieux garder les release/ hotfix/ car même si on créer un script de création automatique de PR pour synchroniser la release/ ou hotfix/ avec develop (après que la branche a été mergée via PR sur main) s'il y a des conflits ou que le script plante il vaut mieux garder ces branches et les supprimer manuellement quand on est sûr qu'elles sont bien intégrées partout
            Qu'en penses-tu ?


Ajouter la création auto des labels (genre synchronization) dans la CI :

# Vérifier si le label existe déjà (optionnel, pour éviter de le recréer)
if ! gh api repos/:owner/:repo/labels/$pr_label >/dev/null 2>&1; then
    echo "Label '$pr_label' does not exist. Creating it..."
    # Créer le label avec une couleur et une description (optionnels)
    gh label create "$pr_label" \
        --color "9C27B0" \  # Couleur hex (violet, par exemple ; random si omis)
        --description "Automatic synchronization PR from main to develop" \
        --force  # Met à jour si existant (mais la vérif ci-dessus l'évite)
else
    echo "Label '$pr_label' already exists. Skipping creation."
fi

Remplace repos/:owner/:repo par repos/${{ github.repository }} dans la commande gh api. Par exemple :
bashif ! gh api repos/${{ github.repository }}/labels/$pr_label >/dev/null 2>&1; then
