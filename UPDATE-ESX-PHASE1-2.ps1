          ####################################################################################################################
          #  Jones Uzan                                                                                                       #
          #            Jan 2018    vmware ESX with SIO ROLLING UPDATEs for ESXI OS  DEMO/LAB use                              #
          #####################################################################################################################




#——----------------------------------------update ESX host software---------------------------------------- ——


#The script will run on two ESX hosts at a time! 
#First task/command ==> Stop/shutdown a vm [SIO02]    on ESX 152    , {hard coded the vm's and esx1 esx2 names}
#Vmotion all the vm's from ESX152 to ESX153 
#Put ESX1 in maintenance mode 
#Run/call SSH command from a Linux server [hard coded comand like "ifconfig" ]
#sleep 
#Bring ESX152 back from maintenance mode [exit maintenance mode ]
#Start the  vm [SIO02 ] back online 
#Sleep 
#Vmotion back the vms from ESX2 
#Sleep 
#Start all over again this time with ESX2 with SIO02 in powered down state
#################################################################################################################################
#













#################################################################################################################################
#Welcom screen for PHASE 1 

[Console]::ForegroundColor = "Green"
write-host ""
write-host "               **********************Starting PHASE1!!!!!!********************"
write-host "                           *************************************"
write-host " "
write-host "                 *********************TASKS:**************************"
write-host "                 * 1. power off SIO02                                *"
write-host "                 * 2. Wait for rebuild to finish                     *"
write-host "                 * 3. Vmotion all running vm's from 152 to 153       *"
write-host "                 * 4. Put esx152 in maintenance mode                 *"
write-host "                 * 5. Update ESXI OS                                 *"
write-host "                 * 6. Exit 152 from maintenance mode                 *"
write-host "                 * 7. Power back on SIO02                            *"
write-host "                 * 8. Wait for Rebalance to finish                   *"
write-host "                 * 9. go to phase 2                                  *"
write-host "                  ****************************************************"                  
[Console]::ResetColor()
sleep 3




#################################################################################################################################
#Log in to VCENTER
 
connect-viserver -server 172.31.240.41 -User administrator@vsphere.local -Password Dell:123

write-host " " 
write-host " "
write-host " "
write-host " "
write-host " "
write-host "*****************************************LOGIN TO VCENTER**********************************"
write-host "                **************************************************************"
write-host " "
write-host " "



#################################################################################################################################
#Poweeroff SIO

Get-VM SIO02 | Stop-VM -Confirm:$false


write-host " "
write-host " "
write-host " "
write-host " "
write-host "             *********************SIO02 POWER OFF******************"
write-host "                        **********************************"
write-host " "
write-host " "
write-host " "
write-host " "

write-host "           *********************REBUILD is done ******************"
write-host "                   **********************************************************"
sleep 25

write-host " "
write-host " "
write-host " "
write-host " "
##################################################################################################################################
#Vmotion all powered on VMs from ESX1(172.31.70.152) to ESX2 (172.31.70.153)

$vmList = Get-VMHost 172.31.70.152 | Get-VM | where { $_.PowerState -eq “PoweredOn”}
$Task = Get-VM $vmList | move-vm -destination (get-vmhost 172.31.70.153)

write-host " "
write-host " "
write-host " "
write-host " "

write-host "            *********************ALL LIVE VM'S ON 152 HAS MOVED TO 153******************"
write-host "                   **********************************************************"
sleep 30
write-host " "
write-host " "
write-host " "
####################################################################################################################################
#put ESXi 172.31.70.152 in Maitenance

Get-VMHost -Name 172.31.70.152 | set-vmhost -State Maintenance
[Console]::ForegroundColor = "Yellow"
write-host ""
write-host "                *****************ESXi 172.31.70.152 is in Maintenance mode!!!!**********"
write-host "                            ****************************************************"
[Console]::ResetColor()


write-host " "
write-host " "
write-host " "
write-host " "
Sleep 15



###############################################################################################################################3
#Run Linux command Jones to run the ansibke ESX Upgrade script 

[Console]::ForegroundColor = "Green"
write-host ""
write-host "                              *****************ESXI PATCH UPDATE!!!**********"
write-host "                                  *************************************"
write-host " "
write-host " "
write-host " "
write-host " "
[Console]::ResetColor()
#Call ansible script 

