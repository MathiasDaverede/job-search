#!/bin/bash

GREEN='\033[32m'
LEGENDARY_ORANGE='\033[1;38;5;208m'
RED='\033[31m'
RESET='\033[0m'

USER_NAME=$(whoami)
USER_ID=$(id -u)
GROUP_ID=$(id -g)

echo -e "${GREEN}🚀 Initializing Docker setup for USER_NAME=$USER_NAME, USER_ID=$USER_ID, GROUP_ID=$GROUP_ID${RESET}"

echo -e "${GREEN}🔄 Step 1 : Converting critical files to LF line endings${RESET}"

# Target Symfony text files (.sh, .yaml, .yml, .env*, .editorconfig, composer.json, package.json, *.lock, bin/*), excluding hidden directories except .github
find . -type f \( -not -path "*/\.*/*" -o -path "./.github/*" \) \( -name "*.sh" -o -name "*.yaml" -o -name "*.yml" -o -name ".env*" -o -name ".editorconfig" -o -name "composer.json" -o -name "package.json" -o -name "*.lock" -o -path "./bin/*" \) -exec sed -i 's/\r$//' {} \;

if [ $? -eq 0 ]; then
  echo -e "${GREEN}✅ Line endings converted successfully.${RESET}"
else
  echo -e "${RED}❌ Failed to convert line endings.${RESET}"
  exit 1
fi

echo -e "${GREEN}🔐 Step 2 : Setting executable permissions for bin/ scripts...${RESET}"
chmod +x bin/* 2>/dev/null
if [ $? -eq 0 ]; then
  echo -e "${GREEN}✅ Permissions set successfully.${RESET}"
else
  echo -e "${RED}❌ Failed to set executable permissions.${RESET}"
  exit 1
fi

echo -e "${GREEN}🚀 Step 3 : Starting containers"

if USER_NAME=$USER_NAME USER_ID=$USER_ID GROUP_ID=$GROUP_ID docker compose up --build -d "$@"; then
  echo -e "${LEGENDARY_ORANGE}✨ Containers started successfully! (USER_NAME=$USER_NAME, USER_ID=$USER_ID, GROUP_ID=$GROUP_ID)${RESET}"
else
  echo -e "${RED}❌ Failed to start containers.${RESET}"
  exit 1
fi
