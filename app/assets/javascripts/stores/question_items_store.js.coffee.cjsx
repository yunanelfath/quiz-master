{EventEmitter} = fbemitter

CHANGE_EVENT = 'change'
ITEM_CHANGE_EVENT = 'change:item'

window.QuestionItemsStore = _.assign(new EventEmitter(), {
  items: []
  formType: 'show'

  showModals: {}
  formData: {}
  filteredForm: {}
  question: {}
  emitChange: -> @emit(CHANGE_EVENT)
  addChangeListener: (callback) -> @addListener(CHANGE_EVENT, callback)

  emitItemChange: -> @emit(ITEM_CHANGE_EVENT)
  addItemChangeListener: (callback) -> @addListener(ITEM_CHANGE_EVENT, callback)
})

dispatcher.register (payload) ->
  switch payload.actionType
    when 'question-items-global-attributes-setter'
      _.assign(QuestionItemsStore, payload.attributes)
      QuestionItemsStore.emitChange()
    when 'question-view-set-modals'
      QuestionItemsStore.showModals[payload.attributes.modalType] = payload.attributes.modalFlag
      QuestionItemsStore.emitChange()
    when 'question-form-attributes-setter'
      _.assign(QuestionItemsStore.question, payload.attributes)
      QuestionItemsStore.emitChange()
    when 'question-filter-form-attributes-setter'
      _.assign(QuestionItemsStore.filteredForm, payload.attributes)
      QuestionItemsStore.emitChange()
