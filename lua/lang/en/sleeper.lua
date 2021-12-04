L = LANG.GetLanguageTableReference("en")

-- GENERAL ROLE LANGUAGE STRINGS
L[SLEEPER.name] = "Sleeper"
L["info_popup_" .. SLEEPER.name] = [[You are a Sleeper! You have been awoken to carry out your duty as part of the Traitor team!]]
L["body_found_" .. SLEEPER.abbr] = "They were a Sleeper!"
L["search_role_" .. SLEEPER.abbr] = "This person was a Sleeper!"
L["target_" .. SLEEPER.name] = "Sleeper"
L["ttt2_desc_" .. SLEEPER.name] = [[The Sleeper is an Innocent that converts to a Traitor if all other Traitors die and the round does not end.]]