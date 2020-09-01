class Admin::BaseController < ApplicationController
  before_action :check_logged_in, :check_admin

  layout "layouts/admin"
end
