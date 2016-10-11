require 'digest/sha1'

# this model expects a certain database layout and its based on the name/login pattern.
class User < ActiveRecord::Base
  has_and_belongs_to_many :notify_contents, :class_name => 'Content',
    :join_table => 'notifications', :foreign_key => 'notify_user_id',
    :association_foreign_key => 'notify_content_id', :uniq => true

  has_many :articles, :order => 'created_at DESC' do
    def published
      find_published(:all, :order => 'created_at DESC')
    end
  end

  # echo "typo" | sha1sum -
  @@salt = '20ac4d290c2293702c64b3b287ae5ea79b26a5c1'
  cattr_accessor :salt

  # Authenticate a user.
  #
  # Example:
  #   @user = User.authenticate('bob', 'bobpass')
  #
  def self.authenticate(login, pass)
    find_first(["login = ? AND password = ?", login, sha1(pass)])
  end

  def self.authenticate?(login, pass)
    user = self.authenticate(login, pass)
    return false if user.nil?
    return true if user.login == login

    false
  end

  def self.find_by_permalink(permalink)
    self.find_by_login(permalink)
  end

  # Let's be lazy, no need to fetch the counters, rails will handle it.
  def self.find_all_with_article_counters(ignored_arg)
    find(:all)
  end

  def self.to_prefix
    'author'
  end

  def password=(newpass)
    @password = newpass
  end

  def password(cleartext = nil)
    if cleartext
      @password.to_s
    else
      @password || read_attribute("password")
    end
  end

  def article_counter
    articles.size
  end

  def display_name
    name
  end

  def permalink
    login
  end

  protected

  # Apply SHA1 encryption to the supplied password.
  # We will additionally surround the password with a salt
  # for additional security.
  def self.sha1(pass)
    Digest::SHA1.hexdigest("#{salt}--#{pass}--")
  end

  before_create :crypt_password

  # Before saving the record to database we will crypt the password
  # using SHA1.
  # We never store the actual password in the DB.
  def crypt_password
    write_attribute "password", self.class.sha1(password(true))
    @password = nil
  end

  before_update :crypt_unless_empty

  # If the record is updated we will check if the password is empty.
  # If its empty we assume that the user didn't want to change his
  # password and just reset it to the old value.
  def crypt_unless_empty
    if password(true).empty?
      user = self.class.find(self.id)
      self.password = user.password
    else
      write_attribute "password", self.class.sha1(password(true))
      @password = nil
    end
  end

  validates_uniqueness_of :login, :on => :create
  validates_length_of :password, :within => 5..40, :on => :create
  validates_presence_of :login

  validates_confirmation_of :password, :if=> Proc.new { |u| u.password.size > 0}
  validates_length_of :login, :within => 3..40
end
