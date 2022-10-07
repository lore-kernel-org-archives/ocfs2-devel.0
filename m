Return-Path: <bounces+ocfs2-devel=archiver.kernel.org@phx1.rp.oracleemaildelivery.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from aib29ajc254.phx1.oracleemaildelivery.com (aib29ajc254.phx1.oracleemaildelivery.com [192.29.103.254])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 62BADC433FE
	for <ocfs2-devel@archiver.kernel.org>; Fri,  7 Oct 2022 12:49:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; s=oss-phx-1109;
 d=oss.oracle.com;
 h=Date:To:From:Subject:Message-Id:MIME-Version:Sender;
 bh=/xjAf5LvuDdaEAljC78kyfM3aZtzZHIv76KCcJH/j34=;
 b=meXnntILUCsQxZ95+QXDbD0YCYGJxdGEIpu46/Ibb36i9MvhFBdn7yLH7C4geksSY8ogVX3XViwD
   tAKzgLoJinQ9SH0onCDBv0fldSjELIWKh0lmh5nmEtxw3sH9R2mJfwrOTweDj44LXNiPlezKmFiM
   ZCLCnrKNGyKY7ypC1cmzfImItbbGPt7O1sglLYhZ90karVaGoBbb9vLhqHUbaekVHibJSXHpW6hh
   3hP8RwqxTfWy811dXF6biqGgiBqUR6GpmwHHSKg/LZlDNZkAEkAiyTVvETV/121NsvBOE2VZDP+F
   mK5aXy+ArMPdnGf3dXA6PWkAXzR5kxt0Thp2MA==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; s=prod-phx-20191217;
 d=phx1.rp.oracleemaildelivery.com;
 h=Date:To:From:Subject:Message-Id:MIME-Version:Sender;
 bh=/xjAf5LvuDdaEAljC78kyfM3aZtzZHIv76KCcJH/j34=;
 b=meLXQJ1IW8FRvLv9QK0c+5ko1cEJI4iNJih5L/Y4F/B2em+jIl4JMYOkeQbxWAni8ZuBxqK1SmS7
   Lp/gKCNWEwJYv2/w0dy1pfqGY9evRYLFr1uFWea8oTjqrV/chovFTNThHe8PrV3sAmr3LiXGMay2
   vIJWKGYbmHZ8hPg50acg+ap9eKHbwUDwLxQjAWIE8yHiyfiJqD9dfr8ei25xw8jevKbidZyMQl3E
   XGibA/jfOqJ7AaaahlR07+84hm35/aoXHiaWRNfnxQVbBEZI+CQuY5VE7bFKVM1ougRiPlPfMF1i
   N3OM9dlwOxqaCvh8zIHYiZEGxgxUjZvAfSQykw==
Received: by omta-ad3-fd3-301-us-phoenix-1.omtaad3.vcndpphx.oraclevcn.com
 (Oracle Communications Messaging Server 8.1.0.1.20220914 64bit (built Sep 14
 2022))
 with ESMTPS id <0RJD009M8VMSS0D0@omta-ad3-fd3-301-us-phoenix-1.omtaad3.vcndpphx.oraclevcn.com> for
 ocfs2-devel@archiver.kernel.org; Fri, 07 Oct 2022 12:49:40 +0000 (GMT)
To: ocfs2-devel@oss.oracle.com
Date: Fri,  7 Oct 2022 20:48:45 +0800
Message-id: <20221007124846.186453-2-joseph.qi@linux.alibaba.com>
X-Mailer: git-send-email 2.24.4
In-reply-to: <20221007124846.186453-1-joseph.qi@linux.alibaba.com>
References: <20221007124846.186453-1-joseph.qi@linux.alibaba.com>
MIME-version: 1.0
X-Source-IP: 115.124.30.43
X-Proofpoint-Virus-Version: vendor=nai engine=6500 definitions=10492
 signatures=596816
