Return-Path: <bounces+ocfs2-devel=archiver.kernel.org@phx1.rp.oracleemaildelivery.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from aib29ajc247.phx1.oracleemaildelivery.com (aib29ajc247.phx1.oracleemaildelivery.com [192.29.103.247])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3AD18C46467
	for <ocfs2-devel@archiver.kernel.org>; Sat,  9 Apr 2022 04:52:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; s=oss-phx-1109;
 d=oss.oracle.com;
 h=Date:To:From:Subject:Message-Id:MIME-Version:Sender;
 bh=EhzRMAliWQfAp1Rh6krPu4+eAG1WRlU9Bdv6/WRPHMQ=;
 b=MoIhSekCGAmRbZ5aLl4BlEgbWEUBHxkYh/bLnOopA9IkEBcFTnq7j+8yuWPcVKEcQgqiOoNdu/HO
   xj3HlLfmLA6bT74jbHY48+O52y0i4vg/HUFE9oN0LYc7nZlnlJePrt3bZB3ecxQC1OW7VKz0ZI+Y
   A/b7kWUIq+BlzCbHda6NTDYxo34Isqxp1aTKHGer5y9P86KkfZzxfHvJAmxcHPNo17iBVlr7uaf6
   eg9ltDT77ptnOoBN5AoPZwb0123qFsqodDH6awKSO/S0KTSU4iefS1fhZ1835AEbR1XaRMdvJuAP
   12BB1CuvcYqpwr4Gn8vS1tVhqp0k+yqqApYxTg==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; s=prod-phx-20191217;
 d=phx1.rp.oracleemaildelivery.com;
 h=Date:To:From:Subject:Message-Id:MIME-Version:Sender;
 bh=EhzRMAliWQfAp1Rh6krPu4+eAG1WRlU9Bdv6/WRPHMQ=;
 b=Jm/kYUCPN70e8vebKGx257R1RTSYl8+aS1ojL6tzPlH/7G6w7Ew78SHtqkQJCQV6LGSXS5UIkCDn
   3gUTsZEVmcf0Awy/btvN7fC+JJPSiQkH3uV6Lx4efoJOIfAMcag1eqd9fdql83s2zaEIJeUF3mh4
   jOF1mKEZ2DlB1HAHxhETeph05SScQyvPtF2+70sqDkXaLXgx6w8fMqoGz+aEmqudtBsRaKVLsLsA
   DlMG3R3Yh9ZZXvzlDvHfkq6mHMqQq3XsoZpDUcWDjvwv/95k38ZiMXWGm3oH9CaaP/0kc6AJFb/Q
   iwMxdZoKjyKjl3wtGQ8gTnguhYHEz1dBOEXZ+w==
