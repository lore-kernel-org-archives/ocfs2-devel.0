Return-Path: <bounces+ocfs2-devel=archiver.kernel.org@phx1.rp.oracleemaildelivery.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from aib29ajc246.phx1.oracleemaildelivery.com (aib29ajc246.phx1.oracleemaildelivery.com [192.29.103.246])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E9623C43334
	for <ocfs2-devel@archiver.kernel.org>; Tue, 19 Jul 2022 10:05:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; s=oss-phx-1109;
 d=oss.oracle.com;
 h=Date:To:From:Subject:Message-Id:MIME-Version:Sender;
 bh=5f/abykBqaGM4z868IVOaKa3K0p8keygIC9v51yGTGA=;
 b=OCo+WTjXm4VdyQzC9i5W3T/xGKSTWsXUyRNyuSQzcXpMSPNRwzB6Jx/iS98P6yOMxee+qnhKCVUm
   cPryxAvYrkLH2Xmz0hoe2isaP1CO+DZuk5nBT21h4+3Xq7XDbRa7n886fg/j7A3dhbe83CyyNBNl
   3jb8Gcxvqqxa76NoksggNYbWd118kNV5DuUQUhGfNt6EUMeD29644pNEpOsVqrwsaVWqMXn9QT//
   mbwUgnzIoYfxJXBNabOAhaLjtjC4uqKeKW+sjVWj0rofhXh9hyYB/0KO6ZdX7PFLMFfjZaETcHhb
   3fS1o4WQTtHRb22IFamvRDPUG1N7l50gXVYT0w==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; s=prod-phx-20191217;
 d=phx1.rp.oracleemaildelivery.com;
 h=Date:To:From:Subject:Message-Id:MIME-Version:Sender;
 bh=5f/abykBqaGM4z868IVOaKa3K0p8keygIC9v51yGTGA=;
 b=VwgwFwqdA4AqA70LgCDUANMqJJbwE79/JVlSOEas+RLwO8U+nA/6FhnvQz1SQE2ptsO9zLLPyWwp
   tOogeKffgHZ9D8de4s0HUFwA1Q/rPariQlR/gNrtiR9rUPTgi8yX9xa1O60jhK1G54Q8tAnDx0zj
   B7oYoFXjqtqNbDlxhoQinYobBJ9mZUEpvCev9VICBX8aSlRxBxxQ/Sa9Qg7MGvC6xRweXR0WYzE2
   DLFudx9U0GBz//7BWc/GirsYq8DJ1IrZ2aBYKXtkHwHBkRCkbqR9uhergPruiIEFbx5gp6dPlxYa
   wRB2C94aLgwW6P3Es8ph7w6qAa6toUTCYDdM5A==
Received: by omta-ad1-fd3-101-us-phoenix-1.omtaad1.vcndpphx.oraclevcn.com
 (Oracle Communications Messaging Server 8.1.0.1.20220603 64bit (built Jun  3
 2022))
 with ESMTPS id <0RF900OVKIPTH180@omta-ad1-fd3-101-us-phoenix-1.omtaad1.vcndpphx.oraclevcn.com> for
 ocfs2-devel@archiver.kernel.org; Tue, 19 Jul 2022 10:05:53 +0000 (GMT)
To: Mark Fasheh <mark@fasheh.com>, Joel Becker <jlbec@evilplan.org>,
 Joseph Qi <joseph.qi@linux.alibaba.com>
Date: Tue, 19 Jul 2022 12:05:33 +0200
Message-id:
 <0a0d6e9bf9d10f67b7a0c1cdd6176cdd0ad2e1f6.1658224839.git.christophe.jaillet@wanadoo.fr>
X-Mailer: git-send-email 2.34.1
In-reply-to:
 <bd6796635e58f9c47cf857573c3b9474a00ce26a.1658224839.git.christophe.jaillet@wanadoo.fr>
References:
 <bd6796635e58f9c47cf857573c3b9474a00ce26a.1658224839.git.christophe.jaillet@wanadoo.fr>
MIME-version: 1.0
X-Source-IP: 80.12.242.129
X-Proofpoint-Virus-Version: vendor=nai engine=6400 definitions=10412
 signatures=596000
X-Proofpoint-Spam-Details: rule=tap_notspam policy=tap score=0 clxscore=63
 bulkscore=0 phishscore=0 adultscore=0 lowpriorityscore=0 mlxscore=0
 malwarescore=0 suspectscore=0 spamscore=0 mlxlogscore=784 impostorscore=0
 priorityscore=182 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2206140000 definitions=main-2207190042
Cc: Christophe JAILLET <christophe.jaillet@wanadoo.fr>,
 kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org,
 ocfs2-devel@oss.oracle.com
Subject: [Ocfs2-devel] [PATCH 3/3] ocfs2: use the bitmap API to simplify code
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
X-ME-Date: Tue, 19 Jul 2022 12:05:39 +0200
X-ME-IP: 90.11.190.129
X-ServerName: smtp07.smtpout.orange.fr
X-Proofpoint-SPF-Result: pass
X-Proofpoint-SPF-Record: v=spf1 include:_spf_gp.wanadoo.fr
 include:spf.email-control.orange-business.com include:_spf_gpf.wanadoo.fr
 include:_spf_other.wanadoo.fr ?all
X-Spam: Clean
X-Proofpoint-GUID: ZtkweJmqL0JJ4NgBzdCM1Lcz3QRRA_sk
X-Proofpoint-ORIG-GUID: ZtkweJmqL0JJ4NgBzdCM1Lcz3QRRA_sk
Reporting-Meta:
 AAElCfINdpFDwwDimMFr9PMpBv2hoxM2q0aqOkEAeW/QzfAN40TyNWhd3iw5F8gL
 +v1yg4Nniyk29hiQ4k+h/55UGTD5F2XGX5TUA2VHGQLSD+cg5tyNGS9Kz5sGGiJE
 /mlVcmpTFDCUDSgj5sB7pr7BA7Y7rusO/VaVlU5Jag9F0iMoPyLvEh77SeNGvjS6
 1ru9eyr4YGy08tI2/wFKCFitbZmLad5JkSPIDc/MWP3y+7pgZCWWoGncYLqMhASu
 TCcL3Rv/xdRPaNm0RpOTvbk2x+Tk9KDjpbMuaIsG3Pq4BlSqEUgX1Uh//vWcO4Ix
 fhyFgm1zPLaSHJ8Ay+ksr9G51KkrO2PnNyJp+Nf8QFwOG4qco7mNAA8rHKPXZlTp
 eVCNwb5TFK3pmTwPFroDoJ23+6sQq0SruU+CBVQy6SAA6dpsx1A+GjkMmZmfp8K3
 u00MhB2yP0WdtLA9K0Nb8DkUs3PEStAY3dlMKfrq5hIi9v0sOeDRvJMUHf4uTNyy
 fAJ65Vj62es2fjdnRXhjAasz6QEkwJKf2ijtRagzo7s=

Use bitmap_zero() instead of hand-writing it.
It is less verbose.

While at it, add an explicit #include <linux/bitmap.h>.

Signed-off-by: Christophe JAILLET <christophe.jaillet@wanadoo.fr>
---
 fs/ocfs2/heartbeat.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/fs/ocfs2/heartbeat.c b/fs/ocfs2/heartbeat.c
index 4863ad35c242..e243cd99e63f 100644
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
