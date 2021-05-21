Return-Path: <SRS0=za23=KQ=oss.oracle.com=ocfs2-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-19.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,MSGID_FROM_MTA_HEADER,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2D245C04FF3
	for <ocfs2-devel@archiver.kernel.org>; Fri, 21 May 2021 23:38:38 +0000 (UTC)
Received: from aserp2120.oracle.com (aserp2120.oracle.com [141.146.126.78])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id BFCC66121E
	for <ocfs2-devel@archiver.kernel.org>; Fri, 21 May 2021 23:38:37 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org BFCC66121E
Authentication-Results: mail.kernel.org; dmarc=pass (p=none dis=none) header.from=oracle.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=ocfs2-devel-bounces@oss.oracle.com
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
	by aserp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 14LNa8m4057754;
	Fri, 21 May 2021 23:38:34 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : date :
 message-id : mime-version : cc : subject : list-id : list-unsubscribe :
 list-archive : list-post : list-help : list-subscribe : content-type :
 content-transfer-encoding : sender; s=corp-2020-01-29;
 bh=yZuYpVKLjIgOJLJrkcDf4Y63ewRH3YqtEqj86h9pBsM=;
 b=JcoI05peUwI1AzuirnWRyGZOQ5aoJyb0zT+D1WaZRNoE0lKamZ349ZuGnmimHi8Ty/Ud
 Z44/x6Z2RbpgNOSRQut0PF9cQInLvZZ3cupqTIpJELvVXuRlXmiaeSuw/IsZKjcU5by2
 2oYoy0eWyMcnktM/sKtR5Yg6BpFQe2KTuIRHc+qzG1VVVcwiAO85uXqntxNfbAtrUMJB
 0dRUzuGGEgZGfMPq52sBYqnHdxOff+PVM711M73HiA/dBCQ3E0JtrmWRF2NPcoEHoOt7
 0RDYfljzc3yPa+KTU9s/0WbsXjBz5XeKS8eAKvXED72jmV714B7BVsn4eYnQim0duXPG IQ== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
	by aserp2120.oracle.com with ESMTP id 38j68mrvxv-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 21 May 2021 23:38:34 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
	by userp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 14LNVhNw081148;
	Fri, 21 May 2021 23:38:33 GMT
Received: from oss.oracle.com (oss-old-reserved.oracle.com [137.254.22.2])
	by userp3020.oracle.com with ESMTP id 38n4936pjv-1
	(version=TLSv1 cipher=AES256-SHA bits=256 verify=NO);
	Fri, 21 May 2021 23:38:33 +0000
Received: from localhost ([127.0.0.1] helo=lb-oss.oracle.com)
	by oss.oracle.com with esmtp (Exim 4.63)
	(envelope-from <ocfs2-devel-bounces@oss.oracle.com>)
	id 1lkEiu-0004bW-3T; Fri, 21 May 2021 16:38:32 -0700
Received: from userp3030.oracle.com ([156.151.31.80])
	by oss.oracle.com with esmtp (Exim 4.63)
	(envelope-from <junxiao.bi@oracle.com>) id 1lkEiP-0004aa-Ag
	for ocfs2-devel@oss.oracle.com; Fri, 21 May 2021 16:38:01 -0700
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
	by userp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id
	14LNUaE8171046
	for <ocfs2-devel@oss.oracle.com>; Fri, 21 May 2021 23:38:01 GMT
Received: from nam04-dm6-obe.outbound.protection.outlook.com
	(mail-dm6nam08lp2049.outbound.protection.outlook.com [104.47.73.49])
	by userp3030.oracle.com with ESMTP id 38megp08a4-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
	for <ocfs2-devel@oss.oracle.com>; Fri, 21 May 2021 23:38:00 +0000
Authentication-Results: oss.oracle.com; dkim=none (message not signed)
	header.d=none; oss.oracle.com;
	dmarc=none action=none header.from=oracle.com; 