Received: by omta-ad1-fd3-102-us-phoenix-1.omtaad1.vcndpphx.oraclevcn.com
 (Oracle Communications Messaging Server 8.1.0.1.20220319 64bit (built Mar 19
 2022))
 with ESMTPS id <0RA200N5V2VGZJ00@omta-ad1-fd3-102-us-phoenix-1.omtaad1.vcndpphx.oraclevcn.com> for
 ocfs2-devel@archiver.kernel.org; Sat, 09 Apr 2022 04:52:28 +0000 (GMT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
 d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
 MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender
 :Reply-To:Content-Type:Content-ID:Content-Description;
 bh=A3F4pzgWH2QQ0wtpIeTWEbWkE7zvp2Hf2SzUvBBV6uI=; b=eX3MLxgs7+LMLexFHqIdmiQ1Yi
 JdldSlm4poJNjPdmeRgScog9CyFDEOKE36j3Y8GOp25ZxOav5fY5REWK35ZSyRrUZZpvLOWxApha8
 AqMJ/MRcKr/CciLBe0jYueVDtJe90F1Pdg6qhOzgnLBHrJsW74l04GpKIl/5YuRS1FbaP4TBsToNP
 0GMgdPs2iWYbeYRMarbkSLZIEMdyAXHMZf+OWZlI5UmjWZF1rz7GghGKiiX6rIFIXD4QKrdrCfgbK
 fUs8lbnQ+FGDvl7FzdU6CQADQv8poqc/NeAD2tkAuI0L7ZIL5HeAN+izt/vpd0COwgfEQET8Ojz2e
 P5cDct/w==;
To: Jens Axboe <axboe@kernel.dk>
Date: Sat,  9 Apr 2022 06:50:36 +0200
Message-id: <20220409045043.23593-21-hch@lst.de>
X-Mailer: git-send-email 2.30.2
In-reply-to: <20220409045043.23593-1-hch@lst.de>
References: <20220409045043.23593-1-hch@lst.de>
MIME-version: 1.0
X-Source-IP: 127.0.0.1
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10311
 signatures=695566
X-Proofpoint-Spam-Details: rule=tap_notspam policy=tap score=0 priorityscore=0
 lowpriorityscore=0 bulkscore=0 suspectscore=0 mlxlogscore=893 spamscore=0
 malwarescore=0 mlxscore=0 adultscore=0 impostorscore=0 phishscore=0
 clxscore=237 classifier=spam adjust=0 reason=mlx scancount=1
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
Subject: [Ocfs2-devel] [PATCH 20/27] block: use bdev_discard_alignment in
	part_discard_alignment_show
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
X-ServerName: localhost
X-Proofpoint-SPF-Result: None
X-Spam: Clean
X-Proofpoint-ORIG-GUID: z0CH6xLf2Bz_STGzPzRM1hC49C9urDYr
X-Proofpoint-GUID: z0CH6xLf2Bz_STGzPzRM1hC49C9urDYr
Reporting-Meta:
 AAGd+mS7qnea2yf0mu2jG9OHBi/K+xS/+F7NFK+hYDj8I9opzM9lI+5b2Yfg4Zy1
 qw882c8sXe0WiavM7LRv3ZgqMkYB0i7r1yJzOpWD/2P1H8uOWhb2fJGEi5jGjP+W
 j3AzivXprhOmLjaQGchvCXUagtdv5qvuK0AxwJZYUi5sA4KjKhvkzE21lH/kFu4c
 3YE4tlAkqDpbP/BlN9S0WBwrMe471e+7bpQl1Q7Ua8JN3INg8iPyFp8YAq5W7XiM
 BcImwdUxRhn0UoKc05St04Q0+MbU6kauhOwgpltyVBgv4a8WW1bv5mHPxkewXH6P
 UrvMZnKu1v6LzLth75dVbmoV0ivaEV+aPQ7h4v0+JYIO9xi6pBrnGDGEASmiOtmc
 CVu6A+Y5WKzSOMB3BKzvJAwXC0bNg3qooYgPxG8DHMXxNbX5tsFKR4abbi49Euhv
 h7z3ursyevj+HCuYh9xyJnJW9PRJpGdweaZibDDAXkZVJ7p+Q1rBqgmM8UW/I6o0
 Xm0mNeNff0e5bL9DNEuiETJmt5QcD5HQWBaaoViiJ5RP

Use the bdev based alignment helper instead of open coding it.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Martin K. Petersen <martin.petersen@oracle.com>
---
 block/partitions/core.c | 6 +-----
 1 file changed, 1 insertion(+), 5 deletions(-)

diff --git a/block/partitions/core.c b/block/partitions/core.c
index 240b3fff521e4..70dec1c78521d 100644
--- a/block/partitions/core.c
+++ b/block/partitions/core.c
@@ -206,11 +206,7 @@ static ssize_t part_alignment_offset_show(struct device *dev,
 static ssize_t part_discard_alignment_show(struct device *dev,
 					   struct device_attribute *attr, char *buf)
 {
-	struct block_device *bdev = dev_to_bdev(dev);
-
-	return sprintf(buf, "%u\n",
-		queue_limit_discard_alignment(&bdev_get_queue(bdev)->limits,
-				bdev->bd_start_sect));
+	return sprintf(buf, "%u\n", bdev_discard_alignment(dev_to_bdev(dev)));
 }
 
 static DEVICE_ATTR(partition, 0444, part_partition_show, NULL);
-- 
2.30.2


_______________________________________________
Ocfs2-devel mailing list
Ocfs2-devel@oss.oracle.com
https://oss.oracle.com/mailman/listinfo/ocfs2-devel
