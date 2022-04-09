Return-Path: <bounces+ocfs2-devel=archiver.kernel.org@phx1.rp.oracleemaildelivery.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from aib29ajc246.phx1.oracleemaildelivery.com (aib29ajc246.phx1.oracleemaildelivery.com [192.29.103.246])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id F2C0DC433F5
	for <ocfs2-devel@archiver.kernel.org>; Sat,  9 Apr 2022 04:51:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; s=oss-phx-1109;
 d=oss.oracle.com;
 h=Date:To:From:Subject:Message-Id:MIME-Version:Sender;
 bh=yjIkxPT1e3ig7cFY+fQTq19J/mg4596tZUMMbSDhENI=;
 b=oBdwBcdjTwzIiPLRVGMt7jMMXadxB4B5dMGDBAJ30e4jfGxwi3hboJNeNgBXj8Z6E7EbV55GjLUj
   82+FUnl2QAlCejZxsnzKfmAWFXZEkXPS2xUKeY96B4wPNakd8ElCKiVj1Bjvup/AXBZy38gjmouP
   LdTd/biXd+dQedNAXaUd0qou2d7lF5tYKQ7lZlt/4f6PmYf6VJTRQks0NIdifLJrCcfY24dVqMqi
   abYKVEXW14HOZr1UvAZXSdxSvKQpjs/kYEMJv0zmNCiXH5/M+wYCmD0RHhAxmG86VAqIiDE9ltSq
   OSSddz8mvc2bJVXjD4c1YwJxHPC0Tl8IbRb2Rg==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; s=prod-phx-20191217;
 d=phx1.rp.oracleemaildelivery.com;
 h=Date:To:From:Subject:Message-Id:MIME-Version:Sender;
 bh=yjIkxPT1e3ig7cFY+fQTq19J/mg4596tZUMMbSDhENI=;
 b=FeFzcNvERZVtc8Z06EnR0jkEsPx86Krd1IjNq900kbecHiQl6brrrhTx1S4pRjlWIflusoLTza72
   aZfJRZqA4vp/07z8sogjh+LLRK3YES8cgMUAh9n7CUASjhErz3lw2RZO8MDmx7/HSgWiS3DsKTYq
   KhpuxNKgxsvbv8JjQ/cT8b/O7ULun7iXR8YyG1/dJ/1nkxPINd8uoI7h15+mt2STfQx6AC/F0t9E
   DPaece+PAZ3qJkqBwU+dKq6NKCjEERjvW4giBsZQD9rUNK8ejixJGG9+e/Egu4HSKZbi9rtjqblx
   bJvrX0g6uxQgmHb2i3up2XjQhOsX/UBuJkgoOQ==
