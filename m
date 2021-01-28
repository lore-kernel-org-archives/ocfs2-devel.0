Return-Path: <SRS0=lfe4=G7=oss.oracle.com=ocfs2-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.7 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 187B4C43381
	for <ocfs2-devel@archiver.kernel.org>; Thu, 28 Jan 2021 07:27:14 +0000 (UTC)
Received: from aserp2130.oracle.com (aserp2130.oracle.com [141.146.126.79])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id 9153564DDB
	for <ocfs2-devel@archiver.kernel.org>; Thu, 28 Jan 2021 07:27:13 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 9153564DDB
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=wdc.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=ocfs2-devel-bounces@oss.oracle.com
Received: from pps.filterd (aserp2130.oracle.com [127.0.0.1])
	by aserp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 10S7PSFo114823;
	Thu, 28 Jan 2021 07:27:11 GMT
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
	by aserp2130.oracle.com with ESMTP id 3689aatvuc-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 28 Jan 2021 07:27:11 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
	by userp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 10S7QD9Q096930;
	Thu, 28 Jan 2021 07:27:10 GMT
Received: from oss.oracle.com (oss-old-reserved.oracle.com [137.254.22.2])
	by userp3030.oracle.com with ESMTP id 368wqyw5wa-1
	(version=TLSv1 cipher=AES256-SHA bits=256 verify=NO);
	Thu, 28 Jan 2021 07:27:10 +0000
Received: from localhost ([127.0.0.1] helo=lb-oss.oracle.com)
	by oss.oracle.com with esmtp (Exim 4.63)
	(envelope-from <ocfs2-devel-bounces@oss.oracle.com>)
	id 1l51ht-0003Qt-Oj; Wed, 27 Jan 2021 23:27:09 -0800
Received: from userp3020.oracle.com ([156.151.31.79])
	by oss.oracle.com with esmtp (Exim 4.63)
	(envelope-from <prvs=655a99766=chaitanya.kulkarni@wdc.com>)
	id 1l51Uj-0002dS-N2
	for ocfs2-devel@oss.oracle.com; Wed, 27 Jan 2021 23:13:33 -0800
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
	by userp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id
	10S6xm1j017744
	for <ocfs2-devel@oss.oracle.com>; Thu, 28 Jan 2021 07:13:33 GMT
Received: from userp2030.oracle.com (userp2030.oracle.com [156.151.31.89])
	by userp3020.oracle.com with ESMTP id 368wjtmnue-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
	for <ocfs2-devel@oss.oracle.com>; Thu, 28 Jan 2021 07:13:33 +0000
Received: from pps.filterd (userp2030.oracle.com [127.0.0.1])
	by userp2030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id
	10S74TP6040727
	for <ocfs2-devel@oss.oracle.com>; Thu, 28 Jan 2021 07:13:32 GMT
Received: from esa3.hgst.iphmx.com (esa3.hgst.iphmx.com [216.71.153.141])
	by userp2030.oracle.com with ESMTP id 36bqd38x69-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256
	verify=FAIL)
	for <ocfs2-devel@oss.oracle.com>; Thu, 28 Jan 2021 07:13:32 +0000
IronPort-SDR: sjLcRD7MCFYUbEsJ3gHTe8npWPgAIvKEisJe2BEC3zrcCgYfQx/ZkG2V+vqOQ/FRTd1y70Uw1P
	oy/CwRdxtPhkq7/g4DEJn2rflzXRFzC3CtLzaZKiOauezMXm1pkmzgwkdrYN6o07jELegjTEbR
	/G2TcKQiIyy5f/Qrg8E5xaDyLG/pJMOG/QmvZCyLSYwP18j8fi3sCbJRwouaAlf0N+VmvbVaG8
	XZ/kB1xJNqDLop8llWgiHw0dLtKwco157Z5nnKp3r166i8hktI/SbZP0o9QXRGzoTe7vMYW+1A
	NqA=
X-IronPort-AV: E=Sophos;i="5.79,381,1602518400"; d="scan'208";a="162963241"
Received: from h199-255-45-14.hgst.com (HELO uls-op-cesaep01.wdc.com)
	([199.255.45.14])
	by ob1.hgst.iphmx.com with ESMTP; 28 Jan 2021 15:13:31 +0800
IronPort-SDR: lRLJ1gvql69/s01C0vNUAQTu5HeUBiuANfv4jbaPEM4AqPbDCImclQ401e6yvLYy045jTf1Ibc
	yIXvkYwj5E+T4FQqN6NvfbdbQK4G9pVMxOzFGNigShtxYCgNsRGwKE2ZglXk5rO7XJZ82ixK7i
	Md/2DA/9D8Xdyoa+jp8wY8acnNF933f1W0RkbhGfFLqI7xSRZzCY4OjNiV25bXPB0+DT2qFis7
	DDBSv3IWfxTk8WLMa4AHbDMOIDMqcF3fRwD3IlKUaxqCq0D8oQh8kgsfT/YxjYzbv8qRmyCPx3
	dr+2S+yfxfYx8M5Vrdyj5cA0
