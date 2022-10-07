Return-Path: <bounces+ocfs2-devel=archiver.kernel.org@phx1.rp.oracleemaildelivery.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from aib29ajc251.phx1.oracleemaildelivery.com (aib29ajc251.phx1.oracleemaildelivery.com [192.29.103.251])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 477D1C433F5
	for <ocfs2-devel@archiver.kernel.org>; Fri,  7 Oct 2022 12:49:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; s=oss-phx-1109;
 d=oss.oracle.com;
 h=Date:To:From:Subject:Message-Id:MIME-Version:Sender;
 bh=bSiUE7PfnYYITexc1reF3QI0wqDNYYJ0AAZDTTLwQUs=;
 b=Vz+2NB0M67w3L9sxo8z/KT4kTDnExjRnKcq0Qd7VPQQkcyYGAk7idE0wb5pTGWIWtnG36tEkRlg5
   g12+Qco8OKuuMM9b12z8Nm7ZbRQJEchqC8+z4ghI0q7kBFNeCKB6+HEPbuHtqnvD2y1SG2U/jygk
   dIjVHNCW7CnKwAbmDDJQ4NEK0ZcTaZWDtaKRUvO5OzodDOIU1YtIh/wF4XLTPmZYaTOpV+ar0bhG
   syDatsfTfNbfMzcv4i99uasDcIE0u3upFoVM2b94lnWh/h68M6714JZVi5tHHxIX2+KF1OeuzO3M
   1hfLQp/xJ8hpd7CP1O47jbcBQ7feh3HVQpy/ZA==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; s=prod-phx-20191217;
 d=phx1.rp.oracleemaildelivery.com;
 h=Date:To:From:Subject:Message-Id:MIME-Version:Sender;
 bh=bSiUE7PfnYYITexc1reF3QI0wqDNYYJ0AAZDTTLwQUs=;
 b=hnRTlVyPi8I3lPx8ff92gvqiJF0cZp0MDYC9bzO8/iP1jL5BySZniU20Uz/8VbOeWz98QbH+VA0D
   z5QvOPBV+bXeBVwV1l+P1AHwg9NDzkaDVdU3MItLxmnkISLrhm9ZvbH6Wnf6zZwuDkbXR4JYdZCP
   M7+RwAgndDoR826iAwZ9pwltexpJxNxfF5ZtQsJDaDylYELUFEegq5TBt34i7zqPYXZtl3KTTfiI
   GLbmB0K4KYIicMyOWtANN1KencrTJq/5X7H0KdsO8CM2ir+yCohufsMCp2akOkcoZPQoCR9zWGmB
   ZyohX23WKgtqWoOM6Uvjor5Y8QFs5kZ9IUebNw==
Received: by omta-ad2-fd3-202-us-phoenix-1.omtaad2.vcndpphx.oraclevcn.com
 (Oracle Communications Messaging Server 8.1.0.1.20220914 64bit (built Sep 14
 2022))
 with ESMTPS id <0RJD008J9VLTD770@omta-ad2-fd3-202-us-phoenix-1.omtaad2.vcndpphx.oraclevcn.com> for
 ocfs2-devel@archiver.kernel.org; Fri, 07 Oct 2022 12:49:05 +0000 (GMT)
To: ocfs2-devel@oss.oracle.com
Date: Fri,  7 Oct 2022 20:48:44 +0800
Message-id: <20221007124846.186453-1-joseph.qi@linux.alibaba.com>
X-Mailer: git-send-email 2.24.4
MIME-version: 1.0
X-Source-IP: 115.124.30.57
X-Proofpoint-Virus-Version: vendor=nai engine=6500 definitions=10492
 signatures=596816
X-Proofpoint-Spam-Details: rule=tap_notspam policy=tap score=0 adultscore=0
 impostorscore=0 phishscore=0 suspectscore=0 malwarescore=0 clxscore=82
 mlxlogscore=999 mlxscore=0 priorityscore=0 spamscore=0 bulkscore=0
 lowpriorityscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2209130000 definitions=main-2210070076 domainage_hfrom=8576
