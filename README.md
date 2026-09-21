# Intro to Hacking - Cyber Security Demo

A hands-on collection of educational security demos for learning common attack vectors and defensive practices. All materials are designed for authorized security training in controlled environments.

⚠️ **For Educational Use Only** - Unauthorized access to computer systems is illegal.

---

## Quick Start

### 1. SQL Injection Demo
**File:** `bank_login.html`

Open directly in your browser to see a vulnerable login form. Follow the SQL injection guide to learn how to bypass authentication.

- **Guide:** [SQL_INJECTION_GUIDE.md](SQL_INJECTION_GUIDE.md)
- **Try these payloads:**
  - Username: `' OR '1'='1` | Password: anything
  - Username: `admin'--` | Password: anything
  - See the SQL query execute in real-time at the bottom of the page

---

### 2. Password Cracking with Hashcat
**Files:** `HASHCAT_PASSWORD_CRACKING_GUIDE.md` + `PASSWORDS_TO_CRACK.md`

Install Hashcat on Windows WSL and crack MD5 password hashes in seconds.

**Installation (WSL):**
```bash
sudo apt update && sudo apt install -y hashcat
```

**Crack passwords:**
```bash
hashcat -a 0 -m 0 hashes.txt /usr/share/wordlists/rockyou.txt
```

See how easily weak passwords are compromised and why strong password practices matter.

---

### 3. Metasploit Reverse Shell
**Files:** `METASPLOIT_TCP_REVERSE_SHELL.md` + `setup_reverse_shell.sh`

Create and control a reverse shell connection in your cyber range.

**Quick setup on Kali Linux:**
```bash
bash setup_reverse_shell.sh
```

The script will:
- Ask for your listener port and IP
- Generate the payload with msfvenom
- Show you how to host it and catch the connection

---

## File Guide

| File | Purpose |
|------|---------|
| `bank_login.html` | Vulnerable login page for SQL injection practice |
| `SQL_INJECTION_GUIDE.md` | Complete guide on SQL injection techniques |
| `PASSWORDS_TO_CRACK.md` | 20+ MD5 hashes to crack with difficulty ratings |
| `HASHCAT_PASSWORD_CRACKING_GUIDE.md` | Installation and usage guide for Hashcat |
| `METASPLOIT_TCP_REVERSE_SHELL.md` | Step-by-step metasploit listener and payload guide |
| `setup_reverse_shell.sh` | Automated setup script for reverse shell demo |

---

## Requirements

- **SQL Injection Demo:** Any web browser
- **Password Cracking:** Windows WSL or Linux, Hashcat installed
- **Metasploit Demo:** Kali Linux VM or WSL with Metasploit Framework installed

---

## Topics Covered

- ✓ SQL Injection (authentication bypass, data extraction)
- ✓ Password hashing and cracking techniques
- ✓ Reverse shells and post-exploitation
- ✓ Common attack patterns and why they work
- ✓ Security best practices and defensive measures

---

## Learning Path

1. **Start with SQL Injection** → Open `bank_login.html`, try the payloads, read the guide
2. **Learn Password Cracking** → Read Hashcat guide, crack the provided password list
3. **Explore Metasploit** → Set up Kali Linux VM, follow the reverse shell guide

Each demo takes 15-30 minutes and builds understanding of real-world attack techniques.

---

**Created for:** University cybersecurity training and authorized security testing  
**Last Updated:** 2026-09-20  
**License:** Educational use only
