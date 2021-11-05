Return-Path: <SRS0=R4zn=PY=oss.oracle.com=ocfs2-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3C0C5C433F5
	for <ocfs2-devel@archiver.kernel.org>; Fri,  5 Nov 2021 01:51:24 +0000 (UTC)
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id C2F136120E
	for <ocfs2-devel@archiver.kernel.org>; Fri,  5 Nov 2021 01:51:23 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org C2F136120E
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=gmail.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=oss.oracle.com
Received: from pps.filterd (m0246632.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 1A50a0Sk007541;
	Fri, 5 Nov 2021 01:51:22 GMT
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
	by mx0b-00069f02.pphosted.com with ESMTP id 3c4t7br93f-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 05 Nov 2021 01:51:22 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
	by userp3020.oracle.com (8.16.1.2/8.16.1.2) with SMTP id 1A51oN0o177030;
	Fri, 5 Nov 2021 01:51:21 GMT
Received: from oss.oracle.com (oss-old-reserved.oracle.com [137.254.22.2])
	by userp3020.oracle.com with ESMTP id 3c4t60j9xp-1
	(version=TLSv1 cipher=AES256-SHA bits=256 verify=NO);
	Fri, 05 Nov 2021 01:51:20 +0000
Received: from localhost ([127.0.0.1] helo=lb-oss.oracle.com)
	by oss.oracle.com with esmtp (Exim 4.63)
	(envelope-from <ocfs2-devel-bounces@oss.oracle.com>)
	id 1mioHt-0003UL-Eg; Thu, 04 Nov 2021 18:45:01 -0700
Received: from userp3020.oracle.com ([156.151.31.79])
	by oss.oracle.com with esmtp (Exim 4.63)
	(envelope-from <cgel.zte@gmail.com>) id 1mioHS-0003TR-Ck
	for ocfs2-devel@oss.oracle.com; Thu, 04 Nov 2021 18:44:34 -0700
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
	by userp3020.oracle.com (8.16.1.2/8.16.1.2) with SMTP id 1A51aNh1134973
	for <ocfs2-devel@oss.oracle.com>; Fri, 5 Nov 2021 01:44:34 GMT
Received: from mx0b-00069f01.pphosted.com (mx0b-00069f01.pphosted.com
	[205.220.177.26]) by userp3020.oracle.com with ESMTP id 3c4t60j3v7-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
	for <ocfs2-devel@oss.oracle.com>; Fri, 05 Nov 2021 01:44:34 +0000
Received: from pps.filterd (m0246576.ppops.net [127.0.0.1])
	by mx0b-00069f01.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id
	1A50QLcF031634
	for <ocfs2-devel@oss.oracle.com>; Fri, 5 Nov 2021 01:44:33 GMT
Received: from mail-qv1-f41.google.com (mail-qv1-f41.google.com
	[209.85.219.41])
	by mx0b-00069f01.pphosted.com with ESMTP id 3c4t2p0t4d-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=OK)
	for <ocfs2-devel@oss.oracle.com>; Fri, 05 Nov 2021 01:44:32 +0000
Received: by mail-qv1-f41.google.com with SMTP id s9so6487117qvk.12
	for <ocfs2-devel@oss.oracle.com>; Thu, 04 Nov 2021 18:44:32 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=1e100.net; s=20210112;
	h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
	:content-transfer-encoding;
	bh=gxv1bZDHr15atfwYJHUOJ87e76juxg0gWxkHi+2jlUQ=;
	b=SkAW0mQC//2YnaI+NFSqPAeV2FmQe0igNZDhnu7F1UHGvDGkXIox9QB6wbz/0bn4Mb
	5jBa0zAOu8RzxrVI/rrYeiSntoSFwWxI6DG4vOf25+929znoNzCeGPtAHK0TX8t4Af9j
	oVC4j+AaUjtaho1eMO9dOUMH78p9UKzDvpLJ2Km6XPCp2sFAGrPlX8Jqa3IgLHZgT20k
	6273PpiQMgPHBrbOHJGeDAooYbACQPySMUM6Wxl6+9Nl0A1TJ01dOWb/H28pvaMod7h8
	CmkKT0EHpdRKw7UePuT8cc32TkeakN9d+wKJs+D/AyU2pqxIiV5IJwVMmbWd8FGOULGc
	+qrA==
