# OSEC Design System

## Brand Identity

OSEC is positioned as a premium, trustworthy e-commerce education platform. The design language blends professionalism with modern aesthetics, using glassomorphism to convey depth and sophistication.

## Color Palette

### Primary Colors

| Name | Hex | Usage |
|------|-----|-------|
| Obsidian | `#11131B` | Primary backgrounds, navigation bars |
| Royal Blue | `#2563EB` | Primary actions, links, active states |
| Emerald Green | `#10B981` | Success states, completed items, verification |
| Gold | `#FBBF24` | Highlights, ratings, badges, premium features |

### Neutral Colors

| Name | Hex | Usage |
|------|-----|-------|
| Pure White | `#FFFFFF` | Text on dark backgrounds |
| Light Gray | `#F3F4F6` | Card backgrounds, sections |
| Medium Gray | `#9CA3AF` | Secondary text, placeholder text |
| Dark Gray | `#4B5563` | Primary text on light backgrounds |
| Near Black | `#1F2937` | Borders, dividers |

### Semantic Colors

| Name | Hex | Usage |
|------|-----|-------|
| Error Red | `#EF4444` | Errors, validation failures |
| Warning Orange | `#F59E0B` | Warnings, pending states |
| Info Blue | `#3B82F6` | Informational elements |

## Typography

### Font Family

| Usage | Font | Weight |
|-------|------|--------|
| Headings (H1-H4) | Montserrat | Bold (700) |
| Subheadings | Montserrat | Semi-Bold (600) |
| Body Text | Inter | Regular (400) |
| Captions | Inter | Medium (500) |
| Buttons | Montserrat | Semi-Bold (600) |
| Labels | Inter | Medium (500) |

### Type Scale

| Style | Size | Line Height | Letter Spacing |
|-------|------|-------------|----------------|
| H1 | 32px | 40px | -0.5px |
| H2 | 24px | 32px | -0.25px |
| H3 | 20px | 28px | -0.25px |
| H4 | 18px | 24px | 0px |
| Body Large | 16px | 24px | 0px |
| Body | 14px | 20px | 0px |
| Caption | 12px | 16px | 0.25px |
| Button | 16px | 20px | 0.5px |
| Overline | 10px | 14px | 1px |

## Spacing System

Based on an 8px grid:

| Token | Pixels | Usage |
|-------|--------|-------|
| xs | 4px | Icon spacing |
| sm | 8px | Small gaps |
| md | 16px | Default padding |
| lg | 24px | Section spacing |
| xl | 32px | Component margins |
| 2xl | 48px | Screen padding |
| 3xl | 64px | Hero section spacing |

## Glassomorphism

The UI uses glassomorphic effects to create depth:

```css
.glass-card {
  background: rgba(255, 255, 255, 0.05);
  backdrop-filter: blur(20px);
  border: 1px solid rgba(255, 255, 255, 0.1);
  border-radius: 16px;
  box-shadow: 0 8px 32px rgba(0, 0, 0, 0.12);
}
```

### Glass Variants

| Variant | Background | Blur | Border |
|---------|------------|------|--------|
| Light Glass | `rgba(255,255,255,0.08)` | 20px | `rgba(255,255,255,0.12)` |
| Dark Glass | `rgba(17,19,27,0.6)` | 20px | `rgba(255,255,255,0.06)` |
| Colored Glass | `rgba(37,99,235,0.1)` | 15px | `rgba(37,99,235,0.15)` |

## Component Specifications

### Buttons

| Variant | Background | Text | Height | Border Radius |
|---------|------------|------|--------|---------------|
| Primary | Royal Blue | White | 48px | 12px |
| Secondary | Transparent | Royal Blue | 48px | 12px (border: 1.5px) |
| Ghost | Transparent | White | 48px | 12px |
| Danger | Error Red | White | 48px | 12px |

### Cards

- **Border Radius:** 16px (default), 20px (featured)
- **Padding:** 16px standard, 24px featured
- **Shadow:** Elevated: `0 4px 12px rgba(0,0,0,0.08)`
- **Background:** White or glassomorphic

### Input Fields

- **Height:** 52px
- **Border Radius:** 12px
- **Border:** 1.5px solid Medium Gray
- **Focus:** 1.5px solid Royal Blue
- **Error:** 1.5px solid Error Red
- **Label:** Inter Medium (500), 14px
- **Placeholder:** Inter Regular, 16px, Medium Gray

### Bottom Navigation

- **Height:** 64px (with safe area)
- **Background:** Obsidian glass
- **Active Icon:** Royal Blue
- **Inactive Icon:** Medium Gray
- **Label:** Caption style, 10px

## Iconography

- **Style:** Linear (stroke-based), 1.5px stroke width
- **Standard Size:** 24x24px
- **Small:** 16x16px
- **Large:** 32x32px
- **Library:** Phosphor Icons or custom SVG set

## Dark Mode

The app uses a dark-first design approach:

- **Primary background:** Obsidian (`#11131B`)
- **Surface:** Near Black (`#1F2937`) with glass effects
- **Primary text:** Pure White
- **Secondary text:** Medium Gray

## Motion & Animation

- **Duration:** 200-300ms (standard), 400-500ms (hero/transitions)
- **Easing:** ease-in-out (standard), ease-out (entrance)
- **Page transitions:** Slide up (iOS), fade + scale (Android)
- **Micro-interactions:** Subtle scale on tap (0.97x)

## Accessibility

- Minimum touch target: 44x44px
- Contrast ratio: minimum 4.5:1 for text
- Focus indicators visible on all interactive elements
- Semantic labels for all icons and images
- Support for system font scaling (up to 200%)
