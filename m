Return-Path: <SRS0=7w/S=H4=oss.oracle.com=ocfs2-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.7 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4B97AC433DB
	for <ocfs2-devel@archiver.kernel.org>; Fri, 26 Feb 2021 16:55:38 +0000 (UTC)
Received: from userp2130.oracle.com (userp2130.oracle.com [156.151.31.86])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id CCD9B64ED2
	for <ocfs2-devel@archiver.kernel.org>; Fri, 26 Feb 2021 16:55:37 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org CCD9B64ED2
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=fujitsu.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=ocfs2-devel-bounces@oss.oracle.com
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
	by userp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 11QGtOPT085518;
	Fri, 26 Feb 2021 16:55:37 GMT
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
	by userp2130.oracle.com with ESMTP id 36tsuranv9-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 26 Feb 2021 16:55:37 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
	by userp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 11QGoIuh004662;
	Fri, 26 Feb 2021 16:55:36 GMT
Received: from oss.oracle.com (oss-old-reserved.oracle.com [137.254.22.2])
	by userp3020.oracle.com with ESMTP id 36uc6w48uf-1
	(version=TLSv1 cipher=AES256-SHA bits=256 verify=NO);
	Fri, 26 Feb 2021 16:55:36 +0000
Received: from localhost ([127.0.0.1] helo=lb-oss.oracle.com)
	by oss.oracle.com with esmtp (Exim 4.63)
	(envelope-from <ocfs2-devel-bounces@oss.oracle.com>)
	id 1lFgOt-0000bx-HG; Fri, 26 Feb 2021 08:55:35 -0800
Received: from userp3020.oracle.com ([156.151.31.79])
	by oss.oracle.com with esmtp (Exim 4.63)
	(envelope-from <ruansy.fnst@fujitsu.com>) id 1lFQsX-0006Cq-AA
	for ocfs2-devel@oss.oracle.com; Thu, 25 Feb 2021 16:21:09 -0800
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
	by userp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id
	11Q0AO0L111060
	for <ocfs2-devel@oss.oracle.com>; Fri, 26 Feb 2021 00:21:09 GMT
Received: from userp2030.oracle.com (userp2030.oracle.com [156.151.31.89])
	by userp3020.oracle.com with ESMTP id 36uc6v6n14-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
	for <ocfs2-devel@oss.oracle.com>; Fri, 26 Feb 2021 00:21:08 +0000
Received: from pps.filterd (userp2030.oracle.com [127.0.0.1])
	by userp2030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id
	11Q0D1MT008989
	for <ocfs2-devel@oss.oracle.com>; Fri, 26 Feb 2021 00:21:08 GMT
Received: from heian.cn.fujitsu.com (mail.cn.fujitsu.com [183.91.158.132])
	by userp2030.oracle.com with ESMTP id 36wqdygthx-1
	for <ocfs2-devel@oss.oracle.com>; Fri, 26 Feb 2021 00:21:08 +0000
X-IronPort-AV: E=Sophos;i="5.81,207,1610380800"; d="scan'208";a="104882827"
Received: from unknown (HELO cn.fujitsu.com) ([10.167.33.5])
	by heian.cn.fujitsu.com with ESMTP; 26 Feb 2021 08:21:06 +0800
Received: from G08CNEXMBPEKD04.g08.fujitsu.local (unknown [10.167.33.201])
	by cn.fujitsu.com (Postfix) with ESMTP id E5C474CE7781;
	Fri, 26 Feb 2021 08:21:05 +0800 (CST)
Received: from G08CNEXCHPEKD04.g08.fujitsu.local (10.167.33.200) by
	G08CNEXMBPEKD04.g08.fujitsu.local (10.167.33.201) with Microsoft SMTP
	Server (TLS) id 15.0.1497.2; Fri, 26 Feb 2021 08:20:56 +0800
Received: from irides.mr.mr.mr (10.167.225.141) by
	G08CNEXCHPEKD04.g08.fujitsu.local (10.167.33.209) with Microsoft SMTP
	Server
	id 15.0.1497.2 via Frontend Transport; Fri, 26 Feb 2021 08:20:55 +0800
