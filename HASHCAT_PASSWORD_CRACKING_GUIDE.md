# Password Cracking with Hashcat - Demo Guide

## Overview

Password cracking is the process of recovering plaintext passwords from their hash representations. This guide demonstrates how to use Hashcat, one of the fastest password cracking tools, to crack password hashes.

**⚠️ Educational Use Only:** This guide is for learning purposes in controlled environments. Unauthorized access to computer systems is illegal. Only crack hashes of systems you own or have explicit permission to test.

---

## What is Password Hashing?

A hash is a one-way cryptographic function that converts plaintext into a fixed-length string. It's impossible to reverse, but you can:

1. **Try dictionary words** - Hash common passwords and compare
2. **Brute force** - Try all possible character combinations
3. **Use rainbow tables** - Pre-computed hash databases
4. **GPU acceleration** - Use graphics cards for massive speed

### Common Hash Types

| Algorithm | Example | Length | Security |
|-----------|---------|--------|----------|
| MD5 | `5d41402abc4b2a76b9719d911017c592` | 32 char | ❌ Weak (fast cracking) |
| SHA1 | `aaf4c61ddcc5e8a2dabede0f3b482cd9aea9434d` | 40 char | ❌ Weak |
| SHA256 | `2c26b46911185131006145dd0c1ce5df` | 64 char | ✓ Good |
| bcrypt | `$2b$12$R9h/cIPz0gi.URNNGU3ZKOYzmM...` | Variable | ✓✓ Excellent |
| Argon2 | Variable | Variable | ✓✓✓ Best |

---

## Part 1: Installing Hashcat on WSL

### Step 1: Install WSL2 (Windows Subsystem for Linux)

If you don't have WSL2 installed, run in PowerShell as Administrator:

```powershell
wsl --install
```

This installs WSL2 and Ubuntu by default.

### Step 2: Update WSL Linux System

Open your WSL terminal and update package lists:

```bash
sudo apt update
sudo apt upgrade -y
```

### Step 3: Install Hashcat

#### Standard Installation

```bash
sudo apt install -y hashcat
```

#### Verify Installation

```bash
hashcat --version
```

You should see output like: `hashcat (v6.2.6)`

### Step 4: Check GPU Support (Optional but Recommended)

For faster cracking, enable GPU acceleration:

#### NVIDIA GPU Users

```bash
sudo apt install -y nvidia-cuda-toolkit
hashcat -I
```

#### AMD GPU Users

```bash
sudo apt install -y rocm-dkms
hashcat -I
```

#### Check Available Devices

```bash
hashcat -I
```

Output will show your CPU and GPU devices:
```
Device ID #1: Intel Core i7-10700K @ 3.80GHz
Device ID #2: NVIDIA GeForce RTX 3080 (Turing)
```

### Step 5: Install Wordlists

Get common password lists for dictionary attacks:

```bash
sudo apt install -y seclists wordlists rockyou
```

Or manually download:

```bash
# Download rockyou wordlist (most popular)
wget https://github.com/brannondorsey/naive-bayes-classifier-language-models/raw/master/data/corpus/rockyou.txt.tar.gz
tar -xzf rockyou.txt.tar.gz
```

---

## Part 2: Understanding Hash Types

### MD5 Hashing

Generate MD5 hash of a password:

```bash
echo -n "password123" | md5sum
```

Output:
```
482c811da5d5b4bc6d497ffa98491e38  -
```

### SHA256 Hashing

```bash
echo -n "password123" | sha256sum
```

Output:
```
ef92b778bafe771e89245d171bafecca6c05e09a0d9744a066ff032f69e475e2  -
```

### Create Hash Files

For cracking, save hashes to a file:

```bash
# Single hash
echo "5d41402abc4b2a76b9719d911017c592" > hashes.txt

# Multiple hashes
cat > hashes.txt << EOF
5d41402abc4b2a76b9719d911017c592
482c811da5d5b4bc6d497ffa98491e38
827ccb0eea8a706c4c34a16891f84e7b
EOF
```

---

