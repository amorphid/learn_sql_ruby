require "csv"
require "fileutils"

RSpec.describe "Import CSV To Table" do
  CSV_PATH = File.join(Dir.pwd,"spec","tmp","blackcurrants.csv")

  before do
    data = CSV.generate do |csv|
      csv << [:is_blackcurrant]
      csv << [true]
      csv << [true]
      csv << [true]
    end
    File.write(CSV_PATH,data)
    LearnSQL.query(%q{
      CREATE TABLE blackcurrants (
        id SERIAL,
        is_blackcurrant BOOLEAN,
        PRIMARY KEY (id)
      );
    })
  end

  after do
    FileUtils.rm(CSV_PATH)
    LearnSQL.query("DROP TABLE blackcurrants;")
  end

  it "3 blackcurrants" do
    expect {
      LearnSQL.query(%Q{
        COPY blackcurrants(is_blackcurrant)
        FROM '#{CSV_PATH}'
        DELIMITER ',' CSV HEADER;
      })
    }
    .to change {
      LearnSQL.query(%{
        SELECT id,is_blackcurrant
        FROM blackcurrants
        ORDER BY id;
      })
    }
    .from([])
    .to([
      # id,is_blackcurrant
      [1,true],
      [2,true],
      [3,true],
    ])
  end
end
