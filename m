Return-Path: <bounces+ocfs2-devel=archiver.kernel.org@phx1.rp.oracleemaildelivery.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from aib29ajc250.phx1.oracleemaildelivery.com (aib29ajc250.phx1.oracleemaildelivery.com [192.29.103.250])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 828A0C35294
	for <ocfs2-devel@archiver.kernel.org>; Fri, 15 Apr 2022 04:54:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; s=oss-phx-1109;
 d=oss.oracle.com;
 h=Date:To:From:Subject:Message-Id:MIME-Version:Sender;
 bh=l3eRycLdb8Qxjhf4nyEhZkv6G/ZZnFNKh8bLPDONSAw=;
 b=OFymqJv4RmZfKGMkqtqkf+gXzgqgtOajW3lhidxACx5jttzInFtOl6hLjgxrLsu+oCZElXMYwf9u
   yfgJrpnP7Z7CXWJ7sjgispWF59oLDSQWe5sK54H9NpVzBh7zx6zuVBHBQzipIVGUUKrPZh+VnjH5
   HbrM2ku3cOMKF5UqxEohmkNEww6R48aLHrykzNkei3z4zOVFl8reJWhqAQ5fKnsIOSqPxuXTptlL
   l8ZO3ihcNZSBZ9XOAzuxpKFfbUBjdE9xp7G4YiTMajLV1Oojzhu72j+Fj7GVtRcKidSHKCEe9Bsr
   8Bp7vrKtLlHMbfkIqdkbcRr2AaKUw+Cwt5MXfw==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; s=prod-phx-20191217;
 d=phx1.rp.oracleemaildelivery.com;
 h=Date:To:From:Subject:Message-Id:MIME-Version:Sender;
 bh=l3eRycLdb8Qxjhf4nyEhZkv6G/ZZnFNKh8bLPDONSAw=;
 b=pACbS2HyCf3VIoUxxZncy5tH8K3BK0fwq8BS0W/5NPUNrVKDQuAAmCzp1SKdRsIgTc1iPALo7hiG
   tx/xSvS3lp66t/JglFZBetaksVHVDcftrM5nKB0tz1T9uFpV6mnBwuwI6HdHoPUkLj9HECyYlYCY
   gJsP72p2PD9VATnaRHXO+G5mC4gigPTNmq9A8+OM0UWGNHd4iy/AdAnWnc6BuUO9uLfsfPllPzF5
   z51JHyo+OBgVTvtZC6/HpwDYh/b+qe0YSQR+nBMTuspXBsey64QFGZzed86dAj+QBqFgVBwP9rIp
   oIlFfWm5drHRLjc5CVbfdZnccYl2XsPE5zaNGQ==
