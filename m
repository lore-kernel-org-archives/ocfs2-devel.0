Return-Path: <bounces+ocfs2-devel=archiver.kernel.org@phx1.rp.oracleemaildelivery.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from aib29ajc247.phx1.oracleemaildelivery.com (aib29ajc247.phx1.oracleemaildelivery.com [192.29.103.247])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 96DC5C43334
	for <ocfs2-devel@archiver.kernel.org>; Tue, 19 Jul 2022 10:02:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; s=oss-phx-1109;
 d=oss.oracle.com;
 h=Date:To:From:Subject:Message-Id:MIME-Version:Sender;
 bh=VVu3kpPKsbQX49bv9q72UuOqrQ4J3QIPEsQHxc9amZ4=;
 b=FDI4ZO1kSoabEFsl6bsvHVGegH4V8PSUO3rLwZ9n1NgCHQTnBT+/jz+WFbFfjxXtbxpIqKRSFRYa
   ww0MulWrN/bgz6vZOWAFA5FDdxvqajWLDuX7CxccITJpd07NAxg5Znwcax1K6PNcHYPtFk6TA9Ec
   JUAgYvYD1TbqSDvH/DaisTbIK4WwGotatZ9iAlh9pT+NipC+keTLGCZXDyyxjTAw/CZ63NmIQsZ9
   z9VBIwv3cZHL6h6F+Zr7Ddvuc5iC+E9OQmt3/HhP1AdXz04oGh78sTGRGqy6CduSCPn06Qgd/iox
   Y0rRHEFPTbwfcV33qQH0DOJqaMCvJhNPbT2uVw==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; s=prod-phx-20191217;
 d=phx1.rp.oracleemaildelivery.com;
 h=Date:To:From:Subject:Message-Id:MIME-Version:Sender;
 bh=VVu3kpPKsbQX49bv9q72UuOqrQ4J3QIPEsQHxc9amZ4=;
 b=qdYWYJpat34r5NwI4Kd4RizHjzCLvG1hWM24ITpB4M7VUgcqC1X3RoziXl7VmkP89+V7fs7IfjeM
   9Z/jNo69EKbOq5AS/D3XT4frDb1sU2ndyMyzCe2E96bmzHCngXwiDzMbH2BHk01L5IvQlQeu2A7B
   fKKmPIn85Sze4qkUHonsREj+3oqlwhsI78Uc1uN3K8I9QaXucYolPHmVTIoYNtsyYaTYXYqPASNA
   cD0hjYEad7B1ca+qs4nOryHpDdhvZR2cnKMgQ3xwSlDGTR5fb4CxLpr9fOkC4zJaGjvusSN8fwj3
   DzipEtBlhKkck3MAD9GpEN+qm1TpzqEaD1J+Rw==
Received: by omta-ad1-fd3-102-us-phoenix-1.omtaad1.vcndpphx.oraclevcn.com
 (Oracle Communications Messaging Server 8.1.0.1.20220603 64bit (built Jun  3
 2022))
 with ESMTPS id <0RF900ALMIJCGUC0@omta-ad1-fd3-102-us-phoenix-1.omtaad1.vcndpphx.oraclevcn.com> for
 ocfs2-devel@archiver.kernel.org; Tue, 19 Jul 2022 10:02:00 +0000 (GMT)
To: Mark Fasheh <mark@fasheh.com>, Joel Becker <jlbec@evilplan.org>,
 Joseph Qi <joseph.qi@linux.alibaba.com>
Date: Tue, 19 Jul 2022 12:01:35 +0200
Message-id:
 <8ba7004d330cbe5f626539a8a3bff696d0c4285e.1658224839.git.christophe.jaillet@wanadoo.fr>
X-Mailer: git-send-email 2.34.1
In-reply-to:
 <bd6796635e58f9c47cf857573c3b9474a00ce26a.1658224839.git.christophe.jaillet@wanadoo.fr>
References:
 <bd6796635e58f9c47cf857573c3b9474a00ce26a.1658224839.git.christophe.jaillet@wanadoo.fr>
MIME-version: 1.0
X-Source-IP: 80.12.242.127
X-Proofpoint-Virus-Version: vendor=nai engine=6400 definitions=10412
 signatures=596000
X-Proofpoint-Spam-Details: rule=tap_notspam policy=tap score=0 suspectscore=0
 clxscore=67 priorityscore=130 adultscore=0 spamscore=0 mlxscore=0 phishscore=0
 bulkscore=0 impostorscore=0 mlxlogscore=999 malwarescore=0 lowpriorityscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2206140000
 definitions=main-2207190042
Cc: Christophe JAILLET <christophe.jaillet@wanadoo.fr>,
 kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org,
 ocfs2-devel@oss.oracle.com
Subject: [Ocfs2-devel] [PATCH 2/3] ocfs2: Remove a useless spinlock
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
X-ME-Date: Tue, 19 Jul 2022 12:01:41 +0200
X-ME-IP: 90.11.190.129
X-ServerName: smtp05.smtpout.orange.fr
X-Proofpoint-SPF-Result: pass
X-Proofpoint-SPF-Record: v=spf1 include:_spf_gp.wanadoo.fr
 include:spf.email-control.orange-business.com include:_spf_gpf.wanadoo.fr
 include:_spf_other.wanadoo.fr ?all
