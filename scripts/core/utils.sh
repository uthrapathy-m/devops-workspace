#!/usr/bin/env bash

###############################################################################
# Utility Functions
# Common helper functions for installation scripts
###############################################################################

# Logging functions
log_info() {
    echo -e "${BLUE}[INFO]${NC} $*"
}

log_success() {
    echo -e "${GREEN}[SUCCESS]${NC} $*"
}

log_warning() {
    echo -e "${YELLOW}[WARNING]${NC} $*"
}

log_error() {
    echo -e "${RED}[ERROR]${NC} $*" >&2
}

# Check if command exists
command_exists() {
    command -v "$1" &> /dev/null
}

# Check if tool is already installed
is_installed() {
    local tool=$1
    if command_exists "$tool"; then
        log_info "$tool is already installed ($(command -v $tool))"
        return 0
    fi
    return 1
}

# Download file using curl or wget
download_file() {
    local url=$1
    local output=$2
    
    if command_exists curl; then
        curl -fsSL "$url" -o "$output"
    elif command_exists wget; then
        wget -q "$url" -O "$output"
    else
        log_error "Neither curl nor wget is available"
        return 1
    fi
}

# Extract archive based on extension
extract_archive() {
    local archive=$1
    local dest=${2:-.}
    
    case "$archive" in
        *.tar.gz|*.tgz)
            tar -xzf "$archive" -C "$dest"
            ;;
        *.tar.bz2|*.tbz2)
            tar -xjf "$archive" -C "$dest"
            ;;
        *.tar.xz|*.txz)
            tar -xJf "$archive" -C "$dest"
            ;;
        *.zip)
            unzip -q "$archive" -d "$dest"
            ;;
        *.gz)
            gunzip "$archive"
            ;;
        *)
            log_error "Unknown archive format: $archive"
            return 1
            ;;
    esac
}

# Install binary to /usr/local/bin
install_binary() {
    local binary=$1
    local dest="/usr/local/bin/$(basename $binary)"
    
    sudo cp "$binary" "$dest"
    sudo chmod +x "$dest"
    log_success "Installed $(basename $binary) to $dest"
}

# Get latest GitHub release version
get_latest_github_release() {
    local repo=$1
    local version
    
    if command_exists curl; then
        version=$(curl -fsSL "https://api.github.com/repos/$repo/releases/latest" | grep '"tag_name"' | sed -E 's/.*"([^"]+)".*/\1/')
    elif command_exists wget; then
        version=$(wget -qO- "https://api.github.com/repos/$repo/releases/latest" | grep '"tag_name"' | sed -E 's/.*"([^"]+)".*/\1/')
    fi
    
    echo "$version"
}

# Get system architecture
get_arch() {
    local arch=$(uname -m)
    
    case "$arch" in
        x86_64)
            echo "amd64"
            ;;
        aarch64|arm64)
            echo "arm64"
            ;;
        armv7l)
            echo "armv7"
            ;;
        *)
            echo "$arch"
            ;;
    esac
}

# Get OS type for binary downloads
get_os_type() {
    local os=$(uname -s | tr '[:upper:]' '[:lower:]')
    echo "$os"
}

# Create temporary directory
create_temp_dir() {
    mktemp -d -t devops-workspace.XXXXXXXXXX
}

# Cleanup temporary directory
cleanup_temp_dir() {
    local temp_dir=$1
    if [[ -d "$temp_dir" ]]; then
        rm -rf "$temp_dir"
    fi
}

# Add to PATH in shell rc file
add_to_path() {
    local new_path=$1
    local shell_rc="$HOME/.bashrc"

    if ! grep -q "export PATH.*$new_path" "$shell_rc" 2>/dev/null; then
        echo "export PATH=\"$new_path:\$PATH\"" >> "$shell_rc"
        log_success "Added $new_path to PATH in $shell_rc"
    fi
}

