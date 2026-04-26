# Recursive Maths Animator

> Beautiful, narrated math animations in minutes — no LaTeX, no bloat.

This is a **Cursor / Claude Code agent skill** that lets you (or your agent) create Manim animations without wrestling with LaTeX installs, font issues, or boilerplate. It ships **9 ready-made patterns** — table transforms, pie charts, formula derivations — all voiceover-ready and fully tweakable in a few lines of Python.

https://github.com/user-attachments/assets/e8976362-ad4f-4655-a41b-e21f86bcd253

---

## What's inside

Think of it as a drop-in animation kit. You pick a pattern, feed it your data, and get a 1080p60 MP4 with auto-generated narration and captions.

**The 9 patterns:**

| # | Pattern | What it's for | Preview |
|---|---------|-------------|---------|
| 1 | **TableToBarChartPattern** | Turn a data table into animated bars | <video src="videos/TableToBarChartPattern.mp4" width="160" muted loop playsinline></video> |
| 2 | **TableToLineGraphPattern** | Show trends over time | <video src="videos/TableToLineGraphPattern.mp4" width="160" muted loop playsinline></video> |
| 3 | **TableToScatterPlotPattern** | Visualize correlations and relationships | <video src="videos/TableToScatterPlotPattern.mp4" width="160" muted loop playsinline></video> |
| 4 | **DistributionAnimation** | Draw normal curves, histograms, statistical concepts | <video src="videos/DistributionAnimation.mp4" width="160" muted loop playsinline></video> |
| 5 | **FormulaDerivation** | Step through proofs and equation derivations | <video src="videos/FormulaDerivation.mp4" width="160" muted loop playsinline></video> |
| 6 | **SamplingVisualization** | Demonstrate sampling, CLT, statistical demos | <video src="videos/SamplingVisualization.mp4" width="160" muted loop playsinline></video> |
| 7 | **BasicPieChart** | Simple market share or percentage breakdowns | <video src="videos/BasicPieChart.mp4" width="160" muted loop playsinline></video> |
| 8 | **StaggeredPieChart** | Pie segments that appear one by one with emphasis | <video src="videos/StaggeredPieChart.mp4" width="160" muted loop playsinline></video> |
| 9 | **PieToBarTransition** | Same dataset, two perspectives — morphs from pie to bars | <video src="videos/PieToBarTransition.mp4" width="160" muted loop playsinline></video> |

All videos render at **1920×1080 @ 60fps** with **auto-generated voiceover** and **SRT captions**. Durations run 17–23 seconds — sweet spot for explainers, Reels, or TikTok.

---

## Quick start

```bash
# Activate the included virtual environment
source recursive-maths-animator/.training/.venv-3.12/bin/activate

# Render one pattern
python recursive-maths-animator/references/pattern_library/table_transforms.py TableToBarChartPattern -ql --format mp4

# Find your video
# → media/videos/1080p60/TableToBarChartPattern.mp4
```

That's it. No LaTeX. No 2GB dependency install. Manim Community + `manim-voiceover` handle the rest.

---

## Tweak a pattern in 3 lines

Every pattern is a plain Python class. Override the data, colors, or labels and re-render.

### Quarterly sales → bar chart

```python
from recursive_maths_animator.references.pattern_library import TableToBarChartPattern

scene = TableToBarChartPattern()
scene.data = [("Q1", 2500), ("Q2", 3200), ("Q3", 2800), ("Q4", 4100)]
scene.bar_colors = [BLUE, GREEN, YELLOW, RED]
scene.render()
# → 19.3s animated video with narration
```

<video src="videos/TableToBarChartPattern.mp4" width="240" muted loop playsinline></video>

### Pythagorean proof → formula derivation

```python
from recursive_maths_animator.references.pattern_library import FormulaDerivation

scene = FormulaDerivation()
scene.formula_steps = ["a² + b² = c²", "c = √(a² + b²)"]
scene.render()
# → 17.2s step-by-step derivation with voiceover
```

<video src="videos/FormulaDerivation.mp4" width="240" muted loop playsinline></video>

### Market share with exploded emphasis

