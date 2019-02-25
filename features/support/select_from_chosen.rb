# frozen_string_literal: true

# select_from_chosen('Option', from: 'id_of_field')
def select_from_chosen(item_text, options)
  field = find_field(options[:from], visible: false)
  find("##{field[:id]}_chosen").click
  find("##{field[:id]}_chosen ul.chosen-results li", text: item_text).click
end
