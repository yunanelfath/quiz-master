{PropTypes} = React
{ FormGroup, Button, Row, Col, Modal } = ReactBootstrap

QuestionForm = React.createClass
  propTypes:
    dispatchEvent: PropTypes.func

  getInitialState: ->
    {
      question: QuestionItemsStore.question
      formData: QuestionItemsStore.formData
      formType: QuestionItemsStore.formType
    }

  componentDidMount: ->
    @listener = QuestionItemsStore.addChangeListener(@_onChange)

  componentWillUnmount: ->
    @listener.remove()

  _onChange: ->
    @setState(
      question: QuestionItemsStore.question
      formData: QuestionItemsStore.formData
      formType: QuestionItemsStore.formType
    )

  onChangeTextInput: (id, event) ->
    params = {}
    params[id] = if event?.target then event.target.value else event
    @props.dispatchEvent(params, 'question-form-attributes-setter')

  render: ->
    { question, formData, formType } = @state
    { content, answer } = question

    <div className="bs-example" data-example-id="basic-forms">
      <Row style={marginBottom: '10px'}>
        <Col md={12} className="clearfix">
          <FormGroup className="#{if formData?.content then 'has-error' else ''}">
            <label className="control-label col-xs-3 col-sm-3">Content:</label>
            <Col xs={9} sm={9}>
              {
                if formType == 'show'
                  <span style={textTransform: 'capitalize'}>{if content then content else '-'}</span>
                else
                  <span>
                    <ReactQuill theme="snow" className="editor" value={content}
                      onChange={@onChangeTextInput.bind(@, 'content')}/>
                    <input type="hidden" value={question?.content} name="question[content]"/>
                  </span>

              }
              {
                if formData?.content
                  <p className="help-block">Field Content {formData?.content[0]}</p>
              }
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
                    value={question?.answer}
                    onChange={@onChangeTextInput.bind(@, 'answer')}
                    placeholder="Answer" type="text" name="question[answer]"/>
              }
              {
                if formData?.answer
                  <p className="help-block">Field Answer {formData?.answer[0]}</p>
              }
            </Col>
          </FormGroup>
        </Col>
      </Row>
    </div>
window.QuestionForm = QuestionForm
