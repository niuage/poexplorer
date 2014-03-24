class ShopDecorator < ApplicationDecorator
  delegate_all

  alias_method :source, :model

  def title(truncate = false)
    t = source.title.present? ? source.title :
      (source.processing ? "Waiting to be processed..." : "Invalid...")
    truncate ? h.truncate(t, length: 60) : t
  end

  def status_classes
    classes = []
    classes << "invalid" if is_invalid
    classes << "processing" if processing
    classes.join(" ")
  end

  def stats
    h.content_tag :ul, class: "stats clearfix" do
      [:weapon, :armour, :misc].map do |type|
        h.content_tag :li, class: type do
          h.pluralize(source.send(:"#{type}_count"), type.to_s)
        end
      end.join("").html_safe
    end
  end

  def username
    %Q{
      #{online_status}
      in #{source.league.try(:name)}
    }.html_safe
  end

  def online_status
    return unless source.username.present?
    h.content_tag :span, class: "online-status" do
      h.link_to(h.player_path(source.username),
                class: "account",
                data: { account: source.username }) do
        h.content_tag(:i, "", class: "icon-circle-blank online-icon") + " " + \
        h.content_tag(:span, source.username)
      end
    end
  end

  def indexed_at
    return "" unless source.indexed_at
    "<i class='icon-refresh'></i> Indexed ".html_safe << h.content_tag(:time, source.indexed_at, datetime: source.indexed_at.iso8601)
  end

  def last_updated_at
    return "" unless source.last_updated_at
    "<i class='icon-time'></i> Thread updated ".html_safe << h.content_tag(:time, source.last_updated_at, datetime: source.last_updated_at.iso8601)
  end

  def thread_url
    "http://pathofexile.com/forum/view-thread/#{source.thread_id}"
  end

  def delete_button
    h.link_to h.shop_path(source.id), class: "btn btn-danger", method: :delete, confirm: "Are you sure?" do
      "<i class='icon-remove-circle icon-white'></i> Delete".html_safe
    end
  end

  def small_delete_button
    h.link_to h.shop_path(source.id),
      class: "btn btn-danger ttip right",
      title: "Delete this shop",
      method: :delete,
      confirm: "Are you sure?" do
      "<i class='icon-remove-circle icon-white'></i>".html_safe
    end
  end

  def link_to_shop
    h.link_to title, ""
  end

  def open_thread_button
    h.link_to thread_url, class: "btn btn-info right", target: "_blank" do
      "<i class='icon-share icon-white'></i> View thread".html_safe
    end
  end
end
