From: Xiongfeng Wang <wangxiongfeng2@huawei.com>
Date: Mon, 20 Jul 2020 16:24:33 +0800
Subject: [Ocfs2-devel] [PATCH] dlmfs: add a newline when printing
	'capabilities' by sysfs
Message-ID: <20200720082433.164311-1-wangxiongfeng2@huawei.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: mark@fasheh.com, jlbec@evilplan.org, joseph.qi@linux.alibaba.com
Cc: ocfs2-devel@oss.oracle.com, linux-kernel@vger.kernel.org, wangxiongfeng2@huawei.com

When I cat module parameter 'capabilities' by sysfs, it displays as
follows. It's better to add a newline for easy reading.

root at syzkaller:~# cat /sys/module/ocfs2_dlmfs/parameters/capabilities
bast stackglueroot at syzkaller:~#

Signed-off-by: Xiongfeng Wang <wangxiongfeng2@huawei.com>
---
 fs/ocfs2/dlmfs/dlmfs.c | 7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff --git a/fs/ocfs2/dlmfs/dlmfs.c b/fs/ocfs2/dlmfs/dlmfs.c
index ea868c6f9800..1f9c864ec09b 100644
--- a/fs/ocfs2/dlmfs/dlmfs.c
+++ b/fs/ocfs2/dlmfs/dlmfs.c
@@ -82,8 +82,13 @@ static int param_set_dlmfs_capabilities(const char *val,
 static int param_get_dlmfs_capabilities(char *buffer,
 					const struct kernel_param *kp)
 {
-	return strlcpy(buffer, DLMFS_CAPABILITIES,
+	int cnt;
+
+	cnt = strlcpy(buffer, DLMFS_CAPABILITIES,
 		       strlen(DLMFS_CAPABILITIES) + 1);
+	cnt += sprintf(buffer + cnt, "\n");
+
+	return cnt;
 }
 module_param_call(capabilities, param_set_dlmfs_capabilities,
 		  param_get_dlmfs_capabilities, NULL, 0444);
-- 
2.20.1
