require_relative '../../test_helper'

describe Nal do

  params = {
    "rft.genre" => "article"
  }

  configuration = {"url" => "http://example.com", "service_types" => ['fulltext']}
  reference = Reference.new(params)

  it "finds Nal fulltext links" do
    EM.run_block {
      stub_request(:get, /#{configuration['url']}.*/).to_return(File.new("spec/fixtures/nal.txt"))
      nal = Nal.new(reference, configuration)
      nal.callback { |result|
        result.first.url_list.size.must_be :==, 3
        result.first.button_text.must_equal "At 3 libraries"
      }
      nal.errback { |error|
        flunk error
      }
    }
  end

  it "returns the proper fields in NAL responses" do
    EM.run_block {
      stub_request(:get, /#{configuration['url']}.*/).to_return(File.new("spec/fixtures/nal.txt"))
      nal = Nal.new(reference, configuration)
      nal.callback { |result|
        result.first.urls.each do |item|
          [:id, :label, :url].each do |key|
            item[key].wont_be_nil
          end
        end
      }
      nal.errback { |error|
        flunk error
      }
    }
  end

  it "ignore errors in nal responses" do
    EM.run_block {
      stub_request(:get, /#{configuration['url']}.*/).to_return(File.new("spec/fixtures/nal_with_error.txt"))
      nal = Nal.new(reference, configuration)
      nal.callback { |result|
        result.first.url_list.size.must_be :==, 1
        result.first.button_text.must_equal "At 1 library"
      }
      nal.errback { |error|
        flunk error
      }
    }
  end
end