Subject: [Ocfs2-devel] [PATCH 1/3] ocfs2/cluster: use bitmap API instead of
	hand-writing it
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
From: Joseph Qi via Ocfs2-devel <ocfs2-devel@oss.oracle.com>
Reply-to: Joseph Qi <joseph.qi@linux.alibaba.com>
Content-type: text/plain; charset="us-ascii"
Content-transfer-encoding: 7bit
Errors-to: ocfs2-devel-bounces@oss.oracle.com
X-Alimail-AntiSpam: AC=PASS; BC=-1|-1; BR=01201311R501e4; CH=green;
 DM=||false|; DS=||; FP=0|-1|-1|-1|0|-1|-1|-1; HT=ay29a033018046051;
 MF=joseph.qi@linux.alibaba.com; NM=1; PH=DS; RN=2; SR=0;
 TI=SMTPD_---0VRUAmEQ_1665146926;
X-ServerName: out30-57.freemail.mail.aliyun.com
X-Proofpoint-SPF-Result: pass
X-Proofpoint-SPF-Record: v=spf1 include:spf1.service.alibaba.com
 include:spf2.service.alibaba.com include:spf1.ocm.aliyun.com
 include:spf2.ocm.aliyun.com include:spf1.staff.mail.aliyun.com
 include:a.hichina.mail.aliyun.com include:b.hichina.mail.aliyun.com -all
X-Spam: Clean
X-Proofpoint-GUID: QMyBptIG9WK-doRFUMn_8TMI2V9n6M37
X-Proofpoint-ORIG-GUID: QMyBptIG9WK-doRFUMn_8TMI2V9n6M37
Reporting-Meta:
 AAF43HHTOW51WquGRJJJmw08DrJvt1I+FT/W5EI7EGe1DMT0CzQHoQ+/zLVTCDBn
 EwemfYEYqmemPbeR6igtwtjsrVZWE7X8Ap88qrZkhQxjD6jHcBOx0kdCw+NmjRH1
 TltMzlV+l2amXcVkrS5yVcHiY7ij2VRI7kDmsD7vrKczGf/gp1Q/c6s6K4hHTIRj
 mVUF0MJVSijm9A5HjZAvZ9CQcY2rwshPMKLOTDH0N/XIHpRDmv/NCda+JgPihOC3
 bVvOLc4RGLUqzLoAlENopIsmlyQMId2aDjk2KyVFwsFZVgz7sUAQ5voLj8lMmTxC
 jnU07OoybNbr6mDz9DLnVNjCHXzt+zbPpgBIE0uW7XpEpI8ll2q4LYB37OVYIGbm
 O9fMpigJjbOBVuTNZ5k2vgUQ/DieegEYwcX/pwIyvgKhwXmwH1m1aqWEn8XkzR6k
 aCbR34ZErLcFq0K/8P+pa8yO6CmHVsy3YNkn9JDaZlECDGL9BuGCONSZdThWc+o1
 WoZCgA9kuZjaC/m3MwypsjNMmhLM1oZW5k263QhkA7D0

Use bitmap_zero/bitmap_copy/bitmap_equal directly for bitmap operations.

Signed-off-by: Joseph Qi <joseph.qi@linux.alibaba.com>
---
 fs/ocfs2/cluster/heartbeat.c   | 20 ++++++++++----------
 fs/ocfs2/cluster/nodemanager.c |  2 +-
 2 files changed, 11 insertions(+), 11 deletions(-)

diff --git a/fs/ocfs2/cluster/heartbeat.c b/fs/ocfs2/cluster/heartbeat.c
index b13d344d40b6..8fe6031f60e3 100644
--- a/fs/ocfs2/cluster/heartbeat.c
+++ b/fs/ocfs2/cluster/heartbeat.c
@@ -335,7 +335,7 @@ static void o2hb_arm_timeout(struct o2hb_region *reg)
 	/* negotiate timeout must be less than write timeout. */
 	schedule_delayed_work(&reg->hr_nego_timeout_work,
 			      msecs_to_jiffies(O2HB_NEGO_TIMEOUT_MS));
