#!/bin/bash
# macOS setup script for fresh testing environment

source "$(dirname "$0")/common.sh"

# Create fresh test user
create_test_user() {
    local username="$TEST_USER"
    local fullname="$TEST_USER_FULLNAME"
    local password="$TEST_USER_PASSWORD"
    
    # Check if user already exists
    if dscl . -read /Users/"$username" &> /dev/null; then
        log_warn "Test user '$username' already exists"
        read -p "Delete and recreate user? (y/N) " -n 1 -r
        echo
        if [[ ! $REPLY =~ ^[Yy]$ ]]; then
            log_info "Cancelled"
            exit 0
        fi
        
        log_info "Deleting existing user '$username'..."
        
        # Delete user account
        sudo dscl . -delete /Users/"$username"
        
        # Remove from groups
        for group in $(dscl . -list /Groups | grep -v '^_'); do
            sudo dscl . -delete /Groups/$group GroupMembership "$username" 2>/dev/null || true
        done
        
        # Remove home directory
        sudo rm -rf /Users/"$username"
        
        log_info "User deleted"
    fi
    
    log_info "Creating fresh test user '$username'..."
    
    # Find next available UID
    local uid=1001
    while dscl . -list /Users UniqueID | grep -q "$uid"; do
        ((uid++))
    done
    
    # Create user
    sudo dscl . -create /Users/"$username"
    sudo dscl . -create /Users/"$username" UserShell /bin/bash
    sudo dscl . -create /Users/"$username" RealName "$fullname"
    sudo dscl . -create /Users/"$username" UniqueID "$uid"
    sudo dscl . -create /Users/"$username" PrimaryGroupID 20
    sudo dscl . -create /Users/"$username" NFSHomeDirectory /Users/"$username"
    sudo dscl . -passwd /Users/"$username" "$password"
    
    # Create home directory
    sudo createhomedir -c -u "$username"
    
    # Make admin for Homebrew installation
    sudo dscl . -append /Groups/admin GroupMembership "$username"
    
    log_info "Test user '$username' created successfully"
}

# Setup user environment
setup_user_environment() {
    log_info "Setting up user environment..."
    
    # Create .bash_profile with custom Homebrew path
    sudo -u "$TEST_USER" tee "/Users/$TEST_USER/.bash_profile" > /dev/null << 'EOF'
# Custom Homebrew installation
export HOMEBREW_PREFIX="$HOME/.homebrew"
export HOMEBREW_CELLAR="$HOMEBREW_PREFIX/Cellar"
export HOMEBREW_REPOSITORY="$HOMEBREW_PREFIX"
export PATH="$HOMEBREW_PREFIX/bin:$HOMEBREW_PREFIX/sbin:$PATH"
export MANPATH="$HOMEBREW_PREFIX/share/man:$MANPATH"
export INFOPATH="$HOMEBREW_PREFIX/share/info:$INFOPATH"

# Note: Homebrew will be installed to ~/.homebrew
# This avoids conflicts with system Homebrew but means:
# - Many packages will build from source (slower)
# - Some packages may not work correctly
# - This setup is not officially supported by Homebrew
EOF

    # Also create .zshrc with same content
    sudo -u "$TEST_USER" tee "/Users/$TEST_USER/.zshrc" > /dev/null << 'EOF'
# Custom Homebrew installation
export HOMEBREW_PREFIX="$HOME/.homebrew"
export HOMEBREW_CELLAR="$HOMEBREW_PREFIX/Cellar"
export HOMEBREW_REPOSITORY="$HOMEBREW_PREFIX"
export PATH="$HOMEBREW_PREFIX/bin:$HOMEBREW_PREFIX/sbin:$PATH"
export MANPATH="$HOMEBREW_PREFIX/share/man:$MANPATH"
export INFOPATH="$HOMEBREW_PREFIX/share/info:$INFOPATH"
EOF

    # Create installation note
    sudo -u "$TEST_USER" tee "/Users/$TEST_USER/HOMEBREW_INSTALL.txt" > /dev/null << 'EOF'
To install Homebrew in your home directory:

1. Clone Homebrew:
   git clone https://github.com/Homebrew/brew ~/.homebrew

2. Initialize (already in your shell profile):
   eval "$(~/.homebrew/bin/brew shellenv)"

3. Update Homebrew:
   brew update --force --quiet

Note: This non-standard installation means many packages will compile from source.
EOF

    sudo chown "$TEST_USER:staff" "/Users/$TEST_USER/.bash_profile"
    sudo chown "$TEST_USER:staff" "/Users/$TEST_USER/.zshrc"
    sudo chown "$TEST_USER:staff" "/Users/$TEST_USER/HOMEBREW_INSTALL.txt"
}

# Main setup
main() {
    log_info "Setting up fresh macOS testing environment..."
    
    # Check if we have sudo access
    if ! sudo -n true 2>/dev/null; then
        log_error "This script requires sudo access to create/reset test user"
        exit 1
    fi
    
    # Create fresh test user
    create_test_user
    
    # Setup user environment with Homebrew paths
    setup_user_environment
    
    log_info "========================================="
    log_info "Fresh test environment ready!"
    log_info "========================================="
    log_info ""
    log_info "Environment configured for user-specific Homebrew in ~/.homebrew"
    log_info ""
    log_info "Next steps:"
    log_info "1. Switch to test user:"
    log_info "   su - $TEST_USER"
    log_info ""
    log_info "2. Install Homebrew:"
    log_info "   git clone https://github.com/Homebrew/brew ~/.homebrew"
    log_info "   brew update"
    log_info ""
    log_info "3. Follow the Voice Mode + Claude Code installation docs"
    log_info ""
    log_info "Test user password: $TEST_USER_PASSWORD"
    log_info ""
    log_info "Note: See ~/HOMEBREW_INSTALL.txt for details"
}

main "$@"