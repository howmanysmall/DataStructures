"use strict";(self.webpackChunkdocs=self.webpackChunkdocs||[]).push([[35,514,379],{24608:function(e,n,t){t.r(n);var a=t(67294),r=t(54814),c=t(95999);n.default=function(){return a.createElement(r.Z,{title:(0,c.I)({id:"theme.NotFound.title",message:"Page Not Found"})},a.createElement("main",{className:"container margin-vert--xl"},a.createElement("div",{className:"row"},a.createElement("div",{className:"col col--6 col--offset-3"},a.createElement("h1",{className:"hero__title"},a.createElement(c.Z,{id:"theme.NotFound.title",description:"The title of the 404 page"},"Page Not Found")),a.createElement("p",null,a.createElement(c.Z,{id:"theme.NotFound.p1",description:"The first paragraph of the 404 page"},"We could not find what you were looking for.")),a.createElement("p",null,a.createElement(c.Z,{id:"theme.NotFound.p2",description:"The 2nd paragraph of the 404 page"},"Please contact the owner of the site that linked you to the original URL and let them know their link is broken."))))))}},6979:function(e,n,t){var a=t(76775),r=t(52263),c=t(28084),o=t(94184),l=t.n(o),s=t(67294);n.Z=function(e){var n=(0,s.useRef)(!1),o=(0,s.useRef)(null),i=(0,a.k6)(),u=(0,r.Z)().siteConfig,h=(void 0===u?{}:u).baseUrl;(0,s.useEffect)((function(){var e=function(e){"s"!==e.key&&"/"!==e.key||o.current&&e.srcElement===document.body&&(e.preventDefault(),o.current.focus())};return document.addEventListener("keydown",e),function(){document.removeEventListener("keydown",e)}}),[]);var d=(0,c.usePluginData)("docusaurus-lunr-search"),f=function(){n.current||(Promise.all([fetch(""+h+d.fileNames.searchDoc).then((function(e){return e.json()})),fetch(""+h+d.fileNames.lunrIndex).then((function(e){return e.json()})),Promise.all([t.e(878),t.e(245)]).then(t.bind(t,24130)),Promise.all([t.e(532),t.e(343)]).then(t.bind(t,53343))]).then((function(e){var n=e[0],t=e[1],a=e[2].default;0!==n.length&&function(e,n,t){new t({searchDocs:e,searchIndex:n,inputSelector:"#search_input_react",handleSelected:function(e,n,t){var a=h+t.url;document.createElement("a").href=a,i.push(a)}})}(n,t,a)})),n.current=!0)},m=(0,s.useCallback)((function(n){o.current.contains(n.target)||o.current.focus(),e.handleSearchBarToggle&&e.handleSearchBarToggle(!e.isSearchBarExpanded)}),[e.isSearchBarExpanded]);return s.createElement("div",{className:"navbar__search",key:"search-box"},s.createElement("span",{"aria-label":"expand searchbar",role:"button",className:l()("search-icon",{"search-icon-hidden":e.isSearchBarExpanded}),onClick:m,onKeyDown:m,tabIndex:0}),s.createElement("input",{id:"search_input_react",type:"search",placeholder:"Press S to Search...","aria-label":"Search",className:l()("navbar__search-input",{"search-bar-expanded":e.isSearchBarExpanded},{"search-bar":!e.isSearchBarExpanded}),onClick:f,onMouseOver:f,onFocus:m,onBlur:m,ref:o}))}}}]);