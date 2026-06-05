# Rhythm Legends – TPSIT

**Sviluppatore:** Sarder Samsuddin

---

# Descrizione del progetto

Rhythm Legends è un videogioco rhythm-game sviluppato in Flutter.

Il giocatore deve eseguire gesture precise a ritmo di musica:
- Tap
- Double Tap
- Swipe Left
- Swipe Right
- Swipe Up
- Swipe Down

Ogni gesto deve essere eseguito con il giusto timing per ottenere:
- PERFECT
- GOOD
- MISS

Il gioco include:
- GUI moderna neon/cyberbeat
- Musiche di background
- Effetti sonori
- Combo system
- Accuracy system
- Pause menu
- Livelli multipli

---

# Come funziona il progetto

## Gesture Detection

Il progetto utilizza il widget `GestureDetector` di Flutter.

Le gesture principali sono:

- `onTap`
- `onDoubleTap`
- `onPanUpdate`

Le gesture vengono confrontate con il tipo di nota corrente.

---

## Sistema Timing

Ogni nota si muove verticalmente verso una target zone centrale.

Quando il giocatore esegue una gesture:
- viene controllata la distanza della nota dalla zona centrale
- viene assegnato un rank

### Rank:
- PERFECT
- GOOD
- MISS

---

## Sistema Audio

Il progetto usa il package:

- `audioplayers`

Sono presenti:
- musica di background
- effetti sonori
- loop automatici

---

# Tecnologie utilizzate

- Flutter
- Dart
- GestureDetector
- StatefulWidget
- Timer.periodic
- audioplayers

---

# Struttura del progetto

lib/

├── main.dart

├── pages/
│   ├── menu_page.dart
│   ├── level_page.dart
│   ├── game_page.dart
│   ├── tutorial_page.dart
│   └── credits_page.dart

├── widgets/
│   ├── rhythm_note.dart
│   ├── target_zone.dart
│   ├── level_button.dart
│   └── neon_button.dart

├── models/
│   └── note_type.dart

└── services/
    └── audio_service.dart

---

# Caratteristiche principali

- Gesture Detection avanzato
- UI neon/cyberbeat
- Sistema accuracy
- Sistema combo
- Effetti sonori dinamici
- Background music
- Livelli progressivi
- Pause menu
- Menu moderno



Progetto TPSIT – ITIS C. Zuccante

Realizzato da:
Sarder Samsuddin
