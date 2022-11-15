import Vue from 'vue'
import NewPostPage from '../components/NewPostPage/NewPostPage.vue'
import veeValidate from "./vee-validate"

Vue.mixin(veeValidate)

document.addEventListener('DOMContentLoaded', () => {
  const selector = '#js-new-post-page'
  const newPostPage = document.querySelector(selector)
  
  if (newPostPage) {
    new Vue({
      render: (h) => h(NewPostPage)
    }).$mount(selector)
  }
})
