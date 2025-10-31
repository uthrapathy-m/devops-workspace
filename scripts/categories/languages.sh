#!/usr/bin/env bash

###############################################################################
# Programming Languages & Runtimes Installation
###############################################################################

install_languages() {
    log_info "Installing Programming Languages & Runtimes..."

    # Check if we should do interactive tool selection
    if [[ "${INTERACTIVE_TOOLS:-false}" == "true" ]]; then
        select_language_tools
    else
        # Install all tools in category
        install_all_language_tools
    fi

    log_success "Languages & Runtimes installation complete"
}

select_language_tools() {
    echo ""
    echo -e "${BLUE}╔═══════════════════════════════════════════════════════════╗${NC}"
    echo -e "${BLUE}║     Select Individual Languages/Runtimes to Install       ║${NC}"
    echo -e "${BLUE}╚═══════════════════════════════════════════════════════════╝${NC}"
    echo ""

    local tools=(
        "Python 3:python3:install_python3"
        "Node.js:node:install_nodejs"
        "Go:go:install_golang"
    )

    local selected_tools=()

    PS3="Select tool to install (0 to finish and install, q to quit): "

    while true; do
        echo ""
        echo "Currently selected tools:"
        if [[ ${#selected_tools[@]} -eq 0 ]]; then
            echo "  (none)"
        else
            for tool in "${selected_tools[@]}"; do
                local tool_name=$(echo "$tool" | cut -d: -f1)
                echo "  - $tool_name"
            done
        fi
        echo ""

        local menu_options=()
        for tool_info in "${tools[@]}"; do
            local tool_name=$(echo "$tool_info" | cut -d: -f1)
            local tool_cmd=$(echo "$tool_info" | cut -d: -f2)

            # Check if already installed
            if is_installed "$tool_cmd"; then
                menu_options+=("$tool_name (already installed)")
            else
                menu_options+=("$tool_name")
            fi
        done

        menu_options+=("Install All" "Done - Start Installation" "Quit")

        select opt in "${menu_options[@]}"; do
            if [[ "$REPLY" == "q" ]]; then
                echo "Installation cancelled."
                exit 0
            elif [[ "$REPLY" -ge 1 ]] && [[ "$REPLY" -le ${#tools[@]} ]]; then
                local tool_index=$((REPLY - 1))
                local tool_info="${tools[$tool_index]}"
                local tool_name=$(echo "$tool_info" | cut -d: -f1)
                local tool_cmd=$(echo "$tool_info" | cut -d: -f2)

                if is_installed "$tool_cmd"; then
                    echo "  $tool_name is already installed, skipping..."
                else
                    selected_tools+=("$tool_info")
                    echo "  Added: $tool_name"
                fi
                break
            elif [[ "$REPLY" -eq $((${#tools[@]} + 1)) ]]; then
                # Install All
                for tool_info in "${tools[@]}"; do
                    selected_tools+=("$tool_info")
                done
                echo "  Added: All tools"
                break
            elif [[ "$REPLY" -eq $((${#tools[@]} + 2)) ]]; then
                # Done - Start Installation
                if [[ ${#selected_tools[@]} -eq 0 ]]; then
                    echo "No tools selected. Please select at least one."
                    break
                fi

                echo ""
                log_info "Starting installation of selected tools..."
                for tool_info in "${selected_tools[@]}"; do
                    local tool_name=$(echo "$tool_info" | cut -d: -f1)
                    local tool_cmd=$(echo "$tool_info" | cut -d: -f2)
                    local install_func=$(echo "$tool_info" | cut -d: -f3)

                    if ! is_installed "$tool_cmd"; then
                        $install_func
                    fi
                done
                return 0
            elif [[ "$REPLY" -eq $((${#tools[@]} + 3)) ]]; then
                # Quit
                echo "Installation cancelled."
                exit 0
            else
                echo "Invalid option"
                break
            fi
        done
    done
}

install_all_language_tools() {
    # Python 3
    if ! is_installed python3; then
        install_python3
    fi

    # Node.js
    if ! is_installed node; then
        install_nodejs
    fi

    # Go
    if ! is_installed go; then
        install_golang
    fi
}

install_python3() {
    log_info "Installing Python 3..."
    
    case "$OS_FAMILY" in
        debian)
            install_package python3
            install_package python3-pip
            install_package python3-venv
            ;;
        redhat)
            install_package python3
            install_package python3-pip
            ;;
        arch)
            install_package python
            install_package python-pip
            ;;
    esac
    
    verify_installation python3
    verify_installation pip3
}

install_nodejs() {
    log_info "Installing Node.js LTS..."
    
    case "$OS_FAMILY" in
        debian)
            # Install NodeSource repository for latest LTS
            curl -fsSL https://deb.nodesource.com/setup_lts.x | sudo -E bash -
            install_package nodejs
            ;;
        redhat)
            # Install NodeSource repository for latest LTS
            curl -fsSL https://rpm.nodesource.com/setup_lts.x | sudo bash -
            install_package nodejs
            ;;
        arch)
            install_package nodejs
            install_package npm
            ;;
    esac
    
    verify_installation node
    verify_installation npm
}

install_golang() {
    log_info "Installing Go..."
    
    local temp_dir=$(create_temp_dir)
    cd "$temp_dir"
    
    # Get latest stable version
    local version=$(curl -fsSL 'https://go.dev/VERSION?m=text' | head -n1)
    local arch=$(get_arch)
    
    curl -fsSL "https://go.dev/dl/${version}.linux-${arch}.tar.gz" -o go.tar.gz
    
    # Remove existing Go installation
    sudo rm -rf /usr/local/go
    
    # Extract new version
    sudo tar -C /usr/local -xzf go.tar.gz
    
    cleanup_temp_dir "$temp_dir"
    
    # Add to PATH
    add_to_path "/usr/local/go/bin"
    
    # Also add GOPATH/bin
    add_to_path "$HOME/go/bin"
    
    export PATH="/usr/local/go/bin:$PATH"
    verify_installation go
}
