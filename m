Return-Path: <SRS0=QTdx=HG=oss.oracle.com=ocfs2-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.7 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4B847C433DB
	for <ocfs2-devel@archiver.kernel.org>; Thu,  4 Feb 2021 11:15:02 +0000 (UTC)
Received: from aserp2120.oracle.com (aserp2120.oracle.com [141.146.126.78])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id A31F064F58
	for <ocfs2-devel@archiver.kernel.org>; Thu,  4 Feb 2021 11:15:01 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org A31F064F58
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=linux.alibaba.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=ocfs2-devel-bounces@oss.oracle.com
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
	by aserp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 114BF0K2093350;
	Thu, 4 Feb 2021 11:15:00 GMT
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
	by aserp2120.oracle.com with ESMTP id 36cydm4p8u-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 04 Feb 2021 11:15:00 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
	by userp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 114B0Ksr143940;
	Thu, 4 Feb 2021 11:12:54 GMT
Received: from oss.oracle.com (oss-old-reserved.oracle.com [137.254.22.2])
	by userp3020.oracle.com with ESMTP id 36dh7v0j7q-1
	(version=TLSv1 cipher=AES256-SHA bits=256 verify=NO);
	Thu, 04 Feb 2021 11:12:54 +0000
Received: from localhost ([127.0.0.1] helo=lb-oss.oracle.com)
	by oss.oracle.com with esmtp (Exim 4.63)
	(envelope-from <ocfs2-devel-bounces@oss.oracle.com>)
	id 1l7cZA-0005AV-GX; Thu, 04 Feb 2021 03:12:52 -0800
Received: from aserp3030.oracle.com ([141.146.126.71])
	by oss.oracle.com with esmtp (Exim 4.63)
	(envelope-from <yang.lee@linux.alibaba.com>) id 1l7V40-00046B-HI
	for ocfs2-devel@oss.oracle.com; Wed, 03 Feb 2021 19:12:12 -0800
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
	by aserp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id
	1142temB143606
	for <ocfs2-devel@oss.oracle.com>; Thu, 4 Feb 2021 03:12:12 GMT
Received: from userp2040.oracle.com (userp2040.oracle.com [156.151.31.90])
	by aserp3030.oracle.com with ESMTP id 36dh1rupwe-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
	for <ocfs2-devel@oss.oracle.com>; Thu, 04 Feb 2021 03:12:12 +0000
Received: from pps.filterd (userp2040.oracle.com [127.0.0.1])
	by userp2040.oracle.com (8.16.0.42/8.16.0.42) with SMTP id
	11434qkf039070
	for <ocfs2-devel@oss.oracle.com>; Thu, 4 Feb 2021 03:12:11 GMT
Received: from out30-131.freemail.mail.aliyun.com
	(out30-131.freemail.mail.aliyun.com [115.124.30.131])
	by userp2040.oracle.com with ESMTP id 36ftxme6md-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO)
	for <ocfs2-devel@oss.oracle.com>; Thu, 04 Feb 2021 03:12:10 +0000
X-Alimail-AntiSpam: AC=PASS; BC=-1|-1; BR=01201311R391e4; CH=green; DM=||false|;
	DS=||; FP=0|-1|-1|-1|0|-1|-1|-1; HT=e01e04420;
	MF=yang.lee@linux.alibaba.com; NM=1; PH=DS; RN=6; SR=0;
	TI=SMTPD_---0UNolUB6_1612408324; 
Received: from
	j63c13417.sqa.eu95.tbsite.net(mailfrom:yang.lee@linux.alibaba.com
	fp:SMTPD_---0UNolUB6_1612408324) by smtp.aliyun-inc.com(127.0.0.1);
	Thu, 04 Feb 2021 11:12:04 +0800
From: Yang Li <yang.lee@linux.alibaba.com>
To: mark@fasheh.com
Date: Thu,  4 Feb 2021 11:12:03 +0800
Message-Id: <1612408323-23579-1-git-send-email-yang.lee@linux.alibaba.com>
X-Mailer: git-send-email 1.8.3.1
X-PDR: PASS
X-Source-IP: 115.124.30.131
X-ServerName: out30-131.freemail.mail.aliyun.com
X-Proofpoint-SPF-Result: pass
X-Proofpoint-SPF-Record: v=spf1 include:spf1.service.alibaba.com
	include:spf2.service.alibaba.com
	include:spf1.ocm.aliyun.com  include:spf2.ocm.aliyun.com
	include:spf1.staff.mail.aliyun.com include:a.hichina.mail.aliyun.com
	include:b.hichina.mail.aliyun.com -all
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9884
	signatures=668683
X-Proofpoint-Spam-Details: rule=tap_notspam policy=tap score=0 adultscore=0
	mlxlogscore=625
	malwarescore=0 mlxscore=0 clxscore=189 priorityscore=48
	lowpriorityscore=0
	phishscore=0 suspectscore=0 impostorscore=0 spamscore=0 bulkscore=0
	classifier=spam adjust=0 reason=mlx scancount=1
	engine=8.12.0-2009150000 definitions=main-2102040018
X-Spam: Clean
X-Mailman-Approved-At: Thu, 04 Feb 2021 03:12:51 -0800
Cc: Yang Li <yang.lee@linux.alibaba.com>, ocfs2-devel@oss.oracle.com,
        linux-kernel@vger.kernel.org
Subject: [Ocfs2-devel] [PATCH] ocfs2: Remove unneeded return variable
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
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9884 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 mlxscore=0
 suspectscore=0 spamscore=0 mlxlogscore=999 phishscore=0 adultscore=0
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2102040069
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9884 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 adultscore=0
 priorityscore=1501 impostorscore=0 malwarescore=0 clxscore=1034
 spamscore=0 lowpriorityscore=0 phishscore=0 mlxlogscore=999 mlxscore=0
 suspectscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2102040070

This patch removes unneeded return variables, using only
'0' instead.
It fixes the following warning detected by coccinelle:
./fs/ocfs2/stack_o2cb.c:69:5-16: Unneeded variable: "o2dlm_flags".
Return "0" on line 84

Reported-by: Abaci Robot <abaci@linux.alibaba.com>
Signed-off-by: Yang Li <yang.lee@linux.alibaba.com>
---
 fs/ocfs2/stack_o2cb.c | 4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff --git a/fs/ocfs2/stack_o2cb.c b/fs/ocfs2/stack_o2cb.c
index dbf8b57..2da9633 100644
--- a/fs/ocfs2/stack_o2cb.c
+++ b/fs/ocfs2/stack_o2cb.c
@@ -66,8 +66,6 @@ static inline int mode_to_o2dlm(int mode)
 	}
 static int flags_to_o2dlm(u32 flags)
 {
-	int o2dlm_flags = 0;
-
 	map_flag(DLM_LKF_NOQUEUE, LKM_NOQUEUE);
 	map_flag(DLM_LKF_CANCEL, LKM_CANCEL);
 	map_flag(DLM_LKF_CONVERT, LKM_CONVERT);
@@ -81,7 +79,7 @@ static int flags_to_o2dlm(u32 flags)
 	/* map_flag() should have cleared every flag passed in */
 	BUG_ON(flags != 0);
 
-	return o2dlm_flags;
+	return 0;
 }
 #undef map_flag
 
-- 
1.8.3.1


_______________________________________________
Ocfs2-devel mailing list
Ocfs2-devel@oss.oracle.com
https://oss.oracle.com/mailman/listinfo/ocfs2-devel
