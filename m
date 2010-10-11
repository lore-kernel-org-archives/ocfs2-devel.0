From: Goldwyn Rodrigues <rgoldwyn@gmail.com>
Date: Mon, 11 Oct 2010 12:57:09 -0500
Subject: [Ocfs2-devel] [PATCH] Initialize max_slots early
Message-ID: <AANLkTinGe9j+NnKh9ftHH1po1ZSoaE_AiZ47q2v-+9cT@mail.gmail.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

Functions such as ocfs2_recovery_init() make use of osb->max_slots.
Initialize osb->max_slots early so the functions may use the correct
value.

Signed-off-by: Goldwyn Rodrigues <rgoldwyn@suse.de>
---
diff --git a/fs/ocfs2/super.c b/fs/ocfs2/super.c
index fa1be1b..3894c7e 100644
--- a/fs/ocfs2/super.c
+++ b/fs/ocfs2/super.c
@@ -2060,6 +2060,15 @@ static int ocfs2_initialize_super(struct super_block *sb,
 	snprintf(osb->dev_str, sizeof(osb->dev_str), "%u,%u",
 		 MAJOR(osb->sb->s_dev), MINOR(osb->sb->s_dev));

+	osb->max_slots = le16_to_cpu(di->id2.i_super.s_max_slots);
+	if (osb->max_slots > OCFS2_MAX_SLOTS || osb->max_slots == 0) {
+		mlog(ML_ERROR, "Invalid number of node slots (%u)\n",
+		     osb->max_slots);
+		status = -EINVAL;
+		goto bail;
+	}
+	mlog(0, "max_slots for this device: %u\n", osb->max_slots);
+
 	ocfs2_orphan_scan_init(osb);

 	status = ocfs2_recovery_init(osb);
@@ -2098,15 +2107,6 @@ static int ocfs2_initialize_super(struct super_block *sb,
 		goto bail;
 	}

-	osb->max_slots = le16_to_cpu(di->id2.i_super.s_max_slots);
-	if (osb->max_slots > OCFS2_MAX_SLOTS || osb->max_slots == 0) {
-		mlog(ML_ERROR, "Invalid number of node slots (%u)\n",
-		     osb->max_slots);
-		status = -EINVAL;
-		goto bail;
-	}
-	mlog(0, "max_slots for this device: %u\n", osb->max_slots);
-
 	osb->slot_recovery_generations =
 		kcalloc(osb->max_slots, sizeof(*osb->slot_recovery_generations),
 			GFP_KERNEL);

-- 
Goldwyn
