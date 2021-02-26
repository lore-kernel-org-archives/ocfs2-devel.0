Return-Path: <SRS0=7w/S=H4=oss.oracle.com=ocfs2-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.7 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4BA9BC43381
	for <ocfs2-devel@archiver.kernel.org>; Fri, 26 Feb 2021 16:55:37 +0000 (UTC)
Received: from userp2130.oracle.com (userp2130.oracle.com [156.151.31.86])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id DC89964ED2
	for <ocfs2-devel@archiver.kernel.org>; Fri, 26 Feb 2021 16:55:36 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org DC89964ED2
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=fujitsu.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=ocfs2-devel-bounces@oss.oracle.com
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
	by userp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 11QGtOLV085516;
	Fri, 26 Feb 2021 16:55:36 GMT
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
	by userp2130.oracle.com with ESMTP id 36tsuranv1-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 26 Feb 2021 16:55:36 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
	by userp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 11QGsf1o118601;
	Fri, 26 Feb 2021 16:55:35 GMT
Received: from oss.oracle.com (oss-old-reserved.oracle.com [137.254.22.2])
	by userp3030.oracle.com with ESMTP id 36ucc2uqrk-1
	(version=TLSv1 cipher=AES256-SHA bits=256 verify=NO);
	Fri, 26 Feb 2021 16:55:35 +0000
Received: from localhost ([127.0.0.1] helo=lb-oss.oracle.com)
	by oss.oracle.com with esmtp (Exim 4.63)
	(envelope-from <ocfs2-devel-bounces@oss.oracle.com>)
	id 1lFgOs-0000ax-C6; Fri, 26 Feb 2021 08:55:34 -0800
Received: from userp3030.oracle.com ([156.151.31.80])
	by oss.oracle.com with esmtp (Exim 4.63)
	(envelope-from <ruansy.fnst@fujitsu.com>) id 1lFQsK-0006B1-9d
	for ocfs2-devel@oss.oracle.com; Thu, 25 Feb 2021 16:20:56 -0800
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
	by userp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id
	11Q0AdaD159871
	for <ocfs2-devel@oss.oracle.com>; Fri, 26 Feb 2021 00:20:56 GMT
Received: from userp2030.oracle.com (userp2030.oracle.com [156.151.31.89])
	by userp3030.oracle.com with ESMTP id 36ucc1x6nw-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
	for <ocfs2-devel@oss.oracle.com>; Fri, 26 Feb 2021 00:20:55 +0000
Received: from pps.filterd (userp2030.oracle.com [127.0.0.1])
	by userp2030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id
	11Q0D22Y009039
	for <ocfs2-devel@oss.oracle.com>; Fri, 26 Feb 2021 00:20:55 GMT
Received: from heian.cn.fujitsu.com (mail.cn.fujitsu.com [183.91.158.132])
	by userp2030.oracle.com with ESMTP id 36wqdygtd8-3
	for <ocfs2-devel@oss.oracle.com>; Fri, 26 Feb 2021 00:20:54 +0000
X-IronPort-AV: E=Sophos;i="5.81,207,1610380800"; d="scan'208";a="104882811"
Received: from unknown (HELO cn.fujitsu.com) ([10.167.33.5])
	by heian.cn.fujitsu.com with ESMTP; 26 Feb 2021 08:20:53 +0800
Received: from G08CNEXMBPEKD04.g08.fujitsu.local (unknown [10.167.33.201])
	by cn.fujitsu.com (Postfix) with ESMTP id EDF534CE1A08;
	Fri, 26 Feb 2021 08:20:51 +0800 (CST)
Received: from G08CNEXCHPEKD04.g08.fujitsu.local (10.167.33.200) by
	G08CNEXMBPEKD04.g08.fujitsu.local (10.167.33.201) with Microsoft SMTP
	Server (TLS) id 15.0.1497.2; Fri, 26 Feb 2021 08:20:47 +0800
Received: from irides.mr.mr.mr (10.167.225.141) by
	G08CNEXCHPEKD04.g08.fujitsu.local (10.167.33.209) with Microsoft SMTP
	Server
	id 15.0.1497.2 via Frontend Transport; Fri, 26 Feb 2021 08:20:46 +0800
From: Shiyang Ruan <ruansy.fnst@fujitsu.com>
To: <linux-kernel@vger.kernel.org>, <linux-xfs@vger.kernel.org>,
        <linux-nvdimm@lists.01.org>, <linux-fsdevel@vger.kernel.org>
