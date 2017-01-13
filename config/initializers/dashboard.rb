require 'matrix'

class Dashboard < ActiveRecord::Base
  def self.likes_color
    # '#5bc5f1'
    '#ffac87'
  end

  def self.comments_color
    # '#36ad7e'
    '#394696'
  end

  def self.chart_density_colors
    # ['#abfaa9', '#00bc66']
    [comments_color, '#ffffff']
  end

  def self.chart_density_vectors
    chart_density_begin_color = chart_density_colors.first
    chart_density_end_color   = chart_density_colors.last
    begin_color_vector = Vector[
      chart_density_begin_color[1..2].to_i(16),
      chart_density_begin_color[3..4].to_i(16),
      chart_density_begin_color[5..6].to_i(16)
    ]
    end_color_vector = Vector[
      chart_density_end_color[1..2].to_i(16),
      chart_density_end_color[3..4].to_i(16),
      chart_density_end_color[5..6].to_i(16)
    ]
    [begin_color_vector, end_color_vector]
  end

  def self.map_dataless_region_color
    '#122c42'
  end

  def self.countries_color
    likes_color
  end

  def self.departments_color
    comments_color
  end

  def self.business_color
    comments_color
  end

  def self.technology_color
    likes_color
  end

  def self.innovation_donuts_colors
    {
      # business_innovation:   '#52aa5e',
      business_innovation:   '#ffac87',
      # business_disruption:   '#388659',
      business_disruption:   '#9e6850',
      # technology_innovation: '#5bc5f1',
      technology_innovation: '#647afc',
      # technology_disruption: '#2e86ab'
      technology_disruption: '#394696'
    }
  end

  def self.bar_chart_colors(sample_size)
    [
      '#ffffff',
      likes_color,
      '#8896ff',
      comments_color
    ][0...sample_size]
  end
end
