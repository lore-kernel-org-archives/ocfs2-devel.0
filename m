Return-Path: <bounces+ocfs2-devel=archiver.kernel.org@phx1.rp.oracleemaildelivery.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from aib29ajc246.phx1.oracleemaildelivery.com (aib29ajc246.phx1.oracleemaildelivery.com [192.29.103.246])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A7FE9C636CC
	for <ocfs2-devel@archiver.kernel.org>; Fri, 17 Feb 2023 01:20:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; s=oss-phx-1109;
 d=oss.oracle.com;
 h=Date:To:From:Subject:Message-Id:MIME-Version:Sender;
 bh=LwXxUHJRn0op3x35/wyGIw2MzXMjZNSim8jxSgg3fWg=;
 b=pasI9NcRELcj244uAzFq57RdKfiYbuaXCzO6wbVM/23UoPJrvkZ9mHwxrtS3zcEMwtLGYOjV05Cx
   BrwlECrfZ8OZdlDTX74hLXFAU/TBG2USvURABRlNGrUgDT4hXVML5dVRLfzk069fyTIRgsgNBe0O
   i1CymzpU08ifx0wmLmhJM/vq3gcRNrZkYHkDeXnbPmV/WdRp+rdr1yMInhXYTxEBtu+Vxc6LNwkd
   rgBt74ePh0FC+7M5N2TozAvX7YRDWcu54ZLj2/gh9+koGhIDB3gg5SRIo8kJR4UcW9GTFx1StO9b
   qoqizFXJkmIwyKqxIbUYf4nPskWOtboWVxcx6w==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; s=prod-phx-20191217;
 d=phx1.rp.oracleemaildelivery.com;
 h=Date:To:From:Subject:Message-Id:MIME-Version:Sender;
 bh=LwXxUHJRn0op3x35/wyGIw2MzXMjZNSim8jxSgg3fWg=;
 b=UsdeeXxymQRY5isLXRVxAaefJ23Dputql8Sjejx3ZN5OD1ltrCvIs7EoEkDlMS3psa498J7A1qIM
   3vFoKoDYervhLpb06R6lw05zIkD6pMiNyTZQyy5/bBSnUnGNi9Zuklo59sm+9KJC/ycQ9FPaj5xw
   B/SwxG+FHRGfjp/P5gDk6/xM7VPZWVYmDQ2aCJ/Ni1BZX0NwjHnjUEoIySNPlQFo0TOzS8yYpRbV
   AHOHCKctFTTjt84J+7quROR92oPDjGU8DGX59lsflGxrMlM172ssxcLecVpLsnemugnXkGz2j8pU
   OFr5al80UIEHmJyLaEPyYztAQbbHzr6HTJMY/w==
