# Expo Installation

NOTE: This package cannot be used in the "Expo Go" app because [it requires custom native code](https://docs.expo.io/workflow/customizing/).

First install the package with `yarn`, `npm`, or [`expo install`](https://docs.expo.io/workflow/expo-cli/#expo-install).

```sh
expo install @mapngin/maphero-react-native
```

After installing this npm package, add the [config plugin](https://docs.expo.io/guides/config-plugins/) to the [`plugins`](https://docs.expo.io/versions/latest/config/app/#plugins) array of your `app.json` or `app.config.js`:

```json
{
  "expo": {
    "plugins": ["@mapngin/maphero-react-native"]
  }
}
```

Next, rebuild your app as described in the ["Adding custom native code"](https://docs.expo.io/workflow/customizing/) guide.

## API

This plugin doesn't currently provide any additional properties for customization. The plugin adds the MapHero install hooks to the generated `ios/Podfile`, which bring in the MapHero iOS SDK. No additional changes are made on Android. Set your key with `MapHero.setAccessToken(...)` as on any other app.
