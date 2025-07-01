#!/bin/bash

set -e

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m'

print_header() { echo -e "${BLUE}=== $1 ===${NC}"; }
print_info() { echo -e "${BLUE}[INFO]${NC} $1"; }
print_success() { echo -e "${GREEN}[SUCCESS]${NC} $1"; }
print_warning() { echo -e "${YELLOW}[WARNING]${NC} $1"; }
print_error() { echo -e "${RED}[ERROR]${NC} $1"; }

print_header "MPro Package Complete Installer and Tester"

# --- BEGIN: Self-cloning logic for one-liner install ---
REPO_URL="https://github.com/pachadotdev/mpro"
SCRIPT_PATH="install.sh"

# Check if we have the required files
if [[ ! -f "tex/latex/mpro/mpro.sty" ]]; then
    print_info "Required files not found. Cloning repository..."
    TMPDIR=$(mktemp -d /tmp/mpro-luatex-XXXXXX)
    git clone --depth 1 "$REPO_URL" "$TMPDIR"
    cd "$TMPDIR/"
    bash install.sh "$@"
    status=$?
    cd - &>/dev/null
    rm -rf "$TMPDIR"
    exit $status
fi
# --- END: Self-cloning logic for one-liner install ---

# Detect user TeX directory
detect_texmf() {
    local candidates=(
        "$HOME/.TinyTeX/texmf-local"
        "$HOME/texmf"
        "$HOME/.texmf-local"
        "$HOME/Library/texmf"
    )
    
    for dir in "${candidates[@]}"; do
        if [[ -d "$(dirname "$dir")" ]]; then
            echo "$dir"
            return
        fi
    done
    
    echo "$HOME/texmf"
}

TEXMF=$(detect_texmf)
print_info "Using TeX directory: $TEXMF"

# Step 1: Remove old installations

old_locations=(
    "$TEXMF/tex/latex/mpro"
    "$TEXMF/fonts/opentype/public/mpro"
    "$TEXMF/fonts/opentype/mpro"
    "$TEXMF/fonts/otf"
    "$TEXMF/doc/latex/mpro"
)

for location in "${old_locations[@]}"; do
    if [[ -d "$location" ]]; then
        print_info "Removing: $location"
        rm -rf "$location"
    fi
done

# Also remove any orphaned MPro font files
find "$TEXMF" -name "MPro*.otf" -delete 2>/dev/null || true

# Step 2: Install package

# Create target directories
mkdir -p "$TEXMF/tex/latex/mpro"
mkdir -p "$TEXMF/fonts/opentype/public/mpro"

# Copy the .sty file from project
cp "tex/latex/mpro/mpro.sty" "$TEXMF/tex/latex/mpro/"

# Copy font files
find . -name "MPro*.otf" -type f -exec cp {} "$TEXMF/fonts/opentype/public/mpro/" \;

font_count_installed=$(ls "$TEXMF/fonts/opentype/public/mpro/"*.otf 2>/dev/null | wc -l)

# Update TeX database
if command -v mktexlsr &> /dev/null; then
    mktexlsr "$TEXMF" &>/dev/null && print_success "TeX database updated" || print_warning "TeX database update failed"
else
    print_warning "mktexlsr not found, but package may still work"
fi

print_success "Package files copied"

# Step 3: Verify installation

print_info "Testing LuaLaTeX compilation..."

if command -v lualatex &> /dev/null; then
  print_info "Compiling example file doc/latex/mpro/mpro-example.tex with LuaLaTeX..."
  cd doc/latex/mpro
  if lualatex -interaction=nonstopmode mpro-example.tex &>/dev/null; then
    if [[ -f "mpro-example.pdf" ]]; then
      print_success "🎉 SUCCESS! PDF created with LuaLaTeX"
      print_info "Test PDF: $(pwd)/mpro-example.pdf"
      cd - &>/dev/null
    else
      print_warning "LuaLaTeX completed but no PDF found"
      cd - &>/dev/null
    fi
  else
    print_error "LuaLaTeX compilation failed"
    print_info "Try running manually: cd doc/latex/mpro && lualatex mpro-example.tex"
    print_info "Check the log file for detailed error information"
    cd - &>/dev/null
  fi
else
    print_warning "LuaLaTeX not found"
fi

# Final summary
print_header "Installation Summary"

echo "Package installed to: $TEXMF"
echo "Files installed:"
echo "  • $TEXMF/tex/latex/mpro/mpro.sty"
echo "  • $TEXMF/fonts/opentype/public/mpro/*.otf"
echo ""
echo "Usage in your documents:"
echo "  \\documentclass{article}"
echo "  \\usepackage{mpro}"
echo "  \\begin{document}"
echo "  Your content with MPro fonts!"
echo "  \\end{document}"
echo ""
echo "Compile with:"
echo "  lualatex yourdocument.tex"
echo "  # or"
echo "  xelatex yourdocument.tex"

if [[ -f "mpro-test.pdf" ]]; then
    echo ""
    print_success "🎉 INSTALLATION COMPLETE AND TESTED!"
    print_info "Open mpro-test.pdf to see the results"
elif [[ -f "doc/latex/mpro/mpro-example.pdf" ]]; then
    echo ""
    print_success "🎉 INSTALLATION COMPLETE AND TESTED!"
    print_info "Open doc/latex/mpro/mpro-example.pdf to see the results"
else
    echo ""
    print_warning "Installation completed but test compilation failed"
    print_info "Try running manually:"
    if [[ -f "doc/latex/mpro/mpro-example.tex" ]]; then
        print_info "  cd doc/latex/mpro && lualatex mpro-example.tex"
    fi
    print_info "Check for error messages in the output"
fi
