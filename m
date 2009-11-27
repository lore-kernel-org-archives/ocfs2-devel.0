From: Tristan Ye <tristan.ye@oracle.com>
Date: Fri, 27 Nov 2009 16:14:20 +0800
Subject: [Ocfs2-devel] [PATCH 1/2] Ocfs2: Need to initialize uuid when
	setuping the osb.
Message-ID: <1259309660-7732-1-git-send-email-tristan.ye@oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

I accidently found this when adding new ioctls for ocfs2
to request fs info from none-prvileged users.

ocfs2_super osb has successfully setuped osb.uuid_str, but
it did leave the osb.uuid field NULL without proper initializing
and bytes filling, it should be corrected I guess.

Signed-off-by: Tristan Ye <tristan.ye@oracle.com>
---
 fs/ocfs2/super.c |    7 +++++++
 1 files changed, 7 insertions(+), 0 deletions(-)

diff --git a/fs/ocfs2/super.c b/fs/ocfs2/super.c
index c0e48ae..f15fea7 100644
--- a/fs/ocfs2/super.c
+++ b/fs/ocfs2/super.c
@@ -1920,6 +1920,12 @@ static int ocfs2_setup_osb_uuid(struct ocfs2_super *osb, const unsigned char *uu
 
 	BUG_ON(uuid_bytes != OCFS2_VOL_UUID_LEN);
 
+	osb->uuid = kzalloc(OCFS2_VOL_UUID_LEN, GFP_KERNEL);
+	if (osb->uuid == NULL)
+		return -ENOMEM;
+
+	memmove(osb->uuid, uuid, OCFS2_VOL_UUID_LEN);
+
 	osb->uuid_str = kzalloc(OCFS2_VOL_UUID_LEN * 2 + 1, GFP_KERNEL);
 	if (osb->uuid_str == NULL)
 		return -ENOMEM;
@@ -2415,6 +2421,7 @@ static void ocfs2_delete_osb(struct ocfs2_super *osb)
 	kfree(osb->journal);
 	if (osb->local_alloc_copy)
 		kfree(osb->local_alloc_copy);
+	kfree(osb->uuid);
 	kfree(osb->uuid_str);
 	ocfs2_put_dlm_debug(osb->osb_dlm_debug);
 	memset(osb, 0, sizeof(struct ocfs2_super));
-- 
1.5.5
