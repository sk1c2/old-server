<template>
  <transition name="fade">
    <div id="hit-button" @click="performHit" v-if="hitOrStandState">
      <b-row>
          <h4>Hit</h4>
      </b-row>
      <b-row>
          <p>Draw another card</p>
      </b-row>
    </div>
  </transition>
</template>

<script lang="ts">
import Vue from 'vue';
import axios from 'axios';
import { Component, Prop } from 'vue-property-decorator';

@Component({})
export default class HitButton extends Vue {
    @Prop({
        default: false
    })
    hitOrStandState!: boolean;

    performHit(event: Event) {
        event.preventDefault();
        axios.post(`https://diamondblackjackoriginal/hitorstandstate`,
            JSON.stringify({
                hasHit: true,
            })
        )
        .then((res) => res)
        .then((res) => console.log(JSON.stringify(res)));
    }
}
</script>