Return-Path: <bounces+ocfs2-devel=archiver.kernel.org@phx1.rp.oracleemaildelivery.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from aib29ajc254.phx1.oracleemaildelivery.com (aib29ajc254.phx1.oracleemaildelivery.com [192.29.103.254])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8B448ECAAD1
	for <ocfs2-devel@archiver.kernel.org>; Thu,  1 Sep 2022 13:24:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; s=oss-phx-1109;
 d=oss.oracle.com;
 h=Date:To:From:Subject:Message-Id:MIME-Version:Sender;
 bh=fIWFzd+4OSG7kctJW4DehgCpmIgIGWpb//91BgzJMJI=;
 b=X6GioFrcCLaa9oH9wDLankgD16/kZbgMr0i0rA5qTK+gSFaEInRD9ww5NahdNkAZ8aEZOmi37NK0
   jq6bGahSiBYLCCJAEBOetDyH+NnBO1T02eFjcRE8EprtSlrSavtvfqLzg01NObnFWAJNRLDu7sbk
   rE8qm7lfLUevKggJymAfERxBxEFt9z0b7mpiqDZZC4huGhn+1mg44dXx2ffcMWe0Gtj/j2Zn3Lau
   NEdG9dyTj5jtdJA/AtbCwFGjMZyE2PPsTxuVtXfH3QGO5zm6SaUuMUJ8h2eTRMhDaEvxjtUTVopS
   WqfyfzeqAIafqZB0eMsMtccOhLMBp9WxC24Z3Q==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; s=prod-phx-20191217;
 d=phx1.rp.oracleemaildelivery.com;
 h=Date:To:From:Subject:Message-Id:MIME-Version:Sender;
 bh=fIWFzd+4OSG7kctJW4DehgCpmIgIGWpb//91BgzJMJI=;
 b=uicyLbBWvbE0TsuoLEtjrwb0gQS4GEWdEizZ46sl9CjGBAc9lfmOfAmRlHQ/6xuRXqmrizbjCSOd
   jhZAmMF4OgPat3o6v4V50QwySvTAVNCJQIX/BuRxMlLOb3BSlmxlBXvPmm4fie60njIzFHr1AwRP
   XiPr6KYhfF+I7if9I5OS6MOcRgobNq5/i7vyBpA3b5G0EDP0qViM6hpEoL8mXKCm7MSoi/kwIfMP
   nDEyKoKJxpasGQjidb82vDmsqqvPqoxs1Fhm2KWT2MKVG0X90uBZrAY/pWenzhet4EIrPOghfqUu
   dNIcz5ElotKYLek9LGvfmUbIqvEt9zCzsvDtMQ==
Received: by omta-ad3-fd3-301-us-phoenix-1.omtaad3.vcndpphx.oraclevcn.com
 (Oracle Communications Messaging Server 8.1.0.1.20220817 64bit (built Aug 17
 2022))
 with ESMTPS id <0RHJ00B7H98FAQB0@omta-ad3-fd3-301-us-phoenix-1.omtaad3.vcndpphx.oraclevcn.com> for
 ocfs2-devel@archiver.kernel.org; Thu, 01 Sep 2022 13:24:15 +0000 (GMT)
To: <linux-ext4@vger.kernel.org>, <linux-fsdevel@vger.kernel.org>,
 <linux-kernel@vger.kernel.org>, <cluster-devel@redhat.com>,
 <ntfs3@lists.linux.dev>, <ocfs2-devel@oss.oracle.com>,
 <reiserfs-devel@vger.kernel.org>, <jack@suse.cz>
Date: Thu, 1 Sep 2022 21:34:52 +0800
Message-id: <20220901133505.2510834-2-yi.zhang@huawei.com>
X-Mailer: git-send-email 2.31.1
In-reply-to: <20220901133505.2510834-1-yi.zhang@huawei.com>
References: <20220901133505.2510834-1-yi.zhang@huawei.com>
MIME-version: 1.0
X-Originating-IP: [10.175.127.227]
X-Source-IP: 45.249.212.187
X-Proofpoint-Virus-Version: vendor=nai engine=6400 definitions=10457
 signatures=596816
X-Proofpoint-Spam-Details: rule=tap_notspam policy=tap score=0 impostorscore=0
 mlxscore=0 phishscore=0 adultscore=0 clxscore=119 bulkscore=0 suspectscore=0
 malwarescore=0 priorityscore=207 mlxlogscore=799 spamscore=0
 lowpriorityscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2207270000 definitions=main-2209010060 domainage_hfrom=8269
Cc: axboe@kernel.dk, hch@infradead.org, tytso@mit.edu, agruenba@redhat.com,
 yi.zhang@huawei.com, almaz.alexandrovich@paragon-software.com,
 viro@zeniv.linux.org.uk, yukuai3@huawei.com, rpeterso@redhat.com,
 dushistov@mail.ru, chengzhihao1@huawei.com
Subject: [Ocfs2-devel] [PATCH v2 01/14] fs/buffer: remove __breadahead_gfp()
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
From: Zhang Yi via Ocfs2-devel <ocfs2-devel@oss.oracle.com>
Reply-to: Zhang Yi <yi.zhang@huawei.com>
Content-type: text/plain; charset="us-ascii"
Content-transfer-encoding: 7bit
Errors-to: ocfs2-devel-bounces@oss.oracle.com
X-ClientProxiedBy: dggems706-chm.china.huawei.com (10.3.19.183) To
 canpemm500005.china.huawei.com (7.192.104.229)
