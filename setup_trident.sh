#!/bin/bash
clear
echo "=================================================="
echo "          BUILDING TRIDENT OS WORKSPACE           "
echo "=================================================="

# Create the required system directory tree
mkdir -p custom-os/usr/local/bin
mkdir -p custom-os/etc/xdg/openbox
mkdir -p trident-search/templates

# 1. CREATE GATEKEEPER
cat << 'INNER' > custom-os/usr/local/bin/system-gatekeeper
#!/bin/bash
CONFIG_FILE="/etc/birthday.conf"
if [ ! -f "$CONFIG_FILE" ] || [ ! -s "$CONFIG_FILE" ]; then
    echo "First time boot detected. Launching setup wizard..."
    /usr/local/bin/setup-wizard
else
    source "$CONFIG_FILE"
    /usr/local/bin/cake-generator
fi
INNER

# 2. CREATE MASTER SETUP WIZARD (Theme + Games Checklist)
cat << 'INNER' > custom-os/usr/local/bin/setup-wizard
#!/bin/bash
CONFIG_FILE="/etc/birthday.conf"
mkdir -p "$(dirname "$CONFIG_FILE")"
clear
echo "=================================================="
echo "          TRIDENT OS INITIAL RUN SETUP            "
echo "=================================================="
read -p "First Name: " fname
read -p "Last Name: " lname
read -p "Birthday Month (MM): " bmonth
read -p "Birthday Day (DD): " bday

echo "FIRST_NAME=\"$fname\"" > $CONFIG_FILE
echo "LAST_NAME=\"$lname\"" >> $CONFIG_FILE
echo "BIRTHDAY_MONTH=\"$bmonth\"" >> $CONFIG_FILE
echo "BIRTHDAY_DAY=\"$bday\"" >> $CONFIG_FILE

echo -e "\n--- CHOOSE CONFIGURATION MODE ---"
echo "1) Dark Mode | 2) Light Mode"
read -p "Selection [1-2]: " ui_mode
[ "$ui_mode" == "2" ] && echo "UI_MODE=\"light\"" >> $CONFIG_FILE || echo "UI_MODE=\"dark\"" >> $CONFIG_FILE

echo -e "\n--- CHOOSE ACCENT COLORS ---"
echo "1) Rose | 2) Beach | 3) Blue | 4) Cocktail"
read -p "Selection [1-4]: " color_choice
case $color_choice in
    1) echo "SYSTEM_COLOR=\"rose\"" >> $CONFIG_FILE ;;
    2) echo "SYSTEM_COLOR=\"beach\"" >> $CONFIG_FILE ;;
    3) echo "SYSTEM_COLOR=\"blue\"" >> $CONFIG_FILE ;;
    4) echo "SYSTEM_COLOR=\"cocktail\"" >> $CONFIG_FILE ;;
esac

echo -e "\n--- BUILT-IN CLASSIC GAMES PACK ---"
read -p "Include Minesweeper? [y/n]: " g_mine
read -p "Include Solitaire? [y/n]: " g_sol
read -p "Include Snake? [y/n]: " g_snake
read -p "Include Tetris? [y/n]: " g_tet
read -p "Include Chess? [y/n]: " g_chess

echo "GAME_MINESWEEPER=\"$g_mine\"" >> $CONFIG_FILE
echo "GAME_SOLITAIRE=\"$g_sol\"" >> $CONFIG_FILE
echo "GAME_SNAKE=\"$g_snake\"" >> $CONFIG_FILE
echo "GAME_TETRIS=\"$g_tet\"" >> $CONFIG_FILE
echo "GAME_CHESS=\"$g_chess\"" >> $CONFIG_FILE

echo -e "\nSetup saved to /etc/birthday.conf!"
/usr/local/bin/cake-generator
INNER

# 3. CREATE CAKE GENERATOR
cat << 'INNER' > custom-os/usr/local/bin/cake-generator
#!/bin/bash
source /etc/birthday.conf
if [ "$UI_MODE" == "light" ]; then
    THEME_BG="\e[107m"; THEME_FG="\e[30m"
else
    THEME_BG="\e[40m"; THEME_FG="\e[37m"
