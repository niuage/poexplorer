(function() {
  var template = Handlebars.template, templates = Handlebars.templates = Handlebars.templates || {};
templates['pagination'] = template({"1":function(depth0,helpers,partials,data) {
  var helper, functionType="function", escapeExpression=this.escapeExpression;
  return "\n      <a href=\"\" id=\"previous-page\" class=\"span12 nav-link text-center\" data-page=\""
    + escapeExpression(((helper = helpers.previousPage || (depth0 && depth0.previousPage)),(typeof helper === functionType ? helper.call(depth0, {"name":"previousPage","hash":{},"data":data}) : helper)))
    + "\">\n        <span class=\"page\"><i class=\"fa fa-caret-left\"></i> Prev</span>\n      </a>\n    ";
},"3":function(depth0,helpers,partials,data) {
  return "\n      <div class=\"nav-link faded text-center\">Prev</div>\n    ";
  },"5":function(depth0,helpers,partials,data) {
  var helper, functionType="function", escapeExpression=this.escapeExpression;
  return "\n      <a href=\"\" id=\"next-page\" class=\"span12 nav-link text-center\" data-page=\""
    + escapeExpression(((helper = helpers.nextPage || (depth0 && depth0.nextPage)),(typeof helper === functionType ? helper.call(depth0, {"name":"nextPage","hash":{},"data":data}) : helper)))
    + "\">\n        <span class=\"page\">Next <i class=\"fa fa-caret-right\"></i></span>\n      </a>\n    ";
},"compiler":[5,">= 2.0.0"],"main":function(depth0,helpers,partials,data) {
  var stack1, helper, functionType="function", escapeExpression=this.escapeExpression, buffer = "<div class=\"pagination-bar ajax row-fluid\">\n  <div class=\"ajax-pagination\">\n  <div class=\"span2\">\n    ";
  stack1 = helpers['if'].call(depth0, (depth0 && depth0.previousPage), {"name":"if","hash":{},"fn":this.program(1, data),"inverse":this.program(3, data),"data":data});
  if(stack1 || stack1 === 0) { buffer += stack1; }
  buffer += "\n  </div>\n\n  <div class=\"span8 text-center faded\">\n    Page "
    + escapeExpression(((helper = helpers.currentPage || (depth0 && depth0.currentPage)),(typeof helper === functionType ? helper.call(depth0, {"name":"currentPage","hash":{},"data":data}) : helper)))
    + "/"
    + escapeExpression(((helper = helpers.totalPageCount || (depth0 && depth0.totalPageCount)),(typeof helper === functionType ? helper.call(depth0, {"name":"totalPageCount","hash":{},"data":data}) : helper)))
    + " &mdash; "
    + escapeExpression(((helper = helpers.totalCount || (depth0 && depth0.totalCount)),(typeof helper === functionType ? helper.call(depth0, {"name":"totalCount","hash":{},"data":data}) : helper)))
    + " results\n  </div>\n\n\n  <div class=\"span2\">\n    ";
  stack1 = helpers['if'].call(depth0, (depth0 && depth0.nextPage), {"name":"if","hash":{},"fn":this.program(5, data),"inverse":this.noop,"data":data});
  if(stack1 || stack1 === 0) { buffer += stack1; }
  return buffer + "\n  </div>\n  </div>\n</div>\n";
},"useData":true});
})();
