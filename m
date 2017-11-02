From: alex chen <alex.chen@huawei.com>
Date: Thu, 2 Nov 2017 14:00:12 +0800
Subject: [Ocfs2-devel] [PATCH v2] ocfs2/cluster: unlock the o2hb_live_lock
	before the o2nm_depend_item()
Message-ID: <59FAB46C.9050703@huawei.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

In the following situation, the down_write() will be called under
the spin_lock(), which may lead a soft lockup:
o2hb_region_inc_user
 spin_lock(&o2hb_live_lock)
  o2hb_region_pin
   o2nm_depend_item
    configfs_depend_item
     inode_lock
      down_write
      -->here may sleep and reschedule

So we should unlock the o2hb_live_lock before the o2nm_depend_item(), and
get item reference in advance to prevent the region to be released.

Signed-off-by: Alex Chen <alex.chen@huawei.com>
Reviewed-by: Yiwen Jiang <jiangyiwen@huawei.com>
Reviewed-by: Jun Piao <piaojun@huawei.com>
---
 fs/ocfs2/cluster/heartbeat.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/fs/ocfs2/cluster/heartbeat.c b/fs/ocfs2/cluster/heartbeat.c
index d020604..07b2fdc 100644
--- a/fs/ocfs2/cluster/heartbeat.c
+++ b/fs/ocfs2/cluster/heartbeat.c
@@ -2399,8 +2399,15 @@ static int o2hb_region_pin(const char *region_uuid)
 		if (reg->hr_item_pinned || reg->hr_item_dropped)
 			goto skip_pin;

+		config_item_get(&reg->hr_item);
+		spin_unlock(&o2hb_live_lock);
+
 		/* Ignore ENOENT only for local hb (userdlm domain) */
 		ret = o2nm_depend_item(&reg->hr_item);
+
+		config_item_put(&reg->hr_item);
+		spin_lock(&o2hb_live_lock);
+
 		if (!ret) {
 			mlog(ML_CLUSTER, "Pin region %s\n", uuid);
 			reg->hr_item_pinned = 1;
-- 
1.9.5.msysgit.1
