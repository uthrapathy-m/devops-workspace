#!/usr/bin/env bash

###############################################################################
# Interactive Menu System
###############################################################################

show_interactive_menu() {
    clear
    echo -e "${BLUE}╔═══════════════════════════════════════════════════════════╗${NC}"
    echo -e "${BLUE}║         Select DevOps Tool Categories to Install          ║${NC}"
    echo -e "${BLUE}╚═══════════════════════════════════════════════════════════╝${NC}"
    echo ""
    echo "Use Space to select/deselect, Enter to confirm"
    echo ""
    
    # Category options
    local categories=(
        "containers:Containers & Orchestration (Docker, kubectl, k9s, Helm)"
        "cloud_tools:Cloud CLI Tools (AWS, Azure, GCloud, Terraform)"
        "iac_tools:Infrastructure as Code (Ansible, Packer, Vagrant)"
        "cicd_tools:CI/CD Tools (GitHub CLI, GitLab CLI, ArgoCD)"
        "monitoring:Monitoring & Observability (stern, ctop, htop)"
        "productivity:Productivity CLI (fzf, ripgrep, bat, eza, jq, yq)"
        "network_security:Network & Security (nmap, trivy, cosign)"
        "languages:Languages & Runtimes (Python3, Node.js, Go)"
    )
    
    local selected=()
    local current=0
    local total=${#categories[@]}
    
    # Initialize selection array
    for i in "${!categories[@]}"; do
        selected[$i]=false
    done
    
    # Function to draw menu
    draw_menu() {
        clear
        echo -e "${BLUE}╔═══════════════════════════════════════════════════════════╗${NC}"
        echo -e "${BLUE}║         Select DevOps Tool Categories to Install          ║${NC}"
        echo -e "${BLUE}╚═══════════════════════════════════════════════════════════╝${NC}"
        echo ""
        echo "Use ↑↓ arrows to navigate, Space to select, Enter to install, 'a' for all, 'q' to quit"
        echo ""
        
        for i in "${!categories[@]}"; do
            local category_data="${categories[$i]}"
            local category_name="${category_data%%:*}"
            local category_desc="${category_data#*:}"
            
            local checkbox="[ ]"
            if [[ "${selected[$i]}" == "true" ]]; then
                checkbox="${GREEN}[✓]${NC}"
            fi
            
            if [[ $i -eq $current ]]; then
                echo -e "  ${YELLOW}▶${NC} $checkbox $category_desc"
            else
                echo -e "    $checkbox $category_desc"
            fi
        done
        
        echo ""
        echo -e "${BLUE}───────────────────────────────────────────────────────────${NC}"
        local selected_count=$(printf '%s\n' "${selected[@]}" | grep -c "true")
        echo -e "Selected: ${GREEN}$selected_count${NC} of $total categories"
    }
    
    # Check if we have dialog or whiptail
    if command_exists whiptail; then
        use_whiptail_menu
        return
    elif command_exists dialog; then
        use_dialog_menu
        return
    fi
    
    # Fallback to simple menu
    simple_menu
}

simple_menu() {
    echo ""
    PS3="Select category to install (0 to install selected, q to quit): "
    
    local categories=(
        "Containers & Orchestration"
        "Cloud CLI Tools"
        "Infrastructure as Code"
        "CI/CD Tools"
        "Monitoring & Observability"
        "Productivity CLI"
        "Network & Security"
        "Languages & Runtimes"
        "Install All"
    )
    
    local selected_categories=()
    
    while true; do
        echo ""
        echo "Currently selected categories:"
        if [[ ${#selected_categories[@]} -eq 0 ]]; then
            echo "  (none)"
        else
            for cat in "${selected_categories[@]}"; do
                echo "  - $cat"
            done
        fi
        echo ""
        
        select opt in "${categories[@]}" "Done - Start Installation" "Quit"; do
            case $REPLY in
                1) selected_categories+=("containers"); echo "Added: Containers & Orchestration"; break ;;
                2) selected_categories+=("cloud_tools"); echo "Added: Cloud CLI Tools"; break ;;
                3) selected_categories+=("iac_tools"); echo "Added: Infrastructure as Code"; break ;;
                4) selected_categories+=("cicd_tools"); echo "Added: CI/CD Tools"; break ;;
                5) selected_categories+=("monitoring"); echo "Added: Monitoring & Observability"; break ;;
                6) selected_categories+=("productivity"); echo "Added: Productivity CLI"; break ;;
                7) selected_categories+=("network_security"); echo "Added: Network & Security"; break ;;
                8) selected_categories+=("languages"); echo "Added: Languages & Runtimes"; break ;;
                9) 
                    for cat in containers cloud_tools iac_tools cicd_tools monitoring productivity network_security languages; do
                        selected_categories+=("$cat")
                    done
                    echo "Added: All categories"
                    break
                    ;;
                10)
                    if [[ ${#selected_categories[@]} -eq 0 ]]; then
                        echo "No categories selected. Please select at least one."
                        break
                    fi
                    
                    echo ""
                    log_info "Starting installation of selected categories..."
                    for category in "${selected_categories[@]}"; do
                        install_category "$category"
                    done
                    return 0
                    ;;
                11)
                    echo "Installation cancelled."
                    exit 0
                    ;;
                *)
                    echo "Invalid option"
                    break
                    ;;
            esac
        done
    done
}

