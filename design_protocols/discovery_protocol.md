# Designový protokol: Discovery Screen (The Nodes)

Hlavní obrazovka aplikace pro vyhledávání okolních uzlů (zařízení) v mesh síti.

## 🎨 Vizuální styl (Aurelian Noir)
- **Styl:** Temné uživatelské rozhraní se zlatými a barevnými stavovými indikátory.
- **Karty:** Zaoblené obdélníky (24px) s jemným zlatým okrajem (0.1 průhlednost).

## 📱 Struktura a obsah

### 1. Horní lišta (AppBar)
- **Statusy (vlevo):** 
    - **Radar Icon:** Modrý pulzující indikátor při aktivním skenování.
    - **Visibility Icon:** Zelený pulzující indikátor, pokud je zařízení viditelné pro ostatní.
- **Titulek:** OFFCHAT (centrovaný, malé kapitálky, letterSpacing 4).
- **Progress:** Tenký zlatý indikátor pod AppBar během probíhajícího skenování.

### 2. Záhlaví obsahu
- **Titulek:** Nearby Devices (headlineSmall, tučné).
- **Podtitul:** Scanning for active pulses...
- **Badge:** Zlatý badge ACTIVE vpravo nahoře.

### 3. Seznam zařízení (Device List)
- **Karta uzlu (Device Card):**
    - **Avatar:** Čtvercový se zaoblením 16px.
    - **Online indikátor:** Zelený bod v pravém dolním rohu avataru (pokud bylo viděno v posledních 2 minutách).
    - **Jméno:** Node: [Alias] (titleMedium, tučné).
    - **Verified:** Zlatá ikona fajfky u jména, pokud je k dispozici veřejný klíč.
    - **Status:** Čas od posledního spatření (např. "Seen 2 minutes ago").
    - **Akce:** Kruhové zlaté tlačítko se zprávou.

### 4. Detail profilu (Profile Dialog)
- **Vizuál:** Dialog s tmavým pozadím a zlatým okrajem (zaoblení 28px).
- **Prvky:** Velký kruhový avatar, jméno, Stable ID a metadata (čas, lokace).
- **Akce:** Tlačítka CLOSE (outlined) a MESSAGE (elevated zlaté).

## ⚙️ Funkcionalita
- **Skenování:** Automatické BLE skenování na pozadí.
- **Granulární status:** Zobrazení specifických stavů synchronizace (např. "Reading profile...") přímo v kartě zařízení.
- **Navigace:** Kliknutí na kartu otevře detail profilu, kliknutí na ikonu zprávy přejde přímo do chatu.
- **Debug:** Dvojitý poklep na titulek v AppBaru otevře logovací terminál.
