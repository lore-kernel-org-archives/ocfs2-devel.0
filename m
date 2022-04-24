Return-Path: <bounces+ocfs2-devel=archiver.kernel.org@phx1.rp.oracleemaildelivery.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from aib29ajc250.phx1.oracleemaildelivery.com (aib29ajc250.phx1.oracleemaildelivery.com [192.29.103.250])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B418FC433F5
	for <ocfs2-devel@archiver.kernel.org>; Sun, 24 Apr 2022 13:10:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; s=oss-phx-1109;
 d=oss.oracle.com;
 h=Date:To:From:Subject:Message-Id:MIME-Version:Sender;
 bh=4elcUrVsQ3ECMVGFkPK76Iffm/Dq/UPKJmVFbnWEWdk=;
 b=SJ1N3j0b3xImRdj/8AyGKR35jl8Z3IIiYkwooZh3z7w+GPdWS+2dSB81R3tS+EqzP2dmNENndDj9
   Al6wNiKiICTh45hrQfSR9Ss2iA5HGzhf1DUkAKB2N5nMMt8XmaV151WlTaoMITYMs148VjeIw49J
   E0esjUqckgN3YEknuyWg2FRvd3rMqposZxK0rTOTCDI711vxI/rNvV7IO4LT2LzR1z6SI/pjPDnj
   6k6qvYbiHLvNpEIZ/qCw6trA0kAxaXLMz9GVQwRXG2eab1UpXlNjTPpmaCtuGiP8Nj7vt+Mm7kpA
   oBF6ylE4/z0XLFE2YSb2ouEhmLheIZy7DqE4Bg==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; s=prod-phx-20191217;
 d=phx1.rp.oracleemaildelivery.com;
 h=Date:To:From:Subject:Message-Id:MIME-Version:Sender;
 bh=4elcUrVsQ3ECMVGFkPK76Iffm/Dq/UPKJmVFbnWEWdk=;
 b=mND3ZP757Pd5S6a8lAUHg7aNKw+KMvzVNUmRKD5IBsPXuKX4vlzuFGWBW0m8kJoTQdGZyXMciAXK
   ClpXbIcmzr071RCVBhFRhVtbmYDENGzVt518tYuLXx021FD6A4+zi0qtwjl4DOwR2x6UnlsYEw2Q
   5hiJu8qiAgLHEgGZWr88m9pK37NS2OP880KI+vTZnSDZ2+h884kHv0fe5eZEHcXPY1EOcU595gWX
   X93gQySOg2zQ9m3Wn9kgJOqrMsHbayqvugR8FkYKPH5T7tiiEgJ1LIPP2CYqxaFU4Jpkh8trYV32
   Rl8152sJJAoUFTXFQkWgCrY3v7bXQCNnyIksPQ==
