require File.expand_path('../test_helper', __FILE__)

class HelpersTest < UnitTest
  Main.get('/helper/foo') { img '/images/foo.jpg' }
  Main.get('/helper/email') { img '/images/email.png' }
  Main.get('/helper/email_path') { asset_path '/images/email.png' }
  Main.get('/helper/css/all') { css :application, :sq }
  Main.get('/helper/css/app') { css :application }
  Main.get('/helper/css/sq') { css :sq }

  test "img non-existing" do
    get '/helper/foo'
    assert body == "<img src='/images/foo.jpg' />"
  end

  test "img existing" do
    get '/helper/email'
    assert body =~ %r{src='/images/email.[0-9]+.png'}
    assert body =~ %r{width='16'}
    assert body =~ %r{height='16'}
  end

  test "asset path existing" do
    get '/helper/email_path'
    assert body =~ %r{/images/email.[0-9]+.png}
  end

  test "css" do
    re = Array.new
    get '/helper/css/app'; re << body
    get '/helper/css/sq';  re << body

    get '/helper/css/all'
    assert body.gsub(/[\r\n]*/m, '') == re.join('')
  end
end
