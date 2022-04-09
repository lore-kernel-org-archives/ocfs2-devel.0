Return-Path: <bounces+ocfs2-devel=archiver.kernel.org@phx1.rp.oracleemaildelivery.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from aib29ajc251.phx1.oracleemaildelivery.com (aib29ajc251.phx1.oracleemaildelivery.com [192.29.103.251])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 055D7C4167E
	for <ocfs2-devel@archiver.kernel.org>; Sat,  9 Apr 2022 04:51:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; s=oss-phx-1109;
 d=oss.oracle.com;
 h=Date:To:From:Subject:Message-Id:MIME-Version:Sender;
 bh=Z97ym2RHCw4pEv0szQ/InI6CKvS+AXfZyhfKhO6xiOM=;
 b=yUr0hUaJyLF9uC3bgtk2AmhGcWjt0qVOyL9TSwJpZaGwBLzoLF8Fs42O1dN9fKlcyXWhuF0aHyam
   jHXLL+/zrdVgD2Vki6IUkOAHCBEWqe1SiF8SMfn6jlRLjmAUN+dw3g7fHf8VqW5d4+st7lWpxUmV
   iP2qneeXnQy/bSbjvYXCA5uqn5sPIZWOAPSaBJ1vcB+nw/kx/7bReRvgNj/u0Z8MB3vOD9DNgztO
   +jUWesNHTVCHYzOM6tOSpwqFqnuaKJmRdX9qtO0kq2xRLTp/T4srp++N+EmRnqb48GoeyAj9HzmR
   +9AyqbZzS/PVkXiZfUrdxVuZDAxvcCDjMSaOEA==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; s=prod-phx-20191217;
 d=phx1.rp.oracleemaildelivery.com;
 h=Date:To:From:Subject:Message-Id:MIME-Version:Sender;
 bh=Z97ym2RHCw4pEv0szQ/InI6CKvS+AXfZyhfKhO6xiOM=;
 b=glrRcH/VPEB+3eBKa4dLuxZhFo5p7mtLDyj2TTiS0YvbZNtJEUws+zA6563CSof2kOzRMwvM7NQP
   Snzj0go629eT4fcxbNrPVA73iMNUu6CQiSX0OfPVXNk8W3cYv/2CwRnddnwawFT77xFZnmmn0wKL
   pQnRBaRdVmzaG4HTCoyNBvP2ua8sIIQGUuAq2eP8hPl8pCseaV4uMW7db2mOBMoJffIMPWP1qIU+
   N80vnOEMG7yJrRakEA3wfZ5HEaLInub8ChN/Taihf2xrsv9NhlsO6Z6SPeuDOrtQy4eJc2NlXwuP
   pbIawNbpojb+oivDfC8pR8V2lOrAYrMP89b8Uw==
