class ViewLayout < ApplicationDecorator
  SIZES = {
    large:  { param: "l", name: "Large layout", ico: :l_layout },
    small:  { param: "s", name: "Small layout", ico: :s_layout }
  }

  TIMES = {
    day:   { param: "day",   name: "Day",   ico: :day_layout },
    night: { param: "night", name: "Night", ico: :night_layout }
  }

  attr_accessor :size, :time, :session, :params

  def initialize size = SIZES[:large][:param], time = TIME[:day][:param], params = {}
    @session = {}
    @params = params
    self.size = valid_size? ? params[:layout] : size
    self.time = valid_time? ? params[:layout] : time
  end

  def to_s
    SIZES[@size][:param]
  end

  def to_class
    "layout_#{self}"
  end

  def sizes; SIZES end
  def times; TIMES end

  def size=(size)
    layout_size = SIZES.find { |k,v| v[:param] == size.to_s }
    @size = layout_size.try :[], 0
    @size = @size.presence || :large
    session[:layout_size] = SIZES[@size][:param]
  end

  def time=(time)
    layout_time = TIMES.find { |k,v| v[:param] == time.to_s }
    @time = layout_time.try :[], 0
    @time = @time.presence || :day
    session[:layout_time] = TIMES[@time][:param]
  end

  def layout_size
    session[:layout_size]
  end

  def layout_time
    session[:layout_time]
  end

  def valid_size?; params[:layout].in?(["l", "s"]) end
  def valid_time?; params[:layout].in?(["night", "day"]) end

  def size? size
    @size == size
  end

  def time? time
    @time == time
  end

  SIZES.each do |k, v|
    define_method "#{k.to_s}?" do
      self.size == k
    end
  end

  TIMES.each do |k, v|
    define_method "#{k.to_s}?" do
      self.time == k
    end
  end

  def buttons
    buttons = ""
    (sizes.merge(times)).each do |k, l|
      buttons += h.content_tag :li do
        h.link_to(h.url_for((@params).merge layout: l[:param]),
          class: "ttip ico ir view_layout #{l[:ico]} #{ "current" if size?(k) || time?(k) }") do
          (l[:name] + h.content_tag(:span, "", class: "ico #{l[:ico]}")).html_safe
        end
      end
    end
    h.content_tag :ul, class: "layouts" do
      buttons.html_safe
    end
  end

end
