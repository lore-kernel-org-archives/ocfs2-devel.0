Return-Path: <SRS0=lfe4=G7=oss.oracle.com=ocfs2-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.7 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5B93EC4332D
	for <ocfs2-devel@archiver.kernel.org>; Thu, 28 Jan 2021 07:27:14 +0000 (UTC)
Received: from aserp2120.oracle.com (aserp2120.oracle.com [141.146.126.78])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id DC82364DDC
	for <ocfs2-devel@archiver.kernel.org>; Thu, 28 Jan 2021 07:27:13 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org DC82364DDC
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=wdc.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=ocfs2-devel-bounces@oss.oracle.com
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
	by aserp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 10S7Os1l064330;
	Thu, 28 Jan 2021 07:27:12 GMT
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
	by aserp2120.oracle.com with ESMTP id 368brktmmu-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 28 Jan 2021 07:27:12 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
	by userp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 10S7QD6v096881;
	Thu, 28 Jan 2021 07:27:11 GMT
Received: from oss.oracle.com (oss-old-reserved.oracle.com [137.254.22.2])
	by userp3030.oracle.com with ESMTP id 368wqyw5wx-1
	(version=TLSv1 cipher=AES256-SHA bits=256 verify=NO);
	Thu, 28 Jan 2021 07:27:11 +0000
Received: from localhost ([127.0.0.1] helo=lb-oss.oracle.com)
	by oss.oracle.com with esmtp (Exim 4.63)
	(envelope-from <ocfs2-devel-bounces@oss.oracle.com>)
	id 1l51hu-0003Ts-9O; Wed, 27 Jan 2021 23:27:10 -0800
Received: from userp3020.oracle.com ([156.151.31.79])
	by oss.oracle.com with esmtp (Exim 4.63)
	(envelope-from <prvs=655a99766=chaitanya.kulkarni@wdc.com>)
	id 1l51VV-0002iR-4b
	for ocfs2-devel@oss.oracle.com; Wed, 27 Jan 2021 23:14:21 -0800
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
	by userp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id
	10S6xmIS017767
	for <ocfs2-devel@oss.oracle.com>; Thu, 28 Jan 2021 07:14:20 GMT
Received: from userp2030.oracle.com (userp2030.oracle.com [156.151.31.89])
	by userp3020.oracle.com with ESMTP id 368wjtmpgv-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
	for <ocfs2-devel@oss.oracle.com>; Thu, 28 Jan 2021 07:14:20 +0000
Received: from pps.filterd (userp2030.oracle.com [127.0.0.1])
	by userp2030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id
	10S74TPF040727
	for <ocfs2-devel@oss.oracle.com>; Thu, 28 Jan 2021 07:14:20 GMT
Received: from esa6.hgst.iphmx.com (esa6.hgst.iphmx.com [216.71.154.45])
	by userp2030.oracle.com with ESMTP id 36bqd38xcp-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256
	verify=FAIL)
	for <ocfs2-devel@oss.oracle.com>; Thu, 28 Jan 2021 07:14:20 +0000
IronPort-SDR: Qv0Sw/ZVgo0LnRajimyc9/rVD0H3jmg0HWrZEvGTq03mRlR9YOkI8dBGZO08m6B5BPT1k5s9iS
	Sz+f9XaMPVg28Dmqj3avA7Iy+IVmQT04ExGgKULEwev9/OFMtmKgRv4i8mb2fcotCUUdsknX8X
	ZNYnh7HoVahs44LnhFFkhnYfYQwKncn9oLwRD6TW5m6E1znsG5DtAZ+zzfzz3P5/74uliptXKx
	8e1fICZvewn7r6Sm/BTtOpajkxIhV8Mez2/V40eMEX1NClWUX+r26R6scRpbHzXpbXFvwycGn1
	IEU=
X-IronPort-AV: E=Sophos;i="5.79,381,1602518400"; d="scan'208";a="159693910"
Received: from h199-255-45-15.hgst.com (HELO uls-op-cesaep02.wdc.com)
	([199.255.45.15])
	by ob1.hgst.iphmx.com with ESMTP; 28 Jan 2021 15:14:18 +0800
