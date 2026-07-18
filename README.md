![Fretboard Hero](assets/banner.svg)

# 🎸 Fretboard Hero

A gamified guitar practice web app for beginners — your guitar is the controller. Inspired by Yousician.

Learn notes and chords by playing them on a real guitar. The app listens through your microphone, detects what you play, and scores you in real time — then rewards your practice with tokens you spend building your own concert hall.

## Features

### Practice
- **Real-time pitch detection** — Web Audio API + autocorrelation (ACF2+), no server or install needed
- **13 progressive levels** — open strings → each string (frets 0–5) → full-board mix → chords
- **Chord learn mode (levels 9–11)** — Em, Am, D, G, C shown as chord diagrams; fret the chord and pick each string low to high, and the app verifies every note (it catches exactly which finger is misplaced)
- **Chord-change drills (levels 12–13)** — the app names a chord, you strum it on cue; a chromagram analysis of the full spectrum checks the chord tones
- **Built-in tuner** — live note + cents display, doubles as a guitar tuner
- **Practice options** — toggle fret hints off once confident; relaxed timer mode

### Game
- **Scoring & streaks** — speed bonuses, streak multipliers (up to 2×), 1–3 stars per level
- **Level unlocking** — earn at least 1 star (50%+ accuracy) to unlock the next level
- **Token economy** — every lesson pays 5–25 tokens by stars, plus bonuses for your first lesson of the day, new personal bests, and 3+ day streaks
- **Music Hall & shop** — spend tokens on 27 items: instruments, musicians (Cat Pianist, Bear Drummer…), and decorations. Musicians wait backstage until you buy their instrument, then take the stage. Collect all seven pairs for a full-house celebration
- **Personalized coaching** — greets you by name, tracks your day streak, and gives performance-based encouragement after every lesson

### Progress
- **Progress dashboard** — day streak, lesson count, overall accuracy, per-level bests, and an accuracy chart of your recent sessions
- **Saved automatically** — stars, tokens, and history persist in your browser (localStorage)
- **Export / Import** — back up progress as a JSON file or move it between browsers

## Getting Started

The app is a single HTML file with no dependencies.

### Option 1: One-click launcher (macOS, recommended)

Double-click `start.command` — it starts a local server and opens the game at
<http://localhost:8000>. Leave the Terminal window open while playing.
(First time: if macOS blocks it, right-click → Open. If needed, run
`chmod +x start.command` once.)

### Option 2: Safari direct

Open `index.html` directly in Safari — it allows microphone access on local files.
Note: progress is stored per origin, so pick one option and stick with it
(or use Export/Import on the Progress screen to move your data).

### Option 3: Manual local server

```bash
python3 -m http.server 8000
```

Then visit <http://localhost:8000>. (Chrome blocks the mic on `file://` URLs,
so a server is required for Chrome.)

> **macOS note:** if you get a mic error (`AbortError`), enable your browser under
> **System Settings → Privacy & Security → Microphone**, then fully restart the browser.
> Also close other apps that may hold the mic (Zoom, FaceTime, etc.).

## How to Play

1. Tune your guitar (the tuner at the bottom of the game screen works for this)
2. **Note levels (1–8):** you're shown a note name and string — play it cleanly near your mic before the timer runs out
3. **Chord levels (9–11):** fret the chord shown in the diagram, then pick each string low to high; verified strings turn green
4. **Change drills (12–13):** strum the named chord on cue and let it ring
5. Faster answers and streaks earn more points; 90%+ accuracy = 3 stars
6. After each lesson, spend your tokens in the **🏛️ Music Hall** — buy instruments and musicians, decorate the hall, and come back to see your band grow

## Tech

Single-file vanilla HTML/CSS/JS. Single notes: autocorrelation with parabolic interpolation
over a 4096-sample mic buffer; a note counts as hit after 5 consecutive matching frames
(pitch class match, octave-error tolerant). Strummed chords: chromagram — FFT energy folded
into 12 pitch classes (75–1050 Hz); a chord counts when the three loudest pitch classes are
all chord tones. SVG rendering for the fretboard, chord diagrams, and music hall.

## Roadmap

- [x] Chord practice (Em, Am, D, G, C): string-by-string learn mode + strummed chord-change drills
- [x] Token economy, shop, and decoratable music hall
- [x] Progress dashboard with export/import
- [x] Scrolling "Guitar Hero"-style song mode — 3 riffs (Smoke on the Water, Seven Nation Army, Ode to Joy) with 50/75/100% speed, metronome count-in, and Perfect/Good timing scores
- [x] Metronome / strumming rhythm trainer — 3 patterns (quarters, down-up eighths, folk strum) with accented metronome, strum onset detection, and timing scores
- [x] Higher frets (5–12) and full fretboard levels — Stage 5 · Mastery: up the neck, landmark dots, and full-fretboard mixed drills

## License

MIT
