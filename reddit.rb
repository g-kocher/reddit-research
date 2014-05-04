class Reddit
	require 'typhoeus'
	require 'json'

	@@base_url = "http://api.reddit.com/"


	def initialize(subreddit, order)
		@subreddit_url = "#{@@base_url}r/#{subreddit}/#{order}.json?limit=100&t=all"
	end

	def subreddits_array()
		users = get_users()
		related = get_subreddits(users)
		return related
	end
=begin
	def subreddits_json()
		users = 
	end
=end
	private
	def get_users()
		#collect the users in an array
		response = Typhoeus.get(@subreddit_url)
		if response.code == 200
			data = JSON.parse(response.body, :symbolize_names => true)
			posts = data[:data][:children]
			users = []
			posts.each  {|post| users << post[:data][:author]}
			users.delete_if {|user| user == ':[deleted]' }
			users.uniq!
			return users
		end
	end

	def get_subreddits(u)
		#collect the subreddits of those users
		subreddits = Hash.new(0)
		users = u

		hydra = Typhoeus::Hydra.hydra

		i=0
		request=[]
		users.each do |user|
			url = "#{@@base_url}user/#{user}/submitted/new.json?limit=100"
			request[i] = Typhoeus::Request.new(url)
			hydra.queue(request[i])
			request[i].on_complete do |response|
				if response.code == 200
					data = JSON.parse(response.body, :symbolize_names => true)
				
					user_subreddits = []
					# Go through the posts and count number of posts per subreddit
					data[:data][:children].each do |post|
						user_subreddits << post[:data][:subreddit]
					end
					user_subreddits.uniq!
					user_subreddits.each do |sr|
						subreddits[sr] += 1
					end
				end
			end
			i += 1
		end
		hydra.run
		subreddits = subreddits.sort_by {|k,v| v}.reverse
		return subreddits
	end
end