IronPort-SDR: sl2C/BtLwNAvkUHZbhpC15Tuo302B9HMzBGahVcG8oTbISIKgsQCyjcwsen2qM9Q0uQT2fQdK4
	MSbOUixkG9acwR1WQUv5mIdtRDKUg882It7lucitu4q7ayrOxoCVHY8SybXCtnMkc6xmNDTuPE
	EEUMITc34WbSdeyrP3n7ALV9Wleogp2qihE3rH5WODozvyvxR+vHj+AFujKGuErFDTLLGRRTp7
	gFVeFvkpRKJrNpLLijnua+yv0dqJmwYtpcYyfE6adSX+Kuvg/HAeDNCTdhuGPQlm8ph4krteHU
	VDlCJVKG2iou5DdZpmq0EzqY
Received: from uls-op-cesaip02.wdc.com ([10.248.3.37])
	by uls-op-cesaep02.wdc.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384;
	27 Jan 2021 22:56:36 -0800
IronPort-SDR: SE/7jhzj8mUN4IuNpOkC3snrZ8NJ1clnXy6y5ds9FsX94ZBtriQ4uRa7QWKdGcnXbjLMCBoUCV
	muTlW54Qa3qPh6fwMtXMlfwP2+yfKLqOcAu45V7pI+dpenWI0L1OM9udcXtJMTQueAmHig5gDN
	d6OcRwyGrT7GxH48PliS/P58sqmLq3e242QCy6iyXTMgFXRd2EClUAs64FPFphS/GBkZYgQLMx
	xAByTj3G42kPYoeBIsWoRZMAgUwhHcuqehcOxGoJkKVhb66+D9X5hujEyFAgPHDC4Sd1jNsKev
	N7A=
WDCIronportException: Internal
Received: from vm.labspan.wdc.com (HELO vm.sc.wdc.com) ([10.6.137.102])
	by uls-op-cesaip02.wdc.com with ESMTP; 27 Jan 2021 23:14:18 -0800
From: Chaitanya Kulkarni <chaitanya.kulkarni@wdc.com>
To: linux-xfs@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        dm-devel@redhat.com, linux-block@vger.kernel.org,
        linux-kernel@vger.kernel.org, drbd-dev@lists.linbit.com,
        xen-devel@lists.xenproject.org, linux-nvme@lists.infradead.org,
        linux-scsi@vger.kernel.org, target-devel@vger.kernel.org,
        linux-fscrypt@vger.kernel.org, jfs-discussion@lists.sourceforge.net,
        linux-nilfs@vger.kernel.org, ocfs2-devel@oss.oracle.com,
        linux-pm@vger.kernel.org, linux-mm@kvack.org
Date: Wed, 27 Jan 2021 23:11:17 -0800
Message-Id: <20210128071133.60335-19-chaitanya.kulkarni@wdc.com>
X-Mailer: git-send-email 2.22.1
In-Reply-To: <20210128071133.60335-1-chaitanya.kulkarni@wdc.com>
References: <20210128071133.60335-1-chaitanya.kulkarni@wdc.com>
MIME-Version: 1.0
X-PDR: PASS
X-Source-IP: 216.71.154.45
X-ServerName: esa6.hgst.iphmx.com
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
	mlxlogscore=522 spamscore=0 bulkscore=0 mlxscore=0 adultscore=0
	lowpriorityscore=0 malwarescore=0 impostorscore=0 suspectscore=0
	priorityscore=173 classifier=spam adjust=0 reason=mlx scancount=1
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
Subject: [Ocfs2-devel] [RFC PATCH 18/34] iomap: use bio_new in
	iomap_dio_bio_actor
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
 fs/iomap/direct-io.c | 5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff --git a/fs/iomap/direct-io.c b/fs/iomap/direct-io.c
index f6c557a1bd25..0737192f7e5c 100644
--- a/fs/iomap/direct-io.c
+++ b/fs/iomap/direct-io.c
@@ -267,9 +267,8 @@ iomap_dio_bio_actor(struct inode *inode, loff_t pos, loff_t length,
 			goto out;
 		}
 
-		bio = bio_alloc(GFP_KERNEL, nr_pages);
-		bio_set_dev(bio, iomap->bdev);
-		bio->bi_iter.bi_sector = iomap_sector(iomap, pos);
+		bio = bio_new(iomap->bdev, iomap_sector(iomap, pos), 0, 0,
+			      nr_pages, GFP_KERNEL);
 		bio->bi_write_hint = dio->iocb->ki_hint;
 		bio->bi_ioprio = dio->iocb->ki_ioprio;
 		bio->bi_private = dio;
-- 
2.22.1


_______________________________________________
Ocfs2-devel mailing list
Ocfs2-devel@oss.oracle.com
https://oss.oracle.com/mailman/listinfo/ocfs2-devel