X-Proofpoint-Spam-Details: rule=tap_notspam policy=tap score=0 mlxlogscore=999
 impostorscore=0 malwarescore=0 suspectscore=0 mlxscore=0 clxscore=197
 phishscore=0 priorityscore=0 spamscore=0 lowpriorityscore=0 adultscore=0
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2209130000 definitions=main-2210070076 domainage_hfrom=8576
Subject: [Ocfs2-devel] [PATCH 2/3] ocfs2: use bitmap API in fill_node_map
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
X-Alimail-AntiSpam: AC=PASS; BC=-1|-1; BR=01201311R131e4; CH=green;
 DM=||false|; DS=||; FP=0|-1|-1|-1|0|-1|-1|-1; HT=ay29a033018045176;
 MF=joseph.qi@linux.alibaba.com; NM=1; PH=DS; RN=2; SR=0;
 TI=SMTPD_---0VRUAmF9_1665146928;
X-ServerName: out30-43.freemail.mail.aliyun.com
X-Proofpoint-SPF-Result: pass
X-Proofpoint-SPF-Record: v=spf1 include:spf1.service.alibaba.com
 include:spf2.service.alibaba.com include:spf1.ocm.aliyun.com
 include:spf2.ocm.aliyun.com include:spf1.staff.mail.aliyun.com
 include:a.hichina.mail.aliyun.com include:b.hichina.mail.aliyun.com -all
X-Spam: Clean
X-Proofpoint-GUID: OBzqEYfssV0M5Aq7NzeoDen5rowQPl8h
X-Proofpoint-ORIG-GUID: OBzqEYfssV0M5Aq7NzeoDen5rowQPl8h
Reporting-Meta:
 AAHD0N/HQaeefYi33kgKCwuU+qCbEuZw21pIpR0j4SokOwNKC2pLwnFbXl0q5YmW
 FiSuS5SdQq7pfhdJzYSFPyKKubxi8b5yTSH6qeTOxWJhUQ2NUkM0zSWY4gSDSq72
 dWud4QJte1GTku8enmbEH/6y+8v2tA1onThpSelHD/hsOaS2f449bIQtaXqvg03X
 KHKSOHOq25yKlO0iMunVRfma/iH/o/JxbkkqM/TzvYlvzd4kREunpJ3GcBD69VxI
 ixoqdeqGvQOi4HBGqoro37YiRkeEdWq2lIS9YpZJN7hgGtoD6W5+cA0jlWedmwKi
 ANhQokSmrMH4RQXRbWkrZLK9+P/F/jVjy/aMBR9jD87C0eWLI6yS3H93oSzHL5aT
 1NcXPyz22/MtajCKUev10DMLWxJ2e8AAQUgqcqBIpxhta5lDwoE3JoS0k6oi7I6t
 eZfrWNdsJxnScR8vtjKB7JmqcOMxAsUvmHFg46Hy1no2PhsD88blfvxw7eQFo82W
 ZpqVU6r12GXRHA/AG7f4men87V4woWg47gFMCPPKP6mCow==

Pass bits directly into fill_node_map helper and use bitmap API directly
to simplify code.

Signed-off-by: Joseph Qi <joseph.qi@linux.alibaba.com>
---
 fs/ocfs2/cluster/heartbeat.c | 18 ++++++++----------
 fs/ocfs2/cluster/heartbeat.h |  2 +-
 fs/ocfs2/cluster/netdebug.c  |  2 +-
 fs/ocfs2/cluster/tcp.c       |  6 ++----
 fs/ocfs2/dlm/dlmdomain.c     |  2 +-
 fs/ocfs2/stack_o2cb.c        |  6 +++---
 6 files changed, 16 insertions(+), 20 deletions(-)

diff --git a/fs/ocfs2/cluster/heartbeat.c b/fs/ocfs2/cluster/heartbeat.c
index 8fe6031f60e3..60b97c92e2b2 100644
--- a/fs/ocfs2/cluster/heartbeat.c
+++ b/fs/ocfs2/cluster/heartbeat.c
@@ -375,7 +375,7 @@ static void o2hb_nego_timeout(struct work_struct *work)
 	if (reg->hr_last_hb_status)
 		return;
 
-	o2hb_fill_node_map(live_node_bitmap, sizeof(live_node_bitmap));
+	o2hb_fill_node_map(live_node_bitmap, O2NM_MAX_NODES);
 	/* lowest node as master node to make negotiate decision. */
 	master_node = find_first_bit(live_node_bitmap, O2NM_MAX_NODES);
 
