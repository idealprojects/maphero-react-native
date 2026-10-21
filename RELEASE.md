# How to release MapHero React Native

## Make sure `main` builds correctly

Are all our [actions](https://github.com/idealprojects/maphero-react-native/actions) passing successfully?  
If not, make sure to investigate the issue and fix it prior to a release.

## Bump the version in our package.json

Once you verified, that `main` isn't broken, go on and increase the `version` within our `package.json`.

## Update the CHANGELOG accordingly

Our [`CHANGELOG.md`](https://github.com/idealprojects/maphero-react-native/blob/main/CHANGELOG.md) should be updated whenever a PR is merged/ noteworthy changes are committed to `main`.  
Prior to a release, the changes should be documented under the `UNRELEASED` section.  
Once it's clear, that a release is about to be published, move the items under `UNRELEASED` to _this_ releases sections.  
Let your actions be guided by the previous release entries.

## Draft a new release on Github

Within the [releases](https://github.com/idealprojects/maphero-react-native/releases) section of the repo you can [`Draft a new release`](https://github.com/idealprojects/maphero-react-native/releases/new).

`Tag version` & `Release title` should be the same.  
As redundant as it might sound, please add the changes from the `CHANGELOG.md` into the body of the release.

## Publish to npm

Publish as the `idealsolutions` npm account (the package maintainer):

```sh
npm login
npm publish --access public
```

If the MapHero iOS or Android SDK version changed, update `maplibre-react-native.podspec` and
`android/build.gradle` first, and check the docs at developer.maphero.io name the same versions.

## Monitor the repo's issues for updates

Once the release is out the door (on [npm](https://www.npmjs.com/package/@mapngin/maphero-react-native)),
make sure to monitor the [issues](https://github.com/idealprojects/maphero-react-native/issues) closely for
problems the community might encounter.
