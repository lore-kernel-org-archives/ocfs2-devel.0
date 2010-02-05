From: Roel Kluin <roel.kluin@gmail.com>
Date: Fri, 05 Feb 2010 10:26:27 +0100
Subject: [Ocfs2-devel] [PATCH] ocfs2: Fix contiguousness check in
	ocfs2_try_to_merge_extent_map()
Message-ID: <4B6BE443.5000307@gmail.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Mark Fasheh <mfasheh@suse.com>, Joel Becker <joel.becker@oracle.com>, tao.ma@oracle.com, ocfs2-devel@oss.oracle.com, Andrew Morton <akpm@linux-foundation.org>, LKML <linux-kernel@vger.kernel.org>

The wrong member was compared in the continguousness check.

Acked-by: Tao Ma <tao.ma@oracle.com>
Signed-off-by: Roel Kluin <roel.kluin@gmail.com>
---
>>         } else if ((ins->ei_phys + ins->ei_clusters) == emi->ei_phys &&
>>                    (ins->ei_cpos + ins->ei_clusters) == emi->ei_phys &&

>> should that 2nd emi->ei_phys be emi->ei_cpos?
> oh, yes, you are right. Do you want to provide a patch?

Here, I added your ack.

diff --git a/fs/ocfs2/extent_map.c b/fs/ocfs2/extent_map.c
index d35a27f..5328529 100644
--- a/fs/ocfs2/extent_map.c
+++ b/fs/ocfs2/extent_map.c
@@ -192,7 +192,7 @@ static int ocfs2_try_to_merge_extent_map(struct ocfs2_extent_map_item *emi,
 		emi->ei_clusters += ins->ei_clusters;
 		return 1;
 	} else if ((ins->ei_phys + ins->ei_clusters) == emi->ei_phys &&
-		   (ins->ei_cpos + ins->ei_clusters) == emi->ei_phys &&
+		   (ins->ei_cpos + ins->ei_clusters) == emi->ei_cpos &&
 		   ins->ei_flags == emi->ei_flags) {
 		emi->ei_phys = ins->ei_phys;
 		emi->ei_cpos = ins->ei_cpos;
