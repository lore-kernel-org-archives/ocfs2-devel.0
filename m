Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BB5C02E3367;
	Mon, 24 Mar 2025 05:49:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.165.32
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742795348; cv=none; b=D4cXmLTKmV3++Q+PXKxk0P+eF7d2DhGde2Z7m7qw0zRnDuwwILRK8fnlQ1cJtawKy/2O/8/EnY/CCnnE2kyOehke5Bj6RmNCnIMFPfU25Qoh9b6PrFRehN6y0UoHTDIk1Bm7v45tasG17PGzlerUvVemwUHZ0SECrFCbusPNboI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742795348; c=relaxed/simple;
	bh=22Nza6YVg6Hl08wFEYpCSX7842OFYBcYEyhct0nuH4M=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=GD7wnt0eopDk9tdEGT/lHiS5tLKrTGQMB6TyYtVqEptI8aXE/T9M03rxiWU8t/1n8Pffpz47XZLqcey6ikpCe1hHACshZqoDUWATheLUV6ttNMq794ekAUaSMz+Gbiw6RhqjfU50Kb6MOw5qDWp2X2OQZAlfdFcUCtuKlmjBglk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=j5pWZorq; arc=none smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="j5pWZorq"
Received: from pps.filterd (m0246617.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 52O53PrH018397;
	Mon, 24 Mar 2025 05:48:54 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:date:from:message-id:mime-version
	:subject:to; s=corp-2023-11-20; bh=Am3y7YrSEXnSO9u9+2OEQrPFmewbo
	O8WWOH5dmY3jiw=; b=j5pWZorqZ1W5zr9WDp6cN6tprIRxT2l9FP7HxKM+1qeLD
	3Bc5RtEpA+hkyDatm4Tx2mvcky5QMJLf/n2rmoU3Yncm1dwc5qzDIrLZuT85ROYf
	9TA9z34COp8oeT3mPBVxfVsHWFylmq1ppgM7SrR1S9J5vDgW6niURLp7LDF6SRe2
	YREbtDinzhRLMAbkWnBbv0qwbWRou+xgQh1kDt46HXwMSReXYu1yUhcjVATZUEBJ
	srUjg/UeDA0ycA26M+emfOmRiXaZbXTCRzJCXZEpMI2lv0Kj5WDIh6p8GpONOjRN
	2zNJudfCGu1v7nHrLDsk2PZ+O2jlBF+ke+g8NQsQQ==
Received: from phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta03.appoci.oracle.com [138.1.37.129])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 45hnrsb3r6-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 24 Mar 2025 05:48:54 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 52O5imTn008186;
	Mon, 24 Mar 2025 05:48:53 GMT
Received: from pps.reinject (localhost [127.0.0.1])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 45jj6s2s4n-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 24 Mar 2025 05:48:53 +0000
Received: from phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 52O5i3Xb005501;
	Mon, 24 Mar 2025 05:48:53 GMT
Received: from gmananth-20230209-1132.osdevelopmeniad.oraclevcn.com (gmananth-20230209-1132.appad3iad.osdevelopmeniad.oraclevcn.com [100.100.242.10])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTP id 45jj6s2s46-1;
	Mon, 24 Mar 2025 05:48:53 +0000
From: Gautham Ananthakrishna <gautham.ananthakrishna@oracle.com>
To: akpm@linux-foundation.org, joseph.qi@linux.alibaba.com
Cc: gautham.ananthakrishna@oracle.com, linux-kernel@vger.kernel.org,
        ocfs2-devel@lists.linux.dev, rajesh.sivaramasubramaniom@oracle.com,
        junxiao.bi@oracle.com
Subject: [PATCH RFC 1/1] ocfs2: fix write IO performance improvement for high fragmentation
Date: Mon, 24 Mar 2025 05:48:51 +0000
Message-ID: <20250324054851.2509325-1-gautham.ananthakrishna@oracle.com>
X-Mailer: git-send-email 2.43.5
Precedence: bulk
X-Mailing-List: ocfs2-devel@lists.linux.dev
List-Id: <ocfs2-devel.lists.linux.dev>
List-Subscribe: <mailto:ocfs2-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:ocfs2-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1093,Hydra:6.0.680,FMLib:17.12.68.34
 definitions=2025-03-24_03,2025-03-21_01,2024-11-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 mlxlogscore=999 adultscore=0
 phishscore=0 suspectscore=0 malwarescore=0 spamscore=0 bulkscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2502280000
 definitions=main-2503240041
X-Proofpoint-GUID: PpagY3PKd6-1NL-agKWF43wC9LXRbrOm
X-Proofpoint-ORIG-GUID: PpagY3PKd6-1NL-agKWF43wC9LXRbrOm

The commit 4eb7b93e03101fd3f35e69affe566e4b1e3e3dca caused a regression
in our test suite in discontig extent tests. Upon troubleshooting I found
The following issues.

