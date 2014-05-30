(function() {
  var template = Handlebars.template, templates = Handlebars.templates = Handlebars.templates || {};
templates['item'] = template({"1":function(depth0,helpers,partials,data) {
  var helper, functionType="function", escapeExpression=this.escapeExpression;
  return "\n      <div class=\"item-icon w-"
    + escapeExpression(((helper = helpers.w || (depth0 && depth0.w)),(typeof helper === functionType ? helper.call(depth0, {"name":"w","hash":{},"data":data}) : helper)))
    + " h-"
    + escapeExpression(((helper = helpers.h || (depth0 && depth0.h)),(typeof helper === functionType ? helper.call(depth0, {"name":"h","hash":{},"data":data}) : helper)))
    + "\">\n        <img src=\""
    + escapeExpression(((helper = helpers.raw_icon || (depth0 && depth0.raw_icon)),(typeof helper === functionType ? helper.call(depth0, {"name":"raw_icon","hash":{},"data":data}) : helper)))
    + "\" alt=\"item icon\">\n        <div class=\"sockets\" data-sockets=\""
    + escapeExpression(((helper = helpers.sockets || (depth0 && depth0.sockets)),(typeof helper === functionType ? helper.call(depth0, {"name":"sockets","hash":{},"data":data}) : helper)))
    + "\"></div>\n      </div>\n    ";
},"3":function(depth0,helpers,partials,data) {
  var stack1, buffer = "\n  ";
  stack1 = helpers['with'].call(depth0, (depth0 && depth0.price_button), {"name":"with","hash":{},"fn":this.program(4, data),"inverse":this.noop,"data":data});
  if(stack1 || stack1 === 0) { buffer += stack1; }
  return buffer + "\n";
},"4":function(depth0,helpers,partials,data) {
  var helper, functionType="function", escapeExpression=this.escapeExpression;
  return "\n    <a class=\"btn "
    + escapeExpression(((helper = helpers.btn_class || (depth0 && depth0.btn_class)),(typeof helper === functionType ? helper.call(depth0, {"name":"btn_class","hash":{},"data":data}) : helper)))
    + " ttip price\" href=\"#\">\n      "
    + escapeExpression(((helper = helpers.price || (depth0 && depth0.price)),(typeof helper === functionType ? helper.call(depth0, {"name":"price","hash":{},"data":data}) : helper)))
    + " x <span class='orb "
    + escapeExpression(((helper = helpers.orb || (depth0 && depth0.orb)),(typeof helper === functionType ? helper.call(depth0, {"name":"orb","hash":{},"data":data}) : helper)))
    + "'>"
    + escapeExpression(((helper = helpers.orb || (depth0 && depth0.orb)),(typeof helper === functionType ? helper.call(depth0, {"name":"orb","hash":{},"data":data}) : helper)))
    + "</span>\n</a>  ";
},"6":function(depth0,helpers,partials,data) {
  var helper, functionType="function", escapeExpression=this.escapeExpression;
  return "\n  <a class=\"btn btn-warning "
    + escapeExpression(((helper = helpers.btn_class || (depth0 && depth0.btn_class)),(typeof helper === functionType ? helper.call(depth0, {"name":"btn_class","hash":{},"data":data}) : helper)))
    + " ttip verify\" data-container=\"body\" data-placement=\"top\" href=\"/items/"
    + escapeExpression(((helper = helpers.id || (depth0 && depth0.id)),(typeof helper === functionType ? helper.call(depth0, {"name":"id","hash":{},"data":data}) : helper)))
    + "/verify\" title=\"Verify this item\"><i class=\"fa fa-check\"></i></a>\n";
},"8":function(depth0,helpers,partials,data) {
  var helper, functionType="function", escapeExpression=this.escapeExpression;
  return "\n  <a class=\"send-pm btn "
    + escapeExpression(((helper = helpers.btn_class || (depth0 && depth0.btn_class)),(typeof helper === functionType ? helper.call(depth0, {"name":"btn_class","hash":{},"data":data}) : helper)))
    + "\" href=\"#\">\n    PM <i class=\"fa fa-comments-o\"></i>\n</a>";
},"10":function(depth0,helpers,partials,data) {
  var stack1, helper, functionType="function", escapeExpression=this.escapeExpression, buffer = "\n  "
    + escapeExpression(((helper = helpers.league_name || (depth0 && depth0.league_name)),(typeof helper === functionType ? helper.call(depth0, {"name":"league_name","hash":{},"data":data}) : helper)))
    + "\n\n  ";
  stack1 = helpers['if'].call(depth0, (depth0 && depth0.level), {"name":"if","hash":{},"fn":this.program(11, data),"inverse":this.noop,"data":data});
  if(stack1 || stack1 === 0) { buffer += stack1; }
  buffer += "\n\n  ";
  stack1 = helpers['if'].call(depth0, (depth0 && depth0.required_stats), {"name":"if","hash":{},"fn":this.program(13, data),"inverse":this.noop,"data":data});
  if(stack1 || stack1 === 0) { buffer += stack1; }
  buffer += "\n\n  ";
  stack1 = helpers['if'].call(depth0, (depth0 && depth0.quality), {"name":"if","hash":{},"fn":this.program(16, data),"inverse":this.noop,"data":data});
  if(stack1 || stack1 === 0) { buffer += stack1; }
  return buffer + "\n";
},"11":function(depth0,helpers,partials,data) {
  var helper, functionType="function", escapeExpression=this.escapeExpression;
  return "\n  &mdash;\n\n  <span data-sort=\"level\">\n    "
    + escapeExpression(((helper = helpers.requires_level || (depth0 && depth0.requires_level)),(typeof helper === functionType ? helper.call(depth0, {"name":"requires_level","hash":{},"data":data}) : helper)))
    + " "
    + escapeExpression(((helper = helpers.level || (depth0 && depth0.level)),(typeof helper === functionType ? helper.call(depth0, {"name":"level","hash":{},"data":data}) : helper)))
    + "\n  </span>\n  ";
},"13":function(depth0,helpers,partials,data) {
  var stack1, buffer = "\n    &mdash;\n\n    ";
  stack1 = helpers.each.call(depth0, (depth0 && depth0.required_stats), {"name":"each","hash":{},"fn":this.program(14, data),"inverse":this.noop,"data":data});
  if(stack1 || stack1 === 0) { buffer += stack1; }
  return buffer + "\n  ";
},"14":function(depth0,helpers,partials,data) {
  var helper, functionType="function", escapeExpression=this.escapeExpression;
  return "\n      <span class=\""
    + escapeExpression(((helper = helpers.stat || (depth0 && depth0.stat)),(typeof helper === functionType ? helper.call(depth0, {"name":"stat","hash":{},"data":data}) : helper)))
    + "\">\n        "
    + escapeExpression(((helper = helpers.value || (depth0 && depth0.value)),(typeof helper === functionType ? helper.call(depth0, {"name":"value","hash":{},"data":data}) : helper)))
    + " "
    + escapeExpression(((helper = helpers.stat || (depth0 && depth0.stat)),(typeof helper === functionType ? helper.call(depth0, {"name":"stat","hash":{},"data":data}) : helper)))
    + "\n      </span>\n    ";
},"16":function(depth0,helpers,partials,data) {
  var helper, functionType="function", escapeExpression=this.escapeExpression;
  return "\n    &mdash;\n\n    <span data-sort=\"quality\">\n      <b>+"
    + escapeExpression(((helper = helpers.quality || (depth0 && depth0.quality)),(typeof helper === functionType ? helper.call(depth0, {"name":"quality","hash":{},"data":data}) : helper)))
    + "%</b> Quality\n    </span>\n  ";
},"18":function(depth0,helpers,partials,data) {
  var stack1, buffer = "\n          <ul class=\"stats\">\n            ";
  stack1 = helpers.each.call(depth0, (depth0 && depth0.visible_stats), {"name":"each","hash":{},"fn":this.program(19, data),"inverse":this.noop,"data":data});
  if(stack1 || stack1 === 0) { buffer += stack1; }
  buffer += "\n            ";
  stack1 = helpers['if'].call(depth0, (depth0 && depth0.corrupted), {"name":"if","hash":{},"fn":this.program(21, data),"inverse":this.noop,"data":data});
  if(stack1 || stack1 === 0) { buffer += stack1; }
  return buffer + "\n          </ul>\n        ";
},"19":function(depth0,helpers,partials,data) {
  var helper, functionType="function", escapeExpression=this.escapeExpression;
  return "\n              <li data-mod=\""
    + escapeExpression(((helper = helpers.mod_id || (depth0 && depth0.mod_id)),(typeof helper === functionType ? helper.call(depth0, {"name":"mod_id","hash":{},"data":data}) : helper)))
    + "\" data-value=\""
    + escapeExpression(((helper = helpers.value || (depth0 && depth0.value)),(typeof helper === functionType ? helper.call(depth0, {"name":"value","hash":{},"data":data}) : helper)))
    + "\" class=\""
    + escapeExpression(((helper = helpers.klass || (depth0 && depth0.klass)),(typeof helper === functionType ? helper.call(depth0, {"name":"klass","hash":{},"data":data}) : helper)))
    + "\">\n                "
    + escapeExpression(((helper = helpers.name || (depth0 && depth0.name)),(typeof helper === functionType ? helper.call(depth0, {"name":"name","hash":{},"data":data}) : helper)))
    + "\n              </li>\n            ";
},"21":function(depth0,helpers,partials,data) {
  return "\n              <li class=\"corrupted\">Corrupted</li>\n            ";
  },"23":function(depth0,helpers,partials,data) {
  var helper, functionType="function", escapeExpression=this.escapeExpression;
  return "\n            <li data-"
    + escapeExpression(((helper = helpers.data_attr || (depth0 && depth0.data_attr)),(typeof helper === functionType ? helper.call(depth0, {"name":"data_attr","hash":{},"data":data}) : helper)))
    + "=\""
    + escapeExpression(((helper = helpers.meta_data || (depth0 && depth0.meta_data)),(typeof helper === functionType ? helper.call(depth0, {"name":"meta_data","hash":{},"data":data}) : helper)))
    + "\">\n              <span>"
    + escapeExpression(((helper = helpers.value || (depth0 && depth0.value)),(typeof helper === functionType ? helper.call(depth0, {"name":"value","hash":{},"data":data}) : helper)))
    + "</span> "
    + escapeExpression(((helper = helpers.name || (depth0 && depth0.name)),(typeof helper === functionType ? helper.call(depth0, {"name":"name","hash":{},"data":data}) : helper)))
    + "\n            </li>\n          ";
},"compiler":[5,">= 2.0.0"],"main":function(depth0,helpers,partials,data) {
  var stack1, helper, functionType="function", escapeExpression=this.escapeExpression, buffer = "<div class=\"result item bb bb-dark row-fluid\" data-item-type=\""
    + escapeExpression(((helper = helpers.item_type || (depth0 && depth0.item_type)),(typeof helper === functionType ? helper.call(depth0, {"name":"item_type","hash":{},"data":data}) : helper)))
    + "\" data-id=\""
    + escapeExpression(((helper = helpers.id || (depth0 && depth0.id)),(typeof helper === functionType ? helper.call(depth0, {"name":"id","hash":{},"data":data}) : helper)))
    + "\">\n  <div class=\"span2\">\n\n    ";
  stack1 = helpers['if'].call(depth0, (depth0 && depth0.raw_icon), {"name":"if","hash":{},"fn":this.program(1, data),"inverse":this.noop,"data":data});
  if(stack1 || stack1 === 0) { buffer += stack1; }
  buffer += "\n\n    <span class=\"faded small\">\n      <i class='fa fa-clock-o'></i>\n      <time datetime=\""
    + escapeExpression(((helper = helpers.indexed_at || (depth0 && depth0.indexed_at)),(typeof helper === functionType ? helper.call(depth0, {"name":"indexed_at","hash":{},"data":data}) : helper)))
    + "\"></time>\n    </span>\n  </div>\n\n  <div class=\"span10\">\n\n    <div class=\"row-fluid\">\n      <div class=\"span12\">\n        <div class=\"h2-title\">\n          <span class=\"small right\">\n            <div class=\"btn-toolbar\">\n              <div class=\"btn-group\">\n                ";
  stack1 = helpers['if'].call(depth0, (depth0 && depth0.price_button), {"name":"if","hash":{},"fn":this.program(3, data),"inverse":this.noop,"data":data});
  if(stack1 || stack1 === 0) { buffer += stack1; }
  buffer += "\n\n                ";
  stack1 = helpers['with'].call(depth0, (depth0 && depth0.verify_button), {"name":"with","hash":{},"fn":this.program(6, data),"inverse":this.noop,"data":data});
  if(stack1 || stack1 === 0) { buffer += stack1; }
  buffer += "\n\n              </div>\n\n              <div class=\"btn-group\">\n                ";
  stack1 = helpers['with'].call(depth0, (depth0 && depth0.pm_button), {"name":"with","hash":{},"fn":this.program(8, data),"inverse":this.noop,"data":data});
  if(stack1 || stack1 === 0) { buffer += stack1; }
  buffer += "\n\n              </div>\n            </div>\n          </span>\n          <h2>\n            <a href=\"http://www.pathofexile.com/forum/view-thread/"
    + escapeExpression(((helper = helpers.thread_id || (depth0 && depth0.thread_id)),(typeof helper === functionType ? helper.call(depth0, {"name":"thread_id","hash":{},"data":data}) : helper)))
    + "\" target=\"_blank\">\n              <span class=\""
    + escapeExpression(((helper = helpers.rarity_name || (depth0 && depth0.rarity_name)),(typeof helper === functionType ? helper.call(depth0, {"name":"rarity_name","hash":{},"data":data}) : helper)))
    + "\">\n                "
    + escapeExpression(((helper = helpers.full_name || (depth0 && depth0.full_name)),(typeof helper === functionType ? helper.call(depth0, {"name":"full_name","hash":{},"data":data}) : helper)))
    + "\n              </span>\n            </a>\n          </h2>\n        </div>\n      </div>\n    </div>\n\n    <p class=\"requirements\">\n      ";
  stack1 = helpers['with'].call(depth0, (depth0 && depth0.requirements), {"name":"with","hash":{},"fn":this.program(10, data),"inverse":this.noop,"data":data});
  if(stack1 || stack1 === 0) { buffer += stack1; }
  buffer += "\n\n    </p>\n\n    <div class=\"row-fluid section small-section\">\n\n      <div class=\"span8\">\n        ";
  stack1 = helpers.unless.call(depth0, (depth0 && depth0.isSkill), {"name":"unless","hash":{},"fn":this.program(18, data),"inverse":this.noop,"data":data});
  if(stack1 || stack1 === 0) { buffer += stack1; }
  buffer += "\n\n      </div>\n\n      <div class=\"span4\">\n        <ul class=\"props\">\n          ";
  stack1 = helpers.each.call(depth0, (depth0 && depth0.properties), {"name":"each","hash":{},"fn":this.program(23, data),"inverse":this.noop,"data":data});
  if(stack1 || stack1 === 0) { buffer += stack1; }
  buffer += "\n        </ul>\n\n      </div>\n\n    </div>\n\n    <hr>\n    <div class=\"row-fluid\">\n      <div class=\"span8\">\n        <p class=\"footer faded small\">\n        ";
  stack1 = ((helper = helpers.account || (depth0 && depth0.account)),(typeof helper === functionType ? helper.call(depth0, {"name":"account","hash":{},"data":data}) : helper));
  if(stack1 || stack1 === 0) { buffer += stack1; }
  return buffer + "\n        </p>\n      </div>\n      <div class=\"span4\">\n        <p class=\"footer\">\n          <a href=\"/items/"
    + escapeExpression(((helper = helpers.id || (depth0 && depth0.id)),(typeof helper === functionType ? helper.call(depth0, {"name":"id","hash":{},"data":data}) : helper)))
    + "\" target=\"_blank\">\n            <i class='fa fa-adjust'></i> Find similar items\n          </a>\n        </p>\n      </div>\n    </div>\n  </div>\n</div>\n";
},"useData":true});
})();