
<#
.Synopsis
	Tests 'assert' and $ErrorActionPreference.

.Example
	Invoke-Build . Assert.build.ps1

.Link
	Invoke-Build
	.build.ps1
#>

# $ErrorActionPreference is Stop by default
assert ($ErrorActionPreference -eq 'Stop')

# But scripts can change it.
$ErrorActionPreference = 0

# This task fails with a default message.
task AssertDefault {
	# Check $ErrorActionPreference
	assert ($ErrorActionPreference -eq 0)

	# Hack needed only for testing, change
	$script:ErrorActionPreference = 'Stop'

	# The simplest assert
	assert
}

# This task fails with a custom message.
task AssertMessage {
	# Check $ErrorActionPreference and change it.
	assert ($ErrorActionPreference -eq 'Stop')
	$ErrorActionPreference = 0

	# Assert with a message.
	assert $false 'Custom assert message.'
}

# The default task calls the others and tests the result errors.
# Note use of @{Task=1} references to failing tasks.
task . @{AssertDefault=1}, @{AssertMessage=1}, {
	# Check $ErrorActionPreference and change it.
	assert ($ErrorActionPreference -eq 'Stop')
	$ErrorActionPreference = 0

	# silly test
	assert $true

	$e = error AssertDefault
	assert ("$e" -eq 'Assertion failed.')

	$e = error AssertMessage
	assert ("$e" -eq 'Assertion failed: Custom assert message.')

	'assert is tested.'
}
