Return-Path: <bounces+ocfs2-devel=archiver.kernel.org@phx1.rp.oracleemaildelivery.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from aib29ajc252.phx1.oracleemaildelivery.com (aib29ajc252.phx1.oracleemaildelivery.com [192.29.103.252])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 20441C43334
	for <ocfs2-devel@archiver.kernel.org>; Thu, 21 Jul 2022 20:50:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; s=oss-phx-1109;
 d=oss.oracle.com;
 h=Date:To:From:Subject:Message-Id:MIME-Version:Sender;
 bh=D4bvJEVl2+ZW+KbZzj+RtS0vjjayRJk0ztxb3Y43GjQ=;
 b=gLsyi5HzKFBOzOSBjMxDwFNbZzVaJLPZFoxxHBXbMU3EPWo9pn02Osa8gKVBCZNVlgegvBclgAow
   n2BWIFirPZh+w99LN1PSxxd1FwADe06/eFEdvTOGNlfPponl0uLetu8ib4wPcL6C68Pnyl4m5u64
   mVVEAnwaFoo8VgyxAFOUPufSivNQzfM7Z5BuRhsKcv/sw/8Vgy1OW2i2KJOgtrYHac94PN7B0OC5
   QbcoDfuuhP+iB63FX0vjR3V/1vQUAIoKO3vERAwLjkM7lWUjBfej5R47iXsZRH/gFieeX+aRT5M/
   E2XG+9NbLx0Q4MBUKaigoKlSpzLmje8Cs5zH5Q==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; s=prod-phx-20191217;
 d=phx1.rp.oracleemaildelivery.com;
 h=Date:To:From:Subject:Message-Id:MIME-Version:Sender;
 bh=D4bvJEVl2+ZW+KbZzj+RtS0vjjayRJk0ztxb3Y43GjQ=;
 b=eEMDi43ygldbUQi30dTjYB+3MW/cV7WZlTv4Yr7fh0sWNHLJNv+HAotq1Ygg+y3fKpfMRwyOm6tz
   Ve93nZ2a5p4dNYLprJFiYw2S5NmzChTe0eNJO3Il4402gChlmefrxUDs4I3Vc/zLrDfhsLTX0RrD
   Z7H6leci0gd3yeh57iOe71sxhf1JIsZIXEbsU1Qoppv8C4dZPxQzdLtVMkJ2yqjjaHIDc8gVk8db
   ByOZ2CYhJhBPpTUCfcIM10FVkq9A5GRj/HUX9rD+qlFdK89OY/O6TQhQJjrIe2UaJFPZRS2Qrrjy
   uKj4BOL7WWMzdCiBXZnp+c7tZUglsXkNuAiyXg==
Received: by omta-ad3-fd1-301-us-phoenix-1.omtaad3.vcndpphx.oraclevcn.com
 (Oracle Communications Messaging Server 8.1.0.1.20220621 64bit (built Jun 21
 2022))
 with ESMTPS id <0RFE00DFN1VBYZ40@omta-ad3-fd1-301-us-phoenix-1.omtaad3.vcndpphx.oraclevcn.com> for
 ocfs2-devel@archiver.kernel.org; Thu, 21 Jul 2022 20:49:59 +0000 (GMT)
To: akpm@linux-foundation.org, Mark Fasheh <mark@fasheh.com>,
 Joel Becker <jlbec@evilplan.org>, Joseph Qi <joseph.qi@linux.alibaba.com>
Date: Thu, 21 Jul 2022 22:49:37 +0200
Message-id:
 <86d2a027c319db12055c98f00c65f7d01e703722.1658436259.git.christophe.jaillet@wanadoo.fr>
X-Mailer: git-send-email 2.34.1
In-reply-to: <cover.1658436259.git.christophe.jaillet@wanadoo.fr>
References: <cover.1658436259.git.christophe.jaillet@wanadoo.fr>
MIME-version: 1.0
X-Source-IP: 80.12.242.25
X-Proofpoint-Virus-Version: vendor=nai engine=6400 definitions=10415
 signatures=596000
X-Proofpoint-Spam-Details: rule=tap_notspam policy=tap score=0 impostorscore=0
 malwarescore=0 spamscore=0 clxscore=-19 bulkscore=0 phishscore=0
 priorityscore=1501 lowpriorityscore=0 mlxscore=0 mlxlogscore=853 adultscore=0
 suspectscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2206140000 definitions=main-2207210084