Received: by omta-ad2-fd3-202-us-phoenix-1.omtaad2.vcndpphx.oraclevcn.com
 (Oracle Communications Messaging Server 8.1.0.1.20220319 64bit (built Mar 19
 2022))
 with ESMTPS id <0RA200AJM2UAPB70@omta-ad2-fd3-202-us-phoenix-1.omtaad2.vcndpphx.oraclevcn.com> for
 ocfs2-devel@archiver.kernel.org; Sat, 09 Apr 2022 04:51:46 +0000 (GMT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
 d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
 MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender
 :Reply-To:Content-Type:Content-ID:Content-Description;
 bh=Bh+vV8H1PUD+w/3YWj6wMRz8JdOJ8okMcDjW6Mx/Fiw=; b=DWf7imoDvMSXJTtirA5ltk+rtE
 YeH7NxKahOANJaW3JeWmpEL0KWvrQ+sUioHsm0dQaUs7Tks6Ss/UVOXMhmulR7QEBLriQYI1KEMzQ
 aO9ISV0dwvPZErcNPFhlMeFi6wIDVT8NvUOYYMlUOKdrnhvM68xwDYg36srZ722XpvX8aIcmuYcaD
 sB1HtVb3yxckb8p+8Hs6srY4Fa9xc+Rr/tmxJaQIFCFAy3LRp9g0YB5fD3IXoh+PksnNKd9R9552Q
 DFKI2Il5Y+lOkByKWQ2YD6LETuE64wDq4THU/F5OZAcQu9U4H1sQRvyeZgS12iohkvkHfPdltFjhr
 Z+SPB7CA==;
To: Jens Axboe <axboe@kernel.dk>
Date: Sat,  9 Apr 2022 06:50:25 +0200
Message-id: <20220409045043.23593-10-hch@lst.de>
X-Mailer: git-send-email 2.30.2
In-reply-to: <20220409045043.23593-1-hch@lst.de>
References: <20220409045043.23593-1-hch@lst.de>
MIME-version: 1.0
X-Source-IP: 198.137.202.133
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10311
 signatures=695566
X-Proofpoint-Spam-Details: rule=tap_notspam policy=tap score=0 spamscore=0
 bulkscore=0 malwarescore=0 priorityscore=30 adultscore=0 clxscore=228
 impostorscore=0 phishscore=0 mlxscore=0 suspectscore=0 mlxlogscore=742
 lowpriorityscore=0 classifier=spam adjust=0 reason=mlx scancount=1
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
 Johannes Thumshirn <johannes.thumshirn@wdc.com>, linux-mmc@vger.kernel.org,
 linux-f2fs-devel@lists.sourceforge.net, linux-xfs@vger.kernel.org,
 ocfs2-devel@oss.oracle.com, linux-fsdevel@vger.kernel.org,
 ntfs3@lists.linux.dev, linux-btrfs@vger.kernel.org
Subject: [Ocfs2-devel] [PATCH 09/27] ntfs3: use bdev_logical_block_size	instead
 of open coding it
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
X-Proofpoint-ORIG-GUID: J8Pfo_LMTLKDlMWPqkyuV9GpnaIiNhFU
X-Proofpoint-GUID: J8Pfo_LMTLKDlMWPqkyuV9GpnaIiNhFU
Reporting-Meta:
 AAEDfTdSz7uUc3yhbhpi8Ql6/SZ+3/L4srFd+Xm4mxfrsQB/DB/A+TBF5SyJIID3
 +21gqJZx8XS/zlOZvf3GDzu7Y3oqJPdHm+LK64BdoIu7+H51xMdY7p506PhSfrju
 Aw9dHbdbTN3bPVYLzYU4x6CxzMhAgHSI8T7STuIKLtdKv5UINsKJmLF0HzSD5Z0H
 jHk1sBKBQwdbB7qq9R76UBjEB7KZQXQe281CtW6e0KFoaVemp5+Q1TMoqGolGs7E
 5Poselu+NZLMDRyOa40lQ0q2EN23AUZKjmgG0kSGJNi2yMzC8bCTF3vW4xiMPk6v
 dgwy8RKdq4IQj2aYfKvvtF/hx+Y4h3DfneGl9tLn3qy7qF2nctB8ZDfyKhd8EeU8
 1NB9uWrbz8Mb5QeP5JMdxL1FSTy5jcP3IKpJpOwWYYCyy8YQYHOpNGNasTcYGMyz
 bsU3OlWESYX+lSeAZXytkG5kLJMV12FNbqtQfZASzA1HlXohO2sIoMvYCa+BXRHQ
 NZntPYDvTRuDokIigpMGxM2f7/Q54fsDlZ8e9pSVGHvJ

Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Johannes Thumshirn <johannes.thumshirn@wdc.com>
---
 fs/ntfs3/super.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/ntfs3/super.c b/fs/ntfs3/super.c
index 278dcf5024102..cd30e81abbce0 100644
--- a/fs/ntfs3/super.c
+++ b/fs/ntfs3/super.c
@@ -920,7 +920,7 @@ static int ntfs_fill_super(struct super_block *sb, struct fs_context *fc)
 	}
 
 	/* Parse boot. */
-	err = ntfs_init_from_boot(sb, rq ? queue_logical_block_size(rq) : 512,
+	err = ntfs_init_from_boot(sb, bdev_logical_block_size(bdev),
 				  bdev_nr_bytes(bdev));
 	if (err)
 		goto out;
-- 
2.30.2


_______________________________________________
Ocfs2-devel mailing list
Ocfs2-devel@oss.oracle.com
https://oss.oracle.com/mailman/listinfo/ocfs2-devel
