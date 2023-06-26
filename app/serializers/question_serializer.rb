class QuestionSerializer
  def initialize(question)
    @question = question
  end

  def serialize
    {
      id: @question.id,
      que: @question.que
    }
  end
end