Received: from SJ0PR10MB4752.namprd10.prod.outlook.com (2603:10b6:a03:2d7::19)
	by SJ0PR10MB4414.namprd10.prod.outlook.com (2603:10b6:a03:2d0::20)
	with Microsoft SMTP Server (version=TLS1_2,
	cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4150.26;
	Fri, 21 May 2021 23:37:58 +0000
Received: from SJ0PR10MB4752.namprd10.prod.outlook.com
	([fe80::4519:4046:5549:95d9]) by
	SJ0PR10MB4752.namprd10.prod.outlook.com
	([fe80::4519:4046:5549:95d9%5]) with mapi id 15.20.4129.035;
	Fri, 21 May 2021 23:37:58 +0000
From: Junxiao Bi <junxiao.bi@oracle.com>
To: ocfs2-devel@oss.oracle.com
Date: Fri, 21 May 2021 16:36:12 -0700
Message-Id: <20210521233612.75185-1-junxiao.bi@oracle.com>
X-Mailer: git-send-email 2.24.3 (Apple Git-128)
X-Originating-IP: [73.231.9.254]
X-ClientProxiedBy: SJ0PR03CA0356.namprd03.prod.outlook.com
	(2603:10b6:a03:39c::31) To SJ0PR10MB4752.namprd10.prod.outlook.com
	(2603:10b6:a03:2d7::19)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from dhcp-10-159-150-81.vpn.oracle.com (73.231.9.254) by
	SJ0PR03CA0356.namprd03.prod.outlook.com (2603:10b6:a03:39c::31)
	with Microsoft SMTP Server (version=TLS1_2,
	cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4150.26
	via Frontend Transport; Fri, 21 May 2021 23:37:58 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 3b65fc93-e05e-4115-6851-08d91cb17739
X-MS-TrafficTypeDiagnostic: SJ0PR10MB4414:
X-MS-Exchange-Transport-Forked: True
X-Oracle-Tenancy: 1
X-MS-Oob-TLC-OOBClassifiers: OLM:1284;
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: p8IhQwp+J2UoKXjPViVnMwNbxkBjc7O9PQMzPtLxHflYINtF/MTkqokzV+Ba1COu12k7EDwI4GZyBjCzZWK2gebNjQ/4QMZoTQCe0Q09bV3oJ/RGQxILnZnIqeTEXIyL+UZSN4D9817CTJFwSb5hi2/M0Tb73/hmdYsMwoRJdS0s2sXaPvoQZWfdmNFYGx/yFkaH8exWApdjxPMWmPlJCddHiym1S68mkUzb13G4Yl7tmaQyQfuZFsl6PJjV32gT7IpB0U88iZxjfNQlth07GQL6jIcuKpWjpQwzdT9IITa6REdby9cgJLrIGR9XuSd5bt/wC6r4ZdaQj2pi/s1d7/TQdlHrgBMCJABvG4VciyLdQEis4V37Ktv9WIf1T3BrVQBwgCUIlGSscRKqjYpmgBzdfYnejbGkITvWEX3iSneKkge+TE27G/q3Jetx70whD3h44lkVXPR/t17OldTGA6m2ouSiDIPR4ASyMD/t/Zc53c9k2XoIEl8ypIv5VXEY0pSUd5soHiCvfztJAOWCmcm6Mr36ARlk8zz+M66u5ClNYZ3ku0IPB+FY5tDakP/TqHP9UJ4O6h3ZLnGYLfX1uoWWmK/nI6PRLW0CYK4erLTSb1Q55/CgCryrm4x4jAdIKETJoFg/BspCAr2X+y2FjVHY7XU/owMqdxn68kAm7wQ=
X-Forefront-Antispam-Report: CIP:255.255.255.255; CTRY:; LANG:en; SCL:-1; SRV:; IPV:NLI; SFV:SKI;
	H:SJ0PR10MB4752.namprd10.prod.outlook.com; PTR:; CAT:NONE; SFS:;
	DIR:INB; 
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?Z4C09LHQ7HklWXHUVcJgQ/Nolqt7jkUpUqtq7x+utsxqewqzKKJ6v7CuMOFT?=
	=?us-ascii?Q?Yg3xaGyXrz/fXUgngNh7ICe/RYazniHLlfGaOc9JjM0fZhKU5CpwUZB/D02Q?=
	=?us-ascii?Q?AZCbtd9MmCwHY8uc+BzhGyXoAwn40W9ckwgPFsP7eZGltMTuai4kUhVL6o5A?=
	=?us-ascii?Q?P6U8+l4+3DIyLNw96+sxSwEmnesQA9g3PQ/Md6DuPhuT6xueeWmEDfHqLd57?=
	=?us-ascii?Q?oRSTil0ma1fUKSGkPv/fHobq/MdWH5OS8cvyo+6ApnaZOBQwOnB8uqtgz2Kt?=
	=?us-ascii?Q?8W1i4vss84dR9CeIi7FwRp7PVQzhSdZ52XGXKc5LJ0Mb3q6LJSPyFo4eacUL?=
	=?us-ascii?Q?Nnj8xsRkB3qQdrDXby2V+eTA0RySsvmP4WyJEcXu3IC3KueyHmvJ74gGsQ5x?=
	=?us-ascii?Q?+SoYOVXxMCExDs2O9S1O5M1dhqEJAaeiIsIEqSy2MbXFcWe9AquHKVfWLveJ?=
	=?us-ascii?Q?f4EDzQGUZcZmdk6OmL4CjEU9bbJltnRzjMK6wjbB/I4arweFsyS9ZOAe3y6y?=
	=?us-ascii?Q?aCxykDD+19duok7510QnZEt+3O55pdEBTYiW2KP2c0BBrQSdohnV1Fw1wORY?=
	=?us-ascii?Q?NQOHu6LPBcb43KB+s6eSm779unusGTv8hYg4N7dP7Tl98/Ke/pWMKeITTLlN?=
	=?us-ascii?Q?E9WmmZ6KgFBSTZhF85OtDRMVLUn7pqtUeeP5eDnbT0hB579jIfqp1o8aeba7?=
	=?us-ascii?Q?9VX5BtNjh/AbsgfQmVcSsiAxR/jt0CIAkXqI5aJqbuEHOs4d7UxOxwKQxYRA?=
	=?us-ascii?Q?Sk6aK9ewX1FGpfL43BYaAE5xSxgzByppFny7wYPb4OZFtHnOYvGTPUruTjTG?=
	=?us-ascii?Q?07jCFFqX8zzOnVVZdpdjrQulVhDjDHioSgx3xRfBFYOXWLnMg6XS+0l7W2qx?=
	=?us-ascii?Q?BgO2Kbr8bD8GpXdytBViNp0v70CsqIJrPDtSCkyr3tgIdGBWAuS6kRrOgIn9?=
	=?us-ascii?Q?ei4raOkFcoNQ8Nqaj+kjXtTBjucs9EEaIvVXxQPtaVykt58sv+KHY3PVLbBg?=
	=?us-ascii?Q?vmRIzKakQdIn9sV84TDnuGQCdAAF9MXgOumdXGh/7NCx7fAWtsc6+mc6qRAm?=
	=?us-ascii?Q?GLqpIeDtoxnIwz9GE/dVhPxfSYrHKiFio2V+oAllzAwT+pr6a4KitWzsc6OX?=
	=?us-ascii?Q?oypihK6o/8kaOrYZhF293QKQHi8xHnldFGk9237zr8Q1RuGonxczxcbXS8/n?=
	=?us-ascii?Q?Jw4nMXA1c7tQgG3DDnwkdYQmA0Sbs62zXYFYxxqgRQ0aN+DH37xTa2hf2YGW?=
	=?us-ascii?Q?15FvJvYZVtopi4rQ3iVyTZ5UWNlnKLTv5C66vujI+NsZdAmA+O1pk62xIMQ3?=
	=?us-ascii?Q?ejZFNX2VqgVsuYWRzQ/O11rD?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 3b65fc93-e05e-4115-6851-08d91cb17739
X-MS-Exchange-CrossTenant-AuthSource: SJ0PR10MB4752.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 May 2021 23:37:58.5711 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: HeqMnXUE5X/Hfv6QZmrT7pxpqAuJjC3ZHqFh2Zp5FOFr7DKMMyJCHdSN6jx0uIBC8cGWBDq0thZq3gqhzkFrNw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR10MB4414
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
X-OrganizationHeadersPreserved: SJ0PR10MB4414.namprd10.prod.outlook.com
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9991
	signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999
	phishscore=0
	adultscore=0 malwarescore=0 bulkscore=0 mlxscore=0 spamscore=0
	suspectscore=0 classifier=spam adjust=0 reason=mlx scancount=1
	engine=8.12.0-2104190000 definitions=main-2105210134
Cc: linux-fsdevel@vger.kernel.org, jack@suse.cz
Subject: [Ocfs2-devel] [PATCH v2] ocfs2: fix data corruption by fallocate
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
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9991 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 spamscore=0 bulkscore=0
 suspectscore=0 mlxlogscore=999 adultscore=0 malwarescore=0 mlxscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2104190000
 definitions=main-2105210134
X-Proofpoint-ORIG-GUID: nJcH5LLPl6ESCHmjcKiz5-pTsFLrbBAZ
X-Proofpoint-GUID: nJcH5LLPl6ESCHmjcKiz5-pTsFLrbBAZ
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9991 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 mlxlogscore=999
 priorityscore=1501 impostorscore=0 suspectscore=0 clxscore=1015
 adultscore=0 bulkscore=0 phishscore=0 spamscore=0 malwarescore=0
 lowpriorityscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2104190000 definitions=main-2105210134

When fallocate punches holes out of inode size, if original isize is in
the middle of last cluster, then the part from isize to the end of the
cluster will be zeroed with buffer write, at that time isize is not
yet updated to match the new size, if writeback is kicked in, it will
invoke ocfs2_writepage()->block_write_full_page() where the pages out
of inode size will be dropped. That will cause file corruption. Fix
this by zero out eof blocks when extending the inode size.

Running the following command with qemu-image 4.2.1 can get a corrupted
coverted image file easily.

    qemu-img convert -p -t none -T none -f qcow2 $qcow_image \
             -O qcow2 -o compat=1.1 $qcow_image.conv

The usage of fallocate in qemu is like this, it first punches holes out of
inode size, then extend the inode size.

    fallocate(11, FALLOC_FL_KEEP_SIZE|FALLOC_FL_PUNCH_HOLE, 2276196352, 65536) = 0
    fallocate(11, 0, 2276196352, 65536) = 0

v1: https://www.spinics.net/lists/linux-fsdevel/msg193999.html

Cc: <stable@vger.kernel.org>
Cc: Jan Kara <jack@suse.cz>
Signed-off-by: Junxiao Bi <junxiao.bi@oracle.com>
---

Changes in v2:
- suggested by Jan Kara, using sb_issue_zeroout to zero eof blocks in disk directly.

 fs/ocfs2/file.c | 49 +++++++++++++++++++++++++++++++++++++++++++++++--
 1 file changed, 47 insertions(+), 2 deletions(-)

diff --git a/fs/ocfs2/file.c b/fs/ocfs2/file.c
index f17c3d33fb18..17469fc7b20e 100644
--- a/fs/ocfs2/file.c
+++ b/fs/ocfs2/file.c
@@ -1855,6 +1855,45 @@ int ocfs2_remove_inode_range(struct inode *inode,
 	return ret;
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
 /*
  * Parts of this function taken from xfs_change_file_space()
  */
@@ -1865,7 +1904,7 @@ static int __ocfs2_change_file_space(struct file *file, struct inode *inode,
 {
 	int ret;
 	s64 llen;
-	loff_t size;
+	loff_t size, orig_isize;
 	struct ocfs2_super *osb = OCFS2_SB(inode->i_sb);
 	struct buffer_head *di_bh = NULL;
 	handle_t *handle;
@@ -1896,6 +1935,7 @@ static int __ocfs2_change_file_space(struct file *file, struct inode *inode,
 		goto out_inode_unlock;
 	}
 
+	orig_isize = i_size_read(inode);
 	switch (sr->l_whence) {
 	case 0: /*SEEK_SET*/
 		break;
@@ -1903,7 +1943,7 @@ static int __ocfs2_change_file_space(struct file *file, struct inode *inode,
 		sr->l_start += f_pos;
 		break;
 	case 2: /*SEEK_END*/
-		sr->l_start += i_size_read(inode);
+		sr->l_start += orig_isize;
 		break;
 	default:
 		ret = -EINVAL;
@@ -1957,6 +1997,11 @@ static int __ocfs2_change_file_space(struct file *file, struct inode *inode,
 	default:
 		ret = -EINVAL;
 	}
+
+	/* zeroout eof blocks in the cluster. */
+	if (!ret && change_size && orig_isize < size)
+		ret = ocfs2_zeroout_partial_cluster(inode, orig_isize,
+					size - orig_isize);
 	up_write(&OCFS2_I(inode)->ip_alloc_sem);
 	if (ret) {
 		mlog_errno(ret);
-- 
2.24.3 (Apple Git-128)


_______________________________________________
Ocfs2-devel mailing list
Ocfs2-devel@oss.oracle.com
https://oss.oracle.com/mailman/listinfo/ocfs2-devel
