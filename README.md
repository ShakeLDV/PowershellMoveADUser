# PowershellMoveADUser

Just a Powershell script that automatically moves users from an OU location to another.

College had to move students from one OU to another every semester. This Powershell script was to make this automated. Currently the conditions are all manual but the movement of bulk OU users are easier. I was suppose to be provided an API so I can cross-check each new student/faculty/staff so the script can automatically label them depending on their department. 

I wish I was able to finish this automation but I left before I saw it to fruition. If anyone in CEI ever sees this you can totally reference how I was doing it. I was going to implement Web Scrapping with Python (You can also do it in Powershell) to check the Solarwinds ticketing system and cross check the new staff/faculty list and you can use that to differentiate those accounts from student accounts.

I had it running with admin privs in the background before. I set it to run every 3 hours. Do note though, that was not very secure. Someone can hijack the PS Script like that and escalate privileges. 
