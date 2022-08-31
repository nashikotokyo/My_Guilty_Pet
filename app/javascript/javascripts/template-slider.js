import Vue from 'vue'
import TemplateSlider from '../components/NewPostsPage/TemplateSlider.vue'

document.addEventListener('DOMContentLoaded', () => {
  const selector = '#js-template-slider'
  const templateSlider = document.querySelector(selector)
  
  if (templateSlider) {
    new Vue({
      render: (h) => h(TemplateSlider)
    }).$mount(selector)
  }
})
