module.exports = class UserMedia extends Backbone.View
  initialize: ->
    _ths = @

    success = (stream) ->
      video = document.createElement 'video'
      video.autoplay = on

      console.log stream

      if window.webkitURL and window.webkitURL.createObjectURL
        video.src = window.webkitURL.createObjectURL stream
      else
        console.log 'hello'
        video.src = stream

      $(document.body).append video  
      _ths.ctx = ctx = _ths.el.getContext '2d'

      Util.on 'animationFrame', ->
        if !_ths.paused
          if video.readyState is video.HAVE_ENOUGH_DATA
            ctx.drawImage video, 0, 0, video.videoWidth, video.videoHeight
            if _ths.el.isSetUp
              _ths.ctx.drawImage video, 0, 0, video.videoWidth, video.videoHeight
              _ths.imageData = _ths.ctx.getImageData 0, 0, _ths.el.width, _ths.el.height

              _ths.trigger 'imageData'

            else if video.videoWidth
              _ths.el.setAttribute 'width', video.videoWidth
              _ths.el.setAttribute 'height', video.videoHeight
              _ths.el.width = video.videoWidth
              _ths.el.height = video.videoHeight
              _ths.el.isSetUp = true

    error = ->
      console.log 'User Media denied :('
    
    if navigator.getUserMedia
      navigator.getUserMedia {video: true}, success, error
    else if navigator.mozGetUserMedia
      navigator.mozGetUserMedia {video: true}, success, error
    else if navigator.webkitGetUserMedia 
      navigator.webkitGetUserMedia {video: true}, success, error
    else
      error()

  paused: false