{TestUtils} = React.addons
{Simulate} = TestUtils

describe "QuestionItems", ->
  items = [
    { id: 1, content: 'content 1', answer: 'answer 1'},
    { id: 2, content: 'content 2', answer: 'answer 2' }
  ]

  QuestionItemsStore.setItems(items)
  element = React.createElement(QuestionItems)
  component = TestUtils.renderIntoDocument(element)

  componentNode = ReactDOM.findDOMNode(component)
  displayNode = TestUtils.findRenderedDOMComponentWithClass(component, 'question-items-display')
  it 'successfully change items', ->
    countItems = $(displayNode).find('.react-bs-container-body table tbody tr').length

    expect(countItems).not.toBe(0);
