From: Jeff Liu <jeff.liu@oracle.com>
Date: Wed, 23 Sep 2009 16:49:22 +0800
Subject: [Ocfs2-devel] [PATCH 1/1] ocfs2: remove an invalid single quotation
	marks from the mlog string
In-Reply-To: <>
References: <>
Message-ID: <1253695762-23082-1-git-send-email-jeff.liu@oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

From: jeff <jeff@jeff-laptop.(none)>

 "Following lockres' are still on the "
                   ^ here

Signed-off-by: jeff <jeff@jeff-laptop.(none)>
---
 fs/ocfs2/dlm/dlmdomain.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/fs/ocfs2/dlm/dlmdomain.c b/fs/ocfs2/dlm/dlmdomain.c
index 4d9e6b2..601c832 100644
--- a/fs/ocfs2/dlm/dlmdomain.c
+++ b/fs/ocfs2/dlm/dlmdomain.c
@@ -684,7 +684,7 @@ void dlm_unregister_domain(struct dlm_ctxt *dlm)
 
 		/* This list should be empty. If not, print remaining lockres */
 		if (!list_empty(&dlm->tracking_list)) {
-			mlog(ML_ERROR, "Following lockres' are still on the "
+			mlog(ML_ERROR, "Following lockres are still on the "
 			     "tracking list:\n");
 			list_for_each_entry(res, &dlm->tracking_list, tracking)
 				dlm_print_one_lock_resource(res);
-- 
1.5.4.3
