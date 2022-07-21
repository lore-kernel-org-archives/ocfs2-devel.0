Return-Path: <bounces+ocfs2-devel=archiver.kernel.org@phx1.rp.oracleemaildelivery.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from aib29ajc251.phx1.oracleemaildelivery.com (aib29ajc251.phx1.oracleemaildelivery.com [192.29.103.251])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 16D83C433EF
	for <ocfs2-devel@archiver.kernel.org>; Thu, 21 Jul 2022 20:49:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; s=oss-phx-1109;
 d=oss.oracle.com;
 h=Date:To:From:Subject:Message-Id:MIME-Version:Sender;
 bh=hBUTeTUlHbJdOINCvs5JQmkJL6tfhFUwIOOgwPkAmmg=;
 b=u5dAL1AR8cwHDOFLdT8MFp3eAheoWVmJaxhQc9UCyF4xOu2+6DKlbMLvZtp6cEhRUK08agPMx6z0
   uIv5RKtWHT/10n/J4QpBrJ+Qtyz1brEB8rBQHxYFcz2oT41hWA6NOWxltHk7fTo5S101Te9JKl4p
   LvfBUwVBg/3mPYZL9momT36okf0nRcgGAkT9E2EPpKH+b3SATHg9Q64OgOrGNQxk6LKoGhOvMgGs
   1+ue+SHopEbl2pwd0aXQlT3ztq1HQAuVTa2VeUzt4/5X3mnYa+HnbyP/W2MRV8z1xOSrm8LRW+25
   2DTOxciXwikSpHhpP6WgIr4WX/bw4duT6iTK8A==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; s=prod-phx-20191217;
 d=phx1.rp.oracleemaildelivery.com;
 h=Date:To:From:Subject:Message-Id:MIME-Version:Sender;
 bh=hBUTeTUlHbJdOINCvs5JQmkJL6tfhFUwIOOgwPkAmmg=;
 b=lqKUYjD6BfV8gF0yzTqH5irG2mPvyQVUhINc890j/dGtOwcpBmltn5VpToNULh9FR00yyAALC2Xb
   2drJz9Xx0RD1x3qqZ/ZIqZgM9Q6nYXhNmRZ6TxJu8bLketXE4O3vsiwaavLNAzQE7WWtU10r++/M
   hl03xa3Wra+YgSbezbI+2rC13t+YYUIwxwGur9IgxwJ7bSg/e/K44RRALEb6m45Amh2N0JL7plTw
   2ZxliC63gjCdeNlZ4bVeOVX/9hKnmPlyKvNHmsJEFE+1Zv0kLLiIZQnjIPY31lSIht01zIo0Jxqj
   tchh5tE4TpkV3dTrREhVfovWwXe57k6bfnJVIw==
Received: by omta-ad2-fd3-202-us-phoenix-1.omtaad2.vcndpphx.oraclevcn.com
 (Oracle Communications Messaging Server 8.1.0.1.20220621 64bit (built Jun 21
 2022))
 with ESMTPS id <0RFE00FGC1V2KF70@omta-ad2-fd3-202-us-phoenix-1.omtaad2.vcndpphx.oraclevcn.com> for
 ocfs2-devel@archiver.kernel.org; Thu, 21 Jul 2022 20:49:50 +0000 (GMT)
To: akpm@linux-foundation.org, Mark Fasheh <mark@fasheh.com>,
 Joel Becker <jlbec@evilplan.org>, Joseph Qi <joseph.qi@linux.alibaba.com>
Date: Thu, 21 Jul 2022 22:49:25 +0200
Message-id:
 <bd1429c84ec7d174c96dbb67a2b42b1b456d9394.1658436259.git.christophe.jaillet@wanadoo.fr>
X-Mailer: git-send-email 2.34.1
In-reply-to: <cover.1658436259.git.christophe.jaillet@wanadoo.fr>
References: <cover.1658436259.git.christophe.jaillet@wanadoo.fr>
MIME-version: 1.0
X-Source-IP: 80.12.242.14
X-Proofpoint-Virus-Version: vendor=nai engine=6400 definitions=10415
 signatures=596000
X-Proofpoint-Spam-Details: rule=tap_notspam policy=tap score=0 spamscore=0
 suspectscore=0 adultscore=0 priorityscore=1501 mlxlogscore=999 impostorscore=0
 malwarescore=0 bulkscore=0 clxscore=-26 phishscore=0 lowpriorityscore=0
 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2206140000 definitions=main-2207210084
Cc: Christophe JAILLET <christophe.jaillet@wanadoo.fr>,
 kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org,
 ocfs2-devel@oss.oracle.com
Subject: [Ocfs2-devel] [PATCH v2 1/3] ocfs2: Remove some useless functions
X-BeenThere: ocfs2-devel@oss.oracle.com
X-Mailman-Version: 2.1.15
Precedence: list
List-Id: <ocfs2-devel.oss.oracle.com>
List-Unsubscribe: <https://oss.oracle.com/mailman/options/ocfs2-devel>,
 <mailto:ocfs2-devel-request@oss.oracle.com?subject=unsubscribe>
List-Archive: <http://oss.oracle.com/pipermail/ocfs2-devel/>
List-Post: <mailto:ocfs2-devel@oss.oracle.com>
List-Help: <mailto:ocfs2-devel-request@oss.oracle.com?subject=help>
List-Subscribe: <https://oss.oracle.com/mailman/listinfo/ocfs2-devel>,
 <mailto:ocfs2-devel-request@oss.oracle.com?subject=subscribe>
