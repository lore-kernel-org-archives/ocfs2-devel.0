Return-Path: <SRS0=iQvO=MO=oss.oracle.com=ocfs2-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_MED,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,MSGID_FROM_MTA_HEADER,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E3DEFC63797
	for <ocfs2-devel@archiver.kernel.org>; Thu, 22 Jul 2021 05:50:36 +0000 (UTC)
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id 87CE860FD7
	for <ocfs2-devel@archiver.kernel.org>; Thu, 22 Jul 2021 05:50:36 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 87CE860FD7
Authentication-Results: mail.kernel.org; dmarc=pass (p=none dis=none) header.from=oracle.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=ocfs2-devel-bounces@oss.oracle.com
Received: from pps.filterd (m0246627.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 16M5l30r006358;
	Thu, 22 Jul 2021 05:50:36 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : date :
 message-id : in-reply-to : references : mime-version : subject : list-id :
 list-unsubscribe : list-archive : list-post : list-help : list-subscribe :
 content-type : content-transfer-encoding : sender; s=corp-2021-07-09;
 bh=MhoarFF0UXlvUQR5cd6r93U/3R2Fby/Bd541FFXxywA=;
 b=VsZ02tXcc+mk4QIXwQn+8NTR7xiNng8++wDFNKzextuNDJ24Cr7yjS1ufZBYDDnezzia
 7wDTZpsvm9IjMZqRlnWRLBclw2QQjzmz0ssB0D5QSLRK77Ab3q12dRM5d7sAXuuCx+7f
 5+YnhV7DHsSuHac4b+3DX+gzDlp4rUQJWfkK2MGkToMW4JDTkEzIePFTj2BiJKdttTTH
 HJuQiiUBbx0WF7+jqFF669KAxKur9BiZdHD+V5O0XRbM4fZRh+z/WzEz8ynQrD+8Yd9z
 AEYB0woQyI2iT0ujnMx9ar5Modc8/HoN//jm+b7cNgON4OXgYCZZP2jrZQclMRHxU/VP Lw== 
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : date :
 message-id : in-reply-to : references : mime-version : subject : list-id :
 list-unsubscribe : list-archive : list-post : list-help : list-subscribe :
 content-type : content-transfer-encoding : sender; s=corp-2020-01-29;
 bh=MhoarFF0UXlvUQR5cd6r93U/3R2Fby/Bd541FFXxywA=;
 b=GRE/Mjc3fZcsqcSkhcEblQs+jxj8wZQMUFYBVZGvM38ysii5WVt95a8GS/XUReillWu4
 FWm0v9Vr2Q8ZABqY5qL6VHJ6NDIxA9+FBn4cj6YYq2aPqISn/WqYOunwIdbpwjVVd+/T
 OstRPtWTJPVqEJxybXNqiSY341q0+IrpXvS79rmhuTUfd0MceL0WbzOsfdnqduDk/VI2
 SADqwvlZVe4KeNIZaZZ/rWhVZ80bCorR/BaIEpgENC/u4Hsy32FcdjSQQX2a+84hwJRp
 xUM97ZJFmkrmoENMk40LXa7/BZixqRH9bucxFAatT3hAApxN/L8Sts4UusCxiVEOGhp8 Jw== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
	by mx0b-00069f02.pphosted.com with ESMTP id 39wyq0v54q-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 22 Jul 2021 05:50:35 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
	by userp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 16M5kYJi140958;
	Thu, 22 Jul 2021 05:50:34 GMT
Received: from oss.oracle.com (oss-old-reserved.oracle.com [137.254.22.2])
	by userp3030.oracle.com with ESMTP id 39umb4888f-1
	(version=TLSv1 cipher=AES256-SHA bits=256 verify=NO);
	Thu, 22 Jul 2021 05:50:33 +0000
Received: from localhost ([127.0.0.1] helo=lb-oss.oracle.com)
	by oss.oracle.com with esmtp (Exim 4.63)
	(envelope-from <ocfs2-devel-bounces@oss.oracle.com>)
	id 1m6RbM-0000dx-Br; Wed, 21 Jul 2021 22:50:32 -0700
Received: from aserp3030.oracle.com ([141.146.126.71])
	by oss.oracle.com with esmtp (Exim 4.63)
	(envelope-from <junxiao.bi@oracle.com>) id 1m6Raq-0000V2-CG
	for ocfs2-devel@oss.oracle.com; Wed, 21 Jul 2021 22:50:00 -0700
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
	by aserp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id
	16M5jMJS060297
	for <ocfs2-devel@oss.oracle.com>; Thu, 22 Jul 2021 05:50:00 GMT
Received: from nam10-mw2-obe.outbound.protection.outlook.com
	(mail-mw2nam10lp2104.outbound.protection.outlook.com [104.47.55.104])
	by aserp3030.oracle.com with ESMTP id 39wunnbjy5-3
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
	for <ocfs2-devel@oss.oracle.com>; Thu, 22 Jul 2021 05:50:00 +0000
Authentication-Results: oss.oracle.com; dkim=none (message not signed)
	header.d=none; oss.oracle.com;
	dmarc=none action=none header.from=oracle.com; 
Received: from SJ0PR10MB4752.namprd10.prod.outlook.com (2603:10b6:a03:2d7::19)
	by BYAPR10MB3061.namprd10.prod.outlook.com (2603:10b6:a03:83::14)
	with Microsoft SMTP Server (version=TLS1_2,
	cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4331.25;
	Thu, 22 Jul 2021 05:49:58 +0000
Received: from SJ0PR10MB4752.namprd10.prod.outlook.com
	([fe80::e0a1:1074:ef31:e756]) by
	SJ0PR10MB4752.namprd10.prod.outlook.com
	([fe80::e0a1:1074:ef31:e756%5]) with mapi id 15.20.4352.025;
	Thu, 22 Jul 2021 05:49:58 +0000
From: Junxiao Bi <junxiao.bi@oracle.com>
To: ocfs2-devel@oss.oracle.com
Date: Wed, 21 Jul 2021 22:49:23 -0700
Message-Id: <20210722054923.24389-2-junxiao.bi@oracle.com>
X-Mailer: git-send-email 2.24.3 (Apple Git-128)
In-Reply-To: <20210722054923.24389-1-junxiao.bi@oracle.com>
References: <20210722054923.24389-1-junxiao.bi@oracle.com>
X-ClientProxiedBy: SN6PR08CA0027.namprd08.prod.outlook.com
	(2603:10b6:805:66::40) To SJ0PR10MB4752.namprd10.prod.outlook.com
	(2603:10b6:a03:2d7::19)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from dhcp-10-159-233-185.vpn.oracle.com (73.231.9.254) by
	SN6PR08CA0027.namprd08.prod.outlook.com (2603:10b6:805:66::40)
	with Microsoft SMTP Server (version=TLS1_2,
	cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4352.25
	via Frontend Transport; Thu, 22 Jul 2021 05:49:57 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 7041c109-cdce-4103-39c3-08d94cd489ea
X-MS-TrafficTypeDiagnostic: BYAPR10MB3061:
X-MS-Exchange-Transport-Forked: True
X-Oracle-Tenancy: 1
X-MS-Oob-TLC-OOBClassifiers: OLM:4303;
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: NBnx+ypww7Ql9HIqmhJvPeITwUUC8+Gs6FsNaP0dkcU6X8mMZ6hH6lZzRJ9ftjiq+T6Vb1COipRUDvTqcKemttrT701D/NqFseTp7jTgRfqJRBcbdohwCWQLgf32tGbKWht9jOLbhDWbYNuMr5xw9dC3oNhW/fVhOd5AHQ/zZ+GJzSwY+gBaQ8MdYqiZ9+xxQPVkXPFSbnvFV8YHRFonudavTRBpjfWPT7n0gujP6hVrQT1k2TJGAXP8RjPjdkL0rpgCfmSp+42PPsULxPCxR/n51+gW0dGeQYAtsuX/gQfIv6nZfBPIBd+6qLPqzKqkty6TqL4bryBrik5W6yMFqtpxMlSVQ7VogElnJie9sidymwoeLflBb00AXQyZM4Jijj21xF51teNI4Vdr4p9k5ggHH+mZvg1m1exFcLye9p2ktlheiTDRw199l+R8Rqwwr9MNC/w4CmTe5YwX5teHUVbUu1EA85tEQoQo9CcXPd8sARSWn8PAeyEXQzkOf3cHimLQ4rOxE2Fltlytu0ryKLETFXV9zDotuC6iTaRl4z8xoAZg6RxSEuUtZszYh+jRP7k1b9uEkT//6OEb6cA4uPXI22CaEfFAoOzj7plmWb4=
X-Forefront-Antispam-Report: CIP:255.255.255.255; CTRY:; LANG:en; SCL:-1; SRV:; IPV:NLI; SFV:SKI;
	H:SJ0PR10MB4752.namprd10.prod.outlook.com; PTR:; CAT:NONE; SFS:;
	DIR:INB; 
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?CgPWk4S51GJTtj3YxXZkpqHzjDc3vIGxu13gCWrTuJOdlu5sA1xw2qZl4xNF?=
	=?us-ascii?Q?C0B69rWHbhdXheJ+cDz7vHsG23phpi7iREepNL8/qppo4eXvLnMpyFm0qdhA?=
	=?us-ascii?Q?d05oWA2PetbMBda9L//IhXjquhTFFz/1ZFSuA8gioiVzmdod+hByrviItQ1h?=
	=?us-ascii?Q?1lkcC28NCMLVCNM31xHRK4kmgKP4gtchv1U3+zn6WK6r/5YqOKmHkXxk+bo+?=
	=?us-ascii?Q?4EXw4ZpCuW6+tkScTupyljmtsqZ75Y/md5TwfaN04Tyj+id35/FkEAcNyLos?=
	=?us-ascii?Q?E3RtgAF8rJ5dzeqt009fLgBco/wZdSh/wpckeICUDOu5sWrvSYwF01YTJL/z?=
	=?us-ascii?Q?SJ6o7Djfrsaoow+XBqoVMtCFrisxOXpIT8uExyOOzyqRCERqsQhm5Hl5lacX?=
	=?us-ascii?Q?+A5fjjjerY+FQy8QYrmMsuaXO4JH9h/9cCha1wf8jZcRIIIa3fUYg5Fvf634?=
	=?us-ascii?Q?ehkOLW+4nqzfT0l5CvBtcYQ75d5xDlNatF01sapCH+3eMfxbIt2UWXl4zdgX?=
	=?us-ascii?Q?2yxDShn5xVuSXtwUd4l9lGrbU5Z8HzQggGR+jkYaUyjH3wL7BPUUdwU2FgUQ?=
	=?us-ascii?Q?T1Yh4Pq3WAZVrc/sz4ohK/VzC1UgpUaFmUtu7YMj+uTPdaDSnC24eRrwap+i?=
	=?us-ascii?Q?bS8ecbyDJh4veeZF0Pr+d+9+I6waQr7tOUT65+Ich7fru5MgWX3s7k7lxFL1?=
	=?us-ascii?Q?1X/QTdocKj9IPpHl4aeDml7pIjL26MPSI5uJAJmAvgYOhyvNbsxVgs21tC/D?=
	=?us-ascii?Q?wwZvSG0qUNy9BNh/xm+6gMZ6XA/7Z2MTwmk7WRR/Q1DJuNgOqg09IhIlKKfa?=
	=?us-ascii?Q?3z3YP+A21aQ8eqLo0qSxYPgBq7+oIfYy/TP/I/FRmjvGRbiFmc1Aupn8QrQq?=
	=?us-ascii?Q?CkxQD4shMqxvN6SuwKjVRuRzB6tUauWLasA7pvPGBZlQgfc3eSgnoIkgJsf4?=
	=?us-ascii?Q?bdlltPVMIT1JZsOw+hCuC1bfBl842DC+FAh0v9Gn+5wyVUm1I1z37uDbUs12?=
	=?us-ascii?Q?8EWd00Bycxmqo7TfQxSjIQ7DWIGD22CNK8GKDOArdZsw7EH9CWZxuGSojPzT?=
	=?us-ascii?Q?FauTmGXnd7j7tGd+aaJiEPUeT5qdqY4OkXaMRwyDRVWnlMPAyx68cnAZOUF6?=
	=?us-ascii?Q?L2KgXH1jpN74Cy5DCbSOXl9oroUsr5CQgCPYjBfFehAWb4ho/FuugSsaPYS/?=
	=?us-ascii?Q?r39L0BlyejvO/31w4SPKKPFvF8HVSbLnJ9WBFDzqxnFeyuogCeFiR+VwyVDF?=
	=?us-ascii?Q?HOY1aEYwQNZqODMUZSuSxn5qgwpwqpMZ3zCI/FSRYyo8lW92+GO/gLGsNogz?=
	=?us-ascii?Q?PvYchSqKWSOlhnMXUOJLrBOs?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 7041c109-cdce-4103-39c3-08d94cd489ea
X-MS-Exchange-CrossTenant-AuthSource: SJ0PR10MB4752.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 22 Jul 2021 05:49:58.3707 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Awc4zdh34czAaTyDHGt9gzo4pDH6Iv4VBcNXt/fNCob57nezsfSTdAbmXZRVSIaNxZZb4Occ8bywdZT5/XLzrw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR10MB3061
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
X-OrganizationHeadersPreserved: BYAPR10MB3061.namprd10.prod.outlook.com
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=10052
	signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0
	phishscore=0 spamscore=0
	bulkscore=0 mlxlogscore=999 adultscore=0 malwarescore=0 mlxscore=0
	classifier=spam adjust=0 reason=mlx scancount=1
	engine=8.12.0-2104190000 definitions=main-2107220033
Subject: [Ocfs2-devel] [PATCH V2 2/2] ocfs2: issue zeroout to EOF blocks
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
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=10052 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 malwarescore=0 spamscore=0
 mlxscore=0 adultscore=0 mlxlogscore=999 suspectscore=0 bulkscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2104190000
 definitions=main-2107220033
X-Proofpoint-GUID: 30dsAYfE1vQfK6QCMfPcAPpVfxYpHGC7
X-Proofpoint-ORIG-GUID: 30dsAYfE1vQfK6QCMfPcAPpVfxYpHGC7

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

Changes in V2:
 - small code style change

 fs/ocfs2/file.c | 99 ++++++++++++++++++++++++++++++-------------------
 1 file changed, 60 insertions(+), 39 deletions(-)

diff --git a/fs/ocfs2/file.c b/fs/ocfs2/file.c
index 53bb46ce3cbb..54d7843c0211 100644
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
+			goto out;
+		}
+		if (start >= isize)
+			goto out;
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