```python
from recursive_maths_animator.references.pattern_library import StaggeredPieChart

scene = StaggeredPieChart()
scene.data = [("Product A", 40), ("Product B", 30), ("Product C", 30)]
scene.explode_index = 0   # pulls the first segment out
scene.render()
# → 21.8s video with sequential reveals and explode effect
```

<video src="videos/StaggeredPieChart.mp4" width="240" muted loop playsinline></video>

---

## How the voiceover works

Patterns subclass `VoiceoverScene` and use `manim-voiceover` with **gTTS** (Google Text-to-Speech) by default. Narration cues are baked into the `construct()` method, so the audio stays locked to the animation beats — no manual syncing needed.

```python
with self.voiceover(text="Let's look at the quarterly sales data.") as tracker:
    self.play(FadeIn(title), run_time=1)
```

If you prefer **Gemini TTS**, swap in `references/gemini_tts_service.py` (requires a `GEMINI_API_KEY`).

---

## Why no LaTeX?

Manim's default `MathTex` and `Axes` objects pull in a full TeX Live install (~2GB). These patterns skip that entirely:

| Standard Manim | This skill uses |
|----------------|-----------------|
| `Axes()` | `Line()` + `Text()` |
| `MathTex()` | `Text()` with Unicode math |
| `FunctionGraph()` | `VMobject()` for full control |
| `PieChart()` | `AnnularSector()` built from scratch |

The result is faster setup, smaller footprint, and zero font-compile headaches.

---

## Git versioning for scenes

Included `references/manim_versioning.py` gives you `ManimProject` — a tiny helper that versions your scenes with git. Render, auto-commit, tweak, render again. Roll back if you break something.

```python
from manim_versioning import ManimProject

project = ManimProject("my_animation")
project.init()                    # scaffolds folders + requirements.txt
project.create_scene("intro", "class Intro(Scene): ...")
project.render("intro")           # commits as "intro v1"
project.update_scene("intro", "# improved code...")
project.render("intro")           # commits as "intro v2"
```

---

## Quality check: vision review loop

After rendering, `scripts/extract_verification_frames.py` slices your MP4 into evenly spaced still frames. Feed those to your agent (or yourself) against `references/video_verification_rubric.md` to catch padding issues, logic mismatches, or color glitches — then iterate.

```bash
python3 recursive-maths-animator/scripts/extract_verification_frames.py output.mp4 --count 8
```

---

## What you need

| Requirement | Why |
|-------------|-----|
| **Python 3.9+** | Manim and voiceover stack |
| **[Manim Community](https://docs.manim.community/en/stable/installation.html)** | Scene rendering engine |
| **ffmpeg + ffprobe** | Video I/O and frame extraction |
| **git** | Optional, for `ManimProject` versioning |
| **manim-voiceover + gTTS** | Optional, for auto narration |

Quick sanity check:

```bash
python3 recursive-maths-animator/scripts/check_environment.py
```

---

## Install the skill

Agents look for a directory named `recursive-maths-animator` containing `SKILL.md`.

**Claude Code (all projects):**
```bash
mkdir -p ~/.claude/skills
cp -R recursive-maths-animator ~/.claude/skills/
```

**Cursor (all projects):**
```bash
mkdir -p ~/.cursor/skills
cp -R recursive-maths-animator ~/.cursor/skills/
```

Restart your editor or start a new agent chat so the skill is picked up.

---

## Repo layout

```
recursive-math-animator/              # git repo root
├── LICENSE
├── README.md                          # this file
├── .gitignore
├── scripts/                           # publish_to_clawhub.sh (maintainers)
└── recursive-maths-animator/          # the installable skill
    ├── SKILL.md                       # agent instructions
    ├── requirements.txt               # pinned deps for new projects
    ├── references/
    │   ├── pattern_library/           # 9 verified LaTeX-free patterns
    │   ├── manim_versioning.py          # git scene versioning
    │   ├── soft_enterprise_palette.py   # color + easing helpers
    │   ├── gemini_tts_service.py        # optional Gemini TTS adapter
    │   └── video_verification_rubric.md # frame review checklist
    └── scripts/
        ├── extract_verification_frames.py
        ├── run_pipeline.py
        └── check_environment.py
```

---

## License

MIT — see [LICENSE](LICENSE).
