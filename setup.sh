#!/bin/bash

# Define a marker file to indicate script progression
MARKER_FILE="/root/quilibrium_installer_marker"

# Function to run initial setup and reboot
initial_setup() {
    wget --no-cache -O - https://raw.githubusercontent.com/lamat1111/quilibriumscripts/master/qnode_service_installer | bash
    touch $MARKER_FILE
    echo "Step 1 complete, rebooting now..."
    sudo reboot
}

# Function to check the size of the keys file and act accordingly
check_keys_file() {
    keys_file="/root/ceremonyclient/node/.config/keys.yml"
    while true; do
        keys_size=$(wc -c < "$keys_file")
        if [ "$keys_size" -eq 1252 ]; then
            echo "Keys file size is 1252 bytes, proceeding with further setup..."
            wget --no-cache -O - https://raw.githubusercontent.com/lamat1111/quilibriumscripts/master/tools/store_kickstart | bash
            wget --no-cache -O - https://raw.githubusercontent.com/lamat1111/quilibriumscripts/master/tools/qnode_gRPC_calls_setup | bash
            break
        else
            echo "Keys file size is not 1252 bytes, waiting 5 minutes before checking again..."
            sleep 300  # 5 minutes in seconds
        fi
    done
}

# Function to continue setup after reboot
continue_setup() {
    wget --no-cache -O - https://raw.githubusercontent.com/lamat1111/quilibriumscripts/master/qnode_service_installer | bash
    echo "Step 2 complete, waiting for 45 minutes..."
    sleep 2700  # 45 minutes in seconds

    # Check the size of keys.yml
    check_keys_file
}

# Main script logic
if [ ! -f "$MARKER_FILE" ]; then
    initial_setup
else
    continue_setup
    # Remove marker file to avoid re-running continue_setup on subsequent reboots
    rm -f $MARKER_FILE
    echo "Setup complete."
fi
