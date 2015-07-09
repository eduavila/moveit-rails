class ApiController < ActionController::API
	include AbstractController::Translation
	include ActionController::ImplicitRender
	include ActionController::Helpers
end