1. The function ocfs2_cluster_group_search() was called for discontig allocations
as well. But it checks only the contiguous bits 'bg_contig_free_bits'.
It hit the ENOSPC in the following case in one of the tests.

ocfs2_mkdir()
 ocfs2_reserve_new_inode()
  ocfs2_reserve_suballoc_bits()
   ocfs2_block_group_alloc()
    ocfs2_block_group_alloc_discontig()
     __ocfs2_claim_clusters()
      ocfs2_claim_suballoc_bits()
       ocfs2_search_chain()
        ocfs2_cluster_group_search()

Looked like the commit did not consider discontig searches. To fix this,
I have split ocfs2_cluster_group_search() into *_common(), *_contig() and
*_discontig()

2. That commit enforced ocfs2_cluster_group_search() to search only the
'bits_wanted' number of bits whereas ocfs2_block_group_find_clear_bits()
fills the best available size and the function ocfs2_cluster_group_search()
itself is supposed to search 'min_bits' at the minimum and need not be
'bits_wanted' always.

Fixed the above issues in this patch.
This patch fixes 4eb7b93e03101fd3f35e69affe566e4b1e3e3dca

Signed-off-by: Gautham Ananthakrishna <gautham.ananthakrishna@oracle.com>
---
 fs/ocfs2/suballoc.c | 146 ++++++++++++++++++++++++++++----------------
 1 file changed, 95 insertions(+), 51 deletions(-)

diff --git a/fs/ocfs2/suballoc.c b/fs/ocfs2/suballoc.c
index 9bffa218bc084..be386e1d8e34d 100644
--- a/fs/ocfs2/suballoc.c
+++ b/fs/ocfs2/suballoc.c
@@ -82,7 +82,17 @@ static int ocfs2_block_group_alloc(struct ocfs2_super *osb,
 				   u64 *last_alloc_group,
 				   int flags);
 
