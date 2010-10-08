From: Sunil Mushran <sunil.mushran@oracle.com>
Date: Thu,  7 Oct 2010 17:15:23 -0700
Subject: [Ocfs2-devel] [PATCH 09/22] ocfs2/cluster: Print messages when
	adding/removing heartbeat regions
In-Reply-To: <1286496936-17072-1-git-send-email-sunil.mushran@oracle.com>
References: <1286496936-17072-1-git-send-email-sunil.mushran@oracle.com>
Message-ID: <1286496936-17072-10-git-send-email-sunil.mushran@oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

Prints messages when the user adds or removes heartbeat regions in global
heartbeat mode. These messages are useful when debugging cluster related issues.

Signed-off-by: Sunil Mushran <sunil.mushran@oracle.com>
---
 fs/ocfs2/cluster/heartbeat.c |    9 ++++++++-
 1 files changed, 8 insertions(+), 1 deletions(-)

diff --git a/fs/ocfs2/cluster/heartbeat.c b/fs/ocfs2/cluster/heartbeat.c
index 3415e58..12bb12b 100644
--- a/fs/ocfs2/cluster/heartbeat.c
+++ b/fs/ocfs2/cluster/heartbeat.c
@@ -1476,6 +1476,10 @@ static ssize_t o2hb_region_dev_write(struct o2hb_region *reg,
 	else
 		ret = -EIO;
 
+	if (hb_task && o2hb_global_heartbeat_active())
+		printk(KERN_NOTICE "o2hb: Heartbeat started on region %s\n",
+		       config_item_name(&reg->hr_item));
+
 out:
 	if (filp)
 		fput(filp);
@@ -1659,6 +1663,9 @@ static void o2hb_heartbeat_group_drop_item(struct config_group *group,
 		wake_up(&o2hb_steady_queue);
 	}
 
+	if (o2hb_global_heartbeat_active())
+		printk(KERN_NOTICE "o2hb: Heartbeat stopped on region %s\n",
+		       config_item_name(&reg->hr_item));
 	config_item_put(item);
 }
 
@@ -1745,7 +1752,7 @@ ssize_t o2hb_heartbeat_group_mode_store(struct o2hb_heartbeat_group *group,
 
 		ret = o2hb_global_hearbeat_mode_set(i);
 		if (!ret)
-			printk(KERN_NOTICE "ocfs2: Heartbeat mode set to %s\n",
+			printk(KERN_NOTICE "o2hb: Heartbeat mode set to %s\n",
 			       o2hb_heartbeat_mode_desc[i]);
 		return count;
 	}
-- 
1.7.0.4
