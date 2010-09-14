From: Sunil Mushran <sunil.mushran@oracle.com>
Date: Tue, 14 Sep 2010 15:50:45 -0700
Subject: [Ocfs2-devel] [PATCH 09/20] ocfs2/cluster: Print messages when
	adding/removing nodes and heartbeat regions
In-Reply-To: <1284504656-2434-1-git-send-email-sunil.mushran@oracle.com>
References: <1284504656-2434-1-git-send-email-sunil.mushran@oracle.com>
Message-ID: <1284504656-2434-10-git-send-email-sunil.mushran@oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

Prints messages when the user adds or removes nodes and heartbeat regions.
The heartbeat region logging is only enabled in the global heartbeat mode. These
messages are useful when debugging cluster related issues.

Signed-off-by: Sunil Mushran <sunil.mushran@oracle.com>
---
 fs/ocfs2/cluster/heartbeat.c   |    9 ++++++++-
 fs/ocfs2/cluster/nodemanager.c |    4 ++++
 2 files changed, 12 insertions(+), 1 deletions(-)

diff --git a/fs/ocfs2/cluster/heartbeat.c b/fs/ocfs2/cluster/heartbeat.c
index cec9d4c..1d71856 100644
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
 
@@ -1743,7 +1750,7 @@ ssize_t o2hb_heartbeat_group_mode_store(struct o2hb_heartbeat_group *group,
 
 		ret = o2hb_global_hearbeat_mode_set(i);
 		if (!ret)
-			printk(KERN_NOTICE "ocfs2: Heartbeat mode set to %s\n",
+			printk(KERN_NOTICE "o2hb: Heartbeat mode set to %s\n",
 			       o2hb_heartbeat_mode_desc[i]);
 		return count;
 	}
diff --git a/fs/ocfs2/cluster/nodemanager.c b/fs/ocfs2/cluster/nodemanager.c
index ed0c9f3..f488fbe 100644
--- a/fs/ocfs2/cluster/nodemanager.c
+++ b/fs/ocfs2/cluster/nodemanager.c
@@ -711,6 +711,8 @@ static struct config_item *o2nm_node_group_make_item(struct config_group *group,
 	config_item_init_type_name(&node->nd_item, name, &o2nm_node_type);
 	spin_lock_init(&node->nd_lock);
 
+	printk(KERN_NOTICE "o2nm: Registering node %s\n", name);
+
 	return &node->nd_item;
 }
 
@@ -744,6 +746,8 @@ static void o2nm_node_group_drop_item(struct config_group *group,
 	}
 	write_unlock(&cluster->cl_nodes_lock);
 
+	printk(KERN_NOTICE "o2nm: Unregistered node %s\n",
+	       config_item_name(&node->nd_item));
 	config_item_put(item);
 }
 
-- 
1.7.0.4
