class Users::AboutController < ApplicationController
  def company
    @company = File.read(Rails.root.join("static", "company.md"))
  end

  def privacy
    @privacy = File.read(Rails.root.join("static", "privacy.md"))
  end

  def term
    @term = File.read(Rails.root.join("static", "term.md"))
  end

  def questions
    @questions = File.read(Rails.root.join("static", "questions.md"))
  end
end
