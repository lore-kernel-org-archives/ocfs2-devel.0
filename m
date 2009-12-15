From: Mark Fasheh <mfasheh@suse.com>
Date: Tue, 15 Dec 2009 14:58:18 -0800
Subject: [Ocfs2-devel] [RFC 3/3] ocfs2: use allocation reservations for
	directory data
In-Reply-To: <1260917320-15959-1-git-send-email-mfasheh@suse.com>
References: <1260917320-15959-1-git-send-email-mfasheh@suse.com>
Message-ID: <1260917898-16078-3-git-send-email-mfasheh@suse.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

Use the reservations system for unindexed dir tree allocations. We don't
bother with the indexed tree as reads from it are mostly random anyway.

Signed-off-by: Mark Fasheh <mfasheh@suse.com>
---
 fs/ocfs2/dir.c |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/fs/ocfs2/dir.c b/fs/ocfs2/dir.c
index 28c3ec2..32b240c 100644
--- a/fs/ocfs2/dir.c
+++ b/fs/ocfs2/dir.c
@@ -2993,6 +2993,7 @@ static int ocfs2_expand_inline_dir(struct inode *dir, struct buffer_head *di_bh,
 	 * if we only get one now, that's enough to continue. The rest
 	 * will be claimed after the conversion to extents.
 	 */
+	data_ac->ac_resv = &oi->ip_la_data_resv;
 	ret = ocfs2_claim_clusters(osb, handle, data_ac, 1, &bit_off, &len);
 	if (ret) {
 		mlog_errno(ret);
@@ -3371,6 +3372,7 @@ static int ocfs2_extend_dir(struct ocfs2_super *osb,
 				mlog_errno(status);
 			goto bail;
 		}
+		data_ac->ac_resv = &OCFS2_I(dir)->ip_la_data_resv;
 
 		credits = ocfs2_calc_extend_credits(sb, el, 1);
 	} else {
-- 
1.5.6
