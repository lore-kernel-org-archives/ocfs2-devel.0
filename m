Return-Path: <SRS0=/zwX=IR=oss.oracle.com=ocfs2-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 970FAC43381
	for <ocfs2-devel@archiver.kernel.org>; Fri, 19 Mar 2021 01:53:44 +0000 (UTC)
Received: from userp2130.oracle.com (userp2130.oracle.com [156.151.31.86])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id 43D1964E99
	for <ocfs2-devel@archiver.kernel.org>; Fri, 19 Mar 2021 01:53:44 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 43D1964E99
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=fujitsu.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=ocfs2-devel-bounces@oss.oracle.com
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
	by userp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 12J1p2Vi084720;
	Fri, 19 Mar 2021 01:53:43 GMT
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
	by userp2130.oracle.com with ESMTP id 37a4ekxanq-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 19 Mar 2021 01:53:43 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
	by userp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 12J1jcct108943;
	Fri, 19 Mar 2021 01:53:43 GMT
Received: from oss.oracle.com (oss-old-reserved.oracle.com [137.254.22.2])
	by userp3020.oracle.com with ESMTP id 37cf2b6fuv-1
	(version=TLSv1 cipher=AES256-SHA bits=256 verify=NO);
	Fri, 19 Mar 2021 01:53:42 +0000
Received: from localhost ([127.0.0.1] helo=lb-oss.oracle.com)
	by oss.oracle.com with esmtp (Exim 4.63)
	(envelope-from <ocfs2-devel-bounces@oss.oracle.com>)
	id 1lN4Kb-0006YM-SQ; Thu, 18 Mar 2021 18:53:41 -0700
Received: from userp3020.oracle.com ([156.151.31.79])
	by oss.oracle.com with esmtp (Exim 4.63)
	(envelope-from <ruansy.fnst@fujitsu.com>) id 1lN4KU-0006U3-St
	for ocfs2-devel@oss.oracle.com; Thu, 18 Mar 2021 18:53:35 -0700
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
	by userp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id
	12J1jdD6109290
	for <ocfs2-devel@oss.oracle.com>; Fri, 19 Mar 2021 01:53:34 GMT
Received: from userp2040.oracle.com (userp2040.oracle.com [156.151.31.90])
	by userp3020.oracle.com with ESMTP id 37cf2b6frt-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
	for <ocfs2-devel@oss.oracle.com>; Fri, 19 Mar 2021 01:53:34 +0000
Received: from pps.filterd (userp2040.oracle.com [127.0.0.1])
	by userp2040.oracle.com (8.16.0.42/8.16.0.42) with SMTP id
	12J1r6lK005056
	for <ocfs2-devel@oss.oracle.com>; Fri, 19 Mar 2021 01:53:34 GMT
Received: from heian.cn.fujitsu.com (mail.cn.fujitsu.com [183.91.158.132])
	by userp2040.oracle.com with ESMTP id 37axjvp783-2
	for <ocfs2-devel@oss.oracle.com>; Fri, 19 Mar 2021 01:53:33 +0000
IronPort-HdrOrdr: =?us-ascii?q?A9a23=3AehSLzK9zHZ1IGwalXjZuk+A4I+orLtY04lQ7?=
	=?us-ascii?q?vn1ZYxpTb8CeioSSjO0WvCWE7Ao5dVMBvZS7OKeGSW7B7pId2+QsFJqrQQWOgg?=
	=?us-ascii?q?WVBa5v4YboyzfjXw3Sn9Q26Y5OaK57YeeQMXFfreLXpDa1CMwhxt7vytHMuc77?=
	=?us-ascii?q?w212RQ9nL4FMhj0JaTqzKUF9SAlYCZdRLvP1ifZvnSaqengcc62Adxs4dtXEzu?=
	=?us-ascii?q?eqqLvWJTYCBzMCrDKFlC6U7tfBeCSw71MzVCxuzN4ZnVT4rw=3D=3D?=
X-IronPort-AV: E=Sophos;i="5.81,259,1610380800"; d="scan'208";a="105876721"
Received: from unknown (HELO cn.fujitsu.com) ([10.167.33.5])
	by heian.cn.fujitsu.com with ESMTP; 19 Mar 2021 09:53:32 +0800
Received: from G08CNEXMBPEKD06.g08.fujitsu.local (unknown [10.167.33.206])
	by cn.fujitsu.com (Postfix) with ESMTP id F1BD94CEB2B4;
	Fri, 19 Mar 2021 09:53:31 +0800 (CST)
Received: from G08CNEXCHPEKD04.g08.fujitsu.local (10.167.33.200) by
	G08CNEXMBPEKD06.g08.fujitsu.local (10.167.33.206) with Microsoft SMTP
	Server (TLS) id 15.0.1497.2; Fri, 19 Mar 2021 09:53:21 +0800
