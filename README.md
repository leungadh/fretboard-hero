![Fretboard Hero](assets/banner.svg)

# 🎸 Fretboard Hero

A gamified guitar practice web app for beginners — your guitar is the controller. Inspired by Yousician.

Learn notes and chords by playing them on a real guitar. The app listens through your microphone, detects what you play, and scores you in real time — then rewards your practice with tokens you spend building your own concert hall.

## Features

### 23 levels across 5 stages

- **🎯 Stage 1 · Notes on the Fretboard (1–8)** — open strings, then each string frets 0–5, then a full-board mix
- **🎸 Stage 2 · Chords (9–13)** — Em, Am, D, G, C. Learn mode shows a chord diagram and verifies each string as you pick it (catching exactly which finger is misplaced); change drills name a chord and check your full strum
- **🎵 Stage 3 · Songs (14–16)** — Guitar Hero-style scrolling note highway: Smoke on the Water, Seven Nation Army, and Ode to Joy, at 50/75/100% speed with metronome count-in and Perfect/Good timing scores
- **🥁 Stage 4 · Rhythm (17–19)** — strumming trainer: hold any chord and follow the arrows (quarters, down-up eighths, the folk strum) against an accented metronome
- **🏆 Stage 5 · Mastery (20–23)** — up the neck: frets 5–9, the landmark dots (5/7/9/12), and a final full-fretboard exam across all 78 positions

### Practice tools
- **Real-time pitch detection** — Web Audio API, no server, install, or account needed
- **Built-in tuner** — live note + cents display, doubles as a guitar tuner
- **Practice options** — toggle fret hints off once confident; relaxed timer/tempo mode; song speed control

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
2. **Note levels (Stages 1 & 5):** you're shown a note name and string — play it cleanly near your mic before the timer runs out
3. **Chord learn levels:** fret the chord shown in the diagram, then pick each string low to high; verified strings turn green. **Change drills:** strum the named chord on cue and let it ring
4. **Songs:** notes scroll toward the hit line in their string lanes — play each as it arrives; tighter timing scores 🎯 Perfect
5. **Rhythm:** hold any chord and strum the ↓/↑ arrows in time with the click
6. Faster answers and streaks earn more points; 90%+ accuracy = 3 stars, 1 star unlocks the next level
7. After each lesson, spend your tokens in the **🏛️ Music Hall** — buy instruments and musicians, decorate the hall, and come back to see your band grow

## Tech

Single-file vanilla HTML/CSS/JS, ~1,300 lines, no dependencies. Four detection methods, all
running on a live mic stream via the Web Audio API:

- **Single notes** — autocorrelation (ACF2+) with parabolic interpolation over a 4096-sample
  buffer; a note counts after 5 consecutive matching frames (pitch class match, octave-error
  tolerant)
- **Strummed chords** — chromagram: FFT energy folded into 12 pitch classes (75–1050 Hz);
  a chord counts when the three loudest pitch classes are all chord tones
- **Song timing** — notes matched inside a ±0.35 s hit window (±0.15 s = Perfect), with a
  re-attack gate so one ringing note can't count for two; metronome scheduled on the
  AudioContext clock
- **Strum onsets** — RMS energy spikes over a running average, with a refractory period;
  works with any chord since no pitch is needed

SVG rendering throughout: fretboard with movable fret window and inlay dots, chord diagrams,
scrolling note highway, rhythm pattern bar, and the music hall scene.

## Roadmap

All original goals shipped ✅ — notes, chords, songs, rhythm, and full-fretboard mastery.

Ideas for the future:

- [ ] More songs (the note format makes new riffs a few lines each)
- [ ] Barre chords (F, Bm) and 7th chords
- [ ] Scales practice (pentatonic boxes)
- [ ] Chord songs — strum patterns + chord changes combined, like a real song

## License

MIT
