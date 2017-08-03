module Tagable
  METHODS = {
    greater_than: '>',
    greater_than_or_equal_to: '>=',
    equal_to: '=',
    less_than: '<',
    less_than_or_equal_to: '<=',
  }.freeze

  def tagged_as(tag, tags = ActiveEndpoint.tags.definition)
    return [] if tags.keys.exclude?(tag)

    time_operators = tags[tag]
    last_operator_index = time_operators.keys.length - 1

    query = ''
    time_operators.each_with_index do |(key, value), index|
      operator = METHODS[key]
      duration = (value.to_f / 1000).to_s
      and_operator = last_operator_index == index ? '' : ' AND '
      query << 'duration ' + operator + ' ' + duration + ' ' + and_operator
    end

    where(query)
  end
end
