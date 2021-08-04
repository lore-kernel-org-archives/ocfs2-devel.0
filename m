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
	by smtp.lore.kernel.org (Postfix) with ESMTP id BC814C432BE
	for <ocfs2-devel@archiver.kernel.org>; Wed, 11 Aug 2021 05:02:48 +0000 (UTC)
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id 6560660F13
	for <ocfs2-devel@archiver.kernel.org>; Wed, 11 Aug 2021 05:02:48 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org 6560660F13
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=gmail.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=oss.oracle.com
Received: from pps.filterd (m0246617.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 17B4u0M2024782;
	Wed, 11 Aug 2021 05:02:48 GMT
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
	by mx0b-00069f02.pphosted.com with ESMTP id 3abwqgs2h9-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 11 Aug 2021 05:02:47 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
	by userp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 17B4uENe184723;
	Wed, 11 Aug 2021 05:02:46 GMT
Received: from oss.oracle.com (oss-old-reserved.oracle.com [137.254.22.2])
	by userp3020.oracle.com with ESMTP id 3aa3xuc9mj-1
	(version=TLSv1 cipher=AES256-SHA bits=256 verify=NO);
	Wed, 11 Aug 2021 05:02:46 +0000
Received: from localhost ([127.0.0.1] helo=lb-oss.oracle.com)
	by oss.oracle.com with esmtp (Exim 4.63)
	(envelope-from <ocfs2-devel-bounces@oss.oracle.com>)
	id 1mDgO3-0006bM-SJ; Tue, 10 Aug 2021 22:02:43 -0700
Received: from aserp3030.oracle.com ([141.146.126.71])
	by oss.oracle.com with esmtp (Exim 4.63)
	(envelope-from <islituo@gmail.com>) id 1mB7R1-0008Kd-E5
	for ocfs2-devel@oss.oracle.com; Tue, 03 Aug 2021 20:19:11 -0700
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
	by aserp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id
	1743A8KI151152
	for <ocfs2-devel@oss.oracle.com>; Wed, 4 Aug 2021 03:19:11 GMT
Received: from mx0b-00069f01.pphosted.com (mx0b-00069f01.pphosted.com
	[205.220.177.26]) by aserp3030.oracle.com with ESMTP id 3a78d5v6wd-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
	for <ocfs2-devel@oss.oracle.com>; Wed, 04 Aug 2021 03:19:11 +0000
Received: from pps.filterd (m0246578.ppops.net [127.0.0.1])
	by mx0b-00069f01.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id
	1743HGkT004946
	for <ocfs2-devel@oss.oracle.com>; Wed, 4 Aug 2021 03:19:10 GMT
Received: from mail-pj1-f54.google.com (mail-pj1-f54.google.com
	[209.85.216.54])
	by mx0b-00069f01.pphosted.com with ESMTP id 3a77ntpdtx-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=OK)
	for <ocfs2-devel@oss.oracle.com>; Wed, 04 Aug 2021 03:19:10 +0000
Received: by mail-pj1-f54.google.com with SMTP id
	t7-20020a17090a5d87b029017807007f23so3591634pji.5
	for <ocfs2-devel@oss.oracle.com>; Tue, 03 Aug 2021 20:19:09 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=1e100.net; s=20161025;
	h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
	:content-transfer-encoding;
	bh=u4aFCESye5oCd8ozjWGaxQW4ltU+c58Zn/mosfi41Qk=;
	b=rBb4xRTd77oa5+/pFZbrBhoW3UQAgqYEkS4ty3HoxlZTwGJw3128VXKw4rZTuyAQuC
	IS6aqLr045UpR+r6FaBf5d8YF8lUC53ms5RzkGgpSDl8DxgVTZUxFVfwoCfIxmtg/9DV
	VfGcnDx0osCYxCv7mzI0L6dH7n/DfNP78ERn2qb0G/xLZLdtEsNbf3gxQwa5992Zrg5s
	xHlB1O7JkM/0YnRrVijnAKHrTNLI8L+LskYQqYz331O/2qNnrC8RdXQsz4w/lB+obkmI
	TzbqGd/Bp6C5zLdNZbO+2SpaHo9U2oxRObQ2FR+VQXp4xMZFRjVPllp2+2WYJgrFk1B8
	Hj2A==
X-Gm-Message-State: AOAM533gbgKLgeD1yOeklxUgU/1YoAp7MvBTBLX5Yatp8ph9gaQsprMU
	7WIyex89z1NppTETD9ke1zuaIOT2s97BDA==
X-Google-Smtp-Source: ABdhPJz+61y8oKEZlfd3ZvPj6B8cKNOShRk6IRWj1jRpM4L3FfiirA4SGwI7cfg7qxH9R+XNXERoSA==
X-Received: by 2002:a17:90a:8a8f:: with SMTP id
	x15mr25373472pjn.161.1628047148651; 
	Tue, 03 Aug 2021 20:19:08 -0700 (PDT)
