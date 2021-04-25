Return-Path: <SRS0=8K4+=KI=oss.oracle.com=ocfs2-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CFA25C43460
	for <ocfs2-devel@archiver.kernel.org>; Thu, 13 May 2021 15:01:18 +0000 (UTC)
Received: from aserp2120.oracle.com (aserp2120.oracle.com [141.146.126.78])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id 5C7EC6143C
	for <ocfs2-devel@archiver.kernel.org>; Thu, 13 May 2021 15:01:18 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 5C7EC6143C
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=vivo.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=ocfs2-devel-bounces@oss.oracle.com
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
	by aserp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 14DF0Ui0086948;
	Thu, 13 May 2021 15:01:17 GMT
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
	by aserp2120.oracle.com with ESMTP id 38gpnxsxqp-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 13 May 2021 15:01:17 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
	by userp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 14DF09vk118334;
	Thu, 13 May 2021 15:01:16 GMT
Received: from oss.oracle.com (oss-old-reserved.oracle.com [137.254.22.2])
	by userp3020.oracle.com with ESMTP id 38gppg9fpu-1
	(version=TLSv1 cipher=AES256-SHA bits=256 verify=NO);
	Thu, 13 May 2021 15:01:16 +0000
Received: from localhost ([127.0.0.1] helo=lb-oss.oracle.com)
	by oss.oracle.com with esmtp (Exim 4.63)
	(envelope-from <ocfs2-devel-bounces@oss.oracle.com>)
	id 1lhCpu-0003dp-Fg; Thu, 13 May 2021 08:01:14 -0700
Received: from userp3020.oracle.com ([156.151.31.79])
	by oss.oracle.com with esmtp (Exim 4.63)
	(envelope-from <wanjiabing@vivo.com>) id 1laUyZ-0001fD-HY
	for ocfs2-devel@oss.oracle.com; Sat, 24 Apr 2021 19:58:27 -0700
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
	by userp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id
	13P2oBin092222
	for <ocfs2-devel@oss.oracle.com>; Sun, 25 Apr 2021 02:58:27 GMT
Received: from oracle.com (userp2030.oracle.com [156.151.31.89])
	by userp3020.oracle.com with ESMTP id 384w3pk7m9-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
	for <ocfs2-devel@oss.oracle.com>; Sun, 25 Apr 2021 02:58:27 +0000
Received: from userp2030.oracle.com (userp2030.oracle.com [127.0.0.1])
	by pps.ucf-imr (8.16.0.36/8.16.0.36) with SMTP id 13P2s462003552
	for <ocfs2-devel@oss.oracle.com>; Sun, 25 Apr 2021 02:58:26 GMT
Received: from mail-m121145.qiye.163.com (mail-m121145.qiye.163.com
	[115.236.121.145]) by userp2030.oracle.com with ESMTP id 384vwejmg0-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO)
	for <ocfs2-devel@oss.oracle.com>; Sun, 25 Apr 2021 02:58:26 +0000
Received: from wanjb-virtual-machine.localdomain (unknown [36.152.145.182])
	by mail-m121145.qiye.163.com (Hmail) with ESMTPA id 61EA4800057;
	Sun, 25 Apr 2021 10:57:10 +0800 (CST)
From: Wan Jiabing <wanjiabing@vivo.com>
To: Mark Fasheh <mark@fasheh.com>, Joel Becker <jlbec@evilplan.org>,
        Joseph Qi <joseph.qi@linux.alibaba.com>, ocfs2-devel@oss.oracle.com,
        linux-kernel@vger.kernel.org
Date: Sun, 25 Apr 2021 10:57:02 +0800
Message-Id: <20210425025702.13628-1-wanjiabing@vivo.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
X-HM-Spam-Status: e1kfGhgUHx5ZQUtXWQgYFAkeWUFZS1VLWVdZKFlBSE83V1ktWUFJV1kPCR
	oVCBIfWUFZGkJJQ1ZLS0lLHh5CHRhDGUpVEwETFhoSFyQUDg9ZV1kWGg8SFR0UWUFZT0tIVUpKS0
	9ISFVLWQY+
