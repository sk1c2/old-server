Citizen.CreateThread(function()

    local CHAIRS = {
        -99500382,
        -1118419705,
        538002882,
        525667351,
        1805980844,
        826023884,
        764848282,
        -741944541,
        -377849416,
        -992710074,
        867556671,
        1716133836,
        146905321,
        603897027
    }

    AddTargetModel(
        CHAIRS,
        {
            options = {
                {
                    event = "animation:Chair",
                    icon = "fas fa-chair",
                    label = "Sit Down!"
                }
            },
            distance = 1.5
        }
    )

    local mp_m_freemode_01 = {
        [1] = 1885233650,
        [2] = -1667301416
    }

    AddTargetModel(
        mp_m_freemode_01,
        {
            options = {
                {
                    event = "police:forceEnter",
                    icon = "fas fa-sign-in-alt",
                    label = "Seat Player!"
                },
                {
                    event = "unseatPlayer",
                    icon = "fas fa-sign-out-alt",
                    label = "Unseat Player!"
                },
                {
                    event = "escortPlayer", 
                    icon = "fas fa-people-arrows",
                    label = "Escort Player!"
                },
                {
                    event = "carryfunction", 
                    icon = "fas fa-people-carry", 
                    label = "Carry Player!"
                },
                {
                    event = "prp-stealtrigger", 
                    icon = "fab fa-searchengin",  
                    label = "Rob Target Player!"
                }
            },
            distance = 1.0
        }
    )

    local doors = {
        "bonnet"
    }

    AddTargetVehicle(doors,
        {
            options = {
                {
                    event = "police:forceEnter",
                    icon = "fas fa-sign-in-alt",
                    label = "Seat Player!"
                },
                {
                    event = "unseatPlayer",
                    icon = "fas fa-sign-out-alt",
                    label = "Unseat Player!"
                },
                {
                    event = "prp-givekey",
                    icon = "fas fa-key",
                    label = "Give The Car Key!"
                },
                {
                    event = "FlipVehicle",
                    icon = "fas fa-undo",
                    label = "Flip the Vehicle!"
                },
                {
                    event = "impoundVehicleee",
                    icon = "fas fa-truck-pickup",
                    label = "Vehicle Scuff / Impound!" 
                },
                {
                    event = "trunkgetinlol",
                    icon = "fas fa-car-alt",
                    label = "Get In Trunk!"  
                },
            },
            distance = 1.5
        }
    )
    

    -------- Police --------


    AddBoxZone("PDArmory", vector3(481.49, -994.94, 30.69), 1, 3.2, {
	name="PDArmory",
	heading=0,
	debugPoly=false,
    minZ=27.54,
    maxZ=31.54
    }, {
        options = {
            {
                event = "police:openArmoury",
                icon = "far fa-clipboard",
                label = "PD Armory",
            },
        },
        distance = 3.5
    })   
    
    AddBoxZone("EMSShop", vector3(306.7157, -601.7974, 43.2841), 1, 3.2, {
        name="EMSShop",
        heading=0,
        debugPoly=false,
        minZ=42.54,
        maxZ=44.54
        }, {
            options = {
                {
                    event = "ems:openCabinet",
                    icon = "far fa-clipboard",
                    label = "Open Cabinet",
                },
            },
            distance = 3.5
    })     

    AddBoxZone("EMSLocker", vector3(298.6602, -598.1305, 43.2841), 1, 4.6, {
        name="EMSLocker",
        heading=76.09740447998,
        debugPoly=false,
        minZ=42.54,
        maxZ=44.54
        }, {
            options = {
                {
                    event = "ems:openPersonalLocker",
                    icon = "far fa-clipboard",
                    label = "Open Personal Locker",
                },
            },
            distance = 3.5
    })     

    AddBoxZone("TrashLocker", vector3(474.2585, -991.0026, 26.27328), 1, 3.2, {
        name="TrashLocker",
        heading=0,
        debugPoly=false,
        minZ=20.54,
        maxZ=29.54
        }, {
            options = {
                {
                    event = "police:openTrash",
                    icon = "far fa-clipboard",
                    label = "Trash Locker",
                },
            },
            distance = 3.5
        })     

    AddBoxZone("personallocker", vector3(447.66, -997.68, 30.68), 1, 5.2, {
	    name="personallocker",
        heading=0,
        debugPoly=false,
        minZ=28.54,
        maxZ=35.54
    }, {
        options = {
            {
                event = "police:openPersonalLocker",
                icon = "fas fa-search",
                label = "Personal Locker",
            },
        },
        distance = 1.5
    })

    -------- EMS ASS --------

    AddCircleZone("checkin", vector3(307.53, -595.28, 43.08), 0.33, {
	name="checkin",
    debugPoly=false,
    useZ=true
    }, {
        options = {
            {
                event = "prp-checkin:doc",
                icon = "far fa-clipboard",
                label = "Check In",
            },
            {
                event = "prp-page:doctor",
                icon = "fas fa-pager",
                label = "Page Doctor",
            },
        },
        distance = 1.5
    })

    -------- ATMS --------  

    local atms = {
        -1126237515,
        506770882,
        -870868698,
        150237004,
        -239124254,
        -1364697528,  
    }
    AddTargetModel(atms, {
        options = {
            {
                event = "bank:checkATM",
                icon = "fas fa-credit-card",
                label = "Use ATM",
            },
        },
        distance = 1.5
    })

    -- spikes

        -------- ATMS --------  

        local spikes = {
            -874338148  
        }
        AddTargetModel(spikes, {
            options = {
                {
                    event = "prp-spikes:removeSpike",
                    icon = "fas fa-wrench",
                    label = "Delete Spikestrip",
                },
            },
            distance = 2.5
        })


    -------- Weapon Shop --------
    AddCircleZone("weapon1", vector3(20.49, -1105.36, 29.6), 1.35, {
    name="weapon1",
    debugPoly=false,
    useZ=true,
    }, {
        options = {
            {
                event = "prp-weapon:shop",
                icon = "fas fa-wrench",
                label = "Purchase Weapons",
            },
        },
        distance = 1.5
    })
    AddCircleZone("weapon2", vector3(812.28, -2158.45, 29.42), 1.35, {
    name="weapon2",
    debugPoly=false,
    useZ=true,
    }, {
        options = {
            {
                event = "prp-weapon:shop",
                icon = "fas fa-wrench",
                label = "Purchase Weapons",
            },
        },
        distance = 1.5
    })
    AddCircleZone("weapon3", vector3(844.47, -1034.7, 28.09), 1.35, {
    name="weapon3",
    debugPoly=false,
    useZ=true,
    }, {
        options = {
            {
                event = "prp-weapon:shop",
                icon = "fas fa-wrench",
                label = "Purchase Weapons",
            },
        },
        distance = 1.5
    })
    AddCircleZone("weapon4", vector3(253.94, -48.42, 69.74), 1.35, {
    name="weapon4",
    debugPoly=false,
    useZ=true,
    }, {
        options = {
            {
                event = "prp-weapon:shop",
                icon = "fas fa-wrench",
                label = "Purchase Weapons",
            },
        },
        distance = 1.5
    })
    AddCircleZone("weapon5", vector3(-1304.19, -392.54, 36.5), 1.35, {
    name="weapon5",
    debugPoly=false,
    useZ=true,
    }, {
        options = {
            {
                event = "prp-weapon:shop",
                icon = "fas fa-wrench",
                label = "Purchase Weapons",
            },
        },
        distance = 1.5
    })
    AddCircleZone("weapon6", vector3(-3173.72, 1086.28, 20.64), 1.35, {
    name="weapon6",
    debugPoly=false,
    useZ=true,
    }, {
        options = {
            {
                event = "prp-weapon:shop",
                icon = "fas fa-wrench",
                label = "Purchase Weapons",
            },
        },
        distance = 1.5
    })
    AddCircleZone("weapon7", vector3(1691.36, 3759.04, 34.56), 1.35, {
    name="weapon7",
    debugPoly=false,
    useZ=true,
    }, {
        options = {
            {
                event = "prp-weapon:shop",
                icon = "fas fa-wrench",
                label = "Purchase Weapons",
            },
        },
        distance = 1.5
    })
    AddCircleZone("weapon8", vector3(-332.65, 6083.1, 31.3), 1.35, {
    name="weapon8",
    debugPoly=false,
    useZ=true,
    }, {
        options = {
            {
                event = "prp-weapon:shop",
                icon = "fas fa-wrench",
                label = "Purchase Weapons",
            },
        },
        distance = 1.5
    })
    AddCircleZone("weapon9", vector3(2569.97, 293.22, 108.63), 1.35, {
    name="weapon9",
    debugPoly=false,
    useZ=true,
    }, {
        options = {
            {
                event = "prp-weapon:shop",
                icon = "fas fa-wrench",
                label = "Purchase Weapons",
            },
        },
        distance = 1.5
    })
    AddCircleZone("weapon10", vector3(-664.24, -934.2, 21.73), 1.35, {
    name="weapon10",
    debugPoly=false,
    useZ=true,
    }, {
        options = {
            {
                event = "prp-weapon:shop",
                icon = "fas fa-wrench",
                label = "Purchase Weapons",
            },
        },
        distance = 1.5
    })
    AddCircleZone("weapon11", vector3(-1120.08, 2697.97, 18.45), 1.35, {
    name="weapon11",
    debugPoly=false,
    useZ=true,
    }, {
        options = {
            {
                event = "prp-weapon:shop",
                icon = "fas fa-wrench",
                label = "Purchase Weapons",
            },
        },
        distance = 1.5
    })

    -------- Prison --------
    AddCircleZone("prison1", vector3(1778.73, 2558.14, 46.12), 0.81,{
    name="prison1",
    debugPoly=false,
    useZ=true,
    }, {
        options = {
            {
                event = "urp:make:slushy",
                icon = "fas fa-ice-cream",
                label = "Make Slushy",
            },
        },
        distance = 1.5
    })
    AddCircleZone("prison2", vector3(1783.13, 2558.37, 45.67), 3,{
    name="prison2",
    debugPoly=false,
    useZ=true,
    }, {
        options = {
            {
                event = "urp:access:jailfood",
                icon = "fas fa-bread-slice",
                label = "Prison Food",
            },
        },
        distance = 1.5
    })
    AddCircleZone("reclaim", vector3(1842.0, 2579.54, 46.01), 2.81, {
    name="reclaim",
    debugPoly=false,
    useZ=true,
    }, {
        options = {
            {
                event = "urp:reclaim:possessions",
                icon = "fas fa-undo",
                label = "Reclaim Possessions",
            },
        },
        distance = 5
    })

-- BurgerShot -- 
AddCircleZone("burgerspickup", vector3(-1193.75, -894.28, 13.99), 0.5,{
    name="burgerspickup",
    debugPoly=false,
    useZ=true,
    }, {
        options = {
            {
                event = "burgershot:pickup",
                icon = "fas fa-search",
                label = "Pickup Order",
            },
        },
        distance = 1.5
    })
    AddCircleZone("burgerspickup2", vector3(-1195.50, -892.5, 13.99), 0.5,{
    name="burgerspickup2",
    debugPoly=false,
    useZ=true,
    }, {
        options = {
            {
                event = "burgershot:pickup2",
                icon = "fas fa-search",
                label = "Pickup Order",
            },
        },
        distance = 1.5
    })
    AddCircleZone("burgerspickup3", vector3(-1193.81, -907.20, 14.00), 0.5,{
        name="burgerspickup3",
        debugPoly=false,
        useZ=true,
        }, {
            options = {
                {
                    event = "burgershot:pickup3",
                    icon = "fas fa-search",
                    label = "Pickup Order",
                },
            },
            distance = 2.5
        })
    AddCircleZone("burgershotshelf", vector3(-1197.70, -894.37, 13.99), 0.8, {
    name="burgershotshelf",
    debugPoly=false,
    useZ=true,
    }, {
        options = {
            {
                event = "burgershot:shelf",
                icon = "fas fa-box",
                label = "Shelf",
            },
        },
        distance = 1.5
    })
    AddCircleZone("burgershotdrinks", vector3(-1199.12, -896.18, 14.1), 0.5, {
        name="burgershotdrinks",
        debugPoly=false,
        useZ=true,
        }, {
            options = {
                {
                    event = "burgershot:drinks",
                    icon = "fas fa-none",
                    label = "Make Soda",
                },
            },
            distance = 1.5
        })
    AddCircleZone("burgershotfood", vector3(-1197.99, -898.17, 13.9), 0.5, {
        name="burgershotfood",
        debugPoly=false,
        useZ=true,
        }, {
            options = {
                {
                    event = "burgershot:food",
                    icon = "fas fa-bread-slice",
                    label = "Make Food",
                },
            },
            distance = 1.5
        })
    AddCircleZone("burgershotstorage", vector3(-1190.53, -903.08, 14.2), 0.5, {
        name="burgershotstorage",
        debugPoly=false,
        useZ=true,
        }, {
            options = {
                {
                    event = "burgershot:storage",
                    icon = "fas fa-box",
                    label = "Storage",
                },
            },
            distance = 1.5
        })
    AddCircleZone("burgershotfries", vector3(-1201.74, -899.17, 13.55), 0.5, {
        name="burgershotfries",
        debugPoly=false,
        useZ=true,
        }, {
            options = {
                {
                    event = "burgershot:fries",
                    icon = "fas fa-box",
                    label = "Fry Fries",
                },
            },
            distance = 1.5
        })
    --CamelTowing--
    AddCircleZone("cameltowingstash", vector3(1187.26, 2635.77, 38.40), 0.5, {
        name="cameltowingstash",
        debugPoly=false,
        useZ=true,
        }, {
            options = {
                {
                    event = "prp-camel:stash",
                    icon = "fas fa-box",
                    label = "Storage",
                },
            },
            distance = 1.5
        })
    AddCircleZone("cameltowingcrafting", vector3(1174.86, 2635.20, 37.75), 0.5, {
        name="cameltowingcrafting",
        debugPoly=false,
        useZ=true,
        }, {
            options = {
                {
                    event = "prp-camel:crafting",
                    icon = "fas fa-wrench",
                    label = "Crafting",
                },
            },
            distance = 1.5
        })
            --------  General Stores -------- 
    AddCircleZone("Store1", vector3(25.08, -1347.41, 29.5), 3.0, {
        name="Store1",
        debugPoly=false,
        useZ=true,
        }, {
            options = {
                {
                    event = "shop:general",
                    icon = "fas fa-shopping-basket",
                    label = "Purchase Goods",
                },
            },
            distance = 1.5
        })
        AddCircleZone("Store1s", vector3(25.11, -1345.0, 29.5), 3.0, {
        name="Store1s",
        debugPoly=false,
        useZ=true,
        }, {
            options = {
                {
                    event = "shop:general",
                    icon = "fas fa-shopping-basket",
                    label = "Purchase Goods",
                },
            },
            distance = 1.5
        })
        AddCircleZone("Store2", vector3(-706.7, -915.54, 19.22), 3.0, {
        name="Store2",
        debugPoly=false,
        useZ=true,
        }, {
            options = {
                {
                    event = "shop:general",
                    icon = "fas fa-shopping-basket",
                    label = "Purchase Goods",
                },
            },
            distance = 1.5
        })
        AddCircleZone("Store2s", vector3(-706.68, -913.55, 19.22), 3.0, {
        name="Store2s",
        debugPoly=false,
        useZ=true,
        }, {
            options = {
                {
                    event = "shop:general",
                    icon = "fas fa-shopping-basket",
                    label = "Purchase Goods",
                },
            },
            distance = 1.5
        })
        AddCircleZone("Store3", vector3(-1222.31, -907.74, 12.33), 3.0, {
        name="Store3",
        debugPoly=false,
        useZ=true,
        }, {
            options = {
                {
                    event = "shop:general",
                    icon = "fas fa-shopping-basket",
                    label = "Purchase Goods",
                },
            },
            distance = 1.5
        })
        AddCircleZone("Store4", vector3(-47.22, -1757.5, 29.42), 3.0, {
        name="Store4",
        debugPoly=false,
        useZ=true,
        }, {
            options = {
                {
                    event = "shop:general",
                    icon = "fas fa-shopping-basket",
                    label = "Purchase Goods",
                },
            },
            distance = 1.5
        })
        AddCircleZone("Store4s", vector3(-48.42, -1759.02, 29.42), 3.0, {
        name="Store4s",
        debugPoly=false,
        useZ=true,
        }, {
            options = {
                {
                    event = "shop:general",
                    icon = "fas fa-shopping-basket",
                    label = "Purchase Goods",
                },
            },
            distance = 1.5
        })
        AddCircleZone("Store5", vector3(1134.9, -982.46, 46.42), 3.0, {
        name="Store5",
        debugPoly=false,
        useZ=true,
        }, {
            options = {
                {
                    event = "shop:general",
                    icon = "fas fa-shopping-basket",
                    label = "Use",
                },
            },
            distance = 1.5
        })
        AddCircleZone("Store6", vector3(1164.08, -322.73, 69.21), 3.0, {
        name="Store6",
        debugPoly=false,
        useZ=true,
        }, {
            options = {
                {
                    event = "shop:general",
                    icon = "fas fa-shopping-basket",
                    label = "Purchase Goods",
                },
            },
            distance = 1.5
        })
        AddCircleZone("Store6s", vector3(1164.49, -324.74, 69.21), 3.0, {
        name="Store6s",
        debugPoly=false,
        useZ=true,
        }, {
            options = {
                {
                    event = "shop:general",
                    icon = "fas fa-shopping-basket",
                    label = "Purchase Goods",
                },
            },
            distance = 1.5
        })
        AddCircleZone("Store7", vector3(373.12, 326.21, 103.57), 3.0, {
        name="Store7",
        debugPoly=false,
        useZ=true,
        }, {
            options = {
                {
                    event = "shop:general",
                    icon = "fas fa-shopping-basket",
                    label = "Purchase Goods",
                },
            },
            distance = 1.5
        })
        AddCircleZone("Store7s", vector3(373.62, 328.58, 103.57), 3.0, {
        name="Store7s",
        debugPoly=false,
        useZ=true,
        }, {
            options = {
                {
                    event = "shop:general",
                    icon = "fas fa-shopping-basket",
                    label = "Purchase Goods",
                },
            },
            distance = 1.5
        })
        AddCircleZone("Store8", vector3(-1820.68, 793.82, 138.14), 3.0, {
        name="Store8",
        debugPoly=false,
        useZ=true,
        }, {
            options = {
                {
                    event = "shop:general",
                    icon = "fas fa-shopping-basket",
                    label = "Purchase Goods",
                },
            },
            distance = 1.5
        })
        AddCircleZone("Store8s", vector3(-1819.29, 792.38, 138.14), 3.0, {
        name="Store8s",
        debugPoly=false,
        useZ=true,
        }, {
            options = {
                {
                    event = "shop:general",
                    icon = "fas fa-shopping-basket",
                    label = "Purchase Goods",
                },
            },
            distance = 1.5
        })
        AddCircleZone("Store9", vector3(-2967.1, 390.97, 15.04), 3.0, {
        name="Store9",
        debugPoly=false,
        useZ=true,
        }, {
            options = {
                {
                    event = "shop:general",
                    icon = "fas fa-shopping-basket",
                    label = "Purchase Goods",
                },
            },
            distance = 1.5
        })
        AddCircleZone("Store10", vector3(-3039.1, 585.11, 7.91), 3.0, {
        name="Store10",
        debugPoly=false,
        useZ=true,
        }, {
            options = {
                {
                    event = "shop:general",
                    icon = "fas fa-shopping-basket",
                    label = "Purchase Goods",
                },
            },
            distance = 1.5
        })
        AddCircleZone("Store10s", vector3(-3041.36, 584.35, 7.91), 3.0, {
        name="Store10s",
        debugPoly=false,
        useZ=true,
        }, {
            options = {
                {
                    event = "shop:general",
                    icon = "fas fa-shopping-basket",
                    label = "Purchase Goods",
                },
            },
            distance = 1.5
        })
        AddCircleZone("Store11", vector3(-3242.17, 1000.57, 12.83), 3.0, {
        name="Store11",
        debugPoly=false,
        useZ=true,
        }, {
            options = {
                {
                    event = "shop:general",
                    icon = "fas fa-shopping-basket",
                    label = "Purchase Goods",
                },
            },
            distance = 1.5
        })
        AddCircleZone("Store11s", vector3(-3244.56, 1000.69, 12.83), 3.0, {
        name="Store11s",
        debugPoly=false,
        useZ=true,
        }, {
            options = {
                {
                    event = "shop:general",
                    icon = "fas fa-shopping-basket",
                    label = "Purchase Goods",
                },
            },
            distance = 1.5
        })
    
        AddCircleZone("Store12", vector3(2557.28, 381.38, 108.62), 3.0, {
        name="Store12",
        debugPoly=false,
        useZ=true,
        }, {
            options = {
                {
                    event = "shop:general",
                    icon = "fas fa-shopping-basket",
                    label = "Purchase Goods",
                },
            },
            distance = 1.5
        })
        AddCircleZone("Store12s", vector3(2554.88, 381.49, 108.62), 3.0, {
        name="Store12s",
        debugPoly=false,
        useZ=true,
        }, {
            options = {
                {
                    event = "shop:general",
                    icon = "fas fa-shopping-basket",
                    label = "Purchase Goods",
                },
            },
            distance = 1.5
        })
        AddCircleZone("Store13", vector3(548.46, 2671.31, 42.16), 3.0, {
        name="Store13",
        debugPoly=false,
        useZ=true,
        }, {
            options = {
                {
                    event = "shop:general",
                    icon = "fas fa-shopping-basket",
                    label = "Purchase Goods",
                },
            },
            distance = 1.5
        })
        AddCircleZone("Store13s", vector3(548.81, 2668.96, 42.16), 3.0, {
        name="Store13s",
        debugPoly=false,
        useZ=true,
        }, {
            options = {
                {
                    event = "shop:general",
                    icon = "fas fa-shopping-basket",
                    label = "Purchase Goods",
                },
            },
            distance = 1.5
        })
        AddCircleZone("Store14", vector3(1165.89, 2710.13, 38.16), 3.0, {
        name="Store14",
        debugPoly=false,
        useZ=true,
        }, {
            options = {
                {
                    event = "shop:general",
                    icon = "fas fa-shopping-basket",
                    label = "Purchase Goods",
                },
            },
            distance = 1.5
        })
        AddCircleZone("Store15", vector3(1393.04, 3605.85, 34.98), 3.0, {
        name="Store15",
        debugPoly=false,
        useZ=true,
        }, {
            options = {
                {
                    event = "shop:general",
                    icon = "fas fa-shopping-basket",
                    label = "Purchase Goods",
                },
            },
            distance = 1.5
        })
        AddCircleZone("Store16", vector3(1960.62, 3740.19, 32.34), 3.0, {
        name="Store16",
        debugPoly=false,
        useZ=true,
        }, {
            options = {
                {
                    event = "shop:general",
                    icon = "fas fa-shopping-basket",
                    label = "Purchase Goods",
                },
            },
            distance = 1.5
        })
        AddCircleZone("Store16s", vector3(1959.34, 3742.35, 32.34), 3.0, {
        name="Store16s",
        debugPoly=false,
        useZ=true,
        }, {
            options = {
                {
                    event = "shop:general",
                    icon = "fas fa-shopping-basket",
                    label = "Purchase Goods",
                },
            },
            distance = 1.5
        })
        AddCircleZone("Store17", vector3(1696.83, 4924.53, 42.06), 3.0, {
        name="Store17",
        debugPoly=false,
        useZ=true,
        }, {
            options = {
                {
                    event = "shop:general",
                    icon = "fas fa-shopping-basket",
                    label = "Purchase Goods",
                },
            },
            distance = 1.5
        })
        AddCircleZone("Store17s", vector3(1698.46, 4923.44, 42.06), 3.0, {
        name="Store17s",
        debugPoly=false,
        useZ=true,
        }, {
            options = {
                {
                    event = "shop:general",
                    icon = "fas fa-shopping-basket",
                    label = "Purchase Goods",
                },
            },
            distance = 1.5
        })
        AddCircleZone("Store18", vector3(1728.38, 6414.87, 35.04), 3.0, {
        name="Store18",
        debugPoly=false,
        useZ=true,
        }, {
            options = {
                {
                    event = "shop:general",
                    icon = "fas fa-shopping-basket",
                    label = "Purchase Goods",
                },
            },
            distance = 1.5
        })
        AddCircleZone("Store18s", vector3(1729.47, 6417.11, 35.04), 3.0, {
        name="Store18s",
        debugPoly=false,
        useZ=true,
        }, {
            options = {
                {
                    event = "shop:general",
                    icon = "fas fa-shopping-basket",
                    label = "Purchase Goods",
                },
            },
            distance = 1.5
        })
        AddCircleZone("Store19", vector3(2678.02, 3279.45, 55.24), 3.0, {
            name="Store19",
            debugPoly=false,
            useZ=true,
            }, {
                options = {
                    {
                        event = "shop:general",
                        icon = "fas fa-shopping-basket",
                        label = "Purchase Goods",
                    },
                },
                distance = 1.5
            })
        -- Iatrias restraunt
        AddCircleZone("microwaveiatria", vector3(143.8067, -1054.761, 22.96024), 1.0, {
            name="microwaveiatria",
            debugPoly=false,
            useZ=true,
            }, {
                options = {
                    {
                        event = "prp-latticepie",
                        icon = "fas fa-shopping-basket",
                        label = "Lattice Topped Pie Slice",
                    },
                    {
                        event = "prp-brownie",
                        icon = "fas fa-shopping-basket",
                        label = "Brownie",
                    },
                    {
                        event = "prp-doughnut",
                        icon = "fas fa-shopping-basket",
                        label = "Glazed Doughnut",
                    },
                    {
                        event = "prp-macaroon",
                        icon = "fas fa-shopping-basket",
                        label = "Coconut Macaroon",
                    },
                },
                distance = 1.5
            })

            AddCircleZone("boardiatria", vector3(148.3783, -1054.37, 22.96024), 1.0, {
                name="boardiatria",
                debugPoly=false,
                useZ=true,
                }, {
                    options = {
                        {
                            event = "prp-thumbprintcookie",
                            icon = "fas fa-shopping-basket",
                            label = "Thumbprint Cookie with Jam Filling",
                        },
                        {
                            event = "prp-pretzel",
                            icon = "fas fa-shopping-basket",
                            label = "Pretzel",
                        },
                        {
                            event = "prp-eclair",
                            icon = "fas fa-shopping-basket",
                            label = "Eclair",
                        },
                        {
                            event = "prp-creampuff",
                            icon = "fas fa-shopping-basket",
                            label = "Cream Puff",
                        },
                        {
                            event = "prp-strudel",
                            icon = "fas fa-shopping-basket",
                            label = "Strudel",
                        },
                    },
                    distance = 1.5
                })

                AddCircleZone("cookingiatria", vector3(146.6336, -1055.103, 22.96024), 1.0, {
                    name="cookingiatria",
                    debugPoly=false,
                    useZ=true,
                    }, {
                        options = {
                            {
                                event = "prp-cinnanomroll",
                                icon = "fas fa-shopping-basket",
                                label = "Cinnamon Roll",
                            },
                            {
                                event = "prp-raspberryslice",
                                icon = "fas fa-shopping-basket",
                                label = "Raspberry Roulade Slice",
                            },
                        },
                        distance = 1.5
                    })

                    AddCircleZone("cookingiatria2", vector3(142.8238, -1057.519, 22.96023), 1.0, {
                        name="cookingiatria2",
                        debugPoly=false,
                        useZ=true,
                        }, {
                            options = {
                                {
                                    event = "prp-souffle",
                                    icon = "fas fa-shopping-basket",
                                    label = "Souffle",
                                },
                            },
                            distance = 1.5
                        }) 
                        AddCircleZone("iatriastoragemain", vector3(134.5371, -1060.483, 22.96023), 1.0, {
                            name="iatriastoragemain",
                            debugPoly=false,
                            useZ=true,
                            }, {
                                options = {
                                    {
                                        event = "prp-bakerystoragemain",
                                        icon = "fas fa-shopping-basket",
                                        label = "Open Storage",
                                    },
                                },
                                distance = 1.5
                            })     
                            AddCircleZone("iatriacollectionbottom", vector3(132.2972, -1054.074, 23.62022), 1.0, {
                                name="iatriacollectionbottom",
                                debugPoly=false,
                                useZ=true,
                                }, {
                                    options = {
                                        {
                                            event = "prp-collectbottom",
                                            icon = "fas fa-shopping-basket",
                                            label = "Collect Order",
                                        },
                                    },
                                    distance = 1.5
                                })         
                                AddCircleZone("iatriawinecollection", vector3(126.0708, -1047.941, 22.96023), 1.0, {
                                    name="iatriawinecollection",
                                    debugPoly=false,
                                    useZ=true,
                                    }, {
                                        options = {
                                            {
                                                event = "prp-collectdrink",
                                                icon = "fas fa-shopping-basket",
                                                label = "Access Drink Storage",
                                            },
                                        },
                                        distance = 1.5
                                    })        
                                    AddCircleZone("iatriacollectorderup", vector3(124.5866, -1033.721, 29.27714), 1.0, {
                                        name="iatriacollectorderup",
                                        debugPoly=false,
                                        useZ=true,
                                        }, {
                                            options = {
                                                {
                                                    event = "prp-graborder",
                                                    icon = "fas fa-shopping-basket",
                                                    label = "Collect Order",
                                                },
                                            },
                                            distance = 1.5
                                        })   
                                        AddCircleZone("iatriadrinkmake", vector3(125.2038, -1038.269, 29.27709), 1.0, {
                                            name="iatriadrinkmake",
                                            debugPoly=false,
                                            useZ=true,
                                            }, {
                                                options = {
                                                    {
                                                        event = "prp-obtaindrinkiatria",
                                                        icon = "fas fa-shopping-basket",
                                                        label = "Grab a Drink",
                                                    },
                                                },
                                                distance = 1.5
                                            })                                    

        
        --TunerShop--
        AddCircleZone("tunercrafting", vector3(948.13, -969.31, 39.71), 0.8, {
            name="tunercrafting",
            debugPoly=false,
            useZ=true,
            }, {
                options = {
                    {
                        event = "tuner:crafting",
                        icon = "fas fa-wrench",
                        label = "Crafting",
                    },
                },
                distance = 1.5
            })
        AddCircleZone("tunermaterials", vector3(955.81, -958.27, 40.2), 0.8, {
            name="tunermaterials",
            debugPoly=false,
            useZ=true,
            }, {
                options = {
                    {
                        event = "tuner:materials",
                        icon = "fas fa-wrench",
                        label = "Access Materials",
                    },
                },
                distance = 1.5
            })
        AddCircleZone("tunerstash", vector3(949.31, -966.40, 39.50), 0.8, {
            name="tunerstash",
            debugPoly=false,
            useZ=true,
            }, {
                options = {
                    {
                        event = "tuner:stash",
                        icon = "fas fa-box",
                        label = "Tuner Stash",
                    },
                },
                distance = 1.5
            })

            --Vending Machines--
        local vending = {
            992069095,
            -654402915,
        }
        AddTargetModel(vending, {
            options = {
                {
                    event = "shop:vending",
                    icon = "fas fa-shopping-basket",
                    label = "Vending Machine",
                },
            },
            distance = 1.5
        })

        --Vanilla Unicorn--
        AddCircleZone("drinksbar", vector3(129.92, -1281.3, 28.2), 0.9, {
            name="drinksbar",
            debugPoly=false,
            useZ=true,
            }, {
                options = {
                    {
                        event = "drinks:bar",
                        icon = "fas fa-box",
                        label = "Drinks Bar",
                    },
                },
                distance = 1.5
            })

            --DriftSchool--
        AddCircleZone("driftstash", vector3(-55.75, -2519.54, 7.40), 0.9, {
            name="driftstash",
            debugPoly=false,
            useZ=true,
            }, {
                options = {
                    {
                        event = "drift:stash",
                        icon = "fas fa-box",
                        label = "Drift Stash",
                    },
                },
                distance = 1.5
            })
        AddCircleZone("tradein", vector3(-113.64, 6471.66, 31.84), 0.9, {
            name="tradein",
            debugPoly=false,
            useZ=true,
            }, {
                options = {
                    {
                        event = "trade:in",
                        icon = "fas fa-credit-card",
                        label = "Trade In",
                    },
                },
                distance = 1.5
            })
            
            --FIB--
        AddCircleZone("fibenter", vector3(176.22, -728.61, 39.40), 0.9, {
            name="fibenter",
            debugPoly=false,
            useZ=true,
            }, {
                options = {
                    {
                        event = "fib:enter",
                        icon = "far fa-clipboard",
                        label = "Use Elevator!",
                    },
                },
                distance = 1.5
            })
        AddCircleZone("fibexit", vector3(136.67, -763.84, 242.15), 0.9, {
            name="fibexit",
            debugPoly=false,
            useZ=true,
            }, {
                options = {
                    {
                        event = "fib:exit",
                        icon = "far fa-clipboard",
                        label = "Use Elevator!",
                    },
                },
                distance = 1.5
            })
        AddCircleZone("fibarmory", vector3(118.35, -728.93, 242.15), 0.9, {
            name="fibarmory",
            debugPoly=false,
            useZ=true,
            }, {
                options = {
                    {
                        event = "fib:armory",
                        icon = "far fa-clipboard",
                        label = "FIB Armory!",
                    },
                },
                distance = 1.5
            })
        AddCircleZone("fibevidence", vector3(143.87, -764.38, 242.15), 0.9, {
            name="fibevidence",
            debugPoly=false,
            useZ=true,
            }, {
                options = {
                    {
                        event = "fib:evidence",
                        icon = "far fa-clipboard",
                        label = "FIB Evidence",
                    },
                },
                distance = 1.5
            })
        
        --Gallery--
        AddCircleZone("gallerystash", vector3(-468.80, 45.21, 46.23), 0.9, {
        name="gallerystash",
        debugPoly=false,
        useZ=true,
        }, {
            options = {
                {
                    event = "gallery:stash",
                    icon = "fas fa-box",
                    label = "Cupboard",
                },
            },
            distance = 1.5
        })
        AddCircleZone("gallerytable", vector3(-422.74, 37.37, 45.43), 0.9, {
            name="gallerytable",
            debugPoly=false,
            useZ=true,
            }, {
                options = {
                    {
                        event = "gallery:table",
                        icon = "fas fa-box",
                        label = "Gem Table",
                    },
                },
                distance = 1.5
            })
        AddCircleZone("gallerytable2", vector3(-437.90, 42.50, 46.31), 2.0, {
            name="gallerytable2",
            debugPoly=false,
            useZ=true,
            }, {
                options = {
                    {
                        event = "gallery:table2",
                        icon = "far fa-clipboard",
                        label = "Gem Table",
                    },
                },
                distance = 1.5
            })

        AddCircleZone("tunerstash2", vector3(154.13, -3209.78, 6.09), 0.9, {
            name="tunerstash2",
            debugPoly=false,
            useZ=true,
            }, {
                options = {
                    {
                        event = "tuner:stash2",
                        icon = "fas fa-box",
                        label = "What dis?",
                    },
                },
                distance = 1.5
            })

            --WhiteWidow--
            local fertilizer = {
                424800391,  
            }
            AddTargetModel(fertilizer, {
                options = {
                    {
                        event = "weed:fertilizer",
                        icon = "fas fa-box",
                        label = "Grab Fertilizer",
                    },
                },
                distance = 1.5
            })
            
        AddCircleZone("whitewidow", vector3(-233.14, -305.19, 30.13), 1.0, {
            name="whitewidow",
            debugPoly=false,
            useZ=true,
            }, {
                options = {
                    {
                        event = "prp-cookshit",
                        icon = "fas fa-shopping-basket",
                        label = "Grow",
                    },
                },
                distance = 1.5
            })

            local brick = {
                -1688127,  
            }
            AddTargetModel(brick, {
                options = {
                    {
                        event = "weed:make",
                        icon = "fas fa-box",
                        label = "Roll Joints",
                    },
                },
                distance = 1.5
            })
        AddCircleZone("weedstash", vector3(-235.47, -309.86, 30.56), 1.0, {
            name="weedstash",
            debugPoly=false,
            useZ=true,
            }, {
                options = {
                    {
                        event = "weed:stash",
                        icon = "fas fa-box",
                        label = "Stash",
                    },
                },
                distance = 1.5
            })

            local pickup = {
                -1928194470, 
            }
            AddTargetModel(pickup, {
                options = {
                    {
                        event = "whitewidow:pickup",
                        icon = "fas fa-box",
                        label = "Weed Pickup",
                    },
                },
                distance = 1.5
            })

            --Pillbox--
        AddCircleZone("pillboxfloor", vector3(332.89, -569.17, 42.9), 1.0, {
            name="pillboxfloor",
            debugPoly=false,
            useZ=true,
            }, {
                options = {
                    {
                        event = "pillbox:floor",
                        icon = "far fa-clipboard",
                        label = "Elevator",
                    },
                },
                distance = 1.5
            })

            AddCircleZone("pillboxroof", vector3(338.60, -583.87, 74.16), 1.0, {
                name="pillboxroof",
                debugPoly=false,
                useZ=true,
                }, {
                    options = {
                        {
                            event = "pillbox:roof",
                            icon = "far fa-clipboard",
                            label = "Elevator",
                        },
                    },
                    distance = 1.5
                })

            AddCircleZone("churchin", vector3(-767.02, -23.19, 41.08), 2.0, {
                name="churchin",
                debugPoly=false,
                useZ=true,
                }, {
                    options = {
                        {
                            event = "urp:churchin",
                            icon = "far fa-clipboard",
                            label = "Church",
                        },
                    },
                    distance = 1.5
                })

            AddCircleZone("churchout", vector3(-785.55, -13.86, -16.77), 2.0, {
                name="churchout",
                debugPoly=false,
                useZ=true,
                }, {
                    options = {
                        {
                            event = "urp:churchout",
                            icon = "far fa-clipboard",
                            label = "Church",
                        },
                    },
                    distance = 1.5
                })

            AddCircleZone("policeduty", vector3(441.79, -982.07, 30.69), 2.0, {
                name="policeduty",
                debugPoly=false,
                useZ=true,
                }, {
                    options = {
                        {
                            event = "prp-police:duty",
                            icon = "far fa-clipboard",
                            label = "Duty",
                        },
                    },
                    distance = 1.5
                })

                local bins = {
                    `prop_dumpster_01a`,
                    `prop_dumpster_02a`,
                    `prop_dumpster_02b`,
 
                }
                AddTargetModel(bins, {
                    options = {
                        {
                            event = "search:dumpster",
                            icon = "fas fa-dumpster",
                            label = "Dumpster Dive",
                        },
                    },
                    distance = 1.5
                })

                AddCircleZone(
                    "methstart",
                    vector3(1005.750793457, -3200.4038085938, -38.519329071045),
                    0.5,
                    {
                        name = "methstart",
                        debugPoly = false,
                        useZ = false
                    },
                    {
                        options = {
                            {
                                event = "meth:start",
                                icon = "fas fa-prescription",
                                label = "Turn The Cooker On!"
                            }
                        },
                        job = {"all"},
                        distance = 2.5
                    }
                )

                AddCircleZone(
                    "methsell",
                    vector3(203.00288391113, -2016.6826171875, 17.5706615448),
                    0.5,
                    {
                        name = "methsell",
                        debugPoly = false,
                        useZ = false
                    },
                    {
                        options = {
                            {
                                event = "meth:sell",
                                icon = "fas fa-handshake",
                                label = "Hand Something Over"
                            }
                        },
                        job = {"all"},
                        distance = 2.5
                    }
                )
                AddCircleZone(
                    "methsell2",
                    vector3(225.73658752441, -1760.8559570312, 27.695140838623),
                    0.5,
                    {
                        name = "methsell",
                        debugPoly = false,
                        useZ = false
                    },
                    {
                        options = {
                            {
                                event = "meth:sell",
                                icon = "fas fa-handshake",
                                label = "Hand Something Over"
                            }
                        },
                        job = {"all"},
                        distance = 2.5
                    }
                )
                AddCircleZone(
                    "methsell3",
                    vector3(-255.40719604492, -1542.0688476562, 30.936147689819),
                    0.5,
                    {
                        name = "methsell",
                        debugPoly = false,
                        useZ = false
                    },
                    {
                        options = {
                            {
                                event = "meth:sell",
                                icon = "fas fa-handshake",
                                label = "Hand Something Over"
                            }
                        },
                        job = {"all"},
                        distance = 2.5
                    }
                )
                AddCircleZone(
                    "methsell4",
                    vector3(1235.3387451172, -413.82913208008, 67.928161621094),
                    0.5,
                    {
                        name = "methsell",
                        debugPoly = false,
                        useZ = false
                    },
                    {
                        options = {
                            {
                                event = "meth:sell",
                                icon = "fas fa-handshake",
                                label = "Hand Something Over"
                            }
                        },
                        job = {"all"},
                        distance = 2.5
                    }
                )

                AddBoxZone("MEnter", vector3(247.1107, -1996.614, 20.18834), 1, 4, {
                    name="MEnter",
                    heading=52.43266,
                    debugPoly=false,
                    minZ=18.0,
                    maxZ=22.0
                    }, {
                        options = {
                            {
                                event = "police:enterBuilding",
                                icon = "fas fa-door-open",
                                label = "Enter Building",
                            },
                        },
                        distance = 1.5
                }) 

                AddBoxZone("SkyHighCraft", vector3(-912.6306, -3022.177, 14.04508), 1, 1.32, {
                    name="SkyHighCraft",
                    heading=242.800292,
                    debugPoly=false,
                    minZ=13.0,
                    maxZ=15.7
                    }, {
                        options = {
                            {
                                event = "skyhigh:crafting",
                                icon = "fas fa-plane",
                                label = "Crafting",
                            },
                        },
                        distance = 1.5
                })   
                
        end)