From: Shiyang Ruan <ruansy.fnst@fujitsu.com>
To: <linux-kernel@vger.kernel.org>, <linux-xfs@vger.kernel.org>,
        <linux-nvdimm@lists.01.org>, <linux-fsdevel@vger.kernel.org>
Date: Fri, 26 Feb 2021 08:20:25 +0800
Message-ID: <20210226002030.653855-6-ruansy.fnst@fujitsu.com>
X-Mailer: git-send-email 2.30.1
In-Reply-To: <20210226002030.653855-1-ruansy.fnst@fujitsu.com>
References: <20210226002030.653855-1-ruansy.fnst@fujitsu.com>
MIME-Version: 1.0
X-yoursite-MailScanner-ID: E5C474CE7781.A3704
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
	clxscore=181
	classifier=spam adjust=0 reason=mlx scancount=1
	engine=8.12.0-2009150000 definitions=main-2102250184
X-Spam: Clean
X-Mailman-Approved-At: Fri, 26 Feb 2021 08:55:31 -0800
Cc: jack@suse.cz, darrick.wong@oracle.com, david@fromorbit.com,
        ocfs2-devel@oss.oracle.com, viro@zeniv.linux.org.uk,
        Goldwyn Rodrigues <rgoldwyn@suse.com>, dan.j.williams@intel.com,
        linux-btrfs@vger.kernel.org
Subject: [Ocfs2-devel] [PATCH v2 05/10] fsdax: Replace mmap entry in case of
	CoW
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
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 mlxscore=0 spamscore=0
 mlxlogscore=999 adultscore=0 bulkscore=0 malwarescore=0 phishscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2102260124
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9907 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 spamscore=0
 priorityscore=1501 impostorscore=0 bulkscore=0 mlxscore=0 malwarescore=0
 clxscore=1015 phishscore=0 mlxlogscore=999 lowpriorityscore=0 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2102260125

We replace the existing entry to the newly allocated one in case of CoW.
Also, we mark the entry as PAGECACHE_TAG_TOWRITE so writeback marks this
entry as writeprotected.  This helps us snapshots so new write
pagefaults after snapshots trigger a CoW.

Signed-off-by: Goldwyn Rodrigues <rgoldwyn@suse.com>
Signed-off-by: Shiyang Ruan <ruansy.fnst@fujitsu.com>
---
 fs/dax.c | 37 ++++++++++++++++++++++++++-----------
 1 file changed, 26 insertions(+), 11 deletions(-)

diff --git a/fs/dax.c b/fs/dax.c
index 748dfb89fb41..ec4b733e0b59 100644
--- a/fs/dax.c
+++ b/fs/dax.c
@@ -722,6 +722,9 @@ static int copy_cow_page_dax(struct block_device *bdev, struct dax_device *dax_d
 	return 0;
 }
 
+#define DAX_IF_DIRTY		(1 << 0)
+#define DAX_IF_COW		(1 << 1)
+
 /*
  * By this point grab_mapping_entry() has ensured that we have a locked entry
  * of the appropriate size so we don't have to worry about downgrading PMDs to
@@ -729,16 +732,19 @@ static int copy_cow_page_dax(struct block_device *bdev, struct dax_device *dax_d
  * already in the tree, we will skip the insertion and just dirty the PMD as
  * appropriate.
  */
