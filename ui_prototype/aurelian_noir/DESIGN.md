# Design System Strategy: The Gilded Noir

## 1. Overview & Creative North Star: "The Digital Concierge"
This design system is not a utility; it is an atmosphere. Our Creative North Star is **"The Digital Concierge"**—a philosophy that rejects the cluttered, boxy nature of standard apps in favor of a spacious, editorial layout that feels curated and high-end. 

We break the "template" look by leaning into **intentional asymmetry** and **tonal depth**. By utilizing a "Deep Black" foundation with "Gilded" interactive points, we create a high-contrast environment where content doesn't just sit on the screen—it is presented. We favor generous breathing room (`spacing-12` and `spacing-16`) and fluid, oversized radii (`rounded-xl`) to mimic the soft edges of premium physical goods.

## 2. Colors & Atmospheric Layering
The palette is built on a foundation of obsidian and gold. The goal is a "glow-on-dark" effect that feels expensive.

*   **Primary (#f2ca50) & Container (#d4af37):** These are your "Jewel" moments. Use these sparingly for high-intent actions.
*   **The "No-Line" Rule:** Under no circumstances should 1px solid borders be used to divide sections. Structure is defined exclusively through background shifts. For example, a list of items (`surface-container-low`) sits directly on the `surface` background. The eye perceives the edge through the shift in value, not a stroke.
*   **Surface Hierarchy & Nesting:** Treat the UI as stacked sheets of obsidian glass. 
    *   **Base Layer:** `surface` (#131313).
    *   **Section Layer:** `surface-container-low` (#1b1b1b) for grouped content.
    *   **Feature/Card Layer:** `surface-container-high` (#2a2a2a) for interactive components.
*   **The "Glass & Gradient" Rule:** For primary CTAs, do not use flat fills. Use a subtle linear gradient from `primary` (#f2ca50) to `primary_container` (#d4af37) at a 135-degree angle. This adds a "metallic" luster that flat hex codes cannot achieve.
*   **Signature Textures:** Apply a `backdrop-blur` (20px+) to any element using `surface_variant` with 60% opacity to create a "Smoked Glass" effect for floating headers or navigation bars.

## 3. Typography: Editorial Authority
We use **Plus Jakarta Sans** to bridge the gap between technical precision and organic warmth.

*   **Display Scales:** Use `display-lg` and `display-md` for "Hero" moments. Don't center everything; use left-aligned, tight-leading headlines to create a sophisticated, magazine-style "Swiss" layout.
*   **High-Contrast Hierarchy:** Pair `display-sm` (Gold/Primary) with `body-md` (On-Surface-Variant/Muted Grey). The contrast in both size and color creates an immediate visual anchor for the user.
*   **Labeling:** `label-sm` should always be uppercase with a letter-spacing of `0.05rem` to evoke the feel of luxury brand marking.

## 4. Elevation & Depth: Tonal Sculpting
We move away from the "drop shadow" era into an era of **Tonal Layering**.

*   **The Layering Principle:** To lift an object, move it up the surface scale. A "floating" modal should be `surface-container-highest` (#353535) against a dimmed `surface` background.
*   **Ambient Shadows:** If a shadow is required for a floating action button, use a blur of `24px`, an offset of `y-8`, and a color derived from `primary` at 10% opacity. This creates a "gold underglow" rather than a dirty grey shadow.
*   **The "Ghost Border" Fallback:** In rare accessibility cases where a border is needed, use `outline-variant` (#4d4635) at 20% opacity. It should be felt, not seen.

## 5. Components & Primitive Styling

### Buttons
*   **Primary:** Gradient fill (`primary` to `primary_container`), `rounded-full`, `title-sm` typography. No border.
*   **Secondary:** Ghost style. No fill, `outline-variant` (at 30% opacity) border, `on-surface` text.
*   **Tertiary:** Plain text in `primary` color with a `0.5rem` bottom-aligned gold accent line for "Selected" states.

### Cards & Containers
*   **Rule:** Forbid divider lines.
*   **Application:** Use `spacing-6` (2rem) of vertical whitespace to separate card groups. If content is dense, use a subtle background shift to `surface-container-low`.
*   **Radius:** All cards must use `rounded-lg` (2rem) to maintain the fluid, "liquid" aesthetic of the system.

### Input Fields
*   **Standard State:** `surface-container-highest` fill, `rounded-md`, no border.
*   **Active State:** Add a `1px` "Ghost Border" using the `primary` color at 40% opacity and a subtle outer glow (4px blur).
*   **Labels:** Use `label-md` floating above the input, never inside.

### Signature Component: The "Gilded Carousel"
Use asymmetric horizontal scrolling where the first item is `spacing-10` from the left edge, and the trailing items are partially cut off. This signals "more to explore" without requiring a scrollbar or heavy UI indicators.

## 6. Do's and Don'ts

### Do:
*   **Embrace the Void:** Use `surface` (#131313) as a design element itself. Let large areas remain empty to focus the eye on the gold "Jewel" elements.
*   **Use Fluid Motion:** When transitioning between surfaces, use "Spring" animations (stiffness: 300, damping: 20) to match the rounded, organic visuals.
*   **Prioritize Legibility:** Ensure `body-md` text is always `on-surface` or `on-surface-variant` to maintain a 7:1 contrast ratio against the dark background.

### Don't:
*   **No Pure White:** Never use `#FFFFFF`. Use `on-surface` (#e2e2e2) for text and highlights to prevent "retina burn" against the deep black.
*   **No Hard Corners:** Avoid `rounded-none` or `rounded-sm`. The design system relies on the "Fluid" aesthetic; hard corners break the premium immersion.
*   **No Vibrancy Overload:** Avoid using `tertiary` (blue tones) unless it's for specific system-level feedback (like informational tooltips). Keep the focus on the Gold/Black duality.