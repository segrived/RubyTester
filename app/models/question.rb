class Question
  include Mongoid::Document
  include Mongoid::Timestamps

  field :text, type: String
  field :type, type: String # TODO: replace with symbol
  field :variants, type: Array
  field :answer, type: Array

  belongs_to :test

  # Возвращает count случайных воросов из теста test
  def self.get_random_ids(test, count)
    Question.where(test: test).only(:_id).shuffle.take(count).map(&:_id)
  end

  def answer_as_text
    case type
    when "onechoice"
      variants[answer]
    when "multiplechoice"
      answer.map { |a| variants[a] }.join("; ")
    end
  end
end
