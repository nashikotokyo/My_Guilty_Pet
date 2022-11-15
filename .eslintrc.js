module.exports = {
    "env": {
        "browser": true,
        "es2021": true,
        "node": true,
        "jquery": true, 
    },
    "extends": [
        "eslint:recommended",
        "plugin:vue/vue3-essential"
    ],
    "overrides": [
    ],
    "parserOptions": {
        "ecmaVersion": "latest",
        "sourceType": "module"
    },
    "plugins": [
        "vue"
    ],
    "rules": {
        "vue/no-deprecated-slot-attribute": "off",
        "vue/multi-word-component-names": "off"
    }
}
