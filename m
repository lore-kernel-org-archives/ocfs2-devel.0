Return-Path: <bounces+ocfs2-devel=archiver.kernel.org@phx1.rp.oracleemaildelivery.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from aib29ajc245.phx1.oracleemaildelivery.com (aib29ajc245.phx1.oracleemaildelivery.com [192.29.103.245])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E8025C43334
	for <ocfs2-devel@archiver.kernel.org>; Thu, 14 Jul 2022 15:05:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; s=oss-phx-1109;
 d=oss.oracle.com;
 h=Date:To:From:Subject:Message-Id:MIME-Version:Sender;
 bh=uBl+at6Iy6imQ/bIkslkb5t8pkjvCAZJJA5NtfwN2d0=;
 b=nJ4y+OS6aFT2/Q+h88Hww4VR78ivIlMzFaVN5mpgrrLxSl1urUA6kAU860ExzUpTTyTkAR6R0cf8
   J46e6glhzIijXYt0N3qmg4wt1upy0/bNTWb0T0WJ8z7xYvrJQ4ZsSjg01Ks1m3h+JUxDui7ftUe8
   PFIUwdSwkn+qCDoH9VEK9/04oL0MrF1Oa24wmXvJ2AbRp1AkbYbxoiL9eyA3T86iPVE0dA3haIG0
   MdZbmbGKU6bL2TOZQfvL1Pa/HsTPJU+APdtRnogvSXroIStUIj5w/dGsbiLBjshSHPC688LSzO4W
   MNxGjmuYcZ0YEV8bX6kL8FHvkdhI2VxCFUkUOQ==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; s=prod-phx-20191217;
 d=phx1.rp.oracleemaildelivery.com;
 h=Date:To:From:Subject:Message-Id:MIME-Version:Sender;
 bh=uBl+at6Iy6imQ/bIkslkb5t8pkjvCAZJJA5NtfwN2d0=;
 b=G1A89VJRmyGYLl1Z1P+q54r/8/jKJz5uqBbfWDvi4lTNs29Dvox9Z1YK9FCsCnM/fcOh3LA6/Lmp
   ztcwCtdfuxUJ1glyiQwxmSVBnWxZHXRvRXtn8hFUzpjd/sBT/RryE3MOWFiEeCe90Qmd7i5E8RjS
   VgP2nyz5aNq5j378YSKqi37vxVjc26oMzt9XpW8lUHhEC4bCgEAlocOt+KR+RAyMNn1U8nZRY7L9
   ROPg4qMkcMM+g2Ohbm5V/Ri4iPcGA4G/9ct2IWF5aRfVP0HpihGlyM9kGC14IPMARwhfOGTCm4bh
   n2uHUhJLiHdKdQy7x5GIXkoIzNWOqMRLopeDOg==
