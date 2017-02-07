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

  render: ->
    { dispatchEvent, onShowDetail, onDeleteIds } = @
    { csrfToken } = @props
    { items, formData, quiz } = @state

    columns = [
      { key: 'id', isKey: true, value: 'ID' }
      { key: 'content', value: 'Question' }
      { key: 'created_at', value: 'Answered time' }
    ]
    <Row className="quiz-items-display">
      <Col lg={12}>
        <FormGroup>
          <QuizDetailModal modalType="quizNew" dispatchEvent={dispatchEvent} csrfToken={csrfToken}/>
        </FormGroup>
        <FormGroup style={borderRadius: '5px', padding: '7px', border: '1px solid #ddd'}>
          <BootstrapDataTable columns={columns} items={items}/>
        </FormGroup>
      </Col>
    </Row>

window.QuizItems = QuizItems
