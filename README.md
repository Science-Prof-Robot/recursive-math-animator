# recursive-maths-animator

Agent skill for **technical and mathematical animations** using [Manim Community](https://www.manim.community/). It teaches Cursor, Claude Code, or other compatible agents how to structure projects, version scenes with git, optional narration, and a **vision review loop** after each render.

Repository: [github.com/Science-Prof-Robot/recursive-math-animator](https://github.com/Science-Prof-Robot/recursive-math-animator)

---

## What it does

The skill is the folder **`recursive-maths-animator/`**, which contains **`SKILL.md`** (the instructions the agent follows) plus helpers:

| Piece | Role |
|-------|------|
| **`SKILL.md`** | When to use Manim, how to agree on a **design theme**, folder layout, rendering, GIF previews, and the **verification loop**. |
| **`references/manim_versioning.py`** | Optional Python helper: git-backed **scene versions**, branches, rollbacks, and render helpers. |
| **`references/soft_enterprise_palette.py`** | Example color and easing helpers for consistent visuals. |
| **`references/video_verification_rubric.md`** | Checklist for reviewing **still frames** (padding, logic vs storyboard, theme, glitches). |
| **`references/gemini_tts_service.py`** | Optional: Gemini TTS for `manim-voiceover` (needs API key and `google-genai`). |
| **`scripts/extract_verification_frames.py`** | Uses **ffmpeg/ffprobe** to slice a video into frames + `manifest.json` for multimodal review. |
| **`scripts/run_pipeline.py`** | Optional render + subtitle burn-in pipeline. |
| **`scripts/check_environment.py`** | Prints whether Manim, ffmpeg, git, and common Python deps are available. |
| **`requirements.txt`** | Template copied into **new animation projects** by `ManimProject.init()` — not necessarily installed into the skill folder itself. |

**End-to-end flow (high level):**

1. Agent and user lock **layout, colors, and intent** (documented in `DESIGN_THEME.md` inside each animation project).
2. Agent writes or updates **Manim** scene code; optional **manim-voiceover** for narration.
3. User or agent **renders** MP4/GIF (Manim CLI or `ManimProject.render*`).
4. **`extract_verification_frames.py`** pulls evenly spaced stills into `exports/verification/…`.
5. The **same agent session** (with vision) reads those frames against the rubric and storyboard, and writes **`VERIFICATION_FEEDBACK.md`** with concrete fixes.
6. Iterate on code and re-render until quality is acceptable.

The skill does **not** call cloud LLM APIs from Python; vision review uses whatever model your IDE/agent already has.

---

## What you need on your machine

**To use the skill** (teach the agent):

- Nothing beyond your editor’s skill support; the agent only needs to **read** `SKILL.md` and the referenced files.

**To actually render animations** (when you or the agent runs Manim):

| Requirement | Why |
|-------------|-----|
| **Python 3.9+** | Manim and scripts. |
| **[Manim Community](https://docs.manim.community/en/stable/installation.html)** | Scene rendering. |
| **ffmpeg** and **ffprobe** | Video I/O; frame extraction for verification. |
| **git** | If you use `ManimProject` versioning. |
| **manim-voiceover** (+ a TTS backend such as gTTS) | Optional narration. |
| **google-genai** + **`GEMINI_API_KEY`** | Only if you use the Gemini TTS helper. |

Quick check from a clone of this repo:

```bash
python3 recursive-maths-animator/scripts/check_environment.py
```

---

## Install the skill

Agents expect a **directory** whose name matches the skill (here: `recursive-maths-animator`) containing **`SKILL.md`**.

### From Git (recommended)

```bash
git clone https://github.com/Science-Prof-Robot/recursive-math-animator.git
cd recursive-math-animator
```

Then copy or symlink the inner skill folder to your tool’s skills location:

**Cursor — all projects**

```bash
mkdir -p ~/.cursor/skills
cp -R recursive-maths-animator ~/.cursor/skills/
```

**Cursor — one repo**

```bash
mkdir -p .cursor/skills
cp -R recursive-maths-animator .cursor/skills/
```

**Claude Code — all projects**

```bash
mkdir -p ~/.claude/skills
cp -R recursive-maths-animator ~/.claude/skills/
```

**Claude Code — one repo**

```bash
mkdir -p .claude/skills
cp -R recursive-maths-animator .claude/skills/
```

Restart the editor or start a new agent chat so the skill is loaded.

If the tool reports an **unknown skill**, confirm the path you registered ends with **`recursive-maths-animator/SKILL.md`** (the inner installable folder), not only the Git repository root.

### From ClawHub

If the package is published under the slug `recursive-maths-animator`:

```bash
npx --yes clawhub@latest install recursive-maths-animator --workdir /path/to/parent
```

That creates `/path/to/parent/skills/recursive-maths-animator/`. Point your agent at that folder the same way as a Git install.

---

## Using helpers inside an animation project

New projects created with `ManimProject.init()` get `requirements.txt`, `DESIGN_THEME.md`, `assets/`, `exports/`, etc. Scene code must be able to import `references/` (copy the skill’s `references` into the project or add it to `PYTHONPATH` / `sys.path`); **`SKILL.md`** shows the usual `sys.path` pattern.

For verification after a render:

```bash
python3 path/to/recursive-maths-animator/scripts/extract_verification_frames.py path/to/output.mp4 --count 8
```

Full steps and templates are in **`recursive-maths-animator/SKILL.md`**.

---

## Layout of this repository

```text
recursive-math-animator/          # git repo root (this README)
├── LICENSE
├── README.md
└── recursive-maths-animator/     # the installable skill
    ├── SKILL.md
    ├── requirements.txt          # copied into new Manim projects by init()
    ├── scripts/
    └── references/
```

---

## Smoke test (Manim)

```bash
printf '%s\n' 'from manim import *' 'class Smoke(Scene):' '    def construct(self): self.play(Write(Text("ok")))' > smoke.py
manim -ql smoke.py Smoke
```

## License

MIT — see [LICENSE](LICENSE).
