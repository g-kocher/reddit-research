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


require 'HTTParty'
require 'json'


def get_users(subreddit, n)
	#subreddit (str) is the subreddit to be studied
	#n (int) is the number of posts to analyze -- this will be removed when I can get all
	#returns an array of users ["user1", "user2", ...]
	base_url = "http://api.reddit.com"
	subreddit = "/r/" + subreddit
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
	return authors_array
end
# Test for get_contributors
puts get_users("gaybrosgonewild", 20)

def get_user_posts(user)
	# contributor (sym) is the user name of the contributor to a subreddit
	# returns a hash of the user's posts
	base_url = "http://api.reddit.com"
	url = "#{base_url}/user/#{user}/submitted/new.json?limit=100"
	response = HTTParty.get(url)
	if response.code == 200
		data = JSON.parse(response.body, :symbolize_names => true)
	end

	# Go through the posts and build a hash of hashes
	# subreddit[:subreddit][:posts]=count  subreddit[:subreddit][:authors]={}
	subreddit_hash = Hash.new(0)
	data[:data][:children].each do |post|
		subreddit = post[:data][:subreddit].to_sym
		subreddit_hash[subreddit] += 1
	end

	return subreddit_hash
end
# Test for get_posts_of_contributor
puts get_user_posts(get_users("gaybrosgonewild", 30)[3]).each {|k, v| 
	"#{k} has #{v} posts."}

