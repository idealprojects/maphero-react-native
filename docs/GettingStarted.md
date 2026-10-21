# Getting started

From an empty React Native app to a MapHero map, on Android and iOS.

## Prerequisites

1. Android 6.0 (API 23) or later; iOS 12 or later.
2. A publishable MapHero API key (`mh_pk_…`) from the [MapHero Console](https://developer.maphero.io).
3. [Node.js](https://nodejs.org) and a React Native project (0.60 or later). To create one:

```shell
npx @react-native-community/cli init MyApp
```

## Install

```shell
npm install @mapngin/maphero-react-native
# or
yarn add @mapngin/maphero-react-native
```

Then follow the platform notes: [Android](/android/install.md) · [iOS](/ios/install.md) ·
[Expo](/plugin/install.md). On iOS that is one line in your Podfile and `pod install`.

## Add a map

```jsx
import React from 'react';
import { StyleSheet, View } from 'react-native';
import MapHero, { MapView, Camera } from '@mapngin/maphero-react-native';

// Your publishable key, set once before any map renders.
MapHero.setAccessToken('mh_pk_your_publishable_key');

export default function App() {
  return (
    <View style={styles.page}>
      <MapView style={styles.map} styleURL="https://regional5e739c.maphero.io/style.json">
        <Camera centerCoordinate={[35.2544, 32.2211]} zoomLevel={12} />
      </MapView>
    </View>
  );
}

const styles = StyleSheet.create({
  page: { flex: 1 },
  map: { flex: 1 },
});
```

`styleURL` is your map's published style URL; the one above is the Regional map. Set the starting
view with a `Camera` — `centerCoordinate` is `[longitude, latitude]`.

## Run it

```shell
npm run ios
npm run android
```

## Next

- Draw routes, search results and markers: [developer.maphero.io/docs/sdk/react-native](https://developer.maphero.io/docs/sdk/react-native)
- The MapHero APIs (search, routing, optimization): [API reference](https://developer.maphero.io/docs/search)