# Verify installation
verify_installation() {
    local tool=$1
    local version_cmd=${2:-"--version"}

    if command_exists "$tool"; then
        # Special handling for kubectl which uses different version command
        if [[ "$tool" == "kubectl" ]]; then
            local version=$($tool version --client --short 2>&1 | head -n1)
        else
            local version=$($tool $version_cmd 2>&1 | head -n1)
        fi
        log_success "$tool installed: $version"
        INSTALLED_TOOLS+=("$tool")
        return 0
    else
        log_error "$tool installation failed or not in PATH"
        return 1
    fi
}

# Install from GitHub release
install_from_github_release() {
    local repo=$1
    local binary_name=$2
    local archive_pattern=$3

    log_info "Installing $binary_name from GitHub: $repo"

    local version=$(get_latest_github_release "$repo")
    if [[ -z "$version" ]]; then
        log_error "Failed to get latest release version"
        return 1
    fi

    local arch=$(get_arch)
    local os=$(get_os_type)
    local temp_dir=$(create_temp_dir)

    # Replace placeholders in archive pattern
    archive_pattern="${archive_pattern//\{version\}/$version}"
    archive_pattern="${archive_pattern//\{os\}/$os}"
    archive_pattern="${archive_pattern//\{arch\}/$arch}"

    local download_url="https://github.com/$repo/releases/download/$version/$archive_pattern"

    log_info "Downloading from: $download_url"

    # Keep the original filename with extension
    local archive_file="$temp_dir/$archive_pattern"

    if download_file "$download_url" "$archive_file"; then
        cd "$temp_dir"
        extract_archive "$archive_pattern"

        # Find binary in extracted files
        local binary_path=$(find . -name "$binary_name" -type f | head -n1)

        if [[ -n "$binary_path" ]]; then
            install_binary "$binary_path"
            cleanup_temp_dir "$temp_dir"
            verify_installation "$binary_name"
            return 0
        else
            log_error "Binary $binary_name not found in archive"
            cleanup_temp_dir "$temp_dir"
            return 1
        fi
    else
        log_error "Failed to download $binary_name"
        cleanup_temp_dir "$temp_dir"
        return 1
    fi
}

# Prompt for confirmation
confirm() {
    local prompt="${1:-Do you want to continue?}"
    local response
    
    read -p "$prompt [y/N] " response
    case "$response" in
        [yY][eE][sS]|[yY]) 
            return 0
            ;;
        *)
            return 1
            ;;
    esac
}

# Check if running in CI/CD environment
is_ci() {
    [[ -n "${CI:-}" ]] || [[ -n "${GITHUB_ACTIONS:-}" ]] || [[ -n "${GITLAB_CI:-}" ]]
}

# Check and install required dependencies
ensure_dependency() {
    local dep=$1
    local package_name=${2:-$dep}

    if ! command_exists "$dep"; then
        log_warning "$dep is not installed. Installing $package_name..."
        install_package "$package_name"

        # Verify it was installed
        if ! command_exists "$dep"; then
            log_error "Failed to install $dep"
            return 1
        fi
        log_success "$dep installed successfully"
    fi
    return 0
}

# Install package based on OS family
install_package() {
    local package=$1

    case "$OS_FAMILY" in
        debian)
            sudo apt-get update -qq
            sudo apt-get install -y "$package"
            ;;
        redhat)
            sudo $PKG_MANAGER install -y "$package"
            ;;
        arch)
            sudo pacman -S --noconfirm "$package"
            ;;
        *)
            log_error "Unsupported OS family: $OS_FAMILY"
            return 1
            ;;
    esac
}

# Ensure common dependencies are installed
ensure_common_dependencies() {
    log_info "Checking for common dependencies..."

    local deps=(
        "unzip"
        "jq"
        "tar"
        "gzip"
        "curl"
    )

    for dep in "${deps[@]}"; do
        ensure_dependency "$dep" || log_warning "Could not install $dep, some installations may fail"
    done

    log_success "Common dependencies check complete"
}
