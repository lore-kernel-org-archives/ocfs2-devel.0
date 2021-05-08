Return-Path: <SRS0=iqh4=KD=oss.oracle.com=ocfs2-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1EDBAC433B4
	for <ocfs2-devel@archiver.kernel.org>; Sat,  8 May 2021 10:45:23 +0000 (UTC)
Received: from aserp2130.oracle.com (aserp2130.oracle.com [141.146.126.79])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id 727966142D
	for <ocfs2-devel@archiver.kernel.org>; Sat,  8 May 2021 10:45:22 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 727966142D
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=linux.alibaba.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=ocfs2-devel-bounces@oss.oracle.com
Received: from pps.filterd (aserp2130.oracle.com [127.0.0.1])
	by aserp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 148Ain7P096293;
	Sat, 8 May 2021 10:45:20 GMT
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
	by aserp2130.oracle.com with ESMTP id 38dg5b8ekt-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Sat, 08 May 2021 10:45:20 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
	by userp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 148Adqfi104583;
	Sat, 8 May 2021 10:45:19 GMT
Received: from oss.oracle.com (oss-old-reserved.oracle.com [137.254.22.2])
	by userp3020.oracle.com with ESMTP id 38dhyjn7dn-1
	(version=TLSv1 cipher=AES256-SHA bits=256 verify=NO);
	Sat, 08 May 2021 10:45:19 +0000
Received: from localhost ([127.0.0.1] helo=lb-oss.oracle.com)
	by oss.oracle.com with esmtp (Exim 4.63)
	(envelope-from <ocfs2-devel-bounces@oss.oracle.com>)
	id 1lfKPR-0001xe-Bf; Sat, 08 May 2021 03:42:09 -0700
Received: from userp3030.oracle.com ([156.151.31.80])
	by oss.oracle.com with esmtp (Exim 4.63)
	(envelope-from <jiapeng.chong@linux.alibaba.com>) id 1lfKOu-0001wd-Qs
	for ocfs2-devel@oss.oracle.com; Sat, 08 May 2021 03:41:36 -0700
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
	by userp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id
	148AfPF1165856
	for <ocfs2-devel@oss.oracle.com>; Sat, 8 May 2021 10:41:36 GMT
Received: from oracle.com (userp2040.oracle.com [156.151.31.90])
	by userp3030.oracle.com with ESMTP id 38dfrs3kut-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
	for <ocfs2-devel@oss.oracle.com>; Sat, 08 May 2021 10:41:36 +0000
Received: from userp2040.oracle.com (userp2040.oracle.com [127.0.0.1])
	by pps.ucf-imr (8.16.0.36/8.16.0.36) with SMTP id 148AYNkU030320
	for <ocfs2-devel@oss.oracle.com>; Sat, 8 May 2021 10:41:35 GMT
Received: from out30-130.freemail.mail.aliyun.com
	(out30-130.freemail.mail.aliyun.com [115.124.30.130])
	by userp2040.oracle.com with ESMTP id 38dh8tdc6v-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO)
	for <ocfs2-devel@oss.oracle.com>; Sat, 08 May 2021 10:41:35 +0000
X-Alimail-AntiSpam: AC=PASS; BC=-1|-1; BR=01201311R151e4; CH=green; DM=||false|;
	DS=||; FP=0|-1|-1|-1|0|-1|-1|-1; HT=e01e04394;
	MF=jiapeng.chong@linux.alibaba.com; NM=1; PH=DS; RN=6; SR=0;
	TI=SMTPD_---0UY8aVeP_1620470483; 
Received: from
	j63c13417.sqa.eu95.tbsite.net(mailfrom:jiapeng.chong@linux.alibaba.com
	fp:SMTPD_---0UY8aVeP_1620470483) by smtp.aliyun-inc.com(127.0.0.1);
	Sat, 08 May 2021 18:41:28 +0800
