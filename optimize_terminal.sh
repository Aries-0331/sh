#!/bin/bash

# ==============================================================================
# Mac Terminal 一键优化部署脚本
# 包含：Homebrew, Oh My Zsh, P10k, 插件, 字体, 现代 CLI 工具
# ==============================================================================

set -e

echo "🚀 开始优化你的终端环境..."

# 1. 检查并安装 Homebrew
if ! command -v brew &> /dev/null; then
    echo "📦 安装 Homebrew..."
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
    # 为当前 session 添加 brew 路径 (针对 Apple Silicon Mac)
    eval "$(/opt/homebrew/bin/brew shellenv)"
else
    echo "✅ Homebrew 已安装"
fi

# 2. 安装必备命令行工具 (eza, bat, fzf, zoxide)
echo "🛠 安装现代命令行工具..."
brew install git eza bat fzf zoxide

# 3. 安装 Nerd Font (用于显示图标)
echo "🔡 安装 JetBrainsMono Nerd Font..."
brew tap homebrew/cask-fonts
brew install --cask font-jetbrains-mono-nerd-font

# 4. 检查并安装 Oh My Zsh
if [ ! -d "$HOME/.oh-my-zsh" ]; then
    echo "🌈 安装 Oh My Zsh..."
    sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended
else
    echo "✅ Oh My Zsh 已安装"
fi

# 5. 下载主题和插件
ZSH_CUSTOM=${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}

echo "🎨 下载 Powerlevel10k 主题..."
[ ! -d "$ZSH_CUSTOM/themes/powerlevel10k" ] && git clone --depth=1 https://github.com/romkatv/powerlevel10k.git $ZSH_CUSTOM/themes/powerlevel10k

echo "🧩 下载插件 (Autosuggestions & Highlighting)..."
[ ! -d "$ZSH_CUSTOM/plugins/zsh-autosuggestions" ] && git clone https://github.com/zsh-users/zsh-autosuggestions $ZSH_CUSTOM/plugins/zsh-autosuggestions
[ ! -d "$ZSH_CUSTOM/plugins/zsh-syntax-highlighting" ] && git clone https://github.com/zsh-users/zsh-syntax-highlighting.git $ZSH_CUSTOM/plugins/zsh-syntax-highlighting

# 6. 备份并生成新的 .zshrc
echo "📝 配置 .zshrc 文件..."
[ -f "$HOME/.zshrc" ] && cp "$HOME/.zshrc" "$HOME/.zshrc.bak_$(date +%F)"

cat > "$HOME/.zshrc" <<EOF
# --- Oh My Zsh 配置 ---
export ZSH="\$HOME/.oh-my-zsh"

# 使用 Powerlevel10k 主题
ZSH_THEME="powerlevel10k/powerlevel10k"

# 插件列表
plugins=(
    git
    zsh-autosuggestions
    zsh-syntax-highlighting
    zoxide
    fzf
)

source \$ZSH/oh-my-zsh.sh

# --- 别名设置 (Aliases) ---
alias ls="eza --icons --group-directories-first"
alias ll="eza -lh --icons --group-directories-first"
alias la="eza -a --icons --group-directories-first"
alias cat="bat"

# --- 工具初始化 ---
eval "\$(zoxide init zsh)"
[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh

# Powerlevel10k 启动配置 (第一次运行会触发向导)
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh
EOF

echo "✅ 脚本运行完毕！"
echo "-------------------------------------------------------"
echo "💡 最后几步手动操作以激活所有效果："
echo "1. 重启 iTerm2 或执行: source ~/.zshrc"
echo "2. 配置 iTerm2 字体 (必须):"
echo "   Settings -> Profiles -> Text -> Font -> 选择 'JetBrainsMono Nerd Font'"
echo "3. 终端会自动进入 Powerlevel10k 配置向导，按提示选择即可。"
echo "4. (可选) 在 Settings -> Profiles -> Colors 中选择 Dracula 配色。"
echo "-------------------------------------------------------"
