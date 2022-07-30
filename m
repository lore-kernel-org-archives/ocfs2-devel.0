Return-Path: <bounces+ocfs2-devel=archiver.kernel.org@phx1.rp.oracleemaildelivery.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from aib29ajc255.phx1.oracleemaildelivery.com (aib29ajc255.phx1.oracleemaildelivery.com [192.29.103.255])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1D62EC00144
	for <ocfs2-devel@archiver.kernel.org>; Sat, 30 Jul 2022 01:15:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; s=oss-phx-1109;
 d=oss.oracle.com;
 h=Date:To:From:Subject:Message-Id:MIME-Version:Sender;
 bh=A7B23MmhUdbvrioWgomQce/q/No5tWnC88HYKHebeLw=;
 b=m9/gcwhSW4jW49rtypEhCMJvr6qeaRlU+5paTWukGRW6Ihp/wGcDIuE16XcrNHkJjRbjxMbhpoXz
   vvP43dGOayhus+0uL3BauYmiS0FGOsEAXdUZT8tBDfImIu/mtP9WgpM8mog7ZeBeSDFd7lQ8iebX
   CdWz4RO7uOUIiisV/X/qgwG1pj8goRC2/ZfaMBxSE3YScMPR1yTlEfDoJIr9DLu5YZfecyKXc32C
   Go65x6M+iUljM+hIbxadJ60r655M9viWgeh9J+QOv4EA++3W7Qmm8EqwYCUhbcMvvnzEP+q0xNAY
   WVuq8iOggKW9o8QNZtpPJJ7h+TFS7Cdj/qFJ5A==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; s=prod-phx-20191217;
 d=phx1.rp.oracleemaildelivery.com;
 h=Date:To:From:Subject:Message-Id:MIME-Version:Sender;
 bh=A7B23MmhUdbvrioWgomQce/q/No5tWnC88HYKHebeLw=;
 b=IAL++VU5PLHk/2z1sJkX5wsaLAM0JX0yYPccsxpuxbMtvADIMqD4zfc/kaCEbMNIWErGMkgqadKT
   +C+8YpOReERLnleM033wzN/yLNcRFsFPsE1XgTLRP4uYG1rVOaOJCU7qBZ6fR5DqNFCMm80lOyMl
   9jxd6Ne+X08Eiaa3DLkw+Y6dU/Hli3y0riMu6dZy+wYGlBUqBdUiIJ9haflecPwAut1MHcaXhuc8
   IxdoCwaCIl62GMqCcAGcaT+DT9iO485Re4GYAUA6s71voqLp3zV8NEj/BAxkRDbdQG2ggb/ISzHp
   wPwkHc9UotB/odOsnDdAxfD5CrbiU47kaq6Dlg==
