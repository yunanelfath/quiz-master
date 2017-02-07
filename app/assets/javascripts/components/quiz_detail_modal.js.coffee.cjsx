{PropTypes} = React
{ Button, Row, Col, Modal, FormGroup } = ReactBootstrap

QuizDetailModal = React.createClass
  propTypes:
    item: PropTypes.object
    csrfToken: PropTypes.string
    dispatchEvent: PropTypes.func
    modalType: PropTypes.string

  getInitialState: ->
    {
      showModals: QuizItemsStore.showModals
      formType: QuizItemsStore.formType
      questionItems: QuizItemsStore.questionItems
      quiz: QuizItemsStore.quiz
    }

  componentDidMount: ->
    @listener = QuizItemsStore.addChangeListener(@_onChange)

  componentWillUnmount: ->
    @listener.remove()

  _onChange: ->
    @setState(
      showModals: QuizItemsStore.showModals
      formType: QuizItemsStore.formType
      questionItems: QuizItemsStore.questionItems
      quiz: QuizItemsStore.quiz
    )

  onToggleModal: ->
    if $.isEmptyObject(@state.questionItems)
      swal {
          title: 'Failed'
          text: 'You need to assigns some question first!'
          type: 'error'
        }, ->
          return false
    @props.dispatchEvent(
      {modalType: @props.modalType, modalFlag: !@state.showModals[@props.modalType]}
      'quiz-view-set-modals'
    )
    @props.dispatchEvent(quiz: @state.questionItems[0], formData: {}, formType: if @props.modalType == "quizNew" then 'new' else 'show')
    if @props.modalType == "quizNew"
      @onResetForm()

  onResetForm: ->
    @props.dispatchEvent(formData: {})
    for q in @state.questionItems
      @props.dispatchEvent(
        {id: q.id, item: {answered: null, result: null}}
        'quiz-answer-item-attributes-setter'
      )

  onEditForm: ->
    @props.dispatchEvent(formType: 'update')

  onShowForm: ->
    @props.dispatchEvent(formType: 'show')

  onNextForm: ->
    if $.isEmptyObject(@state.quiz)
      quizIndex = @state.questionItems[0]
    else
      index = @state.questionItems.indexOf(@state.quiz)
      quizIndex = @state.questionItems[index+1]

    unless quizIndex
      @props.dispatchEvent(formType: 'answered form')
      return false
    @props.dispatchEvent(quiz: quizIndex)

  onSubmitQuiz: ->
    q = @state.questionItems
    i = 0
    setQuizRequest = (i) =>
      data = {
        question_id: q[i].id
        answer: q[i].answered
      }
      $.ajax
        url: "#{Routes.quizzes_path()}.json"
        method: "POST"
        data: {quiz: data}
        success: (json) =>
          @props.dispatchEvent(
            {id: q[i].id, item: {answered: json.quiz.answered, result: json.quiz.result}}
            'quiz-answer-item-attributes-setter'
          )
          if i < (@state.questionItems.length-1)
            i++
            setQuizRequest(i)
          if i == (@state.questionItems.length-1)
            _this = @
            swal {
                title: 'Thank You!'
                text: 'Thanks for your participation.'
                type: 'success'
              }, ->
                _this.props.dispatchEvent(formType: 'finish')
                return false
    setQuizRequest(i)

  render: ->
    { dispatchEvent } = @props
    { showModals, formType, questionItems } = @state

    <span>
      {
        if @props.modalType == 'quizNew'
          <a href="javascript:void(0)" onClick={@onToggleModal} className="btn btn-primary question-new">Start Quiz</a>
        else
          <span></span>
      }
      <Modal show={showModals[@props.modalType]} onHide={@onToggleModal}>
        <form method="POST" action={if @props.modalType == "quizNew" then "#{Routes.quizzes_path()}.js" else (if @props.item?.id then "#{Routes.quiz_path(@props.item.id)}.js" else "")} data-remote={true} ref="formSubmitArchive" encType="multipart/form-data">
          <input type='hidden' name='authenticity_token' value={@props.csrfToken} />
          {
            unless $.inArray(@props.modalType, ["quizNew"]) >= 0
              <input type='hidden' name='_method' value="PATCH" />
          }
          <Modal.Header className="modal-header-square" closeButton>
            <Modal.Title id="contained-modal-title-lg">
              {
                if @props.modalType == 'quizNew'
                  <span>Start Quiz</span>
                else
                  if @props?.item
                    <span>{if formType == 'show' then 'Detail' else 'Edit'} Question - {@props.item.id}</span>

              }
            </Modal.Title>
          </Modal.Header>
          <Modal.Body className="jumbotron" style={marginBottom: 0}>
            {
              if formType == 'answered form' || formType == 'finish'
                <AnswerTableItems items={questionItems}/>
              else
                <QuizForm dispatchEvent={dispatchEvent}/>

            }
          </Modal.Body>
          <Modal.Footer>
            <div className="pull-left">
              {
                if formType == 'answered form'
                  <Button onClick={@onSubmitQuiz} className="btn btn-primary">Submit Quiz</Button>
                else
                  if formType == 'finish'
                    <span></span>
                  else
                    <Button onClick={@onNextForm} className="btn-success">Next</Button>
              }
              {
                if formType == 'update'
                  <Button onClick={@onShowForm} className="btn-danger">Cancel</Button>
              }
              <Button onClick={@onToggleModal}>Close</Button>
            </div>
          </Modal.Footer>
        </form>
      </Modal>
    </span>
window.QuizDetailModal = QuizDetailModal
