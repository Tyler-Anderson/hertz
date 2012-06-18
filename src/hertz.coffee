#tyler anderson 2012
#write some nasty code to appease the god of scopes
((name, global, definition) ->
   if typeof module isnt "undefined"
     module.exports = definition(name, global)
   else if typeof define is "function" and typeof define.amd is "object"
     define definition
   else
     global[name] = definition(name, global)
) "hertz", this, (name, global) ->
  hertz = (channelName) ->
    hertz.$.channel channelName
    hertz.$

  hertz.$ =
    version: '0.1'
    channelName: ""
    channels: []
    broadcast: ->
      c = @channels[@channelName]
      for i in [0...c.length]
        subscriber = c[i]
        if typeof subscriber is "object"
          callback = subscriber[0]
          context = subscriber[1] or global
        callback.apply context, arguments
      this
    channel: (name) ->
      c = @channels
      c[name] = [] unless c[name]
      @channelName = name
      this
    subscribe: ->
      args = arguments
      c     = @channels[@channelName]
      ai = []
      for i in [0...args.length]
        ai = args[i]
        p = (if typeof (ai) is "function" then [ai] else ai)
        c.push p if typeof (p) is "object"
      this
    unsubscribe: ->
      args = arguments
      c = @channels[@channelName]
      jo = undefined
      for i in [0...args.length]
        offset = 0
        for n in [0...c.length]
          jo = n - offset
          if c[jo][0] is args[i]
            c.splice jo, 1
            offset++
      this

  hertz
