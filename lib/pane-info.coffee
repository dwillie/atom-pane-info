PaneInfoView = require './pane-info-view'
{CompositeDisposable} = require 'atom'

module.exports =
  subscriptions: null

  activate: (state) ->
    @subscriptions = new CompositeDisposable

    @subscriptions.add = atom.workspace.observePanes (pane) =>
      pane.paneInfo = paneInfo = new PaneInfoView(state)
      paneView = atom.views.getView(pane)
      paneView.insertBefore(paneInfo.getElement(), paneView.firstChild)
      pane.onDidDestroy =>
        pane.paneInfo.destroy()
        pane.paneInfo = null
        @updatePanes()

    @subscriptions.add = atom.workspace.observeActivePaneItem () =>
      @updatePanes()

  deactivate: ->
    @subscriptions.dispose()

  updatePanes: ->
    atom.workspace.getPanes().forEach (pane) ->
      pane.paneInfo?.update(pane);