Received: by omta-ad1-fd3-101-us-phoenix-1.omtaad1.vcndpphx.oraclevcn.com
 (Oracle Communications Messaging Server 8.1.0.1.20230206 64bit (built Feb  6
 2023))
 with ESMTPS id <0RQ700BMIAE2OFB0@omta-ad1-fd3-101-us-phoenix-1.omtaad1.vcndpphx.oraclevcn.com> for
 ocfs2-devel@archiver.kernel.org; Fri, 17 Feb 2023 01:20:26 +0000 (GMT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=dD+miXHjqIGQBTAzkhxkQfIZFgc3WOqo8w/Qx5iwx6fBFRWrI4cd/mKwhLGspucLTQyXK51hW1Z8I2l9Fb2HiNtD80a39qHduWeQDMeDA71Zsw2Sm3ZGWEIPKdjZ6aGqpbjaj93UZmE/txNUmxYs7q0vHTuLTmHn53/fyWTqy3/o4Gu4W0iKRkpb0DL8IH8NZif9KQrnfAnbs+NgBYFMfC1Zj4xTZ5nH1CsfS57xVILM7kVW+GJxklnNsKtSFRK4heiriP3Jq3ZxNdoO7ShPE07wBR27jrQG+qeKdnbz4mKCErDyuLNBQLdkOrklExmhVdjgNk1ichQcEV7BKXx2sQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=9GosDUVIv6cNwdz635RsfobGA5uZLG4Wxe0JVL4XQzU=;
 b=mzNICXUZF9gV/szvcszJ1RN+ARLYStQ0xfnRLdp5OZA9dpzvlBLJGuGMeNdr4HFZLUL2v0sufv7g5UxtBShcxdUFkBTpJLoOu3VUoDS1Uk9fs+BLLUS6HpkyQLV5tUX4hu4+SOuiuNz2889fjL00/Ta6ekPzKzfWl4hfk3fD2dom/ZOTe1Q569QtpYChuzIYeUVqEbP2aHjyZ5SeU3LE1HejOrSA72JN3XVwL4wzMM7e7/M/csByVpjt2G3bzdttdKdWsrw70vL5zYnVHi5zTR/Yd/iG23NnsFfX/gxP3U7jYMaWbzGC4r0dLh5+W/pO96eHCJhwXtp2j2//+CZlmQ==
ARC-Authentication-results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=suse.com; dmarc=pass action=none header.from=suse.com; dkim=pass
 header.d=suse.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=9GosDUVIv6cNwdz635RsfobGA5uZLG4Wxe0JVL4XQzU=;
 b=dMhHbdwGgkMxKBMGZunkreLfzjZKkkTm7qi1qaphf0i/FbW4S9PonbPwM5TjeA+oZBZtFTutBsWk9JQZOcYwaekkZIotjXL2jUrINI1ikR5l61rr3Kc8rDw3ns7nXTAfuZ+1LLBQG4DtgCoabPjoV7TAnXi1iiM5X337CVUh2+QXgcvksuY/FQ9HCYOH2NC3W8ARifQtjP0NjZLnXql6kDolKOKRGlTWsQpRijqDoEXr95sBXn6O/ljNmQ3xdbtl+UzR8d/zx4z6Ff8M2S2sjtrH8Yrp1WFccrW8ffXOsMSw0qESqw9x8SO9dFSgqB1NcFZtxXn2+bb/95yjWba17w==
To: joseph.qi@linux.alibaba.com, ocfs2-devel@oss.oracle.com
Date: Fri, 17 Feb 2023 09:20:00 +0800
Message-id: <20230217012000.5774-1-heming.zhao@suse.com>
X-Mailer: git-send-email 2.26.2
MIME-version: 1.0
X-Forefront-Antispam-Report: CIP:255.255.255.255; CTRY:; LANG:en; SCL:1; SRV:;
 IPV:NLI; SFV:NSPM; H:PA4PR04MB7997.eurprd04.prod.outlook.com; PTR:; CAT:NONE;
 SFS:(13230025)(346002)(136003)(39860400002)(376002)(366004)(396003)(451199018)(2906002)(44832011)(36756003)(83380400001)(2616005)(86362001)(38100700002)(66946007)(8676002)(66556008)(316002)(66476007)(8936002)(5660300002)(41300700001)(4326008)(1076003)(6512007)(6506007)(107886003)(6666004)(26005)(186003)(478600001)(6486002); DIR:OUT;
 SFP:1101;
X-OriginatorOrg: suse.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 Feb 2023 01:20:08.4151 (UTC)
X-Source-IP: 40.107.21.69
X-Proofpoint-Virus-Version: vendor=nai engine=6500 definitions=10623
 signatures=596816
X-Proofpoint-Spam-Details: rule=tap_notspam policy=tap score=0 adultscore=0
 clxscore=179 impostorscore=0 suspectscore=0 phishscore=0 spamscore=0
 malwarescore=0 lowpriorityscore=0 priorityscore=141 mlxscore=0 mlxlogscore=763
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2212070000 definitions=main-2302170009
Subject: [Ocfs2-devel] [PATCH] ocfs2: fix non-auto defrag path not working	issue
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
X-ClientProxiedBy: SG2PR02CA0060.apcprd02.prod.outlook.com (2603:1096:4:54::24)
 To PA4PR04MB7997.eurprd04.prod.outlook.com (2603:10a6:102:c9::6)
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PA4PR04MB7997:EE_|DB9PR04MB9307:EE_
X-MS-Office365-Filtering-Correlation-Id: 7f193405-c31e-4c5c-0878-08db10851b88
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
 qfFJIkYHzR7/sEE6Vn7x1I9HunJ5EcWNfYXeYXfKiPNEMZwnX705M+cBHulVGktu1Gz9+E1csFjFW6yCpcrbGEDoy1yBjMvUl6CniszYMAVDLWw8FGTHYDtfSMDcpca4cw0lk66e6RgXvp2lkpOueGzHpZW0PJJ+ZWfiJD8I6PNi5XirsIRI9pvCxER+WGJDeyBuErnlnSF6ZhHa6dzNcpkUSJO0lBqX5o0lpxEU6WFelm2+aC3aH5Tz7FZxxl4zol0wi8q7T6cGuad7aDKivQfQcjV/1mMK1bn8nyKMdxVNzHofHcrchaPP2Nbv+l5whGMjNpWU+OBmeBNWvcEO7HaCBRNyYThsu46HUSHHiAFVZS1itDVRCt4xXThu4UUbSBlpOgUNTedTS1YEJELWZA6P4BJjIZIq42y3HzcxF0aeCWHRr+wxlJeIy8JX+TZhzQ4erznjadCAqg4KOloNz7cvgQVCO58vnumCgweGvWza+zd1yagK1o1e/3Yt1FmrPLIFHqnSPMwnKRKKWBS+PnSqcQV5V3X0uyhpBZljTxShfod96ea4SuAQPmJ+tplhgPqUbBCbMxZ3ptyyVapJuSh1Gt0Gk6//dNpAFJzeUUs25ixJn/48MyT0AcaoZU4gW202CQqP80dH7Q63QGyKvA==
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
 =?us-ascii?Q?27Iixg2c+OQGUy2s4l9xUEO8cbYdjgXYuPFFfe5GLbTPmwJuItxaYqdgTZJx?=
 =?us-ascii?Q?RL10+rWzjZbDDGXCxph1kobTshwyY3y0u2Ckujh91J5FB+7lIsNkO/qLXHkS?=
 =?us-ascii?Q?qk0pg9R43jMVeWKoXV15kV5CPBuxX3zds2TmsxNyTBLVzTohFIC0B/H6xQnh?=
 =?us-ascii?Q?4iwt6wzlI3/sk5MRDeMHf4WzEcQ6qri1vjvPlBsRGpAI6F8DQwpqhQz9zvGm?=
 =?us-ascii?Q?2nIgqi1Ru2za4IUliUIOlP+4jMaVJmPNMY1iVwEDWutc2Zr32w0VmMc/MA0d?=
 =?us-ascii?Q?4mmbrB0R/V6xjQrFEYMzm5W1nOeY3p9OJeGFoAFjV5evVwI3Z/y6saeNGQLQ?=
 =?us-ascii?Q?N52RtEhCiRcpCAOY+jjwpHhwYXQjwBrK+GWRAi6FncU2BIOIRRSNPjEXTmaS?=
 =?us-ascii?Q?STnRqvdxXzTaHnxiBHGVYZioZCdYrrCGpolt+IyTm/ZnPn3gxETKfqYLJri1?=
 =?us-ascii?Q?gjRT0bvnpKHd/NGk+9qEvJ7Y7sVLqACRNTpsLsJEa/7dk/imlovgqe95fXjE?=
 =?us-ascii?Q?r42I1QUOLdoCuw5BXljo6S87GS2eiJxjV2L3tOkyA4wBaZvfmof5/oe9LCi3?=
 =?us-ascii?Q?g9PK6VJ3vuvWHK1Q1ZJDInlLyBuApTrgPfDUbbX/xtI4aK0hl3lRLOdFsfmg?=
 =?us-ascii?Q?Pxeck9BS805BrXG4h7m/DCmir48tKgW4gg5kSoRvlhsNWtepAK0jRE/PsKW2?=
 =?us-ascii?Q?N/IUYXYj3hKDFDq61uZn+/SXClSCGcz7mB4/Zq2PfSVMF+nJpIScihhG5SvE?=
 =?us-ascii?Q?2dH0TGOlpL8INDPvR4Bb7hwr9b9Q6QGkuKuKhrJAQVt+YmMR9oS3njC1Y15o?=
 =?us-ascii?Q?OP2nUcr5+BlnFwr6Fp2SgxwY9nTIbY7fKqBDfumYAVXq7dcHHNqAqf+v5XfN?=
 =?us-ascii?Q?lKKX3RnlCQaE3hcKtn3aW5lCMfZ5uU6Yj9oaLlVj0WHNjymoj1brtGJu8aV1?=
 =?us-ascii?Q?kr5QYULmqO2GuKw3trXjNIaVRW/KKTrjefjtOn8pOzSu3lWwLe2WBjTq8T5N?=
 =?us-ascii?Q?M3nqzgFo0W+krIluLat5r0k9PSpQ4r6u0S3J7TPLueRufiIzSRp1iUz8n9vJ?=
 =?us-ascii?Q?oM6XPBBD4adjNillfXa7xh/XIHtNSIBrsgmQDfOOzPK+4T8/FPI+FA/gsfff?=
 =?us-ascii?Q?R/pRxd17svkzK6MKN4uZMCx0T/VwFBh3a4jECQ/QnMPM0TWzmQ8ldB7wXtLs?=
 =?us-ascii?Q?kffIoHualCFZH39CALmVwvxVh/KMcbYbGVrIKdOFP5SNGpEqa3zVWQ7c9u9I?=
 =?us-ascii?Q?IhvhQtebX/WwRLfCbof4JUh991g+4fOQ9c8W6ZFLCKpNL+PIfIGpcFb0CqOE?=
 =?us-ascii?Q?i+24Xw9X7YC20xFgAZS5kQLVzMtXyQxt7o9imaQK4qi6fLYjQFPkV/wCjnJo?=
 =?us-ascii?Q?9ozbD6gMS8CjbPViw8NldDYoW2eXwCRjQqxXvjqbY8/l8kpJrE4buEsSbdYA?=
 =?us-ascii?Q?3LGP+jMKfQ79zZOVUWlP2uGdyt5uehU51YZPrznqhHRZ8t6Yoaw7yxiefwVH?=
 =?us-ascii?Q?RisGy7N6UWvxvf7KheBM1os5vFzjdjd6dt9shVQ3EbhPd1HyBH2Ikt58s3tz?=
 =?us-ascii?Q?ygHkTLxwIKIlT26+vpydCTk15iqd1olIVm0H8IKokgmairRz80++t/M7HQVl?=
 =?us-ascii?Q?Uw=3D=3D?=
X-MS-Exchange-CrossTenant-Network-Message-Id:
 7f193405-c31e-4c5c-0878-08db10851b88
X-MS-Exchange-CrossTenant-AuthSource: PA4PR04MB7997.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: f7a17af6-1c5c-4a36-aa8b-f5be247aa4ba
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName:
 vMiFTnmZDhbapAYbBV8YqTNrZjkPs6dewUNJSQPp/MF0J70Ocg1ScP9IUk2puE0rGbwLwail6ZSyQyN9wSJoLA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB9PR04MB9307
X-ServerName: mail-vi1eur05on2069.outbound.protection.outlook.com
X-Proofpoint-SPF-Result: pass
X-Proofpoint-SPF-Record: v=spf1 include:spf.suse.com include:amazonses.com
 include:spf.protection.outlook.com include:_spf.qemailserver.com
 include:_spf.salesforce.com -all
X-Spam: Clean
X-Proofpoint-GUID: v6woF2UgdWatrxyCwbrrD10NiIRjQGzX
X-Proofpoint-ORIG-GUID: v6woF2UgdWatrxyCwbrrD10NiIRjQGzX
Reporting-Meta:
 AAFTKkut4GHFckVY/AzgXUvYPMqB4NizgFSz6p0br/cWH1eSwIT4U/JFf38O12fd
 Y8/8D1+OO+d0z5FVjnfiVN6SLemncQU+pFrWQn9CEgNc9oto2HNKERknJMbHuMRt
 HyG2P87KMnBbo/jf562Kly/hdtLoF3LYeYxrsLYjxey9VGvbMcPnyOO6dbeJYQPv
 GYtrr9RnKmvUhxk6WW6UyftsOdwXqE1w1E28Z2MGG+cf5k+klPLy/2WZbsYLSFZ4
 c4aWUfqXChJ17OBbMEnUieB5SaCtg7A5SeBRADbbdovo0/qG67NduoG6wyihnXL+
 3IS87t5bw6lgS+43FEd2g2OwQPFNKe0lgT79aT7SPXAOloIWCKlvwnSId5DMPV5w
 mG/ZZMyurXAbHdgYeU1Gx8ndTptNxR7ZmO9AjxCSwFd1pGDlAXVbBLrgf6FoJ7kC
 EKvoYVhOrVpLxENKOvKAHsyX1KTfErzffcaOdztzxx/3rle3/W73DBWfoaXYlmXs
 S7BcUlGLh3IByyY2DBf7oH4GO38Fcdv03eLaPHpwjl/Q

This commit fixes three issues on non-auto defrag path (defragfs.ocfs2
doesn't set OCFS2_MOVE_EXT_FL_AUTO_DEFRAG on range.me_flags):
- For ocfs2_find_victim_alloc_group(), old code forgot enlarge bitmap
  range for global_bitmap case. Old code could generate negative
  vict_bit.
- For ocfs2_probe_alloc_group(), old code forgot back off move_len when
  finding enough bitmap space. Old code has possibility to make data
  corruption.
- For ocfs2_ioctl_move_extents(), this func should set me_threshold for
  both auto & non-auto path. Without setting me_threshold,
  ocfs2_move_extent() will make 'move_max_hop = 0', then
  ocfs2_probe_alloc_group() returns 'phys_cpos == 0' under max_hop is 0.

Another info is current defragfs.ocfs2 doesn't have ability to trigger
non-auto defrag path. I modified defragfs.ocfs2 source code ".me_flags"
and hardcode ".me_goal" for running test.

Signed-off-by: Heming Zhao <heming.zhao@suse.com>
---
 fs/ocfs2/move_extents.c | 24 +++++++++++++-----------
 1 file changed, 13 insertions(+), 11 deletions(-)

diff --git a/fs/ocfs2/move_extents.c b/fs/ocfs2/move_extents.c
index 6251748c695b..b1e32ec4a9d4 100644
--- a/fs/ocfs2/move_extents.c
+++ b/fs/ocfs2/move_extents.c
@@ -434,7 +434,7 @@ static int ocfs2_find_victim_alloc_group(struct inode *inode,
 			bg = (struct ocfs2_group_desc *)gd_bh->b_data;
 
 			if (vict_blkno < (le64_to_cpu(bg->bg_blkno) +
-						le16_to_cpu(bg->bg_bits))) {
+						(le16_to_cpu(bg->bg_bits) << bits_per_unit))) {
 
 				*ret_bh = gd_bh;
 				*vict_bit = (vict_blkno - blkno) >>
@@ -549,6 +549,7 @@ static void ocfs2_probe_alloc_group(struct inode *inode, struct buffer_head *bh,
 			last_free_bits++;
 
 		if (last_free_bits == move_len) {
+			i -= move_len;
 			*goal_bit = i;
 			*phys_cpos = base_cpos + i;
 			break;
@@ -1020,18 +1021,19 @@ int ocfs2_ioctl_move_extents(struct file *filp, void __user *argp)
 
 	context->range = &range;
 
+	/*
+	 * ok, the default theshold for the defragmentation
+	 * is 1M, since our maximum clustersize was 1M also.
+	 * any thought?
+	 */
+	if (!range.me_threshold)
+		range.me_threshold = 1024 * 1024;
+
+	if (range.me_threshold > i_size_read(inode))
+		range.me_threshold = i_size_read(inode);
+
 	if (range.me_flags & OCFS2_MOVE_EXT_FL_AUTO_DEFRAG) {
 		context->auto_defrag = 1;
-		/*
-		 * ok, the default theshold for the defragmentation
-		 * is 1M, since our maximum clustersize was 1M also.
-		 * any thought?
-		 */
-		if (!range.me_threshold)
-			range.me_threshold = 1024 * 1024;
-
-		if (range.me_threshold > i_size_read(inode))
-			range.me_threshold = i_size_read(inode);
 
 		if (range.me_flags & OCFS2_MOVE_EXT_FL_PART_DEFRAG)
 			context->partial = 1;
-- 
2.39.0


_______________________________________________
Ocfs2-devel mailing list
Ocfs2-devel@oss.oracle.com
https://oss.oracle.com/mailman/listinfo/ocfs2-devel