X-Spam: Clean
X-Proofpoint-GUID: yZ5LdisZ9t0vESCbcm8fd9wsv5Sd1vhr
X-Proofpoint-ORIG-GUID: yZ5LdisZ9t0vESCbcm8fd9wsv5Sd1vhr
Reporting-Meta:
 AAGewpPhsvrLEyvnaBUgbmOl6tnu1RDbRmy8von/JC/yZwwFPi9zDnbMr5mneUqS
 9ggpN5at9DFxIJpy/qPsNE2ds3T6Q1w5xCnlWQE8vZxrbRYVUcOCgaACEGT5ZD+N
 MEqaSKc1RdydTCGtf1Q76y+EY6VKeN74mcXsmJ9J54igb3OP+ig++6xFcY/CdaA8
 A6L/ZJWWsCPVWsqK2NjTMjOOyBAaz8H17VolkpnBWnIdQBoWnSfHgy/3yw37PV4b
 SE8ykq0x0y/c0vzzkKZN71pw1WqBvTJx6dYc0o8zShItbyNs0yl+Vj+hQJx/E2f5
 gxNKtrkGKK6hQhMklznfJR6cfey+9z3RHsNI2ihOVWlHzbO85HY2WvR6wbFJMe7j
 IW5MIy0vuGm688gRfdA9HUTJaxING+3myU3dSw1cYJbjxjGJuUlcsTcssmiF11SH
 ePyv3bXNuc0Je6giqxu3QmzoKRgYSyzryiddffA6bYH6pP/biKcYKS0VRYdPdXc2
 23npu2w6fi9RP7ENWHiwNRhk0C1EbK+olyCVRFgOr5l9

'node_map_lock' is a spinlock only used to protect calls to set_bit(),
clear_bit() and test_bit().

{set|clear}_bit() are already atomic and don't need this extra spinlock.
test_bit() only reads the bitmap for a given bit.

Remove this useless spinlock.

Signed-off-by: Christophe JAILLET <christophe.jaillet@wanadoo.fr>
---
test_bit() is NOT documented as an atomic function. However, I can't see
how it could return a wrong result here.

So review with care. There is maybe something I don't think about that is
lurking here.
---
 fs/ocfs2/heartbeat.c | 11 ++++-------
 fs/ocfs2/ocfs2.h     |  2 --
 2 files changed, 4 insertions(+), 9 deletions(-)

diff --git a/fs/ocfs2/heartbeat.c b/fs/ocfs2/heartbeat.c
index 1d72e0788943..4863ad35c242 100644
--- a/fs/ocfs2/heartbeat.c
+++ b/fs/ocfs2/heartbeat.c
@@ -35,7 +35,6 @@ static void ocfs2_node_map_init(struct ocfs2_node_map *map)
 
 void ocfs2_init_node_maps(struct ocfs2_super *osb)
 {
-	spin_lock_init(&osb->node_map_lock);
 	ocfs2_node_map_init(&osb->osb_recovering_orphan_dirs);
 }
 
@@ -67,9 +66,8 @@ void ocfs2_node_map_set_bit(struct ocfs2_super *osb,
 	if (bit==-1)
 		return;
 	BUG_ON(bit >= map->num_nodes);
-	spin_lock(&osb->node_map_lock);
+
 	set_bit(bit, map->map);
-	spin_unlock(&osb->node_map_lock);
 }
 
 void ocfs2_node_map_clear_bit(struct ocfs2_super *osb,
@@ -79,9 +77,8 @@ void ocfs2_node_map_clear_bit(struct ocfs2_super *osb,
 	if (bit==-1)
 		return;
 	BUG_ON(bit >= map->num_nodes);
-	spin_lock(&osb->node_map_lock);
+
 	clear_bit(bit, map->map);
-	spin_unlock(&osb->node_map_lock);
 }
 
 int ocfs2_node_map_test_bit(struct ocfs2_super *osb,
@@ -89,13 +86,13 @@ int ocfs2_node_map_test_bit(struct ocfs2_super *osb,
 			    int bit)
 {
 	int ret;
+
 	if (bit >= map->num_nodes) {
 		mlog(ML_ERROR, "bit=%d map->num_nodes=%d\n", bit, map->num_nodes);
 		BUG();
 	}
-	spin_lock(&osb->node_map_lock);
+
 	ret = test_bit(bit, map->map);
-	spin_unlock(&osb->node_map_lock);
 	return ret;
 }
 
diff --git a/fs/ocfs2/ocfs2.h b/fs/ocfs2/ocfs2.h
index 740b64238312..1df193b97c30 100644
--- a/fs/ocfs2/ocfs2.h
+++ b/fs/ocfs2/ocfs2.h
@@ -302,8 +302,6 @@ struct ocfs2_super
 
 	u32 *slot_recovery_generations;
 
-	spinlock_t node_map_lock;
-
 	u64 root_blkno;
 	u64 system_dir_blkno;
 	u64 bitmap_blkno;
-- 
2.34.1


_______________________________________________
Ocfs2-devel mailing list
Ocfs2-devel@oss.oracle.com
https://oss.oracle.com/mailman/listinfo/ocfs2-devel
