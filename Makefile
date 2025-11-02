BINARY_NAME=ct
VERSION=1.0.0
BUILD_DIR=build
LDFLAGS=-ldflags="-s -w -X main.version=$(VERSION)"

# Colors for output
RED=\033[0;31m
GREEN=\033[0;32m
YELLOW=\033[1;33m
NC=\033[0m # No Color

.PHONY: all build clean install test run help build-all deps

# Default target
all: clean build

# Build for current platform
build:
	@echo "$(GREEN)Building $(BINARY_NAME) for current platform...$(NC)"
	@go build $(LDFLAGS) -o $(BINARY_NAME) ./ct
	@echo "$(GREEN)✓ Build complete: $(BINARY_NAME)$(NC)"

# Build for Windows (from any OS)
build-windows:
	@echo "$(YELLOW)Building for Windows...$(NC)"
	@mkdir -p $(BUILD_DIR)
	@GOOS=windows GOARCH=amd64 go build $(LDFLAGS) -o $(BUILD_DIR)/$(BINARY_NAME)-windows-amd64.exe ./ct
	@echo "$(GREEN)✓ Windows build complete$(NC)"

# Build for Linux (from any OS)
build-linux:
	@echo "$(YELLOW)Building for Linux...$(NC)"
	@mkdir -p $(BUILD_DIR)
	@GOOS=linux GOARCH=amd64 go build $(LDFLAGS) -o $(BUILD_DIR)/$(BINARY_NAME)-linux-amd64 ./ct
	@echo "$(GREEN)✓ Linux build complete$(NC)"

# Build for macOS Intel (from any OS)
build-darwin:
	@echo "$(YELLOW)Building for macOS Intel...$(NC)"
	@mkdir -p $(BUILD_DIR)
	@GOOS=darwin GOARCH=amd64 go build $(LDFLAGS) -o $(BUILD_DIR)/$(BINARY_NAME)-darwin-amd64 ./ct
	@echo "$(GREEN)✓ macOS Intel build complete$(NC)"

# Build for macOS ARM (M1/M2)
build-darwin-arm:
	@echo "$(YELLOW)Building for macOS ARM...$(NC)"
	@mkdir -p $(BUILD_DIR)
	@GOOS=darwin GOARCH=arm64 go build $(LDFLAGS) -o $(BUILD_DIR)/$(BINARY_NAME)-darwin-arm64 ./ct
	@echo "$(GREEN)✓ macOS ARM build complete$(NC)"

# Build for all platforms
build-all: build-windows build-linux build-darwin build-darwin-arm
	@echo "$(GREEN)✓ All builds complete!$(NC)"
	@echo "$(YELLOW)Build artifacts:$(NC)"
	@ls -lh $(BUILD_DIR)/

# Clean build artifacts
clean:
	@echo "$(YELLOW)Cleaning build artifacts...$(NC)"
	@rm -f $(BINARY_NAME) $(BINARY_NAME).exe
	@rm -rf $(BUILD_DIR)
	@echo "$(GREEN)✓ Clean complete$(NC)"

# Install to $GOPATH/bin
install: build
	@echo "$(YELLOW)Installing $(BINARY_NAME)...$(NC)"
	@go install ./ct
	@echo "$(GREEN)✓ Installed to $(shell go env GOPATH)/bin/$(BINARY_NAME)$(NC)"

# Download dependencies
deps:
	@echo "$(YELLOW)Downloading dependencies...$(NC)"
	@go mod download
	@go mod tidy
	@echo "$(GREEN)✓ Dependencies updated$(NC)"

# Run tests
test:
	@echo "$(YELLOW)Running tests...$(NC)"
	@go test -v ./...
	@echo "$(GREEN)✓ Tests complete$(NC)"

# Run the application
run: build
	@echo "$(YELLOW)Running $(BINARY_NAME)...$(NC)"
	@./$(BINARY_NAME)

# Format code
fmt:
	@echo "$(YELLOW)Formatting code...$(NC)"
	@go fmt ./...
	@echo "$(GREEN)✓ Format complete$(NC)"

# Vet code
vet:
	@echo "$(YELLOW)Vetting code...$(NC)"
	@go vet ./...
	@echo "$(GREEN)✓ Vet complete$(NC)"

# Check code quality
check: fmt vet test
	@echo "$(GREEN)✓ All checks passed$(NC)"

# Create release (requires version tag)
release: clean build-all
	@echo "$(YELLOW)Creating release $(VERSION)...$(NC)"
	@mkdir -p $(BUILD_DIR)/release
	@cd $(BUILD_DIR) && \
		zip release/$(BINARY_NAME)-$(VERSION)-windows-amd64.zip $(BINARY_NAME)-windows-amd64.exe && \
		tar czf release/$(BINARY_NAME)-$(VERSION)-linux-amd64.tar.gz $(BINARY_NAME)-linux-amd64 && \
		tar czf release/$(BINARY_NAME)-$(VERSION)-darwin-amd64.tar.gz $(BINARY_NAME)-darwin-amd64 && \
		tar czf release/$(BINARY_NAME)-$(VERSION)-darwin-arm64.tar.gz $(BINARY_NAME)-darwin-arm64
	@echo "$(GREEN)✓ Release packages created in $(BUILD_DIR)/release/$(NC)"
	@ls -lh $(BUILD_DIR)/release/

# Show help
help:
	@echo "$(GREEN)Available targets:$(NC)"
	@echo "  $(YELLOW)make build$(NC)          - Build for current platform"
	@echo "  $(YELLOW)make build-all$(NC)      - Build for all platforms"
	@echo "  $(YELLOW)make build-windows$(NC)  - Build for Windows"
	@echo "  $(YELLOW)make build-linux$(NC)    - Build for Linux"
	@echo "  $(YELLOW)make build-darwin$(NC)   - Build for macOS Intel"
	@echo "  $(YELLOW)make build-darwin-arm$(NC) - Build for macOS ARM"
	@echo "  $(YELLOW)make clean$(NC)          - Remove build artifacts"
	@echo "  $(YELLOW)make install$(NC)        - Install to $$GOPATH/bin"
	@echo "  $(YELLOW)make deps$(NC)           - Download dependencies"
	@echo "  $(YELLOW)make test$(NC)           - Run tests"
	@echo "  $(YELLOW)make run$(NC)            - Build and run"
	@echo "  $(YELLOW)make fmt$(NC)            - Format code"
	@echo "  $(YELLOW)make vet$(NC)            - Vet code"
	@echo "  $(YELLOW)make check$(NC)          - Run fmt, vet, and test"
	@echo "  $(YELLOW)make release$(NC)        - Create release packages"
	@echo "  $(YELLOW)make help$(NC)           - Show this help"