fi
case "$SYSTEM_COLOR" in
    "rose")     COLOR_STR="\e[38;5;211m" ;;
    "beach")    COLOR_STR="\e[38;5;220m" ;;
    "blue")     COLOR_STR="\e[38;5;33m"  ;;
    "cocktail") COLOR_STR="\e[38;5;135m" ;;
esac
RESET="\e[0m"; FULL_NAME="$FIRST_NAME $LAST_NAME"
FLAMES=""; WICKS=""; NAME_LAYER=""
for (( i=0; i<${#FULL_NAME}; i++ )); do
    CHAR="${FULL_NAME:$i:1}"
    if [[ "$CHAR" == "i" || "$CHAR" == "I" ]]; then
        FLAMES="${FLAMES}\e[1;31m*\e[0m${COLOR_STR}"
        WICKS="${WICKS}\e[33m|\e[0m${COLOR_STR}"
    else
        FLAMES="$FLAMES "; WICKS="$WICKS "
    fi
    NAME_LAYER="$NAME_LAYER$CHAR"
done
WIDTH=$((${#FULL_NAME} + 6)); CANDLE_PAD="   "
BARS=$(printf '%*s' "$WIDTH" '' | tr ' ' '=')
SPACER=$(printf '%*s' "$WIDTH" '' | tr ' ' ' ')
clear
echo -e "${THEME_BG}${THEME_FG}${COLOR_STR}"
echo -e "      $CANDLE_PAD $FLAMES"
echo -e "      $CANDLE_PAD $WICKS"
echo -e "   ┌──$BARS──┐"
echo -e "   │  $SPACER  │"
echo -e "   │  $CANDLE_PAD ${THEME_FG}$NAME_LAYER${COLOR_STR} $CANDLE_PAD │"
echo -e "   │  $SPACER  │"
echo -e "┌──┴──$BARS──┴──┐"
echo -e "│  HAPPY BIRTHDAY, $FIRST_NAME!  │"
echo -e "└─────────────────┘${RESET}\n"
INNER

# 4. CREATE PRIVACY SEARCH ENGINE ENGINE
cat << 'INNER' > trident-search/app.py
from flask import Flask, request
import requests
from bs4 import BeautifulSoup
import urllib.parse

app = Flask(__name__)
HEADERS = {"User-Agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36"}

@app.route('/')
def home():
    return '''
    <html><body style="background:#050b14;color:white;font-family:monospace;display:flex;flex-direction:column;align-items:center;justify-content:center;height:100vh;">
    <h1 style="letter-spacing:4px;">TRIDENT</h1><div style="color:#51b5ff;margin-bottom:20px;">ISOLATED PRIVACY INDEX</div>
    <form action="/search"><input type="text" name="q" style="width:500px;padding:15px;background:#0c1524;color:white;border:2px solid #1a2a40;border-radius:8px;" autofocus></form>
    </body></html>
    '''

@app.route('/search')
def search():
    query = request.args.get('q', '')
    url = f"https://html.duckduckgo.com/html/?q={urllib.parse.quote(query)}"
    try:
        res = requests.get(url, headers=HEADERS, timeout=5)
        soup = BeautifulSoup(res.text, 'html.parser')
        results = ""
        for r in soup.find_all('div', class_='result__body'):
            link = r.find('a', class_='result__url')
            snip = r.find('a', class_='result__snippet')
            if link:
                clean_url = urllib.parse.parse_qs(urllib.parse.urlparse(link['href']).query).get('uddg', [link['href']])[0]
                results += f"<div style='margin-bottom:20px;'><a style='color:#51b5ff;text-decoration:none;font-size:1.2rem;' href='{clean_url}'>{link.get_text()}</a><p style='color:#aaa;'>{snip.get_text() if snip else ''}</p></div>"
        return f"<html><body style='background:#050b14;color:white;font-family:monospace;padding:40px;'><h2>TRIDENT RESULTS: {query}</h2><hr style='border:1px solid #1a2a40;'>{results}</body></html>"
    except Exception as e:
        return str(e)

if __name__ == '__main__':
    app.run(host='0.0.0.0', port=8080)
INNER

# Adjust permissions
chmod +x custom-os/usr/local/bin/*
pip3 install flask requests beautifulsoup4 --quiet

echo "Deployment complete! Workspace is fully constructed."
