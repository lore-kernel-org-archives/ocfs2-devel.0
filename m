Return-Path: <bounces+ocfs2-devel=archiver.kernel.org@phx1.rp.oracleemaildelivery.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from aib29ajc245.phx1.oracleemaildelivery.com (aib29ajc245.phx1.oracleemaildelivery.com [192.29.103.245])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C86CEC433F5
	for <ocfs2-devel@archiver.kernel.org>; Tue, 30 Nov 2021 10:41:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; s=oss-phx-1109;
 d=oss.oracle.com;
 h=Date:To:From:Subject:Message-Id:MIME-Version:Sender;
 bh=eXMXUDeMeSn2rah+Lob7AKHLQlQwuw4iaLP2rNh/Dkc=;
 b=1WQnNbF7ych4zqqf+LYxYRr6zScKo+fEEWE66B22rooD9YgEe0bhqToC1xPUx9XzcUzjoX2luR/K
   +P/59ItYcdgWgVBnxLC+ceZnooICX1CXIZLYdc8uCj91H5RHxF1jfjWvAbhweDT38fafa/E9C08G
   c8QzX43DA5j9aeItErGdTz06iJGvMSgSD0NmDxNESpK9tWkGdFFK0QcRY0wjwcq3LqHbSkEf2awx
   K8psNpKUyFx/Xca5V3eo6KvqVIY1vVoPW5xouJ8Iql7a1GDWy4H4MAcMPXLW1hrR3K1JJrSG10ZH
   5jrbmGdkPtsrSmnW17b+d2EbcZTicDX4VUPO1A==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; s=prod-phx-20191217;
 d=phx1.rp.oracleemaildelivery.com;
 h=Date:To:From:Subject:Message-Id:MIME-Version:Sender;
 bh=eXMXUDeMeSn2rah+Lob7AKHLQlQwuw4iaLP2rNh/Dkc=;
 b=LA5kLNzjn8VFbdotbc7d8IZbBDiq5SKICR7FnGFtFAUqlCc7HY6B49eLenPLqInZK25Xg/CbLXdR
   l41rKVKD51NizuW7SCqYZUVILheKR/Kg/xkQLoD+g64Wf9yAvqBXzgg8fZjyIYp1Opn2mZpqDtqb
   PrZMmP/liLZNDg7StJxW5M6FjSuOy1TLUjk31bxo8XhbcI4OM5sqB+ut1YJkKKOUxgeEKuJM8b/b
   UeFLirRRhovUmPW4OhV+4zuOmpbdz4UkkOVPmij3tKe/fEHYQaNr4FQQfYb46BGXaDrQxYxQ+X+n
   Ta4x+yCkMdZD1y0RZU80ucoeitPLUinuLGQyRw==
