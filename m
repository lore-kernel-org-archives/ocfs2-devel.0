From: Coly Li <coly.li@suse.de>
Date: Tue, 05 May 2009 20:03:28 +0800
Subject: [Ocfs2-devel] [RFC][PATCH] masklog: update comments in masklog.h
Message-ID: <4A002B10.1070004@suse.de>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

In upstream ocfs2 code, /proc interface for mask log is updated into files under
/sys/fs/o2cb/masklog, comments in fs/ocfs2/cluster/masklog.h are out of date.

This patch modifies the commens in cluster/masklog.h, which also provides a bash
script example on how to change the log mask bits.

Signed-off-by: Coly Li <coly.li@suse.de>
---
 fs/ocfs2/cluster/masklog.h |   33 ++++++++++++++-------------------
 1 files changed, 14 insertions(+), 19 deletions(-)

diff --git a/fs/ocfs2/cluster/masklog.h b/fs/ocfs2/cluster/masklog.h
index 7e72a81..54a78be 100644
--- a/fs/ocfs2/cluster/masklog.h
+++ b/fs/ocfs2/cluster/masklog.h
@@ -48,34 +48,29 @@
  * only emit the appropriage printk() when the caller passes in a constant
  * mask, as is almost always the case.
  *
- * All this bitmask nonsense is hidden from the /proc interface so that Joel
- * doesn't have an aneurism.  Reading the file gives a straight forward
- * indication of which bits are on or off:
- * 	ENTRY off
- * 	EXIT off
+ * All this bitmask nonsense is hidden from the filesunder /sys/fs/o2cb/logmask/.
+ * Reading the files gives a straight forward indication of which bits are
+ * allowed (allow) or denied (off/deny).
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
+ * Echo allow/deny/off string into the logmask files can flip the bits on or
+ * off as expected, here is the bash script for example:
  *
- * Some trivial shell can flip all the bits on or off:
- *
- * log_mask="/proc/fs/ocfs2_nodemanager/log_mask"
- * cat $log_mask | (
- * 	while read bit status; do
- * 		# $1 is "on" or "off", say
- * 		echo "$bit $1" > $log_mask
- * 	done
- * )
+ * log_mask="/sys/fs/o2cb/log_mask"
+ * for node in ENTRY EXIT TCP MSG SOCKET ERROR NOTICE; do
+ *	echo allow >"$log_mask"/"$node"
+ * done
  */

 /* for task_struct */
-- 
Coly Li
SuSE Labs
