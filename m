Return-Path: <SRS0=lfe4=G7=oss.oracle.com=ocfs2-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.7 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CA08FC433DB
	for <ocfs2-devel@archiver.kernel.org>; Thu, 28 Jan 2021 08:13:37 +0000 (UTC)
Received: from userp2130.oracle.com (userp2130.oracle.com [156.151.31.86])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id 639BD6146D
	for <ocfs2-devel@archiver.kernel.org>; Thu, 28 Jan 2021 08:13:37 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 639BD6146D
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=wdc.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=ocfs2-devel-bounces@oss.oracle.com
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
	by userp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 10S89uL3082705;
	Thu, 28 Jan 2021 08:13:36 GMT
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
	by userp2130.oracle.com with ESMTP id 368b7r2ush-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 28 Jan 2021 08:13:36 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
	by userp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 10S8AErW091599;
	Thu, 28 Jan 2021 08:13:35 GMT
Received: from oss.oracle.com (oss-old-reserved.oracle.com [137.254.22.2])
	by userp3030.oracle.com with ESMTP id 368wqyy49s-1
	(version=TLSv1 cipher=AES256-SHA bits=256 verify=NO);
	Thu, 28 Jan 2021 08:13:35 +0000
Received: from localhost ([127.0.0.1] helo=lb-oss.oracle.com)
	by oss.oracle.com with esmtp (Exim 4.63)
	(envelope-from <ocfs2-devel-bounces@oss.oracle.com>)
	id 1l51hv-0003aP-BU; Wed, 27 Jan 2021 23:27:11 -0800
Received: from userp3030.oracle.com ([156.151.31.80])
	by oss.oracle.com with esmtp (Exim 4.63)
	(envelope-from <prvs=655a99766=chaitanya.kulkarni@wdc.com>)
	id 1l51X4-0002tO-8A
	for ocfs2-devel@oss.oracle.com; Wed, 27 Jan 2021 23:15:58 -0800
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
	by userp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id
	10S70CZA012063
	for <ocfs2-devel@oss.oracle.com>; Thu, 28 Jan 2021 07:15:58 GMT
Received: from userp2030.oracle.com (userp2030.oracle.com [156.151.31.89])
	by userp3030.oracle.com with ESMTP id 368wqyvu37-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
	for <ocfs2-devel@oss.oracle.com>; Thu, 28 Jan 2021 07:15:57 +0000
Received: from pps.filterd (userp2030.oracle.com [127.0.0.1])
	by userp2030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id
	10S74Lah040557
	for <ocfs2-devel@oss.oracle.com>; Thu, 28 Jan 2021 07:15:57 GMT
Received: from esa1.hgst.iphmx.com (esa1.hgst.iphmx.com [68.232.141.245])
	by userp2030.oracle.com with ESMTP id 36bqd38xx2-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256
	verify=FAIL)
	for <ocfs2-devel@oss.oracle.com>; Thu, 28 Jan 2021 07:15:57 +0000
IronPort-SDR: nD7waHmJzgaq39J7hYjGtEpItSHO8g0lHtrOubhAYsGcJqsKqx9E6uEyW9hJ633ah1WjGx+C3T
	KysHWDH8Gfa2uYe7DVV01gZx9dgNI8qz4odOCliaeQgrKSyY/kBRiZ4OfBR8+JLGSbyrklDXe/
	ldylrILmhdqYbgczlYq5ZnDveMn5kws+1H7uHncrMkCklReLj7QTxG7iiEXQoPpdnaF118qe8h
	vIoR5y52wBy1zwMxYbJTkPrBGRhvAAPTgX/18fPcrxS/w8AzipIZgX0SI8if9Jc8fTRTkftAaH
	mgQ=
X-IronPort-AV: E=Sophos;i="5.79,381,1602518400"; d="scan'208";a="268892714"
Received: from uls-op-cesaip01.wdc.com (HELO uls-op-cesaep01.wdc.com)
	([199.255.45.14])
	by ob1.hgst.iphmx.com with ESMTP; 28 Jan 2021 15:15:56 +0800
IronPort-SDR: 3rz/Lr8Dr4dNr+2UeMKJIE6g0F1tL/+7XNsSToPNrbbau/fcb0S8YeBUfoiCYRBPu7dQY4uHcU
	W3U9RPIHjE1e31DEqgSMRI/zGfJQGJzQW2Z4gfbzpESHOthzDeFovfyqbd9KbfVofq4zCE0WkZ
	vz5yeGdpxdXfIL0AsJv5vgTojEm7HP1i1xpzzVmmN9oEPuOxPsm4Ue1n3MIzYn5N4GtFF3rtKH
	nW0zVh27ZpZC5XBLYRvRHA+FuJHDUjStcZqaR/yvGZiX2I0Rs80HHO8+Cymz0Qv9lJArgOcoL8
	aifwMggFYCOcS2Zyznde33UY
