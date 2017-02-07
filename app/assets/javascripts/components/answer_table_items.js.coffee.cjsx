{PropTypes} = React

AnswerTableItems = React.createClass
  propTypes:
    items: PropTypes.array.isRequired

  render: ->
    {items} = @props

    componentRow = (item, idx) ->
      <tr key={idx}>
        <td>{item.id}</td>
        <td>{item.content}</td>
        <td>{item.answered}</td>
        {
          if item.result != undefined && item.result != null
            if item.result
              <td style={backgroundColor: 'green', color: '#fff',verticalAlign: 'middle'}>
                <span>CORRECT</span>
              </td>
            else
              <td style={backgroundColor: 'red', color: '#fff',verticalAlign: 'middle'}>
                <span>INCORRECT</span>
              </td>
          else
            <td></td>
        }
      </tr>

    <table className="table table-bordered table-hover table-striped">
      <thead>
        <tr>
          <th>ID</th>
          <th>Question</th>
          <th>Answered</th>
          <th>Result</th>
        </tr>
      </thead>
      <tbody>
        {items.map(componentRow)}
      </tbody>
    </table>

window.AnswerTableItems = AnswerTableItems
