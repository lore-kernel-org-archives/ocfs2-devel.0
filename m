Return-Path: <SRS0=MtCY=MF=oss.oracle.com=ocfs2-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_MED,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,MSGID_FROM_MTA_HEADER,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BACFDC07E96
	for <ocfs2-devel@archiver.kernel.org>; Tue, 13 Jul 2021 21:14:19 +0000 (UTC)
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id 5E52F61289
	for <ocfs2-devel@archiver.kernel.org>; Tue, 13 Jul 2021 21:14:19 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 5E52F61289
Authentication-Results: mail.kernel.org; dmarc=pass (p=none dis=none) header.from=oracle.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=ocfs2-devel-bounces@oss.oracle.com
Received: from pps.filterd (m0246632.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 16DL6TRD010113;
	Tue, 13 Jul 2021 21:14:18 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : date :
 message-id : in-reply-to : references : mime-version : subject : list-id :
 list-unsubscribe : list-archive : list-post : list-help : list-subscribe :
 content-type : content-transfer-encoding : sender; s=corp-2020-01-29;
 bh=+HczzYYsM643LtLv14tKLq4fbEGKt3SmFxaPQT8eXl4=;
 b=Cmm6ruEDTgycW/ELJGKgemnFhPgcoQQVnb4DnKce12YUVtdySU3GiaMQjYR3DFZ4YMGV
 mTfHklLWBxMJwCDi+aMshLCrxhp9S96PLBtvDDWehGgB/jHlIG7W/VNr1VUIMpExhg3s
 E2y7vn8a4I0ZkeJW9arlkX772xHIfhBJG457dxTOO/G3ziQXGParot96WvZ6rfUy3QEZ
 j0MTVQ3gaOMgV9wvuHSJjOwfYGsBoaziXK5Z801zLEqX3v1Jx0J3WHreKRtMrxqyoa1z
 IOeED5MGgK5d9wxAc3e8hojj5i/8ooI9TxU//ksmKoVJS7mt7MsWrj+nseWSWE49xgw7 tA== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
	by mx0b-00069f02.pphosted.com with ESMTP id 39rqm0ud5e-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 13 Jul 2021 21:14:17 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
	by userp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 16DL6Xps077878;
	Tue, 13 Jul 2021 21:14:16 GMT
Received: from oss.oracle.com (oss-old-reserved.oracle.com [137.254.22.2])
	by userp3030.oracle.com with ESMTP id 39q0p5ubv9-1
	(version=TLSv1 cipher=AES256-SHA bits=256 verify=NO);
	Tue, 13 Jul 2021 21:14:16 +0000
Received: from localhost ([127.0.0.1] helo=lb-oss.oracle.com)
	by oss.oracle.com with esmtp (Exim 4.63)
	(envelope-from <ocfs2-devel-bounces@oss.oracle.com>)
	id 1m3PjL-0006kT-CF; Tue, 13 Jul 2021 14:14:15 -0700
Received: from aserp3030.oracle.com ([141.146.126.71])
	by oss.oracle.com with esmtp (Exim 4.63)
	(envelope-from <junxiao.bi@oracle.com>) id 1m3Pip-0006is-Md
	for ocfs2-devel@oss.oracle.com; Tue, 13 Jul 2021 14:13:43 -0700
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
	by aserp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id
	16DL4t5K016813
	for <ocfs2-devel@oss.oracle.com>; Tue, 13 Jul 2021 21:13:43 GMT
Received: from nam11-co1-obe.outbound.protection.outlook.com
	(mail-co1nam11lp2172.outbound.protection.outlook.com [104.47.56.172])
	by aserp3030.oracle.com with ESMTP id 39qycx478x-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
	for <ocfs2-devel@oss.oracle.com>; Tue, 13 Jul 2021 21:13:43 +0000
Authentication-Results: oss.oracle.com; dkim=none (message not signed)
	header.d=none; oss.oracle.com;
	dmarc=none action=none header.from=oracle.com; 
Received: from SJ0PR10MB4752.namprd10.prod.outlook.com (2603:10b6:a03:2d7::19)
	by BYAPR10MB3654.namprd10.prod.outlook.com (2603:10b6:a03:123::17)
	with Microsoft SMTP Server (version=TLS1_2,
	cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4308.23;
	Tue, 13 Jul 2021 21:13:41 +0000
Received: from SJ0PR10MB4752.namprd10.prod.outlook.com
	([fe80::e0a1:1074:ef31:e756]) by
	SJ0PR10MB4752.namprd10.prod.outlook.com
	([fe80::e0a1:1074:ef31:e756%6]) with mapi id 15.20.4308.027;
	Tue, 13 Jul 2021 21:13:41 +0000
From: Junxiao Bi <junxiao.bi@oracle.com>
To: ocfs2-devel@oss.oracle.com
Date: Tue, 13 Jul 2021 14:13:06 -0700
Message-Id: <20210713211306.50593-2-junxiao.bi@oracle.com>
X-Mailer: git-send-email 2.24.3 (Apple Git-128)
In-Reply-To: <20210713211306.50593-1-junxiao.bi@oracle.com>
References: <20210713211306.50593-1-junxiao.bi@oracle.com>
X-ClientProxiedBy: SN4PR0201CA0059.namprd02.prod.outlook.com
	(2603:10b6:803:20::21) To SJ0PR10MB4752.namprd10.prod.outlook.com
	(2603:10b6:a03:2d7::19)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from dhcp-10-159-233-121.vpn.oracle.com (73.231.9.254) by
	SN4PR0201CA0059.namprd02.prod.outlook.com
	(2603:10b6:803:20::21) with Microsoft SMTP Server
	(version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384)
	id 15.20.4331.21 via Frontend Transport;
	Tue, 13 Jul 2021 21:13:40 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 6c2b958a-bc7e-48df-6420-08d9464316cd
X-MS-TrafficTypeDiagnostic: BYAPR10MB3654:
X-Oracle-Tenancy: 1
X-MS-Oob-TLC-OOBClassifiers: OLM:4303;
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: BsECmNRxEWQn7r2TjnDrQ7t9kiWeICDuatpegOImKfVOvZeimlN3pdSPvXxi9f41s9SeWUznPrhmIXH25XHjl61/BMnpmOGMoLfJlChHcJxFWRfRLR8Yr5lJjymInrXMZgRX2ZAYqxsSMZxV71jtP4JObuGdGXfRLNDcnA8xzOTWwi2N1jfLPRN6e61tBFlsRgTjKT8bGNqOw2IysbPLFLM6V/QpN9exe2Yhe9Yf/HBP7HQ/x62u0OfWmA9dnjmUyNIFFuADpvhJdLj3g6ViMgtp4J/7RrtqibfG19xkGyirMN5XKJ600lQXjHEG0anoXz9PtjHvw9MQeBppGf91xC6bFP+lQUMAealYRw9ZH7IUK+qWlBXU9UlXtNhMUHtS2X/iqLERnD2H0Hm6AIZjEzAlWthwmACphun+9iUjbqZEc6GzRpWoU9is4Ht6cCigzJJl6tj/pHFsJ3RSa4WNEGud5p64Hyt1LBcpd4wpChsocPll90g3QTusEP1q8Ef+XQFh1FSTxlbhNmiKBYME8pDF01fqo5YEj7L+MCcEDb5egvuG1jfEPK3V3SMzyC9h8fG2aNLk1y0koxK4LjlckLtvwIO4Veh7mBDEnpQBMBw=
X-Forefront-Antispam-Report: CIP:255.255.255.255; CTRY:; LANG:en; SCL:-1; SRV:; IPV:NLI; SFV:SKI;
	H:SJ0PR10MB4752.namprd10.prod.outlook.com; PTR:; CAT:NONE; SFS:;
	DIR:INB; 
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?dQlS6rqDNXZBQe5/xcrkdbyUIkFb67rhJOdwPc+Iij+y2dlYfHhXgSNoyYDE?=
	=?us-ascii?Q?Fx/aP88lmZ2mMZIEokZ5GENQy9dDg30BmsdCV3NRw7wgXbf6S7aVp4P42QuI?=
	=?us-ascii?Q?YMLaPAiIvvahsR7PEd446WHJlj6p2mCF8VPijG3fdCnafgi3BWG78j8zgEWQ?=
	=?us-ascii?Q?hU77A3wGBDI4CaFwaAjxxXL/YwXatd9jjbhrxJGngLCMnyTw4SHDGOwPQp4w?=
	=?us-ascii?Q?pfNQ8p5eZ6ceJFxRGHLv2pyZVCjUmXe1uBVF/BveuEMUhMFcZ+qFjkD0tr27?=
	=?us-ascii?Q?jAbOJE3McWmSHlz1qS0bmMwIezyxmUpsuolhg6LW4Ez1W7vDN1do2ivVhdop?=
	=?us-ascii?Q?5kJxGzAh1IWwPSTOm6iFN1XMPtJEnKJdK9CN3d7Dg/bvzHAvhMKOw8E/UMeQ?=
	=?us-ascii?Q?pEw0szaxdO6/HumWpv15y5/lS6PVCyEhqxv8AMgv5sLEzG8k6VEDfkIDjPyj?=
	=?us-ascii?Q?O+cLGxtyeYAm6RxwKQIrOKZtJ7imZivqZGtaavodEOaLEncvydNTouihooqN?=
	=?us-ascii?Q?Iq8cKuPwNJkg5ksW2xT9V5nRQmeL5vEPKlUK+TZB7jQurVEhNDZpqhNalh50?=
	=?us-ascii?Q?LxPsjQr4egAxm+zLk9sKThYY4bt1w7NMFTcvvonhG17gI5iQL/XStCgYSuJ+?=
	=?us-ascii?Q?VwN/NaSmkOlklusMR4mm1tDCy8aFshn7qYRgxbT/G474PSYI+N89tuPpTOJ2?=
	=?us-ascii?Q?yeB2WISltjybHddYpt5er+sIzfRDZYbKnyn2CY/hJRsdYaH9FA4u5UYEbD5E?=
	=?us-ascii?Q?H+A9fwZExNe0VnTk83IiPzHblbbeGwcmgSPvENncgkjVBzvWkFaK05AB9Eul?=
	=?us-ascii?Q?n2S1yQ9/b/yEbFzm5a2m8jxFfbe6A6h3mravuvDfFeSwwzIOt/rf0K9xWu4s?=
	=?us-ascii?Q?0ycdp86z3WxqZ/GtvZoOli56abVvCKFcc1NMCDTgGjUKd77LBvpnEXl3uWZO?=
	=?us-ascii?Q?a/ehW0OukwvwO2XncMkBYdfYrK8VBIhv8BPsGDQy4Pjsft87I2X6+sDd70BN?=
	=?us-ascii?Q?xq5pTUomJzdTApEpkOOQIZqO5UROLl7BfSsipIMQHBgNumtMfN7ICzarJHNX?=
	=?us-ascii?Q?oyVAplAIFiiaGBc9rFGztU1RaLdIrim1bETnJKj8vOSw/4/CmHWM4c5VkdSQ?=
	=?us-ascii?Q?DWJ5RunGVkzzrgz4d8D+lrYUw2T/FCt3d5NuY9JtKTvDrHPypvlPRhsuxuBf?=
	=?us-ascii?Q?Hs6mncMceta0jDpYf1dnGp4+ctumUyjqeL9rXWXHFY3otS0MVfLhVXovPA9l?=
	=?us-ascii?Q?YcunnX00IjWJrzEnHlKgC7P55Djzuwh47ZsCpdbNGCTmAFvByH1uy3gD1Pl/?=
	=?us-ascii?Q?Wx0uizJHJMrbU7UBblzSziIn?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 6c2b958a-bc7e-48df-6420-08d9464316cd
X-MS-Exchange-CrossTenant-AuthSource: SJ0PR10MB4752.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 Jul 2021 21:13:41.2233 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: tyK/zqZ7ZDvYeQiK3S8jpOkABg+rkmpLPlm9uQgC5e9gSlPPiYAvK/tdfjJDIblKiGdyAM+M7jYZu1MDm70YbQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR10MB3654
X-MS-Exchange-CrossPremises-AuthSource: SJ0PR10MB4752.namprd10.prod.outlook.com
X-MS-Exchange-CrossPremises-AuthAs: Internal
X-MS-Exchange-CrossPremises-AuthMechanism: 06
X-MS-Exchange-CrossPremises-Mapi-Admin-Submission: 
X-MS-Exchange-CrossPremises-MessageSource: StoreDriver
X-MS-Exchange-CrossPremises-BCC: 
X-MS-Exchange-CrossPremises-OriginalClientIPAddress: 73.231.9.254
X-MS-Exchange-CrossPremises-TransportTrafficType: Email
X-MS-Exchange-CrossPremises-Antispam-ScanContext: DIR:Originating;SFV:SKI;SKIP:0;
X-MS-Exchange-CrossPremises-SCL: -1
X-MS-Exchange-CrossPremises-Processed-By-Journaling: Journal Agent
X-OrganizationHeadersPreserved: BYAPR10MB3654.namprd10.prod.outlook.com
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=10044
	signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0
	mlxlogscore=999
	adultscore=0 malwarescore=0 bulkscore=0 mlxscore=0 suspectscore=0
	spamscore=0 classifier=spam adjust=0 reason=mlx scancount=1
	engine=8.12.0-2104190000 definitions=main-2107130130
Subject: [Ocfs2-devel] [PATCH 2/2] ocfs2: issue zeroout to EOF blocks
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
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=10044 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 adultscore=0
 phishscore=0 spamscore=0 bulkscore=0 mlxlogscore=999 mlxscore=0
 suspectscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2104190000 definitions=main-2107130130
X-Proofpoint-GUID: _2I4wGN3fJmUoVatfvF0HnZWS6LlcYFM
X-Proofpoint-ORIG-GUID: _2I4wGN3fJmUoVatfvF0HnZWS6LlcYFM

For punch holes in EOF blocks, fallocate used buffer write to zero
the EOF blocks in last cluster. But since ->writepage will ignore
EOF pages, those zeros will not be flushed. This "looks" ok as
commit 6bba4471f0cc ("ocfs2: fix data corruption by fallocate")
will zero the EOF blocks when extend the file size, but it isn't.
The problem happened on those EOF pages, before writeback, those
pages had DIRTY flag set and all buffer_head in them also had
DIRTY flag set, when writeback run by write_cache_pages(), DIRTY
flag on the page was cleared, but DIRTY flag on the buffer_head
not. When next write happened to those EOF pages, since buffer_head
already had DIRTY flag set, it would not mark page DIRTY again.
That made writeback ignore them forever. That will cause data
corruption. Even directio write can't work because it will fail
when trying to drop pages caches before direct io, as it found
the buffer_head for those pages still had DIRTY flag set, then
it will fall back to buffer io mode.
To make a summary of the issue, as writeback ingores EOF pages,
once any EOF page is generated, any write to it will only go
to the page cache, it will never be flushed to disk even file
size extends and that page is not EOF page any more.
The fix is to avoid zero EOF blocks with buffer write.

The following code snippet from qemu-img could trigger the corruption.

656   open("6b3711ae-3306-4bdd-823c-cf1c0060a095.conv.2", O_RDWR|O_DIRECT|O_CLOEXEC) = 11
...
660   fallocate(11, FALLOC_FL_KEEP_SIZE|FALLOC_FL_PUNCH_HOLE, 2275868672, 327680 <unfinished ...>
660   fallocate(11, 0, 2275868672, 327680) = 0
658   pwrite64(11, "\0\31\237\v\0\336\330\f\0\373~\r\0\300\270\16\0\335^\17\0\242\230\20\0\277>\21\0\204x\22"..., 311296, 2275868672) = 311296

Cc: <stable@vger.kernel.org>
Signed-off-by: Junxiao Bi <junxiao.bi@oracle.com>
---
 fs/ocfs2/file.c | 99 ++++++++++++++++++++++++++++++-------------------
 1 file changed, 60 insertions(+), 39 deletions(-)

diff --git a/fs/ocfs2/file.c b/fs/ocfs2/file.c
index 53bb46ce3cbb..984b950f5abc 100644
--- a/fs/ocfs2/file.c
+++ b/fs/ocfs2/file.c
@@ -1529,6 +1529,45 @@ static void ocfs2_truncate_cluster_pages(struct inode *inode, u64 byte_start,
 	}
 }
 
+/*
+ * zero out partial blocks of one cluster.
+ *
+ * start: file offset where zero starts, will be made upper block aligned.
+ * len: it will be trimmed to the end of current cluster if "start + len"
+ *      is bigger than it.
+ */
+static int ocfs2_zeroout_partial_cluster(struct inode *inode,
+					u64 start, u64 len)
+{
+	int ret;
+	u64 start_block, end_block, nr_blocks;
+	u64 p_block, offset;
+	u32 cluster, p_cluster, nr_clusters;
+	struct super_block *sb = inode->i_sb;
+	u64 end = ocfs2_align_bytes_to_clusters(sb, start);
+
+	if (start + len < end)
+		end = start + len;
+
+	start_block = ocfs2_blocks_for_bytes(sb, start);
+	end_block = ocfs2_blocks_for_bytes(sb, end);
+	nr_blocks = end_block - start_block;
+	if (!nr_blocks)
+		return 0;
+
+	cluster = ocfs2_bytes_to_clusters(sb, start);
+	ret = ocfs2_get_clusters(inode, cluster, &p_cluster,
+				&nr_clusters, NULL);
+	if (ret)
+		return ret;
+	if (!p_cluster)
+		return 0;
+
+	offset = start_block - ocfs2_clusters_to_blocks(sb, cluster);
+	p_block = ocfs2_clusters_to_blocks(sb, p_cluster) + offset;
+	return sb_issue_zeroout(sb, p_block, nr_blocks, GFP_NOFS);
+}
+
 static int ocfs2_zero_partial_clusters(struct inode *inode,
 				       u64 start, u64 len)
 {
@@ -1538,6 +1577,7 @@ static int ocfs2_zero_partial_clusters(struct inode *inode,
 	struct ocfs2_super *osb = OCFS2_SB(inode->i_sb);
 	unsigned int csize = osb->s_clustersize;
 	handle_t *handle;
+	loff_t isize = i_size_read(inode);
 
 	/*
 	 * The "start" and "end" values are NOT necessarily part of
@@ -1558,6 +1598,26 @@ static int ocfs2_zero_partial_clusters(struct inode *inode,
 	if ((start & (csize - 1)) == 0 && (end & (csize - 1)) == 0)
 		goto out;
 
+	/* No page cache for EOF blocks, issue zero out to disk. */
+	if (end > isize) {
+		/*
+		 * zeroout eof blocks in last cluster starting from
+		 * "isize" even "start" > "isize" because it is
+		 * complicated to zeroout just at "start" as "start"
+		 * may be not aligned with block size, buffer write
+		 * would be required to do that, but out of eof buffer
+		 * write is not supported.
+		 */
+		ret = ocfs2_zeroout_partial_cluster(inode, isize,
+					end - isize);
+		if (ret) {
+			mlog_errno(ret);
+			return ret;
+		}
+		if (start >= isize)
+			return ret;
+		end = isize;
+	}
 	handle = ocfs2_start_trans(osb, OCFS2_INODE_UPDATE_CREDITS);
 	if (IS_ERR(handle)) {
 		ret = PTR_ERR(handle);
@@ -1855,45 +1915,6 @@ int ocfs2_remove_inode_range(struct inode *inode,
 	return ret;
 }
 
-/*
- * zero out partial blocks of one cluster.
- *
- * start: file offset where zero starts, will be made upper block aligned.
- * len: it will be trimmed to the end of current cluster if "start + len"
- *      is bigger than it.
- */
-static int ocfs2_zeroout_partial_cluster(struct inode *inode,
-					u64 start, u64 len)
-{
-	int ret;
-	u64 start_block, end_block, nr_blocks;
-	u64 p_block, offset;
-	u32 cluster, p_cluster, nr_clusters;
-	struct super_block *sb = inode->i_sb;
-	u64 end = ocfs2_align_bytes_to_clusters(sb, start);
-
-	if (start + len < end)
-		end = start + len;
-
-	start_block = ocfs2_blocks_for_bytes(sb, start);
-	end_block = ocfs2_blocks_for_bytes(sb, end);
-	nr_blocks = end_block - start_block;
-	if (!nr_blocks)
-		return 0;
-
-	cluster = ocfs2_bytes_to_clusters(sb, start);
-	ret = ocfs2_get_clusters(inode, cluster, &p_cluster,
-				&nr_clusters, NULL);
-	if (ret)
-		return ret;
-	if (!p_cluster)
-		return 0;
-
-	offset = start_block - ocfs2_clusters_to_blocks(sb, cluster);
-	p_block = ocfs2_clusters_to_blocks(sb, p_cluster) + offset;
-	return sb_issue_zeroout(sb, p_block, nr_blocks, GFP_NOFS);
-}
-
 /*
  * Parts of this function taken from xfs_change_file_space()
  */
-- 
2.24.3 (Apple Git-128)


_______________________________________________
Ocfs2-devel mailing list
Ocfs2-devel@oss.oracle.com
https://oss.oracle.com/mailman/listinfo/ocfs2-devel
