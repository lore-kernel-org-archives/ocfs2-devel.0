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
	by smtp.lore.kernel.org (Postfix) with ESMTP id F17F5C433F5
	for <ocfs2-devel@archiver.kernel.org>; Mon, 13 Sep 2021 14:29:00 +0000 (UTC)
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id BA68E60F44
	for <ocfs2-devel@archiver.kernel.org>; Mon, 13 Sep 2021 14:29:00 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org BA68E60F44
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=gmail.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=oss.oracle.com
Received: from pps.filterd (m0246629.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 18DESwS0024805;
	Mon, 13 Sep 2021 14:29:00 GMT
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
	by mx0b-00069f02.pphosted.com with ESMTP id 3b1ka92qus-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 13 Sep 2021 14:28:59 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
	by userp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 18DED7DG133734;
	Mon, 13 Sep 2021 14:28:48 GMT
Received: from oss.oracle.com (oss-old-reserved.oracle.com [137.254.22.2])
	by userp3030.oracle.com with ESMTP id 3b0hjtjvqv-1;
	Mon, 13 Sep 2021 14:28:48 +0000
Received: from localhost ([127.0.0.1] helo=lb-oss.oracle.com)
	by oss.oracle.com with esmtp (Exim 4.63)
	(envelope-from <ocfs2-devel-bounces@oss.oracle.com>)
	id 1mPmwx-0004af-Gt; Mon, 13 Sep 2021 07:28:47 -0700
Received: from userp3020.oracle.com ([156.151.31.79])
	by oss.oracle.com with esmtp (Exim 4.63)
	(envelope-from <cgel.zte@gmail.com>) id 1mImRs-0005jA-Kz
	for ocfs2-devel@oss.oracle.com; Tue, 24 Aug 2021 23:31:44 -0700
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
	by userp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id
	17P6PTbC131406
	for <ocfs2-devel@oss.oracle.com>; Wed, 25 Aug 2021 06:31:44 GMT
Received: from mx0b-00069f01.pphosted.com (mx0b-00069f01.pphosted.com
	[205.220.177.26]) by userp3020.oracle.com with ESMTP id 3akb8w8bmy-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
	for <ocfs2-devel@oss.oracle.com>; Wed, 25 Aug 2021 06:31:44 +0000
Received: from pps.filterd (m0246579.ppops.net [127.0.0.1])
	by mx0b-00069f01.pphosted.com (8.16.1.2/8.16.0.43) with SMTP id
	17OMfMf5017764
	for <ocfs2-devel@oss.oracle.com>; Wed, 25 Aug 2021 06:31:43 GMT
Received: from mail-qt1-f182.google.com (mail-qt1-f182.google.com
	[209.85.160.182])
	by mx0b-00069f01.pphosted.com with ESMTP id 3an9sb3yat-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=OK)
	for <ocfs2-devel@oss.oracle.com>; Wed, 25 Aug 2021 06:31:42 +0000
Received: by mail-qt1-f182.google.com with SMTP id t9so10905045qtp.2
	for <ocfs2-devel@oss.oracle.com>; Tue, 24 Aug 2021 23:31:42 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=1e100.net; s=20161025;
	h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
	:content-transfer-encoding;
	bh=qlvI1z1fCV6l+6vZ2EyAPBZvTPzpiJMGsKK1eVy8PQQ=;
	b=PckLCY9QrpkRrOq91aUTd7xZGgNeZ8DAUhSzyFUo1q2nDsK7o2YzUnIHOVW5no0A9H
	2Ma/QXR0shBKdcK5Q4w7ZxLZAzMzvlml3yu2UWarB/3e8xZKdDbHlJ85mxFDg8r3c44U
	b5zLYtjWPeDaUab8CH0UKPCcPAjOxUZZy9xH2rl4bK7wN3gZKQUX7NAjkJUQVCl6r+zO
	m3VEVzbMpY0Yhl4qvAAyGIAJdosIcRSwxva6f3qYTgN7lbKmWhyfsRAvmFjK2V8Hd2El
	M04N/iNOUVLoS4kLTIJW+PnVSXT1M0aNZsF9VjbLJ3TUeVPS4PyaSzZ2J66jO42xShlH
	3zVQ==
X-Gm-Message-State: AOAM532AmjCSqJVTttU/+zCnRflhqj1IqkxOu0U86Br7Xbvaszqv8BcJ
	kh1Jm7/XxaYYtPu/YVdG+zM=
X-Google-Smtp-Source: ABdhPJxOvyzwq6k4wkXWf3bH2J10C0gjxNnf+JrfUPKAK2tIHlB2s6dEK67no4+GfSExe+eBeBi/Ng==
X-Received: by 2002:a05:622a:2cc:: with SMTP id
	a12mr37952327qtx.115.1629873101895; 
	Tue, 24 Aug 2021 23:31:41 -0700 (PDT)
