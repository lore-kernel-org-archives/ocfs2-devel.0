Return-Path: <bounces+ocfs2-devel=archiver.kernel.org@phx1.rp.oracleemaildelivery.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from aib29ajc252.phx1.oracleemaildelivery.com (aib29ajc252.phx1.oracleemaildelivery.com [192.29.103.252])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 456F0C433F5
	for <ocfs2-devel@archiver.kernel.org>; Tue, 28 Dec 2021 14:45:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; s=oss-phx-1109;
 d=oss.oracle.com;
 h=Date:To:From:Subject:Message-Id:MIME-Version:Sender;
 bh=2W+A81Et2OxjaYXRI6ZZePsAeaEKJypr9zkGq58mrso=;
 b=zw2Rztsvi+CPVySfUsNSW74au7B/dl686IpzcEgc3dEOiChCslDRz8u58RPfSbPcVqFs7ucAEf0J
   D/wtoePfWmK3Aiec3vigeS7WaLkJwhbsvHxb/CEAxMGyUDNRM+jbDpUGgT44XMChHkylejtp7qeX
   AlQLiwbus08H88VtaLz8fKEJsetdBnwktml3Yja3m+cEozJgbZtBLuLqMVe/E+FVKzxSu4B+LbYj
   301h6fLDp1QNXcTffJgk6jLQ2Cs1Xnh/NXyZ2x0dkf+e2u2MySs6O+5j8YLBZAz4/x4rVUYPmYs8
   hCR6pLm7Gvbh5UZQaUS4WBjGFp5/9POOKu/wCw==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; s=prod-phx-20191217;
 d=phx1.rp.oracleemaildelivery.com;
 h=Date:To:From:Subject:Message-Id:MIME-Version:Sender;
 bh=2W+A81Et2OxjaYXRI6ZZePsAeaEKJypr9zkGq58mrso=;
 b=CK8uf59bn82WP3orFvHsU/AjqF4IdAkE849K+CkyWtwQCScRh55S+DabsBoBHPa97uoO26iwKmQJ
   vdJe8x+yXDW9y+eSOzyjNSB7Icnzye4t2xdaSxSgR6rHvcWjlG3SztyitodBSOyVPGnW0k6aA8Yz
   v0WQOIKjr/zEMx85cfq1e6uIWFSlq2MCqArpIvJ9gw3u/cCA+xJIph01ey3spW1v6NoMsakH85mC
   TDupX8XFnNBq0kZMWI4UAm1UlFlP2iQIPJdn3fR64LjRb5hQZfp+9e24gQxcxiD3K9VcKSUSpKo9
   BC4pMbnlW4nqhqrdl3OO+MNZnMCvIFbztPawcw==
Received: by omta-ad3-fd1-301-us-phoenix-1.omtaad3.vcndpphx.oraclevcn.com
 (Oracle Communications Messaging Server 8.1.0.1.20211209 64bit (built Dec  9
 2021))
 with ESMTP id <0R4T004C3YBYBPD0@omta-ad3-fd1-301-us-phoenix-1.omtaad3.vcndpphx.oraclevcn.com> for
 ocfs2-devel@archiver.kernel.org; Tue, 28 Dec 2021 14:45:34 +0000 (GMT)
Authentication-results: aserp3010.oracle.com; spf=permerror
 smtp.mailfrom=gregkh@linuxfoundation.org; dkim=pass
 header.d=linuxfoundation.org header.s=korg; dmarc=pass
 header.from=linuxfoundation.org
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
 s=korg; t=1640702720; bh=AdmCkg1Q5igTM2IOejM4lF5V1/tPIkgeLGQAEFlo7I0=;
 h=From:To:Cc:Subject:Date:From;
 b=nq/eQiCsPcuWHKvNdWmAi1ddR1rU8PGvnFmq44oz7iiW+Hj2vpC/obJUiRZrRhEhY
 8pZZZtaDGEVM2io//T19Nio64kRAjHRHgOfOZfAQYn10FV6mYILYBXY1g1K1cKNnT3
 np/dS5PFxFi+hEfrhdylHZmFG3uaCt0omnMkgk8w=
To: linux-kernel@vger.kernel.org
Date: Tue, 28 Dec 2021 15:45:17 +0100
Message-id: <20211228144517.391660-1-gregkh@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
MIME-version: 1.0
X-Source-IP: 139.178.84.217
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10210
 signatures=668683
X-Proofpoint-Spam-Details: rule=tap_notspam policy=tap score=0 clxscore=295
 spamscore=0 impostorscore=0 adultscore=0 priorityscore=308 lowpriorityscore=0
 suspectscore=0 malwarescore=0 mlxscore=0 mlxlogscore=999 bulkscore=0
 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2110150000 definitions=main-2112280067
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, ocfs2-devel@oss.oracle.com
Subject: [Ocfs2-devel] [PATCH] ocfs2: use default_groups in kobj_type
X-BeenThere: ocfs2-devel@oss.oracle.com
X-Mailman-Version: 2.1.15
Precedence: list
List-Id: <ocfs2-devel.oss.oracle.com>
List-Unsubscribe: <https://oss.oracle.com/mailman/options/ocfs2-devel>,
 <mailto:ocfs2-devel-request@oss.oracle.com?subject=unsubscribe>