X-CFilter-Loop: Reflected
X-ServerName: szxga01-in.huawei.com
X-Proofpoint-SPF-Result: pass
X-Proofpoint-SPF-Record: v=spf1 ip4:45.249.212.32 ip4:45.249.212.35
 ip4:45.249.212.255 ip4:45.249.212.187/29 ip4:45.249.212.191 ip4:168.195.93.47
 ip4:185.176.79.56 ip4:119.8.179.247 ip4:119.8.89.136/31 ip4:119.8.89.135
 ip4:119.8.177.36/31 ip4:119.8.177.38 -all
X-Spam: Clean
X-Proofpoint-ORIG-GUID: e58GfGUoQlk6icVLEJ6Amjk9640-i4Z6
X-Proofpoint-GUID: e58GfGUoQlk6icVLEJ6Amjk9640-i4Z6
Reporting-Meta:
 AAF55idWRfbxPozgKQ8TMIUHlDoYw8FeqJaVSOKzo6F8/PWC3EIgXdDEuV1xrAIb
 WQiHDn7HizP8/T/XB6z8jR7C43Runt2Zy2XxpvmbQcAPlopG+ppwVKabFVCXxMAA
 cmsN14gGmMzS3uLr8RPHo/ltMTGfnqwwwMLEZ8Vt8xBCCrYoUWku3BLe98sNYivD
 G7SQ1lV4ifO/oHW0JNRED1PulFTv26ZIqVgl6KB6PTxTWhhKEl8nizDcbXoXbavz
 5xd6DNFxDI67yT0x/6XLHEsLfMRMPG7oEvNJHUS1ZRKPQIm4RnJ+8vRY3xjt9+Xb
 lsKePt8hZobX1vkceAkyEdO5R4Sciig4/9WD2hkufebMa2F4QKwUaSg7h6myNZcO
 XHP8waiPHxECIbGQT1FSMQZxUg+U8OJtOtjQpMBV3bAibe3ZLmGj7uC23eLhBsJz
 2uda2QguuMLxihV5nGIlugOEJgfh0nuFPdAE7Jkrsxw3X8kOL6gg/+uRoLZHFlGD
 UABlz60Tqq5ZpF8NyirW7r/CYoeBLIg5aoTFI/QV3MVk

No one use __breadahead_gfp() and sb_breadahead_unmovable() any more,
remove them.

Signed-off-by: Zhang Yi <yi.zhang@huawei.com>
Reviewed-by: Jan Kara <jack@suse.cz>
---
 fs/buffer.c                 | 11 -----------
 include/linux/buffer_head.h |  8 --------
 2 files changed, 19 deletions(-)

diff --git a/fs/buffer.c b/fs/buffer.c
index 55e762a58eb6..a0b70b3239f3 100644
--- a/fs/buffer.c
+++ b/fs/buffer.c
@@ -1348,17 +1348,6 @@ void __breadahead(struct block_device *bdev, sector_t block, unsigned size)
 }
 EXPORT_SYMBOL(__breadahead);
 
-void __breadahead_gfp(struct block_device *bdev, sector_t block, unsigned size,
-		      gfp_t gfp)
-{
-	struct buffer_head *bh = __getblk_gfp(bdev, block, size, gfp);
-	if (likely(bh)) {
-		ll_rw_block(REQ_OP_READ | REQ_RAHEAD, 1, &bh);
-		brelse(bh);
-	}
-}
-EXPORT_SYMBOL(__breadahead_gfp);
-
 /**
  *  __bread_gfp() - reads a specified block and returns the bh
  *  @bdev: the block_device to read from
diff --git a/include/linux/buffer_head.h b/include/linux/buffer_head.h
index 089c9ade4325..c3863c417b00 100644
--- a/include/linux/buffer_head.h
+++ b/include/linux/buffer_head.h
@@ -214,8 +214,6 @@ struct buffer_head *__getblk_gfp(struct block_device *bdev, sector_t block,
 void __brelse(struct buffer_head *);
 void __bforget(struct buffer_head *);
 void __breadahead(struct block_device *, sector_t block, unsigned int size);
-void __breadahead_gfp(struct block_device *, sector_t block, unsigned int size,
-		  gfp_t gfp);
 struct buffer_head *__bread_gfp(struct block_device *,
 				sector_t block, unsigned size, gfp_t gfp);
 void invalidate_bh_lrus(void);
@@ -340,12 +338,6 @@ sb_breadahead(struct super_block *sb, sector_t block)
 	__breadahead(sb->s_bdev, block, sb->s_blocksize);
 }
 
-static inline void
-sb_breadahead_unmovable(struct super_block *sb, sector_t block)
-{
-	__breadahead_gfp(sb->s_bdev, block, sb->s_blocksize, 0);
-}
-
 static inline struct buffer_head *
 sb_getblk(struct super_block *sb, sector_t block)
 {
-- 
2.31.1


_______________________________________________
Ocfs2-devel mailing list
Ocfs2-devel@oss.oracle.com
https://oss.oracle.com/mailman/listinfo/ocfs2-devel
