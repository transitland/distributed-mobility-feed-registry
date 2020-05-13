# Changelog

## v0.3.0

When `spec=gbfs`, only one type of URL is now needed or allowed: `gbfs_auto_discovery`.

We made this decision because all of the GBFS feeds listed in [`systems.csv`](https://github.com/NABSA/gbfs/blob/v2.0/systems.csv) supply an auto-discovery URL. Also [GBFS v2.0](https://github.com/NABSA/gbfs/releases/tag/v2.0) requires the auto-discovery JSON file. 

## v0.2.0

**Breaking change**: We've removed support to specify a static GTFS feed URL using `feed.url`. Now the one option is to specify this using `feed.urls.static_current`. This change will slightly simplifying tooling that validates or consumes DMFR. 

Here's an old example from Transitland Atlas:

```json
{
  "$schema": "https://dmfr.transit.land/json-schema/dmfr.schema-v0.1.2.json",
  "feeds": [
    {
      "spec": "gtfs",
      "id": "f-tulare~time",
      "url": "http://www.tularecog.org/googletransit/TIME/google_transit.zip"
    },
    {
      "spec": "gtfs",
      "id": "f-tulare~tcat",
      "url": "http://www.tularecog.org/googletransit/TCAT/google_transit.zip"
    },
    {
      "spec": "gtfs",
      "id": "f-tulare~dart",
      "url": "http://www.tularecog.org/googletransit/DART/google_transit.zip"
    }
  ],
  "license_spdx_identifier": "CDLA-Permissive-1.0"
}
```

And here's the same example updated for DMFR v0.2.0:

```json
{
  "$schema": "https://dmfr.transit.land/json-schema/dmfr.schema-v0.2.0.json",
  "feeds": [
    {
      "spec": "gtfs",
      "id": "f-tulare~time",
      "urls": {
        "static_current": "http://www.tularecog.org/googletransit/TIME/google_transit.zip"
      }
    },
    {
      "spec": "gtfs",
      "id": "f-tulare~tcat",
      "urls": {
        "static_current": "http://www.tularecog.org/googletransit/TCAT/google_transit.zip"
      }
    },
    {
      "spec": "gtfs",
      "id": "f-tulare~dart",
      "urls": {
        "static_current": "http://www.tularecog.org/googletransit/DART/google_transit.zip"
      }
    }
  ],
  "license_spdx_identifier": "CDLA-Permissive-1.0"
}
```