function getVehicleInDirection(coordFrom, coordTo)
	local offset = 0
	local rayHandle
	local vehicle

	for i = 0, 100 do
		rayHandle = CastRayPointToPoint(coordFrom.x, coordFrom.y, coordFrom.z, coordTo.x, coordTo.y, coordTo.z + offset, 10, PlayerPedId(), 0)	
		a, b, c, d, vehicle = GetRaycastResult(rayHandle)
		
		offset = offset - 1

		if vehicle ~= 0 then break end
	end
	
	local distance = Vdist2(coordFrom, GetEntityCoords(vehicle))
	
	if distance > 3000 then vehicle = nil end

    return vehicle ~= nil and vehicle or 0
end

function deleteVeh(ent)
	SetVehicleHasBeenOwnedByPlayer(ent, true)
	NetworkRequestControlOfEntity(ent)
	local finished = exports["prp-taskbar"]:taskBar(7500,"Impounding",false,true)	
	Citizen.InvokeNative(0xEA386986E786A54F, Citizen.PointerValueIntInitialized(ent))
	DeleteEntity(ent)
	DeleteVehicle(ent)
	SetEntityAsNoLongerNeeded(ent)
end

RegisterNetEvent('animation:impound')
AddEventHandler('animation:impound', function()
		inanimation = true
		local lPed = GetPlayerPed(-1)
		RequestAnimDict("amb@code_human_police_investigate@idle_a")
		while not HasAnimDictLoaded("amb@code_human_police_investigate@idle_a") do
			Citizen.Wait(0)
		end
		
		if IsEntityPlayingAnim(lPed, "amb@code_human_police_investigate@idle_a", "idle_b", 3) then
			ClearPedSecondaryTask(lPed)
		else
			TaskPlayAnim(lPed, "amb@code_human_police_investigate@idle_a", "idle_b", 8.0, -8, -1, 49, 0, 0, 0, 0)
			seccount = 4
			while seccount > 0 do
				Citizen.Wait(1000)
				seccount = seccount - 1
			end
			ClearPedSecondaryTask(lPed)
		end		
		inanimation = false
end)

