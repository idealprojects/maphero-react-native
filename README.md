<p align="center">
  <a href="https://developer.maphero.io"><img src="https://developer.maphero.io/assets/maphero-mark.svg" alt="MapHero" height="72"></a>
</p>

# MapHero React Native

[![npm](https://img.shields.io/npm/v/@mapngin/maphero-react-native)](https://www.npmjs.com/package/@mapngin/maphero-react-native)
[![License](https://img.shields.io/badge/License-MIT-blue.svg)](LICENSE.md)

Native MapHero maps for React Native on **Android and iOS**, backed by the MapHero Android and iOS SDKs.
Set your API key once and the SDK authenticates every request the map makes.

- Full guide: **[developer.maphero.io/docs/sdk/react-native](https://developer.maphero.io/docs/sdk/react-native)**
- Search, routing and other MapHero APIs: **[API reference](https://developer.maphero.io/docs/search)**

## Requirements

| | |
|---|---|
| React Native | 0.60 or later |
| Android | 6.0 (API 23) or later — `io.maphero:android-sdk` 1.3.0 |
| iOS | 12 or later — MapHero iOS SDK 1.3.3 (Swift package) |
| Key | A publishable `mh_pk_…` key from the [MapHero Console](https://developer.maphero.io) |

## Installation

```sh
npm install @mapngin/maphero-react-native
```

**iOS** — add the MapHero hook to the `post_install` block of `ios/Podfile`, then run `pod install`:

```ruby
post_install do |installer|
  # … the React Native hooks already here …
  $MLRN.post_install(installer)   # adds the MapHero iOS SDK
end
```

**Android** — nothing further. **Expo** — see [plugin/install.md](/plugin/install.md).

Platform details: [Android](/android/install.md) · [iOS](/ios/install.md) · [Expo](/plugin/install.md)

## Quick start

```jsx
import MapHero, { MapView, Camera, ShapeSource, LineLayer } from '@mapngin/maphero-react-native';

// Once, before any map renders. The SDK sends it as X-API-Key on every request.
MapHero.setAccessToken('mh_pk_your_publishable_key');

export default function App({ route }) {
  return (
    <MapView style={{ flex: 1 }} styleURL="https://regional5e739c.maphero.io/style.json">
      <Camera centerCoordinate={[35.2544, 32.2211]} zoomLevel={12} />
      {route && (
        <ShapeSource id="route" shape={route.geometry}>
          <LineLayer id="route" style={{ lineColor: '#0A5578', lineWidth: 5 }} />
        </ShapeSource>
      )}
    </MapView>
  );
}
```

`styleURL` is your map's published style; the Regional map above covers twelve countries.
`centerCoordinate` is `[longitude, latitude]`. A route for `route` comes from
[`/route/v2/find`](https://developer.maphero.io/docs/routing#route-v2), whose `geometry` is GeoJSON.

> **Publishable keys only.** A key compiled into an app can be extracted from it. Restrict your
> `mh_pk_` key to your package name and bundle id in the Console; never ship an `mh_sk_` key.

## Documentation

- [Getting started](/docs/GettingStarted.md)
- [MapHero module](/docs/MapHero.md) — `setAccessToken`, custom headers, connectivity

### Components

[MapView](/docs/MapView.md) ·
[Camera](/docs/Camera.md) ·
[PointAnnotation](/docs/PointAnnotation.md) ·
[MarkerView](/docs/MarkerView.md) ·
[Callout](/docs/Callout.md) ·
[UserLocation](/docs/UserLocation.md) ·
[Images](/docs/Images.md) ·
[Light](/docs/Light.md) ·
[Style](/docs/Style.md)

### Sources

[VectorSource](/docs/VectorSource.md) ·
[ShapeSource](/docs/ShapeSource.md) ·
[RasterSource](/docs/RasterSource.md) ·
[ImageSource](/docs/ImageSource.md)

### Layers

[BackgroundLayer](/docs/BackgroundLayer.md) ·
[CircleLayer](/docs/CircleLayer.md) ·
[FillExtrusionLayer](/docs/FillExtrusionLayer.md) ·
[FillLayer](/docs/FillLayer.md) ·
[LineLayer](/docs/LineLayer.md) ·
[RasterLayer](/docs/RasterLayer.md) ·
[SymbolLayer](/docs/SymbolLayer.md) ·
[HeatmapLayer](/docs/HeatmapLayer.md)

### More

[Styling layers](/docs/StyleSheet.md) ·
[Annotations compared](/docs/Annotations.md) ·
[Custom HTTP headers](/docs/CustomHttpHeaders.md) ·
[Offline](/docs/offlineManager.md) ·
[Snapshots](/docs/snapshotManager.md) ·
[Logger](/docs/Logger.md)

## Support

Questions and bug reports: [GitHub issues](https://github.com/idealprojects/maphero-react-native/issues).
Product documentation: [developer.maphero.io](https://developer.maphero.io).

## Licence

MIT — see [LICENSE.md](LICENSE.md). MapHero React Native is derived from the open-source
maplibre-react-native project, whose copyright notices are kept in the licence as it requires.
