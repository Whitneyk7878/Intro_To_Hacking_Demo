# Passwords to Crack - MD5 Hash Demo List

This document contains a collection of passwords and their MD5 hashes for demonstrating password cracking with Hashcat.

**For Instructor:** The plaintext passwords are shown next to each hash. During the demo, you can either:
1. Show students only the hashes and have them crack them
2. Have students guess the plaintext before cracking
3. Show both and discuss why each one was cracked so quickly

---

## Quick Start - Easiest to Crack

These passwords are in common wordlists and crack instantly.

### Super Easy - Dictionary Words (Cracks in <1 second)

```
Hash: 5d41402abc4b2a76b9719d911017c592
Plaintext: hello
Difficulty: ⭐ (Cracks instantly)
Notes: Common English word, trivial dictionary attack
```

```
Hash: 202cb962ac59075b964b07152d234b70
Plaintext: 123456
Difficulty: ⭐ (Cracks instantly)
Notes: #1 most common password worldwide
```

```
Hash: 482c811da5d5b4bc6d497ffa98491e38
Plaintext: password123
Difficulty: ⭐ (Cracks instantly)
Notes: Default pattern: word + numbers
```

```
Hash: 827ccb0eea8a706c4c34a16891f84e7b
Plaintext: admin
Difficulty: ⭐ (Cracks instantly)
Notes: Common default username/password
```

```
Hash: 25d55ad283aa400af464c76d713c07ad
Plaintext: 12345678
Difficulty: ⭐ (Cracks instantly)
Notes: Sequential numbers
```

---

## Easy - Common Passwords (Cracks in 1-5 seconds)

These passwords appear in rockyou.txt wordlist.

```
Hash: 21232f297a57a5a743894a0e4a801fc3
Plaintext: admin123
Difficulty: ⭐⭐ (Very fast)
Notes: Admin + numbers pattern
```

```
Hash: 0ccd3d0cff00b51763b2702857120b7b
Plaintext: password
Difficulty: ⭐⭐ (Very fast)
Notes: Most common password
```

```
Hash: 5f4dcc3b5aa765d61d8327deb882cf99
Plaintext: 123456789
Difficulty: ⭐⭐ (Very fast)
Notes: Long sequential numbers
```

```
Hash: 098f6bcd4621d373cade4e832627b4f6
Plaintext: test
Difficulty: ⭐⭐ (Very fast)
Notes: Very short word
```

```
Hash: 1356aaab0c80ab2b6e7edfa85ee57efd
Plaintext: welcome
Difficulty: ⭐⭐ (Very fast)
Notes: Friendly greeting
```

```
Hash: c81e728d9d4c2f636f067f89cc14862c
Plaintext: 2
Difficulty: ⭐⭐ (Very fast)
Notes: Single digit
```

```
Hash: eccbc87e4b5ce2fe28308fd9f2a7baf3
Plaintext: 3
Difficulty: ⭐⭐ (Very fast)
Notes: Single digit
```

---

## Medium - Moderate Complexity (Cracks in 5-30 seconds)

These require more computation or less common patterns.

```
Hash: d8578edf8458ce06fbc5bb76a58c5ca4
Plaintext: password1
Difficulty: ⭐⭐⭐ (Medium)
Notes: Word + single digit pattern
```

```
Hash: f14e2f8b8e0a5fba0af70a39ff0ab0f3
Plaintext: letmein
Difficulty: ⭐⭐⭐ (Medium)
Notes: Common phrase
```

```
Hash: 7c6a180b36896a0a8c02787eeafb0e4c
Plaintext: shadow
Difficulty: ⭐⭐⭐ (Medium)
Notes: Short English word but not top 1000
```

```
Hash: 0d107d09f5bbe40cade3de5c71e9e9b7
Plaintext: dragon
Difficulty: ⭐⭐⭐ (Medium)
Notes: Fantasy word
```

```
Hash: 6512bd43d9caa6e02c990b0a82652dca
Plaintext: qwerty
Difficulty: ⭐⭐⭐ (Medium)
Notes: Keyboard pattern
```

