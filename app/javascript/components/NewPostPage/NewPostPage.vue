<template>
	<!-- Container START -->
	<div class="container">
		<!-- Row START -->
		<div class="row justify-content-center py-5">
			<!-- Main content START -->
			<div class="col-sm-10 col-md-8 col-lg-7">
	
				<!-- Templates Slider START -->
				<div v-show="activePart == 1" class="card rounded-3">
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
							<input type="button" value="選択" class="btn btn-warning mt-3" @click="showTemplate">
						</div>
					</div>
				</div>
				<!-- Templates Slider END -->

				<!-- Create Image START -->
				<Template0 v-if="selectedSlide === 0" v-model="activePart" ></Template0>
				<Template1 v-if="selectedSlide === 1" v-model="activePart"></Template1>
				<Template2 v-if="selectedSlide === 2" v-model="activePart"></Template2>
        <!-- Create Image END -->

				<!-- New Post START -->
				<div v-show="activePart == 3" class="card rounded-3">
					<!-- Title -->
					<div class="card-header text-center">
						<h3>画像の投稿</h3>
					</div>
					<!-- Body -->
					<div class="card-body d-flex flex-column justify-content-center">
						<canvas id="combined_canvas" width="1200" height="630"></canvas>
						<!-- Form START -->
						<form action="/posts" accept-charset="UTF-8" method="post">
							<!-- csrfトークンをhiddenで設定 -->
							<input type="hidden" id="authenticity_token" name="authenticity_token" value="" autocomplete="off" />
							<!-- 最終イメージをhiddenで設定 -->
							<input type="hidden" id="post_image" name="post[image]" value="" />
							<!-- キャプション -->
							<div class="form-group">
								<label for="post_body">キャプション(任意)</label>
								<textarea class="form-control" name="post[body]" id="post_body"></textarea>
							</div>
							<div class="d-flex justify-content-between">
				      	<div>
						      <button type="button" @click="backTo2nd" class="btn btn-warning mt-3">戻る</button>
								</div>
          		  <div>
							  	<button type="submit" class="btn btn-warning mt-3" data-disable-with="投稿する">投稿</button>
						  	</div>
							</div>
						</form>
						<!-- Form END -->
					</div>
				</div>
				<!-- New Post END -->
			</div>
			<!-- Main content END -->
		</div>
		<!-- Row END -->
	</div>
	<!-- Container END -->
</template>

<script>
  import { Swiper, SwiperSlide } from 'vue-awesome-swiper'
  import 'swiper/css/swiper.css'
	import Template0 from "./Template0.vue";
	import Template1 from "./Template1.vue";
	import Template2 from "./Template2.vue";

	export default {
		components: {
      Swiper,
      SwiperSlide,
			Template0,
			Template1,
			Template2,
    },
    data: function () {
      return {
				selectedSlide: 0,
				activePart: 1,
        templates: [
					{id:0, img:'/assets/images/templates/wanted_1.png'},
					{id:1, img:'/assets/images/templates/newspaper_1.png'},
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
	    	}		
      }
    },
		mounted() {
			// csrfトークンの設定
			const token = document.getElementsByName("csrf-token")[0].content;
			document.querySelector("#authenticity_token").value = token;

  		this.$nextTick(() => {
	  		const swiperTop = this.$refs.swiperTop.$swiper
	  		const swiperThumbs = this.$refs.swiperThumbs.$swiper
		  	swiperTop.controller.control = swiperThumbs
		  	swiperThumbs.controller.control = swiperTop
		  });
    },
		methods:{
			getActiveSlide(){
				this.selectedSlide = this.$refs.swiperTop.$swiper.realIndex
			},
      showTemplate() {
				const selectedTemplate = new Image();
				selectedTemplate.src = this.templates[this.selectedSlide].img;
				selectedTemplate.onload = () =>{
					const canvas = document.querySelector("#image_canvas");
					const ctx = canvas.getContext("2d");
					ctx.drawImage(selectedTemplate, 0, 0, canvas.width, canvas.height);
        }
				// 画像と文字の合成部分を表示
				this.activePart = 2;
			},
			backTo2nd () {
				this.activePart = 2;
			}
		}
	}
</script>

<style lang="scss" scoped>
  .thumb-example {
    height: auto;
    background-color: white;
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
</style>
