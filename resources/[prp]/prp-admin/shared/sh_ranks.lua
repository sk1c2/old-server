URP.Admin:AddRank("owner", {
    inherits = "dev",
    issuperadmin = true,
    allowafk = true,
    grant = 101
})

URP.Admin:AddRank("dev", {
    inherits = "superadmin",
    issuperadmin = true,
    allowafk = true,
    grant = 100
})

URP.Admin:AddRank("superadmin", {
    inherits = "admin",
    issuperadmin = true,
    allowafk = true,
    grant = 101
})

URP.Admin:AddRank("admin", {
    inherits = "moderator",
    allowafk = true,
    isadmin = true,
    grant = 98
})

URP.Admin:AddRank("moderator", {
    inherits = "trusted",
    isadmin = true,
    grant = 97
})

URP.Admin:AddRank("trusted", {
    inherits = "user",
    isadmin = true,
    grant = 96
})

URP.Admin:AddRank("user", {
    inherits = "",
    grant = 1
})