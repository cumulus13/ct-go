# Contributing to ct-go

First off, thank you for considering contributing to ct-go! It's people like you that make ct-go such a great tool.

## Code of Conduct

This project and everyone participating in it is governed by our Code of Conduct. By participating, you are expected to uphold this code.

## How Can I Contribute?

### Reporting Bugs

Before creating bug reports, please check the existing issues as you might find out that you don't need to create one. When you are creating a bug report, please include as many details as possible:

* **Use a clear and descriptive title**
* **Describe the exact steps which reproduce the problem**
* **Provide specific examples to demonstrate the steps**
* **Describe the behavior you observed after following the steps**
* **Explain which behavior you expected to see instead and why**
* **Include screenshots if possible**
* **Include your environment details** (OS, Go version, etc.)

### Suggesting Enhancements

Enhancement suggestions are tracked as GitHub issues. When creating an enhancement suggestion, please include:

* **Use a clear and descriptive title**
* **Provide a step-by-step description of the suggested enhancement**
* **Provide specific examples to demonstrate the steps**
* **Describe the current behavior and explain which behavior you expected to see instead**
* **Explain why this enhancement would be useful**

### Pull Requests

* Fill in the required template
* Do not include issue numbers in the PR title
* Follow the Go coding style
* Include tests when adding new features
* Update documentation when changing functionality
* End all files with a newline

## Development Setup

1. Fork the repo
2. Clone your fork:
   ```bash
   git clone https://github.com/YOUR_USERNAME/ct-go.git
   cd ct-go
   ```

3. Install dependencies:
   ```bash
   go mod download
   ```

4. Create a branch:
   ```bash
   git checkout -b feature/amazing-feature
   ```

5. Make your changes and test:
   ```bash
   go build ./ct
   ./ct --help
   ```

6. Run tests (if available):
   ```bash
   go test ./...
   ```

7. Format your code:
   ```bash
   go fmt ./...
   ```

8. Commit your changes:
   ```bash
   git commit -m "Add amazing feature"
   ```

9. Push to your fork:
   ```bash
   git push origin feature/amazing-feature
   ```

10. Open a Pull Request

## Coding Guidelines

### Go Code Style

* Follow standard Go formatting (use `go fmt`)
* Follow Go best practices and idioms
* Write clear, self-documenting code
* Add comments for complex logic
* Keep functions small and focused
* Use meaningful variable and function names

### Commit Messages

* Use the present tense ("Add feature" not "Added feature")
* Use the imperative mood ("Move cursor to..." not "Moves cursor to...")
* Limit the first line to 72 characters or less
* Reference issues and pull requests liberally after the first line

Example:
```
Add support for multiple file selection

- Implement batch file processing
- Add tests for multi-file operations
- Update documentation

Fixes #123
```

### Documentation

* Update README.md if you change functionality
* Comment exported functions and types
* Add examples for new features
* Keep comments up-to-date with code changes

## Testing

* Write tests for new features
* Ensure all tests pass before submitting PR
* Aim for good test coverage
* Test on multiple platforms if possible (Windows, Linux, macOS)

## Building and Testing Locally

```bash
# Build
make build

# Build for all platforms
make build-all

# Clean build artifacts
make clean

# Run tests
make test

# Format code
make fmt

# Check code quality
make check
```

## Questions?

Feel free to open an issue with your question or contact the maintainers.

## License

By contributing, you agree that your contributions will be licensed under the MIT License.

## Thank You!

Your contributions to open source, large or small, make projects like this possible. Thank you for taking the time to contribute.