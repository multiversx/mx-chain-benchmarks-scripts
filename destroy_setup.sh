#!/bin/bash

GREEN="\033[0;32m"
YELLOW="\033[0;33m"
RED="\033[0;31m"
CYAN="\033[0;36m"
RESET="\033[0m"

spinner() {
    local pid=$!
    local delay=0.1
    local spinstr='|/-\'
    echo -ne "${YELLOW}In progress...${RESET}"
    while [ "$(ps a | awk '{print $1}' | grep $pid)" ]; do
        local temp=${spinstr#?}
        printf " [%c]  " "$spinstr"
        spinstr=$temp${spinstr%"$temp"}
        sleep $delay
        printf "\b\b\b\b\b\b"
    done
    printf "    \b\b\b\b"
    echo -e "${GREEN}Done!${RESET}"
}

logo() {
    echo -e "${CYAN}"
    cat << "EOF"
 __  __       _ _   _                   __  __
|  \/  |_   _| | |_(_)_   _____ _ __ ___\ \/ /
| |\/| | | | | | __| \ \ / / _ \ '__/ __|\  / 
| |  | | |_| | | |_| |\ V /  __/ |  \__ \/  \ 
|_|  |_|\__,_|_|\__|_| \_/ \___|_|  |___/_/\_\
                                                                 
EOF
    echo -e "${RESET}"
}

logo

echo -e "${CYAN}MULTIVERSX Benchmark Teardown Starting...${RESET}"

echo -e "${CYAN}Step 1: Destroying all Terraform resources...${RESET}"
cd ./terraform || { echo -e "${RED}Error: Terraform directory not found!${RESET}"; exit 1; }

terraform destroy -auto-approve | tee ../terraform-destroy.log &
spinner $!

if [ $? -eq 0 ]; then
    echo -e "${GREEN}Terraform destroy completed successfully.${RESET}"
else
    echo -e "${RED}Terraform destroy failed. Check terraform-destroy.log for details.${RESET}"
    exit 1
fi

echo -e "${CYAN}Step 2: Cleaning up logs and temporary files...${RESET}"
rm -f ../inventory_ips.txt ../inventory.ini

echo -e "${GREEN}Teardown complete!${RESET}"
