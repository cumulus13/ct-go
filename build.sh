#!/bin/bash

# ct-go build script for Linux/macOS
# Author: cumulus13
# Description: Build ct binary for multiple platforms

set -e

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Configuration
BINARY_NAME="ct"
VERSION="1.0.0"
BUILD_DIR="build"
LDFLAGS="-s -w -X main.version=${VERSION}"

# Print colored message
print_message() {
    local color=$1
    shift
    echo -e "${color}$@${NC}"
}

# Print header
print_header() {
    echo ""
    print_message "$BLUE" "=================================="
    print_message "$BLUE" "  CT-GO Build Script"
    print_message "$BLUE" "  Version: ${VERSION}"
    print_message "$BLUE" "=================================="
    echo ""
}

# Check if Go is installed
check_go() {
    if ! command -v go &> /dev/null; then
        print_message "$RED" "Error: Go is not installed!"
        print_message "$YELLOW" "Please install Go from https://golang.org/dl/"
        exit 1
    fi
    print_message "$GREEN" "✓ Go version: $(go version)"
}

# Clean previous builds
clean_build() {
    print_message "$YELLOW" "Cleaning previous builds..."
    rm -rf ${BUILD_DIR}
    rm -f ${BINARY_NAME} ${BINARY_NAME}.exe
    print_message "$GREEN" "✓ Clean complete"
}

# Create build directory
create_build_dir() {
    mkdir -p ${BUILD_DIR}
}

# Build for Windows
build_windows() {
    print_message "$YELLOW" "Building for Windows (amd64)..."
    GOOS=windows GOARCH=amd64 go build -ldflags="${LDFLAGS}" -o ${BUILD_DIR}/${BINARY_NAME}-windows-amd64.exe ./ct
    if [ $? -eq 0 ]; then
        print_message "$GREEN" "✓ Windows build complete: ${BUILD_DIR}/${BINARY_NAME}-windows-amd64.exe"
    else
        print_message "$RED" "✗ Windows build failed"
        exit 1
    fi
}

# Build for Linux
build_linux() {
    print_message "$YELLOW" "Building for Linux (amd64)..."
    GOOS=linux GOARCH=amd64 go build -ldflags="${LDFLAGS}" -o ${BUILD_DIR}/${BINARY_NAME}-linux-amd64 ./ct
    if [ $? -eq 0 ]; then
        chmod +x ${BUILD_DIR}/${BINARY_NAME}-linux-amd64
        print_message "$GREEN" "✓ Linux build complete: ${BUILD_DIR}/${BINARY_NAME}-linux-amd64"
    else
        print_message "$RED" "✗ Linux build failed"
        exit 1
    fi
}

# Build for macOS Intel
build_darwin_amd64() {
    print_message "$YELLOW" "Building for macOS Intel (amd64)..."
    GOOS=darwin GOARCH=amd64 go build -ldflags="${LDFLAGS}" -o ${BUILD_DIR}/${BINARY_NAME}-darwin-amd64 ./ct
    if [ $? -eq 0 ]; then
        chmod +x ${BUILD_DIR}/${BINARY_NAME}-darwin-amd64
        print_message "$GREEN" "✓ macOS Intel build complete: ${BUILD_DIR}/${BINARY_NAME}-darwin-amd64"
    else
        print_message "$RED" "✗ macOS Intel build failed"
        exit 1
    fi
}

# Build for macOS ARM (M1/M2)
build_darwin_arm64() {
    print_message "$YELLOW" "Building for macOS ARM (arm64)..."
    GOOS=darwin GOARCH=arm64 go build -ldflags="${LDFLAGS}" -o ${BUILD_DIR}/${BINARY_NAME}-darwin-arm64 ./ct
    if [ $? -eq 0 ]; then
        chmod +x ${BUILD_DIR}/${BINARY_NAME}-darwin-arm64
        print_message "$GREEN" "✓ macOS ARM build complete: ${BUILD_DIR}/${BINARY_NAME}-darwin-arm64"
    else
        print_message "$RED" "✗ macOS ARM build failed"
        exit 1
    fi
}

# Show build summary
show_summary() {
    echo ""
    print_message "$BLUE" "=================================="
    print_message "$BLUE" "  Build Summary"
    print_message "$BLUE" "=================================="
    echo ""
    
    if [ -d "${BUILD_DIR}" ]; then
        print_message "$GREEN" "Build artifacts in ${BUILD_DIR}/:"
        ls -lh ${BUILD_DIR}/ | tail -n +2 | while read -r line; do
            echo "  $line"
        done
        
        echo ""
        print_message "$BLUE" "Total size:"
        du -sh ${BUILD_DIR}
    fi
    
    echo ""
    print_message "$GREEN" "✓ All builds completed successfully!"
    echo ""
}

# Show usage
usage() {
    echo "Usage: $0 [options]"
    echo ""
    echo "Options:"
    echo "  all           Build for all platforms (default)"
    echo "  windows       Build for Windows only"
    echo "  linux         Build for Linux only"
    echo "  darwin        Build for macOS Intel only"
    echo "  darwin-arm    Build for macOS ARM only"
    echo "  clean         Clean build artifacts only"
    echo "  help          Show this help message"
    echo ""
    echo "Examples:"
    echo "  $0              # Build for all platforms"
    echo "  $0 windows      # Build for Windows only"
    echo "  $0 clean        # Clean build artifacts"
}

# Main function
main() {
    print_header
    check_go
    
    local target=${1:-all}
    
    case $target in
        all)
            clean_build
            create_build_dir
            build_windows
            build_linux
            build_darwin_amd64
            build_darwin_arm64
            show_summary
            ;;
        windows)
            clean_build
            create_build_dir
            build_windows
            show_summary
            ;;
        linux)
            clean_build
            create_build_dir
            build_linux
            show_summary
            ;;
        darwin)
            clean_build
            create_build_dir
            build_darwin_amd64
            show_summary
            ;;
        darwin-arm)
            clean_build
            create_build_dir
            build_darwin_arm64
            show_summary
            ;;
        clean)
            clean_build
            print_message "$GREEN" "✓ Cleanup complete"
            ;;
        help)
            usage
            ;;
        *)
            print_message "$RED" "Error: Unknown option '$target'"
            echo ""
            usage
            exit 1
            ;;
    esac
}

# Run main function
main "$@"