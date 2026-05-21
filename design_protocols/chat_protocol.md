# Designový protokol: Chat Screen

Rozhraní pro zabezpečenou textovou a obrazovou komunikaci mezi dvěma uzly.

## 🎨 Vizuální styl (Aurelian Noir)
- **Styl:** Moderní chatovací rozhraní s asymetrickými bublinami.
- **Barvy:** Moje zprávy jsou zlaté, přijaté zprávy jsou temně šedé.

## 📱 Struktura a obsah

### 1. Horní lišta (AppBar)
- **Navigace:** Zlatá šipka zpět.
- **Profil:** Kruhový avatar protistrany a titulek Node: [ID].
- **Status:** Malý šedý text Secured Mesh Connection.

### 2. Seznam zpráv (Message List)
- **Bublina "Moje zpráva":**
    - **Barva:** Zlatý gradient (primaryGold -> primaryGoldContainer).
    - **Text:** Černý (vysoký kontrast).
    - **Tvar:** Zaoblení 20px, pravý dolní roh je ostrý.
- **Bublina "Přijatá zpráva":**
    - **Barva:** surfaceContainerLow (tmavě šedá).
    - **Text:** Off-white.
    - **Tvar:** Zaoblení 20px, levý dolní roh je ostrý.
    - **Okraj:** Velmi tenký zlatý lem.
- **Čas a stav:**
    - Zobrazen pod bublinou.
    - Ikony fajfek (odesláno/doručeno) nebo červená ikona chyby.

### 3. Vstupní oblast (Input Area)
- **Pozadí:** Tmavý panel s průhledností (0.9).
- **Akce vlevo:** Zlaté tlačítko + pro odeslání obrázku.
- **Vstupní pole:** Černý "pilulkový" tvar s textem Message Offchat...
- **Odeslat:** Zlatý čtverec se zaoblenými rohy a černou ikonou papírového letadla.

## ⚙️ Funkcionalita
- **Media:** Podpora pro odesílání a zobrazení obrázků (automatické zaoblení 12px v bublině).
- **Scroll:** Automatické posouvání na konec seznamu při nové zprávě s plynulou animací.
- **Stavy zpráv:** Vizuální indikace doručení (fajfky) a selhání odeslání.
