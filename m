Return-Path: <SRS0=xoxE=MA=oss.oracle.com=ocfs2-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.5 required=3.0 tests=BAYES_00,DKIMWL_WL_MED,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,MSGID_FROM_MTA_HEADER,
	SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0C23AC07E96
	for <ocfs2-devel@archiver.kernel.org>; Thu,  8 Jul 2021 14:20:46 +0000 (UTC)
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id 972AD61864
	for <ocfs2-devel@archiver.kernel.org>; Thu,  8 Jul 2021 14:20:45 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 972AD61864
Authentication-Results: mail.kernel.org; dmarc=pass (p=none dis=none) header.from=oracle.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=ocfs2-devel-bounces@oss.oracle.com
Received: from pps.filterd (m0246630.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 168E2S1M011280;
	Thu, 8 Jul 2021 14:20:44 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to :
 message-id : mime-version : cc : subject : list-id : list-unsubscribe :
 list-archive : list-post : list-help : list-subscribe : content-type :
 content-transfer-encoding : sender; s=corp-2020-01-29;
 bh=iopGvrR2IBiqnXmWnhIRftPGUS+zBSVYsJi5AmlIG/s=;
 b=xauonnULjxUvH5sL69nxRI0AVOnesyUS3KuSkkedJDqpQpPeJNhmT56dPjuIxJtB6IyM
 2iPDkbIJ5XVf1HZ1jNqfII9WU/QCEr1w/C5EN+dQOtVdTur3RVhyfTkqOoDXQg7QIfk6
 LEyk60duRzle/OemNQvTe5qmBJhvTPTHRmtQjsryrcG6IKOCE6HNH6ElwzGC8a3ayoKv
 qtrBRZVbNEZKycwPlMcl12B6Rar7nplZBPMJORGCxU4UUP2u9rrDZJEsxD9bDMxPjQJP
 DyDduwhcyk8WwrEvNqb197FE/51p4cnQEOF7TAW4A95xvG0/7n2wNOARDyStSj6iVUwu WQ== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
	by mx0b-00069f02.pphosted.com with ESMTP id 39npbyh7tq-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 08 Jul 2021 14:20:44 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
	by userp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 168EKChf037321;
	Thu, 8 Jul 2021 14:20:43 GMT
Received: from oss.oracle.com (oss-old-reserved.oracle.com [137.254.22.2])
	by userp3030.oracle.com with ESMTP id 39jd15rjrv-1
	(version=TLSv1 cipher=AES256-SHA bits=256 verify=NO);
	Thu, 08 Jul 2021 14:20:43 +0000
Received: from localhost ([127.0.0.1] helo=lb-oss.oracle.com)
	by oss.oracle.com with esmtp (Exim 4.63)
	(envelope-from <ocfs2-devel-bounces@oss.oracle.com>)
	id 1m1Uq0-0000qC-OR; Thu, 08 Jul 2021 07:17:12 -0700
Received: from aserp3020.oracle.com ([141.146.126.70])
	by oss.oracle.com with esmtp (Exim 4.63)
	(envelope-from <dan.carpenter@oracle.com>) id 1m1UpZ-0000pH-AM
	for ocfs2-devel@oss.oracle.com; Thu, 08 Jul 2021 07:16:45 -0700
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
	by aserp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id
	168E0PTC044062
	for <ocfs2-devel@oss.oracle.com>; Thu, 8 Jul 2021 14:16:45 GMT
Received: from nam11-co1-obe.outbound.protection.outlook.com
	(mail-co1nam11lp2168.outbound.protection.outlook.com [104.47.56.168])
	by aserp3020.oracle.com with ESMTP id 39jfqcuetw-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
	for <ocfs2-devel@oss.oracle.com>; Thu, 08 Jul 2021 14:16:44 +0000
Authentication-Results: fasheh.com; dkim=none (message not signed)
	header.d=none; fasheh.com; dmarc=none action=none header.from=oracle.com;
Received: from MWHPR1001MB2365.namprd10.prod.outlook.com
	(2603:10b6:301:2d::28) by CO1PR10MB4500.namprd10.prod.outlook.com
	(2603:10b6:303:98::18) with Microsoft SMTP Server (version=TLS1_2,
	cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4308.20;
	Thu, 8 Jul 2021 14:16:43 +0000
Received: from MWHPR1001MB2365.namprd10.prod.outlook.com
	([fe80::3413:3c61:5067:ba73]) by
	MWHPR1001MB2365.namprd10.prod.outlook.com
	([fe80::3413:3c61:5067:ba73%5]) with mapi id 15.20.4287.033;
	Thu, 8 Jul 2021 14:16:43 +0000
Date: Thu, 8 Jul 2021 17:16:22 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: Mark Fasheh <mark@fasheh.com>, Larry Chen <lchen@suse.com>
Message-ID: <YOcItgIXtisi3MaO@mwanda>
Content-Disposition: inline
X-Mailer: git-send-email haha only kidding
X-ClientProxiedBy: JNXP275CA0011.ZAFP275.PROD.OUTLOOK.COM (2603:1086:0:19::23)
	To MWHPR1001MB2365.namprd10.prod.outlook.com
	(2603:10b6:301:2d::28)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from mwanda (102.222.70.252) by
	JNXP275CA0011.ZAFP275.PROD.OUTLOOK.COM (2603:1086:0:19::23)
	with Microsoft SMTP Server (version=TLS1_2,
	cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4308.23
	via Frontend Transport; Thu, 8 Jul 2021 14:16:37 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 5b0e76bf-ff9d-4a4a-2a45-08d9421b02cc
X-MS-TrafficTypeDiagnostic: CO1PR10MB4500:
X-MS-Exchange-Transport-Forked: True
X-Oracle-Tenancy: 1
X-MS-Oob-TLC-OOBClassifiers: OLM:1186;
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: t7ibkD9RZdebEARPh/48GlhUaEX6Rw3bMNKhWc2FbM9B0+Cr0+HuwvBZ3GJMG3abbx2NJFp9SWCAZ2FU4n+p0+7IreCGd6VgbJGJJYY5+h+pukftXSbBpLP+thUjKNBvKcxr5ADQHhM+zQtJaACI4CW7HR39IPcJNhtAEB2FsjDAwKcQiDrxCgJuBCNoYbJ0E76Ck6vRXii11QXmfk4JUV39KeqtWgFuMBmlZ46YtuMnUmZjtr1LSw5FKaPTGXwdAldjXGnEKbMvS4YgXCM1G/wSQV21t6iTGnyRzTAMk4YtNvBjYfGlV3e8zQH4Y+jxS2wExmkHqUdTVLGiXBeT3rhPs1jOH8m4GzCxrX16KGVn0NzKuiffEjJA+8S9Utk9UpC3d6mBaBcCOIWYQdtO3hl85whOtqUrap7vTDgoSp8iCWz4bWCTeejqQBnoXStc/EiQvTurGm7NT4Ka2AXZCuzlwPACWaap4QgwB3vgJDSXsAPCLqLH7LfVv5gZh/0TWaRXUZBNj5FoaTJCqveTVhgs+sSdo9Nr59Yn4vAP3KqjBRtSFXh4Hc1bBllYI/zu2bHm1Ea32Z+4CNAOPo1Nx6tJA6lmPt7qyJk7D0oyD/M=
X-Forefront-Antispam-Report: CIP:255.255.255.255; CTRY:; LANG:en; SCL:-1; SRV:; IPV:NLI; SFV:SKI;
	H:MWHPR1001MB2365.namprd10.prod.outlook.com; PTR:; CAT:NONE;
	SFS:; DIR:INB; 
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?ymuRr7MFgSdtiq7EO80R7P2Tll74sVGooRV7+bfAcYmHQYgxMk3xwAlgiKmn?=
	=?us-ascii?Q?KnV3TTMP60s6M9SZwBps2zvBbMhmiOmhnvT7H+ws8OkSAqwZlbPUfPFxoHGX?=
	=?us-ascii?Q?S7LcQLHWqucF0Joloqk+PM1fGilzofPk3S1X7V26oIwFG6WOe8ag+utYpyV7?=
	=?us-ascii?Q?lh6rCvsuWs5UrEkffOWhcKQEUZc7gO9KICSvipJVXNwRg6navZZsDq1b2duS?=
	=?us-ascii?Q?PuxxkqN4opneU0NRPqp/vYsJxTQ45Z73eZIFm9l5k9oSm30ds+N5BMC1ZUBF?=
	=?us-ascii?Q?E0vYyH8rHABL1jdKbcEwGQiIDSB8RATGQd/UR41jVla7uYKLbv9cN4S6Ek8o?=
	=?us-ascii?Q?Zhal60N5qJPv2a+PM0dYIGXCDDYkkkJaWWLVruTMeOexPQUEYs4+qOGgCpUD?=
	=?us-ascii?Q?rb0igBlGJ+EqET0CPnOBwtP54+Dvfbzt5bbRG0/BgvVllrheUbrkCWKQ/WTG?=
	=?us-ascii?Q?d0KtDioGcRrsgjjYZqSRiRFaul/4mZv2sKLbvr2C+5NRddQ9btjQTSuWry/H?=
	=?us-ascii?Q?Aib5VOvwny1CjPhPIKhRH+5REaUc674KtJI99wRZTzlvqQoKQIsm0X4lbqwa?=
	=?us-ascii?Q?KYGhJMs+VFjmKt92CSPQBPMzHTP/OSNs9ozwypnYdd8+gcUfenUFp7vrLG6k?=
	=?us-ascii?Q?Pvt55JG76G3lDBZ8ll3ql+xrc15rTzCIUVnoqxl0lCab7X6MAvr5zHoev76H?=
	=?us-ascii?Q?+YnP82mo4gcHOmHJbh45X3n+eng1qSDSi4cLF8G6J1naSzC7sQil3jMAkNK3?=
	=?us-ascii?Q?1CYPDiSOWvUmP4Fa4CwckOjLnWFzbGcADNFPbHB6yoHylaFj9k8iNZgaquP6?=
	=?us-ascii?Q?FXWtzVuW3xP0GpNC1J8H1fuvtKQMHQ7Wi8wHHqAKAk1OalEASkifBZi+cMUT?=
	=?us-ascii?Q?wWO82Hr2OIq5BtBub5KQHPwTmdlNHJjK/4oQZOE4nR8ZeX/9of/f2r4yBL9H?=
	=?us-ascii?Q?y9kXgXQ5GTaCAEYxGV9N7gqDXBlhTxQGYy1tL1moIySQtJFYXAvl52UzlXvq?=
	=?us-ascii?Q?7pCnhOltdANHGE6XT+sshkb/sIp8YwR13BVTTBr832DTQtZx7TziSLY+VXMF?=
	=?us-ascii?Q?+u4tKZSy05uiiUYGPRQi/DLyhTA2SKh18jA8pQFCHsPu1WsR45/TSNFmhuuu?=
	=?us-ascii?Q?uHULkLQgsd1+tOTL5Lu6zYmcKcMgV5leCUJb4h2h6rCRXaEN1FT3l8YyqDWY?=
	=?us-ascii?Q?74DM9mpHIZOtdDq4IY0IntsEySRwHfNS56VJckeJJ9iDn8vwSj/48OJKbuzG?=
	=?us-ascii?Q?H1JzewhtnCX3Tb0bVQm/HbEFAamUXpEJA1UhSOpkB93Oe3Z5ebV6oKCbAroR?=
	=?us-ascii?Q?znUT0URkDisyJ28sYpyHT8w5?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 5b0e76bf-ff9d-4a4a-2a45-08d9421b02cc
X-MS-Exchange-CrossTenant-AuthSource: MWHPR1001MB2365.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 Jul 2021 14:16:43.0029 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: qO6gSVtdwSJ2AO1J/7XSE++Kt3OR938QfG1aSrVdOvG5m4VAMXB98BS4vVpMQJiDBx23I2h9KiyCqvyWG99uL4YcxOI6Lx8XwyZP3gHRF4g=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CO1PR10MB4500
X-MS-Exchange-CrossPremises-AuthSource: MWHPR1001MB2365.namprd10.prod.outlook.com
X-MS-Exchange-CrossPremises-AuthAs: Internal
X-MS-Exchange-CrossPremises-AuthMechanism: 06
X-MS-Exchange-CrossPremises-Mapi-Admin-Submission: 
X-MS-Exchange-CrossPremises-MessageSource: StoreDriver
X-MS-Exchange-CrossPremises-BCC: Dan Carpenter <dan.carpenter@oracle.com>
X-MS-Exchange-CrossPremises-OriginalClientIPAddress: 102.222.70.252
X-MS-Exchange-CrossPremises-TransportTrafficType: Email
X-MS-Exchange-CrossPremises-Antispam-ScanContext: DIR:Originating;SFV:SKI;SKIP:0;
X-MS-Exchange-CrossPremises-SCL: -1
X-MS-Exchange-CrossPremises-Processed-By-Journaling: Journal Agent
X-OrganizationHeadersPreserved: CO1PR10MB4500.namprd10.prod.outlook.com
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=10038
	signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0
	spamscore=0 phishscore=0
	mlxscore=0 bulkscore=0 malwarescore=0 adultscore=0 mlxlogscore=999
	classifier=spam adjust=0 reason=mlx scancount=1
	engine=8.12.0-2104190000 definitions=main-2107080077
Cc: kernel-janitors@vger.kernel.org, ocfs2-devel@oss.oracle.com
Subject: [Ocfs2-devel] [PATCH] ocfs2: remove an unnecessary condition
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
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=10038 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 spamscore=0
 suspectscore=0 phishscore=0 mlxscore=0 bulkscore=0 adultscore=0
 mlxlogscore=999 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2104190000 definitions=main-2107080078
X-Proofpoint-GUID: XO2kUyyS5d1X7pdjQ_HR1RO9bCtiu_I9
X-Proofpoint-ORIG-GUID: XO2kUyyS5d1X7pdjQ_HR1RO9bCtiu_I9

The case where "tmp_oh" is NULL is handled at the start of the function.
At this point we know it's non-NULL so this will always return 1.

Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
---
 fs/ocfs2/dlmglue.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/ocfs2/dlmglue.c b/fs/ocfs2/dlmglue.c
index 48fd369c29a4..33fbdc823278 100644
--- a/fs/ocfs2/dlmglue.c
+++ b/fs/ocfs2/dlmglue.c
@@ -2721,7 +2721,7 @@ int ocfs2_inode_lock_tracker(struct inode *inode,
 			return status;
 		}
 	}
-	return tmp_oh ? 1 : 0;
+	return 1;
 }
 
 void ocfs2_inode_unlock_tracker(struct inode *inode,
-- 
2.30.2


_______________________________________________
Ocfs2-devel mailing list
Ocfs2-devel@oss.oracle.com
https://oss.oracle.com/mailman/listinfo/ocfs2-devel
