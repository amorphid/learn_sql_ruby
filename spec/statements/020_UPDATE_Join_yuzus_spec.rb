RSpec.describe "UPDATE Join" do
  before do
    LearnSQL.query(%q{
      CREATE TABLE yuzus (
        id SERIAL,
        diameter_mm INT,
        PRIMARY KEY (id)
      );
    })
    LearnSQL.query(%q{
      CREATE TABLE inspections (
        id SERIAL,
        yuzu_id INT,
        is_valid BOOLEAN,
        PRIMARY KEY (id)
      );
    })
    LearnSQL.query(%q{
      INSERT INTO yuzus (diameter_mm)
      VALUES (54),
             (55),
             (65);
    })
    LearnSQL.query(%q{
      INSERT INTO inspections (yuzu_id,is_valid)
      VALUES (1,false),
             (2,false),
             (3,false),
             (3,false);
    })
  end

  after do
    LearnSQL.query("DROP TABLE yuzus;")
    LearnSQL.query("DROP TABLE inspections;")
  end

  it "2 inspections where yuzu diameter 65 or more" do
    expect {
      LearnSQL.query(%q{
        UPDATE inspections
        SET is_valid = TRUE
        FROM yuzus
        WHERE inspections.yuzu_id = yuzus.id
        AND yuzus.diameter_mm >= 65;
      })
    }
    .to change {
      LearnSQL.query(%{
        SELECT id,yuzu_id,is_valid
        FROM inspections
        ORDER BY id;
      })
    }
    .from([
      # id,yuzu_id,is_valid
      [1,1,false],
      [2,2,false],
      [3,3,false],
      [4,3,false],
    ])
    .to([
      # id,yuzu_id,is_valid
      [1,1,false],
      [2,2,false],
      [3,3,true],
      [4,3,true],
    ])
  end

  it "3 inspections where yuzu diameter 55 or more" do
    expect {
      LearnSQL.query(%q{
        UPDATE inspections
        SET is_valid = TRUE
        FROM yuzus
        WHERE inspections.yuzu_id = yuzus.id
        AND yuzus.diameter_mm >= 55;
      })
    }
    .to change {
      LearnSQL.query(%{
        SELECT id,yuzu_id,is_valid
        FROM inspections
        ORDER BY id;
      })
    }
    .from([
      # id,yuzu_id,is_valid
      [1,1,false],
      [2,2,false],
      [3,3,false],
      [4,3,false],
    ])
    .to([
      # id,yuzu_id,is_valid
      [1,1,false],
      [2,2,true],
      [3,3,true],
      [4,3,true],
    ])
  end
end