@@ -1087,7 +1087,7 @@ static int o2hb_do_disk_heartbeat(struct o2hb_region *reg)
 	 * If a node is not configured but is in the livemap, we still need
 	 * to read the slot so as to be able to remove it from the livemap.
 	 */
-	o2hb_fill_node_map(live_node_bitmap, sizeof(live_node_bitmap));
+	o2hb_fill_node_map(live_node_bitmap, O2NM_MAX_NODES);
 	i = -1;
 	while ((i = find_next_bit(live_node_bitmap,
 				  O2NM_MAX_NODES, i + 1)) < O2NM_MAX_NODES) {
@@ -1450,23 +1450,21 @@ void o2hb_init(void)
 
 /* if we're already in a callback then we're already serialized by the sem */
 static void o2hb_fill_node_map_from_callback(unsigned long *map,
-					     unsigned bytes)
+					     unsigned int bits)
 {
-	BUG_ON(bytes < (BITS_TO_LONGS(O2NM_MAX_NODES) * sizeof(unsigned long)));
-
-	memcpy(map, &o2hb_live_node_bitmap, bytes);
+	bitmap_copy(map, o2hb_live_node_bitmap, bits);
 }
 
 /*
  * get a map of all nodes that are heartbeating in any regions
  */
-void o2hb_fill_node_map(unsigned long *map, unsigned bytes)
+void o2hb_fill_node_map(unsigned long *map, unsigned int bits)
 {
 	/* callers want to serialize this map and callbacks so that they
 	 * can trust that they don't miss nodes coming to the party */
 	down_read(&o2hb_callback_sem);
 	spin_lock(&o2hb_live_lock);
-	o2hb_fill_node_map_from_callback(map, bytes);
+	o2hb_fill_node_map_from_callback(map, bits);
 	spin_unlock(&o2hb_live_lock);
 	up_read(&o2hb_callback_sem);
 }
@@ -2460,7 +2458,7 @@ int o2hb_check_node_heartbeating_no_sem(u8 node_num)
 	unsigned long testing_map[BITS_TO_LONGS(O2NM_MAX_NODES)];
 
 	spin_lock(&o2hb_live_lock);