Received: by omta-ad1-fd1-102-us-phoenix-1.omtaad1.vcndpphx.oraclevcn.com
 (Oracle Communications Messaging Server 8.1.0.1.20211111 64bit (built Nov 11
 2021))
 with ESMTP id <0R3D00NCFSCP5360@omta-ad1-fd1-102-us-phoenix-1.omtaad1.vcndpphx.oraclevcn.com> for
 ocfs2-devel@archiver.kernel.org; Tue, 30 Nov 2021 10:41:13 +0000 (GMT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date :
 from : to : cc : subject : message-id : content-type : mime-version;
 s=corp-2021-07-09; bh=kgnVrAiAPrOq2JZydUTmN9p3HMj24HbJqgI6JeW/M7o=;
 b=P+wJBc3qIsu5ibScLyMz3Z0568c81dUgw28r4Ai+p/gmrwZFJO1WKv9CBrOtsC8PDu6/
 DK4PxGYNvtRFmpUZThrAcWQGcyoSPdhUmy7W0JHIlSLk0Jgb+JeSBRQT6DC2n7Kty4lL
 cnsTqNHFx79go5R/l9RSuWgUYGN+n0wAC3ZYjT/vkgnDthq6LP5xzIh9yudeYqIg/dit
 M2YYarFhU88LzL6OkTu887gocBYmjpVXxwYouTe+mmMHtBef7XXGAo0BsLkBcLicg8jJ
 3uA7yBOhN0pdp7wfXRxIk2S6m6NJkVl8dD5jQBPi9kU/ccSkPfKbJi9xnvM5FfNxVOYU Og==
Authentication-results: aserp3010.oracle.com; spf=softfail
 smtp.mailfrom=dan.carpenter@oracle.com; dkim=pass
 header.s=selector2-oracle-onmicrosoft-com header.d=oracle.onmicrosoft.com;
 dmarc=none header.from=oracle.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=mx08kb427n0wcyoW2zKfri80kO9WDuLD142ujO0A+VZDc6St0eOl75I/uunxx+S27ftw4WdGseQVj3PeK6PjLet7d0+1fIxkdeLy//gNOXazwCqAbFmoYs0tFCq2HMDb+gCxlGNJIur1tHLPJYqQSrdTXwiwKpJs+04iIvsMs0NQ0rhnTCmmRe2CwUaMd/vZF3QzUdOoN8Unj4uoERDzzvAe06dmXgRtpVzRHKavlnpEZtFCHyAWihw0vOZv6c+yVoAR6h+BH3m4jGInUIQG10wFikxRRnY1LC2iSBCu9VuFAqmePkVGZNfimY2UhZukOS/04EtHhQFJH+ZkPi32DQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=kgnVrAiAPrOq2JZydUTmN9p3HMj24HbJqgI6JeW/M7o=;
 b=CtaxVMit6xhDg3L+Ce+ENc5rjNclheiZucmtM9ki7XoSs7pjiTydPRf3Sd6xSaaTTSJwgnHMyNIAbAf6/mBxly+fWwVucqb1WHiWw8BD0EvR3OaA33084ftLCy8O3iaN1DQu3pDI8Ijrx2/YnsYHeF8hdvQ6xYR4wuRGpYczHZEIG4CArYW4dPF0gQFtrgd0MPJW3Nl0asjC69p0TZUOJgw49a8pYKGzzaeApjALYzUKY2JnYGVW5rh1S45DkD5JRYd4/fndNILfANwDgQ2WqOREi5eDnlzswBpweXYsXrxJw2f0CEvvWVtamwW2SXoo3UZ9Ane8EmxBR04Ocf194Q==
ARC-Authentication-results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.onmicrosoft.com;
 s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=kgnVrAiAPrOq2JZydUTmN9p3HMj24HbJqgI6JeW/M7o=;
 b=ttw1eBG+QTybea9vyNhHxQjz489x+K3EaUoFdTU71xZr2bv5Y7zXzLRqNMktdF0kg9Lacny5o3+NLeeb/rR7UX8dnQFqbKCU9SFcDYta1b0tEnfBiK5LFQhJspz9rdcvnSo4FDxA6R8Lzslz3nVE1MFqlP5ohT3kOC+YDmiauwc=
Date: Tue, 30 Nov 2021 13:40:43 +0300
To: Mark Fasheh <mark@fasheh.com>, Wengang Wang <wen.gang.wang@oracle.com>
Message-id: <20211130104043.GB5827@kili>
Content-disposition: inline
X-Mailer: git-send-email haha only kidding
User-Agent: Mutt/1.10.1 (2018-07-13)
MIME-version: 1.0
X-Forefront-Antispam-Report: CIP:255.255.255.255; CTRY:; LANG:en; SCL:-1; SRV:;
 IPV:NLI; SFV:SKI; H:MWHPR1001MB2365.namprd10.prod.outlook.com; PTR:; CAT:NONE;
 SFS:; DIR:INB;
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 30 Nov 2021 10:40:58.9369 (UTC)
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10183
 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0
 spamscore=0 adultscore=0 bulkscore=0 malwarescore=0 mlxlogscore=999 mlxscore=0
 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2110150000 definitions=main-2111300060
Cc: Sunil Mushran <sunil.mushran@oracle.com>, kernel-janitors@vger.kernel.org,
 linux-kernel@vger.kernel.org, ocfs2-devel@oss.oracle.com
Subject: [Ocfs2-devel] [PATCH] ocfs2: fix uninitialized variable in
	ocfs2_dio_wr_get_block()
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
From: Dan Carpenter via Ocfs2-devel <ocfs2-devel@oss.oracle.com>
Reply-to: Dan Carpenter <dan.carpenter@oracle.com>
Content-type: text/plain; charset="us-ascii"
Content-transfer-encoding: 7bit
Errors-to: ocfs2-devel-bounces@oss.oracle.com
X-ClientProxiedBy: ZR0P278CA0127.CHEP278.PROD.OUTLOOK.COM (2603:10a6:910:40::6)
 To MWHPR1001MB2365.namprd10.prod.outlook.com (2603:10b6:301:2d::28)
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 3869521e-f45b-414b-4600-08d9b3ede576
X-MS-TrafficTypeDiagnostic: MWHPR10MB1357:
X-Oracle-Tenancy: 1
X-MS-Oob-TLC-OOBClassifiers: OLM:4714;
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
 joyykst2HFwGxADklHOgPWRN4t3YdQiMUSwa5dTV/kke2S0JyutsFX2RkI8KKBJxeiBIdmsErKGLsiI9vGlyPyS1gojptlwW0/L5CZilvFBFeXrOc7q2e/w5ZT4ORUrh9aiQ3AZI1Ilp+T2CmXH3M+2drrPaj8QlUHD3FUC47PXvwHEDfvK168clV8vj85Mwp0D4IQn+1Z+Q9BFixXsttX9HKQrKU//LjJ+rscM07p8n9xhcW/SOBIie7mu1Lvfuen3b7M9x8VJ5V/0s40vwaBxxMDf/9OgZW6nZ/qFyE6SA8rCA6VSa2W+0AFtj6acBoRJkFW7BQToHwCthKmLa8PGLRjV2wwjrphFW1JeoD7AJRbl7XguRR1Lsf0dht1d+yDrttSEiumUTLl7R/uHGRBZFnatZTSWFlsGg26j6zUhqHNcR+O2jxZeScK6b0eHwX0vW7ucW187MoPKnqPpDYcOdveL1y4YMwabv9SzEGunroQZDLneVkiUsect0eJSYLiuH0cyX2rgwhCsOExUSZVagupWbJa6rjD277/zpLjvUHHpi3+CgHPGLFfnGa+P0XnLWYlkdGQYgl79e46faf/rovy+VwDqM4NUI7+rV1tg=
X-MS-Exchange-CrossTenant-Network-Message-Id:
 3869521e-f45b-414b-4600-08d9b3ede576
X-MS-Exchange-CrossTenant-AuthSource: MWHPR1001MB2365.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName:
 C0lfTSrpJGzdlXASqd/vSvCzyeIShhfo2xDXoYcnn5fEOINoKclg9hxW0gqBfEpnELEEtGmvboX1CjSXTfmHMPuBINV6U5diTII3QnPg48s=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MWHPR10MB1357
X-MS-Exchange-CrossPremises-AuthSource:
 MWHPR1001MB2365.namprd10.prod.outlook.com
X-MS-Exchange-CrossPremises-AuthAs: Internal
X-MS-Exchange-CrossPremises-AuthMechanism: 06
X-MS-Exchange-CrossPremises-Mapi-Admin-Submission:
X-MS-Exchange-CrossPremises-MessageSource: StoreDriver
X-MS-Exchange-CrossPremises-BCC: Dan Carpenter <dan.carpenter@oracle.com>
X-MS-Exchange-CrossPremises-OriginalClientIPAddress: 102.222.70.114
X-MS-Exchange-CrossPremises-TransportTrafficType: Email
X-MS-Exchange-CrossPremises-Antispam-ScanContext: DIR:Originating; SFV:SKI;
 SKIP:0;
X-MS-Exchange-CrossPremises-SCL: -1
X-MS-Exchange-CrossPremises-Processed-By-Journaling: Journal Agent
X-OrganizationHeadersPreserved: MWHPR10MB1357.namprd10.prod.outlook.com
X-Proofpoint-GUID: COQMUb9Amzhb_uUDBK9vg_-V6VBe8bCr
X-Proofpoint-ORIG-GUID: COQMUb9Amzhb_uUDBK9vg_-V6VBe8bCr
Reporting-Meta:
 AAHzXf2Hjk/QgvoqnicRmvjWkUB7FqHAlZQMZkeQHLPfX1cIXmaUImw9tOmwRjNG
 fqzwkimk3+HCvjE/J9ef0R0ESEKqr3Z6eg4crkeVeTQ+Yu1P5zT/7S5o5+P2aLhv
 CQxKnGd/Y8BIhP/ir3gRjk2PgYvS/AmDt/6NkKUfMyp3J1bpD5l06nrdEI6oOGHN
 rEKCJul+Xou3+ihxKAtW6FnDZtYLABsoOUzloGUhrxskCmKzn6SQAgViV0obdSva
 F+WuRaF8UygRBFPlUiNyIj/QTRtJl4kc2+k0uM7O3HJ6YGeWjs/a4AxurxgKiHuF
 dCzkkgxmO+bqakEwJ4si+OhjjR7vyxJOBXEuB44lHM+h0OC2+m9namd7RRkYavZD
 LsC4JyTwFKRTwShveszehJEwtP4d6IFb+etxBb11Mp4piWs5D/nvt1sNvcidE/NZ
 XWfoTy2+0IsLU2DGSs1dBEeu2++nB/a7SEoRobDL5RKvIZyBwO4wqU2jmVZ1+JuZ
 4LjT9EpQQVFhfScNQrQKsN5YH6kd02/OWEaxb1Hl8Kk=

The callers assume that "*fsdata" is set on the success path, but
that's not necessarily true on this path.

Fixes: 5cffff9e2986 ("ocfs2: Fix ocfs2_page_mkwrite()")
Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
---
Please review this one EXTRA CAREFULLY.  It's from static analysis and
the truth is I'm not 100% sure it's correct.  I'm also not sure that
it's a complete fix.

Especially, please review how this is called from ocfs2_write_begin()
to make sure that this doesn't break anything.


 fs/ocfs2/aops.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/fs/ocfs2/aops.c b/fs/ocfs2/aops.c
index 68d11c295dd3..a74a370f16f0 100644
--- a/fs/ocfs2/aops.c
+++ b/fs/ocfs2/aops.c
@@ -1813,6 +1813,7 @@ int ocfs2_write_begin_nolock(struct address_space *mapping,
 	if (ret == -EAGAIN) {
 		BUG_ON(wc->w_target_page);
 		ret = 0;
+		*fsdata = wc;
 		goto out_quota;
 	}
 
-- 
2.20.1


_______________________________________________
Ocfs2-devel mailing list
Ocfs2-devel@oss.oracle.com
https://oss.oracle.com/mailman/listinfo/ocfs2-devel
