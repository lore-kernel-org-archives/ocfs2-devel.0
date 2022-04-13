Return-Path: <bounces+ocfs2-devel=archiver.kernel.org@phx1.rp.oracleemaildelivery.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from aib29ajc253.phx1.oracleemaildelivery.com (aib29ajc253.phx1.oracleemaildelivery.com [192.29.103.253])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 29A8CC433F5
	for <ocfs2-devel@archiver.kernel.org>; Wed, 13 Apr 2022 13:47:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; s=oss-phx-1109;
 d=oss.oracle.com;
 h=Date:To:From:Subject:Message-Id:MIME-Version:Sender;
 bh=N174OW/jlhPu2G8qcM1X6TRBxCM4iQS5XSuq0YKlFGM=;
 b=fR1aTNcOpEaYjQugSgwiK4EaoeqscbvWxDHpR5XGxb3Rp6B3gdzu9tG8pp0tVHdQT339FtG/Gh4u
   fEkk7l8UiHwoq84nQU0n75Kct7KVIPVx3ZoCyTykGvA3MHss1hHY9lOBEA5W8FPE7/iFWPscHdW4
   a/3D55K70Nq2h2oOEBYKOMuYvny1JVigPFW/cEvL/+gHzUcXjfxod4q4Rnh8ERRThjUsBqEPBk4O
   ja5t90xMHFPnpw419OAXl+mZquQexpCt8Sm9bu9E3FsDVTRiFfh8/4kU5keMcaosevNjV5kjB1HY
   pM/X0Vlb/PCpC+uXHAFQciF0kPcKHiYl1yV+gg==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; s=prod-phx-20191217;
 d=phx1.rp.oracleemaildelivery.com;
 h=Date:To:From:Subject:Message-Id:MIME-Version:Sender;
 bh=N174OW/jlhPu2G8qcM1X6TRBxCM4iQS5XSuq0YKlFGM=;
 b=QbnoQCgkzC6dl9cNZGpbshVYVNd1b8D5WB5R+Q9/EogUERQaO75L76dqhtdZVWMFMt2xc5yiOQsk
   xUSzzoa9eW6cZgsOShAWUJHxHo3X9/hN3G0yVWxXqae2jHWIURlT/tdVsmnfc+FseogP22ObZXtC
   5zAgH5sVMWYDhZ47iu7edX9KsME27/VQD2iFh0HrS+5oYmgI7zA9+HHB+TXoKlg5/XstwT5laAJB
   wqljdJYUQu1COtuUVN4vRiD6XpQt54vajDAZJt27ltRFRB76VYUkUrVZ+R43goOO8U92FgYt3xvE
   TwQkaxfUxT0IY7oWS8uf8SXKDHgZ6GpTGpJLsw==
