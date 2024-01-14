Gitleaks pre-commit hook

A simple script that checks the code for secrets before each commit. Blocks a commit if detects secrets. 
To run use `curl -sSfL https://raw.githubusercontent.com/matvrus/pre-commit-auto-script/main/install.sh | bash` in your terminal.

Run `source on-off.sh; enable` to enable the pre-commit check; run `source on-off.sh; disable` - to disable.
