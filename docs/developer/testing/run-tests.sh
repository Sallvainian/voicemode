#!/bin/bash
# Run voice-mode tests

source "$(dirname "$0")/common.sh"

# Test suite
run_test_suite() {
    local failed=0
    
    log_info "Starting Claude Code + Voice Mode test suite..."
    
    # Check Claude Code installation
    log_info "=== Claude Code Installation ==="
    if command -v claude &> /dev/null; then
        log_info "Claude Code is installed ✓"
        claude --version
    else
        log_error "Claude Code not installed"
        log_info "Install with: npm install -g @anthropic-ai/claude-code"
        ((failed++))
    fi
    
    # Check Voice Mode MCP
    log_info "=== Voice Mode MCP Status ==="
    if command -v claude &> /dev/null; then
        if claude mcp list | grep -q "voice-mode"; then
            log_info "Voice Mode MCP is installed ✓"
        else
            log_warn "Voice Mode MCP not found"
            log_info "Add with: claude mcp add --scope user voice-mode uvx voice-mode"
            ((failed++))
        fi
    fi
    
    # Check API key
    log_info "=== API Key Configuration ==="
    if [[ -n "${OPENAI_API_KEY:-}" ]]; then
        log_info "OPENAI_API_KEY is set ✓"
    else
        log_error "OPENAI_API_KEY not set"
        log_info "Set with: export OPENAI_API_KEY='your-key'"
        ((failed++))
    fi
    
    # Basic voice test (if Voice Mode installed locally)
    log_info "=== Voice Functionality Test ==="
    if command -v voice-mode &> /dev/null || command -v uvx &> /dev/null; then
        log_info "Testing basic voice functionality..."
        test_voice || ((failed++))
    else
        log_info "Skipping voice test (run from Claude Code for full test)"
    fi
    
    # Optional: Check local services
    log_info "=== Local Services (Optional) ==="
    if [[ -f ~/.voicemode/whisper.cpp/whisper-server ]]; then
        log_info "Whisper installed ✓"
        /service whisper status || log_warn "Whisper not running"
    else
        log_info "Whisper not installed (optional)"
    fi
    
    if [[ -f ~/.voicemode/kokoro-fastapi/start.sh ]]; then
        log_info "Kokoro installed ✓"
        /service kokoro status || log_warn "Kokoro not running"
    else
        log_info "Kokoro not installed (optional)"
    fi
    
    return $failed
}

# Main
main() {
    cd ~/voicemode-testing/voicemode-test || {
        log_error "Test directory not found. Run setup script first."
        exit 1
    }
    
    source .venv/bin/activate
    
    # Run tests
    if run_test_suite; then
        log_info "All tests passed!"
        exit 0
    else
        log_error "Some tests failed!"
        exit 1
    fi
}

main "$@"