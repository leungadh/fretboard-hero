# CLAUDE.md

Guidance for Claude Code when working in this repository.

## Project

Fretboard Hero — a gamified guitar practice web app (Yousician-style) for the owner, Andy,
a beginner guitarist. The guitar is the controller: the app listens via microphone and
verifies what's played in real time. Personalization is intentional — the app greets Andy
by name (`PLAYER` const) and gives performance-based encouragement.

## Architecture

**Everything is in `index.html`** (~1,300 lines, vanilla HTML/CSS/JS, zero dependencies,
no build step). This is deliberate — keep it a single file unless Andy asks otherwise.
Other files: `README.md`, `assets/banner.svg` (hand-written SVG), `start.command`
(macOS launcher: python3 http.server on port 8000 + open browser).

The `<script>` is organized in commented sections, in order:

1. **Note math** — `NOTE_NAMES`, `midiToName`, `midiToFreq`, `STRINGS` (standard tuning,
   index 0 = string 6 low E, midi 40)
2. **Chords** — `CHORDS` (frets array, index 0 = string 6, `-1` = muted), `chordNotes`, `chordPCs`
3. **Songs** — `SONGS`: notes as `[beat, string, fret]`, sorted by beat
4. **Levels** — `LEVELS` array; a level's `mode` is `undefined` (note), `"chordLearn"`,
   `"chordStrum"`, `"song"`, or `"rhythm"`. Note levels have `pool` + optional
   `win {lo, hi}` (fret display window); song levels have `song` (index into SONGS);
   rhythm levels have `bpm`, `bars`, `pattern` (8 eighth-note slots of `"D"`/`"U"`/`""`)
5. **Progress / stats** — two localStorage keys: `fh-progress` (stars per level id) and
   `fh-stats` (sessions, dayStreak, lastDay, tokens, owned, migrated)
6. **Shop catalog** — `ITEMS`: instruments/musicians/decor; musicians have `needs`
   (instrument id) and only appear on stage when both are owned
7. **Encouragement** — `CHEERS` message pools keyed by stars 0–3, `{n}` = player name
8. **Screens/UI** — `screens` map + `show()`; screens: menu, game, results, progress, hall
9. **Rendering** — `drawBoard` (fret-window aware), `drawChordBoard`, `drawHighway` (song),
   `drawRhythm`, `renderHall`/`renderShop` (SVG hall scene), `renderProgress`
10. **Detection** — `detectPitch` (ACF2+ autocorrelation on 4096-sample time buffer),
    `chromaSnapshot` (FFT → 12 pitch classes, 75–1050 Hz), onset detection inline in
    `rhythmFrame` (RMS spike over running EMA with 0.18 s refractory)
11. **Game loop** — `startLevel` (per-mode setup) → `nextNote` (per-mode prompt) →
    `loop` (rAF; dispatches to `songFrame` / `rhythmFrame` or inline note/chord matching)
    → `resolve(hit)` → `endLevel` (stars, tokens, session recording)

## Key invariants — do not break

- **Stage partition:** `STAGES` matchers must assign every level to exactly one stage, and
  stages must be contiguous in `LEVELS` order (unlock chain is linear: 1 star on level N
  unlocks N+1; the menu groups by stage).
- **Note matching is octave-tolerant:** pitch class equal AND |Δmidi| ≤ 12 — keep this;
  autocorrelation octave errors are common.
- **Song data:** notes sorted by beat; adjacent same-pitch notes rely on the re-attack gate
  (`game.armed` / `game.lastHitPC`) — a ringing note must not hit twice.
- **Rhythm patterns:** adjacent strum slots must be > 2 × `RH_WIN` (0.16 s) apart at the
  level's bpm (check relaxed 0.8× bpm too), or hit windows overlap.
- **chordLearn sequences:** consecutive playable strings of a chord must differ in pitch
  class (all current CHORDS satisfy this) — the detector transitions on pitch change.
- **Detector range:** playable notes must be 60–1500 Hz (fret ≤ 12 on all strings is fine).
- **Fret windows:** every pool target must satisfy `win.lo < fret ≤ win.hi`, except open
  strings which require `win.lo === 0` (the nut is only drawn then).
- **Timing uses the AudioContext clock** (`audioCtx.currentTime`) in song/rhythm modes, not
  `performance.now()` — metronome ticks are pre-scheduled oscillators; call `stopTicks()`
  on quit/end.
- **Export/import:** the whole `stats` object round-trips through JSON export — new stats
  fields need defaults in BOTH `Object.assign` sites (init and import handler).
- **No localStorage assumptions beyond one origin:** file:// and localhost are different
  origins; never hardcode either.

## Common tasks

- **Add a song:** append to `SONGS` (`[beat, string, fret]`, keep sorted) + a `LEVELS` entry
  with `mode: "song"`. Check min same-pitch gap and the riff's note names.
- **Add a chord:** add to `CHORDS`; verify consecutive-string pitch classes differ and
  chord tones are correct; add to a level's `chords` array.
- **Add a shop item:** append to `ITEMS` with hall coordinates (SVG viewBox 800×450; wall
  y<320, floor below); musicians need a `needs` instrument and are auto-placed above it.
- **Add a level:** insert in `LEVELS` respecting stage contiguity; stars/tokens/progress
  all derive from `LEVELS` automatically.

## Testing

No test framework. Verify changes with:

```bash
# syntax: extract the script and check it
python3 -c "import re; open('/tmp/app.js','w').write(re.search(r'<script>(.*)</script>', open('index.html').read(), re.S).group(1))"
node --check /tmp/app.js
```

For logic, eval the data prelude in node and assert invariants (pattern used throughout this
project's history — see git log): extract `src.slice(src.indexOf('const NOTE_NAMES'),
src.indexOf('const ROUND_LEN'))`, then `eval(prelude + '; LEVELS')` and check pools, windows,
song gaps, stage partition. Mic-dependent behavior can only be tested manually in a browser.

## Running

`./start.command` (macOS) or `python3 -m http.server 8000` → http://localhost:8000.
Chrome blocks mic on file://; Safari allows it. macOS `AbortError` = mic permission or
Continuity (iPhone) mic issue.

## Git

Repo: https://github.com/leungadh/fretboard-hero — Andy pushes from his own terminal
(no credentials in this environment). Commit messages: imperative, concise, no attribution
footers.
