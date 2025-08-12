# Changelog

## v0.6.0

- Remove top-level `license_spdx_identifier`. This has confused editors, who think it may refer to an individual feed's license, while the point was to refer to the license attached to the DMFR file itself. Instead, we'll let each repo with DMFR files set its own separate license file.
- Minor fixes to property descriptions

## v0.5.1

- Feed URLs are now validated more permissively, to allow a wider range of alphabetic characters from non-English languages.

## v0.5.0

- A feed record can now have an optional `name` and `description` fields to provide additional context to DMFR editors and users of software that consume DMFR files.
- When specifying an SPDX identifier for a feed license or DMFR license, the value will now be validated against a list of SPDX short-form identifiers. Sourced from https://github.com/spdx/license-list-data

## v0.4.1

DMFR v0.4.1 adds a new "replace_url" option for authorization secrets. This allows a private url to be used to fetch the data.

## v0.4.0

**Breaking change**: We've removed `feed_namespace_id`, `associated_feeds`, and `other_ids`. If you want to group together feeds in a single DMFR, use `operator` records. If you want to reference feeds in another DMFR or outside source by providing external IDs, use `tags`.

### Operators

Operators are used to group together one or more feed record and to provide additional contextual information. Operators can be defined as top-level entities or nested under feeds. In both cases, operators can only be used to group feeds defined in a single DMFR file; an operator cannot be defined in one DMFR file and referenced in another DMFR file.

Defining an operator as a top-level entity is useful in a case like New York MTA that has many feeds grouped under a single operator. Here is an example (with extraneous details removed):

```json
{
  "feeds": [
    {
      "spec": "gtfs",
      "id": "f-dr5r-nyctsubway"
    },
    {
      "spec": "gtfs",
      "id": "f-dr5r-mtanyctbusbrooklyn"
    },
    {
      "spec": "gtfs-rt",
      "id": "f-dr5-mtanyclirr~rt"
    }
  ],
  "operators": [
    {
      "onestop_id": "o-dr5r-nyct",
      "tags": {
        "us_ntd_id": "20008",
        "us_ntd_id2": "20188",
        "wikidata_id": "Q1146109",
        "twitter_general": "mta",
        "twitter_service_alerts": "NYCTSubway"
      },
      "name": "MTA New York City Transit",
      "short_name": "MTA",
      "associated_feeds": [
        {
          "feed_onestop_id": "f-dr5r-nyctsubway"
        },
        {
          "feed_onestop_id": "f-dr5r-mtanyctbusbrooklyn"
        },
        {
          "feed_onestop_id": "f-dr5r-mtanyclirr~rt"
        }
      ]
    }
  ]
}
```

### Other additions

Feeds and operators can now have `tags`, an object that can have any number of keys, with all values as strings. We've long supported a flexible tagging structure in Transitland; now the source-of-truth for this information is also in the DMFR files in Transitland Atlas. Other DMFR tooling may also use `tags` for free-form and experimental functionality.

Feeds and operators may have an array of strings called `supersedes_ids` that lists any IDs for outdated records that have been replaced by or merged into the current record. Transitland Atlas uses stores list of old Onestop IDs to capture the lineage of records over time and provide look-up by Onestop IDs that are no longer active.

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