Received: by omta-ad3-fd3-302-us-phoenix-1.omtaad3.vcndpphx.oraclevcn.com
 (Oracle Communications Messaging Server 8.1.0.1.20220621 64bit (built Jun 21
 2022))
 with ESMTPS id <0RFT00E6D7HXCJ60@omta-ad3-fd3-302-us-phoenix-1.omtaad3.vcndpphx.oraclevcn.com> for
 ocfs2-devel@archiver.kernel.org; Sat, 30 Jul 2022 01:15:33 +0000 (GMT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=gdYFNUaFxR+dPNUTawRrOPPPusYrOqe74T5vUYtIlxOfbhevNwob/Gek0nTi/E67ZFOC0km+3TN1hnh7lSwSQmCTcQDPbm0LXZsIqeSz9G8tenPTIPct4EdWAtA9EsYHw73z21H0645ssO3Ip6m7Z4xqtKMgwgYqh0Ns4g4Z3YkmTy+IgUIwvt8lgWzGVzbCT9/AX9iR8UvHwfB/ZenGxvj3oPhInZn8+xB4TRslv3CohUz28rq2v/at3qyaBOpbHDjBmNOh0Snmolk7ceOyTf3250RJewx2lPTwhJ2VG1mY4tM5g3FovhVfYkm6SLOxOHdgCoy+DoSgKe/AsaxpGQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=3vuuBchB+O51IoiA5C4i5O89wdRv0b4+1Tc18qq+cZk=;
 b=doHzyOBqfnl4dge5vfdlEoPN1pP7D7lgTvsi6zZaW2D0n8sya52ois+p5lypsUe+3RcW6dAXjHdBQYwmVcYunTC2upK+wz8RmXRfeAB3/eeXvXYA/kHMW22KiJ6eX6qCMOBUOW7Kk36+ljN+mXrOqDvku9mnm3xsk5BRpyjCchfeVW7aHIMsf1HmGuzJFVWRBmBt28YO/C8lTlHNEpLTXEwdBfGalfJ5B7l6Ne3dT8ptEnnE0GK+JWE1gwbx4sgoQOMLGjLUjhBnJCKHynajJ1VnZbw3/URKlHhOihLZIapuMl+GpbAXQSYX51Hey93U9fmYVkXY423F9pr8bN8PQA==
ARC-Authentication-results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=suse.com; dmarc=pass action=none header.from=suse.com; dkim=pass
 header.d=suse.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=3vuuBchB+O51IoiA5C4i5O89wdRv0b4+1Tc18qq+cZk=;
 b=wieZFGNtvbyCWmJ3FRBDIXdKIgk/vQxvoAUUbHvI3ksAXgl7Hkv7n+l400WEdhg4UFdRkum+eoddMRcHzd4rvuJOEj2Nioh0F6FfvwE2qHu+RfzOW/nr7+Xh0dpWi3MhoCcaLdXNbb5zez4t5opDfWomhNB3u06PX3d1hy4l9JekfaefugjZyndj8QfBfIHsBwBbgK4RjUaggwC9fdwy/1mnc5YuGRKSyXaRC16SHt66j+YeElcYYvogvJQXWeDPj7iqFn436QGiudkCaxlhHaltEadYGiCXhwQUCnU+appKmObgG7YdkdnIzU0cSGq0vSgP6UFYu705gCd/9DYcZw==
To: ocfs2-devel@oss.oracle.com, joseph.qi@linux.alibaba.com
Date: Sat, 30 Jul 2022 09:14:09 +0800
Message-id: <20220730011411.11214-3-heming.zhao@suse.com>
X-Mailer: git-send-email 2.34.1
In-reply-to: <20220730011411.11214-1-heming.zhao@suse.com>
References: <20220730011411.11214-1-heming.zhao@suse.com>
MIME-version: 1.0
X-Forefront-Antispam-Report: CIP:255.255.255.255; CTRY:; LANG:en; SCL:1; SRV:;
 IPV:NLI; SFV:NSPM; H:AM6PR04MB4662.eurprd04.prod.outlook.com; PTR:; CAT:NONE;
 SFS:(13230016)(396003)(366004)(39860400002)(376002)(136003)(346002)(38100700002)(41300700001)(5660300002)(8936002)(66946007)(478600001)(83380400001)(66556008)(8676002)(316002)(4326008)(66476007)(6486002)(2616005)(1076003)(186003)(6666004)(6506007)(26005)(6512007)(2906002)(44832011)(86362001)(36756003); DIR:OUT;
 SFP:1101;
X-OriginatorOrg: suse.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 30 Jul 2022 01:15:09.5261 (UTC)
X-Source-IP: 40.107.1.64
X-Proofpoint-Virus-Version: vendor=nai engine=6400 definitions=10423
 signatures=596356
X-Proofpoint-Spam-Details: rule=tap_notspam policy=tap score=0 mlxlogscore=999
 spamscore=0 lowpriorityscore=0 bulkscore=0 phishscore=0 adultscore=0
 clxscore=190 priorityscore=140 suspectscore=0 malwarescore=0 mlxscore=0
 impostorscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2206140000 definitions=main-2207300005
Subject: [Ocfs2-devel] [PATCH 2/4] ocfs2: add mlog ML_WARNING support
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
From: Heming Zhao via Ocfs2-devel <ocfs2-devel@oss.oracle.com>
Reply-to: Heming Zhao <heming.zhao@suse.com>
Content-type: text/plain; charset="us-ascii"
Content-transfer-encoding: 7bit
Errors-to: ocfs2-devel-bounces@oss.oracle.com
X-ClientProxiedBy: SI2PR02CA0004.apcprd02.prod.outlook.com
 (2603:1096:4:194::14) To AM6PR04MB4662.eurprd04.prod.outlook.com
 (2603:10a6:20b:1b::21)
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 5e105d33-9f1b-4b61-ec76-08da71c8f1ea
X-MS-TrafficTypeDiagnostic: AM6PR04MB4840:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
 s/qlTbAPndrpxWTdDjoV3bkSITBouXmIBC6qIOAi8+vwqZC+OfZOkm4aPFrhdYCRub/LfCI/6z/zBHw0KiamojJ5GK7YznehYQhfxWSHOUU9zqknkm0yMmCfzQXM5X7D0Ale/7dfCsjSoyVQ+7ZA3+EhuGxFwGlcIWnQ2iTADqaObqsy5raLSHrz+rqMSGXkrMmEFCJI8K9NFEvHogewQnO1pNG0RXCHvjXo97577cDOnO9SUnKEvyoeL6obTPBwwZG4e0sx6aHCXexKrIlsMNiBMVKX512MNa0l/215t4HBez0JHM/TwKZmpxICFhs4l52RFG3rVGWezKseEz/poruOxuPyI9ojsyZz2oeNq5xcbMW+2NfXnR3CBu9U84ovrbsYw1RZGo9pOdCCCGXKI35r3pN7sE6j1F2/rNZxTePfYUevGxPQZXnnqInJAHw7aRO+AzLytOP6MnUJY8RKqT9P5elLRnSpRjdMzQkXOroM5Bftf76ltTTvlMwb2wkWjbRoAlzBiwXqNpFx+m9tf2ofByeH++L8MrrCoAFqGpetPUtbUe3f6p2kjv0v6BkD9SUt4DBr+XeImRFdSTAzQDxavBWgd3J3EPLX9bvsuAabx9obDeih+FrMkXKx6pYHUU3j3epgCERs+mPQFma3CESvfHBkpRwgqd0Ld65dmT+8A7K58koVdnbdE2JambH8nP0hE0GOvQQPv8zyrIZE1PmG2WaqoPdO+9VWJZm9j2GKd78Y+BkAL7UF62oX3AJ0
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
 =?us-ascii?Q?g4nLdlzONDczW/NavSQUSYmIFlmVIy1f9uVDKg6xgycUrwze8T4XuavX6n9u?=
 =?us-ascii?Q?TspBWnqqSCgIEaSpcASX97RRdcOsGobadn/K6usC1VMIxKYCdWAPPnYz5kg+?=
 =?us-ascii?Q?nCHCVlklV4cyx2P14mc2rEKzpS4LCWK9W/XD6KUgHqgOnWmxx8blIpY6Tp9f?=
 =?us-ascii?Q?/g7vO7QglcsVtBfTHD7NtG0n5b+G4eBUheuxSutIkMD/S11CtSAoKL+ajXxV?=
 =?us-ascii?Q?3Jua2DMpmCIc2p8hpoL5y4iuO+tSwGZjXG1GpgOjsiqF4c54nMOJV1TsnMeZ?=
 =?us-ascii?Q?zx5DVJA9bhxRlWBpxRMk+8o1G33F+AHiD5gAoAXj0wQRfNgLFljgPvFZZBL5?=
 =?us-ascii?Q?biBrl7e+eFoAItdYobfHrJFZRZ9a1NFkEKKJYKaUEppzSP05nm9e/Lfit8KD?=
 =?us-ascii?Q?r6Jb5NHwHj5WNdPBjZ3y4zOSVbseUH4WnrJCX0pHy3WiFVkmvRpaY5NntSLC?=
 =?us-ascii?Q?xhUZHNYaQzMmrxPVFDjR2qYsdHDPEO6xHF6DCv8Tf0q9Un2CyG05MuoYgq3x?=
 =?us-ascii?Q?RX8RKXUEkRTMvNkDoaBqH12tJK6+4ZvDGO4JOG5QWDm+bNtRijxJ1otmfQvB?=
 =?us-ascii?Q?oPfZyPkcxCoTwaDS7mrK7Wu0iwXQho0yrNVA/br0sowNG2ExADQiUaYD7d4a?=
 =?us-ascii?Q?igs8FlZuuwtPRGLlTkNGDlgN4LBkkV9LmjbT8SrJKXBHk/ZJEZFQ5FjPlJgS?=
 =?us-ascii?Q?xleWGs654rTYCf+ygMY+swY31ATAxhMdbasAg6+5TEt2D7mbMr8T8eWJCKrj?=
 =?us-ascii?Q?pgIQgT4gK2hYjVnAzcucLBExAnhWShYHLb6k+ZHRi7583/PCeteHi5Hq9Tp/?=
 =?us-ascii?Q?4gPPOtCgcfuIsZYTgYFLG39usoDZ9A9O6IDdt/SqGrn8k6z/TB+lDLimeQSx?=
 =?us-ascii?Q?5tDf3vTBGJwhnyRgQH76fBc4BD5juzmSeSxOaQHtjrKcGCWMUMtkv5UO8Fej?=
 =?us-ascii?Q?0PqZKUtCShiuq5GFdc6ZaVVaq/0MNT0FpiMxM6d2CX4BfMM/+BzwAmN/MVwT?=
 =?us-ascii?Q?tMpw9EvQlL0LT8LDfkSWXe1hVCSgBikxGzefq5cbJLNPv+5B54ugI2CqkTN/?=
 =?us-ascii?Q?tXa6DWQKOPDMzN41lTzvZftoVBUnSnlTGaBMkRAr3iZsR6/SNdK5EJlOqGsT?=
 =?us-ascii?Q?8WxNRgrLrvx2LjpWwKmDU9zd79t3DNj9ngDf8z07CLIrKqo0m+kVEs/5DH5+?=
 =?us-ascii?Q?Pj2fNaITdLIE84JPlzyqioI0SeP8ohjQBADZypqfEUVekTbTqVQordAn+/at?=
 =?us-ascii?Q?qhy9G3712zP8hf17W792HnKOv/DQ4IpfK6lM0P4CLDauUE0wwi3Js6oLRu7W?=
 =?us-ascii?Q?F0SV51b7wCFOH/IFefqVx4g2tI8Ju3fdSbo5UHUXWsM4FXbc0SKdhEMKDjZO?=
 =?us-ascii?Q?gKpKla2rDB9wpdjEYzDy+SC2oG1HSfGuvXJroF03woMdtv9hm5r8SSD6+CGS?=
 =?us-ascii?Q?w9mN+nHsOIKswL1cDl1wI2W9A0oHdOjRVZG8aU6uKxclxS3SJHe335ZJa0Vk?=
 =?us-ascii?Q?wtcxnJq9r930PGwIH2dm1/D0cw0WhVegwWyPuq/bUkwv0zLwLOhb2kSUc4R+?=
 =?us-ascii?Q?DnYZGEoehvjATgz5Yneomdi04iKqEXIPplZnPhWy?=
X-MS-Exchange-CrossTenant-Network-Message-Id:
 5e105d33-9f1b-4b61-ec76-08da71c8f1ea
X-MS-Exchange-CrossTenant-AuthSource: AM6PR04MB4662.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: f7a17af6-1c5c-4a36-aa8b-f5be247aa4ba
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName:
 r+rBcnyQcXJAwR7QW29YyM/UG/CTlV2QeDDoDEl1veaVjSHmtc/akCmNlaxeLEerR6d7h1aWCvIt5w7cy7t6+w==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM6PR04MB4840
X-ServerName: mail-eopbgr10064.outbound.protection.outlook.com
X-Proofpoint-SPF-Result: pass
X-Proofpoint-SPF-Record: v=spf1 include:spf.suse.com include:amazonses.com
 include:spf.protection.outlook.com include:_spf.qemailserver.com
 include:_spf.salesforce.com -all
X-Spam: Clean
X-Proofpoint-ORIG-GUID: jQdGWXhY-bnDM6QNHw4SsGSfFKMONSHP
X-Proofpoint-GUID: jQdGWXhY-bnDM6QNHw4SsGSfFKMONSHP
Reporting-Meta:
 AAF3Sof+ipe41aLJfEoXSte+rQliFlE2IFVPBR9SeTrkm7xvtuQv2MbozowSBQgV
 U/mJyATS9PiRxexGmzuE9n5Xh/xM1z/c5kg8RJjIVkX3IJPBxI7D0DkMXJmp69fC
 4uC6LKcJWYTpUVlXaZU3Hlhi6FKwBnVPsIiaMN4Bl/mjAeVrRIiQk5mRL6/M2/qk
 oNCaAkmFKAkdJSUeq2kBqc3ADqNLJv1MOadXY0EfhwLWLuoWC6l9X4CQ4Jm5MITF
 5mF1+WcHKQXTb4OeavesoH5iTjWO0BvXvCgVzKE7OBmZcSagqBnfukLTLQdrae9s
 UkzVPSEEgPw8WCQ0ClH2WRfeA0wdnIvGCBx9tO8rOK/TQTF6UmAZinkJShPG0MXd
 ta/7HSmPJnGFES0Z68+ZThb3c558cOr5KdRYyItCfGgZX5F2HfystKGaYCpVgffS
 mLpplwo1dLUGFqcO6ohz3hUBPawXLeR6vWY5sRWx/hwR/n70Z9ytrsG0M5bVltBY
 Sqsb1CPvnnxQxXP8RvVM1moF9D8yb6OuSr/usP3+nGs=

This commit gives new message type for ocfs2.

Signed-off-by: Heming Zhao <heming.zhao@suse.com>
---
 fs/ocfs2/cluster/masklog.c | 3 +++
 fs/ocfs2/cluster/masklog.h | 9 +++++----
 2 files changed, 8 insertions(+), 4 deletions(-)

diff --git a/fs/ocfs2/cluster/masklog.c b/fs/ocfs2/cluster/masklog.c
index 563881ddbf00..bac3488e8002 100644
--- a/fs/ocfs2/cluster/masklog.c
+++ b/fs/ocfs2/cluster/masklog.c
@@ -63,6 +63,9 @@ void __mlog_printk(const u64 *mask, const char *func, int line,
 	if (*mask & ML_ERROR) {
 		level = KERN_ERR;
 		prefix = "ERROR: ";
+	} else if (*mask & ML_WARNING) {
+		level = KERN_WARNING;
+		prefix = "WARNING: ";
 	} else if (*mask & ML_NOTICE) {
 		level = KERN_NOTICE;
 	} else {
diff --git a/fs/ocfs2/cluster/masklog.h b/fs/ocfs2/cluster/masklog.h
index b73fc42e46ff..d0bc4fe8cf3d 100644
--- a/fs/ocfs2/cluster/masklog.h
+++ b/fs/ocfs2/cluster/masklog.h
@@ -86,10 +86,11 @@
 
 /* bits that are infrequently given and frequently matched in the high word */
 #define ML_ERROR	0x1000000000000000ULL /* sent to KERN_ERR */
-#define ML_NOTICE	0x2000000000000000ULL /* setn to KERN_NOTICE */
-#define ML_KTHREAD	0x4000000000000000ULL /* kernel thread activity */
+#define ML_NOTICE	0x2000000000000000ULL /* sent to KERN_NOTICE */
+#define ML_WARNING	0x4000000000000000ULL /* sent to KERN_WARNING */
+#define ML_KTHREAD	0x8000000000000000ULL /* kernel thread activity */
 
-#define MLOG_INITIAL_AND_MASK (ML_ERROR|ML_NOTICE)
+#define MLOG_INITIAL_AND_MASK (ML_ERROR|ML_WARNING|ML_NOTICE)
 #ifndef MLOG_MASK_PREFIX
 #define MLOG_MASK_PREFIX 0
 #endif
@@ -102,7 +103,7 @@
 #if defined(CONFIG_OCFS2_DEBUG_MASKLOG)
 #define ML_ALLOWED_BITS ~0
 #else
-#define ML_ALLOWED_BITS (ML_ERROR|ML_NOTICE)
+#define ML_ALLOWED_BITS (ML_ERROR|ML_WARNING|ML_NOTICE)
 #endif
 
 #define MLOG_MAX_BITS 64
-- 
2.37.1


_______________________________________________
Ocfs2-devel mailing list
Ocfs2-devel@oss.oracle.com
https://oss.oracle.com/mailman/listinfo/ocfs2-devel
