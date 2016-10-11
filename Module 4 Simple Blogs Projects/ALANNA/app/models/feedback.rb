class Feedback < Content
  # Empty, for now, ready to hoist up methods from Comment & Trackback
  include TypoGuid
  validates_age_of :article_id

  def self.default_order
    'created_at ASC'
  end

  def initialize(*args, &block)
    super(*args, &block)
    self.state = ContentState::Unclassified.instance
  end

  def location(anchor=:ignored, only_path=true)
    blog.url_for(article, "#{self.class.to_s.downcase}-#{id}", only_path)
  end

  before_create :create_guid, :make_nofollow, :article_allows_this_feedback
  before_save :correct_url

  def correct_url
    if !url.blank? && url !~ /^http:\/\//
      self.url = 'http://' + url
    end
  end

  def article_allows_this_feedback
    article && blog_allows_feedback? && article_allows_feedback?
  end

  def blog_allows_feedback?
    true
  end

  def akismet_options
    {:user_ip => ip,
      :comment_type => self.class.to_s.downcase,
      :comment_author => originator,
      :comment_author_email => email,
      :comment_author_url => url,
      :comment_content => body}.merge(additional_akismet_options)
  end

  def additional_akismet_options
    { }
  end

  def spam_fields
    [:title, :body, :ip, :url]
  end

  def spam?
    state.is_spam?(self)
  end

  def status_confirmed?
    state.status_confirmed?(self)
  end

  # is_spam? checks to see if this is spam.
  #
  # options are passed on to Akismet.  Recommended options (when available) are:
  #
  #  :permalink => the article's URL
  #  :user_agent => the poster's UserAgent string
  #  :referer => the poster's Referer string
  #

  def is_spam?(options={})
    return false unless blog.sp_global
    sp_is_spam?(options) || akismet_is_spam?(options)
  end

  def classify
    return :ham unless blog.sp_global
    test_result = is_spam?

    # Yeah, three state logic is evil...
    case is_spam?
    when nil; :spam
    when true; :spam
    when false; :ham
    end
  end

  def sp_is_spam?(options={})
    sp = SpamProtection.new(blog)
    spam_fields.any? do |field|
      sp.is_spam?(self.send(field))
    end
  end

  def akismet
    Akismet.new(blog.sp_akismet_key, blog.canonical_server_url)
  end

  def akismet_is_spam?(options={})
    return false if blog.sp_akismet_key.blank?
    begin
      Timeout.timeout(5) do
        akismet.commentCheck(akismet_options)
      end
    rescue Timeout::Error => e
      nil
    end
  end

  def mark_as_ham
    state.mark_as_ham(self)
  end

  def mark_as_ham!
    mark_as_ham
    save!
  end

  def mark_as_spam
    state.mark_as_spam(self)
  end

  def mark_as_spam!
    mark_as_spam
    save
  end

  def report_as_spam
    return if blog.sp_akismet_key.blank?
    Timeout.timeout(5) { akismet.submitSpam(akismet_options) }
  end

  def report_as_ham
    return if blog.sp_akismet_key.blank?
    Timeout.timeout(5) { akismet.submitHam(akismet_options) }
  end

  def set_spam(is_spam, options ={})
    return if blog.sp_akismet_key.blank?
    Timeout.timeout(5) { is_spam ? report_as_spam : report_as_ham }
  end

  def withdraw!
    withdraw
    self.save!
  end

  def confirm_classification
    state.confirm_classification(self)
  end

  def confirm_classification!
    state.confirm_classification(self)
    self.save
  end
end
