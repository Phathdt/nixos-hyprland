#!/usr/bin/env bash

# Sync script from local Mac to NixOS server
# Syncs all folders from /Users/phathdt/Documents/Dev/caliber to nixos:/home/phathdt/Documents/caliber
# SAFE MODE: Only adds/updates files, never deletes
#
# Usage:
#   ./sync.sh           # Interactive mode with progress
#   ./sync.sh --quiet   # Quiet mode for cronjob
#
# Cronjob example (every hour):
#   0 * * * * /path/to/sync.sh --quiet

set -e

# Configuration
LOCAL_PATH="/Users/phathdt/Documents/Dev"
REMOTE_HOST="nixos"
REMOTE_PATH="/home/phathdt/Documents/Dev"
SSH_KEY="~/.ssh/id_rsa"
LOG_FILE="$HOME/.sync-caliber.log"

# Check if running in quiet mode (for cronjob)
QUIET_MODE=false
if [[ "$1" == "--quiet" || "$1" == "-q" ]]; then
    QUIET_MODE=true
fi

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Function to print colored output
print_status() {
    local msg="[$(date '+%Y-%m-%d %H:%M:%S')] [INFO] $1"
    if [ "$QUIET_MODE" = false ]; then
        echo -e "${BLUE}$msg${NC}"
    fi
    echo "$msg" >> "$LOG_FILE"
}

print_success() {
    local msg="[$(date '+%Y-%m-%d %H:%M:%S')] [SUCCESS] $1"
    if [ "$QUIET_MODE" = false ]; then
        echo -e "${GREEN}$msg${NC}"
    fi
    echo "$msg" >> "$LOG_FILE"
}

print_warning() {
    local msg="[$(date '+%Y-%m-%d %H:%M:%S')] [WARNING] $1"
    if [ "$QUIET_MODE" = false ]; then
        echo -e "${YELLOW}$msg${NC}"
    fi
    echo "$msg" >> "$LOG_FILE"
}

print_error() {
    local msg="[$(date '+%Y-%m-%d %H:%M:%S')] [ERROR] $1"
    if [ "$QUIET_MODE" = false ]; then
        echo -e "${RED}$msg${NC}"
    fi
    echo "$msg" >> "$LOG_FILE"
}

# Check if local directory exists
if [ ! -d "$LOCAL_PATH" ]; then
    print_error "Local directory $LOCAL_PATH does not exist!"
    exit 1
fi

# Check SSH connection
print_status "Testing SSH connection to $REMOTE_HOST..."
if ! ssh -i "$SSH_KEY" -o ConnectTimeout=5 "$REMOTE_HOST" "echo 'SSH connection successful'" >/dev/null 2>&1; then
    print_error "Cannot connect to $REMOTE_HOST. Please check your SSH configuration."
    exit 1
fi
print_success "SSH connection to $REMOTE_HOST is working"

# Create remote directory if it doesn't exist
print_status "Ensuring remote directory exists..."
ssh -i "$SSH_KEY" "$REMOTE_HOST" "mkdir -p $REMOTE_PATH"

# Show what will be synced
print_status "Syncing from: $LOCAL_PATH"
print_status "Syncing to: $REMOTE_HOST:$REMOTE_PATH"
print_warning "SAFE MODE: Will NOT delete files on server (only add/update)"

# Rsync command with options - SAFE MODE (no --delete)
print_status "Starting incremental sync (only new/changed files)..."

# Record start time
START_TIME=$(date +%s)

# Initialize tracking variables
PROCESSED_FOLDERS=()
TOTAL_FOLDERS_PROCESSED=0

