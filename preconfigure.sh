#/bin/bash

set -e

if [ -z "$TILESERVER" ]; then
  TILESERVER="https://mt1.google.com/vt/lyrs=y&x={x}&y={y}&z={z}"
fi

if [ -z "$ATTRIBUTION" ]; then
  ATTRIBUTION="&copy; LVGIS contributors"
fi

echo "using Tile Server: $TILESERVER"
echo "attribution: $ATTRIBUTION"

cat <<HERE >/usr/share/nginx/html/index.html
<!DOCTYPE html>
<html>
<head>
  <title>Leaflet</title>
  <meta charset="utf-8" />
  <meta name="viewport" content="width=device-width, initial-scale=1.0">

  <link rel="stylesheet" href="//cdnjs.cloudflare.com/ajax/libs/leaflet/0.7.3/leaflet.css" />
  <style>
    body {
      padding: 0px;
      margin: 0px;
      height: 100%;
      width: 100%;
    }
    #map {
      width: 100%;
      height: 100%;
    }
  </style>
</head>
<body>
  <div id="map"></div>

  <script src="//cdnjs.cloudflare.com/ajax/libs/leaflet/0.7.3/leaflet.js"></script>
  <script src="//cdnjs.cloudflare.com/ajax/libs/zepto/1.1.4/zepto.min.js"></script>
  <script src="autosize.js"></script>
  <script>
    Autosize.enable();
    var map = L.map('map').setView([36.11, -115.18], 10);

    L.tileLayer('${TILESERVER}', {
      attribution: '${ATTRIBUTION}'
    })
      .addTo(map);

  </script>
</body>
</html>
HERE

nginx -g "daemon off;"
