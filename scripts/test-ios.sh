#!/bin/bash

# Maestro iOS Test Runner
# This script runs all iOS tests and saves reports to reports/ios/

set -e

# Colors for output
GREEN='\033[0;32m'
BLUE='\033[0;34m'
RED='\033[0;31m'
NC='\033[0m' # No Color

echo -e "${BLUE}=== Maestro iOS Test Runner ===${NC}\n"

# Check if iOS simulator is running
if ! xcrun simctl list devices | grep -q "Booted"; then
    echo -e "${RED}Error: No iOS simulator is running${NC}"
    echo "Please start an iOS simulator first"
    exit 1
fi

# Kill any stale maestro processes
echo "Cleaning up stale processes..."
pkill -9 -f "maestro" 2>/dev/null || true

# Get timestamp for report filename
TIMESTAMP=$(date +"%Y%m%d_%H%M%S")
REPORT_DIR="reports/ios"
REPORT_FILE="${REPORT_DIR}/test-results-${TIMESTAMP}.xml"

# Create reports directory if it doesn't exist
mkdir -p "${REPORT_DIR}"

# Run iOS tests
echo -e "\n${BLUE}Running iOS tests...${NC}\n"

if maestro test flows/ios/ --format=JUNIT --output="${REPORT_FILE}"; then
    echo -e "\n${GREEN}✅ All iOS tests passed!${NC}"
    echo -e "Report saved to: ${REPORT_FILE}\n"
    exit 0
else
    echo -e "\n${RED}❌ Some iOS tests failed${NC}"
    echo -e "Report saved to: ${REPORT_FILE}\n"
    exit 1
fi

