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
            {"visibility", types.integer}
            {"extra_text", types.text default: ""}
            {"extra_text_visibility", types.integer default: 0}
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
            {"approved", types.integer default: 0}
            {"name", types.text}
            {"notes", types.text default: ""}
        }
        create_table "email_codes", {
            {"id", types.integer primary_key: true}
            {"code", types.text}
            {"user_id", types.integer}
        }
        create_table "session_tokens", {
            {"id", types.integer primary_key: true}
            {"token", types.text}
            {"user_id", types.integer}
            {"expiry", types.integer}
        }
        create_table "invites", {
            {"id", types.integer primary_key: true}
            {"workshop_id", types.integer}
            {"user_id", types.integer}
            {"code", types.text}
            {"uses_left", types.integer default: 1}
        }
        -- add_column "posts", "thumbnail_path", types.text default: ""
}