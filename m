Return-Path: <bounces+ocfs2-devel=archiver.kernel.org@phx1.rp.oracleemaildelivery.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from aib29ajc250.phx1.oracleemaildelivery.com (aib29ajc250.phx1.oracleemaildelivery.com [192.29.103.250])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4806DC76195
	for <ocfs2-devel@archiver.kernel.org>; Wed, 22 Mar 2023 17:03:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; s=oss-phx-1109;
 d=oss.oracle.com;
 h=Date:To:From:Subject:Message-Id:MIME-Version:Sender;
 bh=l0kr8EYvtyH8jmZRKtW3fObNFgPQLBKdceya98vSAFU=;
 b=EbCMIh5uB5Vqcs+vo4dRVUFfGBf40gccynr+J+m8fO7r2Z3KifQVZYxA2EDAHajL2d9EODwT4jeI
   WS4ZId3vzxwXDMHJKya4fi4tfYB91vyuJyc9eJtOjdC4QY728jiZ4DctX4cmPoCzVSm1+rF3knOO
   dI/WQdm77igemtKvrMAki0B8FVlBACA9G1k6sQ/hC4Ju5R0A/FxqItg1yFRifl/EeKYaUdLu9To8
   a2C6orZPDET4Rfhrg1DYXwhwcrKbXQxbxo19QXHE9s3NTAAylalRQhS9IfHzx2rbccHObFTUdkVw
   f4qwAuezf+E56uLKtVVE/vHM5bYco36KhnBq+Q==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; s=prod-phx-20191217;
 d=phx1.rp.oracleemaildelivery.com;
 h=Date:To:From:Subject:Message-Id:MIME-Version:Sender;
 bh=l0kr8EYvtyH8jmZRKtW3fObNFgPQLBKdceya98vSAFU=;
 b=nAU59EhoO7kupSwm+O5H+fWmn8BVyyxc49yWri/DkN6SfGT6T43NnuwMwEAYUJEnqPrp4dfU9ek8
   YUEZi+eSX497BlzIPg7/hC4lpsMlthZ7IDPCJzZ+/zELOVdGKQRmLraDcqAFXC3dT4rQMHlA2pNf
   sMaBYDrULZXV9oD3kAQOqdbINwrCnNvMU+MQTKA0aRnov85fUySuM2NREI1N1kssJ4VjRLA1mqMe
   5NI3GlLKCXNrbloGVj690NtuRlLFQRCygqrxGdGdG5iuurkpnq8K8NK8MISyrgr4BL5O48xcrlYy
   hYXddKC2kgqOrHfA7L6oL7KceDPPXi6qu6/Ydg==
