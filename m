From: Julia Lawall <julia@diku.dk>
Date: Thu, 14 Feb 2008 15:15:56 -0000
Subject: [Ocfs2-devel] [PATCH 3/6] fs/ocfs2: Use DIV_ROUND_UP
Message-ID: <Pine.LNX.4.58.0802141614400.1185@pc-041.diku.dk>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: mark.fasheh@oracle.com, kurt.hackel@oracle.com, ocfs2-devel@oss.oracle.com, linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org

From: Julia Lawall <julia@diku.dk>

The kernel.h macro DIV_ROUND_UP performs the computation (((n) + (d) - 1) /
(d)) but is perhaps more readable.

An extract of the semantic patch that makes this change is as follows:
(http://www.emn.fr/x-info/coccinelle/)

// <smpl>
@haskernel@
@@

#include <linux/kernel.h>

@depends on haskernel@
expression n,d;
@@

(
- (n + d - 1) / d
+ DIV_ROUND_UP(n,d)
|
- (n + (d - 1)) / d
+ DIV_ROUND_UP(n,d)
)

@depends on haskernel@
expression n,d;
@@

- DIV_ROUND_UP((n),d)
+ DIV_ROUND_UP(n,d)

@depends on haskernel@
expression n,d;
@@

- DIV_ROUND_UP(n,(d))
+ DIV_ROUND_UP(n,d)
// </smpl>

Signed-off-by: Julia Lawall <julia@diku.dk>

---

diff -u -p a/fs/ocfs2/cluster/heartbeat.c b/fs/ocfs2/cluster/heartbeat.c
--- a/fs/ocfs2/cluster/heartbeat.c 2007-12-31 08:43:31.000000000 +0100
+++ b/fs/ocfs2/cluster/heartbeat.c 2008-02-13 20:59:54.000000000 +0100
@@ -1149,7 +1149,7 @@ static int o2hb_map_slot_data(struct o2h
 		slot->ds_raw_block = NULL;
 	}

-	reg->hr_num_pages = (reg->hr_blocks + spp - 1) / spp;
+	reg->hr_num_pages = DIV_ROUND_UP(reg->hr_blocks, spp);
 	mlog(ML_HEARTBEAT, "Going to require %u pages to cover %u blocks "
 			   "at %u blocks per page\n",
 	     reg->hr_num_pages, reg->hr_blocks, spp);