RegisterNetEvent('impoundVehicleee')
AddEventHandler('impoundVehicleee', function()
		coordA = GetEntityCoords(PlayerPedId(), 1)
		coordB = GetOffsetFromEntityInWorldCoords(PlayerPedId(), 0.0, 100.0, 0.0)
		vehicle = getVehicleInDirection(coordA, coordB)
		if DoesEntityExist(vehicle) and NetworkHasControlOfEntity(vehicle) then
			licensePlate = GetVehicleNumberPlateText(vehicle)
			TriggerServerEvent("garages:SetVehIngarage", licensePlate)
			TriggerEvent("animation:impound")
			FreezeEntityPosition(PlayerPedId(),true)
			local finished = exports["prp-taskbar"]:taskBar("3000","Completing Task")
			if finished == 100 then
				ClearPedTasks(PlayerPedId())
				FreezeEntityPosition(PlayerPedId(),false)
				deleteVeh(vehicle)
				TriggerEvent("DoShortHudText","Impounded with retrieval price of $0")
			else
				FreezeEntityPosition(PlayerPedId(),false)
				ClearPedTasks(PlayerPedId())
			end
		end
end)

---- Push vehicle

Config = {} 
Config.DamageNeeded = 100.0 -- 100.0 being broken and 1000.0 being fixed a lower value than 100.0 will break it
Config.MaxWidth = 5.0 -- Will complete soon
Config.MaxHeight = 5.0
Config.MaxLength = 5.0

