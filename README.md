# Trident-OS
A privacy OS, open source to all.

# 🔱 Trident Privacy OS

A lightweight, privacy-focused environment sandbox designed to run securely within cloud-hosted development containers (like GitHub Codespaces). Trident OS features an isolated, tracker-free search engine proxy, a custom theme configuration engine, and a pre-installed terminal-based classic games drawer.

---

## 🚀 Features

### 1. 🛡️ Isolated Trident Search Engine
A zero-tracking, proxy-based web search interface. It routes search queries through a clean backend wrapper to fetch data from index pools without exposing your user agent, cookies, or tracking footprint to upstream networks.

### 2. 🎛️ First-Time Boot Gatekeeper & Setup Wizard
Detects a fresh system on launch. If a profile doesn't exist, it intercepts the startup flow and launches an interactive terminal setup matrix to configure your workspace properties on the fly.

### 3. 🎨 Custom Canvas Customization
* **Interface Workspace Modes:** Full toggle states for **Light Mode** and **Dark Mode**.
* **System Accent Profiles:** Pick matching desktop hues from **Rose, Beach, Blue, or Cocktail**.
* **Dynamic ASCII Rendering Core:** A standalone processing script that reads system profile variables and mathematically constructs an animated celebration cake, aligning burning flame matches precisely over any vowel anchors (`I` or `i`) found in your system username.

### 4. 🕹️ Offline Classic Games Drawer
Includes a full array of zero-connectivity, low-latency classic application tools for system testing:
* **Minesweeper:** Terminal logic puzzle matrix.
* **Solitaire:** Classic window-performance and frame-drag tester.
* **Snake:** 2D keyboard-driven directional navigation canvas.
* **Tetris:** Low-latency block fall emulator.
* **Chess:** Local, zero-connectivity engine for Human vs. AI matches.

---

## 🛠️ How to Deploy in 60 Seconds (GitHub Codespaces)

Since Trident OS is designed to bypass local device hardware limits and run anywhere, anyone can spin up a fully operational copy for free without using local drive space:

1. Create a fresh, blank repository on **GitHub**.
2. Click the green **`<> Code`** button, navigate to the **Codespaces** tab, and click **Create codespace on main**.
3. Once the terminal workspace initializes at the bottom of the screen, paste the following deployment command and press **Enter**:

```bash
curl -sL [https://raw.githubusercontent.com/jwhitesecret-hub/Trident-OS/main/setup_trident.sh](https://raw.githubusercontent.com/jwhitesecret-hub/Trident-OS/main/setup_trident.sh) | bash