# Choose rsync options based on mode
if [ "$QUIET_MODE" = true ]; then
    # Quiet mode for cronjob - capture stats
    RSYNC_OUTPUT=$(rsync -avz --stats \
        --checksum \
        --update \
        --include='.*' \
        --include='.git/**' \
        --include='.gitignore' \
        --include='.env*' \
        --include='.eslintrc*' \
        --include='.prettierrc*' \
        --include='.vscode/' \
        --exclude='node_modules/' \
        --exclude='.DS_Store' \
        --exclude='*.log' \
        --exclude='dist/' \
        --exclude='build/' \
        --exclude='bin/' \
        --exclude='.next/' \
        --exclude='coverage/' \
        --exclude='.nyc_output/' \
        --exclude='*.tmp' \
        --exclude='*.temp' \
        --exclude='.cache/' \
        --exclude='yarn-error.log' \
        --exclude='npm-debug.log*' \
        -e "ssh -i $SSH_KEY -o ConnectTimeout=10 -o BatchMode=yes" \
        "$LOCAL_PATH/" \
        "$REMOTE_HOST:$REMOTE_PATH/" 2>&1)

    # Extract useful stats from rsync output
    FILES_TRANSFERRED=$(echo "$RSYNC_OUTPUT" | grep "Number of files transferred:" | awk '{print $5}' || echo "0")
    TOTAL_SIZE=$(echo "$RSYNC_OUTPUT" | grep "Total file size:" | awk '{print $4, $5}' || echo "unknown")
    TRANSFERRED_SIZE=$(echo "$RSYNC_OUTPUT" | grep "Total transferred file size:" | awk '{print $5, $6}' || echo "0")

