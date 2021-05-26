Return-Path: <SRS0=dXbG=KV=oss.oracle.com=ocfs2-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DB7D2C47089
	for <ocfs2-devel@archiver.kernel.org>; Wed, 26 May 2021 14:35:51 +0000 (UTC)
Received: from userp2120.oracle.com (userp2120.oracle.com [156.151.31.85])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id 7189E611CD
	for <ocfs2-devel@archiver.kernel.org>; Wed, 26 May 2021 14:35:51 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 7189E611CD
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=huawei.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=ocfs2-devel-bounces@oss.oracle.com
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
	by userp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 14QEZo0N108169;
	Wed, 26 May 2021 14:35:50 GMT
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
	by userp2120.oracle.com with ESMTP id 38ptkp9521-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 26 May 2021 14:35:50 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
	by userp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 14QEGFNX171022;
	Wed, 26 May 2021 14:35:50 GMT
Received: from oss.oracle.com (oss-old-reserved.oracle.com [137.254.22.2])
	by userp3020.oracle.com with ESMTP id 38qbqt9pxr-1
	(version=TLSv1 cipher=AES256-SHA bits=256 verify=NO);
	Wed, 26 May 2021 14:35:49 +0000
Received: from localhost ([127.0.0.1] helo=lb-oss.oracle.com)
	by oss.oracle.com with esmtp (Exim 4.63)
	(envelope-from <ocfs2-devel-bounces@oss.oracle.com>)
	id 1lludQ-0007M7-Rr; Wed, 26 May 2021 07:35:48 -0700
Received: from aserp3030.oracle.com ([141.146.126.71])
	by oss.oracle.com with esmtp (Exim 4.63)
	(envelope-from <chenhuang5@huawei.com>) id 1llpYg-0000VB-68
	for ocfs2-devel@oss.oracle.com; Wed, 26 May 2021 02:10:34 -0700
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
	by aserp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id
	14Q9A5kB129956
	for <ocfs2-devel@oss.oracle.com>; Wed, 26 May 2021 09:10:33 GMT
Received: from userp2030.oracle.com (userp2030.oracle.com [156.151.31.89])
	by aserp3030.oracle.com with ESMTP id 38pr0cj2qk-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
	for <ocfs2-devel@oss.oracle.com>; Wed, 26 May 2021 09:10:32 +0000
Received: from pps.filterd (userp2030.oracle.com [127.0.0.1])
	by userp2030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id
	14Q93O7P008095
	for <ocfs2-devel@oss.oracle.com>; Wed, 26 May 2021 09:10:32 GMT
Received: from szxga07-in.huawei.com (szxga07-in.huawei.com [45.249.212.35])
	by userp2030.oracle.com with ESMTP id 38rnjn73ug-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO)
	for <ocfs2-devel@oss.oracle.com>; Wed, 26 May 2021 09:10:30 +0000
Received: from dggems704-chm.china.huawei.com (unknown [172.30.72.58])
	by szxga07-in.huawei.com (SkyGuard) with ESMTP id 4FqlTG6lRjzCx9y;
	Wed, 26 May 2021 17:07:30 +0800 (CST)
Received: from dggema756-chm.china.huawei.com (10.1.198.198) by
	dggems704-chm.china.huawei.com (10.3.19.181) with Microsoft SMTP Server
	(version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256) id
	15.1.2176.2; Wed, 26 May 2021 17:10:18 +0800
