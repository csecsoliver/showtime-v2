import Model, enum from require "lapis.db.model"

class Workshops extends Model
    @relations: {
        {"user", belongs_to: "Users"}
        {"participations", has_many: "Participations"}
        {"files", has_many: "Files"}
    }
    @visibility: enum {
        invite_only: 0
        unlisted: 1
        public: 2
    }
    @extra_text_visibility: enum {
        organizers_only: 0
        participants: 1
        everyone: 2
    }