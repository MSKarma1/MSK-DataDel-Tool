# MSK Data Deletion (DataDel)

**DataDel** is a cybersecurity and privacy tool designed to streamline the exercise of the "Right to be Forgotten" (RGPD - Article 17). It provides a Command Line Interface (CLI) to identify deletion endpoints and automate the login/deletion process using Selenium.

> **Disclaimer:** This tool is for educational and privacy compliance purposes. Use responsibly.

## Features

*   **Service Reconnaissance:** Quickly identifies deletion URLs for 20+ major services (Google, Facebook, Amazon...).
*   **Link Validation:** Automatically checks if deletion endpoints are active via HTTP requests.
*   **Browser Automation:** Uses **Selenium** to open secure browser sessions and pre-fill login credentials.
*   **Secure Logging:** Hashes user IDs (SHA-256 + Salt) to maintain audit logs without compromising privacy.
*   **Interactive CLI:** Stylish Batch interface for easy usage on Windows.

## Installation

1.  **Clone the repository:**
    ```bash
    git clone https://github.com/TonPseudo/MSK-DataDel.git
    cd MSK-DataDel
    ```

2.  **Install dependencies:**
    Run the automatic installer:
    ```cmd
    requirements.bat
    ```
    *Or manually:* `pip install -r requirements.txt`

## Usage

Simply double-click on **`datadel.bat`** to launch the interactive menu.

**Manual usage via Python:**
```bash
python datadel.py Reddit --login "MyUser" --password "MyPass"
Requirements
Python 3.10+

Google Chrome (for Selenium automation)

Windows (for the .bat interface)

Security
No Credential Storage: Passwords passed to the script are injected directly into the browser and are never saved to disk.

Anonymized Logs: All user actions are logged using salted hashes.

Author
MSKarma - Cybersecurity Student
