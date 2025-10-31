#!/usr/bin/env bash

###############################################################################
# Monitoring & Observability Tools Installation
###############################################################################

install_monitoring() {
    log_info "Installing Monitoring & Observability tools..."

    # Check if we should do interactive tool selection
    if [[ "${INTERACTIVE_TOOLS:-false}" == "true" ]]; then
        select_monitoring_tools
    else
        # Install all tools in category
        install_all_monitoring_tools
    fi

    log_success "Monitoring tools installation complete"
}

select_monitoring_tools() {
    echo ""
    echo -e "${BLUE}╔═══════════════════════════════════════════════════════════╗${NC}"
    echo -e "${BLUE}║     Select Individual Monitoring Tools to Install         ║${NC}"
    echo -e "${BLUE}╚═══════════════════════════════════════════════════════════╝${NC}"
    echo ""

    local tools=(
        "stern:stern:install_stern"
        "ctop:ctop:install_ctop"
        "htop:htop:install_htop"
        "btop:btop:install_btop"
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

install_all_monitoring_tools() {
    # stern (kubectl logs viewer)
    if ! is_installed stern; then
        install_stern
    fi

    # ctop (container metrics)
    if ! is_installed ctop; then
        install_ctop
    fi

    # htop (system monitor)
    if ! is_installed htop; then
        install_htop
    fi

    # btop (better htop)
    if ! is_installed btop; then
        install_btop
    fi
}

install_stern() {
    log_info "Installing stern..."
    
    install_from_github_release "stern/stern" "stern" "stern_{version}_{os}_{arch}.tar.gz"
}

install_ctop() {
    log_info "Installing ctop..."
    
    local arch=$(get_arch)
    local os=$(get_os_type)
    
    curl -fsSL "https://github.com/bcicen/ctop/releases/download/v0.7.7/ctop-0.7.7-${os}-${arch}" -o /tmp/ctop
    
    sudo install -m 755 /tmp/ctop /usr/local/bin/ctop
    rm /tmp/ctop
    
    verify_installation ctop
}

install_htop() {
    log_info "Installing htop..."
    
    install_package htop
    verify_installation htop
}

install_btop() {
    log_info "Installing btop..."
    
    case "$OS_FAMILY" in
        debian)
            sudo apt-get update
            sudo apt-get install -y btop
            ;;
        redhat)
            sudo $PKG_MANAGER install -y btop
            ;;
        arch)
            sudo pacman -S --noconfirm btop
            ;;
        *)
            log_warning "btop not available in package manager, skipping..."
            return
            ;;
    esac
    
    verify_installation btop
}
