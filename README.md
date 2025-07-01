# Math Pro Font LaTeX Package

A LaTeX package providing the MPro font family for use with LuaLaTeX, including
support for mathematical typesetting.

The goal is to provide a decent font that looks good printed and on screen. I
took inspiration from Garamond-like classic fonts from books I found at the
Senate House Library (London, UK).

The focus is to display mathematical typesetting, therefore the name "mpro"
(Math Pro Font).

This package is shared under the OFL (Open Font License) and is free to use.

Demo: https://github.com/pachadotdev/mpro/blob/main/doc/latex/mpro/mpro-example.pdf

## Usage

Add `mpro` to your LaTeX document preamble:

```latex
% Example document for MPro package
\documentclass{article}
\usepackage{mpro}
% \usepackage[oldstyle]{mpro}  % for old style numbers
% \usepackage[lining]{mpro}    % for lining numbers

\begin{document}

Hello World!

\end{document}
```

Render the document with LuaLaTeX:

```bash
lualatex your_document.tex
```

## Installation

### Unix

Copy and paste this one-line command:

```bash
bash -c "$(wget -qO- https://raw.githubusercontent.com/pachadotdev/mpro/refs/heads/main/install.sh)"
```

Or, if you're a Mac user:

```bash
bash -c "$(curl -sLo- https://raw.githubusercontent.com/pachadotdev/mpro/refs/heads/main/install.sh)"
```

### Windows

To install the Math Pro Font LaTeX package on Windows with MiKTeX, follow these steps:

1. Download the ZIP from GitHub: https://github.com/pachadotdev/mpro/archive/refs/heads/main.zip

2. Extract the ZIP to a folder (e.g., `C:\Downloads\mpro`)

3. Copy files to your local texmf directory  
   - Find your local `texmf` directory (often `C:\Users\<YourName>\texmf`).
   - Copy the contents of the `mpro-main/tex/latex/mpro` folder to  
     `C:\Users\<YourName>\texmf\tex\latex\mpro`
   - Copy the contents of `mpro-main/fonts` to  
     `C:\Users\<YourName>\texmf\fonts`

4. Open the MiKTeX Console and click Refresh FNDB (or run `initexmf --update-fndb` in the command prompt).

5. In MiKTeX Console, go to Tasks > Refresh font map files.

If the `texmf` folder does not exist, you can create it manually.

To find or set your personal texmf directory:

1. Open MiKTeX Console.
2. Go to Settings (the gear icon).
3. Click the Directories tab.
4. Look for a line labeled `UserInstall` or `UserConfig`—your `texmf` folder should be there, or you can add it.

## Donate

If you find this package useful, consider supporting my work:
https://buymeacoffee.com/pacha
