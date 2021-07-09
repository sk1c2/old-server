<template>
    <div id="app">
      <HitButton :hitOrStandState="hitOrStandState" />
      <StandButton :hitOrStandState="hitOrStandState" />
      <BetMenu :menuActive="betMenuActive" />
      <BlackjackMenu :status="statusMessage" :ingame="ingame" :currentHand="currentHand" :dealersHand="dealersHand" :cash="cash" />
      <Timer :timer="timeRemaining" :isActive="timerActive" />
    </div>
</template>

<script lang="ts">
import Vue from 'vue';
import { Component } from 'vue-property-decorator';

import BlackjackMenu from './components/BlackjackMenu.vue';
import BetMenu from './components/BetMenu.vue';
import HitButton from './components/buttons/HitButton.vue';
import StandButton from './components/buttons/StandButton.vue';
import Timer from './components/Timer.vue';

@Component({
  components: {
    BlackjackMenu,
    BetMenu,
    HitButton,
    StandButton,
    Timer
  }
})
export default class App extends Vue {
  protected statusMessage: string = '';
  protected betMenuActive: boolean = false;
  protected ingame: boolean = false;
  protected currentHand: number = 0;
  protected dealersHand: number = 0;
  protected hitOrStandState: boolean = false;
  protected timeRemaining: number = 0;
  protected timerActive: boolean = false;
  protected cash: number = 0;

  created() {
    document.body.className = 'hide';
  }
  mounted() {
    window.addEventListener('message', (event) => {
      switch (event.data.type) {
        case 'openUI':
          document.body.className = 'show';
          break;
        case 'closeUI':
          document.body.className = 'hide';
          this.betMenuActive = false; // If player leaves the table halfway through the game.
          break;
        case 'bet':
          this.betMenuActive = true;
          break;
        case 'closeBet':
          this.betMenuActive = false;
          break;
        case 'setHand':
          this.currentHand = event.data.currentHand;
          this.dealersHand = event.data.dealersHand;
          break;
        default:
          break;
      }
      if (event.data.status) {
        this.statusMessage = event.data.status;
      }
      if (event.data.timeRemaining) {
        this.timeRemaining = event.data.timeRemaining * 1000;
      }
      if (event.data.ingame !== undefined) {
        this.ingame = event.data.ingame;
      }
      if (event.data.hitOrStandState !== undefined) {
        this.hitOrStandState = event.data.hitOrStandState;
      }
      if (event.data.timerActive !== undefined) {
        this.timerActive = event.data.timerActive;
      }
      if (event.data.cash !== undefined) {
        this.cash = event.data.cash;
      }
    });
  }
}
</script>
