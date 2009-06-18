From: Sunil Mushran <sunil.mushran@oracle.com>
Date: Wed, 17 Jun 2009 18:52:19 -0700
Subject: [Ocfs2-devel] [PATCH 1/8] ocfs2: update comments in masklog.h
In-Reply-To: <1245289946-17136-1-git-send-email-sunil.mushran@oracle.com>
References: <1245289946-17136-1-git-send-email-sunil.mushran@oracle.com>
Message-ID: <1245289946-17136-2-git-send-email-sunil.mushran@oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

From: Coly Li <coly.li@suse.de>

Mainline commit 2b53bc7bff17341d8b5ac12115f5c2363638e628

In the mainline ocfs2 code, the interface for masklog is in files under
/sys/fs/o2cb/masklog, but the comments in fs/ocfs2/cluster/masklog.h
reference the old /proc interface.  They are out of date.

This patch modifies the comments in cluster/masklog.h, which also provides
a bash script example on how to change the log mask bits.

Signed-off-by: Coly Li <coly.li@suse.de>
Signed-off-by: Joel Becker <joel.becker@oracle.com>
---
 fs/ocfs2/cluster/masklog.h |   35 +++++++++++++++++------------------
 1 files changed, 17 insertions(+), 18 deletions(-)

diff --git a/fs/ocfs2/cluster/masklog.h b/fs/ocfs2/cluster/masklog.h
index 4c32d1c..041f40c 100644
--- a/fs/ocfs2/cluster/masklog.h
+++ b/fs/ocfs2/cluster/masklog.h
@@ -48,34 +48,33 @@
  * only emit the appropriage printk() when the caller passes in a constant
  * mask, as is almost always the case.
  *
- * All this bitmask nonsense is hidden from the /proc interface so that Joel
- * doesn't have an aneurism.  Reading the file gives a straight forward
- * indication of which bits are on or off:
- * 	ENTRY off
- * 	EXIT off
+ * All this bitmask nonsense is managed from the files under
+ * /sys/fs/o2cb/logmask/.  Reading the files gives a straightforward
+ * indication of which bits are allowed (allow) or denied (off/deny).
+ * 	ENTRY deny
+ * 	EXIT deny
  * 	TCP off
  * 	MSG off
  * 	SOCKET off
- * 	ERROR off
- * 	NOTICE on
+ * 	ERROR allow
+ * 	NOTICE allow
  *
  * Writing changes the state of a given bit and requires a strictly formatted
  * single write() call:
  *
- * 	write(fd, "ENTRY on", 8);
+ * 	write(fd, "allow", 5);
  *
- * would turn the entry bit on.  "1" is also accepted in the place of "on", and
- * "off" and "0" behave as expected.
+ * Echoing allow/deny/off string into the logmask files can flip the bits
+ * on or off as expected; here is the bash script for example:
  *
- * Some trivial shell can flip all the bits on or off:
+ * log_mask="/sys/fs/o2cb/log_mask"
+ * for node in ENTRY EXIT TCP MSG SOCKET ERROR NOTICE; do
+ *	echo allow >"$log_mask"/"$node"
+ * done
  *
- * log_mask="/proc/fs/ocfs2_nodemanager/log_mask"
- * cat $log_mask | (
- * 	while read bit status; do
- * 		# $1 is "on" or "off", say
- * 		echo "$bit $1" > $log_mask
- * 	done
- * )
+ * The debugfs.ocfs2 tool can also flip the bits with the -l option:
+ *
+ * debugfs.ocfs2 -l TCP allow
  */
 
 /* for task_struct */
-- 
1.6.0.4
