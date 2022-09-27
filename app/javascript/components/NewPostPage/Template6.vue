<template>
  <div v-show="this.value == 2" class="card rounded-3">
    <!-- Title -->
    <div class="card-header text-center">
      <h3>画像と文字の合成</h3>
    </div>
    <!-- Body -->
    <div class="card-body d-flex flex-column justify-content-center">
      <div class="form-group">
        <label for="pet_image">・ペットの画像を選択</label>
        <input type="file" class="form-control" ref="input" id="pet_image" name="image" accept="image/*" @change="setImage"/>
      </div>
      <div v-show="imgSrc" class="mt-3">
        <vue-cropper
          ref="cropper"
          :src="imgSrc"
          :auto-crop-area="0.5"
          :aspect-ratio="36 / 19"
        />
        <div class="text-end">
          <button class="btn btn-warning mt-3" @click.prevent="drawCroppedImg">トリミング</button>
        </div>
      </div>
      <div class="mt-3">
        <label for="canvas-wrapper">合成イメージ</label>
        <div class="canvas-wrapper mt-3">
          <canvas id="image_canvas" width="1200" height="630"></canvas>
          <canvas id="text_canvas" width="1200" height="630"></canvas>
        </div>
        <div class="d-flex justify-content-between">
					<div>
						<button @click="backTo1st" class="btn btn-warning mt-3">戻る</button>
					</div>
          <div>
						<button v-show="cropImg" @click="setCompletedImage('#combined_canvas', ['#image_canvas', '#text_canvas'])" class="btn btn-warning mt-3">次へ</button>
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
					// 描画の位置は仮設定
					ctx.drawImage(croppedImg, 240, 148, 720, 380);
        }
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
				const imageUrl = canvas.toDataURL('image/jpeg');
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
