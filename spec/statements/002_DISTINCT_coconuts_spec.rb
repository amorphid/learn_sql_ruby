RSpec.describe "DISTINCT" do
  before do
    LearnSQL.query(%q{
      CREATE TABLE coconuts (
        id serial,
        weight_lbs int,
        milk_oz int,
        PRIMARY KEY (id)
      );
    })
    LearnSQL.query(%q{
      INSERT INTO coconuts (weight_lbs,milk_oz)
      VALUES (10,8),
             (10,9),
             (10,9),
             (11,8),
             (11,10);
    })
  end

  after do
    LearnSQL.query("DROP TABLE coconuts;")
  end

  it "coconuts" do
    actual = LearnSQL.query(%q{
      SELECT DISTINCT weight_lbs,milk_oz
      FROM coconuts
      ORDER BY weight_lbs,milk_oz;
    })
    expected = [
      # weight_lbs,milk_oz
      [10,8],
      [10,9],
      [11,8],
      [11,10],
    ]
    expect(actual).to eq(expected)
  end

  it "coconuts weights" do
    actual = LearnSQL.query(%q{
      SELECT DISTINCT weight_lbs
      FROM coconuts
      ORDER BY weight_lbs;
    })
    expected = [
      # weight_lbs
      [10],
      [11],
    ]
    expect(actual).to eq(expected)
  end

  it "coconuts on weight_lbs" do
    actual = LearnSQL.query(%q{
      SELECT DISTINCT ON (weight_lbs) weight_lbs,milk_oz
      FROM coconuts
      ORDER BY weight_lbs,milk_oz;
    })
    expected = [
      # weight_lbs,milk_oz
      [10,8],
      [11,8],
    ]
    expect(actual).to eq(expected)
  end

  it "coconuts on milk_oz" do
    actual = LearnSQL.query(%q{
      SELECT DISTINCT ON (milk_oz) weight_lbs,milk_oz
      FROM coconuts
      ORDER BY milk_oz;
    })
    expected = [
      # weight_lbs,milk_oz
      [10,8],
      [10,9],
      [11,10],
    ]
    expect(actual).to eq(expected)
  end
end
