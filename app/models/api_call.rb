# == Schema Information
#
# Table name: api_calls
#
#  id            :bigint           not null, primary key
#  data          :text
#  method        :integer
#  origin        :integer
#  response_code :string
#  response_data :text
#  response_size :bigint
#  response_time :integer
#  url           :string
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#
class ApiCall < ApplicationRecord
  enum method: %i[get post del]
  enum origin: %i[cron user]
  # paginates_per 100. agregar pagy.
  ransack_alias :searchable_content, :url_or_response_code_or_response_data
end
