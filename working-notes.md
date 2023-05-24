Added verification stubs into the unit, group, combat_group and roster models.
when changes are made the highest changed entity can be told to validate and cascade that down the chain

need to hook up the calls to validate 
* faction option changes
* sub faction option changes
* combat group option changes
* unit mod changes (removals)

Going with a full reset when any faction options change, this only applies to a few subfactions.
Changing cg options clears that cg

Want to eventually do more fine grained validation

next
* when removing a mod from a unit, check to make sure the rest of the mods on the unit are still valid
* update units, groups, combatgroups to know which parent it belongs.  This should simplify a lot of logic and allow better/easier requirement/validation checks.

is the refresh_data on unit mods even used?

I think the refresh was added to update mod options.  is there a  better way

when removing a mod, seems all mods are failing requirement check.
added duelist, dual gun and aa, removing either dual gun or aa removes all mods including duelist

change requirement checks to not return false if the mod is already on the unit

mods have been updated to work with new pattern
should be able to update cgs to properly update on option changes without having to reset everything

units from special filters are not being blocked from being added to a cg when they shouldn't be allowed.

