Return-Path: <bounces+ocfs2-devel=archiver.kernel.org@phx1.rp.oracleemaildelivery.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from aib29ajc249.phx1.oracleemaildelivery.com (aib29ajc249.phx1.oracleemaildelivery.com [192.29.103.249])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id F02AAC43334
	for <ocfs2-devel@archiver.kernel.org>; Tue, 19 Jul 2022 10:01:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; s=oss-phx-1109;
 d=oss.oracle.com;
 h=Date:To:From:Subject:Message-Id:MIME-Version:Sender;
 bh=GtI+CtfVoxRnzpiL0nr2Z9pB4pyesxeppogIXmoY/ck=;
 b=dB4Dsrgmr0NXl+u6AK8y3Fmy+lJrrY7CtulVIjoEa2Ntel0g4bt20R6EppS9UdrE1RI4I92IMI0f
   NxZxwe9bdTaYj/Ya67XWl1qjqCYcM4A45k1eQ2IaVKrD5tS2DrzIQOTkOX4hCZ3ztK8+yT7DCNHN
   rvvlDmjqseg77Uvxt/HjxDOjt5U2ic2NhWXIsVyLjRhWJPmwHg6CyycDSmgPolTGJz5NjJPCrAiG
   kaQjBexIWGRY3CbnZEtGnL5RWqtprA/s6zZW145OVkckcKBJAmsRZslqB6U2+BlrcjTPDPjUONoo
   IHWQvq1qdFiSpSV2ytV1lxgi03DIKAk1VjysDA==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; s=prod-phx-20191217;
 d=phx1.rp.oracleemaildelivery.com;
 h=Date:To:From:Subject:Message-Id:MIME-Version:Sender;
 bh=GtI+CtfVoxRnzpiL0nr2Z9pB4pyesxeppogIXmoY/ck=;
 b=pUJLjZHcoOfcimE5LCSWxOOFS/yLqz5k47Ggv/snvN86rjpwsebUwE+W5SfA0K+nUFt82RKtuua9
   j5yoOMCO+ONEPCIlw+Cw0WApxrsZnI1F2hj2dsVclnc7IVzAFTeftyMCx+NP327G4RZWPQFz/6Ye
   r2fRm8VhuQaSmf+aBwx4ELLPwdYaY/GLlym5pAFdxEimHzxmDa49g3GPEDT2uOImUeEbk5oTgaLX
   tWho2/1VpCq7EvqdQglFycUZ7OyNwmupyjiTXu9P5Z280JMtBPml5lQHXfw8Zn5pgmcqFMlMTVz7
   /F4Yr/FaAe21+0geRnR4TKMSP7IS0aCape+FlQ==
Received: by omta-ad2-fd1-202-us-phoenix-1.omtaad2.vcndpphx.oraclevcn.com
 (Oracle Communications Messaging Server 8.1.0.1.20220603 64bit (built Jun  3
 2022))
 with ESMTPS id <0RF900DHTIIWWVE0@omta-ad2-fd1-202-us-phoenix-1.omtaad2.vcndpphx.oraclevcn.com> for
 ocfs2-devel@archiver.kernel.org; Tue, 19 Jul 2022 10:01:44 +0000 (GMT)
To: Mark Fasheh <mark@fasheh.com>, Joel Becker <jlbec@evilplan.org>,
 Joseph Qi <joseph.qi@linux.alibaba.com>
Date: Tue, 19 Jul 2022 12:01:23 +0200
Message-id:
 <bd6796635e58f9c47cf857573c3b9474a00ce26a.1658224839.git.christophe.jaillet@wanadoo.fr>
X-Mailer: git-send-email 2.34.1
MIME-version: 1.0
X-Source-IP: 80.12.242.123
X-Proofpoint-Virus-Version: vendor=nai engine=6400 definitions=10412
 signatures=596000
X-Proofpoint-Spam-Details: rule=tap_notspam policy=tap score=0
 lowpriorityscore=0 phishscore=0 suspectscore=0 clxscore=-17 spamscore=0
 malwarescore=0 mlxscore=0 priorityscore=1501 mlxlogscore=912 adultscore=0
 bulkscore=0 impostorscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2206140000 definitions=main-2207190042
Cc: Christophe JAILLET <christophe.jaillet@wanadoo.fr>,
 kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org,
 ocfs2-devel@oss.oracle.com
Subject: [Ocfs2-devel] [PATCH 1/3] ocfs2: Remove some useless functions
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
X-ME-Date: Tue, 19 Jul 2022 12:01:30 +0200
X-ME-IP: 90.11.190.129
X-ServerName: smtp01.smtpout.orange.fr
X-Proofpoint-SPF-Result: pass
X-Proofpoint-SPF-Record: v=spf1 include:_spf_gp.wanadoo.fr
 include:spf.email-control.orange-business.com include:_spf_gpf.wanadoo.fr
 include:_spf_other.wanadoo.fr ?all
X-Spam: Clean
X-Proofpoint-GUID: rw1ebNm7UHt0gLBtvRuZl8h2Uk-OK8QF
X-Proofpoint-ORIG-GUID: rw1ebNm7UHt0gLBtvRuZl8h2Uk-OK8QF
Reporting-Meta:
 AAGxPZM9DhEFXfkZ7eLzKSIBac9lZlo6hp9ggdhG+uhysMRHJ3+so45jBC4Bn97h
 RHjCxvk00w98GfefB7z+4aWg5a8Sm5McFU5/KAXiWX4VpQdrd6uhoMgym9CcteyM
 g7pWEjdf6C2tAuQw0bgQC4Y8dFAn8QGTMIY0CfLpEP51ZJo4yx05G2WilFoK//1w
 znU//BAmryaVTslq+nvUyn3TK0XLxaw//bX1fyqyl7LtGl/4LWbJtGLX3hpOE+9S
 PMj6Y1l3mZ0VyFWDdCcvH94cJtfkQMQ7Yf3SHbZq7ksHXpLfXHM30Dx8vXDU4uhh
 35cerot5l/ADlmd9IHGFfBR0gEMOKohdLnNnKyzV3PK95u+B0Vxq3uyUO877QfPi
 NwocLduodOdVJC36xynXScEGNqeaIlC3P9tdRF4SnVJCMlSoKMAadltSXmSWI4ce
 4LaKW2vzVL/v/xyAaMboLppLW/NznQC9z6VJ1hQOHeC+8FWYG7tSm5EhAPD8tA6E
 sTnVzgbM9zEghtabOLCrLZ4X86XoGWp/w8850jHnY6V1

__ocfs2_node_map_set_bit() and __ocfs2_node_map_set_bit() are just
wrapper around set_bit() and clear_bit().

The leading __ also makes think that these functions are non-atomic just
like __set_bit() and __clear_bit().

So, just remove these wrappers and call set_bit() and clear_bit()
directly.

Signed-off-by: Christophe JAILLET <christophe.jaillet@wanadoo.fr>
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
