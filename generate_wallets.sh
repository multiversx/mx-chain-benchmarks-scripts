#!/bin/bash

output_file="wallets.pem"
echo "" > "$output_file"  

number_of_wallets="$2"

pem_dir="./pem_files"
mkdir -p "$pem_dir"

shard="$1"

for i in $(seq 1 $number_of_wallets); do
    ./keygenerator --key-type mined-wallet --shard "$shard"

    sleep 1

    pem_file=$(ls -t walletKey*.pem | head -n 1)

    mv "$pem_file" "$pem_dir/"

    cat "$pem_dir/$pem_file" >> "$output_file"
done

echo "All wallets have been saved to $output_file."