From: Jiapeng Chong <jiapeng.chong@linux.alibaba.com>
To: mark@fasheh.com
Date: Sat,  8 May 2021 18:41:21 +0800
Message-Id: <1620470481-31597-1-git-send-email-jiapeng.chong@linux.alibaba.com>
X-Mailer: git-send-email 1.8.3.1
X-PDR: PASS
X-Source-IP: 115.124.30.130
X-ServerName: out30-130.freemail.mail.aliyun.com
X-Proofpoint-SPF-Result: pass
X-Proofpoint-SPF-Record: v=spf1 include:spf1.service.alibaba.com
	include:spf2.service.alibaba.com
	include:spf1.ocm.aliyun.com  include:spf2.ocm.aliyun.com
	include:spf1.staff.mail.aliyun.com include:a.hichina.mail.aliyun.com
	include:b.hichina.mail.aliyun.com -all
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9977
	signatures=668683
X-Proofpoint-Spam-Details: rule=tap_notspam policy=tap score=0
	priorityscore=100 lowpriorityscore=0
	suspectscore=0 impostorscore=0 spamscore=0 mlxlogscore=970 adultscore=0
	bulkscore=0 clxscore=201 mlxscore=0 phishscore=0 malwarescore=0
	classifier=spam adjust=0 reason=mlx scancount=1
	engine=8.12.0-2104190000 definitions=main-2105080076
X-Spam: Clean
Cc: Jiapeng Chong <jiapeng.chong@linux.alibaba.com>,
        ocfs2-devel@oss.oracle.com, linux-kernel@vger.kernel.org
Subject: [Ocfs2-devel] [PATCH] ocfs2: Reomve err less than zero check
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
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9977 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 adultscore=0
 phishscore=0 bulkscore=0 suspectscore=0 spamscore=0 mlxscore=0
 malwarescore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2104190000 definitions=main-2105080077
X-Proofpoint-GUID: BOZHBPzNXn54lhJeIxekDN34ML86huuu
X-Proofpoint-ORIG-GUID: BOZHBPzNXn54lhJeIxekDN34ML86huuu
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9977 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 lowpriorityscore=0 malwarescore=0
 bulkscore=0 spamscore=0 clxscore=1034 priorityscore=1501 adultscore=0
 mlxlogscore=999 mlxscore=0 suspectscore=0 impostorscore=0 phishscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2104190000
 definitions=main-2105080077

The check for err < 0 is always false because err is an enum and can
never be less than zero.

Clean up the following coccicheck warning:

fs/ocfs2/dlm/dlmdebug.c:222 dlm_errname() warn: unsigned 'err' is never
less than zero.

fs/ocfs2/dlm/dlmdebug.c:214 dlm_errmsg() warn: unsigned 'err' is never
less than zero.

Reported-by: Abaci Robot <abaci@linux.alibaba.com>
Signed-off-by: Jiapeng Chong <jiapeng.chong@linux.alibaba.com>
---
 fs/ocfs2/dlm/dlmdebug.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/fs/ocfs2/dlm/dlmdebug.c b/fs/ocfs2/dlm/dlmdebug.c
index d442cf5..817914d 100644
--- a/fs/ocfs2/dlm/dlmdebug.c
+++ b/fs/ocfs2/dlm/dlmdebug.c
@@ -211,7 +211,7 @@ void dlm_print_one_lock(struct dlm_lock *lockid)
 
 const char *dlm_errmsg(enum dlm_status err)
 {
-	if (err >= DLM_MAXSTATS || err < 0)
+	if (err >= DLM_MAXSTATS)
 		return dlm_errmsgs[DLM_MAXSTATS];
 	return dlm_errmsgs[err];
 }
@@ -219,7 +219,7 @@ const char *dlm_errmsg(enum dlm_status err)
 
 const char *dlm_errname(enum dlm_status err)
 {
-	if (err >= DLM_MAXSTATS || err < 0)
+	if (err >= DLM_MAXSTATS)
 		return dlm_errnames[DLM_MAXSTATS];
 	return dlm_errnames[err];
 }
-- 
1.8.3.1


_______________________________________________
Ocfs2-devel mailing list
Ocfs2-devel@oss.oracle.com
https://oss.oracle.com/mailman/listinfo/ocfs2-devel
