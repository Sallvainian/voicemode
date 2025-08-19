#!/bin/bash
# Cleanup voice-mode test installation

source "$(dirname "$0")/common.sh"

# Cleanup function
cleanup() {
    log_info "Starting cleanup..."
    
    cd ~/voicemode-testing/voicemode-test || {
        log_warn "Test directory not found"
        return
    }
    
    source .venv/bin/activate
    
    # Uninstall services
    log_info "Uninstalling services..."
    /whisper_uninstall || log_warn "Whisper uninstall failed"
    /kokoro_uninstall || log_warn "Kokoro uninstall failed"
    
    # Deactivate venv
    deactivate
    
    # Remove test directory
    cd ~
    rm -rf ~/voicemode-testing
    
    log_info "Cleanup complete"
}

# Main
main() {
    read -p "This will remove all test installations. Continue? (y/N) " -n 1 -r
    echo
    if [[ $REPLY =~ ^[Yy]$ ]]; then
        cleanup
    else
        log_info "Cleanup cancelled"
    fi
}

main "$@"