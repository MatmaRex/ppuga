class RevisionsController < ApplicationController
expose(:phrase)
expose(:revisions) {phrase.revisions.includes(:author).order('created_at desc')}
expose(:revision)
  def index
  end

  def show
  end
end
