should = require 'should'

describe 'Datetime parser', ->

  describe 'Humanize offset parser', ->

    humanizeParser = (require '../lib/utils').Utils.humanizeDatetimeOffset
    oneMillisecond = 1000

    it 'should return expected milliseconds.', ->

      (humanizeParser '1 second').should.equal 1 * oneMillisecond
      (humanizeParser '5 seconds').should.equal 5 * oneMillisecond
      (humanizeParser '105 seconds').should.equal 105 * oneMillisecond
      (humanizeParser '1 minute').should.equal 60 * oneMillisecond
      (humanizeParser '15 minutes').should.equal 15 * 60 * oneMillisecond
      (humanizeParser '42 minutes').should.equal 42 * 60 * oneMillisecond
      (humanizeParser '1 hour').should.equal 60 * 60 * oneMillisecond
      (humanizeParser '12 hours').should.equal 12 * 60 * 60 * oneMillisecond
      (humanizeParser '1 day').should.equal 24 * 60 * 60 * oneMillisecond

    it 'should return expected milliseconds for misspelled plural.', ->

      (humanizeParser '1 seconds').should.equal 1 * oneMillisecond
      (humanizeParser '5 second').should.equal 5 * oneMillisecond
      (humanizeParser '105 second').should.equal 105 * oneMillisecond
      (humanizeParser '1 minutes').should.equal 60 * oneMillisecond
      (humanizeParser '15 minute').should.equal 15 * 60 * oneMillisecond
      (humanizeParser '42 minute').should.equal 42 * 60 * oneMillisecond
      (humanizeParser '1 hours').should.equal 60 * 60 * oneMillisecond
      (humanizeParser '12 hour').should.equal 12 * 60 * 60 * oneMillisecond
      (humanizeParser '1 days').should.equal 24 * 60 * 60 * oneMillisecond
