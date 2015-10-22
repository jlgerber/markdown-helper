MarkdownHelperView = require './markdown-helper-view'
{CompositeDisposable} = require 'atom'

module.exports = MarkdownHelper =
  markdownHelperView: null
  modalPanel: null
  subscriptions: null

  activate: (state) ->
    @markdownHelperView = new MarkdownHelperView(state.markdownHelperViewState)
    @modalPanel = atom.workspace.addModalPanel(item: @markdownHelperView.getElement(), visible: false)

    # Events subscribed to in atom's system can be easily cleaned up with a CompositeDisposable
    @subscriptions = new CompositeDisposable

    # Register command that toggles this view
    @subscriptions.add atom.commands.add 'atom-workspace', 'markdown-helper:toggle': => @toggle()

  deactivate: ->
    @modalPanel.destroy()
    @subscriptions.dispose()
    @markdownHelperView.destroy()

  serialize: ->
    markdownHelperViewState: @markdownHelperView.serialize()

  toggle: ->
    console.log 'MarkdownHelper was toggled!'

    if @modalPanel.isVisible()
      @modalPanel.hide()
    else
      @modalPanel.show()
