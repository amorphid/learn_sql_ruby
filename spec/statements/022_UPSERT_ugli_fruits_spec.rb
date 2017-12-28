RSpec.describe "Upsert" do
  before do
    LearnSQL.query(%q{
      CREATE TABLE ugli_fruits (
        id SERIAL,
        name CHARACTER VARYING UNIQUE,
        believes_self_has_inner_beauty BOOLEAN,
        PRIMARY KEY (id)
      );
    })
    LearnSQL.query(%q{
      INSERT INTO ugli_fruits (name,believes_self_has_inner_beauty)
      VALUES ('Pat',FALSE),
             ('Charlie',FALSE);
    })
  end

  after do
    LearnSQL.query("DROP TABLE ugli_fruits;")
  end

  it "all ulgi fruits for improved self esteem" do
    expect {
      LearnSQL.query(%q{
        INSERT INTO ugli_fruits (name,believes_self_has_inner_beauty)
        VALUES ('Pat',TRUE),
               ('Charlie',TRUE),
               ('Jessie',TRUE)
        ON CONFLICT (name)
        DO UPDATE SET believes_self_has_inner_beauty =
          EXCLUDED.believes_self_has_inner_beauty;
      })
    }
    .to change {
      LearnSQL.query(%{
        SELECT name,believes_self_has_inner_beauty
        FROM ugli_fruits
        ORDER BY name;
      })
    }
    .from([
      # name,believes_self_has_inner_beauty
      ["Charlie",false],
      ["Pat",false],
    ])
    .to([
      # name,believes_self_has_inner_beauty
      ["Charlie",true],
      ["Jessie",true],
      ["Pat",true],
    ])
  end
end
