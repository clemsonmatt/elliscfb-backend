class Manage::ApplicationController < ApplicationController
  before_action :is_admin
end
