# Password Cracking with Hashcat - Quick Demo

**⚠️ Educational Use Only:** Only crack hashes of systems you own or have explicit permission to test.

## Why This Exists? What are Hashes?

Websites never store your actual password — they store a **hash** of it, a scrambled, one-way version that can't be reversed back into the original text. When you log in, the site hashes what you typed and checks if it matches the stored hash. If a database ever leaks, attackers only get these hashes, not the real passwords.

So how do you "crack" something that can't be reversed? You don't — you guess. You hash a *guess* and see if it matches. Guess right, and you've found the password. That's all Hashcat does, just really, really fast (billions of guesses per second on a GPU). The two guessing strategies below are how almost every real crack happens.

Make a hash to practice on:

```bash
echo -n "password123" | md5sum > hashes.txt
```

---

## Using Rockyou (Dictionary Attack)

Rockyou.txt is a leaked list of ~14 million real passwords. Hashcat hashes each entry and checks it against your hash file — if someone used a common password, this finds it instantly.

```bash
hashcat -a 0 -m 0 hashes.txt /usr/share/wordlists/rockyou.txt
```

- `-a 0` = dictionary attack
- `-m 0` = hash type is MD5

See the cracked result anytime with:

```bash
hashcat -a 0 -m 0 hashes.txt /usr/share/wordlists/rockyou.txt --show
```

---

## Brute Force

No wordlist match? Try every possible character combination instead.

```bash
hashcat -a 3 -m 0 hashes.txt ?l?l?l?l?l?l
```

- `-a 3` = brute force
- Each `?l` is one lowercase letter slot — 6 of them = a 6-character password

Other character types: `?u` uppercase, `?d` digits, `?s` symbols, `?a` any of the above.

```bash
hashcat -a 3 -m 0 hashes.txt ?a?a?a?a?a?a?a?a   # 8 chars, any character
```

Brute force gets exponentially slower as length/complexity grows — that's why longer, more complex passwords are safer.

---

**Last Updated:** 2026-09-21
