# frozen_string_literal: true

class BaseSerializer
  include FastJsonapi::ObjectSerializer

  def self.include_model?(params, model)
    params[:include].present? && params[:include].include?(model)
  end
end