List-Archive: <http://oss.oracle.com/pipermail/ocfs2-devel/>
List-Post: <mailto:ocfs2-devel@oss.oracle.com>
List-Help: <mailto:ocfs2-devel-request@oss.oracle.com?subject=help>
List-Subscribe: <https://oss.oracle.com/mailman/listinfo/ocfs2-devel>,
 <mailto:ocfs2-devel-request@oss.oracle.com?subject=subscribe>
From: Greg Kroah-Hartman via Ocfs2-devel <ocfs2-devel@oss.oracle.com>
Reply-to: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Content-type: text/plain; charset="us-ascii"
Content-transfer-encoding: 7bit
Errors-to: ocfs2-devel-bounces@oss.oracle.com
X-Developer-Signature: v=1; a=openpgp-sha256; l=1377; h=from:subject;
 bh=AdmCkg1Q5igTM2IOejM4lF5V1/tPIkgeLGQAEFlo7I0=;
 b=owGbwMvMwCRo6H6F97bub03G02pJDImnlf5yHOUzLWqL1K04tzQ7oLuVWbll0vQpIrdT3G/t2uHY
 qKfUEcvCIMjEICumyPJlG8/R/RWHFL0MbU/DzGFlAhnCwMUpABO51cwwV3j3kaX/WAScm9u3mAhtZv
 mUI1DbyrBgUiAvX8Gd8/w/N2ckdLH3LinYccoRAA==
X-Developer-Key: i=gregkh@linuxfoundation.org; a=openpgp;
 fpr=F4B60CC5BF78C2214A313DCB3147D40DDB2DFB29
X-ServerName: dfw.source.kernel.org
X-Proofpoint-SPF-Result: pass
X-Proofpoint-SPF-Record: v=spf1 ip4:72.55.140.81 include:_spf.kernel.org
 include:_spf.google.com include:amazonses.com include:_spf.salesforce.com ~all
X-Spam: Clean
X-Proofpoint-GUID: r-9NnRfHR29H_YCMhkVucVEl3q7YziUA
X-Proofpoint-ORIG-GUID: r-9NnRfHR29H_YCMhkVucVEl3q7YziUA
Reporting-Meta:
 AAHoJD8qGyTSXuANyhLJQyDy+qEw7PDrezAYaLd4QWk5qaicvZyfOthAXDkBvo8p
 sCx/mC6d/pK1o8AqKorouBXQlElwDqacvZWWb5rysY39vxzvlebXKp5H+A7Hwgi5
 8PtpuMI0fkGxZCK5ROEoCDctOXbu4E93f4P1iufNOIARlmy4UYT2bFHuxtUIOACe
 lNs4TUa2FFvUdVT1hIbmiU+X6Pz/ZB79WxSGLUWKiDnjKCedykfKUXBx/q/WRAjw
 Yz8l5sLeiCnm+HeXoPb5rBOwxIX3faWAN+ZFgmGiC5GUUIKDEIHD8WeaxR0Fgk0B
 ypPTOJW0Y4JIt1k5FVuOmJu9PJPexm88uUJ0zGZcvvvT7vbIB8tPWrvghYvFXnqq
 P7edYGPdXfAuN36yinlSydj7HqZafFPQ+3h7Um5XckygAj5tmeIUTwbY8bCEJ9ND
 TytEwE3mO5XOktbQIP85UVh218GVuC0262AJqcWHPEKA2IdvtjzBoP55OSG+YGYO
 X9qV9tmbMpfkdbj1ZTbmL6F2hqHuGAGxKfrsniY4xmo=

There are currently 2 ways to create a set of sysfs files for a
kobj_type, through the default_attrs field, and the default_groups
field.  Move the ocfs2 code to use default_groups field which has been
the preferred way since aa30f47cf666 ("kobject: Add support for default
attribute groups to kobj_type") so that we can soon get rid of the
obsolete default_attrs field.

Cc: Mark Fasheh <mark@fasheh.com>
Cc: Joel Becker <jlbec@evilplan.org>
Cc: Joseph Qi <joseph.qi@linux.alibaba.com>
Cc: ocfs2-devel@oss.oracle.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/ocfs2/filecheck.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/fs/ocfs2/filecheck.c b/fs/ocfs2/filecheck.c
index de56e6231af8..1ad7106741f8 100644
--- a/fs/ocfs2/filecheck.c
+++ b/fs/ocfs2/filecheck.c
@@ -94,6 +94,7 @@ static struct attribute *ocfs2_filecheck_attrs[] = {
 	&ocfs2_filecheck_attr_set.attr,
 	NULL
 };
+ATTRIBUTE_GROUPS(ocfs2_filecheck);
 
 static void ocfs2_filecheck_release(struct kobject *kobj)
 {
@@ -138,7 +139,7 @@ static const struct sysfs_ops ocfs2_filecheck_ops = {
 };
 
 static struct kobj_type ocfs2_ktype_filecheck = {
-	.default_attrs = ocfs2_filecheck_attrs,
+	.default_groups = ocfs2_filecheck_groups,
 	.sysfs_ops = &ocfs2_filecheck_ops,
 	.release = ocfs2_filecheck_release,
 };
-- 
2.34.1


_______________________________________________
Ocfs2-devel mailing list
Ocfs2-devel@oss.oracle.com
https://oss.oracle.com/mailman/listinfo/ocfs2-devel
