# Description
#   Hubot script for clarifai
#
# Dependencies:
#   clarifai (not the offical one which isn't on npm :sadpanda:)
#
# Configuration:
#   CLARIFAI_ID
#   CLARIFAI_SECRET
#
# Commands:
#   hubot what do you see (here) <url> - hubot sends a few tags from the image <url>
#   hubot guckst du (hier) <url> - same as `hubot what do you see`, but German
#
# Author:
#   Kilian Koeltzsch <me@kilian.io>

phrases_en = [
    'Reminds me of ',
    'I\'m thinking of ',
    'That\'s surely a ',
    'My money\'s on ',
]

phrases_de = [
    'Erinnert mich an ',
    'Ich denk\' an ',
    'Das ist sicherlich ',
    'Ich tipp\' mal auf ',
]

Clarifai = require 'clarifai'
client = new Clarifai
    id: process.env.CLARIFAI_ID,
    secret: process.env.CLARIFAI_SECRET

module.exports = (robot) ->
    robot.respond /what do you see( here)? (.*)/, (res) ->
        url = res.match[2]
        get_tags 'en', url, (tags) ->
            prefix = res.random phrases_en
            res.send prefix + tags.join ', '

    robot.respond /guckst du( hier)? (.*)/, (res) ->
        url = res.match[2]
        get_tags 'de', url, (tags) ->
            prefix = res.random phrases_de
            res.send prefix + tags.join ', '


get_tags = (lang, url, callback) ->
    client.tagFromUrls 'image', url, (err, results) ->
        tags = []
        for result in results.tags
            tags.push result.class
        callback tags
    , [lang]
