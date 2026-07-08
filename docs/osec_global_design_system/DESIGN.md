---
name: OSEC Global Design System
colors:
  surface: '#11131b'
  surface-dim: '#11131b'
  surface-bright: '#373942'
  surface-container-lowest: '#0c0e16'
  surface-container-low: '#191b23'
  surface-container: '#1d1f27'
  surface-container-high: '#282a32'
  surface-container-highest: '#32343d'
  on-surface: '#e1e2ed'
  on-surface-variant: '#c3c6d7'
  inverse-surface: '#e1e2ed'
  inverse-on-surface: '#2e3039'
  outline: '#8d90a0'
  outline-variant: '#434655'
  surface-tint: '#b4c5ff'
  primary: '#b4c5ff'
  on-primary: '#002a78'
  primary-container: '#2563eb'
  on-primary-container: '#eeefff'
  inverse-primary: '#0053db'
  secondary: '#4edea3'
  on-secondary: '#003824'
  secondary-container: '#00a572'
  on-secondary-container: '#00311f'
  tertiary: '#f9bd22'
  on-tertiary: '#402d00'
  tertiary-container: '#8b6700'
  on-tertiary-container: '#ffeed3'
  error: '#ffb4ab'
  on-error: '#690005'
  error-container: '#93000a'
  on-error-container: '#ffdad6'
  primary-fixed: '#dbe1ff'
  primary-fixed-dim: '#b4c5ff'
  on-primary-fixed: '#00174b'
  on-primary-fixed-variant: '#003ea8'
  secondary-fixed: '#6ffbbe'
  secondary-fixed-dim: '#4edea3'
  on-secondary-fixed: '#002113'
  on-secondary-fixed-variant: '#005236'
  tertiary-fixed: '#ffdf9f'
  tertiary-fixed-dim: '#f9bd22'
  on-tertiary-fixed: '#261a00'
  on-tertiary-fixed-variant: '#5c4300'
  background: '#11131b'
  on-background: '#e1e2ed'
  surface-variant: '#32343d'
typography:
  display-lg:
    fontFamily: Montserrat
    fontSize: 48px
    fontWeight: '700'
    lineHeight: 56px
    letterSpacing: -0.02em
  display-lg-mobile:
    fontFamily: Montserrat
    fontSize: 32px
    fontWeight: '700'
    lineHeight: 40px
    letterSpacing: -0.02em
  headline-md:
    fontFamily: Montserrat
    fontSize: 24px
    fontWeight: '600'
    lineHeight: 32px
  headline-sm:
    fontFamily: Montserrat
    fontSize: 20px
    fontWeight: '600'
    lineHeight: 28px
  body-lg:
    fontFamily: Inter
    fontSize: 18px
    fontWeight: '400'
    lineHeight: 28px
  body-md:
    fontFamily: Inter
    fontSize: 16px
    fontWeight: '400'
    lineHeight: 24px
  label-caps:
    fontFamily: Inter
    fontSize: 12px
    fontWeight: '600'
    lineHeight: 16px
    letterSpacing: 0.05em
rounded:
  sm: 0.25rem
  DEFAULT: 0.5rem
  md: 0.75rem
  lg: 1rem
  xl: 1.5rem
  full: 9999px
spacing:
  container-margin: 24px
  gutter: 16px
  section-gap: 48px
  stack-sm: 8px
  stack-md: 16px
  stack-lg: 24px
---

## Brand & Style
The design system embodies "Intellectual Luxury"—a fusion of high-end editorial aesthetics and high-performance educational utility. It targets aspiring entrepreneurs and industry professionals who seek a premium, distraction-free environment. 

The visual language balances the cinematic atmosphere of a streaming platform with the precision of a professional fintech tool. It leverages **Modern Minimalism** to reduce cognitive load, combined with **Glassmorphism** to create a sense of physical depth and premium craftsmanship. The interface must feel expensive, exclusive, and technologically advanced, evoking the same emotional response as a flagship luxury product.

## Colors
The palette is rooted in deep obsidian tones to provide a high-contrast canvas for vibrant accents.

- **Royal Blue (#2563EB):** The primary signal color, used for action-oriented elements and brand recognition.
- **Emerald Green (#10B981):** Reserved for success states, progress tracking, and financial growth indicators.
- **Gold (#FBBF24):** A rare accent used exclusively for "Premium," "Pro," and "Certified" statuses to denote value.
- **The Background Strategy:** Use `#0A0A0A` for the base layer. Interactive surfaces use `#171717` with a subtle 1px border of `rgba(255, 255, 255, 0.1)` to define edges without adding visual weight.

## Typography
The typography system relies on a high-contrast pairing. **Montserrat** provides an architectural, geometric strength for headlines, while **Inter** delivers maximum legibility for dense educational content and data.

For display titles, use tight letter spacing to create a "compact" premium look. Use the `label-caps` style for category tags and metadata to maintain a clean, organized hierarchy. Body text should maintain a generous line height (1.5x) to ensure readability during long study sessions.

## Layout & Spacing
The system follows a **fluid grid** model optimized for mobile-first consumption. 

- **Mobile:** 4-column grid with 24px side margins. Elements are stacked vertically to prioritize the video player and content flow.
- **Desktop:** 12-column grid. The layout shifts to a "Cinematic Sidebar" model where video content takes 8 columns and navigation/course modules occupy the remaining 4.
- **Vertical Rhythm:** Use an 8px base unit. Consistent spacing between course cards (24px) and within modules (16px) is critical for maintaining the "Minimalist" feel.

## Elevation & Depth
Depth is achieved through **Glassmorphism** and tonal layering rather than traditional heavy shadows.

- **Base Layer:** Pure black (#000000).
- **Secondary Surfaces:** Obsidian (#0A0A0A) for card backgrounds.
- **Glass Overlays:** For floating headers and navigation bars, use `backdrop-filter: blur(20px)` with a semi-transparent surface (`rgba(23, 23, 23, 0.7)`).
- **Shadows:** Use extremely soft, large-radius shadows (`box-shadow: 0 20px 40px rgba(0,0,0,0.5)`) to lift primary action cards above the background.

## Shapes
This design system utilizes an **extra-rounded** language to evoke a modern, friendly yet sophisticated feel. 

- **Cards & Containers:** Use `rounded-2xl` (1rem) for standard modules and `rounded-3xl` (1.5rem) for primary video cards.
- **Interactive Elements:** Buttons and input fields follow the `rounded-lg` (0.5rem) standard to remain professional and precise.
- **Progress Bars:** Use fully rounded (pill-shaped) ends for a fluid, organic appearance.

## Components

- **Premium Video Cards:** 16:9 aspect ratio. Feature a subtle gradient overlay at the bottom for legibility. Progress is shown as a thin Royal Blue line at the bottom edge.
- **Course Modules:** Accordion-style layout. Use a subtle vertical line (`rgba(255,255,255,0.1)`) to connect lessons visually. Locked content should be desaturated (60% opacity) with a Gold padlock icon.
- **Secure Payment Buttons:** High-gloss Royal Blue buttons with a slight inner glow on hover. Include a "Secure SSL" micro-label nearby in the `label-caps` style.
- **Locked Content Dialogs:** Full-screen glassmorphic blur with a centered Gold call-to-action. Focus on high-quality typography and a single, clear "Unlock" path.
- **Admin Analytics:** Charts use Emerald Green for growth and Royal Blue for volume. Background grid lines should be near-invisible (`rgba(255,255,255,0.05)`). Use "Inter" for all data labels to ensure technical precision.