Received: by omta-ad1-fd3-101-us-phoenix-1.omtaad1.vcndpphx.oraclevcn.com
 (Oracle Communications Messaging Server 8.1.0.1.20220319 64bit (built Mar 19
 2022))
 with ESMTPS id <0RA200OD92U8KN20@omta-ad1-fd3-101-us-phoenix-1.omtaad1.vcndpphx.oraclevcn.com> for
 ocfs2-devel@archiver.kernel.org; Sat, 09 Apr 2022 04:51:44 +0000 (GMT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
 d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
 MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender
 :Reply-To:Content-Type:Content-ID:Content-Description;
 bh=p7OacHYZtXHcRJcUjaO4g7N75FFwuFvyGKpz8CHLs7c=; b=Pzju2TytWziYGXeAIXOJqaZe7f
 7ZGvsguzecelJ4kpYHFs039peENwElmJJQkOSiGYs68Q+CTFipoeD0GlcVPwvTxb8xwBmaIekN2yU
 Rk4beWtSim6D708e6fSlV3YP5i7sNLfobnz5N1LWmB0773OmCuKgM8hPrOj00tHgKXSL2WCPSypp8
 ErKpc93xT55Q9MUWv2vmwsuaSUJfwgL8pm1UrjQ6JfcKYWVBii/A8RoyrVNpZCMb2NMWyLhn7ceWa
 xkvvl8VwB4N0A1xPbH8PCB21WFupHylrzncwQJ8sn/dqS6wML090d9Ks8PME8EXpA5KlHBwNJY9Qk
 zEahGH1Q==;
To: Jens Axboe <axboe@kernel.dk>
Date: Sat,  9 Apr 2022 06:50:20 +0200
Message-id: <20220409045043.23593-5-hch@lst.de>
X-Mailer: git-send-email 2.30.2
In-reply-to: <20220409045043.23593-1-hch@lst.de>
References: <20220409045043.23593-1-hch@lst.de>
MIME-version: 1.0
X-Source-IP: 198.137.202.133
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10311
 signatures=695566
X-Proofpoint-Spam-Details: rule=tap_notspam policy=tap score=0 priorityscore=48
 lowpriorityscore=0 bulkscore=0 suspectscore=0 mlxlogscore=807 spamscore=0
 malwarescore=0 mlxscore=0 adultscore=0 impostorscore=0 phishscore=0
 clxscore=254 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2202240000 definitions=main-2204090027
Cc: jfs-discussion@lists.sourceforge.net, linux-nvme@lists.infradead.org,
 virtualization@lists.linux-foundation.org, linux-mm@kvack.org,
 dm-devel@redhat.com, target-devel@vger.kernel.org,
 linux-mtd@lists.infradead.org, drbd-dev@lists.linbit.com,
 linux-s390@vger.kernel.org, linux-nilfs@vger.kernel.org,
 linux-scsi@vger.kernel.org, cluster-devel@redhat.com,
 xen-devel@lists.xenproject.org, linux-ext4@vger.kernel.org,
 linux-um@lists.infradead.org, nbd@other.debian.org,
 linux-block@vger.kernel.org, linux-bcache@vger.kernel.org,
 ceph-devel@vger.kernel.org, linux-raid@vger.kernel.org,
 linux-mmc@vger.kernel.org, linux-f2fs-devel@lists.sourceforge.net,
 linux-xfs@vger.kernel.org, ocfs2-devel@oss.oracle.com,
 linux-fsdevel@vger.kernel.org, ntfs3@lists.linux.dev,
 linux-btrfs@vger.kernel.org
Subject: [Ocfs2-devel] [PATCH 04/27] drbd: remove assign_p_sizes_qlim
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
X-Proofpoint-ORIG-GUID: qNr0_Vh5S-rsFBBgK3YOuXlAAWhA3NcK
X-Proofpoint-GUID: qNr0_Vh5S-rsFBBgK3YOuXlAAWhA3NcK
Reporting-Meta:
 AAEbaJwZyG7UVotcEmXCMu7Q49e2rTl+1K7MjNzxvfdj2Z8qeibhBa+5VuSsHX0h
 CAbfHP7oljkPrpgS+puieKsN1DCGDCeic0z8KHP7a/D8XrR//LZVYMvEYg8ZI8b2
 z+3rPXxzbqRjpxufg1WGKuVdynMNdVjukFHEaO9bT4d4C1Z02kk22q1JRWtB5u8B
 zQIP7i71Vu58XDBPBd+EZqh9xxdn/Y5IN7+tlOrR0zS4DXOaOFpDsYCSZ6a36shz
 gKTOOITDHVHeJu4yy4away55YFf1//tDOU8fxn1UXivPcTE5ul6dXVrNOfQ6Umgz
 sms7ZxxfstU9murHT3swjvt3csvHVn/3En0ZAEFkGJ8iREXPtak1FeWUc8+c01eb
 MIuLIiWsa6aSulEAnnTGVlsHD7SlvfyTRBHdSKV5de0rww2SKL+3hzKnQLZeZcow
 eMqZI7CWUbeMPawJzVq/n0lnhG8rBJM7fz7agjs77I6xrEl1DEyv8t9WoPL1iVye
 21Bvzbzo0hC+AX8NMniVwBpbIjIVnNxIcU8neZLwBw3n

Fold each branch into its only caller.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 drivers/block/drbd/drbd_main.c | 47 +++++++++++++++-------------------
 1 file changed, 20 insertions(+), 27 deletions(-)

diff --git a/drivers/block/drbd/drbd_main.c b/drivers/block/drbd/drbd_main.c
index 9676a1d214bc5..1262fe1c33618 100644
--- a/drivers/block/drbd/drbd_main.c
+++ b/drivers/block/drbd/drbd_main.c
@@ -903,31 +903,6 @@ void drbd_gen_and_send_sync_uuid(struct drbd_peer_device *peer_device)
 	}
 }
 