-static void *dax_insert_entry(struct xa_state *xas,
-		struct address_space *mapping, struct vm_fault *vmf,
-		void *entry, pfn_t pfn, unsigned long flags, bool dirty)
+static void *dax_insert_entry(struct xa_state *xas, struct vm_fault *vmf,
+		void *entry, pfn_t pfn, unsigned long flags,
+		unsigned int insert_flags)
 {
+	struct address_space *mapping = vmf->vma->vm_file->f_mapping;
 	void *new_entry = dax_make_entry(pfn, flags);
+	bool dirty = insert_flags & DAX_IF_DIRTY;
+	bool cow = insert_flags & DAX_IF_COW;
 
 	if (dirty)
 		__mark_inode_dirty(mapping->host, I_DIRTY_PAGES);
 
-	if (dax_is_zero_entry(entry) && !(flags & DAX_ZERO_PAGE)) {
+	if (cow || (dax_is_zero_entry(entry) && !(flags & DAX_ZERO_PAGE))) {
 		unsigned long index = xas->xa_index;
 		/* we are replacing a zero page with block mapping */
 		if (dax_is_pmd_entry(entry))
@@ -750,7 +756,7 @@ static void *dax_insert_entry(struct xa_state *xas,
 
 	xas_reset(xas);
 	xas_lock_irq(xas);
-	if (dax_is_zero_entry(entry) || dax_is_empty_entry(entry)) {
+	if (cow || dax_is_zero_entry(entry) || dax_is_empty_entry(entry)) {
 		void *old;
 
 		dax_disassociate_entry(entry, mapping, false);
@@ -774,6 +780,9 @@ static void *dax_insert_entry(struct xa_state *xas,
 	if (dirty)
 		xas_set_mark(xas, PAGECACHE_TAG_DIRTY);
 
+	if (cow)
+		xas_set_mark(xas, PAGECACHE_TAG_TOWRITE);
+
 	xas_unlock_irq(xas);
 	return entry;
 }
@@ -1100,8 +1109,7 @@ static vm_fault_t dax_load_hole(struct xa_state *xas,
 	pfn_t pfn = pfn_to_pfn_t(my_zero_pfn(vaddr));
 	vm_fault_t ret;
 
-	*entry = dax_insert_entry(xas, mapping, vmf, *entry, pfn,
-			DAX_ZERO_PAGE, false);
+	*entry = dax_insert_entry(xas, vmf, *entry, pfn, DAX_ZERO_PAGE, 0);
 
 	ret = vmf_insert_mixed(vmf->vma, vaddr, pfn);
 	trace_dax_load_hole(inode, vmf, ret);
@@ -1403,6 +1411,7 @@ static vm_fault_t dax_fault_actor(struct vm_fault *vmf, pfn_t *pfnp,
 	loff_t pos = (loff_t)xas->xa_offset << PAGE_SHIFT;
 	bool write = vmf->flags & FAULT_FLAG_WRITE;
 	bool sync = dax_fault_is_synchronous(flags, vmf->vma, iomap);
+	unsigned int insert_flags = 0;
 	vm_fault_t ret = 0;
 	int err = 0;
 	pfn_t pfn;
@@ -1426,8 +1435,14 @@ static vm_fault_t dax_fault_actor(struct vm_fault *vmf, pfn_t *pfnp,
 	if (err)
 		goto error_fault;
 
-	entry = dax_insert_entry(xas, mapping, vmf, entry, pfn, 0,
-				 write && !sync);
+	if (write) {
+		if (!sync)
+			insert_flags |= DAX_IF_DIRTY;
+		if (iomap->flags & IOMAP_F_SHARED)
+			insert_flags |= DAX_IF_COW;
+	}
+
+	entry = dax_insert_entry(xas, vmf, entry, pfn, 0, insert_flags);
 
 	if (write && srcmap->addr != iomap->addr) {
 		err = dax_iomap_cow_copy(pos, size, size, srcmap, kaddr, false);
@@ -1571,8 +1586,8 @@ static vm_fault_t dax_pmd_load_hole(struct xa_state *xas, struct vm_fault *vmf,
 		goto fallback;
 
 	pfn = page_to_pfn_t(zero_page);
-	*entry = dax_insert_entry(xas, mapping, vmf, *entry, pfn,
-			DAX_PMD | DAX_ZERO_PAGE, false);
+	*entry = dax_insert_entry(xas, vmf, *entry, pfn,
+				  DAX_PMD | DAX_ZERO_PAGE, 0);
 
 	if (arch_needs_pgtable_deposit()) {
 		pgtable = pte_alloc_one(vma->vm_mm);
-- 
2.30.1




_______________________________________________
Ocfs2-devel mailing list
Ocfs2-devel@oss.oracle.com
https://oss.oracle.com/mailman/listinfo/ocfs2-devel
