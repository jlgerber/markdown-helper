{Disposable, CompositeDisposable} = require 'atom'
uri = require 'url'

module.exports = MarkdownHelper =
  config:
    protocol:
      type: 'string'
      default: 'markdown-preview'
    extensions:
      type:'array'
      default: ['.md','.gfm']
      items:
        type: 'string'
  active: false
  subscriptions: null
  openerfunc: null
  opener_func: null

  activate: (state) ->
    # Events subscribed to in atom's system can be easily cleaned up with a CompositeDisposable
    @subscriptions = new CompositeDisposable
    @openerCompDisp = new CompositeDisposable

    # Register command that toggles this view
    @subscriptions.add atom.commands.add 'atom-workspace', 'markdown-helper:toggle': => @toggle()
    @opener_func = @opener.bind(@)
    @openerCompDisp.add new Disposable => _.remove(atom.workspace.openers, opener_func)

  deactivate: ->
    @modalPanel.destroy()
    @subscriptions.dispose()
    @openerfunc.dispose()

  serialize: ->
    null

  toggle: ->
    if  @active is false
      atom.workspace.openers.splice(0,0, @opener_func )
      @active = true
    else
      atom.workspace.openers.shift()
      @active = false

  opener: (urlpath ) ->
    url = uri.parse(urlpath)
    unless url.protocol
      if path.extname(url.pathname) in atom.config.get('markdown-helper.extensions')
        protocol = atom.config.get('markdown-helper.protocol')
        new_url =  "#{protocol}://#{url.path}"
        return atom.workspace.open new_url
    return
