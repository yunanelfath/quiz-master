{PropTypes} = React
{ FormGroup, Button, Row, Col, Modal } = ReactBootstrap

QuizForm = React.createClass
  propTypes:
    dispatchEvent: PropTypes.func

  getInitialState: ->
    {
      quiz: QuizItemsStore.quiz
      formData: QuizItemsStore.formData
      formType: QuizItemsStore.formType
    }

  componentDidMount: ->
    @listener = QuizItemsStore.addChangeListener(@_onChange)

  componentWillUnmount: ->
    @listener.remove()

  _onChange: ->
    @setState(
      quiz: QuizItemsStore.quiz
      formData: QuizItemsStore.formData
      formType: QuizItemsStore.formType
    )

  onChangeTextInput: (id, event) ->
    params = {}
    params[id] = if event?.target then event.target.value else event
    @props.dispatchEvent(params, 'quiz-form-attributes-setter')

  render: ->
    { quiz, formData, formType } = @state
    { content, id, answered }  = quiz

    <div className="bs-example" data-example-id="basic-forms">
      <Row style={marginBottom: '10px'}>
        <Col md={12} className="clearfix">
          <FormGroup className="#{if formData?.content then 'has-error' else ''}">
            <label className="control-label col-xs-3 col-sm-3">Question:</label>
            <Col xs={9} sm={9}>
              <span style={textTransform: 'capitalize'}>{if content then content else '-'}</span>
            </Col>
          </FormGroup>
        </Col>
      </Row>
      <Row style={marginBottom: '10px'}>
        <Col md={12} className="clearfix">
          <FormGroup className="#{if formData?.answer then 'has-error' else ''}">
            <label className="control-label col-xs-3 col-sm-3">Answer:</label>
            <Col xs={9} sm={9}>
              {
                if formType == 'show'
                  <span style={textTransform: 'capitalize'}>{if answer then answer else '-'}</span>
                else
                  <input className="form-control form-control-required"
                    value={answered}
                    onChange={@onChangeTextInput.bind(@, 'answered')}
                    placeholder="Answer" type="text" name="question[answer]"/>
              }
              {
                if formData?.answered
                  <p className="help-block">Field Answer {formData?.answer[0]}</p>
              }
            </Col>
          </FormGroup>
        </Col>
      </Row>
    </div>
window.QuizForm = QuizForm