#New-SSHSession -ComputerName "ansible" -Credential (Get-Credential)Invoke-SSHCommand -Index 0 -Command "scp /root/ESXi600-201801001.zip 172.31.70.152:/vmfs/volumes/datastore1/patch-directory/"
#New-SSHSession -ComputerName "esx152" -Credential (Get-Credential)Invoke-SSHCommand -Index 0 -Command "esxcli software vib install -d /vmfs/volumes/datastore1/patch-directory/ESXi650-201801001.zip"
#New-SSHSession -ComputerName "esx152" -Credential (Get-Credential)Invoke-SSHCommand -Index 0 -Command "vmware -v"
sleep 3

#New-SSHSession -ComputerName "esx152" -Credential (Get-Credential)Invoke-SSHCommand -Index 0 -Command "reboot"


sleep 660



########################################################################################################3
#Bring ESXi 172.31.70.152 to Connected state

Get-VMHost -Name 172.31.70.152 | set-vmhost -State Connected
[Console]::ForegroundColor = "Yellow"
write-host ""
write-host "               **********************ESXi 172.31.70.152 Exited maintenance mode!!!!!!********************"
write-host "                                   *************************************************"
[Console]::ResetColor()

Sleep 15
write-host " "
write-host " "
write-host " "
write-host " "







###########################################################################################################33
#Start SIO02

Get-VM SIO02 | Start-VM -Confirm:$false


write-host "             *********************Check REBALANCE ******************"
write-host "                    **************************************"
Sleep 60
 

write-host "             *********************REBALANCE done******************"
write-host "             * 1. SIO02 IS UP                                    *"
write-host "             * 2. All vm's are now running on ESX153             *"
write-host "             *****************************************************"
Sleep 20
write-host " "
write-host " "
write-host " "
write-host " "
write-host " "
write-host " "








#    ___________________________________________________________________________________________________________________________________________
#    _______________________________________________________________PHASE2______________________________________________________________________

#################################################################################################################################
#Welcom screen for PHASE 1
[Console]::ForegroundColor = "Blue"
write-host ""
write-host "               **********************Starting PHASE2!!!!!!********************"
write-host "                           *************************************"
write-host " "
write-host "                 *********************TASKS:**************************"
write-host "                 * 1. power off SIO03                                *"
write-host "                 * 2. Wiat for rebuild to finish                     *"
write-host "                 * 3. Vmotion all running vm's to esx 152            *"
write-host "                 * 4. Put 153 in maintetance mode                    *"
write-host "                 * 5. Update ESXI OS                                 *"
write-host "                 * 6. EXIT 153 MINTETANCE MODE                       *"
write-host "                 * 7. Poweron SIO03                                  *"
write-host "                 * 8. Wait for rebalance to finish                   *"
write-host "                 * 9. Vmotion back 153 vm's <Hard coded list         *"
write-host "                  ****************************************************"                  
[Console]::ResetColor()
sleep 2

###############################################################################################################
#Log in to VCENTER 
connect-viserver -server 172.31.240.41 -User administrator@vsphere.local -Password Dell:123





############################################################################################################################33
#Stop SIO03 on ESX2
Get-VM SIO03 | Stop-VM -Confirm:$false


write-host "             *********************SIO03 IS POWERED OFF******************"
write-host "                            ****************************"
sleep 60
write-host ""
write-host ""
write-host ""
write-host "            ********************* REBUILD is done ******************"
write-host "                 ******************************************"
sleep 60





###################################################################################################
#Vmotion all powered on VMs from ESX1(172.31.70.153) to ESX2 (172.31.70.152)  ONLY POWER ON VM'S
$vmList = Get-VMHost 172.31.70.153 | Get-VM | where { $_.PowerState -eq “PoweredOn”}
$Task = Get-VM $vmList | move-vm -destination (get-vmhost 172.31.70.152)


write-host "               *********************VMOTION IS RUNNING ******************"
write-host "                             ****************************"
write-host ""
write-host ""
Sleep 25
write-host ""
write-host ""
write-host ""
write-host ""
write-host ""
write-host ""




################################################################################3
#put ESXi 172.31.70.153 =ESX2 in Maitenance

