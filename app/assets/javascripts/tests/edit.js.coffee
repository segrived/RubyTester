$(document).bind 'edit_tests.load', (e, obj) =>
  $('.add-question-variant').click ->
    fs = $(@).parent('fieldset')
    question_type = fs.parent('form').find("input[name='question[type]']:first").val()
    empty = $('.center-box').find("#variant-type-#{question_type} .field:first").clone()
    guid = unique_id(25)
    empty.find('.dynamic:radio, .dynamic:checkbox').val(guid)
    empty.find('.dynamic:text').attr('name', "question[variants][#{guid}]")
    console.log empty
    fs.find('.question_variants:first').append(empty)
  $(document).on 'click', '.remove-question-variant', ->
    $(@).parent('.field').remove()