Return-Path: <bounces+ocfs2-devel=archiver.kernel.org@phx1.rp.oracleemaildelivery.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from aib29ajc248.phx1.oracleemaildelivery.com (aib29ajc248.phx1.oracleemaildelivery.com [192.29.103.248])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3F32FC4332F
	for <ocfs2-devel@archiver.kernel.org>; Fri, 15 Apr 2022 04:54:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; s=oss-phx-1109;
 d=oss.oracle.com;
 h=Date:To:From:Subject:Message-Id:MIME-Version:Sender;
 bh=Z97ym2RHCw4pEv0szQ/InI6CKvS+AXfZyhfKhO6xiOM=;
 b=mNvzD30drhRxtWWyIJZD4c5RB1MBWWfMDymYQ6lYaGh24Mji88eUvWEZFNQpu7mKpzVK0wGjnPCR
   9zYbEUAYP0WZtejgJBLiOKiKcEhjdl4RPyA/Ifn7S+jtcS0czRRxaCuDHh9FZCv7RsLuZePwsgfU
   vPEFTQQHmflOK6LVMasB81p7sv5ok0jHlPSSeZkQmbD5NbHSeIYJEzo5U4AnEX74Bqti3e9xX3ap
   m0LwsjQ9UTEJCl4H8uwDYe2j5Y1eLdq2Qn6EUpa9nzD49ujr0rZtuHp23HPnoMX9uyJqJQ4fVxRD
   fKtfTO76RV2iAjjM/zBk5eC4QwjR3WcOT66EVA==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; s=prod-phx-20191217;
 d=phx1.rp.oracleemaildelivery.com;
 h=Date:To:From:Subject:Message-Id:MIME-Version:Sender;
 bh=Z97ym2RHCw4pEv0szQ/InI6CKvS+AXfZyhfKhO6xiOM=;
 b=osPx7eCcz4BdMvpMTkE5g9LmUidvR+n3fjILSdTDLvSvl+YEuhm0wTijWqFuNSQrC5TMzspiG5AT
   12wPzj51CcInJUb4pA8aW9wVlnMrI+LPySPsF/3BVqh4cf2lWTfX1ZSMaBgHOXUcqSjwd928pttf
   9/Y3RusOfEQEgDWuqSGlTjE0Xl3WhwKOINHXci2yZjHHMKlFomyhnkcBWlr5+4ooRaqv9RzN6kfA
   dNB3DEuRJwO/NtHwQ3mfPG04RiEJAvuKkralRnGd7wjI7wt6XaghcjGMyB9jvcsRypAPe8L5I6rN
   0E1VmbV88GsiiP8ycRaeZdVbqbsoSXc4v8xF9A==
Received: by omta-ad2-fd1-201-us-phoenix-1.omtaad2.vcndpphx.oraclevcn.com
 (Oracle Communications Messaging Server 8.1.0.1.20220319 64bit (built Mar 19
 2022))
 with ESMTPS id <0RAD004026Z0Q400@omta-ad2-fd1-201-us-phoenix-1.omtaad2.vcndpphx.oraclevcn.com> for
 ocfs2-devel@archiver.kernel.org; Fri, 15 Apr 2022 04:54:36 +0000 (GMT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
 d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
 MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender
 :Reply-To:Content-Type:Content-ID:Content-Description;
 bh=Bh+vV8H1PUD+w/3YWj6wMRz8JdOJ8okMcDjW6Mx/Fiw=; b=EDKTioiwyVTPK+3osA6SlCjZIh
 XT2MFqWZOTWCp0TzWu6P4fqhDWPMpkttHrN+m9dRro3N5CDnlXbRs0EPkfGOyM+igunHSMpD1drYP
 wVG9uOkzBpiVKojyqfYhi6+OMNU5l2i8PZR4B1REL+uCtnEoooz23D6FVFibL3Fu1/dIA+0rTSxtr
 oKyzI2WMLHHUV9rvM0v15/lCAj3aZ6PKIBUE2kOCt4TslhWmWNZKgszd/7d2ie8DKfEQnXgchcj36
 NzfvLJkjkLxSqax1JuD1ELqlJ8gRaVf5Gn7y07gnCWPWGyuEN/9bXBtizUFBY7p5eDKr/MYNHjMCe
 ltnYH85Q==;
To: Jens Axboe <axboe@kernel.dk>
Date: Fri, 15 Apr 2022 06:52:40 +0200
Message-id: <20220415045258.199825-10-hch@lst.de>
X-Mailer: git-send-email 2.30.2
In-reply-to: <20220415045258.199825-1-hch@lst.de>
References: <20220415045258.199825-1-hch@lst.de>
MIME-version: 1.0
X-Source-IP: 198.137.202.133
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10317
 signatures=695566
X-Proofpoint-Spam-Details: rule=tap_notspam policy=tap score=0 impostorscore=0
 lowpriorityscore=0 phishscore=0 priorityscore=151 adultscore=0 mlxlogscore=785
 bulkscore=0 clxscore=264 malwarescore=0 mlxscore=0 spamscore=0 suspectscore=0
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
X-Proofpoint-ORIG-GUID: 8uj6CN8kIRTSs_0gQe2bZXilj_S-ge82
X-Proofpoint-GUID: 8uj6CN8kIRTSs_0gQe2bZXilj_S-ge82
Reporting-Meta:
 AAEw7PIAkF13p9TjXZGmdo446Tx7LXxn8jn9kyO16l8Es9iPLldvwvDI3TvQqaPs
 gT9PIiezFHx5gl0e4CFhBO8rOLOFZcP2u9GxFO1RTe78bH4VCtIdQVCAeLhTVfqB
 A9TSWb1TrY1JLTv9LtlGMvwr57Y8YJMU8FOkv96kV37QcZD/L18SbYisZccWmg37
 ZOwf7ytvtX/OGHd5nI0Hb0stmNchw19NjbkwMCpI7Uj2Q3MzeuoP/1iLndG91/FO
 8/rE/tHst0YxdaU9hQZC04F5R5JfPM5pMRcuAiiWKPQEh01hpmhozHq6Ge/VNkAq
 jovOpUjcgtniGv1Oh0CGQxZUXHh7Lq8YG+uz7KuhWABSLk9plV3C4xccsTcE7YTE
 D1CA7mCTYn8pJ6UXXcb11crwPOmqqPGogrVE7uIlmbPcBcVfLCL4bzn+P/diOF0D
 4iM15zfj8iS7ZchPY1RmoQCwbVk5Cw4tKl3krbjNlwJjjm01s/jfBy3UzTKV3YM/
 +TDfxU8WTFUDx2irMThrB3vGjRcUhVkio4V4sInilRLX

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
