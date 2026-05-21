# Designový protokol: Location Screen (The Radar)

Vizuální reprezentace okolních uzlů na relativním radaru vzhledem k poloze a orientaci uživatele.

## 🎨 Vizuální styl (Aurelian Noir)
- **Styl:** Matematicky přesná vizualizace na černém pozadí s radiálním zlatým gradientem.
- **Radar:** Soustředné kružnice definující vzdálenost (10m, 25m, 50m).

## 📱 Struktura a obsah

### 1. Horní lišta (AppBar)
- **Titulek:** OFFCHAT (zlatý, centrovaný).

### 2. Radarové plátno (Radar Canvas)
- **Skenovací paprsek:** Rotující zlatý výsečový přechod simulující aktivní radar (animace _sweepController).
- **Měřítko:** 
    - Textové popisky vzdálenosti (10M, 25M, 50M) umístěné na svislé ose.
    - Jemné zlaté linky s 30% průhledností.

### 3. Centráůní uzel (My Device)
- **Vizuál:** Avatar uživatele uprostřed radaru.
- **Efekt:** Výrazná zlatá záře (BoxShadow) a zlatý okraj (2px).
- **Štítek:** Zlatý obdélník s textem MY DEVICE pod avatarem.

### 4. Okolní uzly (Device Blips)
- **Pozice:** Vypočítána na základě relativního azimutu (bearing) a vzdálenosti.
- **Vizuál:** Malý avatar (48px) se zlatým okrajem a jménem pod ním.
- **Orientace:** Pozice blipů se dynamicky mění podle natočení zařízení (kompasu) uživatele.

## ⚙️ Funkcionalita
- **Real-time update:** Radar se překresluje při každé změně orientace (heading) nebo GPS polohy.
- **Animace:** Nekonečná rotace skenovacího paprsku (4 sekundy na otočku).
- **Omezení:** Radar zobrazuje zařízení do maximální vzdálenosti 50 metrů.
