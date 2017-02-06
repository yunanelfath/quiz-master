{PropTypes} = React
{BootstrapTable} = ReactBootstrapTable

BootstrapDataTable = React.createClass
  propTypes:
    columns: PropTypes.array
    items: PropTypes.array
    onCellClick: PropTypes.func
    onDeleteIds: PropTypes.func

  optionsTable: ->
    options = {
      onDeleteRow: @onDeleteRow
    }

    options

  onDeleteRow: (ids) ->
    @props.onDeleteIds?(ids)

  columnClassNameFormat: (fieldValue, row, rowIdx, colIdx) ->
    # // fieldValue is column value
    # // row is whole row object
    # // rowIdx is index of row
    # // colIdx is index of column
    if fieldValue then 'text-blue'

  onSelectItem: (row, isSelected, event)->
    tr = $(ReactDOM.findDOMNode(event.target)).closest('tr')
    if isSelected
      tr.addClass('selected-item-table')
    else
      tr.removeClass('selected-item-table')

  onClickableColumn: (item, event) ->
    @props.onCellClick?(item)

  clickableFormat: (cell, row, enumObject, rowIndex) ->
    element = <a href="javascript:void(0)" onClick={@onClickableColumn.bind(@, row)}>{cell}</a>
    element


  render: ->
    columnComponent = (item, idx) =>
      if item?.isKey
        <TableHeaderColumn ref="#{item?.key}" key={idx} dataField={item?.key} dataSort isKey>{item?.value}</TableHeaderColumn>
      else
        if item?.isClickable
          <TableHeaderColumn dataFormat={@clickableFormat} ref="#{item?.key}" key={idx} dataField={item?.key} dataSort columnClassName={@columnClassNameFormat}>{item?.value}</TableHeaderColumn>
        else
          <TableHeaderColumn ref="#{item?.key}" key={idx} dataField={item?.key} dataSort>{item?.value}</TableHeaderColumn>

    <BootstrapTable data={@props.items} striped hover deleteRow search pagination condensed
      selectRow={{mode: 'checkbox', onSelect: @onSelectItem}}
      headerStyle={{cursor: 'pointer'}}
      options={@optionsTable()}>
        {
          @props.columns.map(columnComponent)
        }
    </BootstrapTable>

window.BootstrapDataTable = BootstrapDataTable
