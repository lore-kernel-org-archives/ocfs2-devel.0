Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4FB8E229110
	for <ocfs2-devel@lists.linux.dev>; Tue, 15 Oct 2024 16:11:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.177.32
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729008681; cv=none; b=LzQ/DROz5mLr8uyfF8RwnHTmkk/ujvlb0Gq7ZxTGrtM2Y3ky6EadzVnrIgjKS+NE+4ZjqO1BsRZ4Q2AzH+o5hgLzmMT1iWYMV6++3NrEy/Cg30p5u4U0FfTweHOUBM3ryrZUSQemGnloDNShp7cHNVQYaWOQeqOGR/xo1gXiplI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729008681; c=relaxed/simple;
	bh=ncOrUToyppcZSkNNYpe+hhH0X25GGECk5688HUP5KEA=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=ut0MVwzetQBDfHUU4LA7GibqpG1fnEgJpkIs+epK77/gnYJy5rtJzaJqmB/p4YmCEX3YqzPWjaIV/kjwBSCuDIrDpjISpCtOeo0guw/BrugWCzlTjB+lpA7t2wBfqL0dVTAuFqOmTi11E9NhFC+/+/AzuykARnlEdLT5FfdaZGE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=mzIg/oN9; arc=none smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="mzIg/oN9"
Received: from pps.filterd (m0246631.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 49FF0dYJ031410;
	Tue, 15 Oct 2024 16:11:12 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:date:from:message-id:mime-version
	:subject:to; s=corp-2023-11-20; bh=4bzLS8ZpSzBxVkf76IOX/iF/IWqic
	ri5JRzeKExYKsA=; b=mzIg/oN9L2awWuUO9xqKLyrera9XGRlzl/hfXL0/icNuY
	lcYa+pWTPrCOB2xIblF6DBpxsMyO9yMLcMhdgv3e1IHWzQMMlDjm9JQGXeJmSDlh
	1wEZvd3pusiBg4Err3WVzuHKkW8TrcBS9shvY1tNeY+ZBIXBfOJFj+fDpFk1Uplp
	Lgi/xsLKkkrr6quu1yT3V280u8HcuFnDIq5v4VcWt/bGyj/rTZT6YOnraOGObsWx
	GaCQNxK2Ri101FC3L2ZCYSwsjJELjxwuh5FWG+UOoC+jtHJtvVxhxxs1uB6Rh6wB
	qqvPM/edkGNITxQoBar+oiVAIWCXMHARxgh1NpqzA==
Received: from phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta01.appoci.oracle.com [138.1.114.2])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 427fw2hjv6-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 15 Oct 2024 16:11:11 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 49FFCPZH026296;
	Tue, 15 Oct 2024 16:11:11 GMT
Received: from pps.reinject (localhost [127.0.0.1])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 427fj7ntf1-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 15 Oct 2024 16:11:10 +0000
Received: from phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 49FGBA7s005919;
	Tue, 15 Oct 2024 16:11:10 GMT
Received: from gmananth-20230209-1132.osdevelopmeniad.oraclevcn.com (gmananth-20230209-1132.appad3iad.osdevelopmeniad.oraclevcn.com [100.100.242.10])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTP id 427fj7nte1-1;
	Tue, 15 Oct 2024 16:11:10 +0000
From: Gautham Ananthakrishna <gautham.ananthakrishna@oracle.com>
To: ocfs2-devel@lists.linux.dev
Cc: gautham.ananthakrishna@oracle.com, joseph.qi@linux.alibaba.com,
        ghe@suse.com, mark@fasheh.com
Subject: [PATCH RFC 1/1] libocfs2: fix non-zero value in Next Leaf field in the rightmost leaf metadata block
Date: Tue, 15 Oct 2024 16:11:09 +0000
Message-ID: <20241015161109.156497-1-gautham.ananthakrishna@oracle.com>
X-Mailer: git-send-email 2.43.5
Precedence: bulk
X-Mailing-List: ocfs2-devel@lists.linux.dev
List-Id: <ocfs2-devel.lists.linux.dev>
List-Subscribe: <mailto:ocfs2-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:ocfs2-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1051,Hydra:6.0.680,FMLib:17.12.62.30
 definitions=2024-10-15_11,2024-10-15_01,2024-09-30_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 malwarescore=0 adultscore=0
 bulkscore=0 spamscore=0 mlxlogscore=999 phishscore=0 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2409260000
 definitions=main-2410150110
X-Proofpoint-GUID: pt4J5x9S1cGPgiahJfzJ2HKjOVRpgxa3
X-Proofpoint-ORIG-GUID: pt4J5x9S1cGPgiahJfzJ2HKjOVRpgxa3

One of our customers reported read-only filesystem. fsck.ocfs2 -ny showed the
following issue:
Pass 1: Checking inodes and blocks
[EXTENT_LIST_FREE] Extent list in owner 658435 claims 231 as the next free chain record, but fsck believes the largest valid value is 227.  Clamp the next record value? n

