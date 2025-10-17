#!/bin/bash

set -e # Exit on any error

file_content="USER_NAME=$(whoami)\n"
file_content+="USER_ID=$(id -u)\n"
file_content+="GROUP_ID=$(id -g)\n"
file_content+="MARIADB_DATABASE_NAME=job_search\n"
file_content+="MARIADB_ROOT_PASSWORD=root"

echo -e $file_content > .env.local