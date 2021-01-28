Return-Path: <SRS0=lfe4=G7=oss.oracle.com=ocfs2-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.7 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C56CDC433DB
	for <ocfs2-devel@archiver.kernel.org>; Thu, 28 Jan 2021 07:29:12 +0000 (UTC)
Received: from aserp2120.oracle.com (aserp2120.oracle.com [141.146.126.78])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id 5004E64DD8
	for <ocfs2-devel@archiver.kernel.org>; Thu, 28 Jan 2021 07:29:11 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 5004E64DD8
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=wdc.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=ocfs2-devel-bounces@oss.oracle.com
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
	by aserp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 10S7OwNb064368;
	Thu, 28 Jan 2021 07:29:11 GMT
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
	by aserp2120.oracle.com with ESMTP id 368brktms3-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 28 Jan 2021 07:29:11 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
	by userp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 10S7QDOt096886;
	Thu, 28 Jan 2021 07:27:10 GMT
Received: from oss.oracle.com (oss-old-reserved.oracle.com [137.254.22.2])
	by userp3030.oracle.com with ESMTP id 368wqyw5vh-1
	(version=TLSv1 cipher=AES256-SHA bits=256 verify=NO);
	Thu, 28 Jan 2021 07:27:09 +0000
Received: from localhost ([127.0.0.1] helo=lb-oss.oracle.com)
	by oss.oracle.com with esmtp (Exim 4.63)
	(envelope-from <ocfs2-devel-bounces@oss.oracle.com>)
	id 1l51hs-0003ML-Ro; Wed, 27 Jan 2021 23:27:08 -0800
Received: from userp3030.oracle.com ([156.151.31.80])
	by oss.oracle.com with esmtp (Exim 4.63)
	(envelope-from <prvs=655a99766=chaitanya.kulkarni@wdc.com>)
	id 1l51TM-0002S9-JW
	for ocfs2-devel@oss.oracle.com; Wed, 27 Jan 2021 23:12:08 -0800
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
	by userp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id
	10S70FhH012219
	for <ocfs2-devel@oss.oracle.com>; Thu, 28 Jan 2021 07:12:08 GMT
Received: from userp2030.oracle.com (userp2030.oracle.com [156.151.31.89])
	by userp3030.oracle.com with ESMTP id 368wqyvpjq-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
	for <ocfs2-devel@oss.oracle.com>; Thu, 28 Jan 2021 07:12:08 +0000
Received: from pps.filterd (userp2030.oracle.com [127.0.0.1])
	by userp2030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id
	10S74LxY040567
	for <ocfs2-devel@oss.oracle.com>; Thu, 28 Jan 2021 07:12:07 GMT
Received: from esa1.hgst.iphmx.com (esa1.hgst.iphmx.com [68.232.141.245])
	by userp2030.oracle.com with ESMTP id 36bqd38wky-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256
	verify=FAIL)
	for <ocfs2-devel@oss.oracle.com>; Thu, 28 Jan 2021 07:12:07 +0000
IronPort-SDR: ERT/nnyqdcqLBfhuQtFsqRueHqVWEnu8bkNb9rIna99AXauVVcTrJa2PJFI1N1+mjCdKP0ODvn
	qZSFUHy6nPcpWYWtQaH7DTAVLJzV90ztRAVJFgOefjlbuKBmG1YXmJxTtM7LdXLIAmjGZRZBE6
	OoHGugbyXZZcVS1UJguc5+O4NHP+wOnbLThaHSEMRD71psxOgWALlpsyk1eOZiJ5JqF+Xq7gA0
	KppEZznsLHI0GCdm6/JZwWpHdw7yjbP3dxSf1iMhBZYVp9DVM5JHkbYwcgF3a/ElIb9ueEtQhL
	qks=
X-IronPort-AV: E=Sophos;i="5.79,381,1602518400"; d="scan'208";a="268892355"
Received: from h199-255-45-15.hgst.com (HELO uls-op-cesaep02.wdc.com)
	([199.255.45.15])
	by ob1.hgst.iphmx.com with ESMTP; 28 Jan 2021 15:12:06 +0800
IronPort-SDR: 4Bbj+g2YmXIxlx5npHOCOP4bHS5HUS0lZoE/MddPOc50LYShK3XnP6KtOLPYL/Jd6+SHW6Va2O
	Lc5PXe6ZW5t5Fom6vEFIrCqIn2CVxrYmIyfabfrmbQjtZGodpKAvGwsYr52Q6I2Yz2Nd1QGhj4
	N6al9QBcnu3tDz3uMw3gJfe7Zho1J8Xl+P3ISEa+QbDo3c66lKjHFqj20gJNzH0MguZAXpVIDh
	O46uJgQTXF5ZNykx7HtgLzMwD7Kk3dkBPVLNHCJu31VeunXRxOOXpFWAWqvFxkBV8Kk+BjUYPY
	JA/2DH5zNeLIGkinMit7r5vY
