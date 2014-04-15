# Similar subreddits returned based on author posts (and comments to come later).
# This should help with market research.

# Example
# Say I'm interested in learning about alternative energy
# I would enter RenewableEnergy
# This will crawl the most recent posts and
# return other groups the authors have posted in.


# LIST OF THINGS TO BE DONE LATER
# should add a counter for API calls to pace the work.
# should add ability to look further back than first 100

class Subreddit

	require 'HTTParty'
	require 'json'

	def initialize(name)
		@name = name
	end


	def get_users(n)
		#subreddit (str) is the subreddit to be studied
		#n (int) is the number of posts to analyze -- this will be removed when I can get all
		#returns an array of users ["user1", "user2", ...]
		base_url = "http://api.reddit.com"
		subreddit = "/r/" + @name
		url = base_url + subreddit + "/new.json?limit=" + n.to_s

		# Grab the last n_posts
		reddit_json = HTTParty.get(url)
		reddit_hash = JSON.parse(reddit_json.body, :symbolize_names => true)

		# Create a hash of post_authors with the number of users and count of posts
		post_authors = Hash.new(0)
		posts = reddit_hash[:data][:children]
		posts.each {|post| post_authors[post[:data][:author].to_sym] += 1}

		# remove deleted users
		post_authors.delete_if {|k, v| k == :'[deleted]'}

		#sort
		post_authors = post_authors.sort_by {|k, v| v}
		post_authors.reverse!

		authors_array = []
		post_authors.each{|a| authors_array << a[0]}

		#return the array
		puts "Author Array Complete"
		return authors_array
	end
	# Test for get_contributors
	#test_users = get_users("gaybrosgonewild", 20)
	#puts test_users

	def get_user_posts(user)
		# contributor (sym) is the user name of the contributor to a subreddit
		# returns a hash of the user's posts
		base_url = "http://api.reddit.com"
		url = "#{base_url}/user/#{user}/submitted/new.json?limit=100"
		response = HTTParty.get(url)

		subreddit_hash = Hash.new(0)

		if response.code == 200
			data = JSON.parse(response.body, :symbolize_names => true)

			# Go through the posts and count number of posts per subreddit
			data[:data][:children].each do |post|
				subreddit = post[:data][:subreddit].to_sym
				subreddit_hash[subreddit] += 1
			end
		end
		return subreddit_hash
	end
	# Test for get_posts_of_contributor
	#test_user_reddits = get_user_posts(test_users[3])
	#test_user_reddits.each do |k, v|
	#	puts "#{k} has #{v} posts."
	#end

	@@subreddit_posts = Hash.new(0)  #these need to be in a class to work with the method
	@@subreddit_users = Hash.new(0)

	def get_subreddits(n)
		users = get_users(n)
		posts = []

		users.each do |user|
			posts << get_user_posts(user)
		end

		posts.each do |post|
			post.each_key do |key|
				@@subreddit_users[key.to_sym] += 1
				@@subreddit_posts[key.to_sym] += post[key]
			end
		end

		subreddits = []

		@@subreddit_users.each_key do |k|
			user_count = @@subreddit_users[k]
			post_count  = @@subreddit_posts[k]

			subreddits << [k, user_count, post_count]
			subreddits = subreddits.sort_by {|s, u, p| u}
			subreddits.reverse!
		end

		return subreddits
	end


end

renewableEnergy = Subreddit.new("renewableenergy")
who = renewableEnergy.get_users(10)
puts who

which = renewableEnergy.get_subreddits(100)
which.each do |subreddit, users, posts|
	puts "#{subreddit} has #{posts} posts from #{users} users."
end


=begin
recent_users = get_users('renewableenergy', 5)

user_posts = []
recent_users.each {|user| user_posts << get_user_posts(user)}


user_posts.each {|posts, user| get_subreddits(posts, user)}

subreddit_posts.each do |k, v|
	puts "#{k} has #{v} posts."
end

puts "===================================="

subreddit_users.each do |k, v|
	puts "#{k} has #{v} users"
end
=end