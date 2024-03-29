namespace :etl do
  desc "Create feedback index from lib/data/5_feedback.csv"
  task create_feedback_index: :environment do
    Feedback.recreate_index

    puts "Loading feedback data..."

    records_path = Rails.root.join('lib', 'data', '5_feedback_records.yml')
    records = YAML.load_file(records_path, permitted_classes: [Time])
    records.each do |row|
      Feedback.index_data(data_mapping(row), refresh: true)
    end

    puts "Done!"
  end

  def data_mapping(row)
    row['vector'] = JSON.parse(row['vector'])
    row
  end
end
