# 🖥️ Serial Daemon HMI – Development Environment Setup
Automated Linux setup script + C++ GUI template for serial device monitoring. Builds a Dear ImGui HMI with GLFW/OpenGL, installs system dependencies (GCC, systemd, sqlite3, OpenSSL) and Python packages (pyserial, pymysql). Ideal for embedded systems, industrial automation, and serial communication dashboards.

# ✨ Features
🔧 One‑Command Setup – Detects your Linux distribution (Debian/Ubuntu, Fedora/RHEL, Arch) and installs all required packages

🖥️ Modern GUI Framework – Uses Dear ImGui with docking branch for interactive dashboards

⚡ Real‑time Rendering – OpenGL 3.2 + GLFW for smooth, cross‑platform graphics

🔌 Serial Ready – Includes pyserial and pymysql for serial communication and database integration

📁 Structured Project – Organized directories and build output in build/

# 📋 Requirements
Requirement	Details
OS	Linux (Debian/Ubuntu, Fedora/RHEL, Arch)
Compiler	GCC (installed automatically)
Build Tools	build-essential, pkg-config, git
Libraries	GLFW3, OpenGL, systemd, sqlite3, OpenSSL

# 🚀 Quick Start
bash
git clone https://github.com/AdanH354/dev-env.git
cd dev-env
chmod +x install_dependencies.sh
./install_dependencies.sh
./build/serial_daemon_hmi
The script will:

Install system dependencies

Install Python packages (pyserial, pymysql)

Clone Dear ImGui (docking branch)

Build the HMI executable

# 🛠️ Tech Stack
C++17 – Core application logic

Dear ImGui – Immediate‑mode GUI

GLFW + OpenGL – Windowing and rendering

Bash – Automated setup script

Python – Serial & database modules

