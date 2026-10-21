import React from "react";
import { NativeModules, requireNativeComponent } from "react-native";

import useAbstractLayer, {
  type BaseLayerProps,
  type NativeBaseProps,
} from "../hooks/useAbstractLayer";
import { type BaseProps } from "../types/BaseProps";
import { type BackgroundLayerStyleProps } from "../utils/MapHeroRNStyles";

const MapHeroRN = NativeModules.MHRNModule;

export const NATIVE_MODULE_NAME = "MLRNBackgroundLayer";

export interface BackgroundLayerProps extends BaseProps, BaseLayerProps {
  /**
   * Customizable style attributes
   */
  style?: BackgroundLayerStyleProps;
}

interface NativeProps
  extends Omit<BackgroundLayerProps, "style">,
    NativeBaseProps {}

const MLRNBackgroundLayer =
  requireNativeComponent<BackgroundLayerProps>(NATIVE_MODULE_NAME);

const BackgroundLayer: React.FC<BackgroundLayerProps> = ({
  sourceID = MapHeroRN.StyleSource.DefaultSourceID,
  ...props
}: BackgroundLayerProps) => {
  const { baseProps, setNativeLayer } = useAbstractLayer<
    BackgroundLayerProps,
    NativeProps
  >({
    ...props,
    sourceID,
  });

  return (
    <MLRNBackgroundLayer
      testID="mlrnBackgroundLayer"
      ref={setNativeLayer}
      {...baseProps}
    />
  );
};

export default BackgroundLayer;
