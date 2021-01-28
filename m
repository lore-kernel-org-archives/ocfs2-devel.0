Return-Path: <SRS0=lfe4=G7=oss.oracle.com=ocfs2-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.7 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 454FFC433E9
	for <ocfs2-devel@archiver.kernel.org>; Thu, 28 Jan 2021 08:14:11 +0000 (UTC)
Received: from aserp2130.oracle.com (aserp2130.oracle.com [141.146.126.79])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id C89A064DA1
	for <ocfs2-devel@archiver.kernel.org>; Thu, 28 Jan 2021 08:14:10 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org C89A064DA1
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=wdc.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=ocfs2-devel-bounces@oss.oracle.com
Received: from pps.filterd (aserp2130.oracle.com [127.0.0.1])
	by aserp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 10S89NAO189357;
	Thu, 28 Jan 2021 08:14:09 GMT
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
	by aserp2130.oracle.com with ESMTP id 3689aau19h-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 28 Jan 2021 08:14:09 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
	by userp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 10S8Bo4g106963;
	Thu, 28 Jan 2021 08:12:08 GMT
Received: from oss.oracle.com (oss-old-reserved.oracle.com [137.254.22.2])
	by userp3020.oracle.com with ESMTP id 368wjtq3ab-1
	(version=TLSv1 cipher=AES256-SHA bits=256 verify=NO);
	Thu, 28 Jan 2021 08:12:08 +0000
Received: from localhost ([127.0.0.1] helo=lb-oss.oracle.com)
	by oss.oracle.com with esmtp (Exim 4.63)
	(envelope-from <ocfs2-devel-bounces@oss.oracle.com>)
	id 1l51hu-0003UO-CX; Wed, 27 Jan 2021 23:27:10 -0800
Received: from aserp3020.oracle.com ([141.146.126.70])
	by oss.oracle.com with esmtp (Exim 4.63)
	(envelope-from <prvs=655a99766=chaitanya.kulkarni@wdc.com>)
	id 1l51Ve-0002jK-P5
	for ocfs2-devel@oss.oracle.com; Wed, 27 Jan 2021 23:14:30 -0800
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
	by aserp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id
	10S70dN5177404
	for <ocfs2-devel@oss.oracle.com>; Thu, 28 Jan 2021 07:14:30 GMT
Received: from userp2030.oracle.com (userp2030.oracle.com [156.151.31.89])
	by aserp3020.oracle.com with ESMTP id 368wq195p1-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
	for <ocfs2-devel@oss.oracle.com>; Thu, 28 Jan 2021 07:14:30 +0000
Received: from pps.filterd (userp2030.oracle.com [127.0.0.1])
	by userp2030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id
	10S74NdD040630
	for <ocfs2-devel@oss.oracle.com>; Thu, 28 Jan 2021 07:14:29 GMT
Received: from esa1.hgst.iphmx.com (esa1.hgst.iphmx.com [68.232.141.245])
	by userp2030.oracle.com with ESMTP id 36bqd38xee-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256
	verify=FAIL)
	for <ocfs2-devel@oss.oracle.com>; Thu, 28 Jan 2021 07:14:29 +0000
IronPort-SDR: 6CIVDboiL67HnNJ9nr2sm4CAztMW6aGHJk+AdWYGP085zgamukHUkmQAVOtGU+GBsOAeBHVhAQ
	wJ+zT6o4f5ShzepspTAWVVKU7+4Ksqj1tv7iJkiOHUoLez3UFBZLKD4LoSks3ASbu5xMPZRW7c
	B8OKdvQceopUPK89+bHeeIGYm6TKy/W2rMHPZf37FzBqLC2szFLbfRmJh2cvxjt7/lmt4xs+TB
	rs7DO0ZBTLAi6zhrsciby2eda+JC5LZcedflod7s3tsM/Vl3oqfni3iE5gqZptqH7toM0dncIp
	cVI=
X-IronPort-AV: E=Sophos;i="5.79,381,1602518400"; d="scan'208";a="268892557"
Received: from h199-255-45-15.hgst.com (HELO uls-op-cesaep02.wdc.com)
	([199.255.45.15])
	by ob1.hgst.iphmx.com with ESMTP; 28 Jan 2021 15:14:27 +0800
IronPort-SDR: uZmoD8ZVlA6f4mZmX0EXBFGTz7Y+sIke66KL/fotBPNdza5wdNyy8VS2lsGs7C8B8NfmybORKS
	YrcWRdCwkRmb3dain/UlYaWpCFmhtckp89V3+i/IQ31yT7lA/qMuYdMiGDad3SPC7xNHJHPL4w
	yfVFk9vIWc086aVEqGhQaZNJkiKjTXYiz5UWL70/nUUle06U7KhFa3pQvNohH12MCXHqEL7zJU
	Z3tRsdKYJP/vK1rbE7A/8X3FkglLJED/AsxbREF635kihFmJp4dgrQi6CilLzGDVWnnXKNkzzp
	kCmrBUpak1W+QNAmypDPaqB8
