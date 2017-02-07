{TestUtils} = React.addons
{Simulate} = TestUtils

describe "Quiz Items", ->
  items = [
    { id: 1, content: 'content 1', created_at: '2017-01-01'},
    { id: 2, content: 'content 2', created_at: '2017-01-01'}
  ]

  QuizItemsStore.setItems(items)
  element = React.createElement(QuizItems)
  component = TestUtils.renderIntoDocument(element)

  componentNode = ReactDOM.findDOMNode(component)
  displayNode = TestUtils.findRenderedDOMComponentWithClass(component, 'quiz-items-display')
  it 'successfully change items', ->
    countItems = $(displayNode).find('.react-bs-container-body table tbody tr').length

    expect(countItems).not.toBe(0);
