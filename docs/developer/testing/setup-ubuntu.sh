#!/bin/bash
# Ubuntu/Debian setup script for fresh testing environment

source "$(dirname "$0")/common.sh"

# Create fresh test user
create_test_user() {
    local username="$TEST_USER"
    local fullname="$TEST_USER_FULLNAME"
    local password="$TEST_USER_PASSWORD"
    
    if id "$username" &>/dev/null; then
        log_warn "Test user '$username' already exists"
        read -p "Delete and recreate user? (y/N) " -n 1 -r
        echo
        if [[ ! $REPLY =~ ^[Yy]$ ]]; then
            log_info "Cancelled"
            exit 0
        fi
        
        log_info "Deleting existing user '$username'..."
        
        # Delete user and home directory
        sudo userdel -r "$username" 2>/dev/null || true
        
        # Remove any remaining files
        sudo rm -rf /home/"$username"
        
        log_info "User deleted"
    fi
    
    log_info "Creating fresh test user '$username'..."
    
    # Create user with home directory
    sudo useradd -m -s /bin/bash -c "$fullname" "$username"
    echo "$username:$password" | sudo chpasswd
    
    # Add to sudo group for installation permissions
    sudo usermod -aG sudo "$username"
    
    log_info "Test user '$username' created successfully"
}

# Main setup
main() {
    log_info "Setting up fresh Ubuntu/Debian testing environment..."
    
    # Check if we have sudo access
    if ! sudo -n true 2>/dev/null; then
        log_error "This script requires sudo access to create/reset test user"
        exit 1
    fi
    
    # Create fresh test user
    create_test_user
    
    log_info "========================================="
    log_info "Fresh test environment ready!"
    log_info "========================================="
    log_info ""
    log_info "Next steps:"
    log_info "1. Switch to test user:"
    log_info "   su - $TEST_USER"
    log_info ""
    log_info "2. Follow the Voice Mode + Claude Code installation docs"
    log_info ""
    log_info "Test user password: $TEST_USER_PASSWORD"
    
    # WSL2 specific notes
    if grep -qi microsoft /proc/version; then
        log_info ""
        log_info "WSL2 detected! Audio setup may be required."
        log_info "See: docs/troubleshooting/wsl2-microphone-access.md"
    fi
}

main "$@"