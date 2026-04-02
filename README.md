<div align="center">

# Cosmos Explorer

**An interactive space-themed Flutter Web showcase**

[![License: MIT](https://img.shields.io/badge/License-MIT-blue.svg)](https://opensource.org/licenses/MIT)
[![Flutter](https://img.shields.io/badge/Flutter-%2302569B.svg?logo=Flutter&logoColor=white)](https://flutter.dev/)
[![PRs Welcome](https://img.shields.io/badge/PRs-welcome-brightgreen.svg)](http://makeapullrequest.com)

[**Live Demo (cosmos-explorer.github.io)**](#) • [Report Bug](#) • [Request Feature](#)

</div>

---

## About

Cosmos Explorer is a fully interactive solar system dashboard built entirely with Flutter. It demonstrates the framework's capabilities for creating premium, high-performance web experiences without relying on a single external UI package.

Everything you see—from the twinkling starfields to the glassmorphic cards and animated progress rings—is built using Flutter's core widget system and `CustomPainter`.

### Features

- **Custom Painted Animations:** 
  - Dynamic starfield background with twinkling stars (dark mode) and floating gradient orbs (light mode).
  - Orbital rings and custom animated stat rings (`SweepGradient`).
- **High-Performance Glassmorphism:** 
  - Solid, opaque card backgrounds with animated glow borders for a rich aesthetic without the WebGL performance hit of `BackdropFilter`.
- **Smooth Theming:** 
  - Full Dark/Light theme switching with a custom animated sun/moon toggle switch.
- **Responsive Design:** 
  - Adapts fluidly from ultra-wide desktop monitors to mobile screens.
- **Staggered Animations:** 
  - Entrance animations, hover scale effects, and continuous orbital loops.

## Live Demo

You can try the app right now in your browser:
**[cosmos-explorer.github.io](#)** *(Placeholder link for GitHub Pages)*

## Tech Stack

- **Framework:** [Flutter](https://flutter.dev/) (Web)
- **Language:** [Dart](https://dart.dev/)
- **Typography:** [Google Fonts (Outfit)](https://fonts.google.com/specimen/Outfit)

## Getting Started

### Prerequisites

- [Flutter SDK](https://docs.flutter.dev/get-started/install) (`^3.10.4` or higher)

### Installation

1. Clone the repo:
   ```sh
   git clone https://github.com/your-username/cosmos-explorer.git
   ```
2. Navigate to the directory:
   ```sh
   cd cosmos-explorer
   ```
3. Install dependencies:
   ```sh
   flutter pub get
   ```
4. Run locally on Chrome:
   ```sh
   flutter run -d chrome
   ```

## Architecture

```text
lib/
├── main.dart                    # App entry, theme state, shell with starfield background
├── theme/
│   └── app_theme.dart           # Dark/light ThemeData, gradients, color palette
├── models/
│   └── planet.dart              # Planet data model + full solar system data
├── painters/
│   ├── starfield_painter.dart   # Animated star field & light mode gradient orbs
│   └── ring_chart_painter.dart  # Animated progress rings & orbital paths
├── widgets/
│   ├── glass_card.dart          # Premium card with hover/glow animation
│   ├── planet_card.dart         # Planet list card with entrance animation
│   ├── animated_ring_chart.dart # Animated circular stat display
│   └── theme_toggle.dart        # Day/night animated toggle switch
└── pages/
    ├── home_page.dart           # 3-tab home (Overview, Planets grid, Stats comparisons)
    └── planet_detail_page.dart  # Full planet view with orbital hero & fact cards
```

## Contributing

Contributions are what make the open source community such an amazing place to learn, inspire, and create. Any contributions you make are **greatly appreciated**.

Please read our [Contributing Guidelines](CONTRIBUTING.md) and our [Code of Conduct](CODE_OF_CONDUCT.md) before submitting a Pull Request.

## License

Distributed under the MIT License. See [`LICENSE`](LICENSE) for more information.

---
<div align="center">
  <i>Built with 💙 by <a href="https://cozyportfolio.netlify.app">Cozy Software</a></i>
</div>
