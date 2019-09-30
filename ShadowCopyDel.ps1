#——————————————————————————————–#
# Script_Name : ShadowCopyDel.ps1
# Description : Deletes older versions of shadow copies to free up space
# Version : 1.0
# Changes:
# Date : September 2019
# Created by Arjun N
# Disclaimer:
# THE SCRIPT IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED,
# INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE
# AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, 
# DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, 
# OUT OF OR IN CONNECTION WITH THE SCRIPT OR THE USE OR OTHER DEALINGS IN THE SCRIPT.
#——————————————————————————————-#

#Change this value as required (in GBs)
$MinFreeSpace_GB = 40

$loopthrough = {
$DriveMinFree = [string]::IsNullOrEmpty((Get-CimInstance -ClassName CIM_LogicalDisk |
    Where-Object {
    # Substitute 'F:' with the respective logical drive
        $_.DeviceID -eq 'F:' -and
        $_.FreeSpace -lt $MinFreeSpace_GB * 1GB
        }))

if ($DriveMinFree)
    {
    'The C: drive has at least {0} GB free.' -f $MinFreeSpace_GB
    Write-Host "Hard Disk Space is greater than $MinFreeSpace_GB GB"
    exit
    }
    else
    {
    Write-Host "Hard Disk Space is less than $MinFreeSpace_GB"
    &$shadel
    &$loopthrough
    Write-Warning ('Low free space on Drive C:!')
    }

}

$shadel = {
$shadscript = "./del.shad"
"delete shadows oldest f:" | set-content $shadscript

diskshadow /s $shadscript
remove-item $shadscript
}

&$loopthrough
