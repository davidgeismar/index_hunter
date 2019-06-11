# maybe faraday
module IndexHunter
  module Clients
    class Splunk
      def initialize(base_url, username, password, search_query)
        @base_url = URI.parse(base_url)
        @username = username
        @password = password
        @search_query = search_query
        @base_client = Net::HTTP.new(@base_url.host, @base_url.port)
        @base_client.use_ssl = false
        # Remove leading and trailing whitespace from the search
        # '| inputcsv foo.csv | where sourcetype=access_common | head 5'(.strip)

      end

    #   print httplib2.Http(disable_ssl_certificate_validation=True).request(baseurl + '/services/search/jobs','POST',
    # headers={'Authorization': 'Splunk %s' % sessionKey},body=urllib.urlencode({'search': searchQuery}))[1]
      def run_query
        session_key = login
        req = Net::HTTP::Post.new(uri.path, initheader = {'Authorization': "Splunk #{@session_key}"})
        req.body = @search_query
        res = https.request(req)
        puts "Response #{res.code} #{res.message}: #{res.body}"
      end

      private

      def login
        @base_client.post(
          "/services/auth/login",
           { 'username' => @username, 'password' => @password }.to_json
        )['sessionKey']

        # get the sessionKey in the response

      end
    end
  end
end

# 1 create the search
curl -u admin:changeme -k https://localhost:8089/services/search/jobs -d search="search *"
#parse resp to get the search id

# 2 check the status of the search
curl -u admin:changeme -k https://localhost:8089/services/search/jobs/{search_id}

# 3 get search results
curl -u admin:changeme \
     -k https://localhost:8089/services/search/jobs/{search_id}/results/ \
     --get -d output_mode={csv|xml|json}