Received: from irides.mr.mr.mr (10.167.225.141) by
	G08CNEXCHPEKD04.g08.fujitsu.local (10.167.33.209) with Microsoft SMTP
	Server
	id 15.0.1497.2 via Frontend Transport; Fri, 19 Mar 2021 09:53:21 +0800
From: Shiyang Ruan <ruansy.fnst@fujitsu.com>
To: <linux-kernel@vger.kernel.org>, <linux-xfs@vger.kernel.org>,
        <linux-nvdimm@lists.01.org>, <linux-fsdevel@vger.kernel.org>
Date: Fri, 19 Mar 2021 09:52:35 +0800
Message-ID: <20210319015237.993880-9-ruansy.fnst@fujitsu.com>
X-Mailer: git-send-email 2.30.1
In-Reply-To: <20210319015237.993880-1-ruansy.fnst@fujitsu.com>
References: <20210319015237.993880-1-ruansy.fnst@fujitsu.com>
MIME-Version: 1.0
X-yoursite-MailScanner-ID: F1BD94CEB2B4.A5BD3
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
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9927
	signatures=668683
X-Proofpoint-Spam-Details: rule=tap_notspam policy=tap score=0 mlxscore=0
	bulkscore=0
	lowpriorityscore=0 suspectscore=0 adultscore=0 priorityscore=1501
	impostorscore=0 phishscore=0 mlxlogscore=999 clxscore=-10 spamscore=0
	malwarescore=0 classifier=spam adjust=0 reason=mlx scancount=1
	engine=8.12.0-2009150000 definitions=main-2103190011
X-Spam: Clean
Cc: jack@suse.cz, darrick.wong@oracle.com, david@fromorbit.com,
        ocfs2-devel@oss.oracle.com, viro@zeniv.linux.org.uk,
        Goldwyn Rodrigues <rgoldwyn@suse.com>, dan.j.williams@intel.com,
        linux-btrfs@vger.kernel.org
Subject: [Ocfs2-devel] [PATCH v3 08/10] fsdax: Dedup file range to use a
	compare function
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
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9927 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 mlxscore=0 suspectscore=0
 adultscore=0 bulkscore=0 mlxlogscore=999 phishscore=0 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2103190010
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9927 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 malwarescore=0 bulkscore=0
 impostorscore=0 lowpriorityscore=0 mlxlogscore=999 spamscore=0
 priorityscore=1501 adultscore=0 phishscore=0 suspectscore=0 clxscore=1015
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2103190010

With dax we cannot deal with readpage() etc. So, we create a dax
comparison funciton which is similar with
vfs_dedupe_file_range_compare().
And introduce dax_remap_file_range_prep() for filesystem use.

Signed-off-by: Goldwyn Rodrigues <rgoldwyn@suse.com>
Signed-off-by: Shiyang Ruan <ruansy.fnst@fujitsu.com>
---
 fs/dax.c             | 56 ++++++++++++++++++++++++++++++++++++++++++++
 fs/remap_range.c     | 45 ++++++++++++++++++++++++++++-------
 fs/xfs/xfs_reflink.c |  9 +++++--
 include/linux/dax.h  |  4 ++++
 include/linux/fs.h   | 15 ++++++++----
 5 files changed, 115 insertions(+), 14 deletions(-)

diff --git a/fs/dax.c b/fs/dax.c
index 348297b38f76..76f81f1d76ec 100644
--- a/fs/dax.c
+++ b/fs/dax.c
@@ -1833,3 +1833,59 @@ vm_fault_t dax_finish_sync_fault(struct vm_fault *vmf,
 	return dax_insert_pfn_mkwrite(vmf, pfn, order);
 }
 EXPORT_SYMBOL_GPL(dax_finish_sync_fault);
