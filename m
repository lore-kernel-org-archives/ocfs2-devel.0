Return-Path: <SRS0=yFdm=IX=oss.oracle.com=ocfs2-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.7 required=3.0 tests=BAYES_00,
	DKIM_ADSP_CUSTOM_MED,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 09E29C433C1
	for <ocfs2-devel@archiver.kernel.org>; Thu, 25 Mar 2021 13:48:23 +0000 (UTC)
Received: from aserp2120.oracle.com (aserp2120.oracle.com [141.146.126.78])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id 9790A61A12
	for <ocfs2-devel@archiver.kernel.org>; Thu, 25 Mar 2021 13:48:22 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 9790A61A12
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=gmail.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=ocfs2-devel-bounces@oss.oracle.com
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
	by aserp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 12PDjcDO032827;
	Thu, 25 Mar 2021 13:48:21 GMT
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
	by aserp2120.oracle.com with ESMTP id 37d90mpa16-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 25 Mar 2021 13:48:21 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
	by userp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 12PDkG9l081521;
	Thu, 25 Mar 2021 13:48:20 GMT
Received: from oss.oracle.com (oss-old-reserved.oracle.com [137.254.22.2])
	by userp3020.oracle.com with ESMTP id 37dttupvha-1
	(version=TLSv1 cipher=AES256-SHA bits=256 verify=NO);
	Thu, 25 Mar 2021 13:48:20 +0000
Received: from localhost ([127.0.0.1] helo=lb-oss.oracle.com)
	by oss.oracle.com with esmtp (Exim 4.63)
	(envelope-from <ocfs2-devel-bounces@oss.oracle.com>)
	id 1lPQIQ-0005v1-AV; Thu, 25 Mar 2021 06:45:10 -0700
Received: from userp3020.oracle.com ([156.151.31.79])
	by oss.oracle.com with esmtp (Exim 4.63)
	(envelope-from <unixbhaskar@gmail.com>) id 1lOxvk-0006gd-R2
	for ocfs2-devel@oss.oracle.com; Wed, 24 Mar 2021 00:27:52 -0700
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
	by userp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id
	12O7QBlR154880
	for <ocfs2-devel@oss.oracle.com>; Wed, 24 Mar 2021 07:27:52 GMT
Received: from userp2030.oracle.com (userp2030.oracle.com [156.151.31.89])
	by userp3020.oracle.com with ESMTP id 37dttsyg5n-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
	for <ocfs2-devel@oss.oracle.com>; Wed, 24 Mar 2021 07:27:52 +0000
Received: from pps.filterd (userp2030.oracle.com [127.0.0.1])
	by userp2030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id
	12O7NWK2026348
	for <ocfs2-devel@oss.oracle.com>; Wed, 24 Mar 2021 07:27:51 GMT
Received: from mail-qt1-f175.google.com (mail-qt1-f175.google.com
	[209.85.160.175]) by userp2030.oracle.com with ESMTP id 37d73k4ref-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=OK)
	for <ocfs2-devel@oss.oracle.com>; Wed, 24 Mar 2021 07:27:51 +0000
Received: by mail-qt1-f175.google.com with SMTP id m7so16868084qtq.11
	for <ocfs2-devel@oss.oracle.com>; Wed, 24 Mar 2021 00:27:51 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=1e100.net; s=20161025;
	h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
	:content-transfer-encoding;
	bh=doLGIOHegWUY4bKonv54TOpnfPrc1iFCg0IxD5DTTns=;
	b=CJK8nT+/AqJJEW7r1TQpYBsU4a/0bGn1EqEwBPnTVSu7emQaG/IJBKjbGTufn56HIt
	vtuxZc9iZqYx9UoD1h5d8SAnl2clOSZAZypDvObA1sJvJK9z3PXFgTc0FYCrxK6P5Mx3
	s8vmfaxXxXrsGL1P/XkUffwkt4wPe4/MylxK1bb2B6QEEl5Op0JL4+Dkiq8IzjZP5ZzX
	/EnEbd5qjLXPSaYK1Wv+jbjbWT216+cGBAhlKSiaxtoWFRNSQoORqs4reJrzMaLQb8H1
	SNiRk3VrgHYY+2o8cI97d64NYI7g2nmdbuz7By4ATToZGCS23gDhuhSLnT4nQIc6bRJm
	nhkA==