Received: by omta-ad3-fd1-302-us-phoenix-1.omtaad3.vcndpphx.oraclevcn.com
 (Oracle Communications Messaging Server 8.1.0.1.20220319 64bit (built Mar 19
 2022))
 with ESMTPS id <0RAA002BI6BJ6BF0@omta-ad3-fd1-302-us-phoenix-1.omtaad3.vcndpphx.oraclevcn.com> for
 ocfs2-devel@archiver.kernel.org; Wed, 13 Apr 2022 13:47:43 +0000 (GMT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com;
 s=mimecast20200619; t=1649838657;
 h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
 content-transfer-encoding:content-transfer-encoding:
 in-reply-to:in-reply-to:references:references;
 bh=dtyBVsqLUmvB+HY6RYqvkzXscwkDPIt8X2zwOsKTrMA=;
 b=JctDXfsV1u/G326+tOY2ytoDhksBdoVJ2ByUtZboLUHaZ5LltRCnCjOtSskN5L2QtPP7jl
 BTsqDCZX8YwuP9EKD+XhJU6ZOmHIcxHjxjILuTQ+/6ufa/rjFELv9TkI5R9W6+2GSAtcI3
 CL9UvIRlH1lXkDdgf4g+r7mM7Vkqc5w=
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=fZ7ZYVQz0YCOrzO6CgdarLnSsLnDtnnZypKMYY9E454+puJUBCAGbcTDH5SRKA65xBf+Inb8MQLv3/ZyHxJLngpmdR/JfWvYDjz1eqhLwth09Ir+1KbdEE4pjB3uTHNibAW0vAIyacFs4vNWIsVdNluL0C/zGJ/HWegccwBO6NKcV3L3wL/uuYKobgCjqkP8Abb2xR0ok+aJ+hU/7c+shUixFzKO2U39ecZCtp2jycrMN0YuW1nlBzarNEVmgvR37LKa/ZG5GyO9avpiovxjdYeBvj/qz9NbBINRtzMOFFUoJnxzWlRANShy+6B+wwHcTgPPLRxwlutoPsFtq9O0dA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=xbD7nx4BsNP95qYWULEUA9UIUpHN3fc37qs8bb2KqXY=;
 b=fzVkaDxiiMSsKS4TakfR7fympFZBl6wSWC2e6R3wNMpKu9dLrb1kYmMGKW2mvuWJVvVfRTyKvm6x6SiHNQeaRsIw/vWfwI8RY8BijHSgN2RXtonKmm2pm8vy6ClWT/xBOCtTf4lYbT7pAoZ/sxld3zueGzIDqAiJTJdGz5KwfGrm1wk8FAw6e6sgS4r02IbCLmD215aLbe9ZF3Q3ZbXSkFVHqPP5t5N+Rr1bLSrq/P9ZvFRdPJbfMu+Bh3QghffpQByuqOGZwUYfdBN5hWHxVOljNsFMeD8xeb3p5XJ53tiiUxMWG5q+VQE5a6nbxLWCmYpzlw1s3Da0DRRMh85Hzg==
ARC-Authentication-results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=suse.com; dmarc=pass action=none header.from=suse.com; dkim=pass
 header.d=suse.com; arc=none
To: ocfs2-devel@oss.oracle.com, joseph.qi@linux.alibaba.com
Date: Wed, 13 Apr 2022 16:29:57 +0800
Message-id: <20220413082957.28774-6-heming.zhao@suse.com>
X-Mailer: git-send-email 2.34.1
In-reply-to: <20220413082957.28774-1-heming.zhao@suse.com>
References: <20220413082957.28774-1-heming.zhao@suse.com>
MIME-version: 1.0
X-Forefront-Antispam-Report: CIP:255.255.255.255; CTRY:; LANG:en; SCL:1; SRV:;
 IPV:NLI; SFV:NSPM; H:DB7PR04MB4666.eurprd04.prod.outlook.com; PTR:; CAT:NONE;
 SFS:(13230001)(366004)(316002)(6486002)(38100700002)(8936002)(36756003)(508600001)(86362001)(2616005)(26005)(6512007)(1076003)(8676002)(66556008)(66476007)(4326008)(66946007)(83380400001)(107886003)(2906002)(186003)(6506007)(5660300002)(44832011); DIR:OUT;
 SFP:1101;
X-OriginatorOrg: suse.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 Apr 2022 08:30:55.6163 (UTC)
X-Source-IP: 194.104.111.102
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10315
 signatures=695566
X-Proofpoint-Spam-Details: rule=tap_notspam policy=tap score=0 malwarescore=0
 bulkscore=0 phishscore=0 suspectscore=0 impostorscore=0 clxscore=179
 lowpriorityscore=0 priorityscore=202 mlxlogscore=999 mlxscore=0 spamscore=0
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2202240000 definitions=main-2204130048
Subject: [Ocfs2-devel] [PATCH v2 5/5] ocfs2: rewrite error handling of
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
X-MC-Unique: 8UE4GuUOMterniroPn-BgQ-1
X-ClientProxiedBy: TYAPR01CA0093.jpnprd01.prod.outlook.com
 (2603:1096:404:2c::33) To DB7PR04MB4666.eurprd04.prod.outlook.com
 (2603:10a6:5:2b::14)
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 8d895cce-276b-4d95-4997-08da1d27edb3
X-MS-TrafficTypeDiagnostic: AM9PR04MB8100:EE_
X-Microsoft-Antispam-PRVS:
 <AM9PR04MB81009EE6675353B4CEF7188F97EC9@AM9PR04MB8100.eurprd04.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
 IEzCT9btjjgbQTiSJ15NZ1lNzAvUEmOL/2hYdpWzEZmfhDIGsmAkMR7ULOQd86UlP+Figc47YxQIrIPAMNE1NawVPXaUGYnKDhUwsGjHjcW8FOaZ7w63FjasPd7/9XBHZOYLxQgyi/lli4np375Dh7QUHG+2yi/cRLsfy9bhwMdQ/gb5RWH6rbbuOlrA7kZNtnoT3dej+dFjdsg0TwvLdYcAsiPlfBw7FxuWXVw7WnA/06AvJ911m1/emoRxko0GrzszxQXh8XRRU0gNfEJoe3pjt0UOWZk+p+5zna4SnUX94Wsab75ienN6rljFfmpfXpMc2RFQMxJyWpA3acrJzjLkn/CyykbZNByiqz8a1QHyaynxbd1WGtzHpvfBxpVDeczxweC/ZadjVh1SiP1hxT4nRPu6m+40AOUUzCZe4ZEUVb9Px4ss8UF/k2D/YiatGqy3ZuxIkLkmv5SBHUaTNo3qyzWJ08jTzj4wxukD8FejLN27A2Ol+ShsOxq5Ht+LX3tiAF6WObHI5PXYbatU2DRUyAK6M3neP9M/Q5YwD93jdEIcOKzHYiSKkc0q5YOrn9K6LhY8rnkF0wLRSBD+QV/4ADNJ/XJCrZnvh9LUts38ZgBhqR08jqf7FDnN1E/WYsec2fZNXGcFQIdPiDymJw==
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
 =?us-ascii?Q?g0RwWGIj3QmW/54tzF/Y3H9LLlieU6LpCvJZwgnB0/OHkQQ7QAFyT0uT/8Rk?=
 =?us-ascii?Q?+AELonhlLnRi/BYMSAVuPFjnBFEYS1qkI1esFv/wCJrrf46tqSX8p68Svsic?=
 =?us-ascii?Q?PoG8FQtandAvHZT668N175Cd6Kyz5tphYNL4HMo1+Y/Z3oA2vGPTDcyxOUKZ?=
 =?us-ascii?Q?oIVoOq1z4q+fifmMhaKTFiqAd7NkD0kzgWabaVQWOGYc1PsljSt4h4DY2skx?=
 =?us-ascii?Q?aPU/CrvOX/CswDKvh2f4bcGMINJ1prkq+4hnriyxOrXZ6ZutgvQhsnCB3HL/?=
 =?us-ascii?Q?bo0cZJ+iwjt89sn+qHwz+tgMUpdSCx9DCrMpvo5DsnivmBLHMv7aU6rUqwn+?=
 =?us-ascii?Q?pRCG2K7QeLRhb1s0iYdCzt+bEIGLtK8pbypcsOWY+znErlqETQ6H2X+KctAl?=
 =?us-ascii?Q?35qlCJGog8PE4IP7iz4dM9B3qHZlmmjSYDQmKKhION6LIK1XJ50CLloCGTzH?=
 =?us-ascii?Q?04QnAzJWnuTz3A1EUZbgvpM1UhRpqmz4jmql58bqIdVRRpS82J5HwMlTuRJu?=
 =?us-ascii?Q?aJ5tooIA0N280zQBWJrTHpJEr+1VE5YTnVTzR9wFxHTtAVYBAtt9xl0Gwigz?=
 =?us-ascii?Q?GCCCKe0tWOpxZdkGs30Rd5iDsIpMnEjCAdyXTuM3GPCFwVDcko6+ied4PbI/?=
 =?us-ascii?Q?bKlASzsp9SSumay1Ej2mDynoJ3GEAVJPHAguKaNOdgDKTC0/SlKD3QXLRM1Z?=
 =?us-ascii?Q?cZTWgq/Mp8Dk86FV0GeTAFYekMPZ9LXslKP4wdcRHiFo9usUYU7Cos4s3lMk?=
 =?us-ascii?Q?vWDW9liMpETE0H/WST3uey0TNn+dTupcpZdag4UDn/RtstZ6DlWmuRhcpGDn?=
 =?us-ascii?Q?xco16cxTnPpLfDHCm2zIzPdjMVHCUjn8CeXBOsXKV+aElWgaibHvHP7HPYE5?=
 =?us-ascii?Q?8G7nu8i2m0b8PZrszkN4R+7GboUkPUVE0iGk+LYYXRwguBxfnWKMZRiJwTo+?=
 =?us-ascii?Q?X5EyoXQy1u2A2vUQK2q5u6ulrllIYqH8RalMafxV745MrqYE0riDHax7e+Nb?=
 =?us-ascii?Q?mmitwwpiVcbEgckvqPFZOQq2Z/DN2bXJqrrP5juBZzqW5ZBsCwB79BUx9TQU?=
 =?us-ascii?Q?kguISXcOC7Wv9+j0VRpnyBp6C+2/gRudcYHKNa4Fxu7IwmhEqH3MsSKFfTfG?=
 =?us-ascii?Q?LpzbZ+tX3IttUUBdUMO6O9/hn2QbQbXWEBfWVvRXH6iGb0Jrne69cOzOueb2?=
 =?us-ascii?Q?ufwFbzwny28XjAYdW7+4THmqLMcRhVOKHFsSnsSMtZ72nU1FjXwWm0YfpWUC?=
 =?us-ascii?Q?HwrEmq+UeTDIZh/Efh4Bqs9+LQ5nwZZjN+FdJhSH1vIu8vm1lnXQ/E0Uq9Ow?=
 =?us-ascii?Q?/lDMvSLDo/S8RjymijMgvNSxY3tCkCfLS3LIb6b0GXg7qqUj9LrvFow5W9lg?=
 =?us-ascii?Q?LpuOkYoDcc+dzZkdEkh3+NrMxCG4Gu9xMwGwdp7+XzwX+OuAQzRfjLZWeyu1?=
 =?us-ascii?Q?Vpp6ePSguPH25NR7Bv+r32/SDeIr6v/L4q2XUGh430ib9iaOmyalGcCb+2oV?=
 =?us-ascii?Q?uv0ZdcNYmxbD3vcwet+VcqF8niPfHrAvZRyyoI0jfkqIeqBuR+tfDry/yxJl?=
 =?us-ascii?Q?paFo1sSMYh6AaZ/XGEGwmX6yuVntVkT9cD70hI+brRv0nwDH4db9DJFggU8Y?=
 =?us-ascii?Q?8OGDiFNkBnavt58LKzREuI9W0J5mzAOE22XhGWYtbY83pNWPOzZhb5qWX3ty?=
 =?us-ascii?Q?eM/NP87TSWQYJlmQlDAzJau4CNKG390oydVY0X82u9mv2bue1UIAjlrzGyAQ?=
 =?us-ascii?Q?ZZYq/GDguNVHEGnX9kupnEM+ieJKyQ8=3D?=
X-MS-Exchange-CrossTenant-Network-Message-Id:
 8d895cce-276b-4d95-4997-08da1d27edb3
X-MS-Exchange-CrossTenant-AuthSource: DB7PR04MB4666.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: f7a17af6-1c5c-4a36-aa8b-f5be247aa4ba
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName:
 AYLFVpPtR+TXKLhqY21WwpLeWGFvQRZOvw+y/hNAq9C+9PewoyvUv1xYnVKU726e8sVgEJcm1GxltN/hRBt0YQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM9PR04MB8100
X-ServerName: de-smtp-delivery-102.mimecast.com
X-Proofpoint-SPF-Result: pass
X-Proofpoint-SPF-Record: v=spf1 include:spf.suse.com
 include:de._netblocks.mimecast.com include:amazonses.com
 include:spf.protection.outlook.com include:_spf.qemailserver.com
 include:_spf.salesforce.com -all
X-Spam: Clean
X-Proofpoint-GUID: Q52YEOvzbay2fS6OJ26uxdXjRzSmQBj3
X-Proofpoint-ORIG-GUID: Q52YEOvzbay2fS6OJ26uxdXjRzSmQBj3
Reporting-Meta:
 AAEQ+Mx9NJMmmrb89ZnCLUZ7Pw9cHViJpkhtZmzit76jhAJylKQxqtXK/ZRXbiWF
 gyk6FK/P3ZTFzbAk+lhOBZjrdMPVD6YNarYgNAriMZDvOisI6a6sTznlacDuwgaA
 Wr1ljuMna8TbmXTB7xth9VhVWkqmH1stUB6XKHNspVeaiTztUNfevQp1v9J3LKe0
 syyJnej3b5Olb8zEe3Lj+MupZaWxHhNV1FWyOHivNA7qZZAckTrGLPT/SKswtSjz
 dXsOXkBD4AqUtsVuaqbu9+U8+A9h/kTc46k+EpTt6wXVieWf5SJMs5RyIu7T4PAC
 egQB6aNnn0AgDi4g5J8jnU4Fop6ARqRkAma/X5Sj/yNk8ohYBKVSCGFMgCss4/SW
 OydJ9oztexfgHDBE4NfmsASJxPePRElxgnEoIX8UyB86gflz5Rd3D1nnSKeSF9T8
 c04q4XQUnxmw3hI4VN2Vz3l8cqEJejG0brqOtBkVJZVWP4tgXlebUo6TgPXOmcoj
 k+RXDeu/Xd1ldFvJLUI38JOEurtUKANhI/OAc4RVp1aM

Current ocfs2_fill_super() uses one goto label "read_super_error" to
handle all error cases. And with previous serial patches, the error
handling should fork more branches to handle different error cases.
This patch rewrite the error handling of ocfs2_fill_super.

Signed-off-by: Heming Zhao <heming.zhao@suse.com>
---
 fs/ocfs2/super.c | 67 +++++++++++++++++++++++-------------------------
 1 file changed, 32 insertions(+), 35 deletions(-)

diff --git a/fs/ocfs2/super.c b/fs/ocfs2/super.c
index 5e860d7162d7..72673d40d29c 100644
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
