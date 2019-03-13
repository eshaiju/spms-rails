# frozen_string_literal: true

Swagger::Docs::Config.base_api_controller = ActionController::Base
Swagger::Docs::Config.register_apis(
  '1.0' => {
    api_file_path: 'public/',
    # do not forget to change this when not running in development mode
    base_path: ENV['HOST_URL'],
    clean_directory: true,
    base_api_controller: ActionController::Base,
    attributes: {
      info: {
        'title' => 'SPMS',
        'description' => 'SPMS Documentation'
      }
    }
  }
)