X-Gm-Message-State: AOAM531tgXtrwmENxfQB+6Ex9nGX5M0QvtsDvcS9pvzJPRHaGWgyIqqV
	nO+LB7M4j/JF1V4q6Kz2XcE=
X-Google-Smtp-Source: ABdhPJx0BPMPcUz/Zkohzh+90B54PD0hev/LS+My+FphCBunKypqs5LDtZkPucDKxGBXnfpjixvY8g==
X-Received: by 2002:a05:622a:1654:: with SMTP id
	y20mr1736965qtj.364.1616570870175; 
	Wed, 24 Mar 2021 00:27:50 -0700 (PDT)
Received: from Slackware.localdomain ([156.146.37.194])
	by smtp.gmail.com with ESMTPSA id o7sm1093640qki.63.2021.03.24.00.27.46
	(version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
	Wed, 24 Mar 2021 00:27:49 -0700 (PDT)
From: Bhaskar Chowdhury <unixbhaskar@gmail.com>
To: mark@fasheh.com, jlbec@evilplan.org, joseph.qi@linux.alibaba.com,
        ocfs2-devel@oss.oracle.com, linux-kernel@vger.kernel.org
Date: Wed, 24 Mar 2021 12:59:31 +0530
Message-Id: <20210324072931.5056-1-unixbhaskar@gmail.com>
X-Mailer: git-send-email 2.30.1
MIME-Version: 1.0
X-PDR: PASS
X-Source-IP: 209.85.160.175
X-ServerName: mail-qt1-f175.google.com
X-Proofpoint-SPF-Result: pass
X-Proofpoint-SPF-Record: v=spf1 redirect=_spf.google.com
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9932
	signatures=668683
X-Proofpoint-Spam-Details: rule=tap_notspam policy=tap score=0 spamscore=0
	suspectscore=0 adultscore=0
	priorityscore=443 lowpriorityscore=0 bulkscore=0 malwarescore=0
	impostorscore=0 mlxscore=0 mlxlogscore=821 phishscore=0 clxscore=189
	classifier=spam adjust=0 reason=mlx scancount=1
	engine=8.12.0-2009150000 definitions=main-2103240055
X-Spam: Clean
X-Mailman-Approved-At: Thu, 25 Mar 2021 06:45:09 -0700
Cc: rdunlap@infradead.org, Bhaskar Chowdhury <unixbhaskar@gmail.com>
Subject: [Ocfs2-devel] [PATCH ] ocfs2: Fix a typo
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
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9933 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 malwarescore=0 spamscore=0
 mlxscore=0 phishscore=0 suspectscore=0 mlxlogscore=999 bulkscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2103250103
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9933 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 malwarescore=0 mlxscore=0
 priorityscore=1501 bulkscore=0 impostorscore=0 lowpriorityscore=0
 phishscore=0 mlxlogscore=999 suspectscore=0 clxscore=1034 spamscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2103250103


s/cluter/cluster/

Signed-off-by: Bhaskar Chowdhury <unixbhaskar@gmail.com>
---
 fs/ocfs2/stackglue.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/ocfs2/stackglue.c b/fs/ocfs2/stackglue.c
index a191094694c6..8d33ebc6b6fc 100644
--- a/fs/ocfs2/stackglue.c
+++ b/fs/ocfs2/stackglue.c
@@ -731,7 +731,7 @@ static void __exit ocfs2_stack_glue_exit(void)
 }

 MODULE_AUTHOR("Oracle");
-MODULE_DESCRIPTION("ocfs2 cluter stack glue layer");
+MODULE_DESCRIPTION("ocfs2 cluster stack glue layer");
 MODULE_LICENSE("GPL");
 module_init(ocfs2_stack_glue_init);
 module_exit(ocfs2_stack_glue_exit);
--
2.30.1


_______________________________________________
Ocfs2-devel mailing list
Ocfs2-devel@oss.oracle.com
https://oss.oracle.com/mailman/listinfo/ocfs2-devel
