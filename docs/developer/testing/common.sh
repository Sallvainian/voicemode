#!/bin/bash
# Common functions for testing scripts

set -euo pipefail

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Load configuration from .env if it exists
SCRIPT_DIR="$(dirname "$0")"
if [[ -f "$SCRIPT_DIR/.env" ]]; then
    set -a  # Auto-export all variables
    source "$SCRIPT_DIR/.env"
    set +a
elif [[ -f "$SCRIPT_DIR/.env.example" ]]; then
    log_info "Using .env.example as template. Copy to .env to customize."
    set -a
    source "$SCRIPT_DIR/.env.example"
    set +a
fi

# Set defaults if not provided
TEST_USER="${TEST_USER:-voicemodetest}"
TEST_USER_FULLNAME="${TEST_USER_FULLNAME:-Voice Mode Test}"
TEST_USER_PASSWORD="${TEST_USER_PASSWORD:-testpass123}"
REPO_URL="${REPO_URL:-https://github.com/mbailey/voicemode-config-refactor.git}"
REPO_BRANCH="${REPO_BRANCH:-feature/unified-configuration}"
SKIP_HOMEBREW="${SKIP_HOMEBREW:-0}"
AUTO_ENABLE_SERVICES="${AUTO_ENABLE_SERVICES:-1}"

# Logging functions
log_info() {
    echo -e "${GREEN}[INFO]${NC} $1"
}

log_warn() {
    echo -e "${YELLOW}[WARN]${NC} $1"
}

log_error() {
    echo -e "${RED}[ERROR]${NC} $1"
}

# Check if running as appropriate user
check_user() {
    if [[ $EUID -eq 0 ]]; then
        log_error "This script should not be run as root"
        exit 1
    fi
}

# Clone and setup repository
setup_repo() {
    local repo_url="${1:-$REPO_URL}"
    local branch="${2:-$REPO_BRANCH}"
    
    log_info "Cloning repository..."
    git clone "$repo_url" voicemode-test
    cd voicemode-test
    git checkout "$branch"
}

# Setup Python environment
setup_python_env() {
    log_info "Setting up Python environment..."
    
    # Install uv if not present
    if ! command -v uv &> /dev/null; then
        log_info "Installing uv..."
        curl -LsSf https://astral.sh/uv/install.sh | sh
        export PATH="$HOME/.cargo/bin:$PATH"
    fi
    
    # Create virtual environment
    uv venv
    source .venv/bin/activate
    uv pip install -e .
}

# Run basic voice-mode commands
test_basic_commands() {
    log_info "Testing basic commands..."
    
    # Check audio devices
    /check_audio_devices || log_warn "Audio device check failed"
    
    # Check voice status
    /voice_status || log_warn "Voice status check failed"
}

# Test service operations
test_service() {
    local service="$1"
    
    log_info "Testing $service service..."
    
    # Status
    /service "$service" status
    
    # Stop/Start
    /service "$service" stop
    sleep 2
    /service "$service" start
    sleep 2
    
    # Restart
    /service "$service" restart
    sleep 2
    
    # Logs
    /service "$service" logs | head -20
}

# Test voice functionality
test_voice() {
    log_info "Testing voice functionality..."
    
    # Test TTS only
    /converse "Testing text to speech" wait_for_response=false
    sleep 2
    
    # Test full conversation with short timeout
    /converse "Say hello" listen_duration=5
}

# Wait for service to be ready
wait_for_service() {
    local service="$1"
    local max_attempts="${2:-30}"
    local attempt=0
    
    log_info "Waiting for $service to be ready..."
    
    while (( attempt < max_attempts )); do
        if /service "$service" status | grep -q "running"; then
            log_info "$service is ready"
            return 0
        fi
        sleep 1
        ((attempt++))
    done
    
    log_error "$service failed to start within $max_attempts seconds"
    return 1
}