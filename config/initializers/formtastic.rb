# Set the default text field size when input is a string. Default is 50.
# Formtastic::SemanticFormBuilder.default_text_field_size = 50

# Set the default text area height when input is a text. Default is 20.
# Formtastic::SemanticFormBuilder.default_text_area_height = 5

# Should all fields be considered "required" by default?
# Defaults to true, see ValidationReflection notes below.
# Formtastic::SemanticFormBuilder.all_fields_required_by_default = true

# Should select fields have a blank option/prompt by default?
# Defaults to true.
# Formtastic::SemanticFormBuilder.include_blank_for_select_by_default = true

# Set the string that will be appended to the labels/fieldsets which are required
# It accepts string or procs and the default is a localized version of
# '<abbr title="required">*</abbr>'. In other words, if you configure formtastic.required
# in your locale, it will replace the abbr title properly. But if you don't want to use
# abbr tag, you can simply give a string as below
# Formtastic::SemanticFormBuilder.required_string = "(required)"

# Set the string that will be appended to the labels/fieldsets which are optional
# Defaults to an empty string ("") and also accepts procs (see required_string above)
# Formtastic::SemanticFormBuilder.optional_string = "(optional)"

# Set the way inline errors will be displayed.
# Defaults to :sentence, valid options are :sentence, :list and :none
# Formtastic::SemanticFormBuilder.inline_errors = :sentence

# Set the method to call on label text to transform or format it for human-friendly
# reading when formtastic is used without object. Defaults to :humanize.
# Formtastic::SemanticFormBuilder.label_str_method = :humanize

# Set the array of methods to try calling on parent objects in :select and :radio inputs
# for the text inside each @<option>@ tag or alongside each radio @<input>@. The first method
# that is found on the object will be used.
# Defaults to ["to_label", "display_name", "full_name", "name", "title", "username", "login", "value", "to_s"]
# Formtastic::SemanticFormBuilder.collection_label_methods = [
#   "to_label", "display_name", "full_name", "name", "title", "username", "login", "value", "to_s"]

# Formtastic by default renders inside li tags the input, hints and then
# errors messages. Sometimes you want the hints to be rendered first than
# the input, in the following order: hints, input and errors. You can
# customize it doing just as below:
# Formtastic::SemanticFormBuilder.inline_order = [:input, :hints, :errors]

# Specifies if labels/hints for input fields automatically be looked up using I18n.
# Default value: false. Overridden for specific fields by setting value to true,
# i.e. :label => true, or :hint => true (or opposite depending on initialized value)
# Formtastic::SemanticFormBuilder.i18n_lookups_by_default = false

# You can add custom inputs or override parts of Formtastic by subclassing SemanticFormBuilder and
# specifying that class here.  Defaults to SemanticFormBuilder.
# Formtastic::SemanticFormHelper.builder = MyCustomBuilder

Formtastic::SemanticFormHelper.builder.priority_countries = []

CUSTOM_TIME_ZONES = [
  ['Samoa', 'GMT-11:00'],
  ['Hawaii', 'GMT-10:00'],
  ['Alaska', 'GMT-09:00'],
  ['Tijuana', 'GMT-08:00'],
  ['Arizona', 'GMT-07:00'],
  ['Central America', 'GMT-06:00'],
  ['Bogota', 'GMT-05:00'],
  ['Caracas', 'GMT-04:30'],
  ['Georgetown', 'GMT-04:00'],
  ['Newfoundland', 'GMT-03:30'],
  ['Brasilia', 'GMT-03:00'],
  ['Mid-Atlantic', 'GMT-02:00'],
  ['Azores', 'GMT-01:00'],
  ['London', 'GMT+00:00'],
  ['Amsterdam', 'GMT+01:00'],
  ['Kyiv', 'GMT+02:00'],
  ['Moscow', 'GMT+03:00'],
  ['Tehran', 'GMT+03:30'],
  ['Abu Dhabi', 'GMT+04:00'],
  ['Kabul', 'GMT+04:30'],
  ['Ekaterinburg', 'GMT+05:00'],
  ['Kolkata', 'GMT+05:30'],
  ['Astana', 'GMT+06:00'],
  ['Rangoon', 'GMT+06:30'],
  ['Bangkok', 'GMT+07:00'],
  ['Beijing', 'GMT+08:00'],
  ['Osaka', 'GMT+09:00'],
  ['Adelaide', 'GMT+09:30'],
  ['Canberra', 'GMT+10:00'],
  ['Kamchatka', 'GMT+11:00'],
  ['Fiji', 'GMT+12:00'],
  ["Nuku'alofa", 'GMT+13:00']
  ].collect{|e| e.reverse}