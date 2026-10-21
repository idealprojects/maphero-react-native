# Vendored MapLibre plugins

`annotation`, `markerview` and `localization` are the sources of MapLibre's
`android-plugin-{annotation,markerview,localization}-v9` 3.0.1 (BSD-2-Clause, see each file's
header), compiled here against the MapHero Android SDK instead of upstream MapLibre.

The published artifacts take `org.maplibre.android.*` types (`MapView`, `MapLibreMap`, `LatLng`, ...),
which the MapHero SDK provides as `org.maphero.android.*`. Linking them against MapHero did not
compile, so this package also pulled in a second, upstream MapLibre SDK to satisfy them. Here the
SDK imports are retargeted (`org.maplibre.android.{maps,geometry,style,camera,utils,log,constants}`
-> `org.maphero.android.*`, `MapLibreMap` -> `MapHeroMap`) and nothing else is changed. The plugin
packages keep their original names so the code that uses them is unchanged.

One API difference needed a change: `SymbolManager.getIconPadding()` returns `Float[]`, because
`icon-padding` is per side in the MapHero style spec.