X-HM-Sender-Digest: e1kMHhlZQR0aFwgeV1kSHx4VD1lBWUc6Mjo6Tzo5NT8NLAMeTyM3CUsP
	OC0KCx9VSlVKTUpCSEpCT0hLQkpJVTMWGhIXVQwaFRESGhkSFRw7DRINFFUYFBZFWVdZEgtZQVlI
	TVVKTklVSk9OVUpDSVlXWQgBWUFKQ0hJNwY+
X-HM-Tid: 0a7906f59d93b03akuuu61ea4800057
X-PDR: PASS
X-Source-IP: 115.236.121.145
X-ServerName: mail-m121145.qiye.163.com
X-Proofpoint-SPF-Result: pass
X-Proofpoint-SPF-Record: v=spf1 include:spf.163.com
	include:spf.protection.outlook.com
	include:mail.zendesk.com -all
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9964
	signatures=668683
X-Proofpoint-Spam-Details: rule=tap_notspam policy=tap score=0 malwarescore=0
	spamscore=0 adultscore=0
	phishscore=0 priorityscore=70 impostorscore=0 bulkscore=0
	mlxlogscore=627
	suspectscore=0 clxscore=300 mlxscore=0 lowpriorityscore=0
	classifier=spam
	adjust=0 reason=mlx scancount=1 engine=8.12.0-2104060000
	definitions=main-2104250021
X-Spam: Clean
X-Mailman-Approved-At: Thu, 13 May 2021 08:01:13 -0700
Cc: kael_w@yeah.net, Wan Jiabing <wanjiabing@vivo.com>
Subject: [Ocfs2-devel] [PATCH] ocfs2: Remove repeated uptodate check for
	buffer
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
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 mlxscore=0
 suspectscore=0 malwarescore=0 phishscore=0 spamscore=0 adultscore=0
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2104190000 definitions=main-2105130110
X-Proofpoint-GUID: hh0nM-gYolqjbhfw99PloNnoFAGepIpF
X-Proofpoint-ORIG-GUID: hh0nM-gYolqjbhfw99PloNnoFAGepIpF
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9982 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 lowpriorityscore=0 bulkscore=0
 adultscore=0 priorityscore=1501 phishscore=0 malwarescore=0 spamscore=0
 impostorscore=0 mlxlogscore=999 mlxscore=0 clxscore=1034 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2104190000
 definitions=main-2105130110

In commit 60f91826ca62 ("buffer: Avoid setting buffer bits that are
already set"), function set_buffer_##name was added a test_bit() to
check buffer, which is the same as function buffer_##name.
The !buffer_uptodate(bh) here is a repeated check. Remove it.

Signed-off-by: Wan Jiabing <wanjiabing@vivo.com>
---
 fs/ocfs2/aops.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/fs/ocfs2/aops.c b/fs/ocfs2/aops.c
index ad20403b383f..bd039fdbb27e 100644
--- a/fs/ocfs2/aops.c
+++ b/fs/ocfs2/aops.c
@@ -634,8 +634,7 @@ int ocfs2_map_page_blocks(struct page *page, u64 *p_blkno,
 		}
 
 		if (PageUptodate(page)) {
-			if (!buffer_uptodate(bh))
-				set_buffer_uptodate(bh);
+			set_buffer_uptodate(bh);
 		} else if (!buffer_uptodate(bh) && !buffer_delay(bh) &&
 			   !buffer_new(bh) &&
 			   ocfs2_should_read_blk(inode, page, block_start) &&
-- 
2.25.1


_______________________________________________
Ocfs2-devel mailing list
Ocfs2-devel@oss.oracle.com
https://oss.oracle.com/mailman/listinfo/ocfs2-devel
