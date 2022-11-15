import {
         ValidationProvider,
         ValidationObserver,
         extend,
         localize
} from 'vee-validate';
import { required, excluded } from 'vee-validate/dist/rules';
import badwords from '/config/badwords.json';

extend('required', required)
extend('excluded', excluded)

import ja from "vee-validate/dist/locale/ja.json";
localize('ja', ja);

export default {
  components: {
    ValidationProvider,
    ValidationObserver,
  },
};

let badWords = [];
badWords = badwords.data;

extend('badWords', {
  validate(value) {
    if (hasBadWords(value, badWords)){
      return false
    }
    else {
      return true
    }
  },
  message: '不適切なワードが含まれています',
});

function hasBadWords(str, badwords) {

  for(let i = 0; i < badWords.length; i++) {
    if(~str.indexOf(badwords[i])) return true;
  }

  return false;
}