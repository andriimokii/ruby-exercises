require 'csv'
require 'google/apis/civicinfo_v2'
require 'erb'

def clean_zipcode(zipcode)
  zipcode.to_s.rjust(5,"0")[0..4]
end

def legislators_by_zipcode(zip)
  civic_info = Google::Apis::CivicinfoV2::CivicInfoService.new
  civic_info.key = 'AIzaSyClRzDqDh5MsXwnCWi0kOiiBivP6JsSyBw'

  begin
    civic_info.representative_info_by_address(
      address: zip,
      levels: 'country',
      roles: ['legislatorUpperBody', 'legislatorLowerBody']
    ).officials
  rescue
    'You can find your representatives by visiting www.commoncause.org/take-action/find-elected-officials'
  end
end

def save_thank_you_letter(id,form_letter)
  Dir.mkdir('output') unless Dir.exist?('output')

  filename = "output/thanks_#{id}.html"

  File.open(filename, 'w') do |file|
    file.puts form_letter
  end
end

def clean_homephone(homephone)
  digit_number = homephone.gsub(/\D/, '')

  if digit_number.length == 10
    digit_number
  elsif digit_number.length == 11 && digit_number[0] == '1'
    digit_number[1..]
  else
    '0' * 10
  end
end

def clean_datetime(datetime)
  DateTime.strptime(datetime, '%m/%d/%y %k:%M')
end

def most_target_datetime(datetime, count = 3)
  datetime.tally.max_by(count) { |_key,value| value }
end

def display_max_regs(date_or_time_array, target)
  puts "Max number of registration per #{target}:"
  most_target_datetime(date_or_time_array).each do |date_or_time, regs_count|
    puts "#{target_name(date_or_time, target)} has #{regs_count} registrations"
  end
end

def target_name(date_or_time, target)
  if target == 'hour'
    "#{target.capitalize} #{date_or_time}"
  elsif target == 'day of week'
    Date::DAYNAMES[date_or_time]
  else
    'Unknown target'
  end
end

puts 'EventManager initialized.'

contents = CSV.open(
  'event_attendees.csv',
  headers: true,
  header_converters: :symbol
)

template_letter = File.read('form_letter.erb')
erb_template = ERB.new template_letter

hours_of_day = []
days_of_week = []
contents.each do |row|
  id = row[0]
  name = row[:first_name]
  zipcode = clean_zipcode(row[:zipcode])
  legislators = legislators_by_zipcode(zipcode)

  form_letter = erb_template.result(binding)

  save_thank_you_letter(id,form_letter)

  puts clean_homephone(row[:homephone])

  hours_of_day << clean_datetime(row[:regdate]).hour
  days_of_week << clean_datetime(row[:regdate]).wday
end
display_max_regs(hours_of_day, 'hour')
display_max_regs(days_of_week, 'day of week')
