class User < ActiveRecord::Base
  authenticates_with_sorcery!
  attr_accessible :name, :email, :password, :password_confirmation

  validates_confirmation_of :password
  validates_presence_of :password, :on => :create
  validates_presence_of :name
  validates_presence_of :email
  validates_uniqueness_of :email

  has_many :experiments
  has_many :user_testbed_credentials
  
  def isAdmin?
    return false
  end

  # Authenticated the user with the the given testbed
  #
  # @param testbed [Testbed] the Testbed object to authenticate with
  # @return [String] the secret-authentication-key or [nil] if not authenticated
  def authenticate_with_testbed(testbed)

    secret_auth_keys = nil

    # TODO: cache all the results!

    tb_creds = user_testbed_credentials.find_by_testbed_id(testbed.id)
    tb_session_client = Savon::Client.new(testbed.sessionManagementEndpointUrl+"?WSDL")
    tb_session_response = tb_session_client.request(:urn, :get_configuration)
    if tb_session_response.success?
      snaa_endpoint_url = tb_session_response.to_array(:get_configuration_response, :snaa_endpoint_url).first

      if snaa_endpoint_url
        # the responded wsdl does not specify its schema correctly! This makes some clients really unhappy!
        # We will take the one hosted on github and set the endpoint for it to the testbed manually.
        tb_snaa_client = Savon::Client.new("https://raw.github.com/wisebed/api-wsdl/master/wsdl/SNAA.wsdl")
        tb_snaa_client.wsdl.endpoint=URI::parse(snaa_endpoint_url)
        tb_auth = tb_snaa_client.request :v1, :authenticate, :body => {
            "authenticationData" => {
                "username" => tb_creds.username,
                "urnPrefix" => testbed.urn_prefix_list,
                "password" => tb_creds.password
            }
        }
        if tb_auth.success?
          secret_auth_key = tb_auth.to_array(:authenticate_response, :secret_authentication_key, :secret_authentication_key).first
        end
      end
    end

    if secret_auth_key
      # builds the list *har har* with only one key
      secret_auth_keys = {
          "secretAuthenticationKeys" => [
            {"username" => tb_creds.username,
             "urnPrefix" => testbed.urn_prefix_list,
             "secretAuthenticationKey" => secret_auth_key
            }
          ]}

    end
  end


end
