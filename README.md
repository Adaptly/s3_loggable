[![Adaptly](http://www.adaptly.com/assets/logo-a91eb71925cbe6bb48e2a0505fc90afc.png)](http://www.adaptly.com)

s3_loggable is a Ruby gem that alllows simple logging of objects to S3:

* Creates daily compressed logs in automatically created buckets organized by object/id/year/month/day
* Simple configuration: one file in which AWS access
* Utilizes `fog` and is therefore threadsafe (works great with Sidekiq) unlike the aws-s3 gem
* Can provides a simple `log_to_s3` method which can be included in objects or can be called explicitly

[![Build Status](https://travis-ci.org/Adaptly/s3_loggable.png)](https://github.com/adaptly/s3_loggable)

## Getting Started

    sudo gem install s3_loggable

Or include it in your Gemfile.
    
    require "s3_loggable"

## Configuration

If credentials are already set for `fog`, those iwll be used.  Otherwise, credentials and the default bucket (which can be overridden) can be set as follows:

    require "s3_loggable"

    S3Loggable.configure do |config|
      config.aws_access_key_id = AWS_ACCESS_KEY_ID
      config.aws_secret_access_key = AWS_SECRET_ACCESS_KEY
      config.default_bucket = BUCKET_NAME
    end

If none of these are configured, the gem will look for the environmental variables, `AWS_ACCESS_KEY_ID` and `AWS_SECRET_ACCESS_KEY`.

## Examples

Including in an object:

    require "s3_loggable"

    class Foo
      include S3Loggable

      def id
        return 123
      end
    end

    foo = Foo.new

    foo.log_to_s3({this: "is a message"})

Which create and write the following to `Foo/123/2013/07/02.rb.gz` in your default bucket:

    2013-07-03T12:05:31-04:00
    {this: "is a message"}

Then `foo.log_to_s3({this: "is another message"})` will append the following to the aforementioned file:

    2013-07-03T12:05:32-04:00
    {this: "is another message"}

Finally, `foo.log_to_s3({new: "message"}, "new-bucket", "456", "AnotherObject", DateTime.new(2001,2,3,4,5,6,'+7'))` will create and write the following to `s3://new-bucket/AnotherObject/456/2001/02/03.rb.gz`:

    2001-02-03T04:05:06+07:00
    {new: "message"}


Additionally, the logger can be called directly as follows:

    logger = S3Loggable::Logger.new("bucket-name")
    logger.log_to_s3("message", "id", "object-or-folder", DateTime.now)

Note that the bucket name and datetime are optional depending on your configuration.

## Copyright

(The MIT License)

Permission is hereby granted, free of charge, to any person obtaining
a copy of this software and associated documentation files (the
"Software"), to deal in the Software without restriction, including
without limitation the rights to use, copy, modify, merge, publish,
distribute, sublicense, and/or sell copies of the Software, and to
permit persons to whom the Software is furnished to do so, subject to
the following conditions:

The above copyright notice and this permission notice shall be
included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE
LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION
OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION
WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
