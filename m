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
	by smtp.lore.kernel.org (Postfix) with ESMTP id EC11AC4338F
	for <ocfs2-devel@archiver.kernel.org>; Wed, 11 Aug 2021 05:05:57 +0000 (UTC)
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id 794CD60E9B
	for <ocfs2-devel@archiver.kernel.org>; Wed, 11 Aug 2021 05:05:57 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org 794CD60E9B
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=gmail.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=oss.oracle.com
Received: from pps.filterd (m0246632.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 17B4tsvm009846;
	Wed, 11 Aug 2021 05:05:56 GMT
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
	by mx0b-00069f02.pphosted.com with ESMTP id 3aay0fwggy-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 11 Aug 2021 05:05:56 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
	by userp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 17B4uExv184748;
	Wed, 11 Aug 2021 05:05:54 GMT
Received: from oss.oracle.com (oss-old-reserved.oracle.com [137.254.22.2])
	by userp3020.oracle.com with ESMTP id 3aa3xucd8g-1
	(version=TLSv1 cipher=AES256-SHA bits=256 verify=NO);
	Wed, 11 Aug 2021 05:05:54 +0000
Received: from localhost ([127.0.0.1] helo=lb-oss.oracle.com)
	by oss.oracle.com with esmtp (Exim 4.63)
	(envelope-from <ocfs2-devel-bounces@oss.oracle.com>)
	id 1mDgO3-0006ar-Ak; Tue, 10 Aug 2021 22:02:43 -0700
Received: from aserp3020.oracle.com ([141.146.126.70])
	by oss.oracle.com with esmtp (Exim 4.63)
	(envelope-from <islituo@gmail.com>) id 1mB5yl-00020m-4h
	for ocfs2-devel@oss.oracle.com; Tue, 03 Aug 2021 18:45:55 -0700
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
	by aserp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id
	1741jtE3000835
	for <ocfs2-devel@oss.oracle.com>; Wed, 4 Aug 2021 01:45:55 GMT
Received: from mx0b-00069f01.pphosted.com (mx0b-00069f01.pphosted.com
	[205.220.177.26]) by aserp3020.oracle.com with ESMTP id 3a4xb7qve3-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
	for <ocfs2-devel@oss.oracle.com>; Wed, 04 Aug 2021 01:45:54 +0000
Received: from pps.filterd (m0246577.ppops.net [127.0.0.1])
	by mx0b-00069f01.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id
	1741bUqD020442
	for <ocfs2-devel@oss.oracle.com>; Wed, 4 Aug 2021 01:45:43 GMT
Received: from mail-pl1-f170.google.com (mail-pl1-f170.google.com
	[209.85.214.170])
	by mx0b-00069f01.pphosted.com with ESMTP id 3a75yaxnp2-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=OK)
	for <ocfs2-devel@oss.oracle.com>; Wed, 04 Aug 2021 01:45:43 +0000
Received: by mail-pl1-f170.google.com with SMTP id j3so1259812plx.4
	for <ocfs2-devel@oss.oracle.com>; Tue, 03 Aug 2021 18:45:43 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=1e100.net; s=20161025;
	h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
	:content-transfer-encoding;
	bh=vNRaHSjm+7RgDJm/dANaaa1Byd60xBWxjojsFb0do0o=;
	b=fKd7YuOGM+Ts7mp0IYsjb9GV0GS+V33tp5WM8uo1AyD00oui9HiuALQ7LvSF113Mrw
	gQuVZlhahCICPHD+lcUnKgteGcBwk27Mgang+YrjgEyGDfljji3FSBtbGw9U6IHSpOg1
	VyY3IxqQoMc77bz82HpVD+HIHLTf7wM9ALRmqtvVgj3z6NHnHi9uNApIgKRiup3Ai9Y1
	z7b6thQR/N5WLK2zfJX7JbjNlDQYjXBtEdSCk07ZBu9PqR1gwkotBv1SvGxUBZwFck1v
	3x7LunP5xrdKkfJD4lbDrs+oAgiC1xPWyMnZ6g2XNc+Aw7TFYd3uH6DRl2CdmreLIvi4
	IDdA==
