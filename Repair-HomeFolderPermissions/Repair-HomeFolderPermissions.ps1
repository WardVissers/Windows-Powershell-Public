#########################################################################
# Script: Repair-HomeFolderPermissions.ps1
# Author: Ward Vissers    http://www.wardvissers.nl
# Date: 20/11/2014
# Keywords:
# Comments:
# Pre-Requisites: Full Control over destination folder.
#
# +------------+-----+---------------------------------------------------------+
# |       Date | Usr | Description                                             |
# +------------+-----+---------------------------------------------------------+
# | 20/11/2014 | WV  | Initial Script                                          |
# |            |     |                                                         |
# +------------+-----+---------------------------------------------------------+
#
#   1. http://support.microsoft.com/kb/274443
#
#   2. Set Share Permissions for the Everyone group to Full Control.
#   
#   3.  Use the following settings for NTFS Permissions:
# 
#   CREATOR OWNER - Full Control (Apply onto: Subfolders and Files Only) 
#   System - Full Control (Apply onto: This Folder, Subfolders and Files) 
#   Domain Admins - Full Control (Apply onto: This Folder, Subfolders and Files) 
#   Everyone - Create Folder/Append Data (Apply onto: This Folder Only) 
#   Everyone - List Folder/Read Data (Apply onto: This Folder Only) 
#   Everyone - Read Attributes (Apply onto: This Folder Only) 
#   Everyone - Traverse Folder/Execute File (Apply onto: This Folder Only)
#
#
# DISCLAIMER
# ==========
# THIS CODE IS MADE AVAILABLE AS IS, WITHOUT WARRANTY OF ANY KIND. THE ENTIRE
# RISK OF THE USE OR THE RESULTS FROM THE USE OF THIS CODE REMAINS WITH THE USER.
#############################################################################

$dirpath = "D:\Data\user"

# get list of all child directories, in the current directory
$directories = dir $dirpath | where {$_.PsIsContainer}

# iterate over the directories
foreach ($dir in $directories)
{
# echo out what the full directory is that we’re working on now
write-host Working on $dir.fullname using $dir.name

# setup the inheritance and propagation as we want it
$inheritance = [system.security.accesscontrol.InheritanceFlags]“ContainerInherit, ObjectInherit”
$propagation = [system.security.accesscontrol.PropagationFlags]“None”
$allowdeny=[System.Security.AccessControl.AccessControlType]::Allow

# get the existing ACLs for the directory
$acl = get-acl $dir.fullname

# add our user (with the same name as the directory) to have modify perms
$aclrule = new-object System.Security.AccessControl.FileSystemAccessRule($dir.name, “FullControl”, $inheritance, $propagation, “$allowdeny”)

# check if given user is Valid, this will barf if not
$sid = $aclrule.IdentityReference.Translate([System.Security.Principal.securityidentifier])

# add the ACL to the ACL rules
$acl.AddAccessRule($aclrule)

# set the acls
set-acl -aclobject $acl -path $dir.fullname
}