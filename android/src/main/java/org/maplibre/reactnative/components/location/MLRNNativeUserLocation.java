package org.maplibre.reactnative.components.location;

import android.annotation.SuppressLint;
import android.content.Context;
import androidx.annotation.NonNull;

import org.maphero.android.location.permissions.PermissionsManager;
import org.maphero.android.location.modes.RenderMode;
import org.maphero.android.maps.MapHeroMap;
import org.maphero.android.maps.OnMapReadyCallback;
import org.maphero.android.maps.Style;
import org.maplibre.reactnative.components.AbstractMapFeature;
import org.maplibre.reactnative.components.mapview.MLRNMapView;

public class MLRNNativeUserLocation extends AbstractMapFeature implements OnMapReadyCallback, Style.OnStyleLoaded {
    private boolean mEnabled = true;
    private MapHeroMap mMap;
    private MLRNMapView mMapView;
    private @RenderMode.Mode int mRenderMode = RenderMode.COMPASS;
    private int mPreferredFramesPerSecond;

    public MLRNNativeUserLocation(Context context) {
        super(context);
    }

    @Override
    public void addToMap(MLRNMapView mapView) {
        mEnabled = true;
        mMapView = mapView;
        mapView.getMapAsync(this);
        setRenderMode(mRenderMode);
        setPreferredFramesPerSecond(mPreferredFramesPerSecond);
    }

    @Override
    public void removeFromMap(MLRNMapView mapView) {
        mEnabled = false;
        if (mMap != null) mMap.getStyle(this);
    }

    @SuppressLint("MissingPermission")
    @Override
    public void onMapReady(@NonNull MapHeroMap mapboxMap) {
        mMap = mapboxMap;
        mapboxMap.getStyle(this);
    }

    @SuppressLint("MissingPermission")
    @Override
    public void onStyleLoaded(@NonNull Style style) {
        Context context = getContext();
        if (!PermissionsManager.areLocationPermissionsGranted(context)) {
            return;
        }

        LocationComponentManager locationComponent = mMapView.getLocationComponentManager();
        locationComponent.update(style);
        locationComponent.showUserLocation(mEnabled);
    }

    public void setRenderMode(@RenderMode.Mode int renderMode) {
        mRenderMode = renderMode;
        if (mMapView != null) {
            LocationComponentManager locationComponent = mMapView.getLocationComponentManager();
            locationComponent.setRenderMode(renderMode);
        }
    }

    public void setPreferredFramesPerSecond(int framesPerSecond) {
        mPreferredFramesPerSecond = framesPerSecond;
        if (mMapView != null) {
            LocationComponentManager locationComponent = mMapView.getLocationComponentManager();
            locationComponent.setPreferredFramesPerSecond(framesPerSecond);
        }
    }
}
