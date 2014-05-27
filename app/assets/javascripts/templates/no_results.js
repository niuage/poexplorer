(function() {
  var template = Handlebars.template, templates = Handlebars.templates = Handlebars.templates || {};
templates['no_results'] = template({"compiler":[5,">= 2.0.0"],"main":function(depth0,helpers,partials,data) {
  return "<div class=\"no-results\">\n  <h2>No results :(</h2>\n\n  <p class=\"text\">Try broadening your search, and make sure you're searching in the right category.</p>\n  <p>\n    <a href=\"/weapon_searches/new\">Weapons</a> &mdash;\n    <a href=\"/armour_searches/new\">Armours</a> &mdash;\n    <a href=\"/misc_searches/new\">Misc</a>\n  </p>\n</div>\n";
  },"useData":true});
})();
