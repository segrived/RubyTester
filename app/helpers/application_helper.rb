module ApplicationHelper

  def error_box(object)
    (render partial: '/shared/errors', object: object).html_safe
  end

  def escape! h
    h.keys.each do |k|
      h[k] = h[k].to_s
    end
    h
  end

  def run_code(code)
    require 'net/http'
    require 'open-uri'
    url = 'http://api.hackerearth.com/code/run/'
    client = 'de5c96e8c4d6e80774b213b5e099d49a388ab494'
    data = {
        'client_secret' => client,
        'async' => 0,
        'source' => code,
        'lang' => "RUBY",
        'time_limit' => 5,
        'memory_limit' => 262144,
    }
    resp = Net::HTTP.post_form(URI.parse(url), escape!(data))
    JSON.parse(resp.body)['run_status']['output']
  end
end