Received: from uls-op-cesaip02.wdc.com ([10.248.3.37])
	by uls-op-cesaep01.wdc.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384;
	27 Jan 2021 22:57:51 -0800
IronPort-SDR: VOVmzSzF+PFJ5cIlwEfer9zopXRJVevtkqTAdV/vkmWi5tqY25x0d3LuGTyYENdxWXzay1z5UI
	3lglUXeUdXrgV2kjosRDVsxHgPX3JmYCMkybSp7dVFiY2NtJizGeP3Ns2Zua+ztPSx29L5AtLA
	s1r4WqMcMEF5NenjfW/yptNoTwylDj+qb8oKvyina3WsNVkg0wovZeJk89NSPRf5yUzOMPXVB7
	hd4QqToWmHIoH7o5yPqPfXS+LYwCHRus+XuP8hoEESu425XNxiI+t6Xi0EnlRBN9AYDyemp/IQ
	NGk=
WDCIronportException: Internal
Received: from vm.labspan.wdc.com (HELO vm.sc.wdc.com) ([10.6.137.102])
	by uls-op-cesaip02.wdc.com with ESMTP; 27 Jan 2021 23:13:31 -0800
From: Chaitanya Kulkarni <chaitanya.kulkarni@wdc.com>
To: linux-xfs@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        dm-devel@redhat.com, linux-block@vger.kernel.org,
        linux-kernel@vger.kernel.org, drbd-dev@lists.linbit.com,
        xen-devel@lists.xenproject.org, linux-nvme@lists.infradead.org,
        linux-scsi@vger.kernel.org, target-devel@vger.kernel.org,
        linux-fscrypt@vger.kernel.org, jfs-discussion@lists.sourceforge.net,
        linux-nilfs@vger.kernel.org, ocfs2-devel@oss.oracle.com,
        linux-pm@vger.kernel.org, linux-mm@kvack.org
Date: Wed, 27 Jan 2021 23:11:11 -0800
Message-Id: <20210128071133.60335-13-chaitanya.kulkarni@wdc.com>
X-Mailer: git-send-email 2.22.1
In-Reply-To: <20210128071133.60335-1-chaitanya.kulkarni@wdc.com>
References: <20210128071133.60335-1-chaitanya.kulkarni@wdc.com>
MIME-Version: 1.0
X-PDR: PASS
X-Source-IP: 216.71.153.141
X-ServerName: esa3.hgst.iphmx.com
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
	mlxlogscore=636 spamscore=0 bulkscore=0 mlxscore=0 adultscore=0
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
Subject: [Ocfs2-devel] [RFC PATCH 12/34] scsi: target/iblock: use bio_new
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
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 adultscore=0
 lowpriorityscore=0 mlxlogscore=999 clxscore=1015 phishscore=0 bulkscore=0
 spamscore=0 priorityscore=1501 mlxscore=0 suspectscore=0 impostorscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2101280035

Signed-off-by: Chaitanya Kulkarni <chaitanya.kulkarni@wdc.com>
---
 drivers/target/target_core_iblock.c | 5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff --git a/drivers/target/target_core_iblock.c b/drivers/target/target_core_iblock.c
index 8ed93fd205c7..f1264918aee1 100644
--- a/drivers/target/target_core_iblock.c
+++ b/drivers/target/target_core_iblock.c
@@ -379,10 +379,9 @@ iblock_execute_sync_cache(struct se_cmd *cmd)
 	if (immed)
 		target_complete_cmd(cmd, SAM_STAT_GOOD);
 
-	bio = bio_alloc(GFP_KERNEL, 0);
+	bio = bio_new(ib_dev->ibd_bd, 0, REQ_OP_WRITE, REQ_PREFLUSH, 0,
+		      GFP_KERNEL);
 	bio->bi_end_io = iblock_end_io_flush;
-	bio_set_dev(bio, ib_dev->ibd_bd);
-	bio->bi_opf = REQ_OP_WRITE | REQ_PREFLUSH;
 	if (!immed)
 		bio->bi_private = cmd;
 	submit_bio(bio);
-- 
2.22.1


_______________________________________________
Ocfs2-devel mailing list
Ocfs2-devel@oss.oracle.com
https://oss.oracle.com/mailman/listinfo/ocfs2-devel
