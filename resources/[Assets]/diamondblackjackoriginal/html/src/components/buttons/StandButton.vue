<template>
  <transition name="fade">
    <div id="stand-button" @click="performStand" v-if="hitOrStandState">
      <b-row>
          <h4>Stand</h4>
      </b-row>
      <b-row>
          <p>{{ randomCaption }}</p>
      </b-row>
    </div>
  </transition>
</template>

<script lang="ts">
import Vue from 'vue';
import axios from 'axios';
import { Component, Prop } from 'vue-property-decorator';

import { sendRandomCaptionForStandButton } from '../../services/RandomMessage';

@Component({})
export default class StandButton extends Vue {
  @Prop({
    default: false
  })
  hitOrStandState!: boolean;

  get randomCaption() {
    return sendRandomCaptionForStandButton(this.hitOrStandState);
  }

  performStand(event: Event) {
    event.preventDefault();
    axios.post(`https://diamondblackjackoriginal/hitorstandstate`,
      JSON.stringify({
          hasStood: true,
      })
    )
    .then((res) => res)
    .then((res) => console.log(JSON.stringify(res)));
  }
}
</script>