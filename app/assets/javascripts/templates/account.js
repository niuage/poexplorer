(function() {
  var template = Handlebars.template, templates = Handlebars.templates = Handlebars.templates || {};
templates['account'] = template({"compiler":[5,">= 2.0.0"],"main":function(depth0,helpers,partials,data) {
  var helper, functionType="function", escapeExpression=this.escapeExpression;
  return "<span class=\"online-status\">\n  <a href=\"/accounts/"
    + escapeExpression(((helper = helpers.account || (depth0 && depth0.account)),(typeof helper === functionType ? helper.call(depth0, {"name":"account","hash":{},"data":data}) : helper)))
    + "\" class=\"account\" data-account=\""
    + escapeExpression(((helper = helpers.account || (depth0 && depth0.account)),(typeof helper === functionType ? helper.call(depth0, {"name":"account","hash":{},"data":data}) : helper)))
    + "\" target=\"_blank\">\n    <i class=\"fa fa-circle-o online-icon\"></i>\n    <span>"
    + escapeExpression(((helper = helpers.account || (depth0 && depth0.account)),(typeof helper === functionType ? helper.call(depth0, {"name":"account","hash":{},"data":data}) : helper)))
    + "</span>\n  </a>\n";
},"useData":true});
})();
