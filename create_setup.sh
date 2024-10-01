#!/bin/bash

GREEN="\033[0;32m"
YELLOW="\033[0;33m"
RED="\033[0;31m"
CYAN="\033[0;36m"
RESET="\033[0m"

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

logo

echo -e "${CYAN}MULTIVERSX Benchmark Setup Starting...${RESET}"

echo -e "${CYAN}Step 1: Starting Terraform apply...${RESET}"
cd ./terraform || { echo -e "${RED}Error: Terraform directory not found!${RESET}"; exit 1; }

terraform apply -auto-approve | tee ../terraform.log &
spinner $!

if [ $? -eq 0 ]; then
    echo -e "${GREEN}Terraform apply completed successfully.${RESET}"
else
    echo -e "${RED}Terraform apply failed. Check terraform.log for details.${RESET}"
    exit 1
fi

echo -e "${CYAN}Step 2: Retrieving instance IPs from Terraform output...${RESET}"
terraform output -json instance_ips | jq -r '.[]' > ../inventory_ips.txt

if [ $? -eq 0 ]; then
    echo -e "${GREEN}Instance IPs retrieved successfully.${RESET}"
else
    echo -e "${RED}Failed to retrieve instance IPs. Check terraform.log for details.${RESET}"
    exit 1
fi

echo -e "${CYAN}Step 3: Creating Ansible inventory...${RESET}"
cd ../ansible || { echo -e "${RED}Error: Ansible directory not found!${RESET}"; exit 1; }
echo "[validators]" > inventory.ini
count=0
for ip in $(cat ../inventory_ips.txt); do
    echo "validator-$count ansible_host=$ip ansible_user=ubuntu" >> inventory.ini
    count=$((count+1))
done

echo -e "${GREEN}Ansible inventory created successfully.${RESET}"

echo -e "${CYAN}Step 4: Starting Ansible playbook to configure validators...${RESET}"
ansible-playbook -i inventory.ini playbook.yml --ssh-common-args='-o StrictHostKeyChecking=accept-new' | tee ../ansible.log &
spinner $!

if [ $? -eq 0 ]; then
    echo -e "${GREEN}Ansible playbook completed successfully.${RESET}"
else
    echo -e "${RED}Ansible playbook failed. Check ansible.log for details.${RESET}"
    exit 1
fi

echo -e "${CYAN}MULTIVERSX Benchmark Setup is complete!${RESET}"
