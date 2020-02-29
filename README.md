# Distributed Mobility Feed Registry (DMFR) <!-- omit in toc -->

<!-- to update use https://marketplace.visualstudio.com/items?itemName=yzhang.markdown-all-in-one -->

- [Latest Updates](#latest-updates)
- [Introduction](#introduction)
- [Goals](#goals)
- [Related Work](#related-work)
- [Basic Examples](#basic-examples)
- [Fields](#fields)
  - [IDs](#ids)
  - [Extended URLs](#extended-urls)
- [Optional Stanzas](#optional-stanzas)
  - [License](#license)
  - [Authentication](#authentication)

## Latest Updates

* **18 November 2019** Transitland v2 is now using DMFR to power the new [Transitland Atlas](https://github.com/transitland/transitland-atlas) repository.


## Introduction

This is an experimental set of guidelines for data publishers providing machine readable lists of their feeds _and_ for data aggregation platforms providing machine readable lists of their feed contents to each other. This project is rooted in publishing and sharing lists of GTFS feeds for fixed-route public-transit networks. It's also applicable to real-time transit, bike-share, e-scooter, and other mobility datasets that take the form of "feeds" published at stable URLs:

- [GTFS](https://gtfs.org/reference/static/)
- [GTFS-Realtime](https://gtfs.org/reference/realtime/v2/)
- [GBFS](https://github.com/NABSA/gbfs/#readme)
- [MDS](https://github.com/CityOfLosAngeles/mobility-data-specification/#readme)

## Goals

1. **Publishers provide their own small registries** To provide data creators (e.g., transit agencies and data vendors) a means of posting a list of their public feeds online. The format should be light-weight (no server required to power an API). The registry should also be machine readable, making it simple for data aggregation platforms to automatically recognize and consume newly added feeds.
2. **Aggregator platforms share their registries** To provide data aggregation platforms (e.g., Transitland, OpenMobilityData, Navitia) a means of sharing their feed registries with each other. Each platform may have a particular focus in terms of functionality provided on top of their feed registries. By distributing feed lists among any and all platforms, open data is shared my widely and the burden of data curation is (hopefully) reduced for each platform.
3. **Related feeds are linked** Different feed types reference each other (e.g., GTFS-realtime references a static GTFS feed, an MDS e-scooter feed references a GBFS bike-share feed). This registry format will provide a light-weight means for data publishers and aggregator platforms to identify these linkages.
4. **Put it into practice and experiment**
  - ~~The more contributors to these guidelines, the better! Let's consider many options and discuss the pros/cons of each of the registry specifics. Let's also be pragmatic. Our goal at Transitland will be to implement this registry format for both incoming feed submissions (to complement the existing Transitland Feed Registry [add a feed](https://transit.land/documentation/feed-registry/add-a-feed.html) process) and outputting lists of known feeds (the Datastore API [feeds endpoint](https://transit.land/documentation/datastore/feeds.html)).~~
  - DMFR now powers the new [Transitland Atlas](https://github.com/transitland/transitland-atlas), which is the source of truth for both Transitland v1 and [Transitland v2](https://transit.land/news/2019/10/17/tlv2.html)'s Feed Registry.

## Related Work

The stands on the shoulders of:

- `linked_datasets.txt` https://github.com/google/transit/pull/93
- GBFS `gbfs.json` https://github.com/NABSA/gbfs/blob/master/gbfs.md#gbfsjson
- Transitland Feed Registry v1 https://github.com/transitland/transitland-feed-registry
- Transitland Feed Registry v2 http://transit.land/feed-registry/
- MDS `providers.csv` https://github.com/CityOfLosAngeles/mobility-data-specification/blob/dev/providers.csv
- GBFS `systems.csv` https://github.com/NABSA/gbfs/blob/master/systems.csv

## Basic Examples

Single static GTFS feed:

```jsonc
{
  "feeds": [
    {
      "spec": "gtfs", // enum: ["gtfs", "gtfs-rt", "gbfs", "mds"]
      "id": "XXXX", // IDs are internally unique, but not necessarily globally unique
      "url": "", // "Transitland style URL" to support nested zip archives
      "urls": { // alternatively if you want to list multiple feed URLs
        "static_current": "",
        "static_historic": [""],
        "static_planned": [""]
      },
      "languages": ["en-US"], // IETF language tags, see https://tools.ietf.org/html/bcp47
      "license": { // license covering the contents of the feed
        "spdx_identifier": "", // see https://spdx.org/licenses/
        "url": "",
        "use_without_attribution": "yes", // enum: ["yes", "no", "unknown"]
        "create_derived_product": "yes", // enum: ["yes", "no", "unknown"]
        "redistribute": "yes", // enum: ["yes", "no", "unknown"]
        "attribution_text": "",
      }
    }
  ],
  "license_spdx_identifier": "CC0-1.0" // license covering the DMFR file itself; see https://spdx.org/licenses/
}
```

Single GTFS-realtime feed:

```jsonc
{
  "feeds": [
    {
      "type": "gtfs-rt", // enum: ["gtfs", "gtfs-rt", "gbfs", "mds"]
      "id": "XXXX", // unique ID for this feed record; may be a Onestop ID or your own ID scheme
      "associated_feeds": [
        // list of associated static GTFS feeds ids
      ], 
      "urls": {
        "realtime_vehicle_positions": "",
        "realtime_trip_updates": "",
        "realtime_alerts": ""
      },
      "languages": ["en-US"], // IETF language tags, see https://tools.ietf.org/html/bcp47
      "license": {
        "spdx_identifier": "", // see https://spdx.org/licenses/
        "url": "",
        "use_without_attribution": "yes", // enum: ["yes", "no", "unknown"]
        "create_derived_product": "yes", // enum: ["yes", "no", "unknown"]
        "redistribute": "yes", // enum: ["yes", "no", "unknown"]
        "attribution_text": "",
      }
    },
    {
      "type": "gtfs", // enum: ["gtfs", "gtfs-rt", "gbfs", "mds"],
      "id": "XXXX", // unique ID for this feed record; may be a Onestop ID or your own ID scheme
      // ...
    }
  ],
  "license_spdx_identifier": "CC0-1.0" // required to meet this spec
}
```

## Fields

### IDs

Feed IDs can be any strings that are unique with a given DMFR file. These feed IDs can be [Onestop IDs](https://transit.land/documentation/onestop-id-scheme/), although that is not required by the DMFR spec. In the [Transitland Atlas](https://github.com/transitland/transitland-atlas) repository, DMFR files are required to use Onestop IDs.

### Extended URLs

For static feeds contained in a zip archive, ideally the feed files are all in the root directory of the archive. However, this is not always the case.

Transitland Feed Registry supports an extended URL format that can reference files nested within a subdirectory. The extended URL format can also reference a zip file nested within another zip file.

```
https://github.com/septadev/GTFS/releases/download/v201810010/gtfs_public.zip#google_bus.zip
```

## Optional Stanzas

### License

Based on [Transitland's approach to handling open data licenses](https://transit.land/an-open-project/) in all their variety.

```jsonc
      "license": {
        "spdx_identifier": "", // see https://spdx.org/licenses/
        "url": "",
        "use_without_attribution": "yes", // enum: ["yes", "no", "unknown"]
        "create_derived_product": "yes", // enum: ["yes", "no", "unknown"]
        "redistribute": "yes", // enum: ["yes", "no", "unknown"]
        "attribution_text": "",
      }
```

### Authentication

Requiring authentication for public data feeds is typically not a good idea. However, it's reasonable to require an API key for a GTFS-realtime endpoints and other feeds that involve active queries.

```jsonc
    "authorization": {
      "type": "", // enum: ["header", "basic_auth", "query_param"]
      "param_name": "",
      "info_url": ""
    }
```