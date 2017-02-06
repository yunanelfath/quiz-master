{PropTypes} = React
{BootstrapTable} = ReactBootstrapTable
{ FormGroup, Button, Row, Col, Modal } = ReactBootstrap

QuizItems = React.createClass
  propTypes:
    csrfToken: PropTypes.string

  getInitialState: ->
    {
      items: QuizItemsStore.items
      quiz: QuizItemsStore.quiz
      showModals: QuizItemsStore.showModals
      formData: QuizItemsStore.formData
    }

  componentDidMount: ->
    @listener = QuizItemsStore.addChangeListener(@_onChange)

  componentWillUnmount: ->
    @listener.remove()

  _onChange: ->
    @setState(
      items: QuizItemsStore.items
      quiz: QuizItemsStore.quiz
      showModals: QuizItemsStore.showModals
      formData: QuizItemsStore.formData
    )

  dispatchEvent: (attributes, actionType) ->
    dispatcher.dispatch(
      actionType: if actionType then actionType else 'quiz-items-global-attributes-setter'
      attributes: attributes
    )

  onShowDetail: (item)->
    $.ajax
      url: "#{Routes.quiz_path(item.id)}.json"
      success: (data) =>
        @dispatchEvent(data)
        @dispatchEvent(
          {modalType: "quizDetail#{item.id}", modalFlag: !@state.showModals["quizDetail#{item.id}"]}
          'quiz-view-set-modals'
        )
        @dispatchEvent(formData: {}, formType: 'show')
      error: (error, x, m)=>

  onDeleteIds: (ids)->
    $.ajax
      url: "#{Routes.destroy_all_questions_path({ids: ids.join(','), format: 'json'})}"
      method: "DELETE"
      success: =>
        swal {
            title: 'Destroyed'
            text: 'Selected Records has been deleted!'
            type: 'success'
          }, ->
            Turbolinks.visit(Routes.questions_path());
            return

  render: ->
    { dispatchEvent, onShowDetail, onDeleteIds } = @
    { csrfToken } = @props
    { items, formData, quiz } = @state

    columns = [
      { key: 'id', isKey: true, value: 'ID' }
      { key: 'answer', isClickable: true, value: 'Answer' }
    ]
    <Row className="quiz-items-display">
      <Col lg={12}>
        <FormGroup>
          <QuizDetailModal modalType="quizNew" dispatchEvent={dispatchEvent} csrfToken={csrfToken}/>
        </FormGroup>
        <FormGroup style={borderRadius: '5px', padding: '7px', border: '1px solid #ddd'}>
          <QuizDetailModal item={quiz} modalType="quizDetail#{quiz?.id}" dispatchEvent={dispatchEvent} csrfToken={csrfToken}/>
          <BootstrapDataTable columns={columns} items={items} onCellClick={onShowDetail} onDeleteIds={onDeleteIds}/>
        </FormGroup>
      </Col>
    </Row>

window.QuizItems = QuizItems
