class ViewLayout < ApplicationDecorator
  SIZES = {
    large:  { param: "l", name: "Large layout", ico: "fa-list-ul" },
    small:  { param: "s", name: "Small layout", ico: "fa-list" }
  }

  TIMES = {
    day:   { param: "day",   name: "Day",   ico: "fa-lightbulb-o" },
    night: { param: "night", name: "Night", ico: "fa-moon-o" }
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

    {
      size: sizes,
      time: times
    }.each do |type, layouts|
      layouts.each do |name, layout|

        klasses = ["view-layout"]
        klasses << "current" if size?(name) || time?(name)

        buttons += h.content_tag :li do
          h.link_to(h.url_for((@params).merge layout: layout[:param]),
            class: klasses,
            data: { layout: layout[:param], type: type }) do
            "<i class='fa #{layout[:ico]}'></i>".html_safe
          end
        end

      end
    end

    h.content_tag :ul, class: "layouts" do
      buttons.html_safe
    end
  end

end
