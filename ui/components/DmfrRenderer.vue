<template>
  <section class="section">
    <div class="field">
      <label class="label">Load DMFR file from URL</label>
      <div class="control">
        <input v-model="url" class="input" v-bind:class="{ 'is-danger' : error}" type="text">
      </div>
    </div>
    <div v-if="error" class="notification is-warning">Error fetching DMFR file: {{error}}</div>
    <hr>
    <div class="card" v-for="feed in parsedFeeds" v-bind:key="feed.id">
      <header class="card-header">
        <p class="card-header-title">{{feed.id}}</p>
        <p class="card-header-icon">
          <span class="tag">{{feed.type}}</span>
        </p>
      </header>
      <div class="card-content">
        <div class="content">
          <dl>
            <dt><code>url</code></dt>
            <dt>{{feed.url}}</dt>
                        <dt><code>feed_namespace_id</code></dt>
            <dt>{{feed.feed_namespace_id}}</dt>
          </dl>
          <ul v-if="feed.other_ids">
            <li v-if="feed.other_ids.transitland"><a :href="`https://transit.land/dispatcher/feeds/${feed.other_ids.transitland}`" target="_blank">Feed in Transitland Dispatcher</a></li>
            <li v-if="feed.other_ids.transitland"><a :href="`http://transitfeeds.com/p/${feed.other_ids.openmobilitydata}`" target="_blank">Feed on OpenMobilityData.org</a></li>
          </ul>
        </div>
      </div>
    </div>
  </section>
</template>

<script>
import { stripComments } from "jsonc-parser";

export default {
  data() {
    return {
      url: "/dmfr-examples/nyc-mta.dmfr.jsonc",
      parsedContents: {},
      error: false
    };
  },
  computed: {
    parsedFeeds: function() {
      if (this.parsedContents && this.parsedContents.feeds) {
        return this.parsedContents.feeds;
      }
    }
  },
  watch: {
    url: function(newUrl, oldUrl) {
      if (newUrl !== oldUrl) {
        this.fetchDmfr();
      }
    }
  },
  beforeMount() {
    this.fetchDmfr();
  },
  methods: {
    async fetchDmfr() {
      let jsonc;
      try {
        jsonc = await this.$axios.$get(this.url, {
          responseType: "text"
        });
        this.error = "";
      } catch (error) {
        this.error = error;
      }
      const jsonString = stripComments(jsonc);
      this.parsedContents = JSON.parse(jsonString);
    }
  }
};
</script>

<style>
</style>