-static int ocfs2_cluster_group_search(struct inode *inode,
+static int ocfs2_cluster_group_search_contig(struct inode *inode,
+				      struct buffer_head *group_bh,
+				      u32 bits_wanted, u32 min_bits,
+				      u64 max_block,
+				      struct ocfs2_suballoc_result *res);
+static int ocfs2_cluster_group_search_common(struct inode *inode,
+				      struct buffer_head *group_bh,
+				      u32 bits_wanted, u32 min_bits,
+				      u64 max_block,
+				      struct ocfs2_suballoc_result *res);
+static int ocfs2_cluster_group_search_discontig(struct inode *inode,
 				      struct buffer_head *group_bh,
 				      u32 bits_wanted, u32 min_bits,
 				      u64 max_block,
@@ -593,6 +603,7 @@ ocfs2_block_group_alloc_discontig(handle_t *handle,
 		goto bail;
 	}
 
+	ac->ac_group_search = ocfs2_cluster_group_search_discontig;
 	status = ocfs2_extend_trans(handle,
 				    ocfs2_calc_bg_discontig_credits(osb->sb));
 	if (status) {
@@ -1127,7 +1138,9 @@ int ocfs2_reserve_cluster_bitmap_bits(struct ocfs2_super *osb,
 	int status;
 
 	ac->ac_which = OCFS2_AC_USE_MAIN;
-	ac->ac_group_search = ocfs2_cluster_group_search;
+
+	/* Make contig search as default */
+	ac->ac_group_search = ocfs2_cluster_group_search_contig;
 
 	status = ocfs2_reserve_suballoc_bits(osb, ac,
 					     GLOBAL_BITMAP_SYSTEM_INODE,
@@ -1525,9 +1538,7 @@ static inline int ocfs2_block_group_reasonably_empty(struct ocfs2_group_desc *bg
 	return le16_to_cpu(bg->bg_free_bits_count) > wanted;
 }
 
-/* return 0 on success, -ENOSPC to keep searching and any other < 0
- * value on error. */
-static int ocfs2_cluster_group_search(struct inode *inode,
+static int ocfs2_cluster_group_search_common(struct inode *inode,
 				      struct buffer_head *group_bh,
 				      u32 bits_wanted, u32 min_bits,
 				      u64 max_block,
@@ -1542,57 +1553,90 @@ static int ocfs2_cluster_group_search(struct inode *inode,
 
 	BUG_ON(!ocfs2_is_cluster_bitmap(inode));
 
+	max_bits = le16_to_cpu(gd->bg_bits);
+
+	/* Tail groups in cluster bitmaps which aren't cpg
+	 * aligned are prone to partial extension by a failed
+	 * fs resize. If the file system resize never got to
+	 * update the dinode cluster count, then we don't want
+	 * to trust any clusters past it, regardless of what
+	 * the group descriptor says. */
+	gd_cluster_off = ocfs2_blocks_to_clusters(inode->i_sb,
+						  le64_to_cpu(gd->bg_blkno));
+	if ((gd_cluster_off + max_bits) >
+	    OCFS2_I(inode)->ip_clusters) {
+		max_bits = OCFS2_I(inode)->ip_clusters - gd_cluster_off;
+		trace_ocfs2_cluster_group_search_wrong_max_bits(
+			(unsigned long long)le64_to_cpu(gd->bg_blkno),
+			le16_to_cpu(gd->bg_bits),
+			OCFS2_I(inode)->ip_clusters, max_bits);
+	}
+
+	ret = ocfs2_block_group_find_clear_bits(osb,
+						group_bh, bits_wanted,
+						max_bits, res);
+	if (ret)
+		return ret;
+
+	if (max_block) {
+		blkoff = ocfs2_clusters_to_blocks(inode->i_sb,
+						  gd_cluster_off +
+						  res->sr_bit_offset +
+						  res->sr_bits);
+		trace_ocfs2_cluster_group_search_max_block(
+			(unsigned long long)blkoff,
+			(unsigned long long)max_block);
+		if (blkoff > max_block)
+			return -ENOSPC;
+	}
+
+	/* ocfs2_block_group_find_clear_bits() might
+	 * return success, but we still want to return
+	 * -ENOSPC unless it found the minimum number
+	 * of bits. */
+	if (min_bits <= res->sr_bits)
+		search = 0; /* success */
+
+	return search;
+}
+
+static int ocfs2_cluster_group_search_discontig(struct inode *inode,
+				      struct buffer_head *group_bh,
+				      u32 bits_wanted, u32 min_bits,
+				      u64 max_block,
+				      struct ocfs2_suballoc_result *res)
+{
+	int search = -ENOSPC;
+	struct ocfs2_group_desc *gd = (struct ocfs2_group_desc *) group_bh->b_data;
+
+	if (le16_to_cpu(gd->bg_free_bits_count) >= min_bits)
+		search = ocfs2_cluster_group_search_common(inode, group_bh,
+							   bits_wanted, min_bits,
+							   max_block, res);
+	return search;
+}
+
+/* return 0 on success, -ENOSPC to keep searching and any other < 0
+ * value on error. */
+static int ocfs2_cluster_group_search_contig(struct inode *inode,
+				      struct buffer_head *group_bh,
+				      u32 bits_wanted, u32 min_bits,
+				      u64 max_block,
+				      struct ocfs2_suballoc_result *res)
+{
+	int search = -ENOSPC;
+	struct ocfs2_group_desc *gd = (struct ocfs2_group_desc *) group_bh->b_data;
+
+
 	if (le16_to_cpu(gd->bg_contig_free_bits) &&
 	    le16_to_cpu(gd->bg_contig_free_bits) < bits_wanted)
 		return -ENOSPC;
 
 	/* ->bg_contig_free_bits may un-initialized, so compare again */
-	if (le16_to_cpu(gd->bg_free_bits_count) >= bits_wanted) {
-		max_bits = le16_to_cpu(gd->bg_bits);
-
-		/* Tail groups in cluster bitmaps which aren't cpg
-		 * aligned are prone to partial extension by a failed
-		 * fs resize. If the file system resize never got to
-		 * update the dinode cluster count, then we don't want
-		 * to trust any clusters past it, regardless of what
-		 * the group descriptor says. */
-		gd_cluster_off = ocfs2_blocks_to_clusters(inode->i_sb,
-							  le64_to_cpu(gd->bg_blkno));
-		if ((gd_cluster_off + max_bits) >
-		    OCFS2_I(inode)->ip_clusters) {
-			max_bits = OCFS2_I(inode)->ip_clusters - gd_cluster_off;
-			trace_ocfs2_cluster_group_search_wrong_max_bits(
-				(unsigned long long)le64_to_cpu(gd->bg_blkno),
-				le16_to_cpu(gd->bg_bits),
-				OCFS2_I(inode)->ip_clusters, max_bits);
-		}
-
-		ret = ocfs2_block_group_find_clear_bits(osb,
-							group_bh, bits_wanted,
-							max_bits, res);
-		if (ret)
-			return ret;
-
-		if (max_block) {
-			blkoff = ocfs2_clusters_to_blocks(inode->i_sb,
-							  gd_cluster_off +
-							  res->sr_bit_offset +
-							  res->sr_bits);
-			trace_ocfs2_cluster_group_search_max_block(
-				(unsigned long long)blkoff,
-				(unsigned long long)max_block);
-			if (blkoff > max_block)
-				return -ENOSPC;
-		}
-
-		/* ocfs2_block_group_find_clear_bits() might
-		 * return success, but we still want to return
-		 * -ENOSPC unless it found the minimum number
-		 * of bits. */
-		if (min_bits <= res->sr_bits)
-			search = 0; /* success */
-	}
-
+	if (le16_to_cpu(gd->bg_free_bits_count) >= bits_wanted)
+		search = ocfs2_cluster_group_search_common(inode, group_bh,
+							   bits_wanted, min_bits,
+							   max_block, res);
 	return search;
 }
 
-- 
2.43.5

