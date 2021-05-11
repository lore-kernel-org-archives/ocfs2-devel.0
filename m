Return-Path: <SRS0=8K4+=KI=oss.oracle.com=ocfs2-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E9BF7C433B4
	for <ocfs2-devel@archiver.kernel.org>; Thu, 13 May 2021 15:01:17 +0000 (UTC)
Received: from aserp2120.oracle.com (aserp2120.oracle.com [141.146.126.78])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id 7DB9E61439
	for <ocfs2-devel@archiver.kernel.org>; Thu, 13 May 2021 15:01:17 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 7DB9E61439
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=huawei.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=ocfs2-devel-bounces@oss.oracle.com
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
	by aserp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 14DF0Uhx086948;
	Thu, 13 May 2021 15:01:16 GMT
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
	by aserp2120.oracle.com with ESMTP id 38gpnxsxqe-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 13 May 2021 15:01:16 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
	by userp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 14DExkda022787;
	Thu, 13 May 2021 15:01:15 GMT
Received: from oss.oracle.com (oss-old-reserved.oracle.com [137.254.22.2])
	by userp3030.oracle.com with ESMTP id 38gpq23pq4-1
	(version=TLSv1 cipher=AES256-SHA bits=256 verify=NO);
	Thu, 13 May 2021 15:01:15 +0000
Received: from localhost ([127.0.0.1] helo=lb-oss.oracle.com)
	by oss.oracle.com with esmtp (Exim 4.63)
	(envelope-from <ocfs2-devel-bounces@oss.oracle.com>)
	id 1lhCpu-0003eI-Hk; Thu, 13 May 2021 08:01:14 -0700
Received: from userp3030.oracle.com ([156.151.31.80])
	by oss.oracle.com with esmtp (Exim 4.63)
	(envelope-from <yangyingliang@huawei.com>) id 1lgR02-00051E-U3
	for ocfs2-devel@oss.oracle.com; Tue, 11 May 2021 04:56:31 -0700
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
	by userp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id
	14BBtbdE079174
	for <ocfs2-devel@oss.oracle.com>; Tue, 11 May 2021 11:56:30 GMT
Received: from oracle.com (userp2040.oracle.com [156.151.31.90])
	by userp3030.oracle.com with ESMTP id 38dfrx4sav-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
	for <ocfs2-devel@oss.oracle.com>; Tue, 11 May 2021 11:56:30 +0000
Received: from userp2040.oracle.com (userp2040.oracle.com [127.0.0.1])
	by pps.ucf-imr (8.16.0.36/8.16.0.36) with SMTP id 14BBsR7M032391
	for <ocfs2-devel@oss.oracle.com>; Tue, 11 May 2021 11:56:30 GMT
Received: from szxga04-in.huawei.com (szxga04-in.huawei.com [45.249.212.190])
	by userp2040.oracle.com with ESMTP id 38evq0vqte-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO)
	for <ocfs2-devel@oss.oracle.com>; Tue, 11 May 2021 11:56:28 +0000
Received: from DGGEMS402-HUB.china.huawei.com (unknown [172.30.72.58])
	by szxga04-in.huawei.com (SkyGuard) with ESMTP id 4Ffbsy1kp7z1BKqR;
	Tue, 11 May 2021 19:53:42 +0800 (CST)
Received: from huawei.com (10.175.103.91) by DGGEMS402-HUB.china.huawei.com
	(10.3.19.202) with Microsoft SMTP Server id 14.3.498.0; Tue, 11 May 2021
	19:56:19 +0800
From: Yang Yingliang <yangyingliang@huawei.com>
To: <linux-kernel@vger.kernel.org>, <ocfs2-devel@oss.oracle.com>
Date: Tue, 11 May 2021 19:58:47 +0800
Message-ID: <20210511115847.3817395-1-yangyingliang@huawei.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
X-Originating-IP: [10.175.103.91]
X-CFilter-Loop: Reflected
X-PDR: PASS
X-Source-IP: 45.249.212.190
X-ServerName: szxga04-in.huawei.com
X-Proofpoint-SPF-Result: pass
X-Proofpoint-SPF-Record: v=spf1 ip4:45.249.212.32 ip4:45.249.212.35
	ip4:45.249.212.255
	ip4:45.249.212.187/29 ip4:45.249.212.191 ip4:185.176.76.210
	ip4:168.195.93.47 ip4:103.69.140.247 ip4:185.176.79.56 -all
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9980
	signatures=668683
X-Proofpoint-Spam-Details: rule=tap_notspam policy=tap score=0 malwarescore=0
	suspectscore=0
	mlxlogscore=947 lowpriorityscore=0 adultscore=0 mlxscore=0 bulkscore=0
	impostorscore=0 phishscore=0 clxscore=283 priorityscore=421 spamscore=0
	classifier=spam adjust=0 reason=mlx scancount=1
	engine=8.12.0-2104190000 definitions=main-2105110093
X-Spam: Clean
X-Mailman-Approved-At: Thu, 13 May 2021 08:01:13 -0700
Subject: [Ocfs2-devel] [PATCH -next] ocfs2: Remove unnecessary
	INIT_LIST_HEAD()
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
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9982 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 suspectscore=0
 malwarescore=0 spamscore=0 mlxscore=0 adultscore=0 bulkscore=0
 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2104190000 definitions=main-2105130110
X-Proofpoint-GUID: N1LS31a9vq-Y5msVwRXKFdQ1L6G1h6-r
X-Proofpoint-ORIG-GUID: N1LS31a9vq-Y5msVwRXKFdQ1L6G1h6-r
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9982 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 lowpriorityscore=0 bulkscore=0
 adultscore=0 priorityscore=1501 phishscore=0 malwarescore=0 spamscore=0
 impostorscore=0 mlxlogscore=999 mlxscore=0 clxscore=1011 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2104190000
 definitions=main-2105130110

The list_head o2hb_node_events is initialized statically.
It is unnecessary to initialize by INIT_LIST_HEAD().

Reported-by: Hulk Robot <hulkci@huawei.com>
Signed-off-by: Yang Yingliang <yangyingliang@huawei.com>
---
 fs/ocfs2/cluster/heartbeat.c | 2 --
 1 file changed, 2 deletions(-)

diff --git a/fs/ocfs2/cluster/heartbeat.c b/fs/ocfs2/cluster/heartbeat.c
index e829c2595543..1169c8dc9106 100644
--- a/fs/ocfs2/cluster/heartbeat.c
+++ b/fs/ocfs2/cluster/heartbeat.c
@@ -1442,8 +1442,6 @@ void o2hb_init(void)
 	for (i = 0; i < ARRAY_SIZE(o2hb_live_slots); i++)
 		INIT_LIST_HEAD(&o2hb_live_slots[i]);
 
-	INIT_LIST_HEAD(&o2hb_node_events);
-
 	memset(o2hb_live_node_bitmap, 0, sizeof(o2hb_live_node_bitmap));
 	memset(o2hb_region_bitmap, 0, sizeof(o2hb_region_bitmap));
 	memset(o2hb_live_region_bitmap, 0, sizeof(o2hb_live_region_bitmap));
-- 
2.25.1


_______________________________________________
Ocfs2-devel mailing list
Ocfs2-devel@oss.oracle.com
https://oss.oracle.com/mailman/listinfo/ocfs2-devel
