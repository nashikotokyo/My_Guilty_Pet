<template>
	<!-- Template0をコピーした仮のテンプレートを用意 -->
  <div class="card rounded-3 my-5">
    <!-- Title -->
    <div class="card-header text-center">
      <h3>画像と文字の合成(Template2)</h3>
    </div>
    <!-- Body -->
    <div class="card-body d-flex flex-column justify-content-center">
      <div class="form-group">
        <label for="pet_image">ペットの画像を選択</label>
        <input type="file" class="form-control" ref="input" id="pet_image" name="image" accept="image/*" @change="setImage"/>
      </div>
      <div v-show="imgSrc" class="mt-3">
        <vue-cropper
          ref="cropper"
          :src="imgSrc"
          :auto-crop-area="0.5"
          :aspect-ratio="1 / 1"
        />
        <div class="text-end">
          <button class="btn btn-warning mt-3" @click.prevent="drawCroppedImg">トリミング</button>
        </div>
      </div>
      <div class="mt-3" v-show="cropImg">
        <div class="form-group mt-1" >
          <label for="pet_name">ペットの名前</label>
          <input type="text" class="form-control" id="pet_name" placeholder="ポチ"></input>
          <div class="text-end">
            <button @click="drawPetName" class="btn btn-warning mt-3">合成</button>
          </div>
        </div>
        <div class="form-group mt-1">
          <label for="crime_name">犯行内容・罪状</label>
          <input type="text" class="form-control" id="crime_name" placeholder="脱走罪・ブランドバッグ破壊罪・可愛すぎ罪など"></input>
          <div class="text-end">
            <button @click="drawCrimeName" class="btn btn-warning mt-3">合成</button>
          </div> 
        </div>
        <div class="form-group  mt-1">
          <label for="bounty">懸賞金額</label>
          <input type="text" class="form-control" id="bounty" placeholder="¥30,000,000"></input>
          <div class="text-end">
            <button @click="drawBounty" class="btn btn-warning mt-3">合成</button>
          </div> 
        </div>
      </div>
      <div class="mt-3">
        <label for="canvas-wrapper">合成イメージ</label>
        <div class="canvas-wrapper mt-3">
          <canvas id="image_canvas" width="1200" height="630"></canvas>
          <canvas id="text_canvas" width="1200" height="630"></canvas>
        </div>
        <div class="text-end">
          <button v-show="cropImg" @click="setCompletedImage('#combined_canvas', ['#image_canvas', '#text_canvas'])" class="btn btn-warning mt-3">合成を完了</button>
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
					ctx.drawImage(croppedImg, 70, 120, 500, 500);
        }
			},
			drawPetName(){
				const canvas = document.querySelector("#text_canvas");
				const ctx = canvas.getContext('2d');
				const petName = document.querySelector("#pet_name");
				//消去の位置は仮設定
				ctx.clearRect(0, 0, 1200, 280);
				//スタイルは仮設定
				ctx.font = '70px serif';
				ctx.fillStyle = '#404040';
				//描画の位置は仮設定
				ctx.fillText(petName.value, 700, 250, 370);
			},
			drawCrimeName(){
				const canvas = document.querySelector("#text_canvas");
				const ctx = canvas.getContext('2d');
				const crimeName = document.querySelector("#crime_name");
				//消去の位置は仮設定
				ctx.clearRect(0, 300, 1200, 150);
				//スタイルは仮設定
				ctx.font = '70px serif';
				ctx.fillStyle = '#404040';
				//描画の位置は仮設定
				ctx.fillText(crimeName.value, 700, 400, 370);
			},
			drawBounty(){
				const canvas = document.querySelector("#text_canvas");
				const ctx = canvas.getContext('2d');
				const bounty = document.querySelector("#bounty");
				//消去の位置は仮設定
				ctx.clearRect(0, 450, 1200, 150);
				//スタイルは仮設定
				ctx.font = '70px serif';
				ctx.fillStyle = '#404040';
				//描画の位置は仮設定
				ctx.fillText(bounty.value, 700, 550, 370);
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
			},
			getImagefromCanvas(id){
				return new Promise((resolve, reject) => {
					const image = new Image();
					const ctx = document.querySelector(id).getContext("2d");
					image.onload = () => resolve(image);
					image.onerror = (e) => reject(e);
					image.src = ctx.canvas.toDataURL();
				});
			}
		}
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