X-Gm-Message-State: AOAM532laMy4/roGUwdGOD/0rgS/QmlPPswPlgvI4Z+jWb6QncrxnzSB
	VTTWZ1pgLUNlN1pYJzOojIo=
X-Google-Smtp-Source: ABdhPJxfnFqZnuS3BPSnz9PdPKsMSKblgkWPn4nAF9hidcWkzPqFCfdB7DczRszqu3iUmxeo2Kzg5w==
X-Received: by 2002:a05:6214:5195:: with SMTP id
	kl21mr27580947qvb.42.1636076671960; 
	Thu, 04 Nov 2021 18:44:31 -0700 (PDT)
Received: from localhost.localdomain ([193.203.214.57])
	by smtp.gmail.com with ESMTPSA id
	s11sm4974889qki.95.2021.11.04.18.44.29
	(version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
	Thu, 04 Nov 2021 18:44:31 -0700 (PDT)
From: cgel.zte@gmail.com
X-Google-Original-From: zhang.mingyu@zte.com.cn
To: mark@fasheh.com
Date: Fri,  5 Nov 2021 01:44:24 +0000
Message-Id: <20211105014424.75372-1-zhang.mingyu@zte.com.cn>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
X-Source-IP: 209.85.219.41
X-ServerName: mail-qv1-f41.google.com
X-Proofpoint-SPF-Result: pass
X-Proofpoint-SPF-Record: v=spf1 redirect=_spf.google.com
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10158
	signatures=668683
X-Proofpoint-Spam-Details: rule=tap_notspam policy=tap score=0 suspectscore=0
	mlxlogscore=479
	adultscore=0 phishscore=0 malwarescore=0 clxscore=192 bulkscore=0
	impostorscore=0 priorityscore=429 mlxscore=0 lowpriorityscore=0
	spamscore=0 classifier=spam adjust=0 reason=mlx scancount=1
	engine=8.12.0-2110150000 definitions=main-2111050008
	domainage_hfrom=9581
X-Spam: Clean
Cc: Zeal Robot <zealci@zte.com.cn>, linux-kernel@vger.kernel.org,
        Zhang Mingyu <zhang.mingyu@zte.com.cn>, ocfs2-devel@oss.oracle.com
Subject: [Ocfs2-devel] [PATCH] ocfs2:Use BUG_ON instead of if condition
	followed by BUG.
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
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10158 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 adultscore=0 mlxscore=0
 spamscore=0 malwarescore=0 bulkscore=0 mlxlogscore=999 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2110150000
 definitions=main-2111050009
X-Proofpoint-GUID: SVMsIgv6LpblMakeyrv_miwDUM694TKy
X-Proofpoint-ORIG-GUID: SVMsIgv6LpblMakeyrv_miwDUM694TKy

From: Zhang Mingyu <zhang.mingyu@zte.com.cn>

This issue was detected with the help of Coccinelle.

Reported-by: Zeal Robot <zealci@zte.com.cn>
Signed-off-by: Zhang Mingyu <zhang.mingyu@zte.com.cn>
---
 fs/ocfs2/journal.c | 6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

diff --git a/fs/ocfs2/journal.c b/fs/ocfs2/journal.c
index dbf9b9e97d74..1887a2708709 100644
--- a/fs/ocfs2/journal.c
+++ b/fs/ocfs2/journal.c
@@ -1669,8 +1669,7 @@ static int ocfs2_replay_journal(struct ocfs2_super *osb,
 	status = jbd2_journal_load(journal);
 	if (status < 0) {
 		mlog_errno(status);
-		if (!igrab(inode))
-			BUG();
+		BUG_ON(!igrab(inode));
 		jbd2_journal_destroy(journal);
 		goto done;
 	}
@@ -1699,8 +1698,7 @@ static int ocfs2_replay_journal(struct ocfs2_super *osb,
 	if (status < 0)
 		mlog_errno(status);
 
-	if (!igrab(inode))
-		BUG();
+	BUG_ON(!igrab(inode));
 
 	jbd2_journal_destroy(journal);
 
-- 
2.25.1


_______________________________________________
Ocfs2-devel mailing list
Ocfs2-devel@oss.oracle.com
https://oss.oracle.com/mailman/listinfo/ocfs2-devel
