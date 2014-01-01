//= require jquery
//= require jquery_ujs
//= require underscore
//= require notify.min.js
//= require jquery.scrollTo.min.js
//= require alertify.min.js
//= require moment.min.js
//= require sugar.min.js
//= require js-routes
//= require highlight.pack

//= require_self
//= require_tree .

bind_js = (controller, action) ->
  # fix for controllers within namespace
  controller = controller.replace /\//, '_'
  $.event.trigger "#{controller}.load"
  $.event.trigger "#{action}_#{controller}.load"

$(document).on 'ready page:load', ->
  bind_js $('body').data('controller'), $('body').data('action')

  alertify.set
    labels: { ok: "Да", cancel : "Отменить" }
    buttonReverse: true
  hljs.initHighlightingOnLoad()
    
  $.rails.allowAction = (link) ->
    return true unless link.attr('data-confirm')
    $.rails.showConfirmDialog(link)
    false

  $.rails.confirmed = (link) ->
    link.removeAttr('data-confirm')
    link.trigger('click.rails')

  $.rails.showConfirmDialog = (link) ->
    message = link.attr 'data-confirm'
    alertify.confirm message, (e) ->
      if e then $.rails.confirmed(link)