Received: from uls-op-cesaip02.wdc.com ([10.248.3.37])
	by uls-op-cesaep01.wdc.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384;
	27 Jan 2021 23:00:16 -0800
IronPort-SDR: MJghY7CI3VIGR5/IaW1FKfL3TP8YTcGZMlKgwb78Me3B/B/3apRuuzh9zoIBvsafPZo8P1zI7O
	tvlMLEPWxNEsao+d+OWmeAfzkHQtyrR4CezWVDYJlrvLmf+2864qvNG9WiZqHSu38lUOwqOgWr
	BwUEJ5wQyzZ3OCyeIORv7uUc6VzLa9ZZ6RiC/IlKAQuXNbiGRl7btRhvnWciISjEw6c6WHvSr7
	U7MWRK7LEz7DNkLYA3LIdhi5N4PJW+ftjhgTNZ5eyVeVGIhgT6If8NwOmXnpUTI7IymY6dp08v
	5GE=
WDCIronportException: Internal
Received: from vm.labspan.wdc.com (HELO vm.sc.wdc.com) ([10.6.137.102])
	by uls-op-cesaip02.wdc.com with ESMTP; 27 Jan 2021 23:15:56 -0800
From: Chaitanya Kulkarni <chaitanya.kulkarni@wdc.com>
To: linux-xfs@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        dm-devel@redhat.com, linux-block@vger.kernel.org,
        linux-kernel@vger.kernel.org, drbd-dev@lists.linbit.com,
        xen-devel@lists.xenproject.org, linux-nvme@lists.infradead.org,
        linux-scsi@vger.kernel.org, target-devel@vger.kernel.org,
        linux-fscrypt@vger.kernel.org, jfs-discussion@lists.sourceforge.net,
        linux-nilfs@vger.kernel.org, ocfs2-devel@oss.oracle.com,
        linux-pm@vger.kernel.org, linux-mm@kvack.org
Date: Wed, 27 Jan 2021 23:11:30 -0800
Message-Id: <20210128071133.60335-32-chaitanya.kulkarni@wdc.com>
X-Mailer: git-send-email 2.22.1
In-Reply-To: <20210128071133.60335-1-chaitanya.kulkarni@wdc.com>
References: <20210128071133.60335-1-chaitanya.kulkarni@wdc.com>
MIME-Version: 1.0
X-PDR: PASS
X-Source-IP: 68.232.141.245
X-ServerName: esa1.hgst.iphmx.com
X-Proofpoint-SPF-Result: pass
X-Proofpoint-SPF-Record: v=spf1 ptr ip4:35.160.12.30 ip4:52.34.195.46
	ip4:35.162.181.10
	ip4:35.162.44.129 ip4:68.232.141.245 ip4:68.232.143.124
	ip4:52.36.78.170
	ip4:52.86.68.205 ip4:52.86.226.44 ip4:68.232.142.99 ip4:68.232.148.20
	ip4:52.26.217.74 ip4:54.187.119.58 ip4:216.71.154.42 ip4:68.232.143.124
	ip4:68.232.141.245 ip4:216.71.153.141 ip4:216.71.153.144
	ip4:216.71.154.45
	ip4:199.255.45.14 ip4:199.255.45.15 include:spf.mandrillapp.com
	include:servers.mcsv.net include:spf.protection.outlook.com -all
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9877
	signatures=668683
X-Proofpoint-Spam-Details: rule=tap_notspam policy=tap score=0 phishscore=0
	clxscore=233
	mlxlogscore=964 spamscore=0 bulkscore=0 mlxscore=0 adultscore=0
	lowpriorityscore=0 malwarescore=0 impostorscore=0 suspectscore=0
	priorityscore=162 classifier=spam adjust=0 reason=mlx scancount=1
	engine=8.12.0-2009150000 definitions=main-2101280034