Received: by omta-ad2-fd3-201-us-phoenix-1.omtaad2.vcndpphx.oraclevcn.com
 (Oracle Communications Messaging Server 8.1.0.1.20220319 64bit (built Mar 19
 2022))
 with ESMTPS id <0RAD002HS6YTH560@omta-ad2-fd3-201-us-phoenix-1.omtaad2.vcndpphx.oraclevcn.com> for
 ocfs2-devel@archiver.kernel.org; Fri, 15 Apr 2022 04:54:29 +0000 (GMT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
 d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
 MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender
 :Reply-To:Content-Type:Content-ID:Content-Description;
 bh=UUS6y6SVPRCfJmQVPGCeD5o714qtaTT6EGogPxQdIy8=; b=x5agUVGSt4qUPiArfFruXQZEkh
 ED5eIR3aSkNtXX7nLmypr4HghgJKhQCB8SBb7JsEb44bJsx67U0AujP5aBa1btb0b+S+xGwgwPD/7
 RRQm+W0tVsP/DSqW5U9c8tVIT1qiiaD3HIowj1Lt7t2v4nBRlePLOFKu6cvzlYV9ePp50Bne//9CJ
 umsrwM4RvhODoSk65phqK4ewBHRrL/nBunRhsHvf5+9CdNnqhx6U7RpMnn5jES/jOpBFGw0/3/808
 G3CmRXGpdyxJMHizR5B5MMLpxywFyHZzcVohmA18ECgaE440XvejvcNkIHffvwRVbT/cfUPwhLobO
 l5t6lMLg==;
To: Jens Axboe <axboe@kernel.dk>
Date: Fri, 15 Apr 2022 06:52:32 +0200
Message-id: <20220415045258.199825-2-hch@lst.de>
X-Mailer: git-send-email 2.30.2
In-reply-to: <20220415045258.199825-1-hch@lst.de>
References: <20220415045258.199825-1-hch@lst.de>
MIME-version: 1.0
X-Source-IP: 198.137.202.133
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10317
 signatures=695566
X-Proofpoint-Spam-Details: rule=tap_notspam policy=tap score=0 impostorscore=0
 lowpriorityscore=0 phishscore=0 priorityscore=30 adultscore=0 mlxlogscore=999
 bulkscore=0 clxscore=309 malwarescore=0 mlxscore=0 spamscore=0 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2202240000
 definitions=main-2204150029
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
Subject: [Ocfs2-devel] [PATCH 01/27] target: remove an incorrect unmap	zeroes
 data deduction
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
X-Proofpoint-GUID: KRcMcrl6RDGm5knN30wUQWMl8JkuC8h5
X-Proofpoint-ORIG-GUID: KRcMcrl6RDGm5knN30wUQWMl8JkuC8h5
Reporting-Meta:
 AAEk9FVDjjSIsrc7zH2XlbISVzpVlvpMiUg4YAHGQwqh+autGSz3FSUx7EJm+Oft
 2gi4WDLAE8NdAGu4YOLCiTAXlflb298XZCPLJgFum7nhM1+PxBU0zT/v8rliqyI6
 P5ZVcSLZrR3vzfM/u74/ETNXMaol23nKI4l3yK2ykL+F/PlbwjDX1MRfvMRCcpP0
 mMv/EkAvWZP3uBjld25uY9nMYCdYh3KmlZijr2giLMNqNYv06bjREkr9HbNYxQNY
 dNo13/XDWRUmvMy5K73ww80wuYza2nlU89fc5Ta4l4GLYcxl34i710n7b+LU8IQh
 8oh7nErTsnu+driDq0KPgHanmO9AlqE8ne4UyiGNqXarQKXv/McpNvIVO4Od/0H1
 0grIrwvT4eIZCI6QBgSN6XJQI4NB8WwFcqudk1tUARivEsqbSUEoTFCnmfpkQ4ZO
 vqMnORQFk7GHKLYPGbzIxapknABBn5OueCIfWgdIP3O1x3StPITyss4L6AyRPYEO
 UeFpE+5pvMTFF4PFHpFNQpMeucbtGTLCEno7cXpe0lxVgQ==

For block devices, the SCSI target drivers implements UNMAP as calls to
blkdev_issue_discard, which does not guarantee zeroing just because
Write Zeroes is supported.

Note that this does not affect the file backed path which uses
fallocate to punch holes.

Fixes: 2237498f0b5c ("target/iblock: Convert WRITE_SAME to blkdev_issue_zeroout")
Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Martin K. Petersen <martin.petersen@oracle.com>
---
 drivers/target/target_core_device.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/target/target_core_device.c b/drivers/target/target_core_device.c
index 44bb380e7390c..fa866acef5bb2 100644
--- a/drivers/target/target_core_device.c
+++ b/drivers/target/target_core_device.c
@@ -850,7 +850,6 @@ bool target_configure_unmap_from_queue(struct se_dev_attrib *attrib,
 	attrib->unmap_granularity = q->limits.discard_granularity / block_size;
 	attrib->unmap_granularity_alignment = q->limits.discard_alignment /
 								block_size;
-	attrib->unmap_zeroes_data = !!(q->limits.max_write_zeroes_sectors);
 	return true;
 }
 EXPORT_SYMBOL(target_configure_unmap_from_queue);
-- 
2.30.2


_______________________________________________
Ocfs2-devel mailing list
Ocfs2-devel@oss.oracle.com
https://oss.oracle.com/mailman/listinfo/ocfs2-devel
