<template>
  <div id="blackjack-menu">
    <b-row id="header">
        <h4>Blackjack Game</h4>
    </b-row>
    <b-row id="balance" class="d-flex align-items-center mt-2">
        <p>Balance: ${{ cash }}</p>
    </b-row>
    <b-row id="game-status" class="d-flex align-items-center mt-2" v-if="!ingame">
        <p>{{ status }}</p>
    </b-row>
    <b-row id="hand-status" class="d-flex align-items-center mt-2" v-else>
        <b-col class="pl-0" cols="4">
          <p>Your hand: {{ currentHand }}</p>
        </b-col>
        <b-col cols="8">
          <p>Dealer's hand: {{ dealersHand }}</p>
        </b-col>
    </b-row>
  </div>
</template>

<script lang="ts">
import Vue from 'vue';
import { Component, Prop } from 'vue-property-decorator';

@Component({})
export default class BlackjackMenu extends Vue {
  @Prop({
    default: 50,
  })
  cash!: number;
  @Prop({
    default: 50000,
  })
  betAmount!: number;
  @Prop({
    default: 'Waiting for dealer...',
  })
  status!: string;
  @Prop({
    default: false
  })
  ingame!: boolean;
  @Prop({
    default: 0
  })
  currentHand!: number;
  @Prop({
    default: 0
  })
  dealersHand!: number;
}

</script>
