RSpec.describe LearnSQL do
  before do
    LearnSQL.query(%q{
      CREATE TABLE passionfruits (
        id SERIAL,
        name CHARACTER VARYING,
        is_rich BOOLEAN,
        PRIMARY KEY (id)
      );
    })
    LearnSQL.query(%q{
      CREATE TABLE powerful_passionfruits (
        id SERIAL,
        passionfruit_id INT,
        PRIMARY KEY (id)
      );
    })
    LearnSQL.query(%q{
      INSERT INTO passionfruits (name,is_rich)
      VALUES ('Bob',TRUE),
             ('Susie',TRUE),
             ('Jennifer',TRUE),
             ('George',FALSE),
             ('Amanda',FALSE),
             ('Stinky',FALSE);
    })
    LearnSQL.query(%q{
      INSERT INTO powerful_passionfruits (passionfruit_id)
      VALUES (1),
             (3),
             (5);
    })
  end

  after do
    LearnSQL.query("DROP TABLE passionfruits;")
    LearnSQL.query("DROP TABLE powerful_passionfruits;")
  end

  describe "EXCEPT" do
    it "any passionfruit that is not both rich and powerful" do
      actual = LearnSQL.query(%q{
        SELECT id,name,is_rich
        FROM passionfruits
        EXCEPT
        SELECT passionfruits.id,passionfruits.name,passionfruits.is_rich
        FROM passionfruits
        INNER JOIN powerful_passionfruits
        ON passionfruits.id = powerful_passionfruits.passionfruit_id
        WHERE passionfruits.is_rich = TRUE
        ORDER BY id;
      })
      expected = [
        # id,name,is_rich
        [2,"Susie",true],
        [4,"George",false],
        [5,"Amanda",false],
        [6,"Stinky",false],
      ]
      expect(actual).to eq(expected)
    end
  end
end
