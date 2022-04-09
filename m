Return-Path: <bounces+ocfs2-devel=archiver.kernel.org@phx1.rp.oracleemaildelivery.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from aib29ajc254.phx1.oracleemaildelivery.com (aib29ajc254.phx1.oracleemaildelivery.com [192.29.103.254])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D4CD9C433EF
	for <ocfs2-devel@archiver.kernel.org>; Sat,  9 Apr 2022 04:51:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; s=oss-phx-1109;
 d=oss.oracle.com;
 h=Date:To:From:Subject:Message-Id:MIME-Version:Sender;
 bh=l3eRycLdb8Qxjhf4nyEhZkv6G/ZZnFNKh8bLPDONSAw=;
 b=QhTx3eVdci4myyVoN1PJsmGtkTCueuxogbjsI60oE4T8LdVsOKygW/ySbPyGEfIUGYTg6D74GyvI
   uA7Pswp3FHwKO+/OhV2D6FOXk57MckV7k1FDVKafPx0hck1zisvO3ZNMWbFWnfMF3dF3GP9Sj6ii
   3aXbLyknGN1+kXZ2SIC8OXgLOXno/yNRjfArq3sbkDcUPJxc4htppVp/cihk8dxGVHLG3HawpXUJ
   ToQqJVBln849nm0aZTkCFGNKG2aeY5zyK39wmq0y5V1OEEZDTmyaYvoVJ5s4Tn21M/JGOswcXJoO
   rEguoYvvWtvTubX8m9/EQzM1AM3NsUclQdxjZQ==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; s=prod-phx-20191217;
 d=phx1.rp.oracleemaildelivery.com;
 h=Date:To:From:Subject:Message-Id:MIME-Version:Sender;
 bh=l3eRycLdb8Qxjhf4nyEhZkv6G/ZZnFNKh8bLPDONSAw=;
 b=KuYRL6GoyXJoMdR/StN0ew5odlUiRLRJODHbu5NUA+CfghtkcrF3nFM7Kl8VTM4DGiQDHHWXsi0C
   2lEjjlAQVyl8Mx39hPqQkvM0CW/8IutDyLTwR1Wn8jJTpRjzOVBO88ZvHCKIm9+cKCpxgN/OENFi
   fgoY4e+WEsp52C6WelnnmAIWU18bD52206tbaNJsV0yJDxGN7IrE/GiZjNjJfXCjhiv0e6qj3hSS
   tTonMRl2hif4ygAKRW4j5h4bSTSkEofPI3zRPapJsNd72C8xkxuCuqJkRzKQWfPXR2DTAax57SZ3
   Zynf1pHkFSb1p78l8oNkkVD6bC+0SYmzWTyZyw==
Received: by omta-ad3-fd3-301-us-phoenix-1.omtaad3.vcndpphx.oraclevcn.com
 (Oracle Communications Messaging Server 8.1.0.1.20220319 64bit (built Mar 19
 2022))
 with ESMTPS id <0RA2006AN2U6Y7B0@omta-ad3-fd3-301-us-phoenix-1.omtaad3.vcndpphx.oraclevcn.com> for
 ocfs2-devel@archiver.kernel.org; Sat, 09 Apr 2022 04:51:42 +0000 (GMT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
 d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
 MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender
 :Reply-To:Content-Type:Content-ID:Content-Description;
 bh=UUS6y6SVPRCfJmQVPGCeD5o714qtaTT6EGogPxQdIy8=; b=f8MqUsBATs67rjabQ/6Q/DbIDx
 fgXqbEI8CyICa2zvZugiHMNhsGNdoL78CjqUFo+L85yRWnSp4bLnWw9UOZORPlbxKENuHDE3BMnvC
 nZh6ejqs8UuaxSAp6FEJQyIJYqxldvUdfoiHG+YGtE8JBRDE1ky/o2Z2BT/GFfYVa2U3YknfleDGZ
 YUmnMj5SSobEjQAm6BIb9bH1beFjSOm9lCoP9YbR6kwi/6uzgUKhayh1GCsU3aZjAHXXaEb3quZh4
 j3z6YIhUDIw06+z4r77/ODr1b2fFsOalGXJmTq9WKgX7hgCKnXAOCLs7dqVGI90UT6R50HzlB6hd5
 fgQRzOXw==;
To: Jens Axboe <axboe@kernel.dk>
Date: Sat,  9 Apr 2022 06:50:17 +0200
Message-id: <20220409045043.23593-2-hch@lst.de>
X-Mailer: git-send-email 2.30.2
In-reply-to: <20220409045043.23593-1-hch@lst.de>
References: <20220409045043.23593-1-hch@lst.de>
MIME-version: 1.0
X-Source-IP: 127.0.0.1
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10311
 signatures=695566
X-Proofpoint-Spam-Details: rule=tap_notspam policy=tap score=0
 lowpriorityscore=0 spamscore=0 clxscore=253 priorityscore=111 mlxlogscore=999
 bulkscore=0 malwarescore=0 mlxscore=0 adultscore=0 phishscore=0 suspectscore=0
 impostorscore=0 classifier=spam adjust=0 reason=mlx scancount=1
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
X-ServerName: localhost
X-Proofpoint-SPF-Result: None
X-Spam: Clean
X-Proofpoint-ORIG-GUID: SqGiV6eG9X8h7mnvVcNv5PBLru2hAGYn
X-Proofpoint-GUID: SqGiV6eG9X8h7mnvVcNv5PBLru2hAGYn
Reporting-Meta:
 AAFCSbEZltLyGhoxkQ44OMFI7KZgeOs0ch+Gu/PEshxVulK27QqHBPNsuOrXTIpW
 764Z/5FAecjC2b7DNjlM65CTW/Y3wO+j5UVWMIDEu/HgCfIXcs4/tzA0QGmw201n
 k1WhSaqnjkLkL66v07YnjSNFNfzBtXZ8jN4wx3vHJYfxwA7xC/0s0lhXKjf7l9f0
 WLHvLMZ8dXJQTi8ODRMX/Ws66nRMwYsX3VM7IE8UOgSDrk9TRhJzFmQ+aCAsYptL
 TE5hWP6RqF2vIfZTCcuifWkQaeLjqrm5+MquAdQuzO/oyufxN+/1mdstOSJkNvSe
 /aXuqLDsY9XDuj3GDtP8/V8oatxdk2HZm/tFyMyT0HnWJI1apikohaS1mEygCtVg
 4H3exAqJpuemNGRuC3CfiT0PiAqjT4qe8nF+c5B0rDs6XVNbovzWGpZJrD2Ujt7d
 ZIdlb8HG/1i4pgKL5MkUCCMhDxoW+7bDlGjM1X3mL9CZnjPcG+GZ42bdGA6tIAD/
 tlFq+wcR+zECeO7HPsfUSVaxKuTVJhTEPDTcvfk09o60

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