Cc: Christophe JAILLET <christophe.jaillet@wanadoo.fr>,
 kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org,
 ocfs2-devel@oss.oracle.com
Subject: [Ocfs2-devel] [PATCH v2 2/3] ocfs2: use the bitmap API to simplify	code
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
X-ME-Date: Thu, 21 Jul 2022 22:49:41 +0200
X-ME-IP: 90.11.190.129
X-ServerName: smtp-25.smtpout.orange.fr
X-Proofpoint-SPF-Result: pass
X-Proofpoint-SPF-Record: v=spf1 include:_spf_gp.wanadoo.fr
 include:spf.email-control.orange-business.com include:_spf_gpf.wanadoo.fr
 include:_spf_other.wanadoo.fr ?all
X-Spam: Clean
X-Proofpoint-GUID: YPXFLRmk0qmGHKsRuL8xxl--WQM5jwVh
X-Proofpoint-ORIG-GUID: YPXFLRmk0qmGHKsRuL8xxl--WQM5jwVh
Reporting-Meta:
 AAEJUI7dQ/XZdSQoX5IFdLi9glI0KdiilX5MV1zVkAT+xnDkPZeAt7yU1IYM2Wz/
 D3hLker29FwatFreAw9T2gz6xhRN2UcZatHi2Jm7ZOX+Pz4z/n/cLjkFG+21Ic9L
 QuHkdXcVdfreacAi3uNsTuQ25IgGrXshHQmxcY8a3Bp274r0xn9B4AtE9BmIZnkl
 eK5X1d6kmhg7wbKnWCELwyHqJQ7hfcgbF6h9ZysGUpQjLsOn2Q+R0CkHUhstgZRB
 GYpN0jmgJR+kDjG/ATwWC49AXWuU7bdPtKey1lLGFYIJEjX17S1TdhRup+0c7ouy
 7g3XxJfv6siEh0LlPIXopOUNq8Et8MTTsjCieYDvqdVui7O/Z/oVZmPDUMgh8LAV
 0hfB+gY9t3cNOj/RKnGGSuw7CDTjrX14uv/AxVd3aADAJxVv6pTEs7YXV75kUsBS
 hq1AASVEzc3MViOJdzA0J2YzwUE+n8lgsQ69PXOa9WQ67ktDOU/V1xjp/OgCtup9
 /+REld8y5a6lA3ylUd7DO3vgHjWeIM3IryZ4tlLHqtLv

Use bitmap_zero() instead of hand-writing it.
It is less verbose.

While at it, add an explicit #include <linux/bitmap.h>.

Signed-off-by: Christophe JAILLET <christophe.jaillet@wanadoo.fr>
Reviewed-by: Joseph Qi <joseph.qi@linux.alibaba.com>
---
v1 -> v2
- no change
- it was patch 3/3 in v1
---
 fs/ocfs2/heartbeat.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/fs/ocfs2/heartbeat.c b/fs/ocfs2/heartbeat.c
index 1d72e0788943..dd29d60af154 100644
--- a/fs/ocfs2/heartbeat.c
+++ b/fs/ocfs2/heartbeat.c
@@ -8,6 +8,7 @@
  * Copyright (C) 2002, 2004 Oracle.  All rights reserved.
  */
 
+#include <linux/bitmap.h>
 #include <linux/fs.h>
 #include <linux/types.h>
 #include <linux/highmem.h>
@@ -29,8 +30,7 @@
 static void ocfs2_node_map_init(struct ocfs2_node_map *map)
 {
 	map->num_nodes = OCFS2_NODE_MAP_MAX_NODES;
-	memset(map->map, 0, BITS_TO_LONGS(OCFS2_NODE_MAP_MAX_NODES) *
-	       sizeof(unsigned long));
+	bitmap_zero(map->map, OCFS2_NODE_MAP_MAX_NODES);
 }
 
 void ocfs2_init_node_maps(struct ocfs2_super *osb)
-- 
2.34.1


_______________________________________________
Ocfs2-devel mailing list
Ocfs2-devel@oss.oracle.com
https://oss.oracle.com/mailman/listinfo/ocfs2-devel
