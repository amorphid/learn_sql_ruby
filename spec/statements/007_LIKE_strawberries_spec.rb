RSpec.describe "LIKE" do
  before do
    LearnSQL.query(%q{
      CREATE TABLE strawberries (
        id SERIAL,
        picked_by CHARACTER VARYING,
        PRIMARY KEY (id)
      );
    })
    LearnSQL.query(%q{
      INSERT INTO strawberries (picked_by)
      VALUES ('Andy'),
             ('Betty'),
             ('Jenny'),
             ('Jessie'),
             ('Jose'),
             ('Voltron');
    })
  end

  after do
    LearnSQL.query("DROP TABLE strawberries;")
  end

  it "picked by Andy" do
    sql = %q{
      SELECT id,picked_by
      FROM strawberries
      WHERE picked_by LIKE $1; -- in this case, same as `WHERE picked_by = $1`
    }
    params = ["Andy"]
    actual = LearnSQL.query(sql,params)
    expected = [
      # id,picked_by
      [1,"Andy"],
    ]
    expect(actual).to eq(expected)
  end

  it "picked by names starting with 'Je'" do
    sql = %q{
      SELECT picked_by
      FROM strawberries
      WHERE picked_by LIKE $1
      ORDER BY picked_by;
    }
    params = ["Je%"]
    actual = LearnSQL.query(sql,params)
    expected = [
      # picked_by
      ["Jenny"],
      ["Jessie"],
    ]
    expect(actual).to eq(expected)
  end

  it "picked by names containing an 'e'" do
    sql = %q{
      SELECT picked_by
      FROM strawberries
      WHERE picked_by LIKE $1
      ORDER BY picked_by;
    }
    params = ["%e%"]
    actual = LearnSQL.query(sql,params)
    expected = [
      # picked_by
      ["Betty"],
      ["Jenny"],
      ["Jessie"],
      ["Jose"],
    ]
    expect(actual).to eq(expected)
  end

  it "picked by 7 letter names with 'lt' as 3rd & 4th letters" do
    sql = %q{
      SELECT picked_by
      FROM strawberries
      WHERE picked_by LIKE $1
      ORDER BY picked_by;
    }
    params = ["__lt___"]
    actual = LearnSQL.query(sql,params)
    expected = [
      # picked_by
      ["Voltron"],
    ]
    expect(actual).to eq(expected)
  end
end
