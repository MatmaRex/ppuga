# encoding: utf-8
class PhrasesController < ApplicationController
	require 'wikipedia'
	before_filter :authenticate_author!, :except => [:show, :search, :index, :wikishow]
	expose(:phrase)
	expose(:phrases) {
		if !params[:search].nil?
				p = Phrase.search {
					fulltext params[:search] do
					phrase_fields :title => 5.0
					phrase_fields :description => 3.0
					phrase_slop 1
					end
					with :published, true
				}
			p.results
		else
			Phrase.order(:title)
		end
	}
	expose(:wikiphrases) {
		Wikipedia.search(params[:search])
	}
	expose(:wikiphrase) {
		Wikipedia.show(params[:title])
	}

	respond_to :html
	def search
		if params[:naked] == '1'
			render :layout => false
		end
	end

	def create
		if phrase.save
			revision = Revision.from_phrase(phrase)
			revision.author_id = current_author.id
			revision.save
			flash[:notice] = "Dodano frazę."
		end
		respond_with phrase
	end

	def update
		if phrase.save
			revision = Revision.from_phrase(phrase)
			revision.author_id = current_author.id
			revision.save
			flash[:notice] = "Zaktualizowano frazę."
		end
		respond_with phrase
	end

	def destroy
		revision = Revision.from_phrase(phrase)
		revision.author_id = current_author.id
		revision.save
		phrase.destroy
		flash[:notice] = "Usunięto frazę."
		redirect_to homepage_path
	end

	def wikishow
	end
end
