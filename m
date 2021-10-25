Return-Path: <SRS0=IoPu=PN=oss.oracle.com=ocfs2-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 00BD9C433F5
	for <ocfs2-devel@archiver.kernel.org>; Mon, 25 Oct 2021 15:14:11 +0000 (UTC)
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id 84EE360E75
	for <ocfs2-devel@archiver.kernel.org>; Mon, 25 Oct 2021 15:14:10 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org 84EE360E75
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=oss.oracle.com
Received: from pps.filterd (m0246631.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 19PF9clS006135;
	Mon, 25 Oct 2021 15:14:09 GMT
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
	by mx0b-00069f02.pphosted.com with ESMTP id 3bw6yekrwv-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 25 Oct 2021 15:14:09 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
	by userp3020.oracle.com (8.16.1.2/8.16.1.2) with SMTP id 19PExtMH068428;
	Mon, 25 Oct 2021 15:14:08 GMT
Received: from oss.oracle.com (oss-old-reserved.oracle.com [137.254.22.2])
	by userp3020.oracle.com with ESMTP id 3bvv5s5ded-1
	(version=TLSv1 cipher=AES256-SHA bits=256 verify=NO);
	Mon, 25 Oct 2021 15:14:07 +0000
Received: from localhost ([127.0.0.1] helo=lb-oss.oracle.com)
	by oss.oracle.com with esmtp (Exim 4.63)
	(envelope-from <ocfs2-devel-bounces@oss.oracle.com>)
	id 1mf1fq-0004Nq-MO; Mon, 25 Oct 2021 08:14:06 -0700
Received: from aserp3020.oracle.com ([141.146.126.70])
	by oss.oracle.com with esmtp (Exim 4.63)
	(envelope-from <jack@suse.cz>) id 1mf1fM-0004MM-MH
	for ocfs2-devel@oss.oracle.com; Mon, 25 Oct 2021 08:13:36 -0700
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
	by aserp3020.oracle.com (8.16.1.2/8.16.1.2) with SMTP id 19PF1TQX077385
	for <ocfs2-devel@oss.oracle.com>; Mon, 25 Oct 2021 15:13:36 GMT
Received: from mx0b-00069f01.pphosted.com (mx0b-00069f01.pphosted.com
	[205.220.177.26]) by aserp3020.oracle.com with ESMTP id 3bva76hkke-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
	for <ocfs2-devel@oss.oracle.com>; Mon, 25 Oct 2021 15:13:36 +0000
Received: from pps.filterd (m0246577.ppops.net [127.0.0.1])
	by mx0b-00069f01.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id
	19PDUW9Y002563
	for <ocfs2-devel@oss.oracle.com>; Mon, 25 Oct 2021 15:13:35 GMT
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.220.28])
	by mx0b-00069f01.pphosted.com with ESMTP id 3bwwcv1hkd-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NO)
	for <ocfs2-devel@oss.oracle.com>; Mon, 25 Oct 2021 15:13:35 +0000
Received: from relay2.suse.de (relay2.suse.de [149.44.160.134])
	by smtp-out1.suse.de (Postfix) with ESMTP id 4A9AF21958;
	Mon, 25 Oct 2021 15:13:33 +0000 (UTC)
Received: from quack2.suse.cz (unknown [10.100.224.230])
	by relay2.suse.de (Postfix) with ESMTP id 0CACBA3B88;
	Mon, 25 Oct 2021 15:13:32 +0000 (UTC)
Received: by quack2.suse.cz (Postfix, from userid 1000)
	id C23751E00C7; Mon, 25 Oct 2021 17:13:32 +0200 (CEST)
From: Jan Kara <jack@suse.cz>
To: Andrew Morton <akpm@linux-foundation.org>
Date: Mon, 25 Oct 2021 17:13:24 +0200
Message-Id: <20211025151332.11301-1-jack@suse.cz>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20211025150008.29002-1-jack@suse.cz>
References: <20211025150008.29002-1-jack@suse.cz>
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=2127; h=from:subject;
	bh=8rH7V8oUZIaV62wFoBn9uNxHVKQTpuSlM30rnn8yJ48=;
	b=owEBbQGS/pANAwAIAZydqgc/ZEDZAcsmYgBhdsmU346KUVkGYPuW5Gdlpq2z7Ix/NFSxavkgIsEW
	IKAJiTmJATMEAAEIAB0WIQSrWdEr1p4yirVVKBycnaoHP2RA2QUCYXbJlAAKCRCcnaoHP2RA2T5aB/
	9FyM1mw6k0c9/JwXkX3dmD1zWq/Da1BbLjTGszNQq3uR5wDz7gBePYEbrqxHywMmtQg/GsfAXM5j+C
	2anoDe658l4JVKb0ohLTobM9zO1DyYGjJOyQyUjcFAB3OTQvrwJrWiqNCecbNoMEsGeE3ESDH+nDZW
	vw8xFxIHovTJVvRBSmeLgBWI21E56vMEd/+dv7nPmrc227yJzoO1YEBNU1fxRJKPb6M4h1011o4u3/
	7jbqMw8z1zcAa5syb1TieganBHV4qTvNeKSurkYMCdfa31FxjylYqnrlTN7NKgpuYcrd01a8hnCUSx
	fzGXdeaR2HP9wb/TmE/+6cOHXmkS+Z
