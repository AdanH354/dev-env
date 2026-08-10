#!/bin/sh
set -e

# Colors for output
GREEN='\033[0;32m'
RED='\033[0;31m'
NC='\033[0m'

echo "${GREEN}=== Starting Serial Daemon HMI Setup ===${NC}"

# 1. Detect Package Manager and Install System Dependencies
echo "[1/5] Installing system dependencies (GCC, GLFW3, OpenGL, systemd, sqlite3, OpenSSL)..."

if [ -f /etc/debian_version ]; then
    sudo apt-get update -qq
    sudo apt-get install -y -qq build-essential libglfw3-dev libgl1-mesa-dev \
        git pkg-config libsystemd-dev sqlite3 python3-pip python3-dev \
        libsqlite3-dev python3-systemd openssl
elif [ -f /etc/redhat-release ]; then
    # Fedora/RHEL/CentOS
    sudo dnf install -y gcc-c++ glfw-devel mesa-libGL-devel git pkg-config \
        systemd-devel sqlite sqlite-devel python3-pip python3-devel \
        python3-systemd openssl-devel
elif [ -f /etc/arch-release ]; then
    sudo pacman -Sy --noconfirm base-devel glfw-x11 git pkg-config \
        systemd-libs sqlite python-pip python python-systemd openssl
else
    echo "${RED}Unsupported Linux distribution. Please install GCC, GLFW3, OpenGL, systemd, and sqlite3 headers manually.${NC}"
    exit 1
fi

# 2. Install Python Packages (PyPI packages only)
echo "[2/5] Installing Python packages (pyserial, pymysql)..."

# Check if pip is available
if command -v pip3 >/dev/null 2>&1; then
    PIP_CMD="pip3"
elif command -v pip >/dev/null 2>&1; then
    PIP_CMD="pip"
else
    echo "${RED}pip not found. Please install python3-pip.${NC}"
    exit 1
fi

# Install Python packages from PyPI
$PIP_CMD install --upgrade pip
$PIP_CMD install pyserial pymysql

echo "${GREEN}Python packages installed successfully.${NC}"

# 3. Fetch Dear ImGui with Docking Branch
echo "[3/5] Setting up Dear ImGui headers and backends..."

if [ ! -d "imgui" ]; then
    git clone --depth 1 -b docking https://github.com/ocornut/imgui.git imgui
else
    echo "Directory 'imgui' already exists. Skipping clone."
fi

# 4. Create Project Directory Structure
echo "[4/5] Organizing directories..."
mkdir -p build

# 5. Build the C++ HMI Project
echo "[5/5] Compiling project executable..."

# Check if pkg-config is available for systemd flags
if command -v pkg-config >/dev/null 2>&1; then
    SYSTEMD_CFLAGS=$(pkg-config --cflags libsystemd 2>/dev/null || echo "")
    SYSTEMD_LIBS=$(pkg-config --libs libsystemd 2>/dev/null || echo "-lsystemd")
else
    SYSTEMD_LIBS="-lsystemd"
fi

g++ -std=c++17 main.cpp \
    imgui/imgui.cpp \
    imgui/imgui_draw.cpp \
    imgui/imgui_tables.cpp \
    imgui/imgui_widgets.cpp \
    imgui/backends/imgui_impl_glfw.cpp \
    imgui/backends/imgui_impl_opengl3.cpp \
    -Iimgui -Iimgui/backends \
    -lglfw -lGL -ldl -lpthread \
    ${SYSTEMD_LIBS} \
    -o build/serial_daemon_hmi

# Make the binary executable
chmod +x build/serial_daemon_hmi

echo "${GREEN}=== Setup & Compilation Complete! ===${NC}"
echo "Run the application with: ./build/serial_daemon_hmi"
echo ""
echo "${GREEN}Installed packages:${NC}"
echo "  System:"
echo "    - python3-systemd (systemd integration)"
echo "    - openssl-devel (OpenSSL headers)"
echo "    - sqlite-devel (SQLite headers)"
echo "    - systemd-devel (systemd headers)"
echo "  Python (PyPI):"
echo "    - pyserial (serial communication)"
echo "    - pymysql (MySQL database connectivity)"