use_whiptail_menu() {
    local categories=(
        "containers" "Containers & Orchestration (Docker, kubectl, k9s, Helm)" OFF
        "cloud_tools" "Cloud CLI Tools (AWS, Azure, GCloud, Terraform)" OFF
        "iac_tools" "Infrastructure as Code (Ansible, Packer, Vagrant)" OFF
        "cicd_tools" "CI/CD Tools (GitHub CLI, GitLab CLI, ArgoCD)" OFF
        "monitoring" "Monitoring & Observability (stern, ctop, htop)" OFF
        "productivity" "Productivity CLI (fzf, ripgrep, bat, eza, jq, yq)" OFF
        "network_security" "Network & Security (nmap, trivy, cosign)" OFF
        "languages" "Languages & Runtimes (Python3, Node.js, Go)" OFF
    )
    
    local choices=$(whiptail --title "DevOps Workspace Installer" \
        --checklist "Select tool categories to install (Space to select, Enter to confirm):" \
        20 78 8 \
        "${categories[@]}" \
        3>&1 1>&2 2>&3)
    
    if [[ $? -ne 0 ]]; then
        echo "Installation cancelled."
        exit 0
    fi
    
    # Remove quotes from choices
    choices=$(echo "$choices" | tr -d '"')
    
    if [[ -z "$choices" ]]; then
        log_warning "No categories selected."
        exit 0
    fi
    
    # Install selected categories
    for category in $choices; do
        install_category "$category"
    done
}

use_dialog_menu() {
    local categories=(
        "containers" "Containers & Orchestration" OFF
        "cloud_tools" "Cloud CLI Tools" OFF
        "iac_tools" "Infrastructure as Code" OFF
        "cicd_tools" "CI/CD Tools" OFF
        "monitoring" "Monitoring & Observability" OFF
        "productivity" "Productivity CLI" OFF
        "network_security" "Network & Security" OFF
        "languages" "Languages & Runtimes" OFF
    )
    
    local choices=$(dialog --stdout \
        --title "DevOps Workspace Installer" \
        --checklist "Select tool categories:" 20 78 8 \
        "${categories[@]}")
    
    if [[ $? -ne 0 ]]; then
        echo "Installation cancelled."
        exit 0
    fi
    
    if [[ -z "$choices" ]]; then
        log_warning "No categories selected."
        exit 0
    fi
    
    # Install selected categories
    for category in $choices; do
        install_category "$category"
    done
}
