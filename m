Return-Path: <SRS0=itZy=NC=oss.oracle.com=ocfs2-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.7 required=3.0 tests=BAYES_00,
	DKIM_ADSP_CUSTOM_MED,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0D652C4338F
	for <ocfs2-devel@archiver.kernel.org>; Wed, 11 Aug 2021 05:09:05 +0000 (UTC)
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id A66A060F13
	for <ocfs2-devel@archiver.kernel.org>; Wed, 11 Aug 2021 05:09:04 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org A66A060F13
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=gmail.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=oss.oracle.com
Received: from pps.filterd (m0246632.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 17B57q2b028656;
	Wed, 11 Aug 2021 05:09:03 GMT
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
	by mx0b-00069f02.pphosted.com with ESMTP id 3aay0fwgp2-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 11 Aug 2021 05:09:03 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
	by userp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 17B56Bn2196216;
	Wed, 11 Aug 2021 05:09:02 GMT
Received: from oss.oracle.com (oss-old-reserved.oracle.com [137.254.22.2])
	by userp3030.oracle.com with ESMTP id 3abjw5nn85-1
	(version=TLSv1 cipher=AES256-SHA bits=256 verify=NO);
	Wed, 11 Aug 2021 05:09:02 +0000
Received: from localhost ([127.0.0.1] helo=lb-oss.oracle.com)
	by oss.oracle.com with esmtp (Exim 4.63)
	(envelope-from <ocfs2-devel-bounces@oss.oracle.com>)
	id 1mDgO2-0006Zu-E7; Tue, 10 Aug 2021 22:02:42 -0700
Received: from userp3030.oracle.com ([156.151.31.80])
	by oss.oracle.com with esmtp (Exim 4.63)
	(envelope-from <islituo@gmail.com>) id 1m9js5-0005Kc-4b
	for ocfs2-devel@oss.oracle.com; Sat, 31 Jul 2021 00:57:25 -0700
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
	by userp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id
	16V7t6vI009769
	for <ocfs2-devel@oss.oracle.com>; Sat, 31 Jul 2021 07:57:24 GMT
Received: from mx0a-00069f01.pphosted.com (mx0a-00069f01.pphosted.com
	[205.220.165.26]) by userp3030.oracle.com with ESMTP id 3a4umtg4rn-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
	for <ocfs2-devel@oss.oracle.com>; Sat, 31 Jul 2021 07:57:24 +0000
Received: from pps.filterd (m0246571.ppops.net [127.0.0.1])
	by mx0b-00069f01.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id
	16V7kntO015417
	for <ocfs2-devel@oss.oracle.com>; Sat, 31 Jul 2021 07:57:23 GMT
Received: from mail-pl1-f176.google.com (mail-pl1-f176.google.com
	[209.85.214.176])
	by mx0b-00069f01.pphosted.com with ESMTP id 3a4x7vsrgk-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=OK)
	for <ocfs2-devel@oss.oracle.com>; Sat, 31 Jul 2021 07:57:23 +0000
Received: by mail-pl1-f176.google.com with SMTP id t21so13774575plr.13
	for <ocfs2-devel@oss.oracle.com>; Sat, 31 Jul 2021 00:57:22 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=1e100.net; s=20161025;
	h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
	:content-transfer-encoding;
	bh=jQujshHE7jKWS1+C7xQP9tnfF3yH0GDVGZkIK3moVlU=;
	b=XdQY6kshPg4feQe2aytVzJQzJeUYn4P44pyxBnvapslUjpjmADltJdQIPBLtRjyWtu
	I//KRq9VttdlSMVsHaPI/QV5pFwJ6j7swH6QWA4TXEtuyJBsGA9n7V6YUfxk82s7+2cL
	V/iCUA3crlhFC5TqMXQGVs5GXOvo8S8qdivOZIEd3L8J5J+Zu3Aj9RLt+jPpsiiTGuQt
	wyAf2AmCAP53pnJAkue3Zu+vKOJOrx2MJ5LjQNYhb3H+o+HQHNvBre6PrJYMFIm16EfR
	+2MYgE7uZylN+THJoqIF3ojqrevXNmynrPp6RREF/ZRXccjVc0qcCPipAebC8DCGYlfV
	YprA==
X-Gm-Message-State: AOAM5309PZx1GsonoaDo63Ove6wMQOFMYQBq+RwQ8xr8i35MsMbvlUrF
	cbb/oF33n4T3ZEcXxijWXdU=