Received: from localhost.localdomain ([45.135.186.49])
	by smtp.gmail.com with ESMTPSA id w11sm689514pgk.34.2021.08.03.20.19.06
	(version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
	Tue, 03 Aug 2021 20:19:07 -0700 (PDT)
From: Tuo Li <islituo@gmail.com>
To: mark@fasheh.com, jlbec@evilplan.org, joseph.qi@linux.alibaba.com
Date: Tue,  3 Aug 2021 20:18:32 -0700
Message-Id: <20210804031832.57154-1-islituo@gmail.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
X-Source-IP: 209.85.216.54
X-ServerName: mail-pj1-f54.google.com
X-Proofpoint-SPF-Result: pass
X-Proofpoint-SPF-Record: v=spf1 redirect=_spf.google.com
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=10065
	signatures=668682
X-Proofpoint-Spam-Details: rule=tap_notspam policy=tap score=0 bulkscore=0
	mlxlogscore=999
	priorityscore=423 impostorscore=0 adultscore=0 suspectscore=0
	mlxscore=0
	spamscore=0 malwarescore=0 clxscore=110 phishscore=0 lowpriorityscore=0
	classifier=spam adjust=0 reason=mlx scancount=1
	engine=8.12.0-2107140000
	definitions=main-2108040018 domainage_hfrom=9488
X-Spam: Clean
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=10065
	signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999
	mlxscore=0 adultscore=0
	malwarescore=0 phishscore=0 bulkscore=0 spamscore=0 suspectscore=0
	classifier=spam adjust=0 reason=mlx scancount=1
	engine=8.12.0-2107140000 definitions=main-2108040017
X-Mailman-Approved-At: Tue, 10 Aug 2021 22:02:41 -0700
Cc: TOTE Robot <oslab@tsinghua.edu.cn>, baijiaju1990@gmail.com,
        linux-kernel@vger.kernel.org, ocfs2-devel@oss.oracle.com,
        Tuo Li <islituo@gmail.com>
Subject: [Ocfs2-devel] [PATCH v3] ocfs2: quota_local: fix possible
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
X-Proofpoint-ORIG-GUID: eroRUBTPnL5i9aHZ_EOtJ6YRhyfhZ7Jn
X-Proofpoint-GUID: eroRUBTPnL5i9aHZ_EOtJ6YRhyfhZ7Jn

A memory block is allocated through kmalloc(), and its return value is
assigned to the pointer oinfo. However, oinfo->dqi_gqinode is not
initialized but it is accessed in:
  iput(oinfo->dqi_gqinode);

To fix this possible uninitialized-variable access, assign NULL to
oinfo->dqi_gqinode, and add ocfs2_qinfo_lock_res_init()
behind the assignment in ocfs2_local_read_info(). Remove
ocfs2_qinfo_lock_res_init() in ocfs2_global_read_info().

Reported-by: TOTE Robot <oslab@tsinghua.edu.cn>
Signed-off-by: Tuo Li <islituo@gmail.com>
---
v3:
* Update description.
* Assign NULL to oinfo->dqi_gqinode, and add ocfs2_qinfo_lock_res_init()
behind the assignment in ocfs2_local_read_info(). Remove
ocfs2_qinfo_lock_res_init() in ocfs2_global_read_info()
  Thank Joseph Qi for helpful advice.
v2:
* Replace kzalloc() with NULL assignment to oinfo->dqi_gqinode.
  Thank Joseph Qi for helpful advice.
---
 fs/ocfs2/quota_global.c | 1 -
 fs/ocfs2/quota_local.c  | 2 ++
 2 files changed, 2 insertions(+), 1 deletion(-)

diff --git a/fs/ocfs2/quota_global.c b/fs/ocfs2/quota_global.c
index eda83487c9ec..f033de733adb 100644
--- a/fs/ocfs2/quota_global.c
+++ b/fs/ocfs2/quota_global.c
@@ -357,7 +357,6 @@ int ocfs2_global_read_info(struct super_block *sb, int type)
 	}
 	oinfo->dqi_gi.dqi_sb = sb;
 	oinfo->dqi_gi.dqi_type = type;
-	ocfs2_qinfo_lock_res_init(&oinfo->dqi_gqlock, oinfo);
 	oinfo->dqi_gi.dqi_entry_size = sizeof(struct ocfs2_global_disk_dqblk);
 	oinfo->dqi_gi.dqi_ops = &ocfs2_global_ops;
 	oinfo->dqi_gqi_bh = NULL;
diff --git a/fs/ocfs2/quota_local.c b/fs/ocfs2/quota_local.c
index b1a8b046f4c2..0e4b16d4c037 100644
--- a/fs/ocfs2/quota_local.c
+++ b/fs/ocfs2/quota_local.c
@@ -702,6 +702,8 @@ static int ocfs2_local_read_info(struct super_block *sb, int type)
 	info->dqi_priv = oinfo;
 	oinfo->dqi_type = type;
 	INIT_LIST_HEAD(&oinfo->dqi_chunk);
+	oinfo->dqi_gqinode = NULL;
+	ocfs2_qinfo_lock_res_init(&oinfo->dqi_gqlock, oinfo);
 	oinfo->dqi_rec = NULL;
 	oinfo->dqi_lqi_bh = NULL;
 	oinfo->dqi_libh = NULL;
-- 
2.25.1


_______________________________________________
Ocfs2-devel mailing list
Ocfs2-devel@oss.oracle.com
https://oss.oracle.com/mailman/listinfo/ocfs2-devel