local Keys = {
  ["ESC"] = 322, ["F1"] = 288, ["F2"] = 289, ["F3"] = 170, ["F5"] = 166, ["F6"] = 167, ["F7"] = 168, ["F8"] = 169, ["F9"] = 56, ["F10"] = 57,
  ["~"] = 243, ["1"] = 157, ["2"] = 158, ["3"] = 160, ["4"] = 164, ["5"] = 165, ["6"] = 159, ["7"] = 161, ["8"] = 162, ["9"] = 163, ["-"] = 84, ["="] = 83, ["BACKSPACE"] = 177,
  ["TAB"] = 37, ["Q"] = 44, ["W"] = 32, ["E"] = 38, ["R"] = 45, ["T"] = 245, ["Y"] = 246, ["U"] = 303, ["P"] = 199, ["["] = 39, ["]"] = 40, ["ENTER"] = 18,
  ["CAPS"] = 137, ["A"] = 34, ["S"] = 8, ["D"] = 9, ["F"] = 23, ["G"] = 47, ["H"] = 74, ["K"] = 311, ["L"] = 182,
  ["LEFTSHIFT"] = 21, ["Z"] = 20, ["X"] = 73, ["C"] = 26, ["V"] = 0, ["B"] = 29, ["N"] = 249, ["M"] = 244, [","] = 82, ["."] = 81,
  ["LEFTCTRL"] = 36, ["LEFTALT"] = 19, ["SPACE"] = 22, ["RIGHTCTRL"] = 70,
  ["HOME"] = 213, ["PAGEUP"] = 10, ["PAGEDOWN"] = 11, ["DELETE"] = 178,
  ["LEFT"] = 174, ["RIGHT"] = 175, ["TOP"] = 27, ["DOWN"] = 173,
  ["NENTER"] = 201, ["N4"] = 108, ["N5"] = 60, ["N6"] = 107, ["N+"] = 96, ["N-"] = 97, ["N7"] = 117, ["N8"] = 61, ["N9"] = 118
}

