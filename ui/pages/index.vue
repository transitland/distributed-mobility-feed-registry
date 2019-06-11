<template>
  <div class="container">
    <div class="content">
      <div v-html="readme"></div>
    </div>
    <!-- <dmfr-renderer/> -->
  </div>
</template>

<script>
// import DmfrRenderer from '~/components/DmfrRenderer.vue'
import Readme from "~/../README.md";

export default {
  computed: {
    readme() {
      return Readme;
    }
  }
  // components: {
  //   DmfrRenderer
  // }
};
</script>

<style>
</style>