Received: by omta-ad2-fd3-201-us-phoenix-1.omtaad2.vcndpphx.oraclevcn.com
 (Oracle Communications Messaging Server 8.1.0.1.20220319 64bit (built Mar 19
 2022))
 with ESMTPS id <0RAU00839HY5SJD0@omta-ad2-fd3-201-us-phoenix-1.omtaad2.vcndpphx.oraclevcn.com> for
 ocfs2-devel@archiver.kernel.org; Sun, 24 Apr 2022 13:10:53 +0000 (GMT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com;
 s=mimecast20200619; t=1650805841;
 h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
 content-transfer-encoding:content-transfer-encoding:
 in-reply-to:in-reply-to:references:references;
 bh=gK18UG57XQGAs+YPr77KLycMfn2fH5rEz/LmqKUjqpw=;
 b=Nn5OjjsdwcrV28r4TD4hvds/Wxg/YFQX4+hd8NGM1+o1KVeLE/Z2UAYZD7XiNkD458onJ4
 zE3hHt2kt2I9A5sTlCqH/TdZCZjr690xBPHka2iCPhwksvLhA2WnyCV9Z3xWdXdGIIDvI7
 TMKfm8XDihpyvSkYjKy1A260QOlexDA=
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=JV8LhtkzmqJbvkSRew1hbnqDkIBUwTIYW7zr8IYRUk4J2d97HIQPiEUUDiDLGDmWNmU5tBYwWsEl+lMaGSsCnKZ3dEjgyeDn3FcoLW2qpQHwQWjsXsR0UK+z2bSO5XWb3ECAAjB20J+IbYm9122cjt2GWfzfoQ3aQXWKRERQP0GlpMOOdG3stNgZ8EbCfpujGspr46isSm9lurvTs4mHsW9K9IwPtHDsSwPQ016aI5XSpji6UDBZ8vsu8Et6MuGDiXoGN9q2cavU0tz7TuQMZzkKLha/EbOaqvNOR4r7oycZuCvk6+XjWWSCEoEjzEvFGg9jOwUg+6MKQOwQrDLOgA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=yAQhj73BBD1nl6xqpLKkmd9Oo+h7lZKFxksg51N2d8o=;
 b=gyjF41h4Z56wL1Z2nBxNCqfPK68DsQmSWS+OrTLpiPNEk8KeEOo7c6BgO9W4fkW+SRRv3QEZRKbqfjBEbzUFweSUqrOHMcI5wYXIvzt88hJGyIjqbGyiq85a+XNqJ5dD4QICV7rqxeCOJ8pzDDF4GjDvuokEb1Elm0XPhj04Jo2PbUcxa33EWsdGQ9ibxrrM2Y7xt/zelyuQT0VYA19He8egMUiVbVfvHdv6Je8uN9V7IpGPxSCvRdIQXE2FEb7zdccuJdX6E4RuMWwmZl8qHMe0KxduJWoEkTcsULlIGbq4af7NY8FrK3Osepl5tBv3UOcb2PxFDAztQ5bBt6SQdA==
ARC-Authentication-results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=suse.com; dmarc=pass action=none header.from=suse.com; dkim=pass
 header.d=suse.com; arc=none
To: ocfs2-devel@oss.oracle.com, joseph.qi@linux.alibaba.com
Date: Sun, 24 Apr 2022 21:09:52 +0800
Message-id: <20220424130952.2436-6-heming.zhao@suse.com>
X-Mailer: git-send-email 2.34.1
In-reply-to: <20220424130952.2436-1-heming.zhao@suse.com>
References: <20220424130952.2436-1-heming.zhao@suse.com>
MIME-version: 1.0
X-Forefront-Antispam-Report: CIP:255.255.255.255; CTRY:; LANG:en; SCL:1; SRV:;
 IPV:NLI; SFV:NSPM; H:DB7PR04MB4666.eurprd04.prod.outlook.com; PTR:; CAT:NONE;
 SFS:(13230001)(366004)(316002)(66946007)(1076003)(4326008)(2616005)(66476007)(107886003)(86362001)(83380400001)(26005)(186003)(66556008)(8676002)(36756003)(6666004)(8936002)(38100700002)(6486002)(44832011)(6506007)(2906002)(6512007)(508600001)(5660300002);
 DIR:OUT; SFP:1101;
X-OriginatorOrg: suse.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 24 Apr 2022 13:10:37.5866 (UTC)
X-Source-IP: 194.104.109.102
X-Proofpoint-Virus-Version: vendor=nai engine=6400 definitions=10326
 signatures=694694
X-Proofpoint-Spam-Details: rule=tap_notspam policy=tap score=0 bulkscore=0
 impostorscore=0 adultscore=0 priorityscore=0 mlxlogscore=999 malwarescore=0
 lowpriorityscore=0 phishscore=0 clxscore=191 spamscore=0 suspectscore=0
 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2202240000 definitions=main-2204240062
Subject: [Ocfs2-devel] [PATCH v3 5/5] ocfs2: rewrite error handling of
	ocfs2_fill_super
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
X-MC-Unique: BUV7wVoeM1azzTP8N5rkBg-1
X-ClientProxiedBy: HKAPR04CA0002.apcprd04.prod.outlook.com
 (2603:1096:203:d0::12) To DB7PR04MB4666.eurprd04.prod.outlook.com
 (2603:10a6:5:2b::14)
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 824ee9c2-62f2-454f-e65b-08da25f3d300
X-MS-TrafficTypeDiagnostic: VI1PR0402MB3344:EE_
X-Microsoft-Antispam-PRVS:
 <VI1PR0402MB33447F082598D6A9B51C1B8A97F99@VI1PR0402MB3344.eurprd04.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
 t/xG4JKvBJ/8BSP3bd4Jdk84N9z1slODbkq365wbzbMjYKHD26D5HK+X/N/qVBVmlu3BsLsMCM6dQ7ndHe59Y84wBPfeQacM40CVINPM+ZGmlZD1yIiIlx/JQtPhb2k1fDPSsWuEC5oZEbM1vQGdFrh59a9jd4dgmv/5JfdcVaIsQZDtrrk5KPdbnQ0IzKJ70I5AFF67fwyGD8+/kaAsx8f6zjJ/7XjUo3tEvkrUOjpkG4Jkd3mNlJbftDDm7q6F1dto2zgYGUi7hyLHcGcGeAspcjJMHbTLozsi/GR7G1tauRiOF4snE3+xin2LbyNTHFitI8AbJk1988bU26TZoDkFEJ3sEfAQSSpFiNZG8m7U/hJ/RrpBEhRx3iaef40BSNuvsuuj3DSB+vM7tgYqd1+LSoJO2xRhyU7ovdvYJ5yyn+laHtCY1jq6GKah2c8B+r999f8ql5p3FmhrKOIjXF6g97/3CP/0j9W+Q7XnQfrrzK6yBJVUcvG4OU1BczP6+hBH/RFXtno84sT5Wc0FJhyXcpEVrTB1w68P/qjxAngn5fGaqtWELW/BPK3S+8PXPKOKdrseUy6pbt80jNf+u6DuqIDn5ZgXi/M0ur0Q055oYfxhS06Dwc+dGpBbFenHGOeJy1udsDZcalWCgmW2Rw==
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
 =?us-ascii?Q?bwXonQjKnAeYuAcO4g6QXSIOvmU8Qe3eVbIEMsuFc9j4u9/NhaeZVik7kaLc?=
 =?us-ascii?Q?AS0DZg+KqXzbfC0R7HyDi0Dwoo0Rn3e2vv0gog+vy2Z1PTLzp3Fagdef42OR?=
 =?us-ascii?Q?0zNPt9Hxg+pB7r4WNy2XhUt/e6g6ut2R22eUA0NarkwxPDwzDtK1+H9qRsGc?=
 =?us-ascii?Q?76QNOX9A9il9NrYesqH9aJ2Jg9i29Yi/TsRSGReu5LzUelVwH6C0Nk4fms2i?=
 =?us-ascii?Q?CSQa73ZsdqPpZnUv0bQr+8gZhDXgorNTFNMvpQHLuOO8fVfKlKc5X752Yei6?=
 =?us-ascii?Q?tJLRDY0vBcz4ujvnAas/Yt6+4guaJ+S3DIg1+9ZfnxnXJZYvD+Bb2CQP82fX?=
 =?us-ascii?Q?gDCfNRm5McOVl/3IuBTbjvvRyl1LA3FMOqiRlFHMRtrfDor+73ycvzgK21DU?=
 =?us-ascii?Q?qN++eyJ2SwXi9uhj9Q2+T6xEi0k1FOS+yFsTSkun67tMYXIezmrs3HEQoCxf?=
 =?us-ascii?Q?JmFOKnwyDkTjQneU6OS3nkWPnHuX9usnaYglKyDEHA23Ci0TCwsUwaEg+VlZ?=
 =?us-ascii?Q?jiswGOHlFcbA1GXWVIilfCmq9c/L/Crk9OGikKD7ODdrB7uTQNYKhlhn5HNf?=
 =?us-ascii?Q?ss+O390koTxsa6MX7rsYMcl+NVoj/LWBscjXK3qWQAyuYALfPyHmXcjq6McD?=
 =?us-ascii?Q?IsHluMDjo2f0eVfh/q9so0SKOuFi3kcnO+cdzOzbJzPYMdAfq5CFn13b4Qpm?=
 =?us-ascii?Q?UCX0fs9ZKfls8PjKOV9V4fMOR1KiqyElcEOokOPtfdOyBqsEwDZx0QwhyjH7?=
 =?us-ascii?Q?/KGK40WxdblWT3fwn0aYFnvSV8L3xJxwezEZYIq5PjpyMx8Re7qJPhGM+DnE?=
 =?us-ascii?Q?7bcVStD7KnxXu1QfJ8a5ojx9oLF55YbJHTd/V1f/WYuey7mw2S4zQ7YTM2yB?=
 =?us-ascii?Q?LKSwdp23x/MgeeAaRCMzvDVvahpdoTZXy8Wap8zA71bl6Lpi80QRxYuDvl6S?=
 =?us-ascii?Q?h9zs2ZIVk2uND0mrQ4bo8/u3C1W/IT0BywsIpR0eEmNmekYRzIHXWFPSEyk3?=
 =?us-ascii?Q?kSHtLrgmxj1WGHJYK8SMuTtUlNpKDEzvx0RzY8/gia34cDzca/9hdvfooQqX?=
 =?us-ascii?Q?A9GmgpYGuqnJCK6GYX1JsiYksHp6NLvJNG56SoxCivtez7Tej8lHrPV8lKvt?=
 =?us-ascii?Q?/34GBohyM7cFUHVrWucpyCg2gmDzh+YfUyMkVcTP2GbgyGA9a8F6uXufAFDb?=
 =?us-ascii?Q?uYPUNxCJ2LzEAMcWtie67V0pQZpHFEwoCmEbhlJa17Rdg+55f2z6ctGtAwyb?=
 =?us-ascii?Q?jOPyuwBURi7uOOGzfhx/eS6IP1mS65n5gwFrm/ZSP7I4IEWV1WUmN9zmu4UW?=
 =?us-ascii?Q?eeBcUm0o4J2rUIxFWx62ln1+y8lN/D4MYwafZAlQTEMlCXqTuymHhWcm+AN5?=
 =?us-ascii?Q?ijxk594I0G3Cgpt42+xkjAUIUrCFY0/FrCxgRH0O2GEhmxMLwJy3sCOBvZn8?=
 =?us-ascii?Q?1lE4CVG5Y+S9Tox1Jw3IZkxHg4vDhFxSxAWH9qpCM2YYSygENi3u5oELA4gE?=
 =?us-ascii?Q?ByL32v/bk1pb/NxPyAPZGEu1JG9ICA+MnLIQyCoe8mct694WlXYbxMKPwZWH?=
 =?us-ascii?Q?1eecDVu8o7uR3rVxDDTZNCL3AkKQykkqpvH1kL4GIuULTSyBd1cDtfojfe2F?=
 =?us-ascii?Q?eV39ZQ8zlXW8QFKkYxknXneN+wdO+J5zbtmpU+obcisZ32QCsBPPMPLUbV1X?=
 =?us-ascii?Q?FH1V+1nW+GlbZEbiIcXqCzM3vkLuI97MnZeXA+wP1vdRkiU6vBEOMs3xT+9Q?=
 =?us-ascii?Q?Qq0hVQSHKQ=3D=3D?=
X-MS-Exchange-CrossTenant-Network-Message-Id:
 824ee9c2-62f2-454f-e65b-08da25f3d300
X-MS-Exchange-CrossTenant-AuthSource: DB7PR04MB4666.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: f7a17af6-1c5c-4a36-aa8b-f5be247aa4ba
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName:
 Wm9Kkwqh7nZkOkflj4O954Y05DbdXnoDN4vCdDIbpVKCFsSMU8uUWfcoMCWznxulGMKsa76vaoGv8JXLBO7NPA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR0402MB3344
X-ServerName: de-smtp-delivery-102.mimecast.com
X-Proofpoint-SPF-Result: pass
X-Proofpoint-SPF-Record: v=spf1 include:spf.suse.com
 include:de._netblocks.mimecast.com include:amazonses.com
 include:spf.protection.outlook.com include:_spf.qemailserver.com
 include:_spf.salesforce.com -all
X-Spam: Clean
X-Proofpoint-ORIG-GUID: h-HeJ_Cm63kofMypaGP0b3SRrS9LRplZ
X-Proofpoint-GUID: h-HeJ_Cm63kofMypaGP0b3SRrS9LRplZ
Reporting-Meta:
 AAFbv19XtEbe+hUKUJGfHKJfCJAHqfZu7hbOp0+IXBO9cwgeRWhdBILBz4cgQSjs
 AahRPuJfpozfzakcCrdmr2Wq+kAo4cZRzCNbsYJdE3gpQMnO6jmcQBnZeMPoTP19
 wm193MiNGIfgwgdzmfYdveHd0sjToHe/1pwdGpDfiW3ifYNSBe/Z/ChrXtmUM+HX
 9TGSUXtjmU4OMmWGNz7FD4uUNK3WDjBmkRQxzj3HIgVNsZMVvTE4NTMS/zcT71fk
 7r/4mo/V1llUWWiZoQlynKjysJBAsVfSO9aMq3sxnGVIGMhaN3+tEM247DQMyVZc
 zOhfpsaqXlzgL4KT9pSpmnOulp5k4lTM2+Udwv08kgS4Bpe8+2iL5N5ixewl2sqO
 qRIlTUjuF6yATFp3p8MtwhGPLhjuBXQrefSmM0n+UPxgioVWYyD4LVpRx+XJpRoU
 Wbj6IjCLNi70f1usMFlWORHlwTxk5/mZQoYoxAa6KcFkba8h4mzh700hmvWe2D2D
 GEnEb/H1cP6m1gtDTIfLkMfsVuv930RxCngO1J9eIXAU

Current ocfs2_fill_super() uses one goto label "read_super_error" to
handle all error cases. And with previous serial patches, the error
handling should fork more branches to handle different error cases.
This patch rewrite the error handling of ocfs2_fill_super.

Signed-off-by: Heming Zhao <heming.zhao@suse.com>
---
 fs/ocfs2/super.c | 67 +++++++++++++++++++++++-------------------------
 1 file changed, 32 insertions(+), 35 deletions(-)

diff --git a/fs/ocfs2/super.c b/fs/ocfs2/super.c
index 1cf18ed8cf1b..f7298816d8d9 100644
--- a/fs/ocfs2/super.c
+++ b/fs/ocfs2/super.c
@@ -989,28 +989,27 @@ static int ocfs2_fill_super(struct super_block *sb, void *data, int silent)
 
 	if (!ocfs2_parse_options(sb, data, &parsed_options, 0)) {
 		status = -EINVAL;
-		goto read_super_error;
+		goto out;
 	}
 
 	/* probe for superblock */
 	status = ocfs2_sb_probe(sb, &bh, &sector_size, &stats);
 	if (status < 0) {
 		mlog(ML_ERROR, "superblock probe failed!\n");
-		goto read_super_error;
+		goto out;
 	}
 
 	status = ocfs2_initialize_super(sb, bh, sector_size, &stats);
-	osb = OCFS2_SB(sb);
-	if (status < 0) {
-		mlog_errno(status);
-		goto read_super_error;
-	}
 	brelse(bh);
 	bh = NULL;
+	if (status < 0)
+		goto out;
+
+	osb = OCFS2_SB(sb);
 
 	if (!ocfs2_check_set_options(sb, &parsed_options)) {
 		status = -EINVAL;
-		goto read_super_error;
+		goto out_super;
 	}
 	osb->s_mount_opt = parsed_options.mount_opt;
 	osb->s_atime_quantum = parsed_options.atime_quantum;
@@ -1027,7 +1026,7 @@ static int ocfs2_fill_super(struct super_block *sb, void *data, int silent)
 
 	status = ocfs2_verify_userspace_stack(osb, &parsed_options);
 	if (status)
-		goto read_super_error;
+		goto out_super;
 
 	sb->s_magic = OCFS2_SUPER_MAGIC;
 
@@ -1041,7 +1040,7 @@ static int ocfs2_fill_super(struct super_block *sb, void *data, int silent)
 			status = -EACCES;
 			mlog(ML_ERROR, "Readonly device detected but readonly "
 			     "mount was not specified.\n");
-			goto read_super_error;
+			goto out_super;
 		}
 
 		/* You should not be able to start a local heartbeat
@@ -1050,7 +1049,7 @@ static int ocfs2_fill_super(struct super_block *sb, void *data, int silent)
 			status = -EROFS;
 			mlog(ML_ERROR, "Local heartbeat specified on readonly "
 			     "device.\n");
-			goto read_super_error;
+			goto out_super;
 		}
 
 		status = ocfs2_check_journals_nolocks(osb);
@@ -1059,9 +1058,7 @@ static int ocfs2_fill_super(struct super_block *sb, void *data, int silent)
 				mlog(ML_ERROR, "Recovery required on readonly "
 				     "file system, but write access is "
 				     "unavailable.\n");
-			else
-				mlog_errno(status);
-			goto read_super_error;
+			goto out_super;
 		}
 
 		ocfs2_set_ro_flag(osb, 1);
@@ -1077,10 +1074,8 @@ static int ocfs2_fill_super(struct super_block *sb, void *data, int silent)
 	}
 
 	status = ocfs2_verify_heartbeat(osb);
-	if (status < 0) {
-		mlog_errno(status);
-		goto read_super_error;
-	}
+	if (status < 0)
+		goto out_super;
 
 	osb->osb_debug_root = debugfs_create_dir(osb->uuid_str,
 						 ocfs2_debugfs_root);
@@ -1094,15 +1089,14 @@ static int ocfs2_fill_super(struct super_block *sb, void *data, int silent)
 
 	status = ocfs2_mount_volume(sb);
 	if (status < 0)
-		goto read_super_error;
+		goto out_debugfs;
 
 	if (osb->root_inode)
 		inode = igrab(osb->root_inode);
 
 	if (!inode) {
 		status = -EIO;
-		mlog_errno(status);
-		goto read_super_error;
+		goto out_dismount;
 	}
 
 	osb->osb_dev_kset = kset_create_and_add(sb->s_id, NULL,
@@ -1110,7 +1104,7 @@ static int ocfs2_fill_super(struct super_block *sb, void *data, int silent)
 	if (!osb->osb_dev_kset) {
 		status = -ENOMEM;
 		mlog(ML_ERROR, "Unable to create device kset %s.\n", sb->s_id);
-		goto read_super_error;
+		goto out_dismount;
 	}
 
 	/* Create filecheck sysfs related directories/files at
@@ -1119,14 +1113,13 @@ static int ocfs2_fill_super(struct super_block *sb, void *data, int silent)
 		status = -ENOMEM;
 		mlog(ML_ERROR, "Unable to create filecheck sysfs directory at "
 			"/sys/fs/ocfs2/%s/filecheck.\n", sb->s_id);
-		goto read_super_error;
+		goto out_dismount;
 	}
 
 	root = d_make_root(inode);
 	if (!root) {
 		status = -ENOMEM;
-		mlog_errno(status);
-		goto read_super_error;
+		goto out_dismount;
 	}
 
 	sb->s_root = root;
@@ -1178,17 +1171,21 @@ static int ocfs2_fill_super(struct super_block *sb, void *data, int silent)
 
 	return status;
 
-read_super_error:
-	brelse(bh);
-
-	if (status)
-		mlog_errno(status);
+out_dismount:
+	atomic_set(&osb->vol_state, VOLUME_DISABLED);
+	wake_up(&osb->osb_mount_event);
+	ocfs2_dismount_volume(sb, 1);
+	goto out;
 
-	if (osb) {
-		atomic_set(&osb->vol_state, VOLUME_DISABLED);
-		wake_up(&osb->osb_mount_event);
-		ocfs2_dismount_volume(sb, 1);
-	}
+out_debugfs:
+	debugfs_remove_recursive(osb->osb_debug_root);
+out_super:
+	ocfs2_release_system_inodes(osb);
+	kfree(osb->recovery_map);
+	ocfs2_delete_osb(osb);
+	kfree(osb);
+out:
+	mlog_errno(status);
 
 	return status;
 }
-- 
2.35.1


_______________________________________________
Ocfs2-devel mailing list
Ocfs2-devel@oss.oracle.com
https://oss.oracle.com/mailman/listinfo/ocfs2-devel
