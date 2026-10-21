import { type SyntheticEvent } from "react";

export type MapHeroRNEvent<
  T extends string,
  P = GeoJSON.Feature,
  V = Element,
> = SyntheticEvent<V, { type: T; payload: P }>;