Received: from uls-op-cesaip02.wdc.com ([10.248.3.37])
	by uls-op-cesaep02.wdc.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384;
	27 Jan 2021 22:54:24 -0800
IronPort-SDR: d5xTirF8Ys37shQjxL90xQdmAvrvSyaDd23k+ldZQk6g8Gmyh3lDvEoGm16xcyp5mSBaZTpxOa
	PvC1PFp6twA2TpPlG+Ql+/AG65S9RMLgGFawcQCbg9J6k/x2AMPUiKYtsSCC84Z+EGYfmFKoID
	N3xp6Srvi9c6y+EZp98pFBd59WcY1NGSO1F5aHMorlNIT26uZMyL8pegMXpgjACziNosRf/+TT
	qFeHE9fwJbeXCBkPpJ7sXhYMSQdfV8ojzZIb3gXAYZT1zkKG2mcOAVOk/sf7gRxWJd9WgQISSA
	lhk=
WDCIronportException: Internal
Received: from vm.labspan.wdc.com (HELO vm.sc.wdc.com) ([10.6.137.102])
	by uls-op-cesaip02.wdc.com with ESMTP; 27 Jan 2021 23:12:06 -0800
From: Chaitanya Kulkarni <chaitanya.kulkarni@wdc.com>
To: linux-xfs@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        dm-devel@redhat.com, linux-block@vger.kernel.org,
        linux-kernel@vger.kernel.org, drbd-dev@lists.linbit.com,
        xen-devel@lists.xenproject.org, linux-nvme@lists.infradead.org,
        linux-scsi@vger.kernel.org, target-devel@vger.kernel.org,
        linux-fscrypt@vger.kernel.org, jfs-discussion@lists.sourceforge.net,
        linux-nilfs@vger.kernel.org, ocfs2-devel@oss.oracle.com,
        linux-pm@vger.kernel.org, linux-mm@kvack.org
Date: Wed, 27 Jan 2021 23:11:02 -0800
Message-Id: <20210128071133.60335-4-chaitanya.kulkarni@wdc.com>
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
	clxscore=212
	mlxlogscore=662 spamscore=0 bulkscore=0 mlxscore=0 adultscore=0
	lowpriorityscore=0 malwarescore=0 impostorscore=0 suspectscore=0
	priorityscore=100 classifier=spam adjust=0 reason=mlx scancount=1
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
Subject: [Ocfs2-devel] [RFC PATCH 03/34] drdb: use bio_new in drdb
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
 definitions=main-2101280035
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9877 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 impostorscore=0
 phishscore=0 bulkscore=0 priorityscore=1501 mlxlogscore=999
 lowpriorityscore=0 spamscore=0 mlxscore=0 suspectscore=0 malwarescore=0
 clxscore=1015 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2101280035

Signed-off-by: Chaitanya Kulkarni <chaitanya.kulkarni@wdc.com>
---
 drivers/block/drbd/drbd_receiver.c | 6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

diff --git a/drivers/block/drbd/drbd_receiver.c b/drivers/block/drbd/drbd_receiver.c
index 09c86ef3f0fd..e1cd3427b28b 100644
--- a/drivers/block/drbd/drbd_receiver.c
+++ b/drivers/block/drbd/drbd_receiver.c
@@ -1643,6 +1643,7 @@ int drbd_submit_peer_request(struct drbd_device *device,
 	struct bio *bio;
 	struct page *page = peer_req->pages;
 	sector_t sector = peer_req->i.sector;
+	struct block_device *bdev = device->ldev->backing_bdev;
 	unsigned data_size = peer_req->i.size;
 	unsigned n_bios = 0;
 	unsigned nr_pages = (data_size + PAGE_SIZE -1) >> PAGE_SHIFT;
@@ -1687,15 +1688,12 @@ int drbd_submit_peer_request(struct drbd_device *device,
 	 * generated bio, but a bio allocated on behalf of the peer.
 	 */
 next_bio:
-	bio = bio_alloc(GFP_NOIO, nr_pages);
+	bio = bio_new(bdev, sector, op, op_flags, GFP_NOIO, nr_pages);
 	if (!bio) {
 		drbd_err(device, "submit_ee: Allocation of a bio failed (nr_pages=%u)\n", nr_pages);
 		goto fail;
 	}
 	/* > peer_req->i.sector, unless this is the first bio */
-	bio->bi_iter.bi_sector = sector;
-	bio_set_dev(bio, device->ldev->backing_bdev);
-	bio_set_op_attrs(bio, op, op_flags);
 	bio->bi_private = peer_req;
 	bio->bi_end_io = drbd_peer_request_endio;
 
-- 
2.22.1


_______________________________________________
Ocfs2-devel mailing list
Ocfs2-devel@oss.oracle.com
https://oss.oracle.com/mailman/listinfo/ocfs2-devel