## Part 3: Basic Hashcat Commands

### Syntax

```bash
hashcat [options] -a [attack-mode] -m [hash-type] [hashfile] [wordlist]
```

### Common Hash Type Codes (-m)

```
0       = MD5
1       = MD4
100     = SHA1
1400    = SHA256
3200    = bcrypt
1800    = SHA512
```

### Attack Modes (-a)

```
0       = Straight (dictionary attack)
1       = Combination (merge two wordlists)
3       = Brute-force (try all characters)
6       = Hybrid wordlist + mask
7       = Hybrid mask + wordlist
```

---

## Part 4: Basic Dictionary Attack

The fastest and most practical method.

### Step 1: Create Hash File

```bash
echo "5d41402abc4b2a76b9719d911017c592" > hashes.txt
```

This is the MD5 hash of "hello"

### Step 2: Crack with Dictionary

```bash
hashcat -a 0 -m 0 hashes.txt /usr/share/wordlists/rockyou.txt
```

**Output:**
```
5d41402abc4b2a76b9719d911017c592:hello

Session..........: hashcat
Status...........: Cracked
Hash.Mode........: 0 (MD5)
Hash.Target......: 5d41402abc4b2a76b9719d911017c592
Time.Started.....: Wed Sep 20 10:30:12 2026
Time.Estimated...: Wed Sep 20 10:30:13 2026
Crack.Time.......: 0.001 sec
```

### Step 3: View Results

```bash
hashcat -a 0 -m 0 hashes.txt /usr/share/wordlists/rockyou.txt --show
```

---

## Part 5: SHA256 Password Cracking

### Create SHA256 Hashes

```bash
echo -n "password123" | sha256sum
# Output: ef92b778bafe771e89245d171bafecca6c05e09a0d9744a066ff032f69e475e2
```

### Crack SHA256

```bash
hashcat -a 0 -m 1400 hashes.txt /usr/share/wordlists/rockyou.txt
```

**-m 1400** = SHA256

---

## Part 6: Brute Force Attack

When you don't know the password, try all character combinations.

### Basic Brute Force

```bash
hashcat -a 3 -m 0 hashes.txt ?a?a?a?a
```

**Attack mode 3** = Brute force  
**?a** = Any character (a-z, A-Z, 0-9, symbols)

### Character Sets

```
?l = lowercase a-z
?u = uppercase A-Z
?d = digits 0-9
?s = special symbols
?a = all (?l?u?d?s)
```

### Examples

```bash
# Crack 4-character passwords (lowercase only)
hashcat -a 3 -m 0 hashes.txt ?l?l?l?l

# Crack 6-character passwords (letters + numbers)
hashcat -a 3 -m 0 hashes.txt ?l?l?l?d?d?d

# Crack 8-character passwords (all characters)
hashcat -a 3 -m 0 hashes.txt ?a?a?a?a?a?a?a?a
```

### Brute Force with Pattern

```bash
# Passwords starting with capital letter, 7 lowercase, 2 numbers
hashcat -a 3 -m 0 hashes.txt ?u?l?l?l?l?l?l?d?d
```

---

## Part 7: Rule-Based Attacks

Modify wordlist entries using rules (e.g., capitalize first letter, add numbers).

### Use Built-in Rules

```bash
hashcat -a 0 -m 0 hashes.txt /usr/share/wordlists/rockyou.txt -r /usr/share/hashcat/rules/best64.rule
```

### Common Rule Files

```
best64.rule         = Best 64 rules
d3ad0ne.rule        = Leetspeak replacements
dive.rule           = Various modifications
rockyou-30000.rule  = Top 30k password patterns
```

### Create Custom Rules

```bash
# Create a rule file
cat > custom.rule << EOF
# Capitalize first letter
c

# Append numbers
$1
$2
$3

# Leetspeak: a->@
s a @
EOF

hashcat -a 0 -m 0 hashes.txt /path/to/wordlist.txt -r custom.rule
```

---

## Part 8: Hybrid Attack

Combine wordlist with brute force for specific pattern.

