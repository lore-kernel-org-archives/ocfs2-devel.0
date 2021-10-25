Return-Path: <SRS0=IoPu=PN=oss.oracle.com=ocfs2-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 94FFEC433EF
	for <ocfs2-devel@archiver.kernel.org>; Mon, 25 Oct 2021 15:14:12 +0000 (UTC)
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id 3F39160F02
	for <ocfs2-devel@archiver.kernel.org>; Mon, 25 Oct 2021 15:14:12 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org 3F39160F02
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=oss.oracle.com
Received: from pps.filterd (m0246632.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 19PF578k030370;
	Mon, 25 Oct 2021 15:14:11 GMT
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
	by mx0b-00069f02.pphosted.com with ESMTP id 3bw6v1ut9g-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 25 Oct 2021 15:14:11 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
	by userp3030.oracle.com (8.16.1.2/8.16.1.2) with SMTP id 19PF1uPk064929;
	Mon, 25 Oct 2021 15:14:10 GMT
Received: from oss.oracle.com (oss-old-reserved.oracle.com [137.254.22.2])
	by userp3030.oracle.com with ESMTP id 3bv7gus9xg-1
	(version=TLSv1 cipher=AES256-SHA bits=256 verify=NO);
	Mon, 25 Oct 2021 15:14:09 +0000
Received: from localhost ([127.0.0.1] helo=lb-oss.oracle.com)
	by oss.oracle.com with esmtp (Exim 4.63)
	(envelope-from <ocfs2-devel-bounces@oss.oracle.com>)
	id 1mf1fs-0004Os-Qy; Mon, 25 Oct 2021 08:14:08 -0700
Received: from userp3020.oracle.com ([156.151.31.79])
	by oss.oracle.com with esmtp (Exim 4.63)
	(envelope-from <jack@suse.cz>) id 1mf1fP-0004Mz-Ih
	for ocfs2-devel@oss.oracle.com; Mon, 25 Oct 2021 08:13:39 -0700
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
	by userp3020.oracle.com (8.16.1.2/8.16.1.2) with SMTP id 19PExsjB068169
	for <ocfs2-devel@oss.oracle.com>; Mon, 25 Oct 2021 15:13:39 GMT
Received: from mx0a-00069f01.pphosted.com (mx0a-00069f01.pphosted.com
	[205.220.165.26]) by userp3020.oracle.com with ESMTP id 3bvv5s5c2r-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
	for <ocfs2-devel@oss.oracle.com>; Mon, 25 Oct 2021 15:13:39 +0000
Received: from pps.filterd (m0246573.ppops.net [127.0.0.1])
	by mx0b-00069f01.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id
	19PDUgp9009270
	for <ocfs2-devel@oss.oracle.com>; Mon, 25 Oct 2021 15:13:37 GMT
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.220.29])
	by mx0b-00069f01.pphosted.com with ESMTP id 3bwv7fjc13-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NO)
	for <ocfs2-devel@oss.oracle.com>; Mon, 25 Oct 2021 15:13:36 +0000
Received: from relay2.suse.de (relay2.suse.de [149.44.160.134])
	by smtp-out2.suse.de (Postfix) with ESMTP id 45B0C1FD3A;
	Mon, 25 Oct 2021 15:13:33 +0000 (UTC)
Received: from quack2.suse.cz (unknown [10.100.224.230])
	by relay2.suse.de (Postfix) with ESMTP id 0CB97A3B89;
	Mon, 25 Oct 2021 15:13:32 +0000 (UTC)
Received: by quack2.suse.cz (Postfix, from userid 1000)
	id C5FB61E0C03; Mon, 25 Oct 2021 17:13:32 +0200 (CEST)
From: Jan Kara <jack@suse.cz>
To: Andrew Morton <akpm@linux-foundation.org>
Date: Mon, 25 Oct 2021 17:13:25 +0200
Message-Id: <20211025151332.11301-2-jack@suse.cz>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20211025150008.29002-1-jack@suse.cz>
References: <20211025150008.29002-1-jack@suse.cz>
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=2126; h=from:subject;
	bh=/GnBfkhhGgHtjgXYgf+yGj3QyHCIB+StNAdeIHexZ0k=;
	b=owEBbQGS/pANAwAIAZydqgc/ZEDZAcsmYgBhdsmVvajThV5EZigQy52ELnF9tuwgmR/ry21Iq9dc
	NouUZUKJATMEAAEIAB0WIQSrWdEr1p4yirVVKBycnaoHP2RA2QUCYXbJlQAKCRCcnaoHP2RA2WxIB/
	9SuHX+NxEDPRiY9FooYi11K2fAyHeUhbhy3+o5kEDfzKrepOP/f5DaXZKdqB6htQ09jrYV41mCF/pO
	aNUIbg1xiLgz6u4mW64ZmIicjqjSNA7y1xuJ3rqwjU1EinS9+ci98B+zy9qc+9X0NHJmi5ThkegvKn
	jMfkFGjfsi9oJ7XvN4URJhh4dl9NV4ygfVk7GXo7POGBz8/C0JPbR3SVJjIIJqyQEhEYCSIU0CHKvm
	Eb9VDEZuJqGgA2zdYTtwdsdXdHYJNYezCp2/SAhRmLRFXRar+MiOfiXSWFOyRNx9qltsjG7hzA4g2o
	/+UVkHN32wA6D+0d6ZSd4dvcpE6xHd
