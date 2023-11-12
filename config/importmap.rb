# Pin npm packages by running ./bin/importmap

pin "application", preload: true
pin "typed.js", to: "https://ga.jspm.io/npm:typed.js@2.1.0/dist/typed.module.js"
pin "@hotwired/stimulus", to: "stimulus.min.js", preload: true
pin "@hotwired/stimulus-loading", to: "stimulus-loading.js", preload: true
pin_all_from "app/javascript/controllers", under: "controllers"
pin "@rails/actioncable", to: "https://ga.jspm.io/npm:@rails/actioncable@7.1.2/app/assets/javascripts/actioncable.esm.js"
pin "@popperjs/core", to: "https://ga.jspm.io/npm:@popperjs/core@2.11.8/lib/index.js"

pin "codemirror", to: "https://ga.jspm.io/npm:codemirror@6.0.1/dist/index.js"
pin "@codemirror/language", to: "https://ga.jspm.io/npm:@codemirror/language@6.9.2/dist/index.js"
pin "@codemirror/state", to: "https://ga.jspm.io/npm:@codemirror/state@6.3.1/dist/index.js"
pin "@codemirror/view", to: "https://ga.jspm.io/npm:@codemirror/view@6.22.0/dist/index.js"
pin "@lezer/common", to: "https://ga.jspm.io/npm:@lezer/common@1.1.0/dist/index.js"
pin "@lezer/highlight", to: "https://ga.jspm.io/npm:@lezer/highlight@1.1.6/dist/index.js"
pin "crelt", to: "https://ga.jspm.io/npm:crelt@1.0.6/index.js"
pin "style-mod", to: "https://ga.jspm.io/npm:style-mod@4.1.0/src/style-mod.js"
pin "w3c-keyname", to: "https://ga.jspm.io/npm:w3c-keyname@2.2.8/index.js"
pin "@codemirror/legacy-modes/mode/ruby", to: "https://ga.jspm.io/npm:@codemirror/legacy-modes@6.3.3/mode/ruby.js"
pin "@uiw/codemirror-theme-dracula", to: "https://ga.jspm.io/npm:@uiw/codemirror-theme-dracula@4.21.20/esm/index.js"
pin "@babel/runtime/helpers/extends", to: "https://ga.jspm.io/npm:@babel/runtime@7.23.2/helpers/esm/extends.js"
pin "@uiw/codemirror-themes", to: "https://ga.jspm.io/npm:@uiw/codemirror-themes@4.21.20/esm/index.js"
pin "@codemirror/commands", to: "https://ga.jspm.io/npm:@codemirror/commands@6.3.0/dist/index.js"
pin "@codemirror/search", to: "https://ga.jspm.io/npm:@codemirror/search@6.5.4/dist/index.js"
pin "@codemirror/autocomplete", to: "https://ga.jspm.io/npm:@codemirror/autocomplete@6.11.0/dist/index.js"
pin "@codemirror/lint", to: "https://ga.jspm.io/npm:@codemirror/lint@6.4.2/dist/index.js"