else
    # Interactive mode with progress display
    print_status "Preparing file list..."

    # Create a temporary file for rsync output
    TEMP_OUTPUT=$(mktemp)

    # Run rsync with standard progress (compatible with older versions)
    rsync -avz --stats --progress \
        --checksum \
        --update \
        --include='.*' \
        --include='.git/**' \
        --include='.gitignore' \
        --include='.env*' \
        --include='.eslintrc*' \
        --include='.prettierrc*' \
        --include='.vscode/' \
        --exclude='node_modules/' \
        --exclude='.DS_Store' \
        --exclude='*.log' \
        --exclude='dist/' \
        --exclude='build/' \
        --exclude='bin/' \
        --exclude='.next/' \
        --exclude='coverage/' \
        --exclude='.nyc_output/' \
        --exclude='*.tmp' \
        --exclude='*.temp' \
        --exclude='.cache/' \
        --exclude='yarn-error.log' \
        --exclude='npm-debug.log*' \
        -e "ssh -i $SSH_KEY" \
        "$LOCAL_PATH/" \
        "$REMOTE_HOST:$REMOTE_PATH/" 2>&1 | while IFS= read -r line; do



        # Parse rsync output for file transfers and stats
        if [[ "$line" =~ ^[[:space:]]*([0-9,]+)[[:space:]]+([0-9]+)%[[:space:]]+([0-9.]+[KMGT]?B/s)[[:space:]]+([0-9:]+)[[:space:]]*$ ]]; then
            # Standard progress line format (clean progress without extra info)
            BYTES="${BASH_REMATCH[1]}"
            PERCENT="${BASH_REMATCH[2]}"
            SPEED="${BASH_REMATCH[3]}"
            TIME="${BASH_REMATCH[4]}"

            # Create progress bar
            PROGRESS_WIDTH=40
            FILLED=$((PERCENT * PROGRESS_WIDTH / 100))
            BAR=$(printf "%*s" $FILLED | tr ' ' '█')
            EMPTY=$(printf "%*s" $((PROGRESS_WIDTH - FILLED)) | tr ' ' '░')

            # Clear line and show progress
            printf "\r\033[K"
            if [ -n "$CURRENT_TOP_FOLDER" ]; then
                printf "${BLUE}[SYNC]${NC} %s [%s] %s%% | %s | %s bytes" "$CURRENT_TOP_FOLDER" "${BAR}${EMPTY}" "$PERCENT" "$SPEED" "$BYTES"
            else
                printf "${BLUE}[SYNC]${NC} [%s] %s%% | %s | %s bytes" "${BAR}${EMPTY}" "$PERCENT" "$SPEED" "$BYTES"
            fi

        elif [[ "$line" =~ ^[[:space:]]*([0-9,]+)[[:space:]]+([0-9]+)%[[:space:]]+([0-9.]+[KMGT]?B/s) ]]; then
            # Alternative progress format (more flexible)
            BYTES="${BASH_REMATCH[1]}"
            PERCENT="${BASH_REMATCH[2]}"
            SPEED="${BASH_REMATCH[3]}"

            # Create progress bar
            PROGRESS_WIDTH=40
            FILLED=$((PERCENT * PROGRESS_WIDTH / 100))
            BAR=$(printf "%*s" $FILLED | tr ' ' '█')
            EMPTY=$(printf "%*s" $((PROGRESS_WIDTH - FILLED)) | tr ' ' '░')

            # Clear line and show progress
            printf "\r\033[K"
            if [ -n "$CURRENT_TOP_FOLDER" ]; then
                printf "${BLUE}[SYNC]${NC} %s [%s] %s%% | %s | %s bytes" "$CURRENT_TOP_FOLDER" "${BAR}${EMPTY}" "$PERCENT" "$SPEED" "$BYTES"
            else
                printf "${BLUE}[SYNC]${NC} [%s] %s%% | %s | %s bytes" "${BAR}${EMPTY}" "$PERCENT" "$SPEED" "$BYTES"
            fi

        elif [[ "$line" =~ ^([a-zA-Z0-9_.-]+)/$ ]] && [[ ! "$line" =~ [0-9]+% ]] && [[ ! "$line" =~ xfer# ]]; then
            # Top-level folder being transferred (folder name ending with /)


            # Extract top-level folder from file path
            TOP_FOLDER="${BASH_REMATCH[1]}"

            # Skip common build/cache folders (but allow .git)
            if [[ "$TOP_FOLDER" != "node_modules" ]] && [[ "$TOP_FOLDER" != "dist" ]] && [[ "$TOP_FOLDER" != "build" ]] && [[ "$TOP_FOLDER" != ".next" ]] && [[ "$TOP_FOLDER" != ".cache" ]]; then
                # Show current top-level folder being processed
                if [[ "$TOP_FOLDER" != "$LAST_TOP_FOLDER" ]] && [[ -n "$TOP_FOLDER" ]] && [[ "$TOP_FOLDER" != "." ]]; then
                    # Complete previous folder if exists
                    if [ -n "$LAST_TOP_FOLDER" ]; then
                        printf "\r\033[K"
                        printf "${BLUE}[SYNC]${NC} %s [████████████████████████████████████████] 100%% | Complete\n" "$LAST_TOP_FOLDER"
                        PROCESSED_FOLDERS+=("$LAST_TOP_FOLDER")
                        ((TOTAL_FOLDERS_PROCESSED++))
                    fi

                    printf "${YELLOW}[FOLDER]${NC} Processing: %s\n" "$TOP_FOLDER"
                    LAST_TOP_FOLDER="$TOP_FOLDER"
                    CURRENT_TOP_FOLDER="$TOP_FOLDER"

                    # Show a simple progress indicator for folder start
                    printf "${BLUE}[SYNC]${NC} %s [░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░] 0%% | Starting..." "$TOP_FOLDER"
                fi
            fi

        elif [[ "$line" =~ ^([a-zA-Z0-9_.-]+)/[^/]+$ ]] && [[ ! "$line" =~ [0-9]+% ]] && [[ ! "$line" =~ xfer# ]]; then
            # File in top-level folder being transferred

            # Extract top-level folder from file path
            TOP_FOLDER="${BASH_REMATCH[1]}"

            # Skip common build/cache folders
            if [[ "$TOP_FOLDER" != "node_modules" ]] && [[ "$TOP_FOLDER" != "dist" ]] && [[ "$TOP_FOLDER" != "build" ]] && [[ "$TOP_FOLDER" != ".next" ]] && [[ "$TOP_FOLDER" != ".cache" ]]; then
                # Show current top-level folder being processed
                if [[ "$TOP_FOLDER" != "$LAST_TOP_FOLDER" ]] && [[ -n "$TOP_FOLDER" ]] && [[ "$TOP_FOLDER" != "." ]]; then
                    # Complete previous folder if exists
                    if [ -n "$LAST_TOP_FOLDER" ]; then
                        printf "\r\033[K"
                        printf "${BLUE}[SYNC]${NC} %s [████████████████████████████████████████] 100%% | Complete\n" "$LAST_TOP_FOLDER"
                        PROCESSED_FOLDERS+=("$LAST_TOP_FOLDER")
                        ((TOTAL_FOLDERS_PROCESSED++))
                    fi

                    printf "${YELLOW}[FOLDER]${NC} Processing: %s\n" "$TOP_FOLDER"
                    LAST_TOP_FOLDER="$TOP_FOLDER"
                    CURRENT_TOP_FOLDER="$TOP_FOLDER"

                    # Show a simple progress indicator for folder start
                    printf "${BLUE}[SYNC]${NC} %s [░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░] 0%% | Starting..." "$TOP_FOLDER"
                fi
            fi



        elif [[ "$line" =~ "sent" ]] && [[ "$line" =~ "received" ]]; then
            # Final transfer summary line - complete last folder
            if [ -n "$CURRENT_TOP_FOLDER" ]; then
                printf "\r\033[K"
                printf "${BLUE}[SYNC]${NC} %s [████████████████████████████████████████] 100%% | Complete\n" "$CURRENT_TOP_FOLDER"
                PROCESSED_FOLDERS+=("$CURRENT_TOP_FOLDER")
                ((TOTAL_FOLDERS_PROCESSED++))
            fi

        elif [[ "$line" =~ "Number of files transferred:" ]]; then
            FILES_TRANSFERRED=$(echo "$line" | awk '{print $5}')
        elif [[ "$line" =~ "Total file size:" ]]; then
            TOTAL_SIZE=$(echo "$line" | awk '{print $4, $5}')
        elif [[ "$line" =~ "Total transferred file size:" ]]; then
            TRANSFERRED_SIZE=$(echo "$line" | awk '{print $5, $6}')
        fi

        # Save line to temp file for stats extraction
        echo "$line" >> "$TEMP_OUTPUT"
    done

    # Final newline after progress
    echo ""

    # Extract stats from saved output if not already captured
    if [ -z "$FILES_TRANSFERRED" ]; then
        FILES_TRANSFERRED=$(grep "Number of files transferred:" "$TEMP_OUTPUT" | awk '{print $5}' || echo "0")
    fi
    if [ -z "$TOTAL_SIZE" ]; then
        TOTAL_SIZE=$(grep "Total file size:" "$TEMP_OUTPUT" | awk '{print $4, $5}' || echo "unknown")
    fi
    if [ -z "$TRANSFERRED_SIZE" ]; then
        TRANSFERRED_SIZE=$(grep "Total transferred file size:" "$TEMP_OUTPUT" | awk '{print $5, $6}' || echo "0")
    fi

    # Clean up temp file
    rm -f "$TEMP_OUTPUT"
fi

# Calculate execution time
END_TIME=$(date +%s)
EXECUTION_TIME=$((END_TIME - START_TIME))

if [ $? -eq 0 ]; then
    print_success "Sync completed successfully!"

    # Show processed folders summary
    if [ ${#PROCESSED_FOLDERS[@]} -gt 0 ]; then
        print_status "=== FOLDERS PROCESSED ==="
        for folder in "${PROCESSED_FOLDERS[@]}"; do
            print_status "✅ $folder"
        done
        print_status "Total folders processed: $TOTAL_FOLDERS_PROCESSED"
    else
        print_status "No folders were processed (no changes detected)"
    fi

    # Show detailed sync summary
    print_status "=== SYNC SUMMARY ==="
    print_status "Local:  $LOCAL_PATH"
    print_status "Remote: $REMOTE_HOST:$REMOTE_PATH"
    print_status "Mode:   SAFE (no deletions)"
    print_status "Files transferred: $FILES_TRANSFERRED"
    print_status "Total size: $TOTAL_SIZE"
    print_status "Transferred size: $TRANSFERRED_SIZE"
    print_status "Execution time: $EXECUTION_TIME seconds"
    print_status "Completed at: $(date)"

    # Show remote directory size
    print_status "Getting remote directory size..."
    REMOTE_SIZE=$(ssh -i "$SSH_KEY" "$REMOTE_HOST" "du -sh $REMOTE_PATH 2>/dev/null | cut -f1" || echo "unknown")
    print_status "Remote directory size: $REMOTE_SIZE"

    # Log rsync output in quiet mode for debugging
    if [ "$QUIET_MODE" = true ] && [ -n "$RSYNC_OUTPUT" ]; then
        echo "[$(date '+%Y-%m-%d %H:%M:%S')] [DEBUG] Rsync output:" >> "$LOG_FILE"
        echo "$RSYNC_OUTPUT" >> "$LOG_FILE"
        echo "[$(date '+%Y-%m-%d %H:%M:%S')] [DEBUG] End rsync output" >> "$LOG_FILE"
    fi

else
    print_error "Sync failed!"

    # Log error details in quiet mode
    if [ "$QUIET_MODE" = true ] && [ -n "$RSYNC_OUTPUT" ]; then
        echo "[$(date '+%Y-%m-%d %H:%M:%S')] [ERROR] Rsync error output:" >> "$LOG_FILE"
        echo "$RSYNC_OUTPUT" >> "$LOG_FILE"
    fi

    exit 1
fi
