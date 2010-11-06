From: Jiri Slaby <jslaby@suse.cz>
Date: Sat, 06 Nov 2010 11:32:03 -0000
Subject: [Ocfs2-devel] [PATCH] ocfs2: fix memory leak
In-Reply-To: <1289034412-24278-1-git-send-email-jslaby@suse.cz>
References: <1289034412-24278-1-git-send-email-jslaby@suse.cz>
Message-ID: <1289034412-24278-4-git-send-email-jslaby@suse.cz>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: jirislaby@gmail.com
Cc: linux-kernel@vger.kernel.org, Mark Fasheh <mfasheh@suse.com>, Joel Becker <joel.becker@oracle.com>, ocfs2-devel@oss.oracle.com, Alexander Viro <viro@zeniv.linux.org.uk>, linux-fsdevel@vger.kernel.org

Stanse found that o2hb_heartbeat_group_make_item leaks some memory on
fail paths. Fix the paths by adding a new label and jump there.

Signed-off-by: Jiri Slaby <jslaby@suse.cz>
Cc: Mark Fasheh <mfasheh@suse.com>
Cc: Joel Becker <joel.becker@oracle.com>
Cc: ocfs2-devel at oss.oracle.com
Cc: Alexander Viro <viro@zeniv.linux.org.uk>
Cc: linux-fsdevel at vger.kernel.org
---
 fs/ocfs2/cluster/heartbeat.c |   14 ++++++++++----
 1 files changed, 10 insertions(+), 4 deletions(-)

diff --git a/fs/ocfs2/cluster/heartbeat.c b/fs/ocfs2/cluster/heartbeat.c
index 52c7557..9f26ac9 100644
--- a/fs/ocfs2/cluster/heartbeat.c
+++ b/fs/ocfs2/cluster/heartbeat.c
@@ -1964,8 +1964,10 @@ static struct config_item *o2hb_heartbeat_group_make_item(struct config_group *g
 	if (reg == NULL)
 		return ERR_PTR(-ENOMEM);
 
-	if (strlen(name) > O2HB_MAX_REGION_NAME_LEN)
-		return ERR_PTR(-ENAMETOOLONG);
+	if (strlen(name) > O2HB_MAX_REGION_NAME_LEN) {
+		ret = -ENAMETOOLONG;
+		goto free;
+	}
 
 	spin_lock(&o2hb_live_lock);
 	reg->hr_region_num = 0;
@@ -1974,7 +1976,8 @@ static struct config_item *o2hb_heartbeat_group_make_item(struct config_group *g
 							 O2NM_MAX_REGIONS);
 		if (reg->hr_region_num >= O2NM_MAX_REGIONS) {
 			spin_unlock(&o2hb_live_lock);
-			return ERR_PTR(-EFBIG);
+			ret = -EFBIG;
+			goto free;
 		}
 		set_bit(reg->hr_region_num, o2hb_region_bitmap);
 	}
@@ -1986,10 +1989,13 @@ static struct config_item *o2hb_heartbeat_group_make_item(struct config_group *g
 	ret = o2hb_debug_region_init(reg, o2hb_debug_dir);
 	if (ret) {
 		config_item_put(&reg->hr_item);
-		return ERR_PTR(ret);
+		goto free;
 	}
 
 	return &reg->hr_item;
+free:
+	kfree(reg);
+	return ERR_PTR(ret);
 }
 
 static void o2hb_heartbeat_group_drop_item(struct config_group *group,
-- 
1.7.3.1
