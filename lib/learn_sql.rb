# dependencies
require "pg"

# learn_sql
require "learn_sql/version"

module LearnSQL
  DB = "learn_sql_ruby".freeze
  
  class << self
    def conn()
      @conn
    end

    def query(sql,params=[])
      raise "not connected" unless conn()
      # query database
      conn().exec_params(sql,params)
    end

    def start()
      raise "already started" if conn()

      # open connection to database (and create database if necessary)
      @conn ||= begin
        PG.connect(dbname: DB)
      rescue
        temp_conn = PG.connect(dbname: "template1")
        temp_conn.exec_params("CREATE DATABASE #{DB}")
        temp_conn.close()
        PG.connect(dbname: DB)
      end
      # configure connection to return native types (e.g. return `1`, not `"1"`)
      @conn.type_map_for_results = PG::BasicTypeMapForResults.new(@conn)
      :ok
    end

    def stop()
      raise "not started" unless conn()
      # close connection
      conn().close
      @conn = nil
      :ok
    end
  end
end
