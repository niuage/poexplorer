class BuildDecorator < ApplicationDecorator
  delegate_all

  delegate :disqus_id,
    :main_gear_gems, :klass_names, :unique_names,
    :username,
    to: :model

  def summary
    model.summary.presence || "Build summary"
  end

  def description
    model.description.presence || "Build description"
  end

  def played_as
    classes = model.klasses.map { |c| c.name }.to_sentence
    classes.present? ? "Can be played as #{classes}" : "n/a"
  end

  def video
    return unless video_url.present?
    h.link_to "The build in action", video_url
  end

  def votes
    model.votes || 0
  end

  def user_login
    user.login
  end

  def leagues
    leagues = []
    leagues << "softcore" if softcore
    leagues << "hardcore" if hardcore
    leagues << "softcore" if leagues.empty?
    leagues.to_sentence
  end

  def viable_leagues
    "Viable for #{leagues}"
  end

  def to_param
    "#{id}-#{title.parameterize}"
  end

  def unique_sentence
    unique_names.try(:to_sentence).presence || nil
  end

  def klass_sentence
    klass_names.try(:to_sentence, { two_words_connector: " or ", last_word_connector: ", or " }).presence || nil
  end

  def gem_sentence
    return unless (gems = main_gear_gems) && !gems.empty?
    h.content_tag :span do
      gems.map do |g|
        h.content_tag(:span, g[0], class: "#{g[1]} support_#{g[2]} #{ "tag" if g[2] == false }")
      end.join(", ").html_safe
    end
  end
end

