Start with the file safety_scriptV0.1.do 

This uses the raw_data.csv as input and provides a worked example.

You coudl replace it with your own data, with the same variable names
and edit some of the lines 5-11 to give the numbers exposed, and 
experimental change line 7 to

global soc_index soc_term

if you have recorded teh SOC using text rather than MedDRA code (untested)

With the inputs and subsidiary files provided it has generated a valid xml
file that has been accepted by the EudraCT training environment.

