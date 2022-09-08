<template>
	<div>
	  <!-- Templates Slider Start -->
    <div class="card rounded-3 my-5">
	    <!-- Title -->
	    <div class="card-header text-center">
		    <h3>テンプレートの選択</h3>
	    </div>
	    <!-- Body -->
	    <div class="card-body d-flex flex-column justify-content-center">
		    <!-- Template Slider-->
	      <div class="thumb-example">
          <!-- swiper1 -->
    	    <swiper class="swiper gallery-top" :options="swiperOptionTop" ref="swiperTop" @slideChange="getActiveSlide">
	          <swiper-slide v-for="template in templates" >
		          <img :src="template.img">
  	        </swiper-slide>
            <div class="swiper-pagination"  slot="pagination"></div>
					</swiper>
        	<!-- swiper2 Thumbs -->
          <swiper class="swiper gallery-thumbs" :options="swiperOptionThumbs" ref="swiperThumbs">
	          <swiper-slide v-for="template in templates">
		          <img :src="template.img">
	          </swiper-slide>
          </swiper>
        </div>
        <div class="text-end">
          <input type="button" value="選択する" class="btn btn-warning mt-3" @click="showTemplate">
        </div>
    	</div>
  	</div>
	  <!-- Templates Slider End -->
		<!-- Create Image Stard -->
		<div class="card rounded-3 my-5">
	    <!-- Title -->
	    <div class="card-header text-center">
		    <h3>画像と文字の合成</h3>
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
			  </div>
			</div>      
    </div>
	  <!-- Create Image End -->
  </div>
</template>

<script>
  import { Swiper, SwiperSlide } from 'vue-awesome-swiper'
  import 'swiper/css/swiper.css'
	import VueCropper from 'vue-cropperjs';
  import 'cropperjs/dist/cropper.css';

	export default {
		components: {
      Swiper,
      SwiperSlide,
			VueCropper
    },
    data: function () {
      return {
				selectedSlide: 0,
        templates: [
					{id:0, img:'/assets/images/templates/test0_1200x630.png'},
					{id:1, img:'/assets/images/templates/test1_1200x630.png'},
					{id:2, img:'/assets/images/templates/test2_1200x630.png'}
				],
		  	swiperOptionTop: {
		  	  loop: true,
			    loopedSlides: 3,
			    pagination: {
		  			el: '.swiper-pagination',
			  		clickable: true
	  	  	}
	    	},
		  	swiperOptionThumbs: {
		  	  loop: true,
		    	loopedSlides: 3,
					centeredSlides: true,
	    		slidesPerView: 3,
					touchRatio: 0.2,
	    		slideToClickedSlide: true
	    	},
				imgSrc: '',
        cropImg: '',
				petName: '',
      }
    },
		mounted() {
  		this.$nextTick(() => {
	  		const swiperTop = this.$refs.swiperTop.$swiper
	  		const swiperThumbs = this.$refs.swiperThumbs.$swiper
		  	swiperTop.controller.control = swiperThumbs
		  	swiperThumbs.controller.control = swiperTop
		  })
    },
		methods:{
			getActiveSlide(){
				this.selectedSlide = this.$refs.swiperTop.$swiper.realIndex
			},
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
      showTemplate() {
				const selectedTemplate = new Image();
				selectedTemplate.src = this.templates[this.selectedSlide].img;
				selectedTemplate.onload = () =>{
					const canvas = document.querySelector("#image_canvas");
					const ctx = canvas.getContext("2d");
					ctx.drawImage(selectedTemplate, 0, 0, canvas.width, canvas.height);
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
			}
		}
	}
</script>

<style lang="scss" scoped>
  .thumb-example {
    height: auto;
    background-color: black;
  }
  .swiper {
    .swiper-slide {
      background-size: cover;
      background-position: center;
    }
    &.gallery-top {
      height: 80%;
      width: 100%;
    }
    &.gallery-thumbs {
      height: 20%;
      box-sizing: border-box;
      padding: gap 0;
    }
    &.gallery-thumbs .swiper-slide {
      width: 25%;
      height: 100%;
      opacity: 0.4;
    }
    &.gallery-thumbs .swiper-slide-active {
      opacity: 1;
    }
  }

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
