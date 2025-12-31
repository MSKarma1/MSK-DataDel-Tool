import json
import os
import hashlib
import argparse
import logging
import time
import requests
from difflib import get_close_matches
from urllib.parse import urlparse
from selenium import webdriver
from selenium.webdriver.common.by import By
from selenium.webdriver.common.keys import Keys
from selenium.webdriver.chrome.service import Service
from selenium.webdriver.support.ui import WebDriverWait
from selenium.webdriver.support import expected_conditions as EC
from webdriver_manager.chrome import ChromeDriverManager

logging.basicConfig(
    filename='datadel.log',
    level=logging.INFO,
    format='%(asctime)s - %(levelname)s - %(message)s'
)

class DateDel:
    def __init__(self, db_path="services.json"):
        self.db_path = db_path
        self.services_database = self._load_database()
        self._session_salt = os.urandom(16)

    def _load_database(self):
        if os.path.exists(self.db_path):
            try:
                with open(self.db_path, 'r', encoding='utf-8') as f:
                    return json.load(f)
            except json.JSONDecodeError:
                return {}
        else:
            return {}

    def chercher_service(self, service_input):
        services = list(self.services_database.keys())
        matches = get_close_matches(service_input, services, n=1, cutoff=0.6)
        if matches:
            return matches[0]
        return None

    def lancer_destruction(self, service_name, user_login, user_pass):
        """Fonction principale qui lance le robot."""
        target = self.chercher_service(service_name)
        if not target:
            print(f"[-] Service '{service_name}' inconnu.")
            return

        print(f"[*] Initialisation du pilote Chrome pour {target}...")
        
        options = webdriver.ChromeOptions()
        options.add_argument("--start-maximized")
        options.add_argument("--disable-blink-features=AutomationControlled")
        options.add_experimental_option("excludeSwitches", ["enable-automation"])
        options.add_experimental_option('useAutomationExtension', False)

        driver = webdriver.Chrome(service=Service(ChromeDriverManager().install()), options=options)

        try:
            if target == "Reddit":
                self._scenario_reddit(driver, user_login, user_pass)
            elif target == "Amazon":
                self._scenario_amazon(driver, user_login, user_pass)
            else:
                print(f"[!] Pas de scénario automatique codé pour {target} dans cette version.")
                print(f"[*] J'ouvre simplement la page pour vous.")
                url = self.services_database[target]["url_suppression"]
                driver.get(url)
                time.sleep(60)

        except Exception as e:
            print(f"[ERREUR CRITIQUE] Le robot a échoué : {e}")
        finally:
            print("[*] Fermeture du navigateur dans 10 secondes...")
            time.sleep(10)
            driver.quit()

    def _scenario_reddit(self, driver, login, password):
        print("[*] Étape 1 : Accès à la page de login Reddit...")
        driver.get("https://www.reddit.com/login/")

        wait = WebDriverWait(driver, 10)

        print("[*] Étape 2 : Saisie des identifiants...")
        user_field = wait.until(EC.presence_of_element_located((By.ID, "loginUsername")))
        pass_field = driver.find_element(By.ID, "loginPassword")

        user_field.send_keys(login)
        pass_field.send_keys(password)
        pass_field.send_keys(Keys.RETURN)

        print("[*] Connexion envoyée. Attente (vérifiez si CAPTCHA)...")
        time.sleep(5)

        if "login" in driver.current_url:
            print("[!] ATTENTION : Reddit demande peut-être un code 2FA ou un Captcha.")
            print("[!] Veuillez le résoudre manuellement dans la fenêtre Chrome.")
            input(">>> Appuyez sur ENTRÉE ici quand vous êtes connecté...")

        print("[*] Étape 3 : Accès à la page de suppression...")
        driver.get("https://www.reddit.com/settings/account")

        print("[*] Le robot vous a amené dans les paramètres.")
        print("[*] La dernière étape (clic 'Delete') est laissée manuelle par sécurité.")

    def _scenario_amazon(self, driver, login, password):
        print("[*] Étape 1 : Accès Amazon...")
        driver.get("https://www.amazon.fr/ap/signin?openid.pape.max_auth_age=0&openid.return_to=https%3A%2F%2Fwww.amazon.fr%2F&openid.identity=http%3A%2F%2Fspecs.openid.net%2Fauth%2F2.0%2Fidentifier_select&openid.assoc_handle=frflex&openid.mode=checkid_setup&openid.claimed_id=http%3A%2F%2Fspecs.openid.net%2Fauth%2F2.0%2Fidentifier_select&openid.ns=http%3A%2F%2Fspecs.openid.net%2Fauth%2F2.0")

        wait = WebDriverWait(driver, 10)

        email_field = wait.until(EC.presence_of_element_located((By.ID, "ap_email")))
        email_field.send_keys(login)
        email_field.send_keys(Keys.RETURN)

        print("[*] Email envoyé.")

        try:
            pass_field = wait.until(EC.presence_of_element_located((By.ID, "ap_password")))
            pass_field.send_keys(password)
            pass_field.send_keys(Keys.RETURN)
            print("[*] Mot de passe envoyé.")
        except:
            print("[!] Amazon demande peut-être un Captcha ici. Faites-le manuellement.")
            input(">>> Appuyez sur ENTRÉE une fois le Captcha passé...")

        print("[*] Redirection vers la page de suppression...")
        driver.get("https://www.amazon.com/gp/help/customer/display.html?nodeId=GX7NJQ4ZB8MHFRNJ")


if __name__ == "__main__":
    parser = argparse.ArgumentParser(description="Bot de suppression de compte")
    parser.add_argument("service", help="Nom du service (ex: Reddit)")
    parser.add_argument("--login", help="Identifiant/Email du compte")
    parser.add_argument("--password", help="Mot de passe du compte")

    args = parser.parse_args()

    if not args.login or not args.password:
        print("--- MODE INTERACTIF ---")
        login = input("Login/Email : ")
        password = input("Mot de passe : ")
    else:
        login = args.login
        password = args.password

    app = DateDel()
    app.lancer_destruction(args.service, login, password)
