## WEB ATTACK LAB

# Vulnerability Support Configuration (PHP Settings)

- To intentionally make the DVWA environment vulnerable and suitable for exploitation practice, specific PHP configurations were modified:
```sh
display_errors = On
```

- Displays error messages directly in the browser, which can leak sensitive details like file paths, code snippets, and system messages useful for attackers.

```sh
display_startup_errors = On
```

- Enables displaying of PHP startup sequence errors, offering further environment details during application boot that could aid exploitation.

```sh
allow_url_include = On
```

Allows the inclusion of remote files via functions like include() and require(), making Remote File Inclusion (RFI) vulnerabilities possible.