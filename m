From: Gu Zheng <guz.fnst@cn.fujitsu.com>
Date: Mon, 08 Jul 2013 07:56:25 -0000
Subject: [Ocfs2-devel] [PATCH] ocfs2/refcounttree: add the missing NULL
 check of the return value of find_or_create_page()
Message-ID: <51DA6FD5.8050300@cn.fujitsu.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: mfasheh@suse.com, jlbec@evilplan.org
Cc: ocfs2-devel@oss.oracle.com, linux-kernel <linux-kernel@vger.kernel.org>

Add the missing NULL check of the return value of find_or_create_page() in
function ocfs2_duplicate_clusters_by_page().

Signed-off-by: Gu Zheng <guz.fnst@cn.fujitsu.com>
---
 fs/ocfs2/refcounttree.c |    6 +++++-
 1 files changed, 5 insertions(+), 1 deletions(-)

diff --git a/fs/ocfs2/refcounttree.c b/fs/ocfs2/refcounttree.c
index 998b17e..456d0e4 100644
--- a/fs/ocfs2/refcounttree.c
+++ b/fs/ocfs2/refcounttree.c
@@ -2965,7 +2965,11 @@ int ocfs2_duplicate_clusters_by_page(handle_t *handle,
 			to = map_end & (PAGE_CACHE_SIZE - 1);

 		page = find_or_create_page(mapping, page_index, GFP_NOFS);
-
+		if (!page) {
+			ret = -ENOMEM;
+			mlog_errno(ret);
+			break;
+		}
 		/*
 		 * In case PAGE_CACHE_SIZE <= CLUSTER_SIZE, This page
 		 * can't be dirtied before we CoW it out.
-- 
1.7.7