From: Christophe JAILLET via Ocfs2-devel <ocfs2-devel@oss.oracle.com>
Reply-to: Christophe JAILLET <christophe.jaillet@wanadoo.fr>
Content-type: text/plain; charset="us-ascii"
Content-transfer-encoding: 7bit
Errors-to: ocfs2-devel-bounces@oss.oracle.com
X-ME-Helo: pop-os.home
X-ME-Auth:
 YWZlNiIxYWMyZDliZWIzOTcwYTEyYzlhMmU3ZiQ1M2U2MzfzZDfyZTMxZTBkMTYyNDBjNDJlZmQ3ZQ==
X-ME-Date: Thu, 21 Jul 2022 22:49:31 +0200
X-ME-IP: 90.11.190.129
X-ServerName: smtp-14.smtpout.orange.fr
X-Proofpoint-SPF-Result: pass
X-Proofpoint-SPF-Record: v=spf1 include:_spf_gp.wanadoo.fr
 include:spf.email-control.orange-business.com include:_spf_gpf.wanadoo.fr
 include:_spf_other.wanadoo.fr ?all
X-Spam: Clean
X-Proofpoint-GUID: y2EvSPgzsVTVrB_YczLbA94wIDHkFC4r
X-Proofpoint-ORIG-GUID: y2EvSPgzsVTVrB_YczLbA94wIDHkFC4r
Reporting-Meta:
 AAEAV6J0UfJQoWZ3Ic9mVEeMJlqSaAqGWEXu62OUD0t20gUsCsT1O31LoLkJbSzi
 VRfJb38b3WEKLOIKEOlok/Vwcxsn46RLjZP4TAvr7DiLX+YYWB7WvhUM50PwMOrd
 RA44iuPQUF7ua/XqMfs3WVQI+ipMjLYucU8ZcflhDngd+eF00VlOrSuLh2IswSRM
 63X/O54N9Acpbzraa9/0dzRLWfA5xb86RlI7lfbJM42R58pZaTDtKIkN1LP7gC+S
 UGyJ9ODFV2g8W4mhy83c9HTFNILxwdOHDlGBcg3aLC2Gt4bYSPJ8FZWNBza9xsxC
 RnOx5ThIqnb2bCGpczbn8BqfIWcFTIBcC8QMT6bxaPShuHVhFczYrO4didT5gdVU
 GBl+hcSiVFLmvwbSxvRP7J1HHn/Mw1X46TzSvy9XYumohBC7Zbv+hvyljc1d/hm/
 2PhR+Z7aHbYdLbb/mfO4gQ6rxuiS7MPMgUEIjRXSHnPc5MfmRBTisYTVMQLgKAHN
 553TAvsbdDVcwfR3S8GEdzERjAqfPRmIKuGDHCXWU0Aj

__ocfs2_node_map_set_bit() and __ocfs2_node_map_clear_bit() are just
wrapper around set_bit() and clear_bit().

The leading __ also makes think that these functions are non-atomic just
like __set_bit() and __clear_bit().

So, just remove these wrappers and call set_bit() and clear_bit()
directly.

Signed-off-by: Christophe JAILLET <christophe.jaillet@wanadoo.fr>
Reviewed-by: Joseph Qi <joseph.qi@linux.alibaba.com>
---
v1 -> v2
- fix a typo in the log message
- add R-b tag
---
 fs/ocfs2/heartbeat.c | 21 ++-------------------
 1 file changed, 2 insertions(+), 19 deletions(-)

diff --git a/fs/ocfs2/heartbeat.c b/fs/ocfs2/heartbeat.c
index 9099d8fc7599..1d72e0788943 100644
--- a/fs/ocfs2/heartbeat.c
+++ b/fs/ocfs2/heartbeat.c
@@ -24,11 +24,6 @@
 
 #include "buffer_head_io.h"
 
-static inline void __ocfs2_node_map_set_bit(struct ocfs2_node_map *map,
-					    int bit);
-static inline void __ocfs2_node_map_clear_bit(struct ocfs2_node_map *map,
-					      int bit);
-
 /* special case -1 for now
  * TODO: should *really* make sure the calling func never passes -1!!  */
 static void ocfs2_node_map_init(struct ocfs2_node_map *map)
@@ -65,12 +60,6 @@ void ocfs2_do_node_down(int node_num, void *data)
 	ocfs2_recovery_thread(osb, node_num);
 }
 
-static inline void __ocfs2_node_map_set_bit(struct ocfs2_node_map *map,
-					    int bit)
-{
-	set_bit(bit, map->map);
-}
-
 void ocfs2_node_map_set_bit(struct ocfs2_super *osb,
 			    struct ocfs2_node_map *map,
 			    int bit)
@@ -79,16 +68,10 @@ void ocfs2_node_map_set_bit(struct ocfs2_super *osb,
 		return;
 	BUG_ON(bit >= map->num_nodes);
 	spin_lock(&osb->node_map_lock);
-	__ocfs2_node_map_set_bit(map, bit);
+	set_bit(bit, map->map);
 	spin_unlock(&osb->node_map_lock);
 }
 
-static inline void __ocfs2_node_map_clear_bit(struct ocfs2_node_map *map,
-					      int bit)
-{
-	clear_bit(bit, map->map);
-}
-
 void ocfs2_node_map_clear_bit(struct ocfs2_super *osb,
 			      struct ocfs2_node_map *map,
 			      int bit)
@@ -97,7 +80,7 @@ void ocfs2_node_map_clear_bit(struct ocfs2_super *osb,
 		return;
 	BUG_ON(bit >= map->num_nodes);
 	spin_lock(&osb->node_map_lock);
-	__ocfs2_node_map_clear_bit(map, bit);
+	clear_bit(bit, map->map);
 	spin_unlock(&osb->node_map_lock);
 }
 
-- 
2.34.1


_______________________________________________
Ocfs2-devel mailing list
Ocfs2-devel@oss.oracle.com
https://oss.oracle.com/mailman/listinfo/ocfs2-devel
