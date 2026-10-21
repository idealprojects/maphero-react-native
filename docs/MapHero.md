## MapHero

The default export of `@mapngin/maphero-react-native`:

```js
import MapHero from '@mapngin/maphero-react-native';
```

### methods
#### setAccessToken(accessToken)

##### arguments
| Name | Type | Required | Description  |
| ---- | :--: | :------: | :----------: |
| `accessToken` | `String` | `Yes` | Your publishable MapHero API key (`mh_pk_…`). |

##### Description
Sets the API key for every map in the app. Call it once, before any map renders. The native SDK
sends it as `X-API-Key` on every request the map makes, with your app's package name (Android) or
bundle id (iOS) beside it, for keys restricted to named apps.

#### getAccessToken()

##### Description
Returns a promise of the key set with `setAccessToken`.


#### addCustomHeader(headerName, headerValue)

##### arguments
| Name | Type | Required | Description  |
| ---- | :--: | :------: | :----------: |
| `headerName` | `String` | `Yes` | name for customHeader |
| `headerValue` | `String` | `Yes` | value for customHeader |

##### Description
Adds a header to every map request. Not needed for authentication — `setAccessToken` covers that.
Also see [CustomHttpHeaders](/docs/CustomHttpHeaders.md).


#### removeCustomHeader(headerName)

##### arguments
| Name | Type | Required | Description  |
| ---- | :--: | :------: | :----------: |
| `headerName` | `String` | `Yes` | name of customHeader to be removed |

##### Description
also see [CustomHttpHeaders](/docs/CustomHttpHeaders.md)


### Android only
#### requestAndroidLocationPermissions()
##### Description
Opens Android Location Permission prompt.
Returns a Promise which resolves into a boolean.
Either permission was granted or denied.


#### setConnected(connected)
##### arguments
| Name | Type | Required | Description  |
| ---- | :--: | :------: | :----------: |
| `connected` | `Boolean` | `Yes` | whether or not the SDK should assume it is online |

#### Description
If you want to fully block map tile requests over the network, such as for a low-data / offline application.
