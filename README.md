# Quilibrium Node Setup/Config Script

This repository contains a Bash script designed to automate the installation and setup of the Quilibrium node service. The script performs the following steps:

1. Updates the machine.
2. Downloads and runs the initial Quilibrium node service installer.
3. Reboots the machine.
4. Resumes the setup after rebooting.
5. Waits for 45 minutes for keys to generate
6. Checks the size of a specific configuration file (`keys.yml`).
7. If the file size is 1252 bytes, it proceeds with further setup.
8. If the file size is not 1252 bytes, it waits 5 minutes and checks again until the file size is correct.
9. Installs the qClient

## Prerequisites

- A Unix-based operating system (e.g., Ubuntu)
- Internet access
- Sufficient permissions to execute `sudo` commands
- Go programming language installed

## Usage

1. **Clone the repository:**
    ```sh
   wget https://raw.githubusercontent.com/TidalWavesNode/quil_nodes/main/setup.sh
    ```

2. **Make the script executable:**
    ```sh
    chmod +x setup.sh
    ```

3. **Run the script:**
    ```sh
    sudo ./setup.sh
    ```
