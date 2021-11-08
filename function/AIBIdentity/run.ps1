param($eventGridEvent, $TriggerMetadata)

# Make sure to pass hashtables to Out-String so they're logged correctly
$eventGridEvent | Out-String | Write-Host

Write-Host $eventGridEvent.Subject

$vmResource = Get-AzResource -Id $eventGridEvent.Subject

Write-Host $vmResource.ResourceGroupName

$vm = Get-AzVM -Name $vmResource.Name -ResourceGroupName $vmResource.ResourceGroupName

Write-Host $vm.Id

Update-AzVM -VM $vm -IdentityType SystemAssigned -ResourceGroupName $vmResource.ResourceGroupName

$vm = Get-AzVM -Name $vmResource.Name -ResourceGroupName $vmResource.ResourceGroupName
$id = $vm.Identity.PrincipalId

Write-Host $id

#$groupId = (Get-AzADGroup -DisplayName $vmResource.ResourceGroupName).ID
#Add-AzADGroupMember -MemberObjectId $id -TargetGroupObjectId $groupId
