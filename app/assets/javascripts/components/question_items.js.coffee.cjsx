{PropTypes} = React
{BootstrapTable} = ReactBootstrapTable
{ FormGroup, Button, Row, Col, Modal } = ReactBootstrap

QuestionItems = React.createClass
  propTypes:
    csrfToken: PropTypes.string.isRequired

  getInitialState: ->
    {
      items: QuestionItemsStore.items
      question: QuestionItemsStore.question
      showModals: QuestionItemsStore.showModals
      formData: QuestionItemsStore.formData
    }

  componentDidMount: ->
    @listener = QuestionItemsStore.addChangeListener(@_onChange)

  componentWillUnmount: ->
    @listener.remove()

  _onChange: ->
    @setState(
      items: QuestionItemsStore.items
      question: QuestionItemsStore.question
      showModals: QuestionItemsStore.showModals
      formData: QuestionItemsStore.formData
    )

  dispatchEvent: (attributes, actionType) ->
    dispatcher.dispatch(
      actionType: if actionType then actionType else 'question-items-global-attributes-setter'
      attributes: attributes
    )

  onShowDetail: (item)->
    $.ajax
      url: "#{Routes.question_path(item.id)}.json"
      success: (data) =>
        @dispatchEvent(data)
        @dispatchEvent(
          {modalType: "questionDetail#{item.id}", modalFlag: !@state.showModals["questionDetail#{item.id}"]}
          'question-view-set-modals'
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
    { items, formData, question } = @state

    columns = [
      { key: 'id', isKey: true, value: 'ID' }
      { key: 'content', isClickable: true, value: 'Content' }
      { key: 'answer', value: 'Answer' }
    ]
    <Row>
      <Col lg={12}>
        <FormGroup>
          <QuestionDetailModal modalType="questionNew" dispatchEvent={dispatchEvent} csrfToken={csrfToken}/>
        </FormGroup>
        <FormGroup style={borderRadius: '5px', padding: '7px', border: '1px solid #ddd'}>
          <QuestionDetailModal item={question} modalType="questionDetail#{question?.id}" dispatchEvent={dispatchEvent} csrfToken={csrfToken}/>
          <BootstrapDataTable columns={columns} items={items} onCellClick={onShowDetail} onDeleteIds={onDeleteIds}/>
        </FormGroup>
      </Col>
    </Row>

window.QuestionItems = QuestionItems