X-Developer-Key: i=jack@suse.cz; a=openpgp;
	fpr=93C6099A142276A28BBE35D815BC833443038D8C
X-Source-IP: 195.135.220.29
X-ServerName: smtp-out2.suse.de
X-Proofpoint-SPF-Result: pass
X-Proofpoint-SPF-Record: v=spf1 ip4:137.65.0.0/16 ip4:151.155.28.0/17
	ip4:149.44.0.0/16
	ip4:147.2.0.0/16 ip4:164.99.0.0/16 ip4:130.57.0.0/16
	ip4:192.31.114.0/24
	ip4:195.135.221.0/24 ip4:195.135.220.0/24 ip4:69.7.179.0/24
	ip4:150.215.214.0/24 include:mailcontrol.com ~all
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10148
	signatures=668683
X-Proofpoint-Spam-Details: rule=tap_notspam policy=tap score=0
	priorityscore=48 malwarescore=0
	suspectscore=0 phishscore=0 clxscore=203 mlxscore=0 impostorscore=0
	adultscore=0 lowpriorityscore=0 mlxlogscore=651 bulkscore=0 spamscore=0
	classifier=spam adjust=0 reason=mlx scancount=1
	engine=8.12.0-2109230001 definitions=main-2110250092
X-Spam: Clean
Cc: Jan Kara <jack@suse.cz>, ocfs2-devel@oss.oracle.com
Subject: [Ocfs2-devel] [PATCH 2/2] ocfs2: Do not zero pages beyond i_size
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
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10148 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 phishscore=0 adultscore=0
 suspectscore=0 mlxscore=0 bulkscore=0 mlxlogscore=999 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2109230001
 definitions=main-2110250092
X-Proofpoint-GUID: dPKl30xZnARn6dz6XPARl-1kxPHJMv-e
X-Proofpoint-ORIG-GUID: dPKl30xZnARn6dz6XPARl-1kxPHJMv-e

ocfs2_zero_range_for_truncate() can try to zero pages beyond current
inode size despite the fact that underlying blocks should be already
zeroed out and writeback will skip writing such pages anyway. Avoid the
pointless work.

Signed-off-by: Jan Kara <jack@suse.cz>
---
 fs/ocfs2/alloc.c | 19 ++++++++++++-------
 1 file changed, 12 insertions(+), 7 deletions(-)

diff --git a/fs/ocfs2/alloc.c b/fs/ocfs2/alloc.c
index 5d9ae17bd443..ff5ff0e7de44 100644
--- a/fs/ocfs2/alloc.c
+++ b/fs/ocfs2/alloc.c
@@ -6921,13 +6921,12 @@ static int ocfs2_grab_eof_pages(struct inode *inode, loff_t start, loff_t end,
 }
 
 /*
- * Zero the area past i_size but still within an allocated
- * cluster. This avoids exposing nonzero data on subsequent file
- * extends.
+ * Zero partial cluster for a hole punch or truncate. This avoids exposing
+ * nonzero data on subsequent file extends.
  *
  * We need to call this before i_size is updated on the inode because
  * otherwise block_write_full_page() will skip writeout of pages past
- * i_size. The new_i_size parameter is passed for this reason.
+ * i_size.
  */
 int ocfs2_zero_range_for_truncate(struct inode *inode, handle_t *handle,
 				  u64 range_start, u64 range_end)
@@ -6945,6 +6944,15 @@ int ocfs2_zero_range_for_truncate(struct inode *inode, handle_t *handle,
 	if (!ocfs2_sparse_alloc(OCFS2_SB(sb)))
 		return 0;
 
+	/*
+	 * Avoid zeroing pages fully beyond current i_size. It is pointless as
+	 * underlying blocks of those pages should be already zeroed out and
+	 * page writeback will skip them anyway.
+	 */
+	range_end = min_t(u64, range_end, i_size_read(inode));
+	if (range_start >= range_end)
+		return 0;
+
 	pages = kcalloc(ocfs2_pages_per_cluster(sb),
 			sizeof(struct page *), GFP_NOFS);
 	if (pages == NULL) {
@@ -6953,9 +6961,6 @@ int ocfs2_zero_range_for_truncate(struct inode *inode, handle_t *handle,
 		goto out;
 	}
 
-	if (range_start == range_end)
-		goto out;
-
 	ret = ocfs2_extent_map_get_blocks(inode,
 					  range_start >> sb->s_blocksize_bits,
 					  &phys, NULL, &ext_flags);
-- 
2.26.2


_______________________________________________
Ocfs2-devel mailing list
Ocfs2-devel@oss.oracle.com
https://oss.oracle.com/mailman/listinfo/ocfs2-devel
