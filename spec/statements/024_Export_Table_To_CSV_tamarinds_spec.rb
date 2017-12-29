require "csv"
require "fileutils"

RSpec.describe "Export Table To CSV" do
  CSV_PATH = File.join(Dir.pwd,"spec","tmp","tamarinds.csv")

  before do
    LearnSQL.query(%q{
      CREATE TABLE tamarinds (
        id SERIAL,
        eaten_by CHARACTER VARYING,
        PRIMARY KEY (id)
      );
    })
    LearnSQL.query(%q{
      INSERT INTO tamarinds (eaten_by)
      VALUES ('Susie'),
             ('Bob'),
             ('Tamarind The Canibal');
    })
  end

  after do
    # require 'pry'; binding.pry
    FileUtils.rm(CSV_PATH)
    LearnSQL.query("DROP TABLE tamarinds;")
  end

  it "with no headers" do
    expect {
      LearnSQL.query(%{
        COPY tamarinds
        TO '#{CSV_PATH}'
        DELIMITER ',' CSV;
      })
    }
    .to change {
      File.exist?(CSV_PATH) && [].tap do |data|
        File.read(CSV_PATH).tap  do |csv|
          CSV.parse(csv) {|row| data << row}
        end
      end
    }
    .from(false)
    .to([
      ["1","Susie"],
      ["2","Bob"],
      ["3","Tamarind The Canibal"],
    ])
  end

  it "with headers" do
    expect {
      LearnSQL.query(%{
        COPY tamarinds
        TO '#{CSV_PATH}'
        DELIMITER ',' CSV HEADER;
      })
    }
    .to change {
      File.exist?(CSV_PATH) && [].tap do |data|
        File.read(CSV_PATH).tap  do |csv|
          CSV.parse(csv) {|row| data << row}
        end
      end
    }
    .from(false)
    .to([
      ["id","eaten_by"],
      ["1","Susie"],
      ["2","Bob"],
      ["3","Tamarind The Canibal"],
    ])
  end
end