```bash
# Try wordlist + 2 digits at the end
hashcat -a 6 -m 0 hashes.txt /usr/share/wordlists/rockyou.txt ?d?d

# Try wordlist + 1 uppercase letter at the end
hashcat -a 6 -m 0 hashes.txt /usr/share/wordlists/rockyou.txt ?u
```

---

## Part 9: Advanced Options

### Show Progress

```bash
hashcat -a 0 -m 0 hashes.txt wordlist.txt --status
```

### Specify GPU Device

```bash
# Use GPU 0
hashcat -a 0 -m 0 hashes.txt wordlist.txt -d 1

# Use GPU 0 and 1
hashcat -a 0 -m 0 hashes.txt wordlist.txt -d 1,2
```

### Set Performance Level

```bash
# Slow but accurate (-O = optimize for GPU)
hashcat -a 0 -m 0 hashes.txt wordlist.txt -O

# Workload: 1=low, 2=default, 3=high, 4=nightmare
hashcat -a 0 -m 0 hashes.txt wordlist.txt -w 3
```

### Save Results to File

```bash
hashcat -a 0 -m 0 hashes.txt wordlist.txt --outfile results.txt
```

### Mask Attack (Common Patterns)

```bash
# Passwords like: Password123
hashcat -a 3 -m 0 hashes.txt ?u?l?l?l?l?l?l?l?d?d?d

# Passwords like: 2023-password
hashcat -a 3 -m 0 hashes.txt ?d?d?d?d-?l?l?l?l?l?l?l?l
```

---

## Part 10: Practical Demo Walkthrough

### Demo Scenario: Crack Common Passwords

```bash
# Step 1: Create a file with password hashes
cat > demo_hashes.txt << EOF
5d41402abc4b2a76b9719d911017c592
482c811da5d5b4bc6d497ffa98491e38
827ccb0eea8a706c4c34a16891f84e7b
202cb962ac59075b964b07152d234b70
EOF

# These are MD5 hashes of: hello, password123, admin, 123456

# Step 2: Crack with dictionary attack (fastest)
hashcat -a 0 -m 0 demo_hashes.txt /usr/share/wordlists/rockyou.txt

# Step 3: View cracked passwords
hashcat -a 0 -m 0 demo_hashes.txt /usr/share/wordlists/rockyou.txt --show

# Output:
# 5d41402abc4b2a76b9719d911017c592:hello
# 482c811da5d5b4bc6d497ffa98491e38:password123
# 827ccb0eea8a706c4c34a16891f84e7b:admin
# 202cb962ac59075b964b07152d234b70:123456
```

### Demo Scenario: Brute Force Unknown Password

```bash
# If dictionary doesn't work, try brute force
# This will try all 4-character lowercase combinations
hashcat -a 3 -m 0 demo_hashes.txt ?l?l?l?l

# Time estimate for 4 chars lowercase:
# 26^4 = 456,976 combinations
# On modern GPU: ~1 second
```

---

## Part 11: Performance Tips

### Speed Up Cracking

1. **Use GPU** - 100-1000x faster than CPU
2. **Use SSD** - Faster wordlist loading
3. **Use -O flag** - Optimize for GPU memory
4. **Reduce hash type strength** - MD5 < SHA256
5. **Narrow password length** - Reduce search space
6. **Use good wordlists** - rockyou.txt, SecLists

### Benchmark Your System

```bash
# Test MD5 cracking speed
hashcat -b -m 0 -w 3 -O

# Test SHA256 cracking speed
hashcat -b -m 1400 -w 3 -O

# Output shows hashes/second your system can achieve
```

### Expected Speeds (Approximate)

| Hash Type | CPU | GPU (RTX 3080) |
|-----------|-----|----------------|
| MD5 | 100K/s | 50G/s |
| SHA1 | 50K/s | 30G/s |
| SHA256 | 30K/s | 15G/s |
| bcrypt | 100/s | 500/s |

---

## Part 12: Why Password Cracking Works

### Weak Passwords

