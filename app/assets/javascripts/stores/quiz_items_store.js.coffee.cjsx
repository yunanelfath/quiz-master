{EventEmitter} = fbemitter

CHANGE_EVENT = 'change'
ITEM_CHANGE_EVENT = 'change:item'

window.QuizItemsStore = _.assign(new EventEmitter(), {
  items: []
  questionItems: []
  formType: 'show'

  showModals: {}
  formData: {}
  quiz: {}
  answeredTo: 0

  setItems: (items) ->
    @items = items

  emitChange: -> @emit(CHANGE_EVENT)
  addChangeListener: (callback) -> @addListener(CHANGE_EVENT, callback)

  emitItemChange: -> @emit(ITEM_CHANGE_EVENT)
  addItemChangeListener: (callback) -> @addListener(ITEM_CHANGE_EVENT, callback)
})

dispatcher.register (payload) ->
  switch payload.actionType
    when 'quiz-items-global-attributes-setter'
      _.assign(QuizItemsStore, payload.attributes)
      QuizItemsStore.emitChange()
    when 'quiz-view-set-modals'
      QuizItemsStore.showModals[payload.attributes.modalType] = payload.attributes.modalFlag
      QuizItemsStore.emitChange()
    when 'quiz-form-attributes-setter'
      _.assign(QuizItemsStore.quiz, payload.attributes)
      QuizItemsStore.emitChange()
    when 'quiz-answer-item-attributes-setter'
      items = QuizItemsStore.questionItems
      item = _.find(items, (_item) -> _item.id == payload.attributes.id)
      _.assign(item, payload.attributes.item)
      QuizItemsStore.emitChange()
