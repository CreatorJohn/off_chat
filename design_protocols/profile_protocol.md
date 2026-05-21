# Designový protokol: Profile Screen

Správa identity uživatele a systémové nastavení aplikace v estetice Aurelian Noir.

## 🎨 Vizuální styl (Aurelian Noir)
- **Styl:** Bento-grid rozvržení s kartami na tmavém pozadí.
- **Materiály:** Karty mají barvu surfaceContainerLow s jemným zlatým okrajem.

## 📱 Struktura a obsah

### 1. Profile Hero Section
- **Avatar:** Čtvercový (zaoblení 32px) s výrazným zlatým gradientovým okrajem.
- **Editace:** Překryvné zlaté tlačítko s ikonou tužky.
- **Jméno:** Velký off-white text (displaySmall).
- **Stable ID:** Monospace text ID: [DEVICE_ID] s 50% průhledností.

### 2. System Health Card
- **Obsah:** Monitoring stavu BLE, GPS a baterie.
- **Vizuál:** Dynamické indikátory stavu.

### 3. Mesh Identity Card
- **Sekce:** Změna "Display Alias".
- **Prvky:** Textové pole se zlatým okrajem při fokusu a akční tlačítko SYNC NAME se zlatým pozadím a černým textem.

### 4. Nastavení (Settings Cards)
- **Karty:** Location Visibility a Notifications.
- **Prvky:** Ikona ve zlatém čtverci, titulek, podtitul a zlatý Switch přepínač.

### 5. Patička (Footer)
- **Dělící čára:** Lineární gradient zlaté záře.
- **Metadata:** SECURITY LEVEL 4 // V[VERSION] (monospace, zlatý nádech).

## ⚙️ Funkcionalita
- **Změna jména:** Okamžitá synchronizace s BLE reklamním paketem (advertising).
- **Správa obrázku:** Integrace s galerii a automatická komprese na webp.
- **Stavy:** Integrace s Riverpod providery pro real-time přepínání viditelnosti.
