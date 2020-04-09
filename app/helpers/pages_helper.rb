module PagesHelper
  def category_options_array
    Rails.cache.fetch(:category_options_array, expires_in: 24.hours) do
      Category.with_businesses.pluck(:id, :display_name)
    end
  end
end
