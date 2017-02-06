{PropTypes} = React
{ Button, Row, Col, Modal, FormGroup } = ReactBootstrap

QuestionDetailModal = React.createClass
  propTypes:
    item: PropTypes.object
    csrfToken: PropTypes.string
    dispatchEvent: PropTypes.func
    modalType: PropTypes.string

  getInitialState: ->
    {
      showModals: QuestionItemsStore.showModals
      formType: QuestionItemsStore.formType
    }

  componentDidMount: ->
    @listener = QuestionItemsStore.addChangeListener(@_onChange)

  componentWillUnmount: ->
    @listener.remove()

  _onChange: ->
    @setState(
      showModals: QuestionItemsStore.showModals
      formType: QuestionItemsStore.formType
    )

  onToggleModal: ->
    @props.dispatchEvent(
      {modalType: @props.modalType, modalFlag: !@state.showModals[@props.modalType]}
      'question-view-set-modals'
    )
    @props.dispatchEvent(formData: {}, formType: if @props.modalType == "questionNew" then 'new' else 'show')
    if @props.modalType == "questionNew"
      @onResetForm()

  onResetForm: ->
    @props.dispatchEvent(formData: {}, question: {})

  onEditForm: ->
    @props.dispatchEvent(formType: 'update')

  onShowForm: ->
    @props.dispatchEvent(formType: 'show')

  render: ->
    { dispatchEvent } = @props
    { showModals, formType } = @state

    <span>
      {
        if @props.modalType == 'questionNew'
          <a href="javascript:void(0)" onClick={@onToggleModal} className="btn btn-primary">New Question</a>
        else
          <span></span>
      }
      <Modal show={showModals[@props.modalType]} onHide={@onToggleModal}>
        <form method="POST" action={if @props.modalType == "questionNew" then "#{Routes.questions_path()}.js" else (if @props.item?.id then "#{Routes.question_path(@props.item.id)}.js" else "")} data-remote={true} ref="formSubmitArchive" encType="multipart/form-data">
          <input type='hidden' name='authenticity_token' value={@props.csrfToken} />
          {
            unless $.inArray(@props.modalType, ["questionNew"]) >= 0
              <input type='hidden' name='_method' value="PATCH" />
          }
          <Modal.Header className="modal-header-square" closeButton>
            <Modal.Title id="contained-modal-title-lg">
              {
                if @props.modalType == 'questionNew'
                  <span>New Question</span>
                else
                  <span>{if formType == 'show' then 'Detail' else 'Edit'} Question - {@props.item.id}</span>
              }
            </Modal.Title>
          </Modal.Header>
          <Modal.Body className="jumbotron" style={marginBottom: 0}>
            <QuestionForm dispatchEvent={dispatchEvent}/>
          </Modal.Body>
          <Modal.Footer>
            <div className="pull-left">
              {
                if formType == 'show'
                  <Button onClick={@onEditForm} className="btn-primary">Edit</Button>
                else
                  <input className="btn btn-primary" type="submit" value="Submit" ref="submitButton" data-disable-with="Please wait..."/>
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
window.QuestionDetailModal = QuestionDetailModal
