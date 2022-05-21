# Notes on transforming data from excel to the json format used by gearforce

1. change column headings to match expected

1. remove new line symbols `\n`

1. weapons with multiple traits need to have the comma removed from between the traits 
	- Example: (Apex, Precise) -> (Apex Precise)