X-Spam: Clean
X-Mailman-Approved-At: Wed, 27 Jan 2021 23:27:08 -0800
Cc: shaggy@kernel.org, sergey.senozhatsky.work@gmail.com, snitzer@redhat.com,
        tiwai@suse.de, djwong@kernel.org, gustavoars@kernel.org, pavel@ucw.cz,
        alex.shi@linux.alibaba.com, agk@redhat.com, naohiro.aota@wdc.com,
        sagi@grimberg.me, osandov@fb.com, ebiggers@kernel.org,
        ngupta@vflare.org, len.brown@intel.com, chaitanya.kulkarni@wdc.com,
        konrad.wilk@oracle.com, hare@suse.de, ming.lei@redhat.com,
        viro@zeniv.linux.org.uk, jefflexu@linux.alibaba.com,
        jaegeuk@kernel.org, konishi.ryusuke@gmail.com, bvanassche@acm.org,
        axboe@kernel.dk, damien.lemoal@wdc.com, tytso@mit.edu,
        rjw@rjwysocki.net, philipp.reisner@linbit.com, minchan@kernel.org,
        tj@kernel.org, lars.ellenberg@linbit.com, jth@kernel.org,
        asml.silence@gmail.com, roger.pau@citrix.com
Subject: [Ocfs2-devel] [RFC PATCH 31/34] iomap: use bio_new in
	iomap_readpage_actor
X-BeenThere: ocfs2-devel@oss.oracle.com
X-Mailman-Version: 2.1.9
Precedence: list
List-Id: <ocfs2-devel.oss.oracle.com>
List-Unsubscribe: <https://oss.oracle.com/mailman/listinfo/ocfs2-devel>,
	<mailto:ocfs2-devel-request@oss.oracle.com?subject=unsubscribe>
List-Archive: <http://oss.oracle.com/pipermail/ocfs2-devel>
List-Post: <mailto:ocfs2-devel@oss.oracle.com>
List-Help: <mailto:ocfs2-devel-request@oss.oracle.com?subject=help>
List-Subscribe: <https://oss.oracle.com/mailman/listinfo/ocfs2-devel>,
	<mailto:ocfs2-devel-request@oss.oracle.com?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Sender: ocfs2-devel-bounces@oss.oracle.com
Errors-To: ocfs2-devel-bounces@oss.oracle.com
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9877 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 spamscore=0 phishscore=0
 adultscore=0 mlxlogscore=999 malwarescore=0 suspectscore=0 bulkscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2101280040
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9877 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 spamscore=0 phishscore=0
 adultscore=0 impostorscore=0 malwarescore=0 lowpriorityscore=0 bulkscore=0
 priorityscore=1501 mlxscore=0 clxscore=1015 mlxlogscore=999
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2101280040

Signed-off-by: Chaitanya Kulkarni <chaitanya.kulkarni@wdc.com>
---
 fs/iomap/buffered-io.c | 12 +++++-------
 1 file changed, 5 insertions(+), 7 deletions(-)

diff --git a/fs/iomap/buffered-io.c b/fs/iomap/buffered-io.c
index 16a1e82e3aeb..08d119b62cf5 100644
--- a/fs/iomap/buffered-io.c
+++ b/fs/iomap/buffered-io.c
@@ -241,6 +241,9 @@ iomap_readpage_actor(struct inode *inode, loff_t pos, loff_t length, void *data,
 	struct page *page = ctx->cur_page;
 	struct iomap_page *iop = iomap_page_create(inode, page);
 	bool same_page = false, is_contig = false;
+	struct block_device *bdev = iomap->bdev;
+	unsigned opf = ctx->rac ? REQ_RAHEAD : 0;
+	unsigned op = REQ_OP_READ;
 	loff_t orig_pos = pos;
 	unsigned poff, plen;
 	sector_t sector;
@@ -285,19 +288,14 @@ iomap_readpage_actor(struct inode *inode, loff_t pos, loff_t length, void *data,
 
 		if (ctx->rac) /* same as readahead_gfp_mask */
 			gfp |= __GFP_NORETRY | __GFP_NOWARN;
-		ctx->bio = bio_alloc(gfp, min(BIO_MAX_PAGES, nr_vecs));
+		ctx->bio = bio_new(bdev, sector, op, opf, gfp, nr_vecs);
 		/*
 		 * If the bio_alloc fails, try it again for a single page to
 		 * avoid having to deal with partial page reads.  This emulates
 		 * what do_mpage_readpage does.
 		 */
 		if (!ctx->bio)
-			ctx->bio = bio_alloc(orig_gfp, 1);
-		ctx->bio->bi_opf = REQ_OP_READ;
-		if (ctx->rac)
-			ctx->bio->bi_opf |= REQ_RAHEAD;
-		ctx->bio->bi_iter.bi_sector = sector;
-		bio_set_dev(ctx->bio, iomap->bdev);
+			ctx->bio = bio_new(bdev, sector, op, opf, orig_gfp, 1);
 		ctx->bio->bi_end_io = iomap_read_end_io;
 	}
 
-- 
2.22.1


_______________________________________________
Ocfs2-devel mailing list
Ocfs2-devel@oss.oracle.com
https://oss.oracle.com/mailman/listinfo/ocfs2-devel
