# iOS Installation

The following assumes that you're using autolinking and installed
`@mapngin/maphero-react-native` via `npm` or `yarn`.

Add the following to your `ios/Podfile`:

```ruby
  post_install do |installer|
    ... other post install hooks
    $MLRN.post_install(installer)
  end
```

Running `pod install` adds version `1.3.3` of the MapHero iOS SDK
(`https://github.com/idealprojects/maphero-ios`) as a Swift package.

```sh
cd ios
pod install
```

## Your API key

Set your publishable MapHero key once, before any map is shown:

```js
import MapHero from '@mapngin/maphero-react-native';

MapHero.setAccessToken('mh_pk_your_publishable_key');
```

That is the whole setup. The SDK sends the key as `X-API-Key` on every request the map makes,
with your app's bundle identifier beside it for keys restricted to named apps. Never ship an
`mh_sk_` secret key in an app.

## Installing a specific version

To pin a different MapHero iOS SDK version, override it in your `Podfile`, above the target:

```ruby
$MLRN_SPM_Spec = {
  url: "https://github.com/idealprojects/maphero-ios",
  requirement: {
    kind: "exactVersion",
    version: "1.3.3"
  },
  product_name: "MapHero"
}
```

Versions before 1.3.3 do not send the key set by `setAccessToken`.
