class User < ActiveRecord::Base
  # after_create :send_welcome_email
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :invitable, :omniauthable, :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable

  attr_accessor :user_profile_phone, :user_profile_city

  # Relationships
  has_many :identities
  belongs_to :role, :dependent => :destroy
  belongs_to :userdatum, :dependent => :destroy
  belongs_to :userprofile, :dependent => :destroy

  has_many :conversations, :dependent => :destroy
  
  # Filters
  before_save :assign_role

  def send_welcome_email
    RegisterMailer.welcome(self).deliver_now
  end

  def assign_role
    puts "I am here"
    self.role = Role.find_by name: "User" if self.role.nil?
  end

  def facebook
    identities.where( :provider => "facebook" ).first
  end

  def facebook_client
    @facebook_client ||= Facebook.client( access_token: facebook.accesstoken )
  end

  def google_oauth2
    identities.where( :provider => "google_oauth2" ).first
  end

  def google_oauth2_client
    if !@google_oauth2_client
      @google_oauth2_client = Google::APIClient.new(:application_name => 'Zuplr Test', :application_version => "1.0.0" )
      @google_oauth2_client.authorization.update_token!({:access_token => google_oauth2.accesstoken, :refresh_token => google_oauth2.refreshtoken})
    end
    @google_oauth2_client
  end

  def admin?
    self.role.name == "Admin"
  end

  def user?
    self.role.name == "User"
  end

end
