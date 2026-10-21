
/*
 * The style specification's support tables are keyed to MapLibre Native release numbers, and
 * the generator uses them to decide which style properties each platform supports. The MapHero
 * SDKs version independently (Android 1.3.0, iOS 1.3.3) but carry the style support of the
 * MapLibre Native releases below -- the same values the generator read when this package still
 * depended on MapLibre directly -- so these are pinned rather than read from build.gradle or the
 * podspec. Feeding MapHero's own numbers in would mark most properties unsupported.
 */
const MAPLIBRE_ANDROID_BASE = "11.5.0";
const MAPLIBRE_IOS_BASE = "6.5.4";

export const getAndroidVersion = async () => MAPLIBRE_ANDROID_BASE;

export const getIosVersion = async () => MAPLIBRE_IOS_BASE;

export function isVersionGTE(
  version: string,
  otherVersion: string | undefined,
) {
  return (
    !!otherVersion?.match(/^(\d+\.\d+\.\d+)$/) &&
    version.localeCompare(otherVersion, undefined, {
      numeric: true,
      sensitivity: "base",
    }) >= 0
  );
}
