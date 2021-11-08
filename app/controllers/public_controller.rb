class PublicController < ApplicationController
  include SessionsHelper
  before_action :check_logged_in

  private

  def check_logged_in
    if logged_in?
      redirect_to :root
    end
  end
end