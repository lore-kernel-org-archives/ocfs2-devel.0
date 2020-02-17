From: Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
Date: Mon, 17 Feb 2020 17:12:15 +0100
Subject: [Ocfs2-devel] [PATCH 29/44] docs: filesystems: convert ocfs2.txt to
	ReST
In-Reply-To: <cover.1581955849.git.mchehab+huawei@kernel.org>
References: <cover.1581955849.git.mchehab+huawei@kernel.org>
Message-ID: <e29a8120bf1d847f23fb68e915f10a7d43bed9e3.1581955849.git.mchehab+huawei@kernel.org>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

- Add a SPDX header;
- Adjust document title;
- Some whitespace fixes and new line breaks;
- Mark literal blocks as such;
- Add it to filesystems/index.rst.

Signed-off-by: Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
---
 Documentation/filesystems/index.rst           |  1 +
 .../filesystems/{ocfs2.txt => ocfs2.rst}      | 31 +++++++++++++------
 2 files changed, 22 insertions(+), 10 deletions(-)
 rename Documentation/filesystems/{ocfs2.txt => ocfs2.rst} (88%)

diff --git a/Documentation/filesystems/index.rst b/Documentation/filesystems/index.rst
index f3a26fdbd04f..3b2b07491c98 100644
--- a/Documentation/filesystems/index.rst
+++ b/Documentation/filesystems/index.rst
@@ -76,6 +76,7 @@ Documentation for filesystem implementations.
    nilfs2
    nfs/index
    ntfs
+   ocfs2
    ocfs2-online-filecheck
    overlayfs
    virtiofs
diff --git a/Documentation/filesystems/ocfs2.txt b/Documentation/filesystems/ocfs2.rst
similarity index 88%
rename from Documentation/filesystems/ocfs2.txt
rename to Documentation/filesystems/ocfs2.rst
index 4c49e5410595..412386bc6506 100644
--- a/Documentation/filesystems/ocfs2.txt
+++ b/Documentation/filesystems/ocfs2.rst
@@ -1,5 +1,9 @@
+.. SPDX-License-Identifier: GPL-2.0
+
+================
 OCFS2 filesystem
-==================
+================
+
 OCFS2 is a general purpose extent based shared disk cluster file
 system with many similarities to ext3. It supports 64 bit inode
 numbers, and has automatically extending metadata groups which may
@@ -14,22 +18,26 @@ OCFS2 mailing lists: http://oss.oracle.com/projects/ocfs2/mailman/
 
 All code copyright 2005 Oracle except when otherwise noted.
 
-CREDITS:
+Credits
+=======
+
 Lots of code taken from ext3 and other projects.
 
 Authors in alphabetical order:
-Joel Becker   <joel.becker@oracle.com>
-Zach Brown    <zach.brown@oracle.com>
-Mark Fasheh   <mfasheh@suse.com>
-Kurt Hackel   <kurt.hackel@oracle.com>
-Tao Ma        <tao.ma@oracle.com>
-Sunil Mushran <sunil.mushran@oracle.com>
-Manish Singh  <manish.singh@oracle.com>
-Tiger Yang    <tiger.yang@oracle.com>
+
+- Joel Becker   <joel.becker@oracle.com>
+- Zach Brown    <zach.brown@oracle.com>
+- Mark Fasheh   <mfasheh@suse.com>
+- Kurt Hackel   <kurt.hackel@oracle.com>
+- Tao Ma        <tao.ma@oracle.com>
+- Sunil Mushran <sunil.mushran@oracle.com>
+- Manish Singh  <manish.singh@oracle.com>
+- Tiger Yang    <tiger.yang@oracle.com>
 
 Caveats
 =======
 Features which OCFS2 does not support yet:
+
 	- Directory change notification (F_NOTIFY)
 	- Distributed Caching (F_SETLEASE/F_GETLEASE/break_lease)
 
@@ -37,8 +45,10 @@ Mount options
 =============
 
 OCFS2 supports the following mount options:
+
 (*) == default
 
+======================= ========================================================
 barrier=1		This enables/disables barriers. barrier=0 disables it,
 			barrier=1 enables it.
 errors=remount-ro(*)	Remount the filesystem read-only on an error.
@@ -104,3 +114,4 @@ journal_async_commit	Commit block can be written to disk without waiting
 			for descriptor blocks. If enabled older kernels cannot
 			mount the device. This will enable 'journal_checksum'
 			internally.
+======================= ========================================================
-- 
2.24.1
