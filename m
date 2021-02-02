Return-Path: <SRS0=xZbm=HE=oss.oracle.com=ocfs2-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.7 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 01098C433DB
	for <ocfs2-devel@archiver.kernel.org>; Tue,  2 Feb 2021 03:18:06 +0000 (UTC)
Received: from aserp2130.oracle.com (aserp2130.oracle.com [141.146.126.79])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id 6FC9964E9C
	for <ocfs2-devel@archiver.kernel.org>; Tue,  2 Feb 2021 03:18:05 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 6FC9964E9C
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=linux.alibaba.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=ocfs2-devel-bounces@oss.oracle.com
Received: from pps.filterd (aserp2130.oracle.com [127.0.0.1])
	by aserp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 11239sGO019459;
	Tue, 2 Feb 2021 03:18:04 GMT
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
	by aserp2130.oracle.com with ESMTP id 36cvyarqqj-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 02 Feb 2021 03:18:04 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
	by userp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 1123GCfW063367;
	Tue, 2 Feb 2021 03:18:03 GMT
Received: from oss.oracle.com (oss-old-reserved.oracle.com [137.254.22.2])
	by userp3020.oracle.com with ESMTP id 36dh7qrnjg-1
	(version=TLSv1 cipher=AES256-SHA bits=256 verify=NO);
	Tue, 02 Feb 2021 03:18:03 +0000
Received: from localhost ([127.0.0.1] helo=lb-oss.oracle.com)
	by oss.oracle.com with esmtp (Exim 4.63)
	(envelope-from <ocfs2-devel-bounces@oss.oracle.com>)
	id 1l6mCY-0002Gp-8o; Mon, 01 Feb 2021 19:18:02 -0800
Received: from aserp3020.oracle.com ([141.146.126.70])
	by oss.oracle.com with esmtp (Exim 4.63)
	(envelope-from <jiapeng.chong@linux.alibaba.com>) id 1l6m5g-0001t6-8n
	for ocfs2-devel@oss.oracle.com; Mon, 01 Feb 2021 19:10:56 -0800
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
	by aserp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id
	1123At8w068478
	for <ocfs2-devel@oss.oracle.com>; Tue, 2 Feb 2021 03:10:56 GMT
Received: from userp2030.oracle.com (userp2030.oracle.com [156.151.31.89])
	by aserp3020.oracle.com with ESMTP id 36dhbxk8y8-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
	for <ocfs2-devel@oss.oracle.com>; Tue, 02 Feb 2021 03:10:55 +0000
Received: from pps.filterd (userp2030.oracle.com [127.0.0.1])
	by userp2030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id
	11234vHn044489
	for <ocfs2-devel@oss.oracle.com>; Tue, 2 Feb 2021 03:10:44 GMT
Received: from out30-42.freemail.mail.aliyun.com
	(out30-42.freemail.mail.aliyun.com [115.124.30.42])
	by userp2030.oracle.com with ESMTP id 36dutaab1c-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO)
	for <ocfs2-devel@oss.oracle.com>; Tue, 02 Feb 2021 03:10:43 +0000
X-Alimail-AntiSpam: AC=PASS; BC=-1|-1; BR=01201311R621e4; CH=green; DM=||false|;
	DS=||; FP=0|-1|-1|-1|0|-1|-1|-1; HT=e01e04420;
	MF=jiapeng.chong@linux.alibaba.com; NM=1; PH=DS; RN=6; SR=0;
	TI=SMTPD_---0UNdnZbK_1612235426; 
Received: from
	j63c13417.sqa.eu95.tbsite.net(mailfrom:jiapeng.chong@linux.alibaba.com
	fp:SMTPD_---0UNdnZbK_1612235426) by smtp.aliyun-inc.com(127.0.0.1);
	Tue, 02 Feb 2021 11:10:38 +0800
From: Jiapeng Chong <jiapeng.chong@linux.alibaba.com>
To: mark@fasheh.com
Date: Tue,  2 Feb 2021 11:10:24 +0800
Message-Id: <1612235424-80367-1-git-send-email-jiapeng.chong@linux.alibaba.com>
X-Mailer: git-send-email 1.8.3.1
X-PDR: PASS
X-Source-IP: 115.124.30.42
X-ServerName: out30-42.freemail.mail.aliyun.com
X-Proofpoint-SPF-Result: pass
X-Proofpoint-SPF-Record: v=spf1 include:spf1.service.alibaba.com
	include:spf2.service.alibaba.com
	include:spf1.ocm.aliyun.com  include:spf2.ocm.aliyun.com
	include:spf1.staff.mail.aliyun.com include:a.hichina.mail.aliyun.com
	include:b.hichina.mail.aliyun.com -all
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9882
	signatures=668683
X-Proofpoint-Spam-Details: rule=tap_notspam policy=tap score=0 suspectscore=0
	impostorscore=0
	phishscore=0 mlxlogscore=999 mlxscore=0 bulkscore=0 adultscore=0
	lowpriorityscore=0 clxscore=299 malwarescore=0 spamscore=0
	priorityscore=90 classifier=spam adjust=0 reason=mlx scancount=1
	engine=8.12.0-2009150000 definitions=main-2102020022
X-Spam: Clean
X-Mailman-Approved-At: Mon, 01 Feb 2021 19:18:01 -0800
Cc: Jiapeng Chong <jiapeng.chong@linux.alibaba.com>,
        ocfs2-devel@oss.oracle.com, linux-kernel@vger.kernel.org
Subject: [Ocfs2-devel] [PATCH] ocfs2: Simplify the calculation of variables
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
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Sender: ocfs2-devel-bounces@oss.oracle.com
Errors-To: ocfs2-devel-bounces@oss.oracle.com
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9882 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 mlxscore=0
 suspectscore=0 spamscore=0 mlxlogscore=999 phishscore=0 adultscore=0
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2102020024
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9882 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 clxscore=1034 impostorscore=0
 mlxscore=0 spamscore=0 bulkscore=0 priorityscore=1501 adultscore=0
 lowpriorityscore=0 malwarescore=0 phishscore=0 mlxlogscore=999
 suspectscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2102020023

Fix the following coccicheck warnings:

./fs/ocfs2/refcounttree.c:981:16-18: WARNING !A || A && B is equivalent
to !A || B.

Reported-by: Abaci Robot <abaci@linux.alibaba.com>
Signed-off-by: Jiapeng Chong <jiapeng.chong@linux.alibaba.com>
---
 fs/ocfs2/refcounttree.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/ocfs2/refcounttree.c b/fs/ocfs2/refcounttree.c
index 3b397fa..115365e85 100644
--- a/fs/ocfs2/refcounttree.c
+++ b/fs/ocfs2/refcounttree.c
@@ -978,7 +978,7 @@ static int ocfs2_get_refcount_cpos_end(struct ocfs2_caching_info *ci,
 		return 0;
 	}
 
-	if (!eb || (eb && !eb->h_next_leaf_blk)) {
+	if (!eb || !eb->h_next_leaf_blk) {
 		/*
 		 * We are the last extent rec, so any high cpos should
 		 * be stored in this leaf refcount block.
-- 
1.8.3.1


_______________________________________________
Ocfs2-devel mailing list
Ocfs2-devel@oss.oracle.com
https://oss.oracle.com/mailman/listinfo/ocfs2-devel