Received: by omta-ad1-fd1-102-us-phoenix-1.omtaad1.vcndpphx.oraclevcn.com
 (Oracle Communications Messaging Server 8.1.0.1.20220603 64bit (built Jun  3
 2022))
 with ESMTPS id <0RF0002GIN9CFD00@omta-ad1-fd1-102-us-phoenix-1.omtaad1.vcndpphx.oraclevcn.com> for
 ocfs2-devel@archiver.kernel.org; Thu, 14 Jul 2022 15:05:36 +0000 (GMT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
 d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
 MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender
 :Reply-To:Content-Type:Content-ID:Content-Description;
 bh=Y3KJzRLrphaTDn8Wyop5u8huGV0HUKZAMu6CEtRR/Bk=; b=PEJVBI4x3qa0TuZ6BDxyNedRsC
 21lm58vzmdgB11esQizXAAiCWwrQFxyGkvNn7RMx/SkFDycJThb61cyZxAaAUGEDdojB4NaeNFknZ
 wtAhFYALKJ0dT0eAP3uu1+rPEDqqlcqanSiIilvM3eKi/enitEbOctOt05sWF3OrHoeWFiBBdk1Fp
 oodg1CyjzRY4AARCUaUliopVIt92TUDazeCdMCVgb7x79v0CcqnvoSTIMY1EyAnno/g3PUGExqWRg
 /AMS9ASCbiyBP8suooRN9mDl3MAHsl+BJZv1Zk09a9FJut6uwN2h9Ia1mrOYimv4J9imOrEocUUAT
 qXE9OFRA==;
To: Jens Axboe <axboe@kernel.dk>
Date: Wed, 13 Jul 2022 07:53:15 +0200
Message-id: <20220713055317.1888500-8-hch@lst.de>
X-Mailer: git-send-email 2.30.2
In-reply-to: <20220713055317.1888500-1-hch@lst.de>
References: <20220713055317.1888500-1-hch@lst.de>
MIME-version: 1.0
X-Source-IP: 198.137.202.133
X-Proofpoint-Virus-Version: vendor=nai engine=6400 definitions=10406
 signatures=596000
X-Proofpoint-Spam-Details: rule=tap_notspam policy=tap score=0 bulkscore=0
 suspectscore=0 mlxscore=0 lowpriorityscore=0 adultscore=0 phishscore=0
 impostorscore=0 priorityscore=0 mlxlogscore=999 malwarescore=0 clxscore=256
 spamscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2206140000 definitions=main-2207130024
Cc: linux-block@vger.kernel.org, Theodore Ts'o <tytso@mit.edu>,
 Song Liu <song@kernel.org>, linux-raid@vger.kernel.org,
 =?UTF-8?q?Christoph=20B=C3=B6hmwalder?= <christoph.boehmwalder@linbit.com>,
 Andreas Dilger <adilger.kernel@dilger.ca>, Jan Kara <jack@suse.com>,
 "Md. Haris Iqbal" <haris.iqbal@ionos.com>, linux-ext4@vger.kernel.org,
 Jack Wang <jinpu.wang@ionos.com>, ocfs2-devel@oss.oracle.com,
 drbd-dev@lists.linbit.com
Subject: [Ocfs2-devel] [PATCH 7/9] ocfs2/cluster: remove the hr_dev_name	field
 from struct o2hb_region
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
From: Christoph Hellwig via Ocfs2-devel <ocfs2-devel@oss.oracle.com>
Reply-to: Christoph Hellwig <hch@lst.de>
Content-type: text/plain; charset="us-ascii"
Content-transfer-encoding: 7bit
Errors-to: ocfs2-devel-bounces@oss.oracle.com
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by
 bombadil.infradead.org. See http://www.infradead.org/rpr.html
X-ServerName: bombadil.infradead.org
X-Proofpoint-SPF-Result: None
X-Spam: Clean
X-Proofpoint-GUID: wRuLVdy8Vu8vI11ymhLFQiUz97us-aD7
X-Proofpoint-ORIG-GUID: wRuLVdy8Vu8vI11ymhLFQiUz97us-aD7
Reporting-Meta:
 AAF96d7FwqOPfU3peRtF44vD08EBpGCd2y6P2/YjbqRctvsyrnoOk7bXx/jcr7+8
 VqGCNPslBIj6Yn5FEYnl+irfn7av9eISjl1bLhpiaqd2tAmCFMq16a2UbF0tYg31
 zrxgOKreO+VxlU3+ZbMmHUvkKhRwysXpVCkejjzJtaZkJSQlj9K9OuJz9x6mBvtb
 6TZgQkAJl3iyoWHXcbEkIaCZQIYB3H6SBsOON7gWVTk8DAc+PDEOums/E1Uc/H7i
 CUx19Gzfq5bZgHu5CVPtcDP+zZ7trV9GaKE0guRoP2ZYtWe+Azx1T9CsG9cFCW98
 GHtHN41g3crbw2zZZDxGYzzlC4AqkxjIiBWCeL6ZeYSf69kfhcdUpgD34OBiLphl
 9IY0KgvyoQeUtoV5/BNHF59Mp0ogVdDQgfNysNoIvIM69apaVA3v/SyTSoAGLIqP
 7dMu+xLvadmGQD2DXt3eTZvCRNZUgXepR8Bgph/5k95QfXEKpb5z34soJsd2vmfc
 8oB9TknNgw9dh6fbEDElM3zttcjbY1uZLTRwYrMipzc=

Just print the block device name directly using the %pg format specifier.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 fs/ocfs2/cluster/heartbeat.c | 64 +++++++++++++++++-------------------
 1 file changed, 30 insertions(+), 34 deletions(-)

diff --git a/fs/ocfs2/cluster/heartbeat.c b/fs/ocfs2/cluster/heartbeat.c
index ea0e70c0fce09..5f83c0c0918c0 100644
--- a/fs/ocfs2/cluster/heartbeat.c
+++ b/fs/ocfs2/cluster/heartbeat.c
@@ -235,8 +235,6 @@ struct o2hb_region {
 	 * (hr_steady_iterations == 0) within hr_unsteady_iterations */
 	atomic_t		hr_unsteady_iterations;
 
-	char			hr_dev_name[BDEVNAME_SIZE];
-
 	unsigned int		hr_timeout_ms;
 
 	/* randomized as the region goes up and down so that a node
@@ -287,8 +285,8 @@ static void o2hb_write_timeout(struct work_struct *work)
 		container_of(work, struct o2hb_region,
 			     hr_write_timeout_work.work);
 
-	mlog(ML_ERROR, "Heartbeat write timeout to device %s after %u "
-	     "milliseconds\n", reg->hr_dev_name,
+	mlog(ML_ERROR, "Heartbeat write timeout to device %pg after %u "
+	     "milliseconds\n", reg->hr_bdev,
 	     jiffies_to_msecs(jiffies - reg->hr_last_timeout_start));
 
 	if (o2hb_global_heartbeat_active()) {
@@ -383,9 +381,9 @@ static void o2hb_nego_timeout(struct work_struct *work)
 
 	if (master_node == o2nm_this_node()) {
 		if (!test_bit(master_node, reg->hr_nego_node_bitmap)) {
-			printk(KERN_NOTICE "o2hb: node %d hb write hung for %ds on region %s (%s).\n",
+			printk(KERN_NOTICE "o2hb: node %d hb write hung for %ds on region %s (%pg).\n",
 				o2nm_this_node(), O2HB_NEGO_TIMEOUT_MS/1000,
-				config_item_name(&reg->hr_item), reg->hr_dev_name);
+				config_item_name(&reg->hr_item), reg->hr_bdev);
 			set_bit(master_node, reg->hr_nego_node_bitmap);
 		}
 		if (memcmp(reg->hr_nego_node_bitmap, live_node_bitmap,
@@ -399,8 +397,8 @@ static void o2hb_nego_timeout(struct work_struct *work)
 			return;
 		}
 
-		printk(KERN_NOTICE "o2hb: all nodes hb write hung, maybe region %s (%s) is down.\n",
-			config_item_name(&reg->hr_item), reg->hr_dev_name);
+		printk(KERN_NOTICE "o2hb: all nodes hb write hung, maybe region %s (%pg) is down.\n",
+			config_item_name(&reg->hr_item), reg->hr_bdev);
 		/* approve negotiate timeout request. */
 		o2hb_arm_timeout(reg);
 
@@ -419,9 +417,9 @@ static void o2hb_nego_timeout(struct work_struct *work)
 		}
 	} else {
 		/* negotiate timeout with master node. */
-		printk(KERN_NOTICE "o2hb: node %d hb write hung for %ds on region %s (%s), negotiate timeout with node %d.\n",
+		printk(KERN_NOTICE "o2hb: node %d hb write hung for %ds on region %s (%pg), negotiate timeout with node %d.\n",
 			o2nm_this_node(), O2HB_NEGO_TIMEOUT_MS/1000, config_item_name(&reg->hr_item),
-			reg->hr_dev_name, master_node);
+			reg->hr_bdev, master_node);
 		ret = o2hb_send_nego_msg(reg->hr_key, O2HB_NEGO_TIMEOUT_MSG,
 				master_node);
 		if (ret)
@@ -437,8 +435,8 @@ static int o2hb_nego_timeout_handler(struct o2net_msg *msg, u32 len, void *data,
 	struct o2hb_nego_msg *nego_msg;
 
 	nego_msg = (struct o2hb_nego_msg *)msg->buf;
-	printk(KERN_NOTICE "o2hb: receive negotiate timeout message from node %d on region %s (%s).\n",
-		nego_msg->node_num, config_item_name(&reg->hr_item), reg->hr_dev_name);
+	printk(KERN_NOTICE "o2hb: receive negotiate timeout message from node %d on region %s (%pg).\n",
+		nego_msg->node_num, config_item_name(&reg->hr_item), reg->hr_bdev);
 	if (nego_msg->node_num < O2NM_MAX_NODES)
 		set_bit(nego_msg->node_num, reg->hr_nego_node_bitmap);
 	else
@@ -452,8 +450,8 @@ static int o2hb_nego_approve_handler(struct o2net_msg *msg, u32 len, void *data,
 {
 	struct o2hb_region *reg = data;
 
-	printk(KERN_NOTICE "o2hb: negotiate timeout approved by master node on region %s (%s).\n",
-		config_item_name(&reg->hr_item), reg->hr_dev_name);
+	printk(KERN_NOTICE "o2hb: negotiate timeout approved by master node on region %s (%pg).\n",
+		config_item_name(&reg->hr_item), reg->hr_bdev);
 	o2hb_arm_timeout(reg);
 	return 0;
 }
@@ -689,8 +687,8 @@ static int o2hb_check_own_slot(struct o2hb_region *reg)
 	else
 		errstr = ERRSTR3;
 
-	mlog(ML_ERROR, "%s (%s): expected(%u:0x%llx, 0x%llx), "
-	     "ondisk(%u:0x%llx, 0x%llx)\n", errstr, reg->hr_dev_name,
+	mlog(ML_ERROR, "%s (%pg): expected(%u:0x%llx, 0x%llx), "
+	     "ondisk(%u:0x%llx, 0x%llx)\n", errstr, reg->hr_bdev,
 	     slot->ds_node_num, (unsigned long long)slot->ds_last_generation,
 	     (unsigned long long)slot->ds_last_time, hb_block->hb_node,
 	     (unsigned long long)le64_to_cpu(hb_block->hb_generation),
@@ -863,8 +861,8 @@ static void o2hb_set_quorum_device(struct o2hb_region *reg)
 		   sizeof(o2hb_live_node_bitmap)))
 		goto unlock;
 
-	printk(KERN_NOTICE "o2hb: Region %s (%s) is now a quorum device\n",
-	       config_item_name(&reg->hr_item), reg->hr_dev_name);
+	printk(KERN_NOTICE "o2hb: Region %s (%pg) is now a quorum device\n",
+	       config_item_name(&reg->hr_item), reg->hr_bdev);
 
 	set_bit(reg->hr_region_num, o2hb_quorum_region_bitmap);
 
@@ -922,8 +920,8 @@ static int o2hb_check_slot(struct o2hb_region *reg,
 		/* The node is live but pushed out a bad crc. We
 		 * consider it a transient miss but don't populate any
 		 * other values as they may be junk. */
-		mlog(ML_ERROR, "Node %d has written a bad crc to %s\n",
-		     slot->ds_node_num, reg->hr_dev_name);
+		mlog(ML_ERROR, "Node %d has written a bad crc to %pg\n",
+		     slot->ds_node_num, reg->hr_bdev);
 		o2hb_dump_slot(hb_block);
 
 		slot->ds_equal_samples++;
@@ -1002,11 +1000,11 @@ static int o2hb_check_slot(struct o2hb_region *reg,
 		slot_dead_ms = le32_to_cpu(hb_block->hb_dead_ms);
 		if (slot_dead_ms && slot_dead_ms != dead_ms) {
 			/* TODO: Perhaps we can fail the region here. */
-			mlog(ML_ERROR, "Node %d on device %s has a dead count "
+			mlog(ML_ERROR, "Node %d on device %pg has a dead count "
 			     "of %u ms, but our count is %u ms.\n"
 			     "Please double check your configuration values "
 			     "for 'O2CB_HEARTBEAT_THRESHOLD'\n",
-			     slot->ds_node_num, reg->hr_dev_name, slot_dead_ms,
+			     slot->ds_node_num, reg->hr_bdev, slot_dead_ms,
 			     dead_ms);
 		}
 		goto out;
@@ -1145,8 +1143,8 @@ static int o2hb_do_disk_heartbeat(struct o2hb_region *reg)
 		/* Do not re-arm the write timeout on I/O error - we
 		 * can't be sure that the new block ever made it to
 		 * disk */
-		mlog(ML_ERROR, "Write error %d on device \"%s\"\n",
-		     write_wc.wc_error, reg->hr_dev_name);
+		mlog(ML_ERROR, "Write error %d on device \"%pg\"\n",
+		     write_wc.wc_error, reg->hr_bdev);
 		ret = write_wc.wc_error;
 		goto bail;
 	}
@@ -1170,9 +1168,9 @@ static int o2hb_do_disk_heartbeat(struct o2hb_region *reg)
 	if (atomic_read(&reg->hr_steady_iterations) != 0) {
 		if (atomic_dec_and_test(&reg->hr_unsteady_iterations)) {
 			printk(KERN_NOTICE "o2hb: Unable to stabilize "
-			       "heartbeat on region %s (%s)\n",
+			       "heartbeat on region %s (%pg)\n",
 			       config_item_name(&reg->hr_item),
-			       reg->hr_dev_name);
+			       reg->hr_bdev);
 			atomic_set(&reg->hr_steady_iterations, 0);
 			reg->hr_aborted_start = 1;
 			wake_up(&o2hb_steady_queue);
@@ -1494,7 +1492,7 @@ static void o2hb_region_release(struct config_item *item)
 	struct page *page;
 	struct o2hb_region *reg = to_o2hb_region(item);
 
-	mlog(ML_HEARTBEAT, "hb region release (%s)\n", reg->hr_dev_name);
+	mlog(ML_HEARTBEAT, "hb region release (%pg)\n", reg->hr_bdev);
 
 	kfree(reg->hr_tmp_block);
 
@@ -1641,7 +1639,7 @@ static ssize_t o2hb_region_dev_show(struct config_item *item, char *page)
 	unsigned int ret = 0;
 
 	if (to_o2hb_region(item)->hr_bdev)
-		ret = sprintf(page, "%s\n", to_o2hb_region(item)->hr_dev_name);
+		ret = sprintf(page, "%pg\n", to_o2hb_region(item)->hr_bdev);
 
 	return ret;
 }
@@ -1798,8 +1796,6 @@ static ssize_t o2hb_region_dev_store(struct config_item *item,
 		goto out2;
 	}
 
-	bdevname(reg->hr_bdev, reg->hr_dev_name);
-
 	sectsize = bdev_logical_block_size(reg->hr_bdev);
 	if (sectsize != reg->hr_block_bytes) {
 		mlog(ML_ERROR,
@@ -1895,8 +1891,8 @@ static ssize_t o2hb_region_dev_store(struct config_item *item,
 		ret = -EIO;
 
 	if (hb_task && o2hb_global_heartbeat_active())
-		printk(KERN_NOTICE "o2hb: Heartbeat started on region %s (%s)\n",
-		       config_item_name(&reg->hr_item), reg->hr_dev_name);
+		printk(KERN_NOTICE "o2hb: Heartbeat started on region %s (%pg)\n",
+		       config_item_name(&reg->hr_item), reg->hr_bdev);
 
 out3:
 	if (ret < 0) {
@@ -2088,10 +2084,10 @@ static void o2hb_heartbeat_group_drop_item(struct config_group *group,
 			quorum_region = 1;
 		clear_bit(reg->hr_region_num, o2hb_quorum_region_bitmap);
 		spin_unlock(&o2hb_live_lock);
-		printk(KERN_NOTICE "o2hb: Heartbeat %s on region %s (%s)\n",
+		printk(KERN_NOTICE "o2hb: Heartbeat %s on region %s (%pg)\n",
 		       ((atomic_read(&reg->hr_steady_iterations) == 0) ?
 			"stopped" : "start aborted"), config_item_name(item),
-		       reg->hr_dev_name);
+		       reg->hr_bdev);
 	}
 
 	/*
-- 
2.30.2


_______________________________________________
Ocfs2-devel mailing list
Ocfs2-devel@oss.oracle.com
https://oss.oracle.com/mailman/listinfo/ocfs2-devel