debugfs.ocfs2 also showed the corruption:

        Inode: 658435   Mode: 0644   Generation: 974589382 (0x3a170dc6)
        FS Generation: 432631804 (0x19c96ffc)
        CRC32: 00000000   ECC: 0000
        Type: Regular   Attr: 0x0   Flags: Valid
        Dynamic Features: (0x0)
        User: 0 (root)   Group: 0 (root)   Size: 121633767424
        Links: 1   Clusters: 14848000
        ctime: 0x66fa60d8 0x343acc43 -- Mon Sep 30 08:27:04.876268611 2024
        atime: 0x66fa5e5d 0x34514ed8 -- Mon Sep 30 08:16:29.877743832 2024
        mtime: 0x66fa60d8 0x343acc43 -- Mon Sep 30 08:27:04.876268611 2024
        dtime: 0x0 -- Thu Jan  1 00:00:00 1970
        Refcount Block: 0
        Last Extblk: 539186   Orphan Slot: 0
        Sub Alloc Slot: 0   Sub Alloc Bit: 2
        Tree Depth: 1   Count: 227   Next Free Rec: 231
        ## Offset        Clusters       Block#
        0  0             129024         525859
        1  129024        129024         526883

The "Next Free Rec" had overshoot the "Count".

Upon running fsck.ocfs2 -fy, the fsck managed to fix only the
root metadata block and updated it with a new "Last Extblk"

        Inode: 658435   Mode: 0644   Generation: 974589382 (0x3a170dc6)
        FS Generation: 432631804 (0x19c96ffc)
        CRC32: 00000000   ECC: 0000
        Type: Regular   Attr: 0x0   Flags: Valid
        Dynamic Features: (0x0)
        User: 0 (root)   Group: 0 (root)   Size: 121633767424
        Links: 1   Clusters: 14644224
        ctime: 0x66fa60d8 0x343acc43 -- Mon Sep 30 08:27:04.876268611 2024
        atime: 0x66fa5e5d 0x34514ed8 -- Mon Sep 30 08:16:29.877743832 2024
        mtime: 0x66fa60d8 0x343acc43 -- Mon Sep 30 08:27:04.876268611 2024
        dtime: 0x0 -- Thu Jan  1 00:00:00 1970
        Refcount Block: 0
        Last Extblk: 535090   Orphan Slot: 0
        Sub Alloc Slot: 0   Sub Alloc Bit: 2
        Tree Depth: 1   Count: 227   Next Free Rec: 227
        ## Offset        Clusters       Block#
        0  0             129024         525859
        1  129024        129024         526883
        2  258048        129024         536099

However fsck.ocfs2 did not set "Next Leaf" to zero in the updated "Last Extblk".

        SubAlloc Bit: 16   SubAlloc Slot: 0
        Blknum: 535090   Next Leaf: 536114
        CRC32: 00000000   ECC: 0000
        Tree Depth: 0   Count: 252   Next Free Rec: 252
        ## Offset        Clusters       Block#          Flags
        0  29159424      256            7845889         0x0
        1  29159936      256            7846145         0x0

This patch addresses this issue by checking the last leaf metadata block
and setting "Next Leaf" to zero if not done.

Signed-off-by: Gautham Ananthakrishna <gautham.ananthakrishna@oracle.com>
---
 libocfs2/extents.c | 22 ++++++++++++++++++++++
 1 file changed, 22 insertions(+)

diff --git a/libocfs2/extents.c b/libocfs2/extents.c
index d72ae66..c2a3a88 100644
--- a/libocfs2/extents.c
+++ b/libocfs2/extents.c
@@ -277,6 +277,7 @@ static int extent_iterate_el(struct ocfs2_extent_list *el,
 				if (el->l_tree_depth == 1)
 					ctxt->last_eb_blkno =
 							el->l_recs[i].e_blkno;
+
 				ctxt->last_eb_cpos = el->l_recs[i].e_cpos;
 			}
 
@@ -478,6 +479,7 @@ errcode_t ocfs2_extent_iterate_inode(ocfs2_filesys *fs,
 	struct ocfs2_extent_list *el;
 	errcode_t ret;
 	struct extent_context ctxt;
+	struct ocfs2_extent_block *eb;
 
 	ret = OCFS2_ET_INODE_NOT_VALID;
 	if (!(inode->i_flags & OCFS2_VALID_FL))
@@ -543,6 +545,26 @@ out_abort:
 	if (!ret && (iret & OCFS2_EXTENT_CHANGED))
 		ret = ocfs2_write_inode(fs, inode->i_blkno, (char *)inode);
 
+	/*
+	 * Check i_last_eb_blk and set
+	 * its next leaf to zero.
+	 */
+	if (!ret && el->l_tree_depth) {
+		ctxt.errcode = ocfs2_read_extent_block(fs,
+					inode->i_last_eb_blk,
+					ctxt.eb_bufs[0]);
+
+		eb = (struct ocfs2_extent_block *)ctxt.eb_bufs[0];
+
+		if (!ctxt.errcode && eb->h_next_leaf_blk != 0) {
+			eb->h_next_leaf_blk = 0;
+			ctxt.errcode = ocfs2_write_extent_block(fs,
+						inode->i_last_eb_blk,
+						ctxt.eb_bufs[0]);
+		}
+		ret = ctxt.errcode;
+	}
+
 out_eb_bufs:
 	if (ctxt.eb_bufs) {
 		if (!block_buf && ctxt.eb_bufs[0])
-- 
2.43.5

