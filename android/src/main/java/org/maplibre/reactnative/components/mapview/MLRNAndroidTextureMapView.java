package org.maplibre.reactnative.components.mapview;

import android.content.Context;
import org.maphero.android.maps.MapHeroMapOptions;

@SuppressWarnings({"MissingPermission"})
public class MLRNAndroidTextureMapView extends MLRNMapView {
	public static final String LOG_TAG = "MLRNAndroidTextureMapView";

    public MLRNAndroidTextureMapView(Context context, MLRNAndroidTextureMapViewManager manager, MapHeroMapOptions options) {
        super(context, manager, options);
    }
}