-/* communicated if (agreed_features & DRBD_FF_WSAME) */
-static void
-assign_p_sizes_qlim(struct drbd_device *device, struct p_sizes *p,
-					struct request_queue *q)
-{
-	if (q) {
-		p->qlim->physical_block_size = cpu_to_be32(queue_physical_block_size(q));
-		p->qlim->logical_block_size = cpu_to_be32(queue_logical_block_size(q));
-		p->qlim->alignment_offset = cpu_to_be32(queue_alignment_offset(q));
-		p->qlim->io_min = cpu_to_be32(queue_io_min(q));
-		p->qlim->io_opt = cpu_to_be32(queue_io_opt(q));
-		p->qlim->discard_enabled = blk_queue_discard(q);
-		p->qlim->write_same_capable = 0;
-	} else {
-		q = device->rq_queue;
-		p->qlim->physical_block_size = cpu_to_be32(queue_physical_block_size(q));
-		p->qlim->logical_block_size = cpu_to_be32(queue_logical_block_size(q));
-		p->qlim->alignment_offset = 0;
-		p->qlim->io_min = cpu_to_be32(queue_io_min(q));
-		p->qlim->io_opt = cpu_to_be32(queue_io_opt(q));
-		p->qlim->discard_enabled = 0;
-		p->qlim->write_same_capable = 0;
-	}
-}
-
 int drbd_send_sizes(struct drbd_peer_device *peer_device, int trigger_reply, enum dds_flags flags)
 {
 	struct drbd_device *device = peer_device->device;
@@ -957,14 +932,32 @@ int drbd_send_sizes(struct drbd_peer_device *peer_device, int trigger_reply, enu
 		q_order_type = drbd_queue_order_type(device);
 		max_bio_size = queue_max_hw_sectors(q) << 9;
 		max_bio_size = min(max_bio_size, DRBD_MAX_BIO_SIZE);
-		assign_p_sizes_qlim(device, p, q);
+		p->qlim->physical_block_size =
+			cpu_to_be32(queue_physical_block_size(q));
+		p->qlim->logical_block_size =
+			cpu_to_be32(queue_logical_block_size(q));
+		p->qlim->alignment_offset =
+			cpu_to_be32(queue_alignment_offset(q));
+		p->qlim->io_min = cpu_to_be32(queue_io_min(q));
+		p->qlim->io_opt = cpu_to_be32(queue_io_opt(q));
+		p->qlim->discard_enabled = blk_queue_discard(q);
 		put_ldev(device);
 	} else {
+		struct request_queue *q = device->rq_queue;
+
+		p->qlim->physical_block_size =
+			cpu_to_be32(queue_physical_block_size(q));
+		p->qlim->logical_block_size =
+			cpu_to_be32(queue_logical_block_size(q));
+		p->qlim->alignment_offset = 0;
+		p->qlim->io_min = cpu_to_be32(queue_io_min(q));
+		p->qlim->io_opt = cpu_to_be32(queue_io_opt(q));
+		p->qlim->discard_enabled = 0;
+
 		d_size = 0;
 		u_size = 0;
 		q_order_type = QUEUE_ORDERED_NONE;
 		max_bio_size = DRBD_MAX_BIO_SIZE; /* ... multiple BIOs per peer_request */
-		assign_p_sizes_qlim(device, p, NULL);
 	}
 
 	if (peer_device->connection->agreed_pro_version <= 94)
-- 
2.30.2


_______________________________________________
Ocfs2-devel mailing list
Ocfs2-devel@oss.oracle.com
https://oss.oracle.com/mailman/listinfo/ocfs2-devel
