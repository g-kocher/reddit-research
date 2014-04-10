require 'HTTParty'
require 'json'

# Similar subreddits returned based on author posts (and comments to come later).
# This should help with market research.

# Example
# Say I'm interested in learning about alternative energy
# I would enter RenewableEnergy
# This will crawl the most recent posts and
# return other groups the authors have posted in.


# LIST OF THINGS TO BE DONE LATER
# should add a counter for number of calls to pace the work.
# should add ability to look further back than first 20

# Grab some input (which subreddit, how many posts, --how to sort)


puts "Which subreddit?"
subreddit = gets.chomp

puts "How many? (1-100)"
n_posts = gets.chomp

base_url = "http://api.reddit.com"
subreddit = "/r/" + subreddit
url = base_url + subreddit + "/new.json?limit=" + n_posts

# Grab the last n_posts
reddit_posts = HTTParty.get(url)
reddit_json = JSON.parse(reddit_posts.body)

# Create a hash of post_authors hash with the number of users and count of posts
post_authors = Hash.new(0)
posts = reddit_json['data']['children']
posts.each {|post| post_authors[post['data']['author']] += 1}

# Sort and print 
post_authors = post_authors.sort_by {|k, v| v}
post_authors.reverse!
post_authors.each {|author, times|
	puts "#{author} has posted #{times.to_s} in this sample."}

# Count number of total
number_of_posts = 0
post_authors.each {|author, times| number_of_posts += times}
puts ""
puts "There were a total of #{post_authors.count} authors"
puts ""
puts "A total of #{number_of_posts} were returned, #{n_posts} were requested."



# Next step, iterate through the post authors
# post_authors.each