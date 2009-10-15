From: Sunil Mushran <sunil.mushran@oracle.com>
Date: Thu, 15 Oct 2009 15:41:24 -0700
Subject: [Ocfs2-devel] [PATCH] ocfs2: Use FIEMAP_EXTENT_SHARED
In-Reply-To: <1255646484-28357-1-git-send-email-sunil.mushran@oracle.com>
References: <1255646484-28357-1-git-send-email-sunil.mushran@oracle.com>
Message-ID: <1255646484-28357-2-git-send-email-sunil.mushran@oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com, linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org

Adds FIEMAP_EXTENT_SHARED flag to refcounted extents.

Signed-off-by: Sunil Mushran <sunil.mushran@oracle.com>
---
 fs/ocfs2/extent_map.c |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/fs/ocfs2/extent_map.c b/fs/ocfs2/extent_map.c
index 843db64..cdce5f8 100644
--- a/fs/ocfs2/extent_map.c
+++ b/fs/ocfs2/extent_map.c
@@ -786,6 +786,8 @@ int ocfs2_fiemap(struct inode *inode, struct fiemap_extent_info *fieinfo,
 		fe_flags = 0;
 		if (rec.e_flags & OCFS2_EXT_UNWRITTEN)
 			fe_flags |= FIEMAP_EXTENT_UNWRITTEN;
+		if (rec.e_flags & OCFS2_EXT_REFCOUNTED)
+			fe_flags |= FIEMAP_EXTENT_SHARED;
 		if (is_last)
 			fe_flags |= FIEMAP_EXTENT_LAST;
 		len_bytes = (u64)le16_to_cpu(rec.e_leaf_clusters) << osb->s_clustersize_bits;
-- 
1.6.0.4