Received: from uls-op-cesaip02.wdc.com ([10.248.3.37])
	by uls-op-cesaep02.wdc.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384;
	27 Jan 2021 22:56:44 -0800
IronPort-SDR: 8zWpKV1GG73An1zpnhB0A6RHwKcvj53Vuxf9sCqOuA5ZBa5rmYze0QOVvU8HXRv/G7xpZnMIM1
	owK+1cH03BzVuf34Vf4nPTxb3MJRxKHU7MPVsfYKBvoE5U6OUm3WvlKRFiuZT6me2l9YBpl9Dw
	srBAVfHgvdy6RitQaBWTWMkJB+swHKrWKKu/bnpunnMHs5/vTt80z06ovpDFKB7vDmFytTZ38T
	a/jEmxYBTtNgI1MsJxovm0Lez6j5sfQFarO3Hedm9NgwCWDpXDWzTcx88c/FgbEiOtdVVLfaVV
	avQ=
WDCIronportException: Internal
Received: from vm.labspan.wdc.com (HELO vm.sc.wdc.com) ([10.6.137.102])
	by uls-op-cesaip02.wdc.com with ESMTP; 27 Jan 2021 23:14:26 -0800
From: Chaitanya Kulkarni <chaitanya.kulkarni@wdc.com>
To: linux-xfs@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        dm-devel@redhat.com, linux-block@vger.kernel.org,
        linux-kernel@vger.kernel.org, drbd-dev@lists.linbit.com,
        xen-devel@lists.xenproject.org, linux-nvme@lists.infradead.org,
        linux-scsi@vger.kernel.org, target-devel@vger.kernel.org,
        linux-fscrypt@vger.kernel.org, jfs-discussion@lists.sourceforge.net,
        linux-nilfs@vger.kernel.org, ocfs2-devel@oss.oracle.com,
        linux-pm@vger.kernel.org, linux-mm@kvack.org
Date: Wed, 27 Jan 2021 23:11:18 -0800
Message-Id: <20210128071133.60335-20-chaitanya.kulkarni@wdc.com>
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
	mlxlogscore=593 spamscore=0 bulkscore=0 mlxscore=0 adultscore=0
	lowpriorityscore=0 malwarescore=0 impostorscore=0 suspectscore=0
	priorityscore=194 classifier=spam adjust=0 reason=mlx scancount=1
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
Subject: [Ocfs2-devel] [RFC PATCH 19/34] fs/jfs/jfs_logmgr.c: use bio_new in
	lbmRead
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
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 suspectscore=0
 adultscore=0 mlxscore=0 malwarescore=0 spamscore=0 mlxlogscore=999
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2101280040
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9877 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 adultscore=0
 lowpriorityscore=0 mlxlogscore=999 clxscore=1015 phishscore=0 bulkscore=0
 spamscore=0 priorityscore=1501 mlxscore=0 suspectscore=0 impostorscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2101280040

Signed-off-by: Chaitanya Kulkarni <chaitanya.kulkarni@wdc.com>
---
 fs/jfs/jfs_logmgr.c | 7 ++-----
 1 file changed, 2 insertions(+), 5 deletions(-)

diff --git a/fs/jfs/jfs_logmgr.c b/fs/jfs/jfs_logmgr.c
index 9330eff210e0..4481f3e33a3f 100644
--- a/fs/jfs/jfs_logmgr.c
+++ b/fs/jfs/jfs_logmgr.c
@@ -1979,17 +1979,14 @@ static int lbmRead(struct jfs_log * log, int pn, struct lbuf ** bpp)
 
 	bp->l_flag |= lbmREAD;
 
-	bio = bio_alloc(GFP_NOFS, 1);
-
-	bio->bi_iter.bi_sector = bp->l_blkno << (log->l2bsize - 9);
-	bio_set_dev(bio, log->bdev);
+	bio = bio_new(log->bdev, bp->l_blkno << (log->l2bsize - 9),
+			REQ_OP_READ, 0, 1, GFP_NOFS);
 
 	bio_add_page(bio, bp->l_page, LOGPSIZE, bp->l_offset);
 	BUG_ON(bio->bi_iter.bi_size != LOGPSIZE);
 
 	bio->bi_end_io = lbmIODone;
 	bio->bi_private = bp;
-	bio->bi_opf = REQ_OP_READ;
 	/*check if journaling to disk has been disabled*/
 	if (log->no_integrity) {
 		bio->bi_iter.bi_size = 0;
-- 
2.22.1


_______________________________________________
Ocfs2-devel mailing list
Ocfs2-devel@oss.oracle.com
https://oss.oracle.com/mailman/listinfo/ocfs2-devel
