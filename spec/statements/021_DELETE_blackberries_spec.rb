RSpec.describe "DELETE" do
  before do
    LearnSQL.query(%q{
      CREATE TABLE blackberries (
        id SERIAL,
        stem_length_mm INT,
        PRIMARY KEY (id)
      );
    })
    LearnSQL.query(%q{
      INSERT INTO blackberries (stem_length_mm)
      VALUES (4),
             (5),
             (5);
    })
  end

  after do
    LearnSQL.query("DROP TABLE blackberries;")
  end

  it "the 2nd blackberry" do
    expect {
      LearnSQL.query(%q{
        DELETE FROM blackberries
        WHERE id = 2;
      })
    }
    .to change {
      LearnSQL.query(%{
        SELECT id,stem_length_mm
        FROM blackberries
        ORDER BY id;
      })
    }
    .from([
      # id,stem_length_mm
      [1,4],
      [2,5],
      [3,5],
    ])
    .to([
      # id,stem_length_mm
      [1,4],
      [3,5],
    ])
  end

  it "blackberries with stem_length_mm greater than 4" do
    expect {
      LearnSQL.query(%q{
        DELETE FROM blackberries
        WHERE stem_length_mm > 4;
      })
    }
    .to change {
      LearnSQL.query(%{
        SELECT id,stem_length_mm
        FROM blackberries
        ORDER BY id;
      })
    }
    .from([
      # id,stem_length_mm
      [1,4],
      [2,5],
      [3,5],
    ])
    .to([
      # id,stem_length_mm
      [1,4],
    ])
  end

  it "all blackberries" do
    expect {
      LearnSQL.query(%q{
        DELETE FROM blackberries;
      })
    }
    .to change {
      LearnSQL.query(%{
        SELECT id,stem_length_mm
        FROM blackberries
        ORDER BY id;
      })
    }
    .from([
      # id,stem_length_mm
      [1,4],
      [2,5],
      [3,5],
    ])
    .to([])
  end
end
