class Question
  include Mongoid::Document
  include Mongoid::Timestamps

  field :text, type: String
  field :type, type: String
  field :variants, type: Array
  field :answer, type: Array

  belongs_to :test

  def self.get_random_ids(test, count)
    Question.where(test: test).only(:_id).shuffle.take(count).map(&:_id)
  end
end
