From: Sunil Mushran <sunil.mushran@oracle.com>
Date: Wed Jan 16 11:33:19 2008
Subject: [Ocfs2-devel] [PATCH 06/20] ocfs2: Fix possibly too long write in
	o2hb_setup_one_bio()
In-Reply-To: <1200511977-19513-1-git-send-email-sunil.mushran@oracle.com>
References: <1200511977-19513-1-git-send-email-sunil.mushran@oracle.com>
Message-ID: <1200511977-19513-7-git-send-email-sunil.mushran@oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

Mainline commit bc7e97cbdd4bef162e5772c74ee2cc4487a2d997
Author: Jan Kara <jack@suse.cz>
Date: Wed, 10 Oct 2007 16:25:42 +0200

We should subtract start of our IO from PAGE_CACHE_SIZE to get the right
length of the write we want to perform.

Signed-off-by: Jan Kara <jack@suse.cz>
Signed-off-by: Mark Fasheh <mark.fasheh@oracle.com>
---
 fs/ocfs2/cluster/heartbeat.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/fs/ocfs2/cluster/heartbeat.c b/fs/ocfs2/cluster/heartbeat.c
index 6a91607..999e7e5 100644
--- a/fs/ocfs2/cluster/heartbeat.c
+++ b/fs/ocfs2/cluster/heartbeat.c
@@ -275,7 +275,7 @@ static struct bio *o2hb_setup_one_bio(struct o2hb_region *reg,
 		current_page = cs / spp;
 		page = reg->hr_slot_data[current_page];
 
-		vec_len = min(PAGE_CACHE_SIZE,
+		vec_len = min(PAGE_CACHE_SIZE - vec_start,
 			      (max_slots-cs) * (PAGE_CACHE_SIZE/spp) );
 
 		mlog(ML_HB_BIO, "page %d, vec_len = %u, vec_start = %u\n",
-- 
1.5.3.4
