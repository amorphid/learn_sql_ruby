RSpec.describe "WHERE" do
  before do
    LearnSQL.query(%q{
      CREATE TABLE pears (
        id serial,
        variety character varying,
        seed_count int,
        PRIMARY KEY (id)
      );
    })
    LearnSQL.query(%q{
      INSERT INTO pears (variety,seed_count)
      VALUES ('Comice',6),
             ('Asian',7),
             ('Williams',8),
             ('Asian',10);
    })
  end

  after do
    LearnSQL.query("DROP TABLE pears;")
  end

  it "variety is Asian" do
    actual = LearnSQL.query(%q{
      SELECT variety,seed_count
      FROM pears
      WHERE variety = 'Asian'
      ORDER BY seed_count;
    })
    expected = [
      # variety,seed_count
      ["Asian",7],
      ["Asian",10],
    ]
    expect(actual).to eq(expected)
  end

  it "seed count is greater than 6 is Asian" do
    actual = LearnSQL.query(%q{
      SELECT variety,seed_count
      FROM pears
      WHERE seed_count > 6
      ORDER BY seed_count;
    })
    expected = [
      # variety,seed_count
      ["Asian",7],
      ["Williams",8],
      ["Asian",10],
    ]
    expect(actual).to eq(expected)
  end

  it "using a param for seed_count" do
    sql = %q{
      SELECT variety,seed_count
      FROM pears
      WHERE seed_count > $1
      ORDER BY seed_count;
    }
    params = [6] # params are feature of pg client (aka not an SQL feature)
    actual = LearnSQL.query(sql,params)
    expected = [
      # variety,seed_count
      ["Asian",7],
      ["Williams",8],
      ["Asian",10],
    ]
    expect(actual).to eq(expected)
  end
end