X-Developer-Key: i=jack@suse.cz; a=openpgp;
	fpr=93C6099A142276A28BBE35D815BC833443038D8C
X-Source-IP: 195.135.220.28
X-ServerName: smtp-out1.suse.de
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
	lowpriorityscore=0 bulkscore=0
	suspectscore=0 impostorscore=0 mlxscore=0 malwarescore=0
	mlxlogscore=729
	adultscore=0 priorityscore=111 spamscore=0 clxscore=211 phishscore=0
	classifier=spam adjust=0 reason=mlx scancount=1
	engine=8.12.0-2109230001 definitions=main-2110250092
X-Spam: Clean
Cc: Jan Kara <jack@suse.cz>, stable@vger.kernel.org,
        ocfs2-devel@oss.oracle.com
Subject: [Ocfs2-devel] [PATCH 1/2] ocfs2: Fix data corruption on truncate
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
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 mlxscore=0 spamscore=0
 phishscore=0 suspectscore=0 malwarescore=0 adultscore=0 mlxlogscore=999
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2109230001
 definitions=main-2110250092
X-Proofpoint-GUID: loeLcLDO1gEyO2TFJ7ISvrRFAMbJhblC
X-Proofpoint-ORIG-GUID: loeLcLDO1gEyO2TFJ7ISvrRFAMbJhblC

ocfs2_truncate_file() did unmap invalidate page cache pages before
zeroing partial tail cluster and setting i_size. Thus some pages could
be left (and likely have left if the cluster zeroing happened) in the
page cache beyond i_size after truncate finished letting user possibly
see stale data once the file was extended again. Also the tail cluster
zeroing was not guaranteed to finish before truncate finished causing
possible stale data exposure. The problem started to be particularly
easy to hit after commit 6dbf7bb55598 "fs: Don't invalidate page buffers
in block_write_full_page()" stopped invalidation of pages beyond i_size
from page writeback path.

Fix these problems by unmapping and invalidating pages in the page cache
after the i_size is reduced and tail cluster is zeroed out.

CC: stable@vger.kernel.org
Fixes: ccd979bdbce9 ("[PATCH] OCFS2: The Second Oracle Cluster Filesystem")
Signed-off-by: Jan Kara <jack@suse.cz>
---
 fs/ocfs2/file.c | 8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

diff --git a/fs/ocfs2/file.c b/fs/ocfs2/file.c
index 54d7843c0211..fc5f780fa235 100644
--- a/fs/ocfs2/file.c
+++ b/fs/ocfs2/file.c
@@ -476,10 +476,11 @@ int ocfs2_truncate_file(struct inode *inode,
 	 * greater than page size, so we have to truncate them
 	 * anyway.
 	 */
-	unmap_mapping_range(inode->i_mapping, new_i_size + PAGE_SIZE - 1, 0, 1);
-	truncate_inode_pages(inode->i_mapping, new_i_size);
 
 	if (OCFS2_I(inode)->ip_dyn_features & OCFS2_INLINE_DATA_FL) {
+		unmap_mapping_range(inode->i_mapping,
+				    new_i_size + PAGE_SIZE - 1, 0, 1);
+		truncate_inode_pages(inode->i_mapping, new_i_size);
 		status = ocfs2_truncate_inline(inode, di_bh, new_i_size,
 					       i_size_read(inode), 1);
 		if (status)
@@ -498,6 +499,9 @@ int ocfs2_truncate_file(struct inode *inode,
 		goto bail_unlock_sem;
 	}
 
+	unmap_mapping_range(inode->i_mapping, new_i_size + PAGE_SIZE - 1, 0, 1);
+	truncate_inode_pages(inode->i_mapping, new_i_size);
+
 	status = ocfs2_commit_truncate(osb, inode, di_bh);
 	if (status < 0) {
 		mlog_errno(status);
-- 
2.26.2


_______________________________________________
Ocfs2-devel mailing list
Ocfs2-devel@oss.oracle.com
https://oss.oracle.com/mailman/listinfo/ocfs2-devel
