module.exports = class Language
  constructor: (lang) ->
    for key of lang
      try
        language = require 'data/languages/' + key + '.lang'
      catch e
        console.log 'Language definition ' + key + ' not found :('

      if language.version isnt lang[key]
        console.log 'Wrong language version for ' + key
      else
        words = language.words

        if language.extends
          language = new Language language.extends

        @merge @words, language.words
        @merge @words, words

        console.log key
        console.log language.words
        console.log @words

  merge: (target, source) ->
    for key of source
      target[key] = source[key]

  words: {}