Return-Path: <SRS0=LIWT=O3=oss.oracle.com=ocfs2-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AF6A0C433F5
	for <ocfs2-devel@archiver.kernel.org>; Thu,  7 Oct 2021 23:35:32 +0000 (UTC)
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id 6C8BF60FD8
	for <ocfs2-devel@archiver.kernel.org>; Thu,  7 Oct 2021 23:35:32 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org 6C8BF60FD8
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=canonical.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=oss.oracle.com
Received: from pps.filterd (m0246629.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 197LuYow023220;
	Thu, 7 Oct 2021 23:35:31 GMT
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
	by mx0b-00069f02.pphosted.com with ESMTP id 3bj02jmhg6-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 07 Oct 2021 23:35:31 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
	by userp3030.oracle.com (8.16.1.2/8.16.1.2) with SMTP id 197NUnYU102202;
	Thu, 7 Oct 2021 23:35:28 GMT
Received: from oss.oracle.com (oss-old-reserved.oracle.com [137.254.22.2])
	by userp3030.oracle.com with ESMTP id 3bf0sb1r9f-1
	(version=TLSv1 cipher=AES256-SHA bits=256 verify=NO);
	Thu, 07 Oct 2021 23:35:28 +0000
Received: from localhost ([127.0.0.1] helo=lb-oss.oracle.com)
	by oss.oracle.com with esmtp (Exim 4.63)
	(envelope-from <ocfs2-devel-bounces@oss.oracle.com>)
	id 1mYcv9-0008NZ-3z; Thu, 07 Oct 2021 16:35:27 -0700
Received: from aserp3020.oracle.com ([141.146.126.70])
	by oss.oracle.com with esmtp (Exim 4.63)
	(envelope-from <colin.king@canonical.com>) id 1mYcuf-0008Mf-Qy
	for ocfs2-devel@oss.oracle.com; Thu, 07 Oct 2021 16:34:57 -0700
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
	by aserp3020.oracle.com (8.16.1.2/8.16.1.2) with SMTP id 197NUSL7050831
	for <ocfs2-devel@oss.oracle.com>; Thu, 7 Oct 2021 23:34:57 GMT
Received: from mx0b-00069f01.pphosted.com (mx0b-00069f01.pphosted.com
	[205.220.177.26]) by aserp3020.oracle.com with ESMTP id 3bev91r9x9-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
	for <ocfs2-devel@oss.oracle.com>; Thu, 07 Oct 2021 23:34:57 +0000
Received: from pps.filterd (m0246579.ppops.net [127.0.0.1])
	by mx0b-00069f01.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id
	197MkOOa023620
	for <ocfs2-devel@oss.oracle.com>; Thu, 7 Oct 2021 23:34:56 GMT
Received: from smtp-relay-canonical-1.canonical.com
	(smtp-relay-canonical-1.canonical.com [185.125.188.121])
	by mx0b-00069f01.pphosted.com with ESMTP id 3bhybwtqwv-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO)
	for <ocfs2-devel@oss.oracle.com>; Thu, 07 Oct 2021 23:34:56 +0000
Received: from localhost (1.general.cking.uk.vpn [10.172.193.212])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	key-exchange ECDHE (P-256) server-signature RSA-PSS (2048 bits)
	server-digest SHA256) (No client certificate requested)
	by smtp-relay-canonical-1.canonical.com (Postfix) with ESMTPSA id
	8ACC13FFE8; Thu,  7 Oct 2021 23:34:52 +0000 (UTC)
From: Colin King <colin.king@canonical.com>
To: Mark Fasheh <mark@fasheh.com>, Joel Becker <jlbec@evilplan.org>,
        Joseph Qi <joseph.qi@linux.alibaba.com>, ocfs2-devel@oss.oracle.com
Date: Fri,  8 Oct 2021 00:34:52 +0100
Message-Id: <20211007233452.30815-1-colin.king@canonical.com>
X-Mailer: git-send-email 2.32.0
MIME-Version: 1.0
X-Source-IP: 185.125.188.121
X-ServerName: smtp-relay-canonical-1.canonical.com
X-Proofpoint-SPF-Result: pass
X-Proofpoint-SPF-Record: v=spf1 ip4:185.125.188.120 ip4:185.125.188.121
	ip4:185.125.188.122
	ip4:185.125.188.123 ip4:185.125.188.124 ip4:185.125.188.125
	ip4:91.189.95.10 ip4:91.189.90.122 ip4:91.189.95.79 ip4:91.189.90.7
	-all
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10130
	signatures=668683
X-Proofpoint-Spam-Details: rule=tap_notspam policy=tap score=0 malwarescore=0
	priorityscore=275
	impostorscore=0 phishscore=0 adultscore=0 clxscore=171 suspectscore=0
	spamscore=0 bulkscore=0 lowpriorityscore=0 mlxscore=0 mlxlogscore=999
	classifier=spam adjust=0 reason=mlx scancount=1
	engine=8.12.0-2109230001 definitions=main-2110070147
X-Spam: Clean
Cc: kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [Ocfs2-devel] [PATCH] ocfs2/dlm: Remove redundant assignment of
	variable ret
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
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10130 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 suspectscore=0 adultscore=0
 mlxscore=0 phishscore=0 bulkscore=0 mlxlogscore=999 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2109230001
 definitions=main-2110070147
X-Proofpoint-ORIG-GUID: WEx2dbV3yDjyG75H7MEZR55Id80zNSMr
X-Proofpoint-GUID: WEx2dbV3yDjyG75H7MEZR55Id80zNSMr

From: Colin Ian King <colin.king@canonical.com>

The variable ret is being assigned a value that is never read, it is
updated later on with a different value. The assignment is redundant and
can be removed.

Addresses-Coverity: ("Unused value")
Signed-off-by: Colin Ian King <colin.king@canonical.com>
---
 fs/ocfs2/dlm/dlmrecovery.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/fs/ocfs2/dlm/dlmrecovery.c b/fs/ocfs2/dlm/dlmrecovery.c
index e24e327524f8..52ad342fec3e 100644
--- a/fs/ocfs2/dlm/dlmrecovery.c
+++ b/fs/ocfs2/dlm/dlmrecovery.c
@@ -2698,7 +2698,6 @@ static int dlm_send_begin_reco_message(struct dlm_ctxt *dlm, u8 dead_node)
 			continue;
 		}
 retry:
-		ret = -EINVAL;
 		mlog(0, "attempting to send begin reco msg to %d\n",
 			  nodenum);
 		ret = o2net_send_message(DLM_BEGIN_RECO_MSG, dlm->key,
-- 
2.32.0


_______________________________________________
Ocfs2-devel mailing list
Ocfs2-devel@oss.oracle.com
https://oss.oracle.com/mailman/listinfo/ocfs2-devel
