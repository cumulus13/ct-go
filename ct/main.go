// File: ct\main.go
// Author: Hadi Cahyadi <cumulus13@gmail.com>
// Date: 2025-11-02
// Description: A powerful command-line tool to copy file contents to clipboard with line number selection support.
// License: MIT

package main

import (
	"bufio"
	"flag"
	"fmt"
	"log"
	"os"
	"strconv"
	"strings"
	"time"

	"github.com/atotto/clipboard"
	"github.com/gen2brain/beeep"
)

const (
	notificationTitle   = "Clipboard Manager"
	notificationTimeout = 3 * time.Second
)

func getText() (string, error) {
	return clipboard.ReadAll()
}

func setText(text string) error {
	return clipboard.WriteAll(text)
}

func readFile(filename string, lineNumbers []int, withoutLineNumber bool) (string, error) {
	file, err := os.Open(filename)
	if err != nil {
		return "", fmt.Errorf("failed to open file: %w", err)
	}
	defer file.Close()

	var lines []string
	scanner := bufio.NewScanner(file)
	currentLine := 1

	// Jika tidak ada line number spesifik, baca semua baris
	if len(lineNumbers) == 0 {
		for scanner.Scan() {
			lines = append(lines, scanner.Text())
		}
	} else {
		// Buat map untuk lookup cepat
		lineMap := make(map[int]bool)
		for _, num := range lineNumbers {
			lineMap[num] = true
		}

		for scanner.Scan() {
			if lineMap[currentLine] {
				line := scanner.Text()
				if withoutLineNumber {
					lines = append(lines, line)
				} else {
					lines = append(lines, fmt.Sprintf("%d. %s", currentLine, line))
				}
			}
			currentLine++
		}
	}

	if err := scanner.Err(); err != nil {
		return "", fmt.Errorf("error reading file: %w", err)
	}

	if len(lines) == 0 {
		return "", fmt.Errorf("no lines found for the specified line numbers")
	}

	return strings.Join(lines, "\n"), nil
}

func sendNotification(title, message string) error {
	// Gunakan beeep untuk cross-platform notification
	err := beeep.Notify(title, message, "")
	if err != nil {
		return fmt.Errorf("notification failed: %w", err)
	}
	return nil
}

func parseLineNumbers(lineNumbersStr string) ([]int, error) {
	if lineNumbersStr == "" {
		return nil, nil
	}

	var result []int
	parts := strings.Split(lineNumbersStr, ",")
	
	for _, part := range parts {
		part = strings.TrimSpace(part)
		if part == "" {
			continue
		}

		num, err := strconv.Atoi(part)
		if err != nil {
			return nil, fmt.Errorf("invalid line number '%s': %w", part, err)
		}

		if num <= 0 {
			return nil, fmt.Errorf("line number must be positive: %d", num)
		}

		result = append(result, num)
	}

	return result, nil
}

func main() {
	lineNumber := flag.Int("l", 0, "Single line number to copy")
	lineNumbers := flag.String("line", "", "Line numbers separated by comma (e.g., 1,3,5)")
	withoutLineNumberPrint := flag.Bool("w", false, "Copy text without line numbers")
	silent := flag.Bool("s", false, "Silent mode (no notifications)")
	
	flag.Usage = func() {
		fmt.Fprintf(os.Stderr, "Usage: %s [options] <file1> [file2...]\n\n", os.Args[0])
		fmt.Fprintf(os.Stderr, "Options:\n")
		flag.PrintDefaults()
		fmt.Fprintf(os.Stderr, "\nExamples:\n")
		fmt.Fprintf(os.Stderr, "  %s file.txt              # Copy entire file\n", os.Args[0])
		fmt.Fprintf(os.Stderr, "  %s -l 5 file.txt         # Copy line 5\n", os.Args[0])
		fmt.Fprintf(os.Stderr, "  %s -line 1,3,5 file.txt  # Copy lines 1, 3, and 5\n", os.Args[0])
		fmt.Fprintf(os.Stderr, "  %s -w -line 2,4 file.txt # Copy lines 2 and 4 without line numbers\n", os.Args[0])
	}

	flag.Parse()

	if flag.NArg() == 0 {
		flag.Usage()
		os.Exit(1)
	}

	// Parse line numbers
	var lineNumbersSlice []int
	var err error

	if *lineNumber > 0 {
		lineNumbersSlice = []int{*lineNumber}
	} else if *lineNumbers != "" {
		lineNumbersSlice, err = parseLineNumbers(*lineNumbers)
		if err != nil {
			log.Fatalf("Error parsing line numbers: %v\n", err)
		}
	}

	// Process files
	var allContent []string
	successCount := 0
	errorCount := 0

	for _, filename := range flag.Args() {
		data, err := readFile(filename, lineNumbersSlice, *withoutLineNumberPrint)
		if err != nil {
			errorMsg := fmt.Sprintf("Error reading '%s': %v", filename, err)
			log.Println(errorMsg)
			
			if !*silent {
				sendNotification("Error", errorMsg)
			}
			
			errorCount++
			continue
		}

		allContent = append(allContent, data)
		successCount++
	}

	if successCount == 0 {
		log.Fatal("No files were successfully read")
	}

	// Copy to clipboard
	finalContent := strings.Join(allContent, "\n\n")
	err = setText(finalContent)
	if err != nil {
		errorMsg := fmt.Sprintf("Failed to copy to clipboard: %v", err)
		log.Fatal(errorMsg)
	}

	// Show success message
	successMsg := fmt.Sprintf("Successfully copied %d file(s) to clipboard", successCount)
	if errorCount > 0 {
		successMsg += fmt.Sprintf(" (%d failed)", errorCount)
	}

	// fmt.Println("-------------------------- END OF LINE -----------")
	fmt.Println(successMsg)

	// Send notification
	if !*silent {
		err = sendNotification(notificationTitle, successMsg)
		if err != nil {
			log.Printf("Warning: %v\n", err)
		}
	}
}