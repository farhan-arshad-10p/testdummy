require 'spec_helper'
describe Api::V1::ContentSourceSerializer do
  describe '#as_json' do
    subject { described_class.new content_source, root: :content_source }
    let(:content_source) { Fabricate(:content_source) }

    it 'serializes the model properly' do
      content_source.media_url = '<script src="https://gist.github.com/adamwiggins/5687294.js"></script>'
      subject.as_json.should == {
        content_source: {
          id: content_source.id,
          title: content_source.title,
          content_body: content_source.content,
          description: content_source.description,
          url: content_source.url,
          media_url: content_source.media_url,
          featured_image_url: content_source.featured_image_url,
          provider_display: content_source.provider_display,
          content_type: content_source.content_type
        }
      }
    end

    it 'serializes http:// sourced media properly' do
      fixed_media_url = '<iframe src="//embed.ted.com/talks/malcolm_gladwell_on_spaghetti_sauce.html" width="560" height="315" frameborder="0" scrolling="no" webkitAllowFullScreen mozallowfullscreen allowFullScreen></iframe>'
      content_source.media_url = '<iframe src="http://embed.ted.com/talks/malcolm_gladwell_on_spaghetti_sauce.html" width="560" height="315" frameborder="0" scrolling="no" webkitAllowFullScreen mozallowfullscreen allowFullScreen></iframe>'
      subject.as_json.should == {
        content_source: {
          id: content_source.id,
          title: content_source.title,
          content_body: content_source.content,
          description: content_source.description,
          url: content_source.url,
          media_url: fixed_media_url,
          featured_image_url: content_source.featured_image_url,
          provider_display: content_source.provider_display,
          content_type: content_source.content_type
        }
      }
    end

    it 'does not break when no media source is given' do
      content_source.media_url = nil
      subject.as_json.should == {
        content_source: {
          id: content_source.id,
          title: content_source.title,
          content_body: content_source.content,
          description: content_source.description,
          url: content_source.url,
          media_url: nil,
          featured_image_url: content_source.featured_image_url,
          provider_display: content_source.provider_display,
          content_type: content_source.content_type
        }
      }
    end
  end
end