+
+static loff_t dax_range_compare_actor(struct inode *ino1, loff_t pos1,
+		struct inode *ino2, loff_t pos2, loff_t len, void *data,
+		struct iomap *smap, struct iomap *dmap)
+{
+	void *saddr, *daddr;
+	bool *same = data;
+	int ret;
+
+	if (smap->type == IOMAP_HOLE && dmap->type == IOMAP_HOLE) {
+		*same = true;
+		return len;
+	}
+
+	if (smap->type == IOMAP_HOLE || dmap->type == IOMAP_HOLE) {
+		*same = false;
+		return 0;
+	}
+
+	ret = dax_iomap_direct_access(smap, pos1, ALIGN(pos1 + len, PAGE_SIZE),
+				      &saddr, NULL);
+	if (ret < 0)
+		return -EIO;
+
+	ret = dax_iomap_direct_access(dmap, pos2, ALIGN(pos2 + len, PAGE_SIZE),
+				      &daddr, NULL);
+	if (ret < 0)
+		return -EIO;
+
+	*same = !memcmp(saddr, daddr, len);
+	return len;
+}
+
+int dax_dedupe_file_range_compare(struct inode *src, loff_t srcoff,
+		struct inode *dest, loff_t destoff, loff_t len, bool *is_same,
+		const struct iomap_ops *ops)
+{
+	int id, ret = 0;
+
+	id = dax_read_lock();
+	while (len) {
+		ret = iomap_apply2(src, srcoff, dest, destoff, len, 0, ops,
+				   is_same, dax_range_compare_actor);
+		if (ret < 0 || !*is_same)
+			goto out;
+
+		len -= ret;
+		srcoff += ret;
+		destoff += ret;
+	}
+	ret = 0;
+out:
+	dax_read_unlock(id);
+	return ret;
+}
+EXPORT_SYMBOL_GPL(dax_dedupe_file_range_compare);
diff --git a/fs/remap_range.c b/fs/remap_range.c
index 77dba3a49e65..9079390edaf3 100644
--- a/fs/remap_range.c
+++ b/fs/remap_range.c
@@ -14,6 +14,7 @@
 #include <linux/compat.h>
 #include <linux/mount.h>
 #include <linux/fs.h>
+#include <linux/dax.h>
 #include "internal.h"
 
 #include <linux/uaccess.h>
@@ -199,9 +200,9 @@ static void vfs_unlock_two_pages(struct page *page1, struct page *page2)
  * Compare extents of two files to see if they are the same.
  * Caller must have locked both inodes to prevent write races.
  */
