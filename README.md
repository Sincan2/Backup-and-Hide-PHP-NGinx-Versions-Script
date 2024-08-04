# Backup and Hide Versions Script

This script performs automatic backup of PHP and Nginx configuration files, then hides the version information of PHP and Nginx to enhance security.

## Features

- Automatically detects the installed PHP version.
- Backs up the PHP FPM and CLI configuration files.
- Backs up all Nginx configuration files in `/etc/nginx/sites-enabled/*.conf`.
- Modifies the PHP configuration to hide the PHP version.
- Modifies the Nginx configuration files to hide the Nginx version.
- Backs up the script itself before making any changes.
- Restarts the necessary services to apply changes.

## Prerequisites

- Bash shell
- PHP
- Nginx
- Sudo privileges

## Usage

1. Clone this repository to your local machine.

    ```sh
    git clone [https://github.com/Sincan2/backup-hide-versions.git](https://github.com/Sincan2/Backup-and-Hide-PHP-NGinx-Versions-Script.git)
    cd backup-hide-versions
    ```

2. Modify the script to set the backup directory if needed. The default backup directory is `/root/backup`.

3. Make the script executable.

    ```sh
    chmod +x backup_and_hide_versions.sh
    ```

4. Run the script with sudo privileges.

    ```sh
    sudo ./backup_and_hide_versions.sh
    ```

## Script Details

The script performs the following steps:

1. Creates a backup directory if it does not exist.
2. Backs up the PHP FPM configuration file (`php.ini`).
3. Backs up the PHP CLI configuration file (`php.ini`).
4. Backs up all Nginx configuration files in `/etc/nginx/sites-enabled/*.conf`.
5. Backs up the script itself.
6. Modifies the PHP FPM and CLI configuration files to set `expose_php = Off`.
7. Modifies all Nginx configuration files in `/etc/nginx/sites-enabled/*.conf` to add `server_tokens off;` inside the `server {}` block.
8. Restarts PHP FPM and Nginx services to apply the changes.

## Important Notes

- Ensure you have the necessary permissions to read, write, and execute the files and directories involved.
- Test the script in a staging environment before running it in production to avoid any unintended disruptions.

## License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.
