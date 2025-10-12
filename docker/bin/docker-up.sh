#!/bin/bash

GREEN='\033[32m'
LEGENDARY_ORANGE='\033[1;38;5;208m'
RED='\033[31m'
RESET='\033[0m'

USER_NAME=$(whoami)
USER_ID=$(id -u)
GROUP_ID=$(id -g)

echo -e "${GREEN}🚀 Starting containers with USER_NAME=$USER_NAME, USER_ID=$USER_ID, GROUP_ID=$GROUP_ID${RESET}"

if USER_NAME=$USER_NAME USER_ID=$USER_ID GROUP_ID=$GROUP_ID docker compose up --build -d "$@"; then
  echo -e "${LEGENDARY_ORANGE}✨ Containers started successfully! (USER_NAME=$USER_NAME, USER_ID=$USER_ID, GROUP_ID=$GROUP_ID)${RESET}"
else
  echo -e "${RED}❌ Failed to start containers.${RESET}"
  exit 1
fi
