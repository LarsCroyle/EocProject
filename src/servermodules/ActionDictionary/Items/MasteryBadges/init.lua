return {
    ["Common Rapier Mastery Badge"] = {
        Name = "Common Rapier Mastery Badge",
        Actions = {
            Added = {
                Action = {
                    {0, function(self)
                        print("Rapier Mastery Badge Added")
                    end}
                },
                ActionInformation = {
                    Active = false
                }
            },
            Removed = {
                Action = {
                    {0, function(self)
                        print("Rapier Mastery Badge Removed")
                    end}
                },
                ActionInformation = {
                    Active = false
                }
            }
        },
        Assets = {}
    }
}