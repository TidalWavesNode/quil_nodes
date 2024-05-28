#!/bin/bash

# Define a marker file to indicate script progression
MARKER_FILE="/root/quilibrium_installer_marker"
LOG_FILE="/var/log/quilibrium_installer.log"

# Function to log messages and show progress
log() {
    message=$1
    echo "$(date +'%Y-%m-%d %H:%M:%S') - $message" | tee -a $LOG_FILE
}

# Function to update the machine
update_machine() {
    log "Updating the machine..."
    sudo apt-get update | tee -a $LOG_FILE
    sudo apt-get upgrade -y | tee -a $LOG_FILE
    log "Machine update complete."
}

# Function to install qClient
install_qclient() {
    log "Installing qClient..."
    cd ~/ceremonyclient/client
    GOEXPERIMENT=arenas go build -o qclient main.go | tee -a $LOG_FILE
    log "qClient installation complete."
}

# Function to run initial setup
initial_setup() {
    log "Starting initial setup..."
    wget --no-cache -O - https://raw.githubusercontent.com/lamat1111/quilibriumscripts/master/qnode_service_installer | bash | tee -a $LOG_FILE
    touch $MARKER_FILE
    log "Step 1 complete."
}

# Function to check the size of the keys file and act accordingly
check_keys_file() {
    keys_file="/root/ceremonyclient/node/.config/keys.yml"
    while true; do
        keys_size=$(wc -c < "$keys_file")
        if [ "$keys_size" -eq 1252 ]; then
            log "Keys file size is 1252 bytes, proceeding with further setup..."
            wget --no-cache -O - https://raw.githubusercontent.com/lamat1111/quilibriumscripts/master/tools/store_kickstart | bash | tee -a $LOG_FILE
            wget --no-cache -O - https://raw.githubusercontent.com/lamat1111/quilibriumscripts/master/tools/qnode_gRPC_calls_setup | bash | tee -a $LOG_FILE
            break
        else
            log "Keys file size is not 1252 bytes, waiting 5 minutes before checking again..."
            sleep 300  # 5 minutes in seconds
        fi
    done
}

# Function to continue setup after initial steps
continue_setup() {
    log "Continuing setup..."
    wget --no-cache -O - https://raw.githubusercontent.com/lamat1111/quilibriumscripts/master/qnode_service_installer | bash | tee -a $LOG_FILE
    log "Step 2 complete, waiting for 45 minutes..."
    sleep 2700  # 45 minutes in seconds

    # Check the size of keys.yml
    check_keys_file

    # Install qClient
    install_qclient
}

# Main script logic
if [ ! -f "$MARKER_FILE" ]; then
    update_machine
    initial_setup
fi
continue_setup
rm -f $MARKER_FILE
log "Setup complete."