- **Dictionary words** - Only ~171K unique words in English
- **Common patterns** - "Password123", "Company2024"
- **Short length** - 8 characters or less is crackable
- **No complexity** - Only lowercase letters
- **Predictable** - Birthdays, pet names

### Real-World Stats

- 59% of users use the same password everywhere
- Most common password: "123456"
- 81% of data breaches involve weak passwords
- Dictionary attacks crack 90% of leaked passwords

---

## Part 13: Security - How to Protect Passwords

### Use Strong Hashing

```bash
# ❌ Weak: MD5
echo -n "password123" | md5sum

# ✓ Good: SHA256
echo -n "password123" | sha256sum

# ✓✓ Better: bcrypt
# Used by: Linux /etc/shadow, modern frameworks
htpasswd -c passwords.txt username
# Prompts for password, stores as bcrypt

# ✓✓✓ Best: Argon2
# Used by: OWASP recommendation for new applications
```

### Password Requirements

- ✓ Minimum 12 characters (16+ is better)
- ✓ Mix of uppercase, lowercase, numbers, symbols
- ✓ No dictionary words
- ✓ No personal information
- ✓ Unique per account
- ✓ Use a password manager (1Password, Bitwarden, KeePass)

### Salting

Modern password systems use **salt** (random data added to password before hashing):

```
Plaintext: "password123"
Salt: "xk9mN2p4"
Combined: "password123xk9mN2p4"
Hash: sha256("password123xk9mN2p4") = "a1b2c3d4..."
```

This prevents rainbow table attacks because same password has different hash.

---

## Troubleshooting

### Hashcat Not Found

```bash
sudo apt install -y hashcat
```

### GPU Not Detected

```bash
hashcat -I
# Check if GPU shows in list
# If not, install drivers:
# NVIDIA: sudo apt install -y nvidia-driver-XXX
# AMD: sudo apt install -y rocm-dkms
```

### Slow Performance

- Enable GPU: Install CUDA/ROCm drivers
- Use -w 3 or -w 4 for higher workload
- Use -O to optimize for GPU
- Ensure wordlist is on SSD

### "Exhausted" - No Match Found

- Wordlist doesn't contain the password
- Wrong hash type specified
- Try brute force attack instead
- Try rule-based attack to modify wordlist

---

## Demo Commands Quick Reference

```bash
# Create MD5 hash
echo -n "password123" | md5sum > hashes.txt

# Dictionary attack (fastest)
hashcat -a 0 -m 0 hashes.txt /usr/share/wordlists/rockyou.txt

# Brute force 4 chars lowercase
hashcat -a 3 -m 0 hashes.txt ?l?l?l?l

# Hybrid: wordlist + 2 digits
hashcat -a 6 -m 0 hashes.txt /usr/share/wordlists/rockyou.txt ?d?d

# Rules-based (modify wordlist)
hashcat -a 0 -m 0 hashes.txt /usr/share/wordlists/rockyou.txt -r best64.rule

# View results
hashcat -a 0 -m 0 hashes.txt /usr/share/wordlists/rockyou.txt --show

# Benchmark GPU
hashcat -b -m 0 -w 3
```

---

## Key Takeaways

1. **Weak passwords are crackable in seconds** - Use strong, unique passwords
2. **Hash algorithms matter** - bcrypt/Argon2 > SHA256 > MD5
3. **Salting is essential** - Prevents rainbow table attacks
4. **Modern systems are fast** - GPUs can try billions of hashes/second
5. **Defense in depth** - Rate limiting, account lockout, 2FA reduce cracking success

---

## References

- [Hashcat Documentation](https://hashcat.net/wiki/)
- [OWASP Password Hashing](https://cheatsheetseries.owasp.org/cheatsheets/Password_Storage_Cheat_Sheet.html)
- [SecLists Wordlists](https://github.com/danielmiessler/SecLists)
- [Have I Been Pwned](https://haveibeenpwned.com/)

---

**Last Updated:** 2026-09-20  
**Intended For:** Educational security training only  
**Environment:** Controlled lab environment
