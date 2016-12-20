class PagesController < ApplicationController
  skip_before_action :authenticate_user!, only: [ :home, :styleguide ]

  def home
  end

  def styleguide
  end

  def test
  end
end
