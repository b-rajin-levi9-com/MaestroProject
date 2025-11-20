#!/bin/bash

# Maestro Android Test Runner
# This script runs all Android tests and saves reports to reports/android/

set -e

# Colors for output
GREEN='\033[0;32m'
BLUE='\033[0;34m'
RED='\033[0;31m'
NC='\033[0m' # No Color

echo -e "${BLUE}=== Maestro Android Test Runner ===${NC}\n"

# Check if Android emulator is running
if ! adb devices | grep -q "emulator"; then
    echo -e "${RED}Error: No Android emulator is running${NC}"
    echo "Please start an Android emulator first"
    exit 1
fi

# Kill any stale maestro processes
echo "Cleaning up stale processes..."
pkill -9 -f "maestro" 2>/dev/null || true

# Get timestamp for report filename
TIMESTAMP=$(date +"%Y%m%d_%H%M%S")
REPORT_DIR="reports/android"
REPORT_FILE="${REPORT_DIR}/test-results-${TIMESTAMP}.xml"

# Create reports directory if it doesn't exist
mkdir -p "${REPORT_DIR}"

# Run Android tests
echo -e "\n${BLUE}Running Android tests...${NC}\n"

if maestro test flows/android/ --format=JUNIT --output="${REPORT_FILE}"; then
    echo -e "\n${GREEN}✅ All Android tests passed!${NC}"
    echo -e "Report saved to: ${REPORT_FILE}\n"
    exit 0
else
    echo -e "\n${RED}❌ Some Android tests failed${NC}"
    echo -e "Report saved to: ${REPORT_FILE}\n"
    exit 1
fi

