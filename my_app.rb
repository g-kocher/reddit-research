require 'bundler/setup'
require 'sinatra/base'
require 'sinatra/content_for'



class MyApp < Sinatra::Base
	helper Sinatra::ContentFor
	set :static, true
	set :public_folder, File.dirname(__FILE__) + '/static'



	#Root route
	get '/' do
		erb :index
	end

	post '/:subreddit/:order' do
		subreddits(params[subreddit],params[order])
		erb :results, :layout => !request.xhr?
	end	

end

