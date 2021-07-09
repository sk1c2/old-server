<template>
    <transition name="fade">
        <div id="timer" v-if="isActive">
            <b-row>
                <b-col cols="5">TIME:</b-col>
                <b-col cols="7">{{ timeInSeconds }}</b-col>
            </b-row>
        </div>
    </transition>
</template>

<script lang="ts">
import Vue from 'vue';
import { Component, Prop } from 'vue-property-decorator';

@Component({})
export default class Timer extends Vue {
    @Prop({
        default: 0,
    })
    timer!: number;
    @Prop({
        default: false,
    })
    isActive!: boolean;

    get timeInSeconds() {
        return new Date(this.timer).toISOString().slice(14, -5)
    }
}
</script>
