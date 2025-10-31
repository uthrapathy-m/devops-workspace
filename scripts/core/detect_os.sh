#!/usr/bin/env bash

###############################################################################
# OS Detection Script
# Detects Linux distribution and sets appropriate package manager
###############################################################################

detect_os() {
    # Initialize variables
    OS_NAME=""
    OS_VERSION=""
    OS_FAMILY=""
    PKG_MANAGER=""
    PKG_INSTALL_CMD=""
    PKG_UPDATE_CMD=""
    
    # Detect OS using /etc/os-release
    if [[ -f /etc/os-release ]]; then
        . /etc/os-release
        OS_NAME=$NAME
        OS_VERSION=$VERSION_ID
        
        # Determine OS family and package manager
        case "$ID" in
            ubuntu|debian|linuxmint|pop)
                OS_FAMILY="debian"
                PKG_MANAGER="apt-get"
                PKG_INSTALL_CMD="apt-get install -y"
                PKG_UPDATE_CMD="apt-get update"
                ;;
            fedora|rhel|centos|rocky|almalinux)
                OS_FAMILY="redhat"
                if command -v dnf &> /dev/null; then
                    PKG_MANAGER="dnf"
                    PKG_INSTALL_CMD="dnf install -y"
                    PKG_UPDATE_CMD="dnf check-update"
                else
                    PKG_MANAGER="yum"
                    PKG_INSTALL_CMD="yum install -y"
                    PKG_UPDATE_CMD="yum check-update"
                fi
                ;;
            arch|manjaro)
                OS_FAMILY="arch"
                PKG_MANAGER="pacman"
                PKG_INSTALL_CMD="pacman -S --noconfirm"
                PKG_UPDATE_CMD="pacman -Sy"
                ;;
            opensuse*|sles)
                OS_FAMILY="suse"
                PKG_MANAGER="zypper"
                PKG_INSTALL_CMD="zypper install -y"
                PKG_UPDATE_CMD="zypper refresh"
                ;;
            *)
                log_warning "Unknown distribution: $ID"
                OS_FAMILY="unknown"
                ;;
        esac
    else
        log_error "Cannot detect OS. /etc/os-release not found"
        exit 1
    fi
    
    # Export variables for use in other scripts
    export OS_NAME
    export OS_VERSION
    export OS_FAMILY
    export PKG_MANAGER
    export PKG_INSTALL_CMD
    export PKG_UPDATE_CMD
}

# Check if running as root
is_root() {
    [[ $EUID -eq 0 ]]
}

# Get sudo command prefix
get_sudo() {
    if is_root; then
        echo ""
    else
        echo "sudo"
    fi
}

# Install package using detected package manager
install_package() {
    local package=$1
    local sudo_cmd=$(get_sudo)
    
    log_info "Installing package: $package"
    
    case "$OS_FAMILY" in
        debian)
            $sudo_cmd apt-get update -qq
            $sudo_cmd apt-get install -y "$package"
            ;;
        redhat)
            $sudo_cmd $PKG_MANAGER install -y "$package"
            ;;
        arch)
            $sudo_cmd pacman -S --noconfirm "$package"
            ;;
        suse)
            $sudo_cmd zypper install -y "$package"
            ;;
        *)
            log_error "Unsupported OS family: $OS_FAMILY"
            return 1
            ;;
    esac
}

# Update package cache
update_package_cache() {
    local sudo_cmd=$(get_sudo)
    
    log_info "Updating package cache..."
    
    case "$OS_FAMILY" in
        debian)
            $sudo_cmd apt-get update -qq
            ;;
        redhat)
            $sudo_cmd $PKG_MANAGER check-update || true
            ;;
        arch)
            $sudo_cmd pacman -Sy
            ;;
        suse)
            $sudo_cmd zypper refresh
            ;;
    esac
}

# Get package name for different distros
get_package_name() {
    local generic_name=$1
    
    case "$OS_FAMILY" in
        debian)
            case "$generic_name" in
                build-essential) echo "build-essential" ;;
                python3-pip) echo "python3-pip" ;;
                *) echo "$generic_name" ;;
            esac
            ;;
        redhat)
            case "$generic_name" in
                build-essential) echo "gcc gcc-c++ make" ;;
                python3-pip) echo "python3-pip" ;;
                *) echo "$generic_name" ;;
            esac
            ;;
        arch)
            case "$generic_name" in
                build-essential) echo "base-devel" ;;
                python3-pip) echo "python-pip" ;;
                *) echo "$generic_name" ;;
            esac
            ;;
        *)
            echo "$generic_name"
            ;;
    esac
}
