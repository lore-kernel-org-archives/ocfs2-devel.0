From: Sunil Mushran <sunil.mushran@oracle.com>
Date: Mon,  2 Nov 2009 13:38:10 -0800
Subject: [Ocfs2-devel] [PATCH 1/1] ocfs2: Refresh documentation
Message-ID: <1257197890-16493-1-git-send-email-sunil.mushran@oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

Signed-off-by: Sunil Mushran <sunil.mushran@oracle.com>
---
 Documentation/filesystems/ocfs2.txt |    6 +++---
 1 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/Documentation/filesystems/ocfs2.txt b/Documentation/filesystems/ocfs2.txt
index c2a0871..c58b9f5 100644
--- a/Documentation/filesystems/ocfs2.txt
+++ b/Documentation/filesystems/ocfs2.txt
@@ -20,15 +20,16 @@ Lots of code taken from ext3 and other projects.
 Authors in alphabetical order:
 Joel Becker   <joel.becker@oracle.com>
 Zach Brown    <zach.brown@oracle.com>
-Mark Fasheh   <mark.fasheh@oracle.com>
+Mark Fasheh   <mfasheh@suse.com>
 Kurt Hackel   <kurt.hackel@oracle.com>
+Tao Ma        <tao.ma@oracle.com>
 Sunil Mushran <sunil.mushran@oracle.com>
 Manish Singh  <manish.singh@oracle.com>
+Tiger Yang    <tiger.yang@oracle.com>
 
 Caveats
 =======
 Features which OCFS2 does not support yet:
-	- quotas
 	- Directory change notification (F_NOTIFY)
 	- Distributed Caching (F_SETLEASE/F_GETLEASE/break_lease)
 
@@ -70,7 +71,6 @@ commit=nrsec	(*)	Ocfs2 can be told to sync all its data and metadata
 			performance.
 localalloc=8(*)		Allows custom localalloc size in MB. If the value is too
 			large, the fs will silently revert it to the default.
-			Localalloc is not enabled for local mounts.
 localflocks		This disables cluster aware flock.
 inode64			Indicates that Ocfs2 is allowed to create inodes at
 			any location in the filesystem, including those which
-- 
1.5.6.5
