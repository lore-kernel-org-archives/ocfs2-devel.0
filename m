Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6AB3B17ADE2
	for <ocfs2-devel@lists.linux.dev>; Tue, 10 Sep 2024 04:40:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.165.32
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725943257; cv=none; b=Mi2oCBDPmvR/SgXzrwUWCo88OjXOm836wvht0iDAqp3iBmkAYymjDxpN7kNsyWXeJaq8mpS6GT6s4Sxw73xgXmV5zfmTj367POjrTqtxYcUYXaLNkMVyxgthZJmgLAazD4N1l/b7cMS85DLOFfQqn23GABtHJUx3O8ki4OYZP/I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725943257; c=relaxed/simple;
	bh=LYPJYmRGPuWIQI7MxAV4tFKAbX4znCi6gd/93MIJhuM=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=fw9xMZp9A7+bsEGgZliJCPRv9CKl3UJoKU/EnFnbQxrg0XnV1ZbvopK5tnQKMEeNyntNf+tlR0isHhfVtslA7oJzgvd003cLppHDd+rlnJFoMgEQl7cGQLmSPggr96XfPwcUpVZONwyhjqiAAHliHVA5rheXyhi3X7QnuZI8BzY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=oe8wwcG3; arc=none smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="oe8wwcG3"
Received: from pps.filterd (m0246629.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 48A2tVXr020454;
	Tue, 10 Sep 2024 04:40:48 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=
	from:to:cc:subject:date:message-id:mime-version
	:content-transfer-encoding; s=corp-2023-11-20; bh=bFsHWpijZBnbG2
	v0Z/CmAKGrSERhkPXMGxrB2aTn5Hw=; b=oe8wwcG3pnO0t+5vJZe4ESdcNFoUAB
	sa/7uuUa7XbpWVCyIa8351c8WdSdQvCfIxDdSXVitYyxuyEO6zE2zxqlUMoe0R/a
	YnBApuekR1+MKBGm0jxPLqV8iD1B7vqxKXjlOe8yAPfZkvY8RUSJQEA1X/GDKzBo
	Q99snmAeY71AywxTmfs8q+LDVwQHRp/TVb4Je0AHSeVFZuMhlgsrqRrDq1sxNZU1
	O1jMyr1VbMJEK0WBg7GOnJwYQC1PPuYa0dYvgiZ6OQeElbcpQSUsC544b/1RFbf5
	V4vBS5tH9YOho43dTaF3C83rqCdMjPsWeKv+4Awybt9nhr/Vx4cD7+bw==
Received: from iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta03.appoci.oracle.com [130.35.103.27])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 41geq9mgvc-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 10 Sep 2024 04:40:48 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 48A3H6c7005931;
	Tue, 10 Sep 2024 04:40:47 GMT
Received: from pps.reinject (localhost [127.0.0.1])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 41gd981yx3-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 10 Sep 2024 04:40:47 +0000
Received: from iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 48A4ZkR5014596;
	Tue, 10 Sep 2024 04:40:46 GMT
Received: from gmananth-20230209-1132.osdevelopmeniad.oraclevcn.com (gmananth-20230209-1132.appad3iad.osdevelopmeniad.oraclevcn.com [100.100.242.10])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTP id 41gd981ywf-1;
	Tue, 10 Sep 2024 04:40:46 +0000
From: Gautham Ananthakrishna <gautham.ananthakrishna@oracle.com>
To: joseph.qi@linux.alibaba.com
Cc: gautham.ananthakrishna@oracle.com, junxiao.bi@oracle.com,
        rajesh.sivaramasubramaniom@oracle.com, ocfs2-devel@lists.linux.dev
Subject: [PATCH RFC 1/1] ocfs2: reserve space for inline xattr before attaching reflink tree
Date: Tue, 10 Sep 2024 04:40:45 +0000
Message-Id: <20240910044045.257958-1-gautham.ananthakrishna@oracle.com>
X-Mailer: git-send-email 2.39.3
Precedence: bulk
X-Mailing-List: ocfs2-devel@lists.linux.dev
List-Id: <ocfs2-devel.lists.linux.dev>
List-Subscribe: <mailto:ocfs2-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:ocfs2-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1039,Hydra:6.0.680,FMLib:17.12.60.29
 definitions=2024-09-09_12,2024-09-09_02,2024-09-02_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 malwarescore=0
 mlxlogscore=999 bulkscore=0 adultscore=0 phishscore=0 suspectscore=0
 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2408220000 definitions=main-2409100032
X-Proofpoint-ORIG-GUID: mNKS0f3s2maDjx5dwxspdLl3iUcuvIVI
X-Proofpoint-GUID: mNKS0f3s2maDjx5dwxspdLl3iUcuvIVI

One of our customers reported a crash and a corrupted ocfs2 filesystem.
The crash was due to the detection of corruption. Upon troubleshooting,
the fsck -fn output showed the below corruption

[EXTENT_LIST_FREE] Extent list in owner 33080590 claims 230 as the next free chain record,
but fsck believes the largest valid value is 227.  Clamp the next record value? n

