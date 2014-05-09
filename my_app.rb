require 'bundler/setup'
require 'sinatra/base'
require 'sinatra/content_for'
require_relative 'models/reddit'







class MyApp < Sinatra::Base
	helpers Sinatra::ContentFor
	set :static, true
	set :public_folder, File.dirname(__FILE__) + '/static'



	#Root route
	get '/' do
		haml :index
	end


	# /subreddit/order    
	get %r{/(\w{3,})\/(new|top|rising)} do
		@subreddit = params[:captures][0]
		@order = params[:captures][1]
		@subreddits = Reddit.new(@subreddit, @order).subreddits_array()
		haml :results
	end

	get %r{/(\w{3,})} do
		@subreddit = params[:captures][0]
		redirect to("#{@subreddit}/new")
	end


	error 404 do
		redirect to('/')
	end

end