-	memset(reg->hr_nego_node_bitmap, 0, sizeof(reg->hr_nego_node_bitmap));
+	bitmap_zero(reg->hr_nego_node_bitmap, O2NM_MAX_NODES);
 }
 
 static void o2hb_disarm_timeout(struct o2hb_region *reg)
@@ -386,8 +386,8 @@ static void o2hb_nego_timeout(struct work_struct *work)
 				config_item_name(&reg->hr_item), reg->hr_bdev);
 			set_bit(master_node, reg->hr_nego_node_bitmap);
 		}
-		if (memcmp(reg->hr_nego_node_bitmap, live_node_bitmap,
-				sizeof(reg->hr_nego_node_bitmap))) {
+		if (!bitmap_equal(reg->hr_nego_node_bitmap, live_node_bitmap,
+				  O2NM_MAX_NODES)) {
 			/* check negotiate bitmap every second to do timeout
 			 * approve decision.
 			 */
@@ -856,8 +856,8 @@ static void o2hb_set_quorum_device(struct o2hb_region *reg)
 	 * live nodes heartbeat on it. In other words, the region has been
 	 * added to all nodes.
 	 */
-	if (memcmp(reg->hr_live_node_bitmap, o2hb_live_node_bitmap,
-		   sizeof(o2hb_live_node_bitmap)))
+	if (!bitmap_equal(reg->hr_live_node_bitmap, o2hb_live_node_bitmap,
+			  O2NM_MAX_NODES))
 		goto unlock;
 
 	printk(KERN_NOTICE "o2hb: Region %s (%pg) is now a quorum device\n",
@@ -1437,11 +1437,11 @@ void o2hb_init(void)
 	for (i = 0; i < ARRAY_SIZE(o2hb_live_slots); i++)
 		INIT_LIST_HEAD(&o2hb_live_slots[i]);
 
-	memset(o2hb_live_node_bitmap, 0, sizeof(o2hb_live_node_bitmap));
-	memset(o2hb_region_bitmap, 0, sizeof(o2hb_region_bitmap));
-	memset(o2hb_live_region_bitmap, 0, sizeof(o2hb_live_region_bitmap));
-	memset(o2hb_quorum_region_bitmap, 0, sizeof(o2hb_quorum_region_bitmap));
-	memset(o2hb_failed_region_bitmap, 0, sizeof(o2hb_failed_region_bitmap));
+	bitmap_zero(o2hb_live_node_bitmap, O2NM_MAX_NODES);
+	bitmap_zero(o2hb_region_bitmap, O2NM_MAX_REGIONS);
+	bitmap_zero(o2hb_live_region_bitmap, O2NM_MAX_REGIONS);
+	bitmap_zero(o2hb_quorum_region_bitmap, O2NM_MAX_REGIONS);
+	bitmap_zero(o2hb_failed_region_bitmap, O2NM_MAX_REGIONS);
 
 	o2hb_dependent_users = 0;
 
diff --git a/fs/ocfs2/cluster/nodemanager.c b/fs/ocfs2/cluster/nodemanager.c
index 27fee68f860a..2f61d39e4e50 100644
--- a/fs/ocfs2/cluster/nodemanager.c
+++ b/fs/ocfs2/cluster/nodemanager.c
@@ -54,7 +54,7 @@ int o2nm_configured_node_map(unsigned long *map, unsigned bytes)
 		return -EINVAL;
 
 	read_lock(&cluster->cl_nodes_lock);
-	memcpy(map, cluster->cl_nodes_bitmap, sizeof(cluster->cl_nodes_bitmap));
+	bitmap_copy(map, cluster->cl_nodes_bitmap, O2NM_MAX_NODES);
 	read_unlock(&cluster->cl_nodes_lock);
 
 	return 0;
-- 
2.24.4


_______________________________________________
Ocfs2-devel mailing list
Ocfs2-devel@oss.oracle.com
https://oss.oracle.com/mailman/listinfo/ocfs2-devel