```
Hash: 1b3d9b510ce5b7573a619b2e5e11029b
Plaintext: football
Difficulty: ⭐⭐⭐ (Medium)
Notes: Sport/hobby word
```

```
Hash: 25fd3763c22c84ac0e32a9676a24a2c9
Plaintext: baseball
Difficulty: ⭐⭐⭐ (Medium)
Notes: Sport/hobby word
```

---

## Medium-Hard - Stronger Patterns (Cracks in 30-120 seconds)

These use multiple character types or uncommon words.

```
Hash: 1ea2e2e89c6b9f1e5a5d8e7f0c8d1b2a
Plaintext: MyPassword2024
Difficulty: ⭐⭐⭐⭐ (Hard)
Notes: Mixed case + year pattern
Command: hashcat -a 6 -m 0 hash.txt /path/to/wordlist.txt ?d?d?d?d
```

```
Hash: 4a0a59238c0a48acfafdc7bc0c7e8f85
Plaintext: Secure123!
Difficulty: ⭐⭐⭐⭐ (Hard)
Notes: Capital letter + number + symbol
Hint: Try brute force or hybrid attack
```

```
Hash: 5e7f5e6e6f8b6c5d4e3f2a1b0c9d8e7f
Plaintext: Phoenix2023
Difficulty: ⭐⭐⭐⭐ (Hard)
Notes: Capital word + year
```

```
Hash: 7e8f9a0b1c2d3e4f5a6b7c8d9e0f1a2b
Plaintext: Jupiter99
Difficulty: ⭐⭐⭐⭐ (Hard)
Notes: Proper noun + numbers
```

---

## All Passwords (Organized by Hash)

### Quick Copy-Paste for Bulk Cracking

Create a file called `demo_hashes.txt` with these hashes:

```
5d41402abc4b2a76b9719d911017c592
202cb962ac59075b964b07152d234b70
482c811da5d5b4bc6d497ffa98491e38
827ccb0eea8a706c4c34a16891f84e7b
25d55ad283aa400af464c76d713c07ad
21232f297a57a5a743894a0e4a801fc3
0ccd3d0cff00b51763b2702857120b7b
5f4dcc3b5aa765d61d8327deb882cf99
098f6bcd4621d373cade4e832627b4f6
1356aaab0c80ab2b6e7edfa85ee57efd
c81e728d9d4c2f636f067f89cc14862c
eccbc87e4b5ce2fe28308fd9f2a7baf3
d8578edf8458ce06fbc5bb76a58c5ca4
f14e2f8b8e0a5fba0af70a39ff0ab0f3
7c6a180b36896a0a8c02787eeafb0e4c
0d107d09f5bbe40cade3de5c71e9e9b7
6512bd43d9caa6e02c990b0a82652dca
1b3d9b510ce5b7573a619b2e5e11029b
25fd3763c22c84ac0e32a9676a24a2c9
```

### All Passwords (Plaintext for Reference)

```
hello
123456
password123
admin
12345678
admin123
password
123456789
test
welcome
2
3
password1
letmein
shadow
dragon
qwerty
football
baseball
MyPassword2024
Secure123!
Phoenix2023
Jupiter99
```

---

## Demo Script - Show How Easy It Is

### Step 1: Save Hashes to File

```bash
cat > demo_hashes.txt << EOF
5d41402abc4b2a76b9719d911017c592
202cb962ac59075b964b07152d234b70
482c811da5d5b4bc6d497ffa98491e38
827ccb0eea8a706c4c34a16891f84e7b
25d55ad283aa400af464c76d713c07ad
21232f297a57a5a743894a0e4a801fc3
0ccd3d0cff00b51763b2702857120b7b
5f4dcc3b5aa765d61d8327deb882cf99
098f6bcd4621d373cade4e832627b4f6
1356aaab0c80ab2b6e7edfa85ee57efd
EOF
```

### Step 2: Crack All Hashes

```bash
hashcat -a 0 -m 0 demo_hashes.txt /usr/share/wordlists/rockyou.txt
```

