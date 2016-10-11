class ApplicationController < ActionController::Base
  session :session_key => '_exercisr_session_id'
  include AuthenticatedSystem
end
