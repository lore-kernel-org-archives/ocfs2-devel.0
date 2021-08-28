Return-Path: <SRS0=LbgC=OD=oss.oracle.com=ocfs2-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.7 required=3.0 tests=BAYES_00,
	DKIM_ADSP_CUSTOM_MED,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 60BEAC433FE
	for <ocfs2-devel@archiver.kernel.org>; Mon, 13 Sep 2021 14:28:59 +0000 (UTC)
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id 2723D60F6F
	for <ocfs2-devel@archiver.kernel.org>; Mon, 13 Sep 2021 14:28:59 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org 2723D60F6F
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=gmail.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=oss.oracle.com
Received: from pps.filterd (m0246629.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 18DESvg9024785;
	Mon, 13 Sep 2021 14:28:58 GMT
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
	by mx0b-00069f02.pphosted.com with ESMTP id 3b1ka92qut-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 13 Sep 2021 14:28:57 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
	by userp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 18DEDPDk034993;
	Mon, 13 Sep 2021 14:28:49 GMT
Received: from oss.oracle.com (oss-old-reserved.oracle.com [137.254.22.2])
	by userp3020.oracle.com with ESMTP id 3b167qh6ub-1;
	Mon, 13 Sep 2021 14:28:49 +0000
Received: from localhost ([127.0.0.1] helo=lb-oss.oracle.com)
	by oss.oracle.com with esmtp (Exim 4.63)
	(envelope-from <ocfs2-devel-bounces@oss.oracle.com>)
	id 1mPmwy-0004cC-Bp; Mon, 13 Sep 2021 07:28:48 -0700
Received: from userp3020.oracle.com ([156.151.31.79])
	by oss.oracle.com with esmtp (Exim 4.63)
	(envelope-from <cgel.zte@gmail.com>) id 1mJmm7-0003FB-Bq
	for ocfs2-devel@oss.oracle.com; Fri, 27 Aug 2021 18:04:47 -0700
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
	by userp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id
	17S10mKg179631
	for <ocfs2-devel@oss.oracle.com>; Sat, 28 Aug 2021 01:04:47 GMT
Received: from mx0b-00069f01.pphosted.com (mx0b-00069f01.pphosted.com
	[205.220.177.26]) by userp3020.oracle.com with ESMTP id 3akb93352j-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
	for <ocfs2-devel@oss.oracle.com>; Sat, 28 Aug 2021 01:04:46 +0000
Received: from pps.filterd (m0246580.ppops.net [127.0.0.1])
	by mx0b-00069f01.pphosted.com (8.16.1.2/8.16.0.43) with SMTP id
	17S0E0UH027607
	for <ocfs2-devel@oss.oracle.com>; Sat, 28 Aug 2021 01:04:45 GMT
Received: from mail-qv1-f45.google.com (mail-qv1-f45.google.com
	[209.85.219.45])
	by mx0b-00069f01.pphosted.com with ESMTP id 3aqae1rbw6-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=OK)
	for <ocfs2-devel@oss.oracle.com>; Sat, 28 Aug 2021 01:04:45 +0000
Received: by mail-qv1-f45.google.com with SMTP id p17so706576qvo.8
	for <ocfs2-devel@oss.oracle.com>; Fri, 27 Aug 2021 18:04:45 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=1e100.net; s=20161025;
	h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
	:content-transfer-encoding;
	bh=ycC5EjOXPlt4T7OSVhH11w0K9nPLV+pEuuLBP1af7qg=;
	b=alkdKDk0vZ30Tsrfnebz0gAvyUgu85+MEyjVeJaiNIn6QmvfVMFjuJ10l8T7kRv0+e
	faIGhin2MHYFPsHgE7wEz43RNZ8xD0+SvLL0jjsG2voHLgBKYPvXTPiWxMYjVVz8uc/6
	3mO7r3hgoW9qVGaAmx5ddxahVZB3xEuAZ/HOSJouRy7gWcCVAx/IsZbBvIzvqCqsofaB
	CAAn8P28vXN6YnLEoKRyG4IcuV5R+g29hNKAgss1d2jESTtvm+QJuDdOpksdv5qcbKCY
	zsh3NibRbjB2QQHhmDEioojJvgGqYmJ5kuRIA09i7xAP9jShK8X23fZtC+4RNEI/BSBn
	MjkQ==
X-Gm-Message-State: AOAM532FvlTMI7OrdcISfShUY3lnBB/BLwVbbDK5WQ0tQX/SmCFKoLI1
	sTrlmuabIps2G9b0K43ruAg=