X-Google-Smtp-Source: ABdhPJxLWzpfwgdJKJml+8xRal8USXAvCo0f5vC8aGxcUOjHhaZnQcIlzhD4uSXkGEwAMEnCWlSGYw==
X-Received: by 2002:a17:902:ac94:b029:12c:9bae:7d with SMTP id
	h20-20020a170902ac94b029012c9bae007dmr3031701plr.32.1627718242052;
	Sat, 31 Jul 2021 00:57:22 -0700 (PDT)
Received: from localhost.localdomain ([45.135.186.29])
	by smtp.gmail.com with ESMTPSA id
	ge21sm4361615pjb.55.2021.07.31.00.57.19
	(version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
	Sat, 31 Jul 2021 00:57:21 -0700 (PDT)
From: Tuo Li <islituo@gmail.com>
To: mark@fasheh.com, jlbec@evilplan.org, joseph.qi@linux.alibaba.com
Date: Sat, 31 Jul 2021 00:56:59 -0700
Message-Id: <20210731075659.73505-1-islituo@gmail.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
X-Source-IP: 209.85.214.176
X-ServerName: mail-pl1-f176.google.com
X-Proofpoint-SPF-Result: pass
X-Proofpoint-SPF-Record: v=spf1 redirect=_spf.google.com
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=10061
	signatures=668682
X-Proofpoint-Spam-Details: rule=tap_notspam policy=tap score=0 malwarescore=0
	mlxscore=0 adultscore=0
	spamscore=0 clxscore=223 lowpriorityscore=0 impostorscore=0
	suspectscore=0
	mlxlogscore=999 priorityscore=329 bulkscore=0 phishscore=0
	classifier=spam
	adjust=0 reason=mlx scancount=1 engine=8.12.0-2107140000
	definitions=main-2107310037 domainage_hfrom=9484
X-Spam: Clean
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=10061
	signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0
	phishscore=0 malwarescore=0
	suspectscore=0 mlxscore=0 adultscore=0 mlxlogscore=999 spamscore=0
	classifier=spam adjust=0 reason=mlx scancount=1
	engine=8.12.0-2107140000 definitions=main-2107310038
X-Mailman-Approved-At: Tue, 10 Aug 2021 22:02:40 -0700
Cc: TOTE Robot <oslab@tsinghua.edu.cn>, baijiaju1990@gmail.com,
        linux-kernel@vger.kernel.org, ocfs2-devel@oss.oracle.com,
        Tuo Li <islituo@gmail.com>
Subject: [Ocfs2-devel] [PATCH] ocfs2: quota_local: fix possible
	uninitialized-variable access in ocfs2_local_read_info()
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
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=10072 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 mlxlogscore=999
 malwarescore=0 phishscore=0 bulkscore=0 suspectscore=0 mlxscore=0
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2107140000 definitions=main-2108110031
X-Proofpoint-ORIG-GUID: 9azIfr8IgQtLYVxkIuYpug4Os6cp7CVd
X-Proofpoint-GUID: 9azIfr8IgQtLYVxkIuYpug4Os6cp7CVd

A memory block is allocated through kmalloc(), and its return value is
assigned to the pointer oinfo. If the return value of
ocfs2_global_read_info() at line 709 is less than zero,
oinfo->dqi_gqinode may be not initialized. However, it is accessed at
line 775:
  iput(oinfo->dqi_gqinode);

To fix this possible uninitialized-variable access, replace kmalloc()
with kzalloc() when allocating memory for oinfo.

Reported-by: TOTE Robot <oslab@tsinghua.edu.cn>
Signed-off-by: Tuo Li <islituo@gmail.com>
---
 fs/ocfs2/quota_local.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/ocfs2/quota_local.c b/fs/ocfs2/quota_local.c
index b1a8b046f4c2..4c1219e08b49 100644
--- a/fs/ocfs2/quota_local.c
+++ b/fs/ocfs2/quota_local.c
@@ -693,7 +693,7 @@ static int ocfs2_local_read_info(struct super_block *sb, int type)
 
 	info->dqi_max_spc_limit = 0x7fffffffffffffffLL;
 	info->dqi_max_ino_limit = 0x7fffffffffffffffLL;
-	oinfo = kmalloc(sizeof(struct ocfs2_mem_dqinfo), GFP_NOFS);
+	oinfo = kzalloc(sizeof(struct ocfs2_mem_dqinfo), GFP_NOFS);
 	if (!oinfo) {
 		mlog(ML_ERROR, "failed to allocate memory for ocfs2 quota"
 			       " info.");
-- 
2.25.1


_______________________________________________
Ocfs2-devel mailing list
Ocfs2-devel@oss.oracle.com
https://oss.oracle.com/mailman/listinfo/ocfs2-devel
