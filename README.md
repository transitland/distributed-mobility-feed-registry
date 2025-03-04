# Distributed Mobility Feed Registry (DMFR) <!-- omit in toc -->

<!-- to update use https://marketplace.visualstudio.com/items?itemName=yzhang.markdown-all-in-one -->

- [Introduction](#introduction)
- [Goals](#goals)
- [Related Work](#related-work)
- [Basic Examples](#basic-examples)
- [Fields](#fields)
  - [IDs](#ids)
  - [Feed specs and URLs](#feed-specs-and-urls)
  - [Extended URLs](#extended-urls)
- [Optional Stanzas and Tags](#optional-stanzas-and-tags)
  - [License](#license)
  - [Authentication](#authentication)
  - [Tags](#tags)
  - [Languages](#languages)
  - [Superceding lineage](#superceding-lineage)

## Introduction

This is a set of guidelines for data publishers providing machine readable lists of their feeds _and_ for data aggregation platforms providing machine readable lists of their feed contents to each other. This project is rooted in publishing and sharing lists of GTFS feeds for fixed-route public-transit networks. It's also applicable to real-time transit, bike-share, e-scooter, and other mobility datasets that take the form of "feeds" published at stable URLs:

- [GTFS](https://gtfs.org/reference/static/)
- [GTFS Realtime](https://gtfs.org/documentation/realtime/reference/)
- [GBFS](https://github.com/MobilityData/gbfs#readme)
- [MDS](https://github.com/CityOfLosAngeles/mobility-data-specification/#readme)

## Goals

1. **Publishers provide their own small registries** To provide data creators (e.g., transit agencies and data vendors) a means of posting a list of their public feeds online. The format should be light-weight (no server required to power an API). The registry should also be machine readable, making it simple for data aggregation platforms to automatically recognize and consume newly added feeds.
2. **Aggregator platforms share their registries** To provide data aggregation platforms (e.g., Transitland, OpenMobilityData, Navitia) a means of sharing their feed registries with each other. Each platform may have a particular focus in terms of functionality provided on top of their feed registries. By distributing feed lists among any and all platforms, open data is shared my widely and the burden of data curation is (hopefully) reduced for each platform.
3. **Related feeds are linked** Different feed types reference each other (e.g., GTFS Realtime references a static GTFS feed, an MDS e-scooter feed references a GBFS bike-share feed). This registry format will provide a light-weight means for data publishers and aggregator platforms to identify these linkages.
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
- GBFS `systems.csv` https://github.com/mobilitydata/gbfs/blob/master/systems.csv

## Basic Examples

Single static GTFS feed:

```jsonc
{
  "$schema": "https://dmfr.transit.land/json-schema/dmfr.schema-v0.5.1.json",
  "feeds": [
    {
      "spec": "gtfs", // enum: ["gtfs", "gtfs-rt", "gbfs", "mds"]
      "id": "example", // ID must be unique across all of your DMFR files; in the Transitland Atlas repo, this is a feed Onestop ID
      "urls": { 
        "static_current": "http://example.com/gtfs.zip" // URL for the current version of the feed
      }
    }
  ],
  "license_spdx_identifier": "CDLA-Permissive-1.0" // license covering the DMFR file itself, not the feed contents
}
```

Single GTFS Realtime feed:

```jsonc
{
  "$schema": "https://dmfr.transit.land/json-schema/dmfr.schema-v0.5.1.json",
  "feeds": [
    {
      "spec": "gtfs-rt", // enum: ["gtfs", "gtfs-rt", "gbfs", "mds"]
      "id": "XXXX", // unique ID for this feed record; in the Transitland Atlas repo, this is a feed Onestop ID often ending in ~rt
      "urls": {
        "realtime_vehicle_positions": "",
        "realtime_trip_updates": "",
        "realtime_alerts": ""
      }
    }
  ],
  "license_spdx_identifier": "CDLA-Permissive-1.0" // required to meet this spec
}
```

Group together multiple feeds using an operator:

```jsonc
{
  "$schema": "https://dmfr.transit.land/json-schema/dmfr.schema-v0.5.1.json",
  "feeds": [
    {
      "spec": "gtfs",
      "id": "f-9q9-bart",
      "urls": {
        "static_current": "http://www.bart.gov/dev/schedules/google_transit.zip"
      }
    },
    {
      "spec": "gtfs-rt",
      "id": "f-bart~rt",
      "urls": {
        "realtime_alerts": "http://api.bart.gov/gtfsrt/alerts.aspx",
        "realtime_trip_updates": "http://api.bart.gov/gtfsrt/tripupdate.aspx"
      }
    }
  ],
  "operators": [
    {
      "onestop_id": "o-9q9-bart",
      "supersedes_ids": ["o-9q9-bart~old"],
      "name": "Bay Area Rapid Transit",
      "short_name": "BART",
      "website": "https://www.bart.gov",
      "tags": {
        "us_ntd_id": "90003",
        "omd_provider_id": "bart",
        "wikidata_id": "Q610120",
        "twitter_general": "sfbart",
        "twitter_service_alerts": "SFBARTalert"
      },
      "associated_feeds": [
        {
          "feed_onestop_id": "f-bart~rt"
        },
        {
          "feed_onestop_id": "f-9q9-bart",
          "gtfs_agency_id": "BART"
        }
      ]
    }
  ],
  "license_spdx_identifier": "CDLA-Permissive-1.0"
}
```

Alternatively, operators can be nested within feeds when there is a one-to-one relationship between a feed and an operator:

```jsonc
{
  "$schema": "https://dmfr.transit.land/json-schema/dmfr.schema-v0.5.1.json",
  "feeds": [
    {
      "id": "f-west~virginia~university",
      "spec": "gtfs",
      "urls": {
        "static_current": "https://prt.wvu.edu/files/d/fcc4abeb-9e23-477b-b648-30623cb8ad80/gtfs-3.zip"

      },
      "operators": [
        {
          "onestop_id": "o-dpp1s-wvuprt",
          "name": "West Virginia University Morgantown Personal Rapid Transit",
          "short_name": "WVU PRT",
          "website": "http://transportation.wvu.edu/"
        }
      ]
    }
  ],
  "license_spdx_identifier": "CDLA-Permissive-1.0"
}
```

The root-level `operators` array is typically used when:
- An operator has three or more feeds
- You want to organize feeds across multiple files

The nested `operators` array within a feed is typically used when:
- There is a one-to-one relationship between a feed and an operator
- You want to keep the feed and operator information together for simplicity

Note: The `name` field is required for operators, while `short_name` and `website` are optional.

## Fields

### IDs

Feed IDs can be any strings that are unique with a given DMFR file. These feed IDs can be [Onestop IDs](https://transit.land/documentation/onestop-id-scheme/), although that is not required by the DMFR spec.

In the [Transitland Atlas](https://github.com/transitland/transitland-atlas) repository, DMFR files are required to use Onestop IDs.

### Feed specs and URLs

Each feed must specify a `spec` field that indicates the type of data contained in the feed. The following specs are supported, along with the following urls:

- `gtfs`: Static GTFS feed containing schedule data
  - `static_current`: URL for the current version of the feed
  - `static_historic`: Array of URLs for previous versions of the feed
  - `static_planned`: Array of URLs for future service changes
  - `static_hypothetical`: Array of URLs for potential future scenarios

- `gtfs-rt`: GTFS Realtime feed containing real-time updates
  - `realtime_vehicle_positions`: URL for real-time vehicle position updates
  - `realtime_trip_updates`: URL for real-time trip updates
  - `realtime_alerts`: URL for real-time service alerts

- `gbfs`: GBFS (General Bikeshare Feed Specification) feed
  - `gbfs_auto_discovery`: URL for GBFS auto-discovery file that links to all other GBFS files

- `mds`: MDS (Mobility Data Specification) feed
  - `mds_provider`: URL for MDS provider API endpoints

### Extended URLs

For static feeds contained in a zip archive, ideally the feed files are all in the root directory of the archive. However, this is not always the case.

[transitland-lib](https://github.com/interline-io/transitland-lib) supports an extended URL format that can reference files nested within a subdirectory. The extended URL format can also reference a zip file nested within another zip file.

Example of nested zip file reference:
```
https://github.com/septadev/GTFS/releases/download/v201810010/gtfs_public.zip#google_bus.zip
```

## Optional Stanzas and Tags

### License

Based on [Transitland's approach to handling open data licenses](https://transitland/an-open-project/) in all their variety.

```jsonc
      "license": {
        "spdx_identifier": "", // see https://spdx.org/licenses/
        "url": "",
        "use_without_attribution": "yes", // enum: ["yes", "no", "unknown"]
        "create_derived_product": "yes", // enum: ["yes", "no", "unknown"]
        "redistribution_allowed": "yes", // enum: ["yes", "no", "unknown"]
        "commercial_use_allowed": "yes", // enum: ["yes", "no", "unknown"]
        "share_alike_optional": "yes", // enum: ["yes", "no", "unknown"]
        "attribution_text": "", // if license requires that data consumers display specific text
        "attribution_instructions": "" // if license provides specific guidance to how data consumers should provide attribution
      }
```

### Authentication

Requiring authentication for public data feeds is typically not a good idea. However, it's reasonable to require an API key for a GTFS Realtime endpoints and other feeds that involve active queries.

```jsonc
    "authorization": {
      "type": "", // enum: ["header", "basic_auth", "query_param", "path_segment", "replace_url"]
      "param_name": "", // When type=query_param, this specifies the name of the query parameter
      "info_url": "" // Website to visit to sign up for an account
    }
```

The following authentication types are supported:

- `header`: API key or token is sent in an HTTP header
- `basic_auth`: Username and password are sent using HTTP Basic Authentication
- `query_param`: API key or token is sent as a URL query parameter
- `path_segment`: API key or token is included as a segment in the URL path. Indicate where the key/token should be injected using `{}`
- `replace_url`: The entire URL should be replaced with a different URL that includes authentication

Auth credentials are not stored in a DMFR file. It's up to each software package that reads the DMFR format to implement its own way of reading auth credentials from a separate file or from environment variables and using them when fetching each feed.

### Tags

Tags allow extra information to be added to feeds and operators. Keys and values must both be strings.

```jsonc
  "feeds": [
    {
      "spec": "gtfs",
      "id": "f-example~feed",
      "urls": {
        "static_current": "http://example.com/gtfs_2025_02_01.zip"
      },
      "tags": {
        "unstable_url": "true" // note the quotes around true to specify a string value
      }
    }
  ],
  "operators": [
    {
      "onestop_id": "o-9q9-bart",
      "tags": {
        "us_ntd_id": "90003", // an identifier from the US National Transit Database
        "omd_provider_id": "bart", // an identifier from OpenMobilityData.org
        "wikidata_id": "Q610120", // an identifier from Wikidata
        "twitter_general": "sfbart", // a Twitter handle
        "twitter_service_alerts": "SFBARTalert" // a Twitter handle
      }
    }
  ]
```

### Languages

The `languages` field is an optional array of IETF language tags that specify the languages used in the feed. This is particularly useful for feeds that contain multilingual content.

```jsonc
{
  "languages": ["en-US", "es-MX"], // IETF language tags, see https://tools.ietf.org/html/bcp47
  // ...
}
```

### Superceding lineage

The `supersedes_ids` field is an optional way to indicate when a feed or operator record replaces previous ones. This is useful when:
- An operator changes their name or organizational structure
- Multiple feeds or operators are merged into a single record

Alternatively, when a static GTFS feed is substantially the same but published at a different URL, its old URL(s) may be retained under `urls.static_historic`.

Example for a feed:
```jsonc
{
  "id": "f-example~feed",
  "supersedes_ids": ["f-example~feed~old"],
  "spec": "gtfs",
  // ...
}
```

Example for an operator:
```jsonc
{
  "onestop_id": "o-9q9-bart",
  "supersedes_ids": ["o-9q9-bart~old"],
  "name": "Bay Area Rapid Transit",
  // ...
}
```


