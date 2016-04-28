## Streamer App
A basic HDFS browsing web application that using Live Streaming to download files.

To setup the application, configure the file `config/webhdfs.yml` for the appropriate environment (or all).

To run the server locally, Puma should be used instead of `rails server` (WEBrick). To launch Puma, use the following command `puma -w 2`. Note: Adjust the value '2' upwards to add additional workers if you'd like more concurrent requests.

## Interesting Links
* http://guides.rubyonrails.org/action_controller_overview.html#streaming-and-file-downloads
* http://tenderlovemaking.com/2012/07/30/is-it-live.html
* https://intercityup.com/blog/streaming-data-with-actioncontroller-live.html
* http://guides.rubyonrails.org/rails_on_rack.html
