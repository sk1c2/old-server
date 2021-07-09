<template>
  <div id="bet-menu" v-if="menuActive">
    <b-form @submit="onSubmit" @reset="onReset" id="bet-form" class="d-flex align-items-center">
      <b-form-group
        id="bet-amount-group"
        label="Bet Amount"
        label-for="bet-amount-input"
        class="w-100"
      >
        <b-form-input
          id="bet-amount-input"
          v-model="betAmount"
          type="text"
          required
        >
        </b-form-input>
      </b-form-group>

      <b-row>
        <b-col>
          <b-button type="submit" variant="success">Submit</b-button>
        </b-col>
        <b-col>
          <b-button type="reset" variant="danger">Leave</b-button>
        </b-col>
      </b-row>
    </b-form>
    <p v-if="error">BAD BOI</p>
  </div>
</template>

<script lang="ts">
import Vue from 'vue';
import axios from 'axios';
import { Component, Prop } from 'vue-property-decorator';

@Component({})
export default class BetMenu extends Vue {
  @Prop({
    default: false,
  })
  menuActive!: boolean;
  
  protected betAmount: string = '';
  protected error: boolean = false;

  onSubmit(event: Event) {
    event.preventDefault();
    if (!parseInt(this.betAmount)){
      this.error = true;
    } else {
      axios.post(`https://diamondblackjackoriginal/setbet`,
        JSON.stringify({
          betAmount: this.betAmount,
        })
      )
      .then((res) => res)
      .then((res) => console.log(JSON.stringify(res)));
    }
  }

  onReset(event: Event) {
    event.preventDefault();
    axios.post(`https://diamondblackjackoriginal/leave`)
    .then((res) => res)
    .then((res) => console.log(JSON.stringify(res)));
  }
}
</script>
