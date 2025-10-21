Question posée à grok concernant le changelog :

Tu peux m'aider à mettre en place une ci github,
lors de la création ou mise à jour d'une PR sur main (release hotfix)
Met à jour automatiquement le changelog en le recréant depuis le début sur le modèle :
markdown# Changelog

All notable changes to this project are documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),  
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## v1.1.0 - 2025-10-20

[Release v1.1.0](https://github.com/$repo/releases/tag/v1.1.0)

### Added

- feat [#2](https://github.com/$repo/issues/2) : Display version in footer
- feat [#3](https://github.com/$repo/issues/3) : Useful links for developers

## v1.0.0 - 2025-10-13

[Release v1.0.0](https://github.com/$repo/releases/tag/v1.0.0)

### Added

- feat [#1](https://github.com/$repo/issues/1) : My first feature
Pour que ce soit plus lisible, peux tu faire appel à un script .sh dans le yml.
Il y a une subtilité dans la logique, car :
pour la première release 1.0.0 il faut récupérer les informations des PRs merged de features sur main entre son tag v1.0.0 et avant
pour toutes le autres il faut se baser sur la même logique entre 2 tags
MAIS
Pour la release actuelle je ne sais pas trop comment faire mais par exemple il faut les informations des features mergées entre maintenant et le dernier tag
Car le tag actuel ne sera créer qu'au merge de cette même PR tu vois ce que je veux dire ?


sa réponse :

yml :
name: Update Changelog on PR

on:
  pull_request:
    types: [opened, synchronize]
    branches: [main]

jobs:
  update-changelog:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4
        with:
          fetch-depth: 0  # Fetch all history for tags and logs

      - name: Update Changelog
        run: ./.github/scripts/update-changelog.sh

      - name: Commit updated changelog
        uses: stefanzweifel/git-auto-commit-action@v5
        with:
          commit_message: "chore: update CHANGELOG.md"
          file_pattern: CHANGELOG.md
          skip_dirty_check: true

Voici le contenu du script .github/scripts/update-changelog.sh que tu peux créer dans ton repo. Assure-toi de le rendre exécutable (chmod +x .github/scripts/update-changelog.sh localement avant de push).

#!/bin/bash

set -e

# Récupère le repo au format owner/repo
REPO=${GITHUB_REPOSITORY}

# Récupère la branche source de la PR
BRANCH=${GITHUB_HEAD_REF}

# Extrait la version de la branche (assume format comme release/v1.1.0 ou hotfix/v1.1.0)
if [[ $BRANCH =~ ^(release|hotfix)/v([0-9]+\.[0-9]+\.[0-9]+)$ ]]; then
  CURRENT_VERSION=${BASH_REMATCH[2]}
else
  echo "Impossible d'extraire la version de la branche $BRANCH. Assure-toi que la branche est nommée comme release/vX.Y.Z ou hotfix/vX.Y.Z."
  exit 1
fi

# Date actuelle pour la version en cours
CURRENT_DATE=$(date +%Y-%m-%d)

# Liste tous les tags existants triés par date de création (du plus récent au plus ancien)
TAGS=($(git tag -l 'v*' --sort=-creatordate))

# En-tête du changelog
CHANGELOG="# Changelog

All notable changes to this project are documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),  
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

"

# Fonction pour parser les commits et extraire les features (assume format "feat(#issue): message")
parse_changes() {
  local RANGE=$1
  local ADDED=""

  # Récupère les messages de commits (seulement la première ligne avec %s)
  CHANGES=$(git log --pretty=format:"%s" --first-parent $RANGE 2>/dev/null || echo "")

  # Parcourt chaque commit message
  while IFS= read -r COMMIT; do
    if [[ $COMMIT =~ ^feat\(#([0-9]+)\):\ (.*)$ ]]; then
      ISSUE=${BASH_REMATCH[1]}
      MSG=${BASH_REMATCH[2]}
      ADDED+="- feat [#${ISSUE}](https://github.com/${REPO}/issues/${ISSUE}) : ${MSG}\n"
    fi
    # Tu peux ajouter d'autres types ici, ex: pour fix -> ### Fixed
    # if [[ $COMMIT =~ ^fix\(#([0-9]+)\):\ (.*)$ ]]; then ... " - fix [#${ISSUE}]... " et ajouter une section ### Fixed
  done <<< "$CHANGES"

  echo "$ADDED"
}

# Ajoute la section pour la version actuelle (changes depuis le dernier tag jusqu'à HEAD)
CHANGELOG+="
## v${CURRENT_VERSION} - ${CURRENT_DATE}

[Release v${CURRENT_VERSION}](https://github.com/${REPO}/releases/tag/v${CURRENT_VERSION})

"

if [ ${#TAGS[@]} -gt 0 ]; then
  LAST_TAG=${TAGS[0]}
  RANGE="${LAST_TAG}..HEAD"
else
  RANGE="HEAD"  # Si pas de tags, tout depuis le début
fi

ADDED=$(parse_changes "$RANGE")
if [ ! -z "$ADDED" ]; then
  CHANGELOG+="### Added

${ADDED}
"
fi

# Ajoute les sections pour les versions précédentes (du plus récent au plus ancien)
for (( i=0; i<${#TAGS[@]}; i++ )); do
  TAG=${TAGS[i]}
  TAG_DATE=$(git show -s --format=%ci $TAG | cut -d' ' -f1)

  CHANGELOG+="
## ${TAG} - ${TAG_DATE}

[Release ${TAG}](https://github.com/${REPO}/releases/tag/${TAG})

"

  if [ $i -lt $((${#TAGS[@]}-1)) ]; then
    PREV_TAG=${TAGS[i+1]}
    RANGE="${PREV_TAG}..${TAG}"
  else
    # Du premier commit jusqu'au tag
    FIRST_COMMIT=$(git rev-list --max-parents=0 HEAD | tail -n 1)
    RANGE="${FIRST_COMMIT}..${TAG}"
  fi

  ADDED=$(parse_changes "$RANGE")
  if [ ! -z "$ADDED" ]; then
    CHANGELOG+="### Added

${ADDED}
"
  fi
done

# Écrit le changelog dans le fichier
echo -e "$CHANGELOG" > CHANGELOG.md

echo "Changelog mis à jour avec succès pour v${CURRENT_VERSION}."

Explications rapides :

Trigger : La CI s'exécute sur création ou update d'une PR targeting main.
Extraction de la version : Je pars du principe que ta branche source est nommée release/vX.Y.Z ou hotfix/vX.Y.Z. Si ce n'est pas le cas, adapte le regex.
Logique des ranges :

Pour la version actuelle : Commits depuis le dernier tag jusqu'à HEAD (ce qui inclut les merges récents, y compris ceux de la PR en cours si elle est une hotfix/release).
Pour les versions passées : Entre deux tags consécutifs.
Pour la première version : Du premier commit jusqu'au premier tag.


Parsing des commits : Assume que tes messages de commits (ou titles de PR si squash/merge) suivent le format feat(#issue): message. Seules les "feat" sont traitées pour la section ### Added. Ajoute d'autres regex si tu as des fix:, chore:, etc., pour d'autres sections (ex: ### Fixed, ### Changed).
Subtilité pour la release actuelle : Comme le tag n'existe pas encore, on utilise les changes depuis le dernier tag. Le lien vers la release pointe vers un tag futur (qui sera créé au merge). Ça marche car le changelog est commité dans la PR avant merge.
Améliorations possibles : Si tes PRs sont mergées avec des merge commits standards ("Merge pull request #X"), adapte le parsing pour extraire le title de la PR via %b (body) ou utilise gh CLI pour lister les PRs mergées (ex: gh api repos/${REPO}/pulls?state=merged&base=main&sort=updated&direction=desc et filter par date).

Si ça ne match pas exactement ta setup (ex: format des commits, nom des branches), donne plus de détails pour affiner !