Date: Fri, 26 Feb 2021 08:20:22 +0800
Message-ID: <20210226002030.653855-3-ruansy.fnst@fujitsu.com>
X-Mailer: git-send-email 2.30.1
In-Reply-To: <20210226002030.653855-1-ruansy.fnst@fujitsu.com>
References: <20210226002030.653855-1-ruansy.fnst@fujitsu.com>
MIME-Version: 1.0
X-yoursite-MailScanner-ID: EDF534CE1A08.A5F5A
X-yoursite-MailScanner: Found to be clean
X-yoursite-MailScanner-From: ruansy.fnst@fujitsu.com
X-PDR: PASS
X-Source-IP: 183.91.158.132
X-ServerName: mail.cn.fujitsu.com
X-Proofpoint-SPF-Result: neutral
X-Proofpoint-SPF-Record: v=spf1 ip4:211.128.242.0/26 ip4:202.219.69.128/26
	ip4:207.54.90.47
	ip4:207.54.90.48 ip4:207.54.90.49 ip4:68.232.139.117 ip4:68.232.139.130
	ip4:68.232.139.139 include:spf.protection.outlook.com
	include:mktomail.com
	mx:fujitsu.com include:spf.messagelabs.com ?all
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9906
	signatures=668683
X-Proofpoint-Spam-Details: rule=tap_notspam policy=tap score=0
	lowpriorityscore=0 spamscore=0
	malwarescore=0 bulkscore=0 impostorscore=0 mlxscore=0 adultscore=0
	suspectscore=0 priorityscore=0 mlxlogscore=999 phishscore=0
	clxscore=285
	classifier=spam adjust=0 reason=mlx scancount=1
	engine=8.12.0-2009150000 definitions=main-2102250184
X-Spam: Clean
X-Mailman-Approved-At: Fri, 26 Feb 2021 08:55:31 -0800
Cc: jack@suse.cz, darrick.wong@oracle.com, david@fromorbit.com,
        ocfs2-devel@oss.oracle.com, viro@zeniv.linux.org.uk,
        dan.j.williams@intel.com, linux-btrfs@vger.kernel.org
Subject: [Ocfs2-devel] [PATCH v2 02/10] fsdax: Factor helper:
	dax_fault_actor()
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
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9907 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 adultscore=0
 phishscore=0 spamscore=0 suspectscore=0 bulkscore=0 malwarescore=0
 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2102260125
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9907 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 spamscore=0
 priorityscore=1501 impostorscore=0 bulkscore=0 mlxscore=0 malwarescore=0
 clxscore=1015 phishscore=0 mlxlogscore=999 lowpriorityscore=0 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2102260125

The core logic in the two dax page fault functions is similar. So, move
the logic into a common helper function. Also, to facilitate the
addition of new features, such as CoW, switch-case is no longer used to
handle different iomap types.

Signed-off-by: Shiyang Ruan <ruansy.fnst@fujitsu.com>
---
 fs/dax.c | 211 ++++++++++++++++++++++++++++++-------------------------
 1 file changed, 117 insertions(+), 94 deletions(-)

diff --git a/fs/dax.c b/fs/dax.c
index 7031e4302b13..9dea1572868e 100644
--- a/fs/dax.c
+++ b/fs/dax.c
@@ -1289,6 +1289,93 @@ static int dax_fault_cow_page(struct vm_fault *vmf, struct iomap *iomap,
 	return 0;
 }
 