-	o2hb_fill_node_map_from_callback(testing_map, sizeof(testing_map));
+	o2hb_fill_node_map_from_callback(testing_map, O2NM_MAX_NODES);
 	spin_unlock(&o2hb_live_lock);
 	if (!test_bit(node_num, testing_map)) {
 		mlog(ML_HEARTBEAT,
@@ -2477,7 +2475,7 @@ int o2hb_check_node_heartbeating_from_callback(u8 node_num)
 {
 	unsigned long testing_map[BITS_TO_LONGS(O2NM_MAX_NODES)];
 
-	o2hb_fill_node_map_from_callback(testing_map, sizeof(testing_map));
+	o2hb_fill_node_map_from_callback(testing_map, O2NM_MAX_NODES);
 	if (!test_bit(node_num, testing_map)) {
 		mlog(ML_HEARTBEAT,
 		     "node (%u) does not have heartbeating enabled.\n",
diff --git a/fs/ocfs2/cluster/heartbeat.h b/fs/ocfs2/cluster/heartbeat.h
index 1d4100abf6f8..8ef8c1b9eeb7 100644
--- a/fs/ocfs2/cluster/heartbeat.h
+++ b/fs/ocfs2/cluster/heartbeat.h
@@ -59,7 +59,7 @@ int o2hb_register_callback(const char *region_uuid,
 void o2hb_unregister_callback(const char *region_uuid,
 			      struct o2hb_callback_func *hc);
 void o2hb_fill_node_map(unsigned long *map,
-			unsigned bytes);
+			unsigned int bits);
 void o2hb_exit(void);
 void o2hb_init(void);
 int o2hb_check_node_heartbeating_no_sem(u8 node_num);
diff --git a/fs/ocfs2/cluster/netdebug.c b/fs/ocfs2/cluster/netdebug.c
index 7524994e3199..35c05c18de59 100644
--- a/fs/ocfs2/cluster/netdebug.c
+++ b/fs/ocfs2/cluster/netdebug.c
@@ -438,7 +438,7 @@ static int o2net_fill_bitmap(char *buf, int len)
 	unsigned long map[BITS_TO_LONGS(O2NM_MAX_NODES)];
 	int i = -1, out = 0;
 
-	o2net_fill_node_map(map, sizeof(map));
+	o2net_fill_node_map(map, O2NM_MAX_NODES);
 
 	while ((i = find_next_bit(map, O2NM_MAX_NODES, i + 1)) < O2NM_MAX_NODES)
 		out += scnprintf(buf + out, PAGE_SIZE - out, "%d ", i);
diff --git a/fs/ocfs2/cluster/tcp.c b/fs/ocfs2/cluster/tcp.c
index f660c0dbdb63..6f5a3fb97c7f 100644
--- a/fs/ocfs2/cluster/tcp.c
+++ b/fs/ocfs2/cluster/tcp.c
@@ -990,14 +990,12 @@ static int o2net_tx_can_proceed(struct o2net_node *nn,
 }
 
 /* Get a map of all nodes to which this node is currently connected to */
-void o2net_fill_node_map(unsigned long *map, unsigned bytes)
+void o2net_fill_node_map(unsigned long *map, unsigned int bits)
 {
 	struct o2net_sock_container *sc;
 	int node, ret;
 
-	BUG_ON(bytes < (BITS_TO_LONGS(O2NM_MAX_NODES) * sizeof(unsigned long)));
-
-	memset(map, 0, bytes);
+	bitmap_zero(map, bits);
 	for (node = 0; node < O2NM_MAX_NODES; ++node) {
 		if (!o2net_tx_can_proceed(o2net_nn_from_num(node), &sc, &ret))
 			continue;
diff --git a/fs/ocfs2/dlm/dlmdomain.c b/fs/ocfs2/dlm/dlmdomain.c
index c4eccd499db8..f46941ff665d 100644
--- a/fs/ocfs2/dlm/dlmdomain.c
+++ b/fs/ocfs2/dlm/dlmdomain.c
@@ -1604,7 +1604,7 @@ static int dlm_try_to_join_domain(struct dlm_ctxt *dlm)
 	/* group sem locking should work for us here -- we're already
 	 * registered for heartbeat events so filling this should be
 	 * atomic wrt getting those handlers called. */
-	o2hb_fill_node_map(dlm->live_nodes_map, sizeof(dlm->live_nodes_map));
+	o2hb_fill_node_map(dlm->live_nodes_map, O2NM_MAX_NODES);
 
 	spin_lock(&dlm->spinlock);
 	memcpy(ctxt->live_map, dlm->live_nodes_map, sizeof(ctxt->live_map));
diff --git a/fs/ocfs2/stack_o2cb.c b/fs/ocfs2/stack_o2cb.c
index 88f75f7f02d7..c973c03f6fd8 100644
--- a/fs/ocfs2/stack_o2cb.c
+++ b/fs/ocfs2/stack_o2cb.c
@@ -273,17 +273,17 @@ static int o2cb_cluster_check(void)
 	 */
 #define	O2CB_MAP_STABILIZE_COUNT	60
 	for (i = 0; i < O2CB_MAP_STABILIZE_COUNT; ++i) {
-		o2hb_fill_node_map(hbmap, sizeof(hbmap));
+		o2hb_fill_node_map(hbmap, O2NM_MAX_NODES);
 		if (!test_bit(node_num, hbmap)) {
 			printk(KERN_ERR "o2cb: %s heartbeat has not been "
 			       "started.\n", (o2hb_global_heartbeat_active() ?
 					      "Global" : "Local"));
 			return -EINVAL;
 		}
-		o2net_fill_node_map(netmap, sizeof(netmap));
+		o2net_fill_node_map(netmap, O2NM_MAX_NODES);
 		/* Force set the current node to allow easy compare */
 		set_bit(node_num, netmap);
-		if (!memcmp(hbmap, netmap, sizeof(hbmap)))
+		if (bitmap_equal(hbmap, netmap, O2NM_MAX_NODES))
 			return 0;
 		if (i < O2CB_MAP_STABILIZE_COUNT - 1)
 			msleep(1000);
-- 
2.24.4


_______________________________________________
Ocfs2-devel mailing list
Ocfs2-devel@oss.oracle.com
https://oss.oracle.com/mailman/listinfo/ocfs2-devel
