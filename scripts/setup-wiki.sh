#!/bin/bash

# Wiki Integration Setup Script
# Sets up symbolic link to GitHub wiki repository for seamless development workflow

set -e  # Exit on any error

echo "🔧 Setting up Reckie Wiki integration..."

# Check if we're in the correct directory
if [ ! -f "CLAUDE.md" ]; then
    echo "❌ Error: Please run this script from the reckie repository root directory"
    exit 1
fi

# Check if docs/wiki already exists and is properly configured
if [ -L "docs/wiki" ]; then
    echo "✅ Wiki symlink already configured"
    echo "📂 docs/wiki -> $(readlink docs/wiki)"
    exit 0
fi

if [ -d "docs/wiki" ] && [ ! -L "docs/wiki" ]; then
    echo "⚠️  Found existing docs/wiki directory (not a symlink)"
    echo "🗑️  Removing duplicate wiki files from main repository..."
    rm -rf docs/wiki
fi

# Clone wiki repository if it doesn't exist
WIKI_PATH="../reckie.wiki"
if [ ! -d "$WIKI_PATH" ]; then
    echo "📥 Cloning GitHub wiki repository..."
    git clone https://github.com/FreeSideNomad/reckie.wiki.git "$WIKI_PATH"
    echo "✅ Wiki repository cloned to $WIKI_PATH"
else
    echo "✅ Wiki repository already exists at $WIKI_PATH"
    echo "🔄 Updating wiki repository..."
    (cd "$WIKI_PATH" && git pull origin master)
fi

# Create symbolic link
echo "🔗 Creating symbolic link: docs/wiki -> $WIKI_PATH"
ln -s "$WIKI_PATH" docs/wiki

# Ensure docs/wiki is in .gitignore
if ! grep -q "^docs/wiki$" .gitignore 2>/dev/null; then
    echo "📝 Adding docs/wiki to .gitignore..."
    echo "docs/wiki" >> .gitignore
else
    echo "✅ docs/wiki already in .gitignore"
fi

# Verify setup
if [ -L "docs/wiki" ] && [ -d "docs/wiki" ]; then
    echo ""
    echo "🎉 Wiki integration setup complete!"
    echo ""
    echo "📁 Planning documents now available at:"
    echo "   • docs/wiki/Epic-User-LLM-Interaction-Framework.md"
    echo "   • docs/wiki/Essential-Use-Cases-LLM-Interaction.md"
    echo "   • docs/wiki/UI-Mockups-LLM-Interaction.md"
    echo ""
    echo "💡 Usage:"
    echo "   • Edit files in docs/wiki/ normally in VS Code"
    echo "   • Files are version-controlled in separate wiki repository"
    echo "   • Commit changes: cd docs/wiki && git add . && git commit -m '...' && git push"
    echo ""
    echo "📖 See CLAUDE.md for complete workflow documentation"
else
    echo "❌ Setup failed - symbolic link not working properly"
    exit 1
fi