<% if @question.errors.present? %>
  dispatcher.dispatch({
    actionType: 'question-items-global-attributes-setter',
    attributes: {formData: <%= @question.errors.to_json.html_safe %>}
  })
<% else %>

dispatcher.dispatch({
  actionType: 'question-items-global-attributes-setter',
  attributes: {showModals: {questionDetail<%= @question.id %>: false}, items: <%= json_for(@questions, nil, {includes: []}).html_safe %>}
})
<% end %>
