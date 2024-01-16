<script lang="ts" setup>
import { Vue3Lottie } from 'vue3-lottie';
import AnimationJson from '../../assets/anim-not-found.json';

const props = withDefaults(defineProps<{
  size?: number,
}>(), {
  size: 500,
});
</script>

<template>
  <Vue3Lottie :animationData="AnimationJson" :height="props.size" :width="props.size"/>
</template>

<style scoped>

</style>