+static vm_fault_t dax_fault_insert_pfn(struct vm_fault *vmf, pfn_t pfn,
+		bool pmd, bool write)
+{
+	vm_fault_t ret;
+
+	if (!pmd) {
+		struct vm_area_struct *vma = vmf->vma;
+		unsigned long address = vmf->address;
+
+		if (write)
+			ret = vmf_insert_mixed_mkwrite(vma, address, pfn);
+		else
+			ret = vmf_insert_mixed(vma, address, pfn);
+	} else
+		ret = vmf_insert_pfn_pmd(vmf, pfn, write);
+
+	return ret;
+}
+
+#ifdef CONFIG_FS_DAX_PMD
+static vm_fault_t dax_pmd_load_hole(struct xa_state *xas, struct vm_fault *vmf,
+		struct iomap *iomap, void **entry);
+#else
+static vm_fault_t dax_pmd_load_hole(struct xa_state *xas, struct vm_fault *vmf,
+		struct iomap *iomap, void **entry)
+{
+	return VM_FAULT_FALLBACK;
+}
+#endif
+
+/**
+ * dax_fault_actor - Common actor to handle pfn insertion in PTE/PMD fault.
+ * @vmf:	vm fault instance
+ * @pfnp:	pfn to be returned
+ * @xas:	the dax mapping tree of a file
+ * @entry:	an unlocked dax entry to be inserted
+ * @pmd:	distinguish whether it is a pmd fault
+ * @flags:	iomap flags
+ * @iomap:	from iomap_begin()
+ * @srcmap:	from iomap_begin(), not equal to iomap if it is a CoW
+ */
+static vm_fault_t dax_fault_actor(struct vm_fault *vmf, pfn_t *pfnp,
+		struct xa_state *xas, void *entry, bool pmd, unsigned int flags,
+		struct iomap *iomap, struct iomap *srcmap)
+{
+	struct address_space *mapping = vmf->vma->vm_file->f_mapping;
+	size_t size = pmd ? PMD_SIZE : PAGE_SIZE;
+	loff_t pos = (loff_t)xas->xa_offset << PAGE_SHIFT;
+	bool write = vmf->flags & FAULT_FLAG_WRITE;
+	bool sync = dax_fault_is_synchronous(flags, vmf->vma, iomap);
+	vm_fault_t ret = 0;
+	int err = 0;
+	pfn_t pfn;
+
+	/* if we are reading UNWRITTEN and HOLE, return a hole. */
+	if (!write &&
+	    (iomap->type == IOMAP_UNWRITTEN || iomap->type == IOMAP_HOLE)) {
+		if (!pmd)
+			return dax_load_hole(xas, mapping, &entry, vmf);
+		else
+			return dax_pmd_load_hole(xas, vmf, iomap, &entry);
+	}
+
+	if (iomap->type != IOMAP_MAPPED) {
+		WARN_ON_ONCE(1);
+		return VM_FAULT_SIGBUS;
+	}
+
+	err = dax_iomap_pfn(iomap, pos, size, &pfn);
+	if (err)
+		goto error_fault;
+
+	entry = dax_insert_entry(xas, mapping, vmf, entry, pfn, 0,
+				 write && !sync);
+
+	if (sync)
+		return dax_fault_synchronous_pfnp(pfnp, pfn);
+
+	ret = dax_fault_insert_pfn(vmf, pfn, pmd, write);
+
+error_fault:
+	if (err)
+		ret = dax_fault_return(err);
+
+	return ret;
+}
+
 static vm_fault_t dax_iomap_pte_fault(struct vm_fault *vmf, pfn_t *pfnp,
 			       int *iomap_errp, const struct iomap_ops *ops)
 {
@@ -1296,17 +1383,14 @@ static vm_fault_t dax_iomap_pte_fault(struct vm_fault *vmf, pfn_t *pfnp,
 	struct address_space *mapping = vma->vm_file->f_mapping;
 	XA_STATE(xas, &mapping->i_pages, vmf->pgoff);
 	struct inode *inode = mapping->host;
-	unsigned long vaddr = vmf->address;
 	loff_t pos = (loff_t)vmf->pgoff << PAGE_SHIFT;
 	struct iomap iomap = { .type = IOMAP_HOLE };
 	struct iomap srcmap = { .type = IOMAP_HOLE };
 	unsigned flags = IOMAP_FAULT;
 	int error, major = 0;
 	bool write = vmf->flags & FAULT_FLAG_WRITE;
-	bool sync;
 	vm_fault_t ret = 0;
 	void *entry;
-	pfn_t pfn;
 
 	trace_dax_pte_fault(inode, vmf, ret);
 	/*
@@ -1352,8 +1436,8 @@ static vm_fault_t dax_iomap_pte_fault(struct vm_fault *vmf, pfn_t *pfnp,
 		goto unlock_entry;
 	}
 	if (WARN_ON_ONCE(iomap.offset + iomap.length < pos + PAGE_SIZE)) {
-		error = -EIO;	/* fs corruption? */
-		goto error_finish_iomap;
+		ret = VM_FAULT_SIGBUS;	/* fs corruption? */
+		goto finish_iomap;
 	}
 
 	if (vmf->cow_page) {
@@ -1363,49 +1447,19 @@ static vm_fault_t dax_iomap_pte_fault(struct vm_fault *vmf, pfn_t *pfnp,
 		goto finish_iomap;
 	}
 
-	sync = dax_fault_is_synchronous(flags, vma, &iomap);
-
-	switch (iomap.type) {
-	case IOMAP_MAPPED:
-		if (iomap.flags & IOMAP_F_NEW) {
-			count_vm_event(PGMAJFAULT);
-			count_memcg_event_mm(vma->vm_mm, PGMAJFAULT);
-			major = VM_FAULT_MAJOR;
-		}
-		error = dax_iomap_pfn(&iomap, pos, PAGE_SIZE, &pfn);
-		if (error < 0)
-			goto error_finish_iomap;
-
-		entry = dax_insert_entry(&xas, mapping, vmf, entry, pfn,
-						 0, write && !sync);
-
-		if (sync) {
-			ret = dax_fault_synchronous_pfnp(pfnp, pfn);
-			goto finish_iomap;
-		}
-		trace_dax_insert_mapping(inode, vmf, entry);
-		if (write)
-			ret = vmf_insert_mixed_mkwrite(vma, vaddr, pfn);
-		else
-			ret = vmf_insert_mixed(vma, vaddr, pfn);
-
+	ret = dax_fault_actor(vmf, pfnp, &xas, entry, false, flags,
+			      &iomap, &srcmap);
+	if (ret == VM_FAULT_SIGBUS)
 		goto finish_iomap;
-	case IOMAP_UNWRITTEN:
-	case IOMAP_HOLE:
-		if (!write) {
-			ret = dax_load_hole(&xas, mapping, &entry, vmf);
-			goto finish_iomap;
-		}
-		fallthrough;
-	default:
-		WARN_ON_ONCE(1);
-		error = -EIO;
-		break;
+
+	/* read/write MAPPED, CoW UNWRITTEN */
+	if (iomap.flags & IOMAP_F_NEW) {
+		count_vm_event(PGMAJFAULT);
+		count_memcg_event_mm(vma->vm_mm, PGMAJFAULT);
+		major = VM_FAULT_MAJOR;
 	}
 
- error_finish_iomap:
-	ret = dax_fault_return(error);
- finish_iomap:
+finish_iomap:
 	if (ops->iomap_end) {
 		int copied = PAGE_SIZE;
 
@@ -1419,9 +1473,9 @@ static vm_fault_t dax_iomap_pte_fault(struct vm_fault *vmf, pfn_t *pfnp,
 		 */
 		ops->iomap_end(inode, pos, PAGE_SIZE, copied, flags, &iomap);
 	}
- unlock_entry:
+unlock_entry:
 	dax_unlock_entry(&xas, entry);
- out:
+out:
 	trace_dax_pte_fault_done(inode, vmf, ret);
 	return ret | major;
 }
@@ -1519,17 +1573,15 @@ static vm_fault_t dax_iomap_pmd_fault(struct vm_fault *vmf, pfn_t *pfnp,
 	struct address_space *mapping = vma->vm_file->f_mapping;
 	XA_STATE_ORDER(xas, &mapping->i_pages, vmf->pgoff, PMD_ORDER);
 	bool write = vmf->flags & FAULT_FLAG_WRITE;
-	bool sync;
-	unsigned int iomap_flags = (write ? IOMAP_WRITE : 0) | IOMAP_FAULT;
+	unsigned int flags = (write ? IOMAP_WRITE : 0) | IOMAP_FAULT;
 	struct inode *inode = mapping->host;
-	vm_fault_t result = VM_FAULT_FALLBACK;
+	vm_fault_t ret = VM_FAULT_FALLBACK;
 	struct iomap iomap = { .type = IOMAP_HOLE };
 	struct iomap srcmap = { .type = IOMAP_HOLE };
 	pgoff_t max_pgoff;
 	void *entry;
 	loff_t pos;
 	int error;
-	pfn_t pfn;
 
 	/*
 	 * Check whether offset isn't beyond end of file now. Caller is
@@ -1541,7 +1593,7 @@ static vm_fault_t dax_iomap_pmd_fault(struct vm_fault *vmf, pfn_t *pfnp,
 	trace_dax_pmd_fault(inode, vmf, max_pgoff, 0);
 
 	if (xas.xa_index >= max_pgoff) {
-		result = VM_FAULT_SIGBUS;
+		ret = VM_FAULT_SIGBUS;
 		goto out;
 	}
 
@@ -1556,7 +1608,7 @@ static vm_fault_t dax_iomap_pmd_fault(struct vm_fault *vmf, pfn_t *pfnp,
 	 */
 	entry = grab_mapping_entry(&xas, mapping, PMD_ORDER);
 	if (xa_is_internal(entry)) {
-		result = xa_to_internal(entry);
+		ret = xa_to_internal(entry);
 		goto fallback;
 	}
 
@@ -1568,7 +1620,7 @@ static vm_fault_t dax_iomap_pmd_fault(struct vm_fault *vmf, pfn_t *pfnp,
 	 */
 	if (!pmd_none(*vmf->pmd) && !pmd_trans_huge(*vmf->pmd) &&
 			!pmd_devmap(*vmf->pmd)) {
-		result = 0;
+		ret = 0;
 		goto unlock_entry;
 	}
 
@@ -1578,49 +1630,21 @@ static vm_fault_t dax_iomap_pmd_fault(struct vm_fault *vmf, pfn_t *pfnp,
 	 * to look up our filesystem block.
 	 */
 	pos = (loff_t)xas.xa_index << PAGE_SHIFT;
-	error = ops->iomap_begin(inode, pos, PMD_SIZE, iomap_flags, &iomap,
-			&srcmap);
+	error = ops->iomap_begin(inode, pos, PMD_SIZE, flags, &iomap, &srcmap);
 	if (error)
 		goto unlock_entry;
 
 	if (iomap.offset + iomap.length < pos + PMD_SIZE)
 		goto finish_iomap;
 
-	sync = dax_fault_is_synchronous(iomap_flags, vma, &iomap);
-
-	switch (iomap.type) {
-	case IOMAP_MAPPED:
-		error = dax_iomap_pfn(&iomap, pos, PMD_SIZE, &pfn);
-		if (error < 0)
-			goto finish_iomap;
+	ret = dax_fault_actor(vmf, pfnp, &xas, entry, true, flags,
+			      &iomap, &srcmap);
 
-		entry = dax_insert_entry(&xas, mapping, vmf, entry, pfn,
-						DAX_PMD, write && !sync);
-
-		if (sync) {
-			result = dax_fault_synchronous_pfnp(pfnp, pfn);
-			goto finish_iomap;
-		}
-
-		trace_dax_pmd_insert_mapping(inode, vmf, PMD_SIZE, pfn, entry);
-		result = vmf_insert_pfn_pmd(vmf, pfn, write);
-		break;
-	case IOMAP_UNWRITTEN:
-	case IOMAP_HOLE:
-		if (WARN_ON_ONCE(write))
-			break;
-		result = dax_pmd_load_hole(&xas, vmf, &iomap, &entry);
-		break;
-	default:
-		WARN_ON_ONCE(1);
-		break;
-	}
-
- finish_iomap:
+finish_iomap:
 	if (ops->iomap_end) {
 		int copied = PMD_SIZE;
 
-		if (result == VM_FAULT_FALLBACK)
+		if (ret == VM_FAULT_FALLBACK)
 			copied = 0;
 		/*
 		 * The fault is done by now and there's no way back (other
@@ -1628,19 +1652,18 @@ static vm_fault_t dax_iomap_pmd_fault(struct vm_fault *vmf, pfn_t *pfnp,
 		 * Just ignore error from ->iomap_end since we cannot do much
 		 * with it.
 		 */
-		ops->iomap_end(inode, pos, PMD_SIZE, copied, iomap_flags,
-				&iomap);
+		ops->iomap_end(inode, pos, PMD_SIZE, copied, flags, &iomap);
 	}
- unlock_entry:
+unlock_entry:
 	dax_unlock_entry(&xas, entry);
- fallback:
-	if (result == VM_FAULT_FALLBACK) {
+fallback:
+	if (ret == VM_FAULT_FALLBACK) {
 		split_huge_pmd(vma, vmf->pmd, vmf->address);
 		count_vm_event(THP_FAULT_FALLBACK);
 	}
 out:
-	trace_dax_pmd_fault_done(inode, vmf, max_pgoff, result);
-	return result;
+	trace_dax_pmd_fault_done(inode, vmf, max_pgoff, ret);
+	return ret;
 }
 #else
 static vm_fault_t dax_iomap_pmd_fault(struct vm_fault *vmf, pfn_t *pfnp,
-- 
2.30.1




_______________________________________________
Ocfs2-devel mailing list
Ocfs2-devel@oss.oracle.com
https://oss.oracle.com/mailman/listinfo/ocfs2-devel