Received: by omta-ad2-fd3-201-us-phoenix-1.omtaad2.vcndpphx.oraclevcn.com
 (Oracle Communications Messaging Server 8.1.0.1.20230214 64bit (built Feb 14
 2023))
 with ESMTPS id <0RRX00GGJM1E8MB0@omta-ad2-fd3-201-us-phoenix-1.omtaad2.vcndpphx.oraclevcn.com> for
 ocfs2-devel@archiver.kernel.org; Wed, 22 Mar 2023 17:03:14 +0000 (GMT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=AavFzUp+nIqkZvNuKbj2r6MjLa46RzHA2TsqnR+1XqyUABHqMmaZjcTM1Sveo50e3DkeZHmNcoRYA1M8dY0/fJH+1TNfbw3drh0rIAs1Z3LB3HGSrX6rlRELuqY2xqgx2HBLOwKa7eDLssxAkq4sxw2tMMeDW1YGEbZ6DBPFsjgZTLFaOw6OPevIkFVbjg0xONkpFPyvxR7CJhF0qs8Gri9BhvpcUUCOpXm8KNn6qVeWGB28RarBW8wzGwM07TCcgIrCaEjVigAQRhqyep3MqYo03PwH5WX32Li/zciwN24ac2jHSK4g54Y8vyqvVWtZRR35dKoJFTpUo6SB0JKu4Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Jf0NXmPR/A6QkRkcChnZxvlRXMYJdAJ8WDWuNw+JSCc=;
 b=ASp3j4xCnVKn6rlJmeIHszVQ0MN43voN58DsaVhNNn+lHCG96xdvXnMjIwsSxEGAGiihWkCilBZZNcODkG6hBNg3cONeuHWpaDOgTwYE2HY8s8A9QsU2OQFdYVa/kJEakRZn/Yx0QSyEb5kufk6Tkf5nuMSUwv/3YUrYc7CIf7Ynyv86mmxRXcgvTBRBbHc2lHCqxDj8cIRTYhRhrpLHk+2Ykjs1pyvJuJzhAGbG9RmWLe4YJTbw7yaLK3sKmp7V0Ls2aTn9rwqoU6EqFsFhMF4ZcWAyP+2orLvqInQou1Hep5z6A+DD0LWby6+zhaZGWVM6i/qAZacTZvxzgjbD6g==
ARC-Authentication-results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=vivo.com; dmarc=pass action=none header.from=vivo.com; dkim=pass
 header.d=vivo.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=vivo.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Jf0NXmPR/A6QkRkcChnZxvlRXMYJdAJ8WDWuNw+JSCc=;
 b=Ui1Fd0lIj8aTyHTIyyEEwsj/07yvxB5AZTwpOcNERLpqaaV4vCga/k+KdNoko+HW5/KhrD0lC0gz63DySKzKLVJqH8hosqN6G25PNhYDbpWNLuadpdOMbEVNsiiAmc5XHs88+53iGeUmfXx3AGPiJjnWSSD+SRjlAy7T6l6v+zT4+eZu8l5bmstmg1jStHwm3hXVditPeQJDHYhxNY+1f3vm8JTo1RXeY2Fp20AyYJtlpHTVYeMgnFAvU2AJq1D/VbqLYPS+AvgXC4h3iL6US6nGzZV/rHR0UKLuZf0pow58Prkx9U1cC4x40WXb1fsMAlOicBQ9lHgXMwq91sbRrQ==
To: xiang@kernel.org, chao@kernel.org, huyue2@coolpad.com,
 jefflexu@linux.alibaba.com, tytso@mit.edu, adilger.kernel@dilger.ca,
 rpeterso@redhat.com, agruenba@redhat.com, mark@fasheh.com, jlbec@evilplan.org,
 joseph.qi@linux.alibaba.com, viro@zeniv.linux.org.uk, brauner@kernel.org
Date: Fri, 10 Mar 2023 13:48:28 +0800
Message-id: <20230310054829.4241-4-frank.li@vivo.com>
X-Mailer: git-send-email 2.35.1
In-reply-to: <20230310054829.4241-1-frank.li@vivo.com>
References: <20230310054829.4241-1-frank.li@vivo.com>
MIME-version: 1.0
X-Forefront-Antispam-Report: CIP:255.255.255.255; CTRY:; LANG:en; SCL:1; SRV:;
 IPV:NLI; SFV:NSPM; H:SEZPR06MB5269.apcprd06.prod.outlook.com; PTR:; CAT:NONE;
 SFS:(13230025)(4636009)(346002)(376002)(39850400004)(136003)(396003)(366004)(451199018)(52116002)(6486002)(1076003)(26005)(6506007)(6666004)(6512007)(107886003)(186003)(41300700001)(66946007)(66476007)(66556008)(4326008)(8676002)(7416002)(8936002)(5660300002)(86362001)(2906002)(36756003)(316002)(478600001)(921005)(83380400001)(38100700002)(38350700002)(2616005); DIR:OUT;
 SFP:1102;
X-OriginatorOrg: vivo.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Mar 2023 05:49:17.1994 (UTC)
X-Source-IP: 40.107.117.106
X-Proofpoint-Virus-Version: vendor=nai engine=6500 definitions=10644
 signatures=596816
X-Proofpoint-Spam-Details: rule=tap_notspam policy=tap score=0 priorityscore=90
 spamscore=0 malwarescore=0 adultscore=0 mlxscore=0 impostorscore=0
 phishscore=0 mlxlogscore=804 lowpriorityscore=0 clxscore=96 bulkscore=0
 suspectscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2212070000 definitions=main-2303100045 domainage_hfrom=9103
Cc: Yangtao Li <frank.li@vivo.com>, linux-kernel@vger.kernel.org,
 cluster-devel@redhat.com, linux-fsdevel@vger.kernel.org,
 linux-ext4@vger.kernel.org, linux-erofs@lists.ozlabs.org,
 ocfs2-devel@oss.oracle.com
Subject: [Ocfs2-devel] [PATCH v4 4/5] ocfs2: convert to use i_blockmask()
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
From: Yangtao Li via Ocfs2-devel <ocfs2-devel@oss.oracle.com>
Reply-to: Yangtao Li <frank.li@vivo.com>
Content-type: text/plain; charset="us-ascii"
Content-transfer-encoding: 7bit
Errors-to: ocfs2-devel-bounces@oss.oracle.com
X-ClientProxiedBy: SI2PR04CA0006.apcprd04.prod.outlook.com
 (2603:1096:4:197::13) To SEZPR06MB5269.apcprd06.prod.outlook.com
 (2603:1096:101:78::6)
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SEZPR06MB5269:EE_|TYZPR06MB6023:EE_
X-MS-Office365-Filtering-Correlation-Id: 711f6969-e97f-406d-ad7b-08db212b2fa8
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
 xqbFJAQdmbHdWPhF3vfFZyWdBFBAKXTfjT6gH4vIZr6t5PQH0TpVRMOSbJcEbHGABSmslD5ZBlO2LAhbBLVhuCAoW6fLBWNpL6oaaPd3bN4bbS8RsEsKyMgfIv3M9ZcNKQsOSEfUoLNoumwXpjatuT8Lrs50Sv0fEEkV1yQdMKTWiHc/bLTlmIbPMxVKa59ujtN85GutND5MWCQEOT4SsFvvFfei2eKkY6nwpwMMIx1LtlXRAu1yDLGcqouDO6MRZmRtJysVbP1dEzmjUED61nSnbs8bWK0zgMMm8Cmk78T6UMq/G0ckBsZpUVZKwUir2oLRSfDGIF732g8ad0SmocNJ1Tv8MOHuc1zxq2WtN/zv68wLFaf3xQPlR1xw77VU95ds2sYh9aQzqKE9kvo3Kinqg/dohrf/LEOi42ge1NFox/WlqrXA6keAZi/AvrYgOWODFlzwcFMzXr7DWkGiOOojPpY2AdA9qJlYc4mJgSG7W/9H8tlHKzqbLu7hZm7V2hFgzjH6zWIsZXvwN2hlMCkRZ5m05hhg+SRDaVsBXW48NAlveyOWcuk5TB4PebP6Rif22m+G+IuqMGdOVacnCTX+L9nHZQsi8GJU5aUlI6M0s14gPzlcAP5Ul97L5s8K8jGZYFbjU6HnWy3V5N19Tb7Ey6e2Gfepj7J6IPGP5eDXUg9BUB1Lrd0mkPExX5yP4uvmDTV7XgQZBynR/CZ3qWT/Qs52LxxW5moWuuuJFJ4=
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
 =?us-ascii?Q?dmrTeRSbA5k/Xj/W5NeL1fjGQXm8oyg0+YcTsyotISkdrDHOAB0w0Gf8TQtn?=
 =?us-ascii?Q?+lMy1upUl/8depZTc8mrABlrtVIRUxez9JJvGZIWu0GQF+k7VYkJ4xlWURce?=
 =?us-ascii?Q?eOCJovN2Cs6ybWwp+WrpiwbQS+U+01Xyc7XMAdNq2zhNEzmRJHQ63AKV+X+c?=
 =?us-ascii?Q?H2mE+IjRnEOEVe82AoGls5H3jmU25/5e/IH7AL94rOhHv7fITGYE00UKT4Gd?=
 =?us-ascii?Q?7RKE0TYEwG4eQVNMANQFlIWgft8zLrzvOhCs8Xm7fCZftYWlPp5rdjZ7eRNx?=
 =?us-ascii?Q?yOEFwGQotteNGWKfOOiahf9lRZA/T5bX5H7cpCOeGRicTpGuUqGoE/jcv9A/?=
 =?us-ascii?Q?7vIQ6qMy7W9k3XH8WRw3Xi+XXmOUEJh+vr1/d9sjOyy8mc9nKs9AcXFypv8x?=
 =?us-ascii?Q?PDuTPHPK2RqZeqG7D83254IUNVZIfufoFDX63pQXGAj1vNo2g0P4HbMXQzEr?=
 =?us-ascii?Q?MfKDXFaIxUsl0htGHDhns1j4WWw37dCfLbP8kgdPaDTKnNnk36lSdutX1FZy?=
 =?us-ascii?Q?ec60TZgw/GDxXVlLg5pm5GNbWwq82YLy428S/RzX0AlpelWWpUnrKROg90s3?=
 =?us-ascii?Q?fLR1ACXl64SWyeq0BWmgu3eZzifwaY4r8rwcdCEgw5fg8pTxw0vMrNNAZn5Q?=
 =?us-ascii?Q?eD0r66rK784Djne3tyeZ45IwhWPsnXnpB8a/pBje7Yd7xq84t6mDfy8Bfeu1?=
 =?us-ascii?Q?4FY4OyB4MvSMW26wttS5EEdS10i4zPcv4Vl3wJ1x0v4mRpdObvaoWRtCGD/E?=
 =?us-ascii?Q?L+m0vOZFtBHS3AQTE8CwNy9bxSvBTgO26hs0a+otIR577lxMl4IfGW8K79FC?=
 =?us-ascii?Q?67UliUF/nKi20mvR6RVXbfSYz5Ctd36h12hUidyH/Lvlx/vyoNymKvs+Hypm?=
 =?us-ascii?Q?PPQN5g3qnPHc/uDBWg69XcXfWBULY7YVXVulRddT1Lwm+SxL2VHKpFea7/YG?=
 =?us-ascii?Q?3wcgb1aw+JfuiW0o8Qv1+J45JF0sJxc++X0x28VBgu0PiN5/C4oKP/CUgzKU?=
 =?us-ascii?Q?TEZVF7i6/6IoAxpMpnoCIOxMYUrbwtf2bmtMe462YFe2HC/4x1xvMbSx2ka4?=
 =?us-ascii?Q?xPeVFpbxV8wGJIYX65A2VVPVtATxnAacHPpsU93FvzS91qx/3axkecvmSLZi?=
 =?us-ascii?Q?Y4xFbNFDcy1u5Ww2jeWnIUH21CG8m7FN8sb4MgX7y/wMpQjfkmcgtvQPxpZ7?=
 =?us-ascii?Q?9bufpzPMR0ib/1k2ec7vxXAzr8C3siPtRrUFwIu+UN+de9xAwnPIMTAHrxwK?=
 =?us-ascii?Q?Sw3Xknnyr2v8SSZKUz/5hRGN3xuFkjXm1uAn+qxoOQ4LBoz2a6KjUIoXjEBT?=
 =?us-ascii?Q?vlQhQuhhn8f3/V7GoP4XNz3YWZHc2dsSVoc6SF+vVoODEZFpCFtQWwkR3yW4?=
 =?us-ascii?Q?VWPN2DXkcTXZv2tuxdPbXlpbRmAlmUjf9eAnGNlTNmcFBtKvYyduMFMwMjkH?=
 =?us-ascii?Q?TMcAfbY54mngO0kecn3Gr7HaJhM6AJ25T/zg6hmYz48MMyIKe/meEfm313Wu?=
 =?us-ascii?Q?7pG33krISktsQ4QLN3379CbeJb+NLzyiHrdjgWTwGZ3eNaRThDPdmcne1rQI?=
 =?us-ascii?Q?PxKz2AOkdbmIMUdv8FnXPziIIdAMyr8/oS1+YwOh?=
X-MS-Exchange-CrossTenant-Network-Message-Id:
 711f6969-e97f-406d-ad7b-08db212b2fa8
X-MS-Exchange-CrossTenant-AuthSource: SEZPR06MB5269.apcprd06.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 923e42dc-48d5-4cbe-b582-1a797a6412ed
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName:
 2MhJP/TVakp22HmT7xiQqB8u3NGWSEmzp61q3tg3wd+upwIzOd45eoqYpNGisZd1RLmmBp1M6djG3cH5tmUCyw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: TYZPR06MB6023
X-ServerName: mail-tyzapc01on2106.outbound.protection.outlook.com
X-Proofpoint-SPF-Result: pass
X-Proofpoint-SPF-Record: v=spf1 include:spf.protection.outlook.com -all
X-Spam: Clean
X-Proofpoint-ORIG-GUID: smA_VbTfN_eYxCDua-IpuB5o49HRZCVs
X-Proofpoint-GUID: smA_VbTfN_eYxCDua-IpuB5o49HRZCVs
X-Mailman-Approved-At: Wed, 22 Mar 2023 17:03:04 +0000
Reporting-Meta:
 AAEg8qBlNj+L5mMy/qwJPphGyOQZS3Rt9hEQkQ017GVmYvJLlozei99BpNbU6GjQ
 wLMcYOviJz4OEJCQ0sjG9HxigdlcBvjlxQfJAvC6S3XXzX7IfXDnLZOl1dWfPSTT
 MwQw23bVHoSjPq/RbDgaLZodOmi+HdwhiLKXOLzQuJ1SpVvTra7vIz+swp8CFHi2
 I2sC0vo6SZVNsB3DUsqo6kuG3AVTy+XwuUu50bDpE+/Cq0zaKbUZhh94d0h7EhFM
 IdADG7SKgXweigpzS7LWwzrCcS50H+ficnj1ivYbgOAjRDFtjqdfNKijsCUHHiQp
 fd414XIljAw9zZk8LeER/uLyvKhDLWEZwwsSu9q1pFkoxtBzjcqb4CmTtWHWRBEz
 D7r1IrJxbRJJ7t+huXIXwfQbjXvocmI3F+tzpoC83G8EFZqJKdgHdAoDkenZoJX4
 NJ8Zx8tE1bIGpSVh9L3tmMrNg1IeFYqMdAl+inLEp5eEeeIzok41ipi+4gELVTkQ
 FlQmgBLx60wCsAexDz6A0ps30qSNeIoUEfWxABtLNQg8

Use i_blockmask() to simplify code. BTW convert ocfs2_is_io_unaligned
to return bool type and the fact that the value will be the same
(i.e. that ->i_blkbits is never changed by ocfs2).

Signed-off-by: Yangtao Li <frank.li@vivo.com>
---
 fs/ocfs2/file.c | 9 ++-------
 1 file changed, 2 insertions(+), 7 deletions(-)

diff --git a/fs/ocfs2/file.c b/fs/ocfs2/file.c
index efb09de4343d..7fd06a4d27d4 100644
--- a/fs/ocfs2/file.c
+++ b/fs/ocfs2/file.c
@@ -2159,14 +2159,9 @@ int ocfs2_check_range_for_refcount(struct inode *inode, loff_t pos,
 	return ret;
 }
 
-static int ocfs2_is_io_unaligned(struct inode *inode, size_t count, loff_t pos)
+static bool ocfs2_is_io_unaligned(struct inode *inode, size_t count, loff_t pos)
 {
-	int blockmask = inode->i_sb->s_blocksize - 1;
-	loff_t final_size = pos + count;
-
-	if ((pos & blockmask) || (final_size & blockmask))
-		return 1;
-	return 0;
+	return ((pos | count) & i_blockmask(inode)) != 0;
 }
 
 static int ocfs2_inode_lock_for_extent_tree(struct inode *inode,
-- 
2.25.1


_______________________________________________
Ocfs2-devel mailing list
Ocfs2-devel@oss.oracle.com
https://oss.oracle.com/mailman/listinfo/ocfs2-devel
