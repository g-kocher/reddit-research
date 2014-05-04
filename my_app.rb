require 'bundler/setup'
require 'sinatra/base'
require 'sinatra/content_for'
require_relative 'reddit'



class MyApp < Sinatra::Base
	helpers Sinatra::ContentFor
	set :static, true
	set :public_folder, File.dirname(__FILE__) + '/static'



	#Root route
	get '/' do
		erb :index
	end

	# /subreddit/order
	get '/:subreddit/:order' do
		@subreddit = params[:subreddit]
		@order = params[:order]
		
		related = Reddit.new(@subreddit, @order)
		@subreddits = related.subreddits_array()

		content_for :title do
			"#{@subreddit}/#{@order}"
		end
		erb :results, :layout => !request.xhr?
	end
=begin
	# /subreddit/order.json
	get '/:subreddit/:order.json', '/:subreddit/:order/.json' do
		interested = Reddit.new()
=end
end

