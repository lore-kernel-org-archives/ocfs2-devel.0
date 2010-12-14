From: Sunil Mushran <sunil.mushran@oracle.com>
Date: Tue, 14 Dec 2010 14:14:28 -0800
Subject: [Ocfs2-devel] [PATCH 2/5] ocfs2/cluster: Remove dropped region from
	o2hb quorum region bitmap
In-Reply-To: <1292364871-18461-1-git-send-email-sunil.mushran@oracle.com>
References: <1292364871-18461-1-git-send-email-sunil.mushran@oracle.com>
Message-ID: <1292364871-18461-3-git-send-email-sunil.mushran@oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

Patch removes a dropped region from the quorum region bitmap maintained by o2hb.

Signed-off-by: Sunil Mushran <sunil.mushran@oracle.com>
---
 fs/ocfs2/cluster/heartbeat.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/fs/ocfs2/cluster/heartbeat.c b/fs/ocfs2/cluster/heartbeat.c
index 9f26ac9..9f21dd7 100644
--- a/fs/ocfs2/cluster/heartbeat.c
+++ b/fs/ocfs2/cluster/heartbeat.c
@@ -2009,6 +2009,7 @@ static void o2hb_heartbeat_group_drop_item(struct config_group *group,
 	if (o2hb_global_heartbeat_active()) {
 		clear_bit(reg->hr_region_num, o2hb_region_bitmap);
 		clear_bit(reg->hr_region_num, o2hb_live_region_bitmap);
+		clear_bit(reg->hr_region_num, o2hb_quorum_region_bitmap);
 	}
 	hb_task = reg->hr_task;
 	reg->hr_task = NULL;
-- 
1.7.1
