module ApplicationHelper
  def stylesheet(*args)
    assets = filter_assets(args)
    content_for(:head) { stylesheet_link_tag(*assets) } unless assets.empty?
  end

  def javascript(*args)
    args = args.map { |arg| arg == :defaults ? arg : arg.to_s }
    content_for(:javascripts) { javascript_include_tag(*args) }
  end

  def body_classes
    "#{"#{@module_name} " if @module_name}c-#{controller.controller_name} a-#{controller.action_name} #{"signed_in" if user_signed_in?}"
  end

  def page_title(title = nil)
    content_for(:title, internal_title(title))
  end

  def _link_to_if condition, options, html_options={}, &block
    if condition
      link_to options, html_options, &block
    else
      capture &block
    end
  end

  private

  def internal_title(page_title = nil)
    poex = "PoExplorer.com"
    return "#{page_title.to_s} | #{poex}" if page_title.present?
    poex
  end

  def filter_assets assets
    @asset_map ||= {}
    includes = assets.reject do |a|
      @asset_map[a] = @asset_map.key?(a)
    end.map(&:to_s)
    includes.map{|i| i }.compact
  end

  def to_html(text)
    return "" unless text
    @markdown ||= Redcarpet::Markdown.new(Redcarpet::Render::HTML.new({
      filter_html: true,
      hard_wrap: true
    }), autolink: true)

    content_tag :div, class: "user-content" do
      @markdown.render(text).html_safe
    end
  end

  def current_page?(options)
    !!options.each { |k, v| return false unless params[k.to_s] == v }
  end

end
