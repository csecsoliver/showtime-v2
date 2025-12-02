import create_table, types, add_column from require "lapis.db.schema"

{
    [1]: =>
        create_table "users", {
            {"id", types.integer primary_key: true}
            {"email", types.text unique: true}
            {"passhash", types.text default: ""}
            {"role", types.integer default: 10}
        }
        create_table "workshops", {
            {"id", types.integer primary_key: true}
            {"user_id", types.integer}
            {"created_at", types.integer}
            {"date", types.integer default: -1}
            {"location", types.text default: ""}
            {"max_participants", types.integer default: -1}
            {"sponsor", types.text default: "none"}
            {"open", types.number}
            {"extra_text", types.text default: ""}
            {"extra_text_visibility", types.number default: 0}
        }
        create_table "files", {
            {"id", types.integer primary_key:true}
            {"workshop_id", types.integer}
            {"path", types.text}
        }
        create_table "participations", {
            {"id", types.integer primary_key:true}
            {"workshop_id", types.integer}
            {"user_id", types.integer}
            {"confirmed", types.number default: 0}
            {"name", types.number}
            {"notes", types.text default: ""}
        }
        -- add_column "posts", "thumbnail_path", types.text default: ""
}