Get-VMHost -Name 172.31.70.153 | set-vmhost -State Maintenance
[Console]::ForegroundColor = "Yellow"
write-host ""
write-host "ESXi 172.31.70.153 is in Maintenance mode now!!!!!!"
[Console]::ResetColor()
write-host ""
write-host ""
write-host "               *********************MAINTENANCE mode on 153 ******************"
write-host "                          **************************************"
write-host ""
write-host ""
Sleep 40
write-host ""
write-host ""

###################################################################################3
#Run Linux command Jones to run the ansibke ESX Upgrade script 

[Console]::ForegroundColor = "Green"
write-host ""
write-host "                              *****************ESXI PATCH UPDATE!!!**********"
write-host "                                  *************************************"
write-host " "
write-host " "
write-host " "
write-host " "
[Console]::ResetColor()
#Call ansible script 

#New-SSHSession -ComputerName "ansible" -Credential (Get-Credential)Invoke-SSHCommand -Index 0 -Command "scp /root/ESXi600-201801001.zip 172.31.70.153:/vmfs/volumes/datastore1/patch-directory/"
#write-host "New-SSHSession -ComputerName "esx153" -Credential (Get-Credential)Invoke-SSHCommand -Index 0 -Command "esxcli software vib install -d /vmfs/volumes/datastore1/patch-directory/ESXi650-201801001.zip""
#New-SSHSession -ComputerName "esx153" -Credential (Get-Credential)Invoke-SSHCommand -Index 0 -Command "vmware -v"



function Start-Sleep($seconds) {
$doneDT = (Get-Date).AddSeconds($seconds)
while($doneDT -gt (Get-Date)) {
$secondsLeft = $doneDT.Subtract((Get-Date)).TotalSeconds
$percent = ($seconds - $secondsLeft) / $seconds * 100
Write-Progress -Activity "Sleeping" -Status "Sleeping..." -SecondsRemaining $secondsLeft -PercentComplete $percent
[System.Threading.Thread]::Sleep(20)
}
Write-Progress -Activity "Sleeping" -Status "Sleeping..." -SecondsRemaining 0 -Completed
}

########################################################################################################################333
#Bring ESXi 172.31.70.153 to Connected state back from maintenance mode 

Get-VMHost -Name 172.31.70.153 | set-vmhost -State Connected
[Console]::ForegroundColor = "Yellow"
write-host ""
write-host "ESXi 172.31.70.153 is in Connected State now!!!!!!"


write-host ""
write-host ""
write-host "            *********************ESX 153 IS BACK FROM MAINTENANCE ******************"
write-host "                              **************************************"
Sleep 30
write-host ""
write-host ""


####################################################################################################################
#Start SIO03
Get-VM SIO03 | Start-VM -Confirm:$false
sleep 60 

write-host "             *********************SIO03 IS BACK ONLINE******************"
write-host "                        **************************************"
write-host " "
write-host " " 
write-host "             *********************REBALANCE is done******************"
write-host "                          *******************************"
write-host ""
write-host ""
write-host ""
write-host ""



#######################################################################################################################
#Vmotion VM's back to esxi 2 where they belonged earlier.


Get-VM VM200 | move-vm -destination (get-vmhost 172.31.70.153)

function Start-Sleep($seconds) {
$doneDT = (Get-Date).AddSeconds($seconds)
while($doneDT -gt (Get-Date)) {
$secondsLeft = $doneDT.Subtract((Get-Date)).TotalSeconds
$percent = ($seconds - $secondsLeft) / $seconds * 100
Write-Progress -Activity "Sleeping" -Status "Sleeping..." -SecondsRemaining $secondsLeft -PercentComplete $percent
[System.Threading.Thread]::Sleep(20)
}
Write-Progress -Activity "Sleeping" -Status "Sleeping..." -SecondsRemaining 0 -Completed
}

Get-VM VM201 | move-vm -destination (get-vmhost 172.31.70.153)
Sleep 10
[Console]::ResetColor()
[Console]::ForegroundColor = "Green"
write-host ""

write-host "!!!!!!!!!!End of all the tasks !!!!!!!!!!!!"
sleep 1


disconnect-viserver 172.31.240.41 -Confirm:$false


