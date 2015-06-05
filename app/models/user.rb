class User < ActiveRecord::Base
  has_and_belongs_to_many :watchlist, join_table: 'watchlists', class_name: 'Movie'
  has_and_belongs_to_many :movies_seen, join_table: 'movie_views', class_name: 'Movie'

  has_many :active_relationships, class_name:  'Relationship', foreign_key: 'follower_id', dependent: :destroy
  has_many :passive_relationships, class_name:  'Relationship', foreign_key: 'followed_id', dependent: :destroy
  has_many :following, through: :active_relationships, source: :followed
  has_many :followers, through: :passive_relationships, source: :follower

  enum sync_status: { default: 0, needs_to_sync: 1, syncing: 2, synced: 3 }

  scope :needs_to_sync, -> { where( sync_status: sync_statuses[:needs_to_sync]) }

  # Follows a user.
  def follow(other_user)
    active_relationships.create(followed_id: other_user.id)
  end

  # Unfollows a user.
  def unfollow(other_user)
    active_relationships.find_by(followed_id: other_user.id).destroy
  end

  # Returns true if the current user is following the other user.
  def following?(other_user)
    following.include?(other_user)
  end
end
