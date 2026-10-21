# Android installation

Nothing beyond `npm install`: autolinking adds the module, and the MapHero Android SDK
(`io.maphero:android-sdk`, on Maven Central) comes with it. Requires Android 6.0 (API 23) or later.

## Your API key

Set your publishable MapHero key once, before any map renders — for example at the top of `App.js`:

```javascript
import MapHero from "@mapngin/maphero-react-native";

MapHero.setAccessToken("mh_pk_your_publishable_key");
```

On Android a `MapView` cannot be created before this call. The SDK then sends the key as
`X-API-Key` on every map request, with `X-MapHero-Android-Package` and `X-MapHero-Android-Cert`
(your signing certificate's SHA-256) beside it. Restrict the key to that package and certificate
in the MapHero Console.

## Setting connection status

If you host styles or sources on localhost, you may need to set the connection status manually.
Set `true` for connected, `false` for disconnected, and `null` for the system's normal behaviour:

```js
import MapHero from "@mapngin/maphero-react-native";

MapHero.setConnected(true);
```
