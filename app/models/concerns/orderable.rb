## Written by: https://gist.github.com/mamantoha/9c0aec7958c7636cebef

module Orderable
  extend ActiveSupport::Concern

  # A list of the param names that can be used for ordering the model list
  def ordering_params(params)
  # GET /api/v1/experiences?sort=-price,created_at
    ordering = {}
    if params[:sort]
      sort_order = { '+' => :asc, '-' => :desc }
      sorted_params = params[:sort].split(',')
      sorted_params.each do |attr|
        sort_sign = (attr =~ /\A[+-]/) ? attr.slice!(0) : '+'
        model = controller_name.titlecase.singularize.constantize
        if model.attribute_names.include?(attr)
          ordering[attr] = sort_order[sort_sign]
        end
      end
    end

    # default order of created_at desc unless otherwise specified..
    unless ordering.include?("created_at")
      ordering["created_at"] = :desc
    end

    return ordering
  end
end
