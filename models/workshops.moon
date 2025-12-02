import Model from require "lapis.db.model"

class Workshops extends Model
    @relations: {
        {"user", belongs_to: "Users"}
        {"participations", has_many: "Participations"}
    }
    @open: enum {
        invite_only: 0
        unlisted: 1
        public: 2
    }