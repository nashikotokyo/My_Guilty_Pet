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
          :aspect-ratio="3 / 2"
        />
        <div class="text-end">
          <button class="btn btn-purple mt-1 me-2" @click.prevent="drawCroppedImg">トリミング</button>
        </div>
      </div>
      <div class="mt-1 mx-2" v-show="cropImg">
        <div class="form-group" >
          <label for="headline1">・新聞の見出しを入力</label>
					<p class="mb-0 small">(例)〇〇容疑者現行犯逮捕/禁固〇分求刑/〇〇の容疑で逮捕</p>
          <input type="text" class="form-control" id="headline1" placeholder="山田ポチ容疑者現行犯逮捕">
          <div class="text-end">
            <button @click="drawHeadline1" class="btn btn-purple mt-1">合成</button>
          </div>
        </div>
				<p class="mb-0 mt-2">・犯行内容や犯行理由など詳細を入力</p>
				<p class="mb-0 small">(例)〇〇を破壊した罪/犯行理由は〇〇からと供述</p>
				<p class="mb-0 small">※各列最大6文字(スペースも認識されます)</p>
        <div class="form-group mt-1">
          <label for="detail1">1列目</label>
          <input type="text" class="form-control" id="detail1" maxlength="6" placeholder="おやつを">
          <div class="text-end">
            <button @click="drawDetail1" class="btn btn-purple mt-1">合成</button>
          </div> 
        </div>
        <div class="form-group">
          <label for="detail2">2列目</label>
          <input type="text" class="form-control" id="detail2" maxlength="6" placeholder="　食い逃げ">
          <div class="text-end">
            <button @click="drawDetail2" class="btn btn-purple mt-1">合成</button>
          </div> 
        </div>
				<div class="form-group">
          <label for="detail3">3列目</label>
          <input type="text" class="form-control" id="detail3" maxlength="6" placeholder="　　した罪">
          <div class="text-end">
            <button @click="drawDetail3" class="btn btn-purple mt-1">合成</button>
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
					ctx.drawImage(croppedImg, 70, 190, 600, 400);
        }
			},
			drawHeadline1(){
				const canvas = document.querySelector("#text_canvas");
				const ctx = canvas.getContext('2d');
				const headline1 = document.querySelector("#headline1");
				//消去の位置を設定
				ctx.clearRect(0, 0, 1200, 160);
				//文字のデザインを設定
				ctx.font = '900 90px sans-serif';
				ctx.fillStyle = '#ffffff';
				ctx.textAlign = 'center'
				//描画の位置を設定
				ctx.fillText(headline1.value, 532, 140, 900);
			},
			drawDetail1(){
				const canvas = document.querySelector("#text_canvas");
				const ctx = canvas.getContext('2d');
				const detail1 = document.querySelector("#detail1");
				//消去の位置を設定
				ctx.clearRect(900, 180, 85, 450);
				//文字のデザインを設定
				ctx.font = '900 70px serif';
				ctx.fillStyle = '#14191e';
				//描画の位置を設定(縦書きで表示)
				this.tategaki(ctx, detail1.value, 950, 245);
			},
			drawDetail2(){
				const canvas = document.querySelector("#text_canvas");
				const ctx = canvas.getContext('2d');
				const detail2 = document.querySelector("#detail2");
				//消去の位置を設定
				ctx.clearRect(800, 180, 85, 450);
				//文字のデザインを設定
				ctx.font = '900 70px serif';
				ctx.fillStyle = '#14191e';
				//描画の位置を設定(縦書きで表示)
				this.tategaki(ctx, detail2.value, 850, 245);
			},
			drawDetail3(){
				const canvas = document.querySelector("#text_canvas");
				const ctx = canvas.getContext('2d');
				const detail3 = document.querySelector("#detail3");
				//消去の位置を設定
				ctx.clearRect(700, 180, 85, 450);
				//文字のデザインを設定
				ctx.font = '900 70px serif';
				ctx.fillStyle = '#14191e';
				//描画の位置を設定(縦書きで表示)
				this.tategaki(ctx, detail3.value, 750, 245);
			},
			tategaki(ctx, text, x, y){
				const textList = text.split('\n');
				const lineHeight = ctx.measureText("あ").width;
				textList.forEach(function(elm, i) {
					Array.prototype.forEach.call(elm, function(ch, j) {
						ctx.fillText(ch, x-lineHeight*i, y+lineHeight*j);
					});
				});
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
