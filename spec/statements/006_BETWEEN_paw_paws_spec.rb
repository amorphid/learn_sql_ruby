RSpec.describe "BETWEEN" do
  before do
    LearnSQL.query(%q{
      CREATE TABLE paw_paws (
        id SERIAL,
        picked_on TIMESTAMP WITH TIME ZONE,
        PRIMARY KEY (id)
      );
    })
    LearnSQL.query(%q{
      INSERT INTO paw_paws (picked_on)
      VALUES ('2017-11-30T00:00:00.000000000+0000'), -- IS08601 /w microsec pre.
             ('2017-12-01T00:00:00.000000000+0000'),
             ('2017-12-02T00:00:00.000000000+0000'),
             ('2017-12-03T00:00:00.000000000+0000'),
             ('2017-12-04T00:05:00.000000000+0000'),
             ('2017-12-04T00:05:25.000000000+0000'),
             ('2017-12-04T00:05:35.000000000+0000'),
             ('2017-12-04T00:05:00.000000000+0000');
    })
  end

  after do
    LearnSQL.query("DROP TABLE paw_paws;")
  end

  it "December 1 and December 3" do
    actual = LearnSQL.query(%q{
      SELECT id,picked_on
      FROM paw_paws
      WHERE picked_on
      BETWEEN '2017-12-01 UTC' -- date with time zone
      AND '2017-12-03 UTC'
      ORDER BY id;
    })
    expected = [
      # id,picked_on
      [2,DateTime.parse("2017-12-01+0").to_time()], # +0 signifies UTC
      [3,DateTime.parse("2017-12-02+0").to_time()],
      [4,DateTime.parse("2017-12-03+0").to_time()],
    ]
    expect(actual).to eq(expected)
  end

  it "December 4, 5:15 a.m. (UTC) and December 4, 5:45 a.m. (UTC)" do
    actual = LearnSQL.query(%q{
      SELECT picked_on
      FROM paw_paws
      WHERE picked_on
      BETWEEN '2017-12-04 00:05:15.000000000 -0000' -- (maybe) strftime format
      AND '2017-12-04 00:05:45.000000000 -0000'
      ORDER BY picked_on;
    })
    expected = [
      # picked_on
      [DateTime.parse("2017-12-04 00:05:25 -0000").to_time],
      [DateTime.parse("2017-12-04 00:05:35 -0000").to_time],
    ]
    expect(actual).to eq(expected)
  end
end
