// stimulus-carousel@5.0.1 downloaded from https://ga.jspm.io/npm:stimulus-carousel@5.0.1/dist/stimulus-carousel.mjs

import{Controller as t}from"@hotwired/stimulus";import e from"swiper/bundle";class s extends t{connect(){this.swiper=new e(this.element,{...this.defaultOptions,...this.optionsValue})}disconnect(){this.swiper.destroy(),this.swiper=void 0}get defaultOptions(){return{}}}s.values={options:Object};export{s as default};

