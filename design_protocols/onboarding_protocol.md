# Designový protokol: Onboarding Screen

Tato obrazovka zajišťuje první seznámení uživatele s aplikací, nastavení základní identity a udělení potřebných oprávnění.

## 🎨 Vizuální styl (Aurelian Noir)
- **Pozadí:** Sytá černá (#131313).
- **Hlavní barva:** Zlatá (#F2CA50).
- **Prvky:** Velké kruhové ikony, plynulé přechody mezi stránkami, výrazné typografické prvky.

## 📱 Struktura a obsah

### 1. Úvodní obrazovka (Splash Step)
- **Logo:** Velké transparentní logo Off Chat (off-chat-logo-transparent.png).
- **Titulek:** OFFCHAT (displayLarge, letterSpacing 8).
- **Podtitul:** THE DIGITAL CONCIERGE (labelSmall, letterSpacing 4).
- **Akce:** Tlačítko BEGIN PROTOCOL.

### 2. Informační kroky (Step 1-5)
- **Vizuál:** Centrální kruhová ikona s jemným zlatým lemováním.
- **Obsah:**
    - **Step 1 (Discover Nearby):** Ikona Icons.radar. Popis vyhledávání zařízení v okolí.
    - **Step 2 (Offline Messaging):** Ikona Icons.forum. Popis posílání zpráv bez internetu.
    - **Step 3 (Image Sharing):** Ikona Icons.image. Popis sdílení médií v mesh síti.
    - **Step 4 (Location Discovery):** Ikona Icons.location_on. Popis radarové vizualizace.
    - **Step 5 (Profile Management):** Ikona Icons.person_pin. Popis správy identity.

### 3. Nastavení identity (Final Step)
- **Titulek:** IDENTITY. (displayMedium, tučné).
- **Avatar:** Velký kruhový placeholder pro profilový obrázek se zlatým okrajem (4px).
- **Editace:** Zlaté plovoucí tlačítko s ikonou fotoaparátu.
- **Jméno:** Textové pole DISPLAY NAME se zaoblenými rohy (16px) a tmavým výplňovým pozadím.

### 4. Footer (Společný pro informační kroky)
- **Indikátor stránek:** Čárkový indikátor (7 bodů), aktivní bod je zlatý a delší.
- **Hlavní tlačítko:** Široké zlaté tlačítko CONTINUE (v posledním kroku FINISH).
- **Průhlednost:** Pozadí footeru má jemný černý přechod do ztracena směrem nahoru.

## ⚙️ Funkcionalita
- **Navigace:** PageView s plynulým posouváním.
- **Oprávnění:** Při přechodu na poslední krok (index 5) aplikace automaticky vyžádá Bluetooth a Location oprávnění.
- **Validace:** Uživatel nemůže dokončit onboarding bez zadání jména.
- **Debug:** Dvojitý poklep na titulek "IDENTITY." nebo logo otevře logovací terminál.
