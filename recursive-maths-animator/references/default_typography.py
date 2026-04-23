"""
Default on-screen typography for this skill.

Skill convention: use **Roboto** for all Manim ``Text()`` unless the user asks for
another font in ``DESIGN_THEME.md``.

Manim resolves ``font`` by family name against installed system fonts. For
reproducible renders (CI, minimal Linux images), add ``Roboto*.ttf`` under the
project's ``assets/fonts/`` and register the font with Manim's font system if
needed, or install ``fonts-roboto`` / ``ttf-roboto`` from the OS package manager.

``MathTex`` / ``Tex`` keep LaTeX math fonts unless the user requests otherwise.
"""

# Single default family for body, titles, labels, and code-style on-screen text.
DEFAULT_FONT = "Roboto"