local First = vector3(0.0, 0.0, 0.0)
local Second = vector3(5.0, 5.0, 5.0)

-- Voodoo function shit

function GetClosestVehiclex(coords, modelFilter) return GetClosestEntityx(GetVehiclesx(), false, coords, modelFilter) end

local function EnumerateEntities(initFunc, moveFunc, disposeFunc)
	return coroutine.wrap(function()
		local iter, id = initFunc()
		if not id or id == 0 then
			disposeFunc(iter)
			return
		end

		local enum = {handle = iter, destructor = disposeFunc}
		setmetatable(enum, entityEnumerator)
		local next = true

		repeat
			coroutine.yield(id)
			next, id = moveFunc(iter)
		until not next

		enum.destructor, enum.handle = nil, nil
		disposeFunc(iter)
	end)
end

function EnumerateVehicles()
	return EnumerateEntities(FindFirstVehicle, FindNextVehicle, EndFindVehicle)
end

function GetVehiclesx()
	local vehicles = {}

	for vehicle in EnumerateVehicles() do
		table.insert(vehicles, vehicle)
	end

	return vehicles
end

function GetClosestEntityx(entities, isPlayerEntities, coords, modelFilter)
	local closestEntity, closestEntityDistance, filteredEntities = -1, -1, nil

	if coords then
		coords = vector3(coords.x, coords.y, coords.z)
	else
		local playerPed = PlayerPedId()
		coords = GetEntityCoords(playerPed)
	end

	if modelFilter then
		filteredEntities = {}

		for k,entity in pairs(entities) do
			if modelFilter[GetEntityModel(entity)] then
				table.insert(filteredEntities, entity)
			end
		end
	end

	for k,entity in pairs(filteredEntities or entities) do
		local distance = #(coords - GetEntityCoords(entity))

		if closestEntityDistance == -1 or distance < closestEntityDistance then
			closestEntity, closestEntityDistance = isPlayerEntities and k or entity, distance
		end
	end

	return closestEntity, closestEntityDistance
