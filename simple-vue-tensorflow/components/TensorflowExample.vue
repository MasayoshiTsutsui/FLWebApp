<template>
    <div>
        <div>
            <div class="train-controls">
                <h2 class="section clo-sm-1">Training Data (x,y) pairs</h2>
                <div class="field-label">X</div><div class="field-label">Y</div>
        
                <div v-for="(item, index) in xValues" v-bind:key="index">
                    <input class="field field-x" v-on:change="onImageUploaded" type="file">
                    <input class="field field-y" v-model="yValues[index]" type="number">
                </div>
            </div>
            <button class="button-add-example button--green" v-on:click="addItem">+</button>
            <button class="button-train button--green" v-on:click="train">Train</button>
        </div>

        <select-image/>

        <div class="predict-controls">
            <h2 class="section col-sm-1">Predicting</h2>
            <input class="field element" v-model.number="valueToPredict" type="number" placeholder="Enter an integer number"><br>
            <div class="element">{{predictedValue}}</div>
            <button class="element button--green" v-on:click="predict" :disabled="!trained">Predict</button>
        </div>
    </div>

</template>

<script>
import * as tf from '@tensorflow/tfjs'
import SelectImage from './SelectImage.vue'

export default {
    components: {
        SelectImage
    },
    data() {
        return {
            trained: false,
            xValues: ['', '', '', ''],
            yValues: [0,7,8,9],
            predictedValue: 'Click on train!',
            valueToPredict: ''
        }
    },
    methods: {
        onImageUploaded(e) {
            const target = e.target;
            const files = target.files;
            if (files && files.length > 0) {
                const file = files[0];
                console.log("file =", file);

                var reader = new FileReader();
                reader.readAsArrayBuffer(file);
                reader.onloadend = function (evt) {
                    if (evt.target.readyState === FileReader.DONE) {
                        const arrayBuffer = evt.target.result;
                        const array = new Uint8Array(arrayBuffer);
                        console.log("array =", array);
                        console.log("array.length =", array.length);
                        console.log("array.byteLength =", array.byteLength);
                    }
                };
            }
        },
        addItem() {
            this.xValues.push(0);
            this.yValues.push(0);
        },
        train() {
            console.log(this.xValues[0])
            const model = this.model = tf.sequential();
            model.add(tf.layers.dense({units: 100, inputShape: [28*28]}));
            model.add(tf.layers.dense({units: 10}));
            model.compile({loss: 'categorical_crossentropy', optimizer: 'adam'});

            const xs = tf.tensor2d(this.xValues, [this.xValues.length, 28*28]);
            const ys = tf.one_hot(this.yValues, 10);
            
            model.fit(xs, ys, {epochs: 50}).then(() => {
                this.trained = true;
                this.predictedValue = 'Ready for predictions';
            });
        },
        predict() {
            const outputTensor = this.model.predict(tf.tensor2d([this.valueToPredict], [1, 1]));
            this.predictedValue = outputTensor.dataSync()[0];
            console.log(outputTensor.dataSync());
        }
    }
}
</script>

<style>
.field, .field-label {
  height: 30px;
  padding: 0px 15px;
  float: left;
  width: 50%;
}
</style>