X-Google-Smtp-Source: ABdhPJyv++bIWK/0r2Oc18SBIuOViJS3qdiBlzi1SOLF2tjvrUUe0Vi+k6jsaRKexrbeR3ia/zzHqA==
X-Received: by 2002:a0c:9043:: with SMTP id o61mr978572qvo.54.1630112684366;
	Fri, 27 Aug 2021 18:04:44 -0700 (PDT)
Received: from localhost.localdomain ([193.203.214.57])
	by smtp.gmail.com with ESMTPSA id
	n18sm5963946qkn.63.2021.08.27.18.04.41
	(version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
	Fri, 27 Aug 2021 18:04:44 -0700 (PDT)
From: CGEL <cgel.zte@gmail.com>
X-Google-Original-From: CGEL <deng.changcheng@zte.com.cn>
To: Mark Fasheh <mark@fasheh.com>
Date: Fri, 27 Aug 2021 18:04:32 -0700
Message-Id: <20210828010432.11100-1-deng.changcheng@zte.com.cn>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
X-Source-IP: 209.85.219.45
X-ServerName: mail-qv1-f45.google.com
X-Proofpoint-SPF-Result: pass
X-Proofpoint-SPF-Record: v=spf1 redirect=_spf.google.com
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10089
	signatures=668682
X-Proofpoint-Spam-Details: rule=tap_notspam policy=tap score=0 clxscore=214
	adultscore=0
	mlxlogscore=999 impostorscore=0 bulkscore=0 priorityscore=393
	phishscore=0
	suspectscore=0 mlxscore=0 lowpriorityscore=0 spamscore=0 malwarescore=0
	classifier=spam adjust=0 reason=mlx scancount=1
	engine=8.12.0-2107140000 definitions=main-2108280004
X-Spam: Clean
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10089
	signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0
	phishscore=0 spamscore=0
	bulkscore=0 mlxlogscore=999 malwarescore=0 adultscore=0 mlxscore=0
	classifier=spam adjust=0 reason=mlx scancount=1
	engine=8.12.0-2107140000 definitions=main-2108280004
X-Mailman-Approved-At: Mon, 13 Sep 2021 07:28:45 -0700
Cc: Zeal Robot <zealci@zte.com.cn>,
        Changcheng Deng <deng.changcheng@zte.com.cn>,
        linux-kernel@vger.kernel.org, ocfs2-devel@oss.oracle.com
Subject: [Ocfs2-devel] [PATCH linux-next] ocfs2: fix bugon.cocci warnings
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
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10105 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 adultscore=0 suspectscore=0
 phishscore=0 mlxlogscore=999 malwarescore=0 mlxscore=0 bulkscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2109030001
 definitions=main-2109130095
X-Proofpoint-GUID: igBcKzTtxea5eyb1d3ag26ksTgu0ymNw
X-Proofpoint-ORIG-GUID: igBcKzTtxea5eyb1d3ag26ksTgu0ymNw

From: Changcheng Deng <deng.changcheng@zte.com.cn>

Use BUG_ON instead of if condition followed by BUG.

Reported-by: Zeal Robot <zealci@zte.com.cn>
Signed-off-by: Changcheng Deng <deng.changcheng@zte.com.cn>
---
 fs/ocfs2/journal.c | 9 +++------
 1 file changed, 3 insertions(+), 6 deletions(-)

diff --git a/fs/ocfs2/journal.c b/fs/ocfs2/journal.c
index 4f15750..2305aa5 100644
--- a/fs/ocfs2/journal.c
+++ b/fs/ocfs2/journal.c
@@ -974,8 +974,7 @@ void ocfs2_journal_shutdown(struct ocfs2_super *osb)
 		goto done;
 
 	/* need to inc inode use count - jbd2_journal_destroy will iput. */
-	if (!igrab(inode))
-		BUG();
+	BUG_ON(!igrab(inode));
 
 	num_running_trans = atomic_read(&(osb->journal->j_num_trans));
 	trace_ocfs2_journal_shutdown(num_running_trans);
@@ -1656,8 +1655,7 @@ static int ocfs2_replay_journal(struct ocfs2_super *osb,
 	status = jbd2_journal_load(journal);
 	if (status < 0) {
 		mlog_errno(status);
-		if (!igrab(inode))
-			BUG();
+		BUG_ON(!igrab(inode));
 		jbd2_journal_destroy(journal);
 		goto done;
 	}
@@ -1686,8 +1684,7 @@ static int ocfs2_replay_journal(struct ocfs2_super *osb,
 	if (status < 0)
 		mlog_errno(status);
 
-	if (!igrab(inode))
-		BUG();
+	BUG_ON(!igrab(inode));
 
 	jbd2_journal_destroy(journal);
 
-- 
1.8.3.1



_______________________________________________
Ocfs2-devel mailing list
Ocfs2-devel@oss.oracle.com
https://oss.oracle.com/mailman/listinfo/ocfs2-devel
