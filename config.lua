Config = {}
Config.Locale = 'de'

-- Useable Command settings
Config.UseCommand = true -- if true can used Command and Hotkey
Config.Command = 'openjoblist' -- commandname
Config.DefaultHotkey = 'F9' -- hotkey

-- Useable Item settings
Config.UseItem = true -- if true you can use item to open Joblist
Config.ItemName = 'job_tablet' -- itemname NO ITEMLABEL

-- prop settings
Config.PropName = 'prop_cs_tablet' -- propname

-- database settings
Config.PhoneScript = 'defaultESXPhone' -- use here defaultESXPhone or qs-phone
Config.MobileNumberDB = 'users' -- DB tablename
Config.MobileNumberEntry = 'phone_number' -- phone_number table

-- job settings
Config.Jobs = {
    'police',
    'mechanic',
    'ambulance'   
}

Config.Language = {
    ['de'] = {
        ['copy_number_msg'] = 'Es wurde die Handynummer: %s von %s kopiert.',
        ['no_job'] = 'Du hast kein passenden Job um dies zu tun!',
    },
    ['en'] = {},
    ['fr'] = {},
    ['es'] = {},
    ['pl'] = {}
}
