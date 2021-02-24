Return-Path: <SRS0=z2TF=H2=oss.oracle.com=ocfs2-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.7 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 28407C433E9
	for <ocfs2-devel@archiver.kernel.org>; Wed, 24 Feb 2021 08:31:02 +0000 (UTC)
Received: from aserp2130.oracle.com (aserp2130.oracle.com [141.146.126.79])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id 7E2BC64F0E
	for <ocfs2-devel@archiver.kernel.org>; Wed, 24 Feb 2021 08:31:01 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 7E2BC64F0E
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=linux.alibaba.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=ocfs2-devel-bounces@oss.oracle.com
Received: from pps.filterd (aserp2130.oracle.com [127.0.0.1])
	by aserp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 11O8UxFx083383;
	Wed, 24 Feb 2021 08:30:59 GMT
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
	by aserp2130.oracle.com with ESMTP id 36vr624dsg-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 24 Feb 2021 08:30:59 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
	by userp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 11O8UYZ1069174;
	Wed, 24 Feb 2021 08:30:58 GMT
Received: from oss.oracle.com (oss-old-reserved.oracle.com [137.254.22.2])
	by userp3030.oracle.com with ESMTP id 36ucbyjyyg-1
	(version=TLSv1 cipher=AES256-SHA bits=256 verify=NO);
	Wed, 24 Feb 2021 08:30:58 +0000
Received: from localhost ([127.0.0.1] helo=lb-oss.oracle.com)
	by oss.oracle.com with esmtp (Exim 4.63)
	(envelope-from <ocfs2-devel-bounces@oss.oracle.com>)
	id 1lEpWO-0002b5-48; Wed, 24 Feb 2021 00:27:48 -0800
Received: from aserp3030.oracle.com ([141.146.126.71])
	by oss.oracle.com with esmtp (Exim 4.63)
	(envelope-from <yang.lee@linux.alibaba.com>) id 1lEpVy-0002aF-QP
	for ocfs2-devel@oss.oracle.com; Wed, 24 Feb 2021 00:27:22 -0800
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
	by aserp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id
	11O8QVHj114830
	for <ocfs2-devel@oss.oracle.com>; Wed, 24 Feb 2021 08:27:22 GMT
Received: from userp2030.oracle.com (userp2030.oracle.com [156.151.31.89])
	by aserp3030.oracle.com with ESMTP id 36v9m5nhc4-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
	for <ocfs2-devel@oss.oracle.com>; Wed, 24 Feb 2021 08:27:22 +0000
Received: from pps.filterd (userp2030.oracle.com [127.0.0.1])
	by userp2030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id
	11O8Ooux038007
	for <ocfs2-devel@oss.oracle.com>; Wed, 24 Feb 2021 08:27:21 GMT
Received: from out30-54.freemail.mail.aliyun.com
	(out30-54.freemail.mail.aliyun.com [115.124.30.54])
	by userp2030.oracle.com with ESMTP id 36trfhygc2-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO)
	for <ocfs2-devel@oss.oracle.com>; Wed, 24 Feb 2021 08:27:21 +0000
X-Alimail-AntiSpam: AC=PASS; BC=-1|-1; BR=01201311R911e4; CH=green; DM=||false|;
	DS=||; FP=0|-1|-1|-1|0|-1|-1|-1; HT=e01e04395;
	MF=yang.lee@linux.alibaba.com; NM=1; PH=DS; RN=6; SR=0;
	TI=SMTPD_---0UPRlhND_1614155232; 
Received: from
	j63c13417.sqa.eu95.tbsite.net(mailfrom:yang.lee@linux.alibaba.com
	fp:SMTPD_---0UPRlhND_1614155232) by smtp.aliyun-inc.com(127.0.0.1);
	Wed, 24 Feb 2021 16:27:12 +0800
From: Yang Li <yang.lee@linux.alibaba.com>
To: mark@fasheh.com
Date: Wed, 24 Feb 2021 16:27:10 +0800
Message-Id: <1614155230-57292-1-git-send-email-yang.lee@linux.alibaba.com>
X-Mailer: git-send-email 1.8.3.1
X-PDR: PASS
X-Source-IP: 115.124.30.54
X-ServerName: out30-54.freemail.mail.aliyun.com
X-Proofpoint-SPF-Result: pass
X-Proofpoint-SPF-Record: v=spf1 include:spf1.service.alibaba.com
	include:spf2.service.alibaba.com
	include:spf1.ocm.aliyun.com  include:spf2.ocm.aliyun.com
	include:spf1.staff.mail.aliyun.com include:a.hichina.mail.aliyun.com
	include:b.hichina.mail.aliyun.com -all
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9904
	signatures=668683
X-Proofpoint-Spam-Details: rule=tap_notspam policy=tap score=0 spamscore=0
	priorityscore=0
	lowpriorityscore=0 malwarescore=0 impostorscore=0 clxscore=185
	mlxscore=0
	adultscore=0 phishscore=0 bulkscore=0 mlxlogscore=357 suspectscore=0
	classifier=spam adjust=0 reason=mlx scancount=1
	engine=8.12.0-2009150000 definitions=main-2102240064
X-Spam: Clean
Cc: Yang Li <yang.lee@linux.alibaba.com>, ocfs2-devel@oss.oracle.com,
        linux-kernel@vger.kernel.org
Subject: [Ocfs2-devel] [PATCH] ocfs2: Replace DEFINE_SIMPLE_ATTRIBUTE with
	DEFINE_DEBUGFS_ATTRIBUTE
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
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9904 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 adultscore=0
 phishscore=0 spamscore=0 suspectscore=0 bulkscore=0 malwarescore=0
 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2102240065
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9904 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 bulkscore=0
 clxscore=1034 mlxlogscore=999 lowpriorityscore=0 phishscore=0
 impostorscore=0 adultscore=0 mlxscore=0 priorityscore=1501 malwarescore=0
 spamscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2102240065

Fix the following coccicheck warning:
./fs/ocfs2/blockcheck.c:232:0-23: WARNING: blockcheck_fops should be
defined with DEFINE_DEBUGFS_ATTRIBUTE

Reported-by: Abaci Robot <abaci@linux.alibaba.com>
Signed-off-by: Yang Li <yang.lee@linux.alibaba.com>
---
 fs/ocfs2/blockcheck.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/ocfs2/blockcheck.c b/fs/ocfs2/blockcheck.c
index 6e07ddb..dabfef9 100644
--- a/fs/ocfs2/blockcheck.c
+++ b/fs/ocfs2/blockcheck.c
@@ -229,7 +229,7 @@ static int blockcheck_u64_get(void *data, u64 *val)
 	*val = *(u64 *)data;
 	return 0;
 }
-DEFINE_SIMPLE_ATTRIBUTE(blockcheck_fops, blockcheck_u64_get, NULL, "%llu\n");
+DEFINE_DEBUGFS_ATTRIBUTE(blockcheck_fops, blockcheck_u64_get, NULL, "%llu\n");
 
 static void ocfs2_blockcheck_debug_remove(struct ocfs2_blockcheck_stats *stats)
 {
-- 
1.8.3.1


_______________________________________________
Ocfs2-devel mailing list
Ocfs2-devel@oss.oracle.com
https://oss.oracle.com/mailman/listinfo/ocfs2-devel