Received: from localhost.localdomain (10.175.112.125) by
	dggema756-chm.china.huawei.com (10.1.198.198) with Microsoft SMTP
	Server
	(version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id
	15.1.2176.2; Wed, 26 May 2021 17:10:17 +0800
From: Chen Huang <chenhuang5@huawei.com>
To: Michael Ellerman <mpe@ellerman.id.au>,
        Benjamin Herrenschmidt
	<benh@kernel.crashing.org>,
        Paul Mackerras <paulus@samba.org>,
        "Boris
	Ostrovsky" <boris.ostrovsky@oracle.com>,
        Juergen Gross <jgross@suse.com>,
        Stefano Stabellini <sstabellini@kernel.org>,
        Mark Fasheh <mark@fasheh.com>, Joel Becker <jlbec@evilplan.org>,
        Joseph Qi <joseph.qi@linux.alibaba.com>,
        Nathan Lynch <nathanl@linux.ibm.com>,
        Andrew Donnellan <ajd@linux.ibm.com>,
        Alexey Kardashevskiy <aik@ozlabs.ru>,
        Andrew Morton
	<akpm@linux-foundation.org>,
        Stephen Rothwell <sfr@canb.auug.org.au>,
        "Jens
	Axboe" <axboe@kernel.dk>,
        Yang Yingliang <yangyingliang@huawei.com>,
        "Masahiro Yamada" <masahiroy@kernel.org>,
        Dan Carpenter
	<dan.carpenter@oracle.com>
Date: Wed, 26 May 2021 09:20:18 +0000
Message-ID: <20210526092020.554341-1-chenhuang5@huawei.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
X-Originating-IP: [10.175.112.125]
X-ClientProxiedBy: dggems703-chm.china.huawei.com (10.3.19.180) To
	dggema756-chm.china.huawei.com (10.1.198.198)
X-CFilter-Loop: Reflected
X-PDR: PASS
X-Source-IP: 45.249.212.35
X-ServerName: szxga07-in.huawei.com
X-Proofpoint-SPF-Result: pass
X-Proofpoint-SPF-Record: v=spf1 ip4:45.249.212.32 ip4:45.249.212.35
	ip4:45.249.212.255
	ip4:45.249.212.187/29 ip4:45.249.212.191 ip4:185.176.76.210
	ip4:168.195.93.47 ip4:103.69.140.247 ip4:185.176.79.56 -all
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9995
	signatures=668682
X-Proofpoint-Spam-Details: rule=tap_notspam policy=tap score=0 mlxscore=0
	bulkscore=0 adultscore=0
	malwarescore=0 phishscore=0 impostorscore=0 suspectscore=0 clxscore=255
	mlxlogscore=999 priorityscore=288 lowpriorityscore=0 spamscore=0
	classifier=spam adjust=0 reason=mlx scancount=1
	engine=8.12.0-2104190000 definitions=main-2105260060
X-Spam: Clean
X-Mailman-Approved-At: Wed, 26 May 2021 07:35:47 -0700
Cc: xen-devel@lists.xenproject.org, Chen Huang <chenhuang5@huawei.com>,
        linuxppc-dev@lists.ozlabs.org, linux-kernel@vger.kernel.org,
        ocfs2-devel@oss.oracle.com
Subject: [Ocfs2-devel] [PATCH -next 1/3] powerpc/rtas: Replaced
	simple_strtoull() with kstrtoull()
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
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9996 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 phishscore=0 bulkscore=0
 mlxlogscore=999 malwarescore=0 spamscore=0 suspectscore=0 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2104190000
 definitions=main-2105260097
X-Proofpoint-GUID: zrWh7Jgu68S89mJe7bAZV_wx8ly33E5k
X-Proofpoint-ORIG-GUID: zrWh7Jgu68S89mJe7bAZV_wx8ly33E5k
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9996 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 impostorscore=0 mlxscore=0
 suspectscore=0 bulkscore=0 adultscore=0 mlxlogscore=999 phishscore=0
 malwarescore=0 clxscore=1015 lowpriorityscore=0 spamscore=0
 priorityscore=1501 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2104190000 definitions=main-2105260098

The simple_strtoull() function is deprecated in some situation, since
it does not check for the range overflow, use kstrtoull() instead.

Signed-off-by: Chen Huang <chenhuang5@huawei.com>
---
 arch/powerpc/kernel/rtas-proc.c | 7 +------
 1 file changed, 1 insertion(+), 6 deletions(-)

diff --git a/arch/powerpc/kernel/rtas-proc.c b/arch/powerpc/kernel/rtas-proc.c
index 6857a5b0a1c3..117886782ebd 100644
--- a/arch/powerpc/kernel/rtas-proc.c
+++ b/arch/powerpc/kernel/rtas-proc.c
@@ -259,7 +259,6 @@ __initcall(proc_rtas_init);
 static int parse_number(const char __user *p, size_t count, u64 *val)
 {
 	char buf[40];
-	char *end;
 
 	if (count > 39)
 		return -EINVAL;
@@ -269,11 +268,7 @@ static int parse_number(const char __user *p, size_t count, u64 *val)
 
 	buf[count] = 0;
 
-	*val = simple_strtoull(buf, &end, 10);
-	if (*end && *end != '\n')
-		return -EINVAL;
-
-	return 0;
+	return kstrtoull(buf, 10, val);
 }
 
 /* ****************************************************************** */
-- 
2.25.1


_______________________________________________
Ocfs2-devel mailing list
Ocfs2-devel@oss.oracle.com
https://oss.oracle.com/mailman/listinfo/ocfs2-devel
