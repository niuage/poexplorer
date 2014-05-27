(function() {
  var template = Handlebars.template, templates = Handlebars.templates = Handlebars.templates || {};
templates['facet'] = template({"1":function(depth0,helpers,partials,data) {
  var stack1, helper, functionType="function", escapeExpression=this.escapeExpression, buffer = "\n<div class=\"facet\" data-name=\""
    + escapeExpression(((helper = helpers.name || (depth0 && depth0.name)),(typeof helper === functionType ? helper.call(depth0, {"name":"name","hash":{},"data":data}) : helper)))
    + "\">\n  <h3>\n    ";
  stack1 = helpers['if'].call(depth0, (depth0 && depth0.resetable), {"name":"if","hash":{},"fn":this.program(2, data),"inverse":this.noop,"data":data});
  if(stack1 || stack1 === 0) { buffer += stack1; }
  buffer += "\n\n    "
    + escapeExpression(((helper = helpers.title || (depth0 && depth0.title)),(typeof helper === functionType ? helper.call(depth0, {"name":"title","hash":{},"data":data}) : helper)))
    + "\n  </h3>\n  <ul>\n    ";
  stack1 = helpers.each.call(depth0, (depth0 && depth0.terms), {"name":"each","hash":{},"fn":this.program(4, data),"inverse":this.noop,"data":data});
  if(stack1 || stack1 === 0) { buffer += stack1; }
  return buffer + "\n  </ul>\n</div>\n";
},"2":function(depth0,helpers,partials,data) {
  var helper, functionType="function", escapeExpression=this.escapeExpression;
  return "\n      <a class=\"reset-facet "
    + escapeExpression(((helper = helpers.reset_on || (depth0 && depth0.reset_on)),(typeof helper === functionType ? helper.call(depth0, {"name":"reset_on","hash":{},"data":data}) : helper)))
    + "\" href=\"#\">reset</a>\n    ";
},"4":function(depth0,helpers,partials,data) {
  var helper, functionType="function", escapeExpression=this.escapeExpression;
  return "\n      <li>\n        <a href=\"#\">\n          <span class=\"facet-title\">\n            <span class=\"right small tag\">\n              "
    + escapeExpression(((helper = helpers.count || (depth0 && depth0.count)),(typeof helper === functionType ? helper.call(depth0, {"name":"count","hash":{},"data":data}) : helper)))
    + "\n            </span>\n            <span class=\"facet-name\">"
    + escapeExpression(((helper = helpers.title || (depth0 && depth0.title)),(typeof helper === functionType ? helper.call(depth0, {"name":"title","hash":{},"data":data}) : helper)))
    + "</span>\n          </span>\n</a>      </li>\n    ";
},"compiler":[5,">= 2.0.0"],"main":function(depth0,helpers,partials,data) {
  var stack1, buffer = "";
  stack1 = helpers['if'].call(depth0, (depth0 && depth0.terms), {"name":"if","hash":{},"fn":this.program(1, data),"inverse":this.noop,"data":data});
  if(stack1 || stack1 === 0) { buffer += stack1; }
  return buffer + "\n";
},"useData":true});
})();
