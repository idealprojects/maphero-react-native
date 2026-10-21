package org.maplibre.reactnative.components.mapview;

import com.facebook.react.bridge.ReactApplicationContext;
import org.maphero.android.maps.MapHeroMapOptions;
import com.facebook.react.uimanager.ThemedReactContext;
import com.facebook.react.uimanager.annotations.ReactProp;

public class MLRNAndroidTextureMapViewManager extends MLRNMapViewManager {
    public static final String LOG_TAG = "MLRNAndroidTextureMapViewManager";
    public static final String REACT_CLASS = "MLRNAndroidTextureMapView";

    public MLRNAndroidTextureMapViewManager(ReactApplicationContext context) {
        super(context);
    }

    @Override
    public String getName() {
        return REACT_CLASS;
    }

    @Override
    protected MLRNAndroidTextureMapView createViewInstance(ThemedReactContext themedReactContext) {
        MapHeroMapOptions options = new MapHeroMapOptions();
        options.textureMode(true);
        return new MLRNAndroidTextureMapView(themedReactContext, this, options);
    }
}
