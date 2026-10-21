package org.maplibre.android.plugins.annotation;

import androidx.annotation.Nullable;
import org.maphero.android.style.layers.Layer;
import org.maphero.android.style.sources.GeoJsonOptions;
import org.maphero.android.style.sources.GeoJsonSource;

interface CoreElementProvider<L extends Layer> {

    String getLayerId();

    String getSourceId();

    L getLayer();

    GeoJsonSource getSource(@Nullable GeoJsonOptions geoJsonOptions);
}
