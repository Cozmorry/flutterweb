import 'package:flutter/material.dart';

class Planet {
  final String name;
  final String subtitle;
  final String description;
  final String emoji;
  final Color primaryColor;
  final Color secondaryColor;
  final double distanceFromSun; // AU
  final double diameter; // km
  final double orbitalPeriod; // Earth years
  final double gravity; // m/s²
  final int moons;
  final double temperature; // °C average
  final List<String> facts;

  const Planet({
    required this.name,
    required this.subtitle,
    required this.description,
    required this.emoji,
    required this.primaryColor,
    required this.secondaryColor,
    required this.distanceFromSun,
    required this.diameter,
    required this.orbitalPeriod,
    required this.gravity,
    required this.moons,
    required this.temperature,
    required this.facts,
  });
}

final List<Planet> solarSystemPlanets = [
  Planet(
    name: 'Mercury',
    subtitle: 'The Swift Planet',
    description:
        'Mercury is the smallest planet in our solar system and closest to the Sun. Despite its proximity, it\'s not the hottest planet — that title goes to Venus.',
    emoji: '☿',
    primaryColor: const Color(0xFFB0B0B0),
    secondaryColor: const Color(0xFF8C8C8C),
    distanceFromSun: 0.39,
    diameter: 4879,
    orbitalPeriod: 0.24,
    gravity: 3.7,
    moons: 0,
    temperature: 167,
    facts: [
      'A year on Mercury is just 88 Earth days',
      'Mercury has no atmosphere to retain heat',
      'It has the most eccentric orbit of all planets',
      'Temperatures swing from -180°C to 430°C',
    ],
  ),
  Planet(
    name: 'Venus',
    subtitle: 'Earth\'s Twin',
    description:
        'Venus is the hottest planet in our solar system. Its thick atmosphere traps heat in a runaway greenhouse effect, making its surface hot enough to melt lead.',
    emoji: '♀',
    primaryColor: const Color(0xFFF59E0B),
    secondaryColor: const Color(0xFFD97706),
    distanceFromSun: 0.72,
    diameter: 12104,
    orbitalPeriod: 0.62,
    gravity: 8.87,
    moons: 0,
    temperature: 464,
    facts: [
      'Venus spins backwards on its axis',
      'A day on Venus is longer than its year',
      'Surface pressure is 90x Earth\'s',
      'It rains sulfuric acid in Venus\' clouds',
    ],
  ),
  Planet(
    name: 'Earth',
    subtitle: 'The Blue Marble',
    description:
        'Our home planet is the only place we know of so far that\'s inhabited by living things. It\'s also the only planet with liquid water on its surface.',
    emoji: '🌍',
    primaryColor: const Color(0xFF3B82F6),
    secondaryColor: const Color(0xFF10B981),
    distanceFromSun: 1.0,
    diameter: 12756,
    orbitalPeriod: 1.0,
    gravity: 9.81,
    moons: 1,
    temperature: 15,
    facts: [
      'Earth is the densest planet in the solar system',
      '70% of the surface is covered in water',
      'Earth\'s magnetic field protects us from solar wind',
      'The atmosphere is 78% nitrogen and 21% oxygen',
    ],
  ),
  Planet(
    name: 'Mars',
    subtitle: 'The Red Planet',
    description:
        'Mars is a dusty, cold, desert world with a very thin atmosphere. It\'s the most explored body in our solar system besides Earth.',
    emoji: '♂',
    primaryColor: const Color(0xFFEF4444),
    secondaryColor: const Color(0xFFDC2626),
    distanceFromSun: 1.52,
    diameter: 6792,
    orbitalPeriod: 1.88,
    gravity: 3.72,
    moons: 2,
    temperature: -65,
    facts: [
      'Mars has the tallest volcano — Olympus Mons at 21.9km',
      'A Martian day is 24 hours and 37 minutes',
      'Mars has seasons similar to Earth',
      'Its red color comes from iron oxide (rust)',
    ],
  ),
  Planet(
    name: 'Jupiter',
    subtitle: 'The Gas Giant',
    description:
        'Jupiter is the largest planet in our solar system. Its iconic Great Red Spot is a storm larger than Earth that has been raging for hundreds of years.',
    emoji: '♃',
    primaryColor: const Color(0xFFF59E0B),
    secondaryColor: const Color(0xFFB45309),
    distanceFromSun: 5.2,
    diameter: 142984,
    orbitalPeriod: 11.86,
    gravity: 24.79,
    moons: 95,
    temperature: -110,
    facts: [
      'Jupiter\'s Great Red Spot could fit 2-3 Earths',
      'It has the shortest day of any planet (10 hours)',
      'Jupiter\'s magnetic field is 20,000x Earth\'s',
      'It acts as a cosmic vacuum cleaner for asteroids',
    ],
  ),
  Planet(
    name: 'Saturn',
    subtitle: 'The Ringed Beauty',
    description:
        'Saturn is the sixth planet from the Sun and the most distant that can be seen with the naked eye. Its ring system is the most extensive and complex in the solar system.',
    emoji: '♄',
    primaryColor: const Color(0xFFD4A574),
    secondaryColor: const Color(0xFFA0785A),
    distanceFromSun: 9.54,
    diameter: 120536,
    orbitalPeriod: 29.46,
    gravity: 10.44,
    moons: 146,
    temperature: -140,
    facts: [
      'Saturn\'s rings are mostly ice and rock',
      'It\'s the least dense planet — it would float on water',
      'Winds can reach up to 1,800 km/h',
      'Its moon Titan has a thick atmosphere and lakes',
    ],
  ),
  Planet(
    name: 'Uranus',
    subtitle: 'The Ice Giant',
    description:
        'Uranus is the seventh planet from the Sun. It rotates on its side, making it unique among the planets. Its blue-green color comes from methane in its atmosphere.',
    emoji: '⛢',
    primaryColor: const Color(0xFF22D3EE),
    secondaryColor: const Color(0xFF0891B2),
    distanceFromSun: 19.2,
    diameter: 51118,
    orbitalPeriod: 84.01,
    gravity: 8.87,
    moons: 28,
    temperature: -195,
    facts: [
      'Uranus rotates on its side at 98° tilt',
      'It was the first planet found with a telescope',
      'A year on Uranus is 84 Earth years',
      'It has 13 known rings',
    ],
  ),
  Planet(
    name: 'Neptune',
    subtitle: 'The Windy Planet',
    description:
        'Neptune is the most distant planet from the Sun. It has the strongest winds in the solar system, reaching speeds of over 2,000 km/h.',
    emoji: '♆',
    primaryColor: const Color(0xFF6366F1),
    secondaryColor: const Color(0xFF4F46E5),
    distanceFromSun: 30.06,
    diameter: 49528,
    orbitalPeriod: 164.8,
    gravity: 11.15,
    moons: 16,
    temperature: -200,
    facts: [
      'Neptune has the strongest winds — over 2,000 km/h',
      'A year on Neptune is 165 Earth years',
      'It was predicted mathematically before being observed',
      'Its moon Triton orbits in the opposite direction',
    ],
  ),
];
