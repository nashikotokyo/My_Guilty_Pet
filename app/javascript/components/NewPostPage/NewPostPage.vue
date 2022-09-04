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
          <input type="button" value="選択する" class="btn btn-warning mt-3">
        </div>
    	</div>
  	</div>
	  <!-- Templates Slider End -->
	  <!-- Select Pet Image Start -->
    <div class="card rounded-3 my-5">
	    <!-- Title -->
	    <div class="card-header text-center">
		    <h3>ペットの画像を選択</h3>
	    </div>
	    <!-- Body -->
	    <div class="card-body d-flex flex-column justify-content-center">
				<input class="form-control" type="file" ref="uploadedFile" @change="getFileUrl">
        <div v-if="uploadedFileUrl">
					<img class="pt-3" :src="uploadedFileUrl">
					<div class="text-end">
            <input type="button" value="選択する" class="btn btn-warning mt-3">
          </div>
				</div> 
    	</div>
  	</div>
	  <!-- Select Pet Image End -->
		<!-- Trimming Start -->
		<div class="card rounded-3 my-5">
	    <!-- Title -->
	    <div class="card-header text-center">
		    <h3>トリミング</h3>
	    </div>
	    <!-- Body -->
	    <div class="card-body d-flex flex-column justify-content-center">
			 
    	</div>
    </div>
	  <!-- Trimming End -->

  </div>
</template>

<script>
  import { Swiper, SwiperSlide } from 'vue-awesome-swiper'
  import 'swiper/css/swiper.css'

	export default {
		components: {
      Swiper,
      SwiperSlide
    },
    data: function () {
      return {
				selectedSlide: 0,
				uploadedFileUrl: '',
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
	    	}
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
			getFileUrl(){
				const uploadedFile = this.$refs.uploadedFile.files[0] 
        this.uploadedFileUrl = URL.createObjectURL(uploadedFile)
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
</style>
