Mercury.dialogHandlers.forecolor = ->
  @element.find('.picker, .last-picked').click (event) =>
    color = $(event.target).css('background-color')
    @element.find('.last-picked').css({background: color})
    @button.css({backgroundColor: color})
    Mercury.trigger('action', {action: 'forecolor', value: color})