X-Gm-Message-State: AOAM5323JX5Fu+H55LZg3Z6pxXCqnV+xOLfn/ASdpkYXX1G7O+g3VOpO
	CryawCFivVWkx9yTLjGw5vE=
X-Google-Smtp-Source: ABdhPJzvR7WL4YbOVs8dGOps/kNt0aGMdVazGuJMy9N1YWA78Orj60RxPGiOlM59xnaKqvoAV/QUjA==
X-Received: by 2002:a17:90b:344:: with SMTP id
	fh4mr24879918pjb.29.1628041541758; 
	Tue, 03 Aug 2021 18:45:41 -0700 (PDT)
Received: from localhost.localdomain ([45.135.186.49])
	by smtp.gmail.com with ESMTPSA id z124sm476074pgb.6.2021.08.03.18.45.38
	(version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
	Tue, 03 Aug 2021 18:45:40 -0700 (PDT)
From: Tuo Li <islituo@gmail.com>
To: mark@fasheh.com, jlbec@evilplan.org, joseph.qi@linux.alibaba.com
Date: Tue,  3 Aug 2021 18:45:10 -0700
Message-Id: <20210804014510.29430-1-islituo@gmail.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
X-Source-IP: 209.85.214.170
X-ServerName: mail-pl1-f170.google.com
X-Proofpoint-SPF-Result: pass
X-Proofpoint-SPF-Record: v=spf1 redirect=_spf.google.com
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=10065
	signatures=668682
X-Proofpoint-Spam-Details: rule=tap_notspam policy=tap score=0 phishscore=0
	mlxlogscore=999
	spamscore=0 priorityscore=337 suspectscore=0 impostorscore=0 mlxscore=0
	adultscore=0 bulkscore=0 malwarescore=0 clxscore=221 lowpriorityscore=0
	classifier=spam adjust=0 reason=mlx scancount=1
	engine=8.12.0-2107140000
	definitions=main-2108040007 domainage_hfrom=9488
X-Spam: Clean
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=10065
	signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0
	phishscore=0 malwarescore=0
	bulkscore=0 spamscore=0 adultscore=0 mlxlogscore=999 suspectscore=0
	classifier=spam adjust=0 reason=mlx scancount=1
	engine=8.12.0-2107140000 definitions=main-2108040008
X-Mailman-Approved-At: Tue, 10 Aug 2021 22:02:41 -0700
Cc: TOTE Robot <oslab@tsinghua.edu.cn>, baijiaju1990@gmail.com,
        linux-kernel@vger.kernel.org, ocfs2-devel@oss.oracle.com,
        Tuo Li <islituo@gmail.com>
Subject: [Ocfs2-devel] [PATCH v2] ocfs2: quota_local: fix possible
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
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 mlxscore=0
 suspectscore=0 malwarescore=0 phishscore=0 adultscore=0 spamscore=0
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2107140000 definitions=main-2108110030
X-Proofpoint-ORIG-GUID: WIcIg0wdBXq88-Nsz9WlRGR_hS5ESAI6
X-Proofpoint-GUID: WIcIg0wdBXq88-Nsz9WlRGR_hS5ESAI6

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
v2:
* Replace kzalloc() with NULL assignment to oinfo->dqi_gqinode.
  Thank Joseph Qi for helpful advice.
---
 fs/ocfs2/quota_local.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/fs/ocfs2/quota_local.c b/fs/ocfs2/quota_local.c
index b1a8b046f4c2..de5aae584d5d 100644
--- a/fs/ocfs2/quota_local.c
+++ b/fs/ocfs2/quota_local.c
@@ -703,6 +703,7 @@ static int ocfs2_local_read_info(struct super_block *sb, int type)
 	oinfo->dqi_type = type;
 	INIT_LIST_HEAD(&oinfo->dqi_chunk);
 	oinfo->dqi_rec = NULL;
+	oinfo->dqi_gqinode = NULL;
 	oinfo->dqi_lqi_bh = NULL;
 	oinfo->dqi_libh = NULL;
 
-- 
2.25.1


_______________________________________________
Ocfs2-devel mailing list
Ocfs2-devel@oss.oracle.com
https://oss.oracle.com/mailman/listinfo/ocfs2-devel