Received: from localhost.localdomain ([193.203.214.57])
	by smtp.gmail.com with ESMTPSA id
	m19sm9247058qtx.84.2021.08.24.23.31.39
	(version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
	Tue, 24 Aug 2021 23:31:41 -0700 (PDT)
From: CGEL <cgel.zte@gmail.com>
X-Google-Original-From: CGEL <deng.changcheng@zte.com.cn>
To: Mark Fasheh <mark@fasheh.com>
Date: Tue, 24 Aug 2021 23:31:25 -0700
Message-Id: <20210825063125.70192-1-deng.changcheng@zte.com.cn>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
X-Source-IP: 209.85.160.182
X-ServerName: mail-qt1-f182.google.com
X-Proofpoint-SPF-Result: pass
X-Proofpoint-SPF-Record: v=spf1 redirect=_spf.google.com
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10086
	signatures=668682
X-Proofpoint-Spam-Details: rule=tap_notspam policy=tap score=0
	priorityscore=426 bulkscore=0
	adultscore=0 phishscore=0 mlxlogscore=999 lowpriorityscore=0
	clxscore=290
	mlxscore=0 spamscore=0 suspectscore=0 impostorscore=0 malwarescore=0
	classifier=spam adjust=0 reason=mlx scancount=1
	engine=8.12.0-2107140000 definitions=main-2108250037
X-Spam: Clean
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10086
	signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0
	phishscore=0 spamscore=0
	bulkscore=0 mlxlogscore=999 malwarescore=0 adultscore=0 mlxscore=0
	classifier=spam adjust=0 reason=mlx scancount=1
	engine=8.12.0-2107140000 definitions=main-2108250037
X-Mailman-Approved-At: Mon, 13 Sep 2021 07:28:45 -0700
Cc: Yury Norov <yury.norov@gmail.com>,
        Jing Yangyang <jing.yangyang@zte.com.cn>,
        Masahiro Yamada <masahiroy@kernel.org>, linux-kernel@vger.kernel.org,
        Zeal Robot <zealci@zte.com.cn>, ocfs2-devel@oss.oracle.com
Subject: [Ocfs2-devel] [PATCH linux-next] fs/ocfs2/dlm/dlmmaster.c: fix
	bugon.cocci warnings
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
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 adultscore=0 phishscore=0
 mlxlogscore=999 suspectscore=0 spamscore=0 bulkscore=0 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2109030001
 definitions=main-2109130095
X-Proofpoint-GUID: 1cmv4VLRQRUBfTuumS-BBQko3fBSoBQ2
X-Proofpoint-ORIG-GUID: 1cmv4VLRQRUBfTuumS-BBQko3fBSoBQ2

From: Jing Yangyang <jing.yangyang@zte.com.cn>

Use BUG_ON instead of a if condition followed by BUG.

Generated by: scripts/coccinelle/misc/bugon.cocci

Reported-by: Zeal Robot <zealci@zte.com.cn>
Signed-off-by: Jing Yangyang <jing.yangyang@zte.com.cn>
---
 fs/ocfs2/dlm/dlmmaster.c | 6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

diff --git a/fs/ocfs2/dlm/dlmmaster.c b/fs/ocfs2/dlm/dlmmaster.c
index 227da5b..afaf9a7 100644
--- a/fs/ocfs2/dlm/dlmmaster.c
+++ b/fs/ocfs2/dlm/dlmmaster.c
@@ -2181,8 +2181,7 @@ static int dlm_pre_master_reco_lockres(struct dlm_ctxt *dlm,
 		ret = dlm_do_master_requery(dlm, res, nodenum, &master);
 		if (ret < 0) {
 			mlog_errno(ret);
-			if (!dlm_is_host_down(ret))
-				BUG();
+			BUG_ON(!dlm_is_host_down(ret));
 			/* host is down, so answer for that node would be
 			 * DLM_LOCK_RES_OWNER_UNKNOWN.  continue. */
 			ret = 0;
@@ -2238,8 +2237,7 @@ int dlm_drop_lockres_ref(struct dlm_ctxt *dlm, struct dlm_lock_resource *res)
 		mlog(ML_ERROR, "%s: res %.*s, DEREF to node %u got %d\n",
 		     dlm->name, namelen, lockname, res->owner, r);
 		dlm_print_one_lock_resource(res);
-		if (r == -ENOMEM)
-			BUG();
+		BUG_ON(r == -ENOMEM);
 	} else
 		ret = r;
 
-- 
1.8.3.1



_______________________________________________
Ocfs2-devel mailing list
Ocfs2-devel@oss.oracle.com
https://oss.oracle.com/mailman/listinfo/ocfs2-devel
