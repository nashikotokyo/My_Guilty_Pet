<template>
  <div v-show="this.value == 2" class="card rounded-3">
    <!-- Title -->
    <div class="card-header text-center">
      <h3 class="mb-0">画像と文字の合成</h3>
    </div>
    <!-- Body -->
    <div class="p-0 card-body d-flex flex-column justify-content-center">
      <div class="form-group mx-2 mt-3">
        <label for="pet_image">・ペットの画像を選択</label>
        <input type="file" class="form-control" ref="input" id="pet_image" name="image" accept="image/*" @change="setImage"/>
      </div>
      <div v-show="imgSrc" class="mt-3">
        <vue-cropper
          ref="cropper"
          :src="imgSrc"
          :auto-crop-area="0.5"
          :aspect-ratio="106 / 94"
        />
        <div class="text-end">
          <button class="btn btn-purple mt-1 me-2" @click.prevent="drawCroppedImg">トリミング</button>
        </div>
      </div>
      <div class="mt-1 mx-2" v-show="cropImg">
        <div class="form-group" >
          <label for="case_name">・事件名や罪名を入力</label>
          <p class="mb-0 small">(例)〇〇事件犯人/〇〇の罪/〇〇の容疑</p>
          <input type="text" class="form-control" id="case_name" placeholder="高級バッグ破壊事件犯人">
          <div class="text-end">
            <button @click="drawCaseName" class="btn btn-purple mt-1">合成</button>
          </div>
        </div>
        <div class="form-group">
          <label for="feature">・特徴を入力</label>
          <input type="text" class="form-control" id="feature" placeholder="短い足に長い胴">
          <div class="text-end">
            <button @click="drawFeature" class="btn btn-purple mt-1">合成</button>
          </div> 
        </div>
        <div class="form-group">
          <label for="bounty">・報奨金額を入力</label>
          <input type="text" class="form-control" id="bounty" placeholder="¥100,000">
          <div class="text-end">
            <button @click="drawBounty" class="btn btn-purple mt-1">合成</button>
          </div>
        </div>
      </div>
      <div class="mt-2">
        <label for="canvas-wrapper" class="ms-2">合成イメージ</label>
        <div class="canvas-wrapper">
          <canvas id="image_canvas" width="1200" height="630"></canvas>
          <canvas id="text_canvas" width="1200" height="630"></canvas>
        </div>
        <div class="p-2 d-flex align-items-center justify-content-between">
					<div>
						<button @click="backTo1st" class="btn btn-purple">戻る</button>
					</div>
          <div>
						<button v-show="cropImg" @click="setCompletedImage('#combined_canvas', ['#image_canvas', '#text_canvas'])" class="btn btn-purple">次へ</button>
					</div>					          
        </div>
      </div>
    </div>      
  </div>
</template>

<script>
	import VueCropper from 'vue-cropperjs';
  import 'cropperjs/dist/cropper.css';

	export default {
		components: {
			VueCropper
    },
		props: ['value'],
    data: function () {
      return {
				imgSrc: '',
        cropImg: '',			
      }
    },
		methods:{
			setImage (e) {
				const file = e.target.files[0]
				if (!file.type.includes('image/')) {
					alert('画像ファイルを選択して下さい')
					return
				}
				if (typeof FileReader === 'function') {
					const reader = new FileReader();
          reader.onload = (event) => {
						this.imgSrc = event.target.result;
						// rebuild cropperjs with the updated source
          	this.$refs.cropper.replace(event.target.result);
          };
          reader.readAsDataURL(file);
				} else {
					alert('Sorry, FileReader API not supported');
				}
			},
			drawCroppedImg() {
				// トリミングした画像のURLをcropImgに格納
				this.cropImg = this.$refs.cropper.getCroppedCanvas().toDataURL();
				// トリミングした画像を選択されたテンプレートの上に合成する
				const croppedImg = new Image();
				croppedImg.src = this.cropImg;
				croppedImg.onload = () =>{
					const canvas = document.querySelector("#image_canvas");
					const ctx = canvas.getContext("2d");
					// 描画の位置を設定
					ctx.drawImage(croppedImg, 20, 145, 530, 470);
        }
			},
			drawCaseName(){
				const canvas = document.querySelector("#text_canvas");
				const ctx = canvas.getContext('2d');
				const caseName = document.querySelector("#case_name");
				//消去の位置を設定
				ctx.clearRect(0, 0, 1200, 300);
				//文字のデザインを設定
				ctx.font = '900 80px sans-serif';
				ctx.fillStyle = '#fff';
				ctx.textAlign = 'center'
				//描画の位置を設定
				ctx.fillText(caseName.value, 875, 222, 585);
			},
			drawFeature(){
				const canvas = document.querySelector("#text_canvas");
				const ctx = canvas.getContext('2d');
				const feature = document.querySelector("#feature");
				//消去の位置を設定
				ctx.clearRect(0, 300, 1200, 150);
				//文字のデザインを設定
				ctx.font = '900 80px sans-serif';
				ctx.fillStyle = '#14191e';
				ctx.textAlign = 'center'
				//描画の位置を設定
				ctx.fillText(feature.value, 875, 420, 600);
			},
			drawBounty(){
				const canvas = document.querySelector("#text_canvas");
				const ctx = canvas.getContext('2d');
				const bounty = document.querySelector("#bounty");
				//消去の位置を設定
				ctx.clearRect(0, 450, 1200, 180);
				//文字のデザインを設定
				ctx.font = '900 80px sans-serif';
				ctx.fillStyle = '#14191e';
				ctx.textAlign = 'center'
				//描画の位置を設定
				ctx.fillText(bounty.value, 875, 600, 600);
			},
			setCompletedImage:async function(base, assets){
				// imageとtextの2つのcanvasを合成する
				const canvas = document.querySelector(base);
        const ctx = canvas.getContext("2d");

				for(let i=0; i<assets.length; i++){
					const image1 = await this.getImagefromCanvas(assets[i]);
					ctx.drawImage(image1, 0, 0, canvas.width, canvas.height);
				}
			  // 完成イメージをフォーム内のhiddenに設定
				const imageUrl = canvas.toDataURL('image/jpg');
				document.querySelector("#post_image").value = imageUrl
        // 完成した画像の投稿部分を表示
        this.localActivePart = 3;
			},
			getImagefromCanvas(id){
				return new Promise((resolve, reject) => {
					const image = new Image();
					const ctx = document.querySelector(id).getContext("2d");
					image.onload = () => resolve(image);
					image.onerror = (e) => reject(e);
					image.src = ctx.canvas.toDataURL();
				});
			},
			backTo1st(){
				this.localActivePart = 1;
			}
		},
		computed: {
			localActivePart: {
				get: function() {
					return this.value
				},
				set: function(value) {
					this.$emit('input', value)
				},
      },
		},
	}
</script>

<style lang="scss" scoped>
	
	.canvas-wrapper {
    position: relative;
		width: 100%;
		padding-top: 52.5%;
		height:auto;
  }

	.canvas-wrapper canvas {
		position: absolute;
		width: 100%;
    top: 0;
    left: 0;
  }
</style>