end

local Vehicle = {Coords = nil, Vehicle = nil, Dimension = nil, IsInFront = false, Distance = nil}
Citizen.CreateThread(function()
    Citizen.Wait(200)
    while true do
        local ped = PlayerPedId()
        local closestVehicle, Distance = GetClosestVehiclex()
        local vehicleCoords = GetEntityCoords(closestVehicle)
        local dimension = GetModelDimensions(GetEntityModel(closestVehicle), First, Second)
        if Distance < 6.0  and not IsPedInAnyVehicle(ped, false) then
            Vehicle.Coords = vehicleCoords
            Vehicle.Dimensions = dimension
            Vehicle.Vehicle = closestVehicle
            Vehicle.Distance = Distance
            if GetDistanceBetweenCoords(GetEntityCoords(closestVehicle) + GetEntityForwardVector(closestVehicle), GetEntityCoords(ped), true) > GetDistanceBetweenCoords(GetEntityCoords(closestVehicle) + GetEntityForwardVector(closestVehicle) * -1, GetEntityCoords(ped), true) then
                Vehicle.IsInFront = false
            else
                Vehicle.IsInFront = true
            end
        else
            Vehicle = {Coords = nil, Vehicle = nil, Dimensions = nil, IsInFront = false, Distance = nil}
        end
        Citizen.Wait(500)
    end
end)