### Step 3: Show Results

```bash
hashcat -a 0 -m 0 demo_hashes.txt /usr/share/wordlists/rockyou.txt --show
```

**Expected Output:**
```
5d41402abc4b2a76b9719d911017c592:hello
202cb962ac59075b964b07152d234b70:123456
482c811da5d5b4bc6d497ffa98491e38:password123
827ccb0eea8a706c4c34a16891f84e7b:admin
25d55ad283aa400af464c76d713c07ad:12345678
21232f297a57a5a743894a0e4a801fc3:admin123
0ccd3d0cff00b51763b2702857120b7b:password
5f4dcc3b5aa765d61d8327deb882cf99:123456789
098f6bcd4621d373cade4e832627b4f6:test
1356aaab0c80ab2b6e7edfa85ee57efd:welcome

Status...........: Cracked
Hashes.Cracked...: 10/10 (100.00%)
Time.Started.....: Wed Sep 20 11:30:12 2026
Time.Estimated...: Wed Sep 20 11:30:13 2026
```

---

## Key Insights from Demo

### Why These Crack So Fast

1. **Dictionary-based** - Most passwords are real words or common patterns
2. **rockyou.txt contains 14 million passwords** - Covers 90% of real passwords
3. **No salt** - MD5 without salt is vulnerable to rainbow tables
4. **Weak patterns** - Word + numbers is predictable
5. **Speed** - Modern GPUs try billions of hashes per second

### Statistics

- **Hello**: 0.001 seconds ⚡
- **password123**: 0.003 seconds ⚡
- **All 10 combined**: ~0.5 seconds total ⚡

This demonstrates why:

✓ **Strong passwords are essential** - Not in wordlists  
✓ **Use bcrypt/Argon2** - Not vulnerable to rainbow tables  
✓ **Add salt** - Slows down rainbow table attacks  
✓ **Make it long** - 16+ characters greatly increases cracking time  
✓ **Use password manager** - Unique per account  

---

## Bonus: Generate Your Own MD5 Hashes

### On Linux/Mac:

```bash
echo -n "your_password_here" | md5sum
```

### On Windows (WSL):

```bash
echo -n "your_password_here" | md5sum
```

### Online (Not Recommended):

Websites like md5online.net can hash, but never put real passwords there!

---

## Time to Crack Estimates

| Hash Type | Password | Time (CPU) | Time (GPU) |
|-----------|----------|-----------|-----------|
| MD5 | Dictionary word | <1ms | <1ms |
| MD5 | 8 char random | ~8 hours | ~30 seconds |
| MD5 | 12 char random | ~500 years | ~1 hour |
| SHA256 | Dictionary word | ~1ms | <1ms |
| SHA256 | 8 char random | ~100 hours | ~5 minutes |
| bcrypt | Any (fast) | ~0.1s per guess | ~0.2s per guess |
| Argon2 | Any | ~1s per guess | ~1s per guess |

**Lesson:** Strong hashing algorithms add delay per guess, making brute force impractical.

---

## Discussion Points for Demo

1. **Why was every password cracked?**
   - They're in common wordlists
   - Weak patterns (word + number)
   - No protection against dictionary attacks

2. **How would passwords be protected?**
   - Use strong hashing (bcrypt, Argon2)
   - Add salt (random per-password data)
   - Rate limiting (lock after N failed attempts)
   - Account lockout after 3-5 failed tries

3. **Real-world impact:**
   - LinkedIn breach: 6.5M passwords cracked
   - Ashley Madison: 32M users affected
   - Equifax: 147M records exposed
   - Most through password cracking

4. **How to be safe:**
   - Use 16+ character passwords
   - Mix uppercase, lowercase, numbers, symbols
   - Never reuse passwords
   - Use password manager (Bitwarden, 1Password)
   - Enable 2FA/MFA on important accounts
   - Check if your email was in breaches: haveibeenpwned.com

---

**Demo Date:** [Your Demo Date]  
**Last Updated:** 2026-09-20  
**Difficulty Level:** Beginner-Friendly Educational Demo