The stat output from the debugfs.ocfs2 showed the following corruption
where the "Next Free Rec:" had overshot the "Count:" in the root metadata
block.

        Inode: 33080590   Mode: 0640   Generation: 2619713622 (0x9c25a856)
        FS Generation: 904309833 (0x35e6ac49)
        CRC32: 00000000   ECC: 0000
        Type: Regular   Attr: 0x0   Flags: Valid
        Dynamic Features: (0x16) HasXattr InlineXattr Refcounted
        Extended Attributes Block: 0  Extended Attributes Inline Size: 256
        User: 0 (root)   Group: 0 (root)   Size: 281320357888
        Links: 1   Clusters: 141738
        ctime: 0x66911b56 0x316edcb8 -- Fri Jul 12 06:02:30.829349048 2024
        atime: 0x66911d6b 0x7f7a28d -- Fri Jul 12 06:11:23.133669517 2024
        mtime: 0x66911b56 0x12ed75d7 -- Fri Jul 12 06:02:30.317552087 2024
        dtime: 0x0 -- Wed Dec 31 17:00:00 1969
        Refcount Block: 2777346
        Last Extblk: 2886943   Orphan Slot: 0
        Sub Alloc Slot: 0   Sub Alloc Bit: 14
        Tree Depth: 1   Count: 227   Next Free Rec: 230
        ## Offset        Clusters       Block#
        0  0             2310           2776351
        1  2310          2139           2777375
        2  4449          1221           2778399
        3  5670          731            2779423
        4  6401          566            2780447
        .......          ....           .......
        .......          ....           .......

The issue was in the reflink workfow while reserving space for inline xattr.
The problematic function is ocfs2_reflink_xattr_inline(). By the time this
function is called the reflink tree is already recreated at the destination
inode from the source inode. At this point, this function reserves space
space inline xattrs at the destination inode without even checking if there
is space at the root metadata block. It simply reduces the l_count from 243
to 227 thereby making space of 256 bytes for inline xattr whereas the inode
already has extents beyond this index (in this case upto 230), thereby causing
corruption.

The fix for this is to reserve space for inline metadata before the at the
destination inode before the reflink tree gets recreated. The customer has
verified the fix.

Signed-off-by: Gautham Ananthakrishna <gautham.ananthakrishna@oracle.com>
---
 fs/ocfs2/refcounttree.c | 18 ++++++++++++++++++
 fs/ocfs2/xattr.c        | 11 +----------
 2 files changed, 19 insertions(+), 10 deletions(-)

diff --git a/fs/ocfs2/refcounttree.c b/fs/ocfs2/refcounttree.c
index 3f80a56d0d60..c0edb32a7ff6 100644
--- a/fs/ocfs2/refcounttree.c
+++ b/fs/ocfs2/refcounttree.c
@@ -25,6 +25,7 @@
 #include "namei.h"
 #include "ocfs2_trace.h"
 #include "file.h"
+#include "symlink.h"
 
 #include <linux/bio.h>
 #include <linux/blkdev.h>
@@ -4182,6 +4183,23 @@ static int __ocfs2_reflink(struct dentry *old_dentry,
 		goto out_unlock;
 	}
 
+	if ((OCFS2_I(inode)->ip_dyn_features & OCFS2_HAS_XATTR_FL) &&
+		(OCFS2_I(inode)->ip_dyn_features & OCFS2_INLINE_XATTR_FL)) {
+		/*
+		 * Adjust extent record count to reserve space for extended attribute.
+		 * Inline data count had been adjusted in ocfs2_duplicate_inline_data().
+		 */
+		if (!(OCFS2_I(new_inode)->ip_dyn_features & OCFS2_INLINE_DATA_FL) &&
+			!(ocfs2_inode_is_fast_symlink(new_inode))) {
+			struct ocfs2_dinode *new_di = new_bh->b_data;
+			struct ocfs2_dinode *old_di = old_bh->b_data;
+			struct ocfs2_extent_list *el = &new_di->id2.i_list;
+			int inline_size = le16_to_cpu(old_di->i_xattr_inline_size);
+			le16_add_cpu(&el->l_count, -(inline_size /
+					sizeof(struct ocfs2_extent_rec)));
+		}
+	}
+
 	ret = ocfs2_create_reflink_node(inode, old_bh,
 					new_inode, new_bh, preserve);
 	if (ret) {
diff --git a/fs/ocfs2/xattr.c b/fs/ocfs2/xattr.c
index 3b81213ed7b8..a9f716ec89e2 100644
--- a/fs/ocfs2/xattr.c
+++ b/fs/ocfs2/xattr.c
@@ -6511,16 +6511,7 @@ static int ocfs2_reflink_xattr_inline(struct ocfs2_xattr_reflink *args)
 	}
 
 	new_oi = OCFS2_I(args->new_inode);
-	/*
-	 * Adjust extent record count to reserve space for extended attribute.
-	 * Inline data count had been adjusted in ocfs2_duplicate_inline_data().
-	 */
-	if (!(new_oi->ip_dyn_features & OCFS2_INLINE_DATA_FL) &&
-	    !(ocfs2_inode_is_fast_symlink(args->new_inode))) {
-		struct ocfs2_extent_list *el = &new_di->id2.i_list;
-		le16_add_cpu(&el->l_count, -(inline_size /
-					sizeof(struct ocfs2_extent_rec)));
-	}
+
 	spin_lock(&new_oi->ip_lock);
 	new_oi->ip_dyn_features |= OCFS2_HAS_XATTR_FL | OCFS2_INLINE_XATTR_FL;
 	new_di->i_dyn_features = cpu_to_le16(new_oi->ip_dyn_features);
-- 
2.39.3