function DrawText3DTest(x,y,z, text)
	local onScreen,_x,_y=World3dToScreen2d(x,y,z)
	local px,py,pz=table.unpack(GetGameplayCamCoords())
			
	SetTextScale(0.35, 0.35)
	SetTextFont(4)
	SetTextProportional(1)
	SetTextColour(255, 255, 255, 215)
		
	SetTextEntry("STRING")
	SetTextCentre(1)
	AddTextComponentString(text)
	DrawText(_x,_y)
	local factor = (string.len(text)) / 370
	DrawRect(_x,_y+0.0125, 0.015+ factor, 0.03, 41, 11, 41, 68)
end

function StreamingRequestAnimDict(animDict, cb)
	if not HasAnimDictLoaded(animDict) then
		RequestAnimDict(animDict)

		while not HasAnimDictLoaded(animDict) do
			Citizen.Wait(1)
		end
	end

	if cb ~= nil then
		cb()
	end
end

-- End of voodoo magic

Citizen.CreateThread(function()
    while true do 
        Citizen.Wait(5)
        local ped = PlayerPedId()
        if Vehicle.Vehicle ~= nil then
 
                if IsVehicleSeatFree(Vehicle.Vehicle, -1) and GetVehicleEngineHealth(Vehicle.Vehicle) <= Config.DamageNeeded then
                    TriggerEvent('DoLongHudText', 'Press Shift and E to Push Vehicle')
                end
     

            if IsControlPressed(0, Keys["LEFTSHIFT"]) and IsVehicleSeatFree(Vehicle.Vehicle, -1) and not IsEntityAttachedToEntity(ped, Vehicle.Vehicle) and IsControlJustPressed(0, Keys["E"])  and GetVehicleEngineHealth(Vehicle.Vehicle) <= Config.DamageNeeded then
                NetworkRequestControlOfEntity(Vehicle.Vehicle)
                local coords = GetEntityCoords(ped)
                if Vehicle.IsInFront then    
                    AttachEntityToEntity(PlayerPedId(), Vehicle.Vehicle, GetPedBoneIndex(6286), 0.0, Vehicle.Dimensions.y * -1 + 0.1 , Vehicle.Dimensions.z + 1.0, 0.0, 0.0, 180.0, 0.0, false, false, true, false, true)
                else
                    AttachEntityToEntity(PlayerPedId(), Vehicle.Vehicle, GetPedBoneIndex(6286), 0.0, Vehicle.Dimensions.y - 0.3, Vehicle.Dimensions.z  + 1.0, 0.0, 0.0, 0.0, 0.0, false, false, true, false, true)
                end

                StreamingRequestAnimDict('missfinale_c2ig_11')
                TaskPlayAnim(ped, 'missfinale_c2ig_11', 'pushcar_offcliff_m', 2.0, -8.0, -1, 35, 0, 0, 0, 0)
                Citizen.Wait(200)

                local currentVehicle = Vehicle.Vehicle
                 while true do
                    Citizen.Wait(5)
                    if IsDisabledControlPressed(0, Keys["A"]) then
                        TaskVehicleTempAction(PlayerPedId(), currentVehicle, 11, 1000)
                    end

                    if IsDisabledControlPressed(0, Keys["D"]) then
                        TaskVehicleTempAction(PlayerPedId(), currentVehicle, 10, 1000)
                    end

                    if Vehicle.IsInFront then
                        SetVehicleForwardSpeed(currentVehicle, -1.0)
                    else
                        SetVehicleForwardSpeed(currentVehicle, 1.0)
                    end

                    if HasEntityCollidedWithAnything(currentVehicle) then
                        SetVehicleOnGroundProperly(currentVehicle)
                    end

                    if not IsDisabledControlPressed(0, Keys["E"]) then
                        DetachEntity(ped, false, false)
                        StopAnimTask(ped, 'missfinale_c2ig_11', 'pushcar_offcliff_m', 2.0)
                        FreezeEntityPosition(ped, false)
                        break
                    end
                end
            end
        end
    end
end)
