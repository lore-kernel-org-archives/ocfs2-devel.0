Return-Path: <SRS0=Eigy=NV=oss.oracle.com=ocfs2-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.7 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,MSGID_FROM_MTA_HEADER,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5E61EC432BE
	for <ocfs2-devel@archiver.kernel.org>; Mon, 30 Aug 2021 04:47:10 +0000 (UTC)
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id 01D70604D7
	for <ocfs2-devel@archiver.kernel.org>; Mon, 30 Aug 2021 04:47:09 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org 01D70604D7
Authentication-Results: mail.kernel.org; dmarc=fail (p=quarantine dis=none) header.from=suse.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=oss.oracle.com
Received: from pps.filterd (m0246630.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 17TEMum7007861;
	Mon, 30 Aug 2021 04:47:09 GMT
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
	by mx0b-00069f02.pphosted.com with ESMTP id 3arbxwghkd-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 30 Aug 2021 04:47:08 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
	by userp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 17U4k5Eb171529;
	Mon, 30 Aug 2021 04:47:07 GMT
Received: from oss.oracle.com (oss-old-reserved.oracle.com [137.254.22.2])
	by userp3030.oracle.com with ESMTP id 3arpf1n0v9-1
	(version=TLSv1 cipher=AES256-SHA bits=256 verify=NO);
	Mon, 30 Aug 2021 04:47:07 +0000
Received: from localhost ([127.0.0.1] helo=lb-oss.oracle.com)
	by oss.oracle.com with esmtp (Exim 4.63)
	(envelope-from <ocfs2-devel-bounces@oss.oracle.com>)
	id 1mKZCL-0001Fy-VQ; Sun, 29 Aug 2021 21:47:05 -0700
Received: from aserp3030.oracle.com ([141.146.126.71])
	by oss.oracle.com with esmtp (Exim 4.63)
	(envelope-from <ghe@suse.com>) id 1mKZBs-0001F1-Iq
	for ocfs2-devel@oss.oracle.com; Sun, 29 Aug 2021 21:46:36 -0700
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
	by aserp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id
	17U4jfGA068283
	for <ocfs2-devel@oss.oracle.com>; Mon, 30 Aug 2021 04:46:36 GMT
Received: from mx0b-00069f01.pphosted.com (mx0b-00069f01.pphosted.com
	[205.220.177.26]) by aserp3030.oracle.com with ESMTP id 3aqb6b9rd9-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
	for <ocfs2-devel@oss.oracle.com>; Mon, 30 Aug 2021 04:46:35 +0000
Received: from pps.filterd (m0246577.ppops.net [127.0.0.1])
	by mx0b-00069f01.pphosted.com (8.16.1.2/8.16.0.43) with SMTP id
	17U4BrKD027411
	for <ocfs2-devel@oss.oracle.com>; Mon, 30 Aug 2021 04:46:34 GMT
Received: from de-smtp-delivery-102.mimecast.com
	(de-smtp-delivery-102.mimecast.com [194.104.109.102])
	by mx0b-00069f01.pphosted.com with ESMTP id 3aqxwrry74-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
	for <ocfs2-devel@oss.oracle.com>; Mon, 30 Aug 2021 04:46:34 +0000
Received: from EUR01-VE1-obe.outbound.protection.outlook.com
	(mail-ve1eur01lp2057.outbound.protection.outlook.com [104.47.1.57])
	(Using TLS) by relay.mimecast.com with ESMTP id
	de-mta-35-hqqyvQQlMyiyNxxylOPYNA-1; Mon, 30 Aug 2021 06:46:31 +0200
X-MC-Unique: hqqyvQQlMyiyNxxylOPYNA-1
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
	b=kwnYj8dDuyuve2khw68Y6gPNTSpAqO6DAaPm00QfO7OHp+vxUEgGk95VBSVKjSY1QOJfW6L44clPpyFCEOrFddDqMImYpwbFQrkVEkc0BdTzPhRjd11j1oEgxjGEqGSKyq3JP1RDI1x+57ADJd/h7YP89NcVLboD5CSGBeL9kxQoqQ3MQc0VoVABlFeeV+6OFTjNM8EZIy9ofNnVLBB/4VskxyUhB4T+vyusN+WOhSDA2hUvkF35vtn5goFlFVljQteWTA9XpXHLqRdvbRxhx/K/N9J76YvCv2pcKbfiontGI6csQjjvPJcL6HfKfS91nk1gQ+GOlGBAcbTCE4Wnuw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com; 
	s=arcselector9901;
	h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
	bh=ZCokgxGLZl9QrUw5hu1Th+Svdfwva4BRiv5Norjt0Fg=;
	b=jOQVbkITaFShAZysDUBmJSLBV7QaWv8KuQbGb0l8y/BszNuu+LPVXDpTHX/7e/mml91FFtEsALmTG3n6xqEsBvDFZ9X8e04GW1ioMCh9N7HKr66zLa2MbMOPMdIDMyiqFI9OJQNA4iuXH+bT+cMW/stuGeAk717RADSsC8Vr0jzhKVlFYnypIczAJ2BrRvC46xuonZXK78xLapCtWjvvmpNqw/YG1U6R1dB8L44KoZ41qOLQuA9A9QnUIvsJq//uakcj9QZ4dGUBHf7jUA4jkxlEmduOMQXUsnG25G48ny5ke6M8nHCTwMUJaJRu4xBrdpiecn8X6g1NH3L5s9sFnA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
	smtp.mailfrom=suse.com; dmarc=pass action=none header.from=suse.com;
	dkim=pass header.d=suse.com; arc=none
Authentication-Results: fasheh.com; dkim=none (message not signed)
	header.d=none; fasheh.com; dmarc=none action=none header.from=suse.com; 
Received: from AM6PR04MB6488.eurprd04.prod.outlook.com (2603:10a6:20b:f8::21)
	by AM6PR04MB5064.eurprd04.prod.outlook.com (2603:10a6:20b:4::33) with
	Microsoft SMTP Server (version=TLS1_2,
	cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4457.24;
	Mon, 30 Aug 2021 04:46:30 +0000
Received: from AM6PR04MB6488.eurprd04.prod.outlook.com
	([fe80::793c:6276:4f2a:4d71]) by
	AM6PR04MB6488.eurprd04.prod.outlook.com
	([fe80::793c:6276:4f2a:4d71%4]) with mapi id 15.20.4457.024;
	Mon, 30 Aug 2021 04:46:29 +0000
From: Gang He <ghe@suse.com>
To: mark@fasheh.com, jlbec@evilplan.org, joseph.qi@linux.alibaba.com
Date: Mon, 30 Aug 2021 12:46:21 +0800
Message-ID: <20210830044621.12544-1-ghe@suse.com>
X-Mailer: git-send-email 2.32.0
X-ClientProxiedBy: HK0PR03CA0116.apcprd03.prod.outlook.com
	(2603:1096:203:b0::32) To AM6PR04MB6488.eurprd04.prod.outlook.com
	(2603:10a6:20b:f8::21)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from localhost (60.251.47.115) by
	HK0PR03CA0116.apcprd03.prod.outlook.com (2603:1096:203:b0::32)
	with Microsoft SMTP Server (version=TLS1_2,
	cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4457.19
	via Frontend Transport; Mon, 30 Aug 2021 04:46:29 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 5343dc60-1a01-4639-1c05-08d96b712219
X-MS-TrafficTypeDiagnostic: AM6PR04MB5064:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <AM6PR04MB506429F0C5913E2C7E5C4B0DCFCB9@AM6PR04MB5064.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:8273;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: T0aUGhsn/GdcVspRDVM/n8zFdN5QinSBGSs5FRqKCxNYOXvwiGtXmhUOUjk9PuHdtI8ryZSlwFxi7tqp+tc2x4fwYBFGon2x/vffA3a4+x3ruNQQxRE6bsXHWryToSWzrkqzQC1fqZa9WKPXJYr3yvBJBCYJ9SMxU+/cva/vyj8YNWb0ux/sCd5IVyVUhXfsa7Ur5rXAg1j+V5MRPqTkCtN6NAGnR+PhWDGKlecL820uzuBOEcquILdzNUrU6aubJYEQfSe+bfeoAKUfbnMOb8/VHGZXhQazWUZLj5aBiST1jP99vTcqUqIUfYVCCuxJXWcT9hV92h8mBVhdzpSAb8kkII408ddhcS8T1kvVQ1m+CgYKHANqPye/OCVztXBn76oMTkZ51YlZWvf9n1JpAWCwE9NSSwHH0ty0ucn/XUUtTLWo3SU0CE7AIfejqUvgrcZsW1KFP6hi5KunaOKKsosQ5hVwQDWBb/orYJJsrowCD620KsEcltHVEGT4eMxvcxxTJV+o2kZlSxLg0pfEqbha9JErxUWi70UAmFXhVR3/thlq8aLMClcePuOQQUfiVAzfVGQc3/faKyZBnOE+Ijy92GdHCU6a6D8Az7ISY738MH+vzqkqmMErCmIGS5J4IWwFAkMevifE8xYnWRGoDQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255; CTRY:; LANG:en; SCL:1; SRV:; IPV:NLI; SFV:NSPM;
	H:AM6PR04MB6488.eurprd04.prod.outlook.com; PTR:; CAT:NONE;
	SFS:(376002)(39860400002)(136003)(366004)(396003)(346002)(6666004)(86362001)(5660300002)(4326008)(66946007)(1076003)(83380400001)(66556008)(66476007)(2906002)(6486002)(36756003)(38100700002)(2616005)(316002)(26005)(956004)(8676002)(8936002)(186003)(6496006)(478600001)(55236004);
	DIR:OUT; SFP:1101; 
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?HxbzOLa0wcNtkoZQIKozcAcihm6893Fz8qaGdCgwwXFn2PsEju8K8zt9E4Zm?=
	=?us-ascii?Q?IlAcE7utf7hA6ez0jIvmw+VgvGKjVi/TR9RXn2Ivg59+mUUHIuF5RGkVvY6f?=
	=?us-ascii?Q?gKRoJmqYV1lfA31vMFFsvbTJZTT4KmzSpYPbJLpQ6LsxJ389CM2A4LsNd4JL?=
	=?us-ascii?Q?Gw4fA6h86sY8eD5LaPuvR9+2C9L6eQBI6r0BykAQlpwlotWpM+KB4Nshv1Vg?=
	=?us-ascii?Q?ypNXOfcHlZE/gAf4r8H1jCjDD2PbYNyRlb4UNZDuhucH5w280dXcVpD79rnU?=
	=?us-ascii?Q?SO6EwAKK0lYSU9I74ZJ5LnCIjQIjmvkNlsjXWwMV6Dteq5DOBTazesqVJj5j?=
	=?us-ascii?Q?Cnft7fVwe8l9xVRyiikIbcwJ3kHtN2X8TDQlY3yg2cddGC8SeJLdJk1tkk9b?=
	=?us-ascii?Q?wCrF7u+aCtj4wWqmkwYyWQhHEsrRGMECAITqN+YHb6Sr+T4bspsk5CCzPjCx?=
	=?us-ascii?Q?Etz+itzxHNBCIXfFsB88BhatuWYhoHt7RANifk+ii189My5y1vvD8c+bS7H5?=
	=?us-ascii?Q?n4oz1vQWPNmuXFU1dL/5RT1TOPtE4uahyr/DQR5k3XG73J1KRcZpZlU1DDjA?=
	=?us-ascii?Q?rphBOW48bRTEAtDR5f3RCbIUUySyhi5vltBWOe2Vdit/F1hOnLdy7QFaAXEI?=
	=?us-ascii?Q?L+ZW3OdP2bKwmkY7+saVDbClDMLqcPOJHMxQvUWnH6dMcTQ0frwYF3TuggaV?=
	=?us-ascii?Q?JCt4BQ0gJmJjQJ490Ulhze87LUKEBD8hMuo494LgPQc6fLiArvbcm7HrWepj?=
	=?us-ascii?Q?Yvz91xT7WUD0vRVP+07IP8UJANbEJotQu0FzHcz3c3Cc8CZiBgzwfqa/kAST?=
	=?us-ascii?Q?EIQfbH9YSwiMPzkhgN9/d4QG8Di8uwL/EB4mEnXMkWxQsXa3AtmU5S8Vnmy4?=
	=?us-ascii?Q?r2fIC3IzB9Jay0Y9rQ3GAB/VCMJlc12RZpOjq+J7fqtLzPnLcXs/cQwgnVbD?=
	=?us-ascii?Q?3TBrVn8apthLno6zWvo354mqg2Y57Bf4WwlB9xTBodBeL88pFpHHMXHPNN0K?=
	=?us-ascii?Q?FevGcxnl2+GhwDYH4isw2glbFNFj6uveK6d1BB4FDL7qt9TaYRpmaSv/khiC?=
	=?us-ascii?Q?MkeQwsV/k7Xi24g2gcznLShMtgCa2tqmcFhYPb0tF8RmP5vIm5iidaZC08qj?=
	=?us-ascii?Q?10ZN/ljhotCiUbwZ3W06SD10nC6mjPCduxWfjdKQIL43mB+Z/YpB3/wItHe9?=
	=?us-ascii?Q?LKYLVukH478b46edUCB3o3htBtDTmm8HbsVyWwWE6pT67bMzm8KFLH3fJ4bY?=
	=?us-ascii?Q?iv8YPBqy377xsIX+xZ0EqZqI/e/M6hAUdfucR0f07byh6LIN79xnKbJjDcfA?=
	=?us-ascii?Q?e5WQC56Cc39TxzRz9wc85zcC?=
X-OriginatorOrg: suse.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 5343dc60-1a01-4639-1c05-08d96b712219
X-MS-Exchange-CrossTenant-AuthSource: AM6PR04MB6488.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 30 Aug 2021 04:46:29.8102 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: f7a17af6-1c5c-4a36-aa8b-f5be247aa4ba
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 85rtYvDp+vt8ptc+8b6i0ADkvnCW58ZpNkGf9M+TncRv5w4earB+UZFvuVa2oe5U
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM6PR04MB5064
X-Source-IP: 194.104.109.102
X-ServerName: de-smtp-delivery-102.mimecast.com
X-Proofpoint-SPF-Result: pass
X-Proofpoint-SPF-Record: v=spf1 include:spf.suse.com
	include:de._netblocks.mimecast.com
	include:amazonses.com include:spf.protection.outlook.com
	include:_spf.qemailserver.com include:_spf.salesforce.com -all
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10091
	signatures=668682
X-Proofpoint-Spam-Details: rule=tap_notspam policy=tap score=0 mlxscore=0
	adultscore=0 clxscore=269
	phishscore=0 spamscore=0 malwarescore=0 bulkscore=0 mlxlogscore=776
	priorityscore=108 lowpriorityscore=0 impostorscore=0 suspectscore=0
	classifier=spam adjust=0 reason=mlx scancount=1
	engine=8.12.0-2107140000 definitions=main-2108300031
X-Spam: Clean
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10091
	signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0
	phishscore=0 suspectscore=0
	adultscore=0 mlxscore=0 mlxlogscore=724 malwarescore=0 spamscore=0
	classifier=spam adjust=0 reason=mlx scancount=1
	engine=8.12.0-2107140000 definitions=main-2108300031
Cc: linux-kernel@vger.kernel.org, ocfs2-devel@oss.oracle.com
Subject: [Ocfs2-devel] [PATCH v2] ocfs2: ocfs2_downconvert_lock failure
	results in deadlock
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
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10091 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 bulkscore=0 phishscore=0
 spamscore=0 mlxlogscore=999 adultscore=0 suspectscore=0 mlxscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2107140000
 definitions=main-2108300031
X-Proofpoint-ORIG-GUID: c2nnYR0eDCT9smGNKZUuWoBiUGytpih0
X-Proofpoint-GUID: c2nnYR0eDCT9smGNKZUuWoBiUGytpih0

Usually, ocfs2_downconvert_lock() function always downconverts
dlm lock to the expected level for satisfy dlm bast requests
from the other nodes.
But there is a rare situation. When dlm lock conversion is being
canceled, ocfs2_downconvert_lock() function will return -EBUSY.
You need to be aware that ocfs2_cancel_convert() function is
asynchronous in fsdlm implementation.
If we does not requeue this lockres entry, ocfs2 downconvert
thread no longer handles this dlm lock bast request. Then, the
other nodes will not get the dlm lock again, the current node's
process will be blocked when acquire this dlm lock again.

Signed-off-by: Gang He <ghe@suse.com>
---
v2: keep error print in ocfs2_downconvert_lock function, add more detailed
comments in code, add msleep to avoid repeated attempts. 
---
 fs/ocfs2/dlmglue.c | 12 ++++++++++++
 1 file changed, 12 insertions(+)

diff --git a/fs/ocfs2/dlmglue.c b/fs/ocfs2/dlmglue.c
index 48fd369c29a4..f8f561850470 100644
--- a/fs/ocfs2/dlmglue.c
+++ b/fs/ocfs2/dlmglue.c
@@ -16,6 +16,7 @@
 #include <linux/debugfs.h>
 #include <linux/seq_file.h>
 #include <linux/time.h>
+#include <linux/delay.h>
 #include <linux/quotaops.h>
 #include <linux/sched/signal.h>
 
@@ -3912,6 +3913,17 @@ static int ocfs2_unblock_lock(struct ocfs2_super *osb,
 	spin_unlock_irqrestore(&lockres->l_lock, flags);
 	ret = ocfs2_downconvert_lock(osb, lockres, new_level, set_lvb,
 				     gen);
+	/* The dlm lock convert is being cancelled in background,
+	 * ocfs2_cancel_convert() is asynchronous in fs/dlm,
+	 * requeue it, try again later.
+	 */
+	if (ret == -EBUSY) {
+		ctl->requeue = 1;
+		mlog(ML_BASTS, "lockres %s, ReQ: Downconvert busy\n",
+		     lockres->l_name);
+		ret = 0;
+		msleep(20);
+	}
 
 leave:
 	if (ret)
-- 
2.12.3


_______________________________________________
Ocfs2-devel mailing list
Ocfs2-devel@oss.oracle.com
https://oss.oracle.com/mailman/listinfo/ocfs2-devel