-static int vfs_dedupe_file_range_compare(struct inode *src, loff_t srcoff,
-					 struct inode *dest, loff_t destoff,
-					 loff_t len, bool *is_same)
+int vfs_dedupe_file_range_compare(struct inode *src, loff_t srcoff,
+				  struct inode *dest, loff_t destoff,
+				  loff_t len, bool *is_same)
 {
 	loff_t src_poff;
 	loff_t dest_poff;
@@ -280,6 +281,7 @@ static int vfs_dedupe_file_range_compare(struct inode *src, loff_t srcoff,
 out_error:
 	return error;
 }
+EXPORT_SYMBOL(vfs_dedupe_file_range_compare);
 
 /*
  * Check that the two inodes are eligible for cloning, the ranges make
@@ -289,9 +291,11 @@ static int vfs_dedupe_file_range_compare(struct inode *src, loff_t srcoff,
  * If there's an error, then the usual negative error code is returned.
  * Otherwise returns 0 with *len set to the request length.
  */
-int generic_remap_file_range_prep(struct file *file_in, loff_t pos_in,
-				  struct file *file_out, loff_t pos_out,
-				  loff_t *len, unsigned int remap_flags)
+static int
+__generic_remap_file_range_prep(struct file *file_in, loff_t pos_in,
+				struct file *file_out, loff_t pos_out,
+				loff_t *len, unsigned int remap_flags,
+				const struct iomap_ops *ops)
 {
 	struct inode *inode_in = file_inode(file_in);
 	struct inode *inode_out = file_inode(file_out);
@@ -351,8 +355,15 @@ int generic_remap_file_range_prep(struct file *file_in, loff_t pos_in,
 	if (remap_flags & REMAP_FILE_DEDUP) {
 		bool		is_same = false;
 
-		ret = vfs_dedupe_file_range_compare(inode_in, pos_in,
-				inode_out, pos_out, *len, &is_same);
+		if (!IS_DAX(inode_in) && !IS_DAX(inode_out))
+			ret = vfs_dedupe_file_range_compare(inode_in, pos_in,
+					inode_out, pos_out, *len, &is_same);
+		else if (IS_DAX(inode_in) && IS_DAX(inode_out) && ops)
+			ret = dax_dedupe_file_range_compare(inode_in, pos_in,
+					inode_out, pos_out, *len, &is_same,
+					ops);
+		else
+			return -EINVAL;
 		if (ret)
 			return ret;
 		if (!is_same)
@@ -370,6 +381,24 @@ int generic_remap_file_range_prep(struct file *file_in, loff_t pos_in,
 
 	return ret;
 }
+
+int dax_remap_file_range_prep(struct file *file_in, loff_t pos_in,
+			      struct file *file_out, loff_t pos_out,
+			      loff_t *len, unsigned int remap_flags,
+			      const struct iomap_ops *ops)
+{
+	return __generic_remap_file_range_prep(file_in, pos_in, file_out,
+					       pos_out, len, remap_flags, ops);
+}
+EXPORT_SYMBOL(dax_remap_file_range_prep);
+
+int generic_remap_file_range_prep(struct file *file_in, loff_t pos_in,
+				  struct file *file_out, loff_t pos_out,
+				  loff_t *len, unsigned int remap_flags)
+{
+	return __generic_remap_file_range_prep(file_in, pos_in, file_out,
+					       pos_out, len, remap_flags, NULL);
+}
 EXPORT_SYMBOL(generic_remap_file_range_prep);
 
 loff_t do_clone_file_range(struct file *file_in, loff_t pos_in,
diff --git a/fs/xfs/xfs_reflink.c b/fs/xfs/xfs_reflink.c
index 6fa05fb78189..f5b3a3da36b7 100644
--- a/fs/xfs/xfs_reflink.c
+++ b/fs/xfs/xfs_reflink.c
@@ -1308,8 +1308,13 @@ xfs_reflink_remap_prep(
 	if (IS_DAX(inode_in) || IS_DAX(inode_out))
 		goto out_unlock;
 
-	ret = generic_remap_file_range_prep(file_in, pos_in, file_out, pos_out,
-			len, remap_flags);
+	if (IS_DAX(inode_in))
+		ret = generic_remap_file_range_prep(file_in, pos_in, file_out,
+						    pos_out, len, remap_flags);
+	else
+		ret = dax_remap_file_range_prep(file_in, pos_in, file_out,
+						pos_out, len, remap_flags,
+						&xfs_read_iomap_ops);
 	if (ret || *len == 0)
 		goto out_unlock;
 
diff --git a/include/linux/dax.h b/include/linux/dax.h
index 3275e01ed33d..32e1c34349f2 100644
--- a/include/linux/dax.h
+++ b/include/linux/dax.h
@@ -239,6 +239,10 @@ int dax_invalidate_mapping_entry_sync(struct address_space *mapping,
 				      pgoff_t index);
 s64 dax_iomap_zero(loff_t pos, u64 length, struct iomap *iomap,
 		struct iomap *srcmap);
+int dax_dedupe_file_range_compare(struct inode *src, loff_t srcoff,
+				  struct inode *dest, loff_t destoff,
+				  loff_t len, bool *is_same,
+				  const struct iomap_ops *ops);
 static inline bool dax_mapping(struct address_space *mapping)
 {
 	return mapping->host && IS_DAX(mapping->host);
diff --git a/include/linux/fs.h b/include/linux/fs.h
index fd47deea7c17..2e6ec5bdf82a 100644
--- a/include/linux/fs.h
+++ b/include/linux/fs.h
@@ -68,6 +68,7 @@ struct fsverity_info;
 struct fsverity_operations;
 struct fs_context;
 struct fs_parameter_spec;
+struct iomap_ops;
 
 extern void __init inode_init(void);
 extern void __init inode_init_early(void);
@@ -1910,13 +1911,19 @@ extern ssize_t vfs_read(struct file *, char __user *, size_t, loff_t *);
 extern ssize_t vfs_write(struct file *, const char __user *, size_t, loff_t *);
 extern ssize_t vfs_copy_file_range(struct file *, loff_t , struct file *,
 				   loff_t, size_t, unsigned int);
+typedef int (*compare_range_t)(struct inode *src, loff_t srcpos,
+			       struct inode *dest, loff_t destpos,
+			       loff_t len, bool *is_same);
 extern ssize_t generic_copy_file_range(struct file *file_in, loff_t pos_in,
 				       struct file *file_out, loff_t pos_out,
 				       size_t len, unsigned int flags);
-extern int generic_remap_file_range_prep(struct file *file_in, loff_t pos_in,
-					 struct file *file_out, loff_t pos_out,
-					 loff_t *count,
-					 unsigned int remap_flags);
+int generic_remap_file_range_prep(struct file *file_in, loff_t pos_in,
+				  struct file *file_out, loff_t pos_out,
+				  loff_t *count, unsigned int remap_flags);
+int dax_remap_file_range_prep(struct file *file_in, loff_t pos_in,
+			      struct file *file_out, loff_t pos_out,
+			      loff_t *len, unsigned int remap_flags,
+			      const struct iomap_ops *ops);
 extern loff_t do_clone_file_range(struct file *file_in, loff_t pos_in,
 				  struct file *file_out, loff_t pos_out,
 				  loff_t len, unsigned int remap_flags);
-- 
2.30.1




_______________________________________________
Ocfs2-devel mailing list
Ocfs2-devel@oss.oracle.com
https://oss.oracle.com/mailman/listinfo/ocfs2-devel
