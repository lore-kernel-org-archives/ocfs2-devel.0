Return-Path: <SRS0=eOWJ=NK=oss.oracle.com=ocfs2-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B6198C4320A
	for <ocfs2-devel@archiver.kernel.org>; Thu, 19 Aug 2021 19:42:03 +0000 (UTC)
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id 6A8B260EBD
	for <ocfs2-devel@archiver.kernel.org>; Thu, 19 Aug 2021 19:42:03 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org 6A8B260EBD
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=oss.oracle.com
Received: from pps.filterd (m0246632.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 17JJWERj027259;
	Thu, 19 Aug 2021 19:42:02 GMT
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
	by mx0b-00069f02.pphosted.com with ESMTP id 3agw7t4mgg-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 19 Aug 2021 19:42:01 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
	by userp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 17JJV67K041319;
	Thu, 19 Aug 2021 19:42:00 GMT
Received: from oss.oracle.com (oss-old-reserved.oracle.com [137.254.22.2])
	by userp3020.oracle.com with ESMTP id 3aeqm04j48-1
	(version=TLSv1 cipher=AES256-SHA bits=256 verify=NO);
	Thu, 19 Aug 2021 19:42:00 +0000
Received: from localhost ([127.0.0.1] helo=lb-oss.oracle.com)
	by oss.oracle.com with esmtp (Exim 4.63)
	(envelope-from <ocfs2-devel-bounces@oss.oracle.com>)
	id 1mGnvL-0005G8-Hy; Thu, 19 Aug 2021 12:41:59 -0700
Received: from aserp3020.oracle.com ([141.146.126.70])
	by oss.oracle.com with esmtp (Exim 4.63)
	(envelope-from <agruenba@redhat.com>) id 1mGnvJ-0005Fp-VV
	for ocfs2-devel@oss.oracle.com; Thu, 19 Aug 2021 12:41:58 -0700
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
	by aserp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id
	17JJUutI058570
	for <ocfs2-devel@oss.oracle.com>; Thu, 19 Aug 2021 19:41:57 GMT
Received: from mx0b-00069f01.pphosted.com (mx0b-00069f01.pphosted.com
	[205.220.177.26]) by aserp3020.oracle.com with ESMTP id 3ae5nc4wb6-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
	for <ocfs2-devel@oss.oracle.com>; Thu, 19 Aug 2021 19:41:57 +0000
Received: from pps.filterd (m0246576.ppops.net [127.0.0.1])
	by mx0b-00069f01.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id
	17JJXU5X032640
	for <ocfs2-devel@oss.oracle.com>; Thu, 19 Aug 2021 19:41:56 GMT
Received: from us-smtp-delivery-124.mimecast.com
	(us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by mx0b-00069f01.pphosted.com with ESMTP id 3ahbarmbtq-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
	for <ocfs2-devel@oss.oracle.com>; Thu, 19 Aug 2021 19:41:56 +0000
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
	[209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
	us-mta-124-ei7g3Qq-NMiokc7jEeJKwQ-1; Thu, 19 Aug 2021 15:41:54 -0400
X-MC-Unique: ei7g3Qq-NMiokc7jEeJKwQ-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com
	[10.5.11.13])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id D5A1C801AC5;
	Thu, 19 Aug 2021 19:41:52 +0000 (UTC)
Received: from max.com (unknown [10.40.194.206])
	by smtp.corp.redhat.com (Postfix) with ESMTP id CC54D60938;
	Thu, 19 Aug 2021 19:41:46 +0000 (UTC)
From: Andreas Gruenbacher <agruenba@redhat.com>
To: Linus Torvalds <torvalds@linux-foundation.org>,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        Christoph Hellwig <hch@infradead.org>,
        "Darrick J. Wong" <djwong@kernel.org>
Date: Thu, 19 Aug 2021 21:40:54 +0200
Message-Id: <20210819194102.1491495-12-agruenba@redhat.com>
In-Reply-To: <20210819194102.1491495-1-agruenba@redhat.com>
References: <20210819194102.1491495-1-agruenba@redhat.com>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
X-Proofpoint-SPF-Result: pass
X-Proofpoint-SPF-Record: v=spf1 ip4:103.23.64.2 ip4:103.23.65.2
	ip4:103.23.66.26 ip4:103.23.67.26
	ip4:107.21.15.141 ip4:108.177.8.0/21 ip4:128.17.0.0/20
	ip4:128.17.128.0/20
	ip4:128.17.192.0/20 ip4:128.17.64.0/20 ip4:128.245.0.0/20
	ip4:128.245.64.0/20 ip4:13.110.208.0/21 ip4:13.110.216.0/22
	ip4:13.111.0.0/16 ip4:136.147.128.0/20 ip4:136.147.176.0/20
	include:spf1.redhat.com -all
X-Proofpoint-SPF-VenPass: Allowed
X-Source-IP: 170.10.133.124
X-ServerName: us-smtp-delivery-124.mimecast.com
X-Proofpoint-SPF-Result: pass
X-Proofpoint-SPF-Record: v=spf1 ip4:103.23.64.2 ip4:103.23.65.2
	ip4:103.23.66.26 ip4:103.23.67.26
	ip4:107.21.15.141 ip4:108.177.8.0/21 ip4:128.17.0.0/20
	ip4:128.17.128.0/20
	ip4:128.17.192.0/20 ip4:128.17.64.0/20 ip4:128.245.0.0/20
	ip4:128.245.64.0/20 ip4:13.110.208.0/21 ip4:13.110.216.0/22
	ip4:13.111.0.0/16 ip4:136.147.128.0/20 ip4:136.147.176.0/20
	include:spf1.redhat.com -all
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=10081
	signatures=668682
X-Proofpoint-Spam-Reason: safe
X-Spam: OrgSafeList
X-SpamRule: orgsafelist
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=10081
	signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0
	adultscore=0 bulkscore=0
	suspectscore=0 mlxlogscore=934 phishscore=0 mlxscore=0 spamscore=0
	classifier=spam adjust=0 reason=mlx scancount=1
	engine=8.12.0-2107140000 definitions=main-2108190114
Cc: Jan Kara <jack@suse.cz>, Andreas Gruenbacher <agruenba@redhat.com>,
        linux-kernel@vger.kernel.org, cluster-devel@redhat.com,
        linux-fsdevel@vger.kernel.org, ocfs2-devel@oss.oracle.com
Subject: [Ocfs2-devel] [PATCH v6 11/19] gfs2: Move the inode glock locking
	to gfs2_file_buffered_write
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
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=10081 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 bulkscore=0 malwarescore=0
 mlxscore=0 spamscore=0 suspectscore=0 mlxlogscore=999 phishscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2107140000
 definitions=main-2108190114
X-Proofpoint-ORIG-GUID: ryHkcbm4BnWw-dSsFtoyQQNk7-YJg8lT
X-Proofpoint-GUID: ryHkcbm4BnWw-dSsFtoyQQNk7-YJg8lT

So far, for buffered writes, we were taking the inode glock in
gfs2_iomap_begin and dropping it in gfs2_iomap_end with the intention of
not holding the inode glock while iomap_write_actor faults in user
pages.  It turns out that iomap_write_actor is called inside iomap_begin
... iomap_end, so the user pages were still faulted in while holding the
inode glock and the locking code in iomap_begin / iomap_end was
completely pointless.

Move the locking into gfs2_file_buffered_write instead.  We'll take care
of the potential deadlocks due to faulting user pages while holding a
glock in a subsequent patch.

Signed-off-by: Andreas Gruenbacher <agruenba@redhat.com>
---
 fs/gfs2/bmap.c | 60 +-------------------------------------------------
 fs/gfs2/file.c | 27 +++++++++++++++++++++++
 2 files changed, 28 insertions(+), 59 deletions(-)

diff --git a/fs/gfs2/bmap.c b/fs/gfs2/bmap.c
index ed8b67b21718..0d90f1809efb 100644
--- a/fs/gfs2/bmap.c
+++ b/fs/gfs2/bmap.c
@@ -961,46 +961,6 @@ static int __gfs2_iomap_get(struct inode *inode, loff_t pos, loff_t length,
 	goto out;
 }
 
-static int gfs2_write_lock(struct inode *inode)
-{
-	struct gfs2_inode *ip = GFS2_I(inode);
-	struct gfs2_sbd *sdp = GFS2_SB(inode);
-	int error;
-
-	gfs2_holder_init(ip->i_gl, LM_ST_EXCLUSIVE, 0, &ip->i_gh);
-	error = gfs2_glock_nq(&ip->i_gh);
-	if (error)
-		goto out_uninit;
-	if (&ip->i_inode == sdp->sd_rindex) {
-		struct gfs2_inode *m_ip = GFS2_I(sdp->sd_statfs_inode);
-
-		error = gfs2_glock_nq_init(m_ip->i_gl, LM_ST_EXCLUSIVE,
-					   GL_NOCACHE, &m_ip->i_gh);
-		if (error)
-			goto out_unlock;
-	}
-	return 0;
-
-out_unlock:
-	gfs2_glock_dq(&ip->i_gh);
-out_uninit:
-	gfs2_holder_uninit(&ip->i_gh);
-	return error;
-}
-
-static void gfs2_write_unlock(struct inode *inode)
-{
-	struct gfs2_inode *ip = GFS2_I(inode);
-	struct gfs2_sbd *sdp = GFS2_SB(inode);
-
-	if (&ip->i_inode == sdp->sd_rindex) {
-		struct gfs2_inode *m_ip = GFS2_I(sdp->sd_statfs_inode);
-
-		gfs2_glock_dq_uninit(&m_ip->i_gh);
-	}
-	gfs2_glock_dq_uninit(&ip->i_gh);
-}
-
 static int gfs2_iomap_page_prepare(struct inode *inode, loff_t pos,
 				   unsigned len, struct iomap *iomap)
 {
@@ -1119,11 +1079,6 @@ static int gfs2_iomap_begin_write(struct inode *inode, loff_t pos,
 	return ret;
 }
 
-static inline bool gfs2_iomap_need_write_lock(unsigned flags)
-{
-	return (flags & IOMAP_WRITE) && !(flags & IOMAP_DIRECT);
-}
-
 static int gfs2_iomap_begin(struct inode *inode, loff_t pos, loff_t length,
 			    unsigned flags, struct iomap *iomap,
 			    struct iomap *srcmap)
@@ -1136,12 +1091,6 @@ static int gfs2_iomap_begin(struct inode *inode, loff_t pos, loff_t length,
 		iomap->flags |= IOMAP_F_BUFFER_HEAD;
 
 	trace_gfs2_iomap_start(ip, pos, length, flags);
-	if (gfs2_iomap_need_write_lock(flags)) {
-		ret = gfs2_write_lock(inode);
-		if (ret)
-			goto out;
-	}
-
 	ret = __gfs2_iomap_get(inode, pos, length, flags, iomap, &mp);
 	if (ret)
 		goto out_unlock;
@@ -1169,10 +1118,7 @@ static int gfs2_iomap_begin(struct inode *inode, loff_t pos, loff_t length,
 	ret = gfs2_iomap_begin_write(inode, pos, length, flags, iomap, &mp);
 
 out_unlock:
-	if (ret && gfs2_iomap_need_write_lock(flags))
-		gfs2_write_unlock(inode);
 	release_metapath(&mp);
-out:
 	trace_gfs2_iomap_end(ip, iomap, ret);
 	return ret;
 }
@@ -1220,15 +1166,11 @@ static int gfs2_iomap_end(struct inode *inode, loff_t pos, loff_t length,
 	}
 
 	if (unlikely(!written))
-		goto out_unlock;
+		return 0;
 
 	if (iomap->flags & IOMAP_F_SIZE_CHANGED)
 		mark_inode_dirty(inode);
 	set_bit(GLF_DIRTY, &ip->i_gl->gl_flags);
-
-out_unlock:
-	if (gfs2_iomap_need_write_lock(flags))
-		gfs2_write_unlock(inode);
 	return 0;
 }
 
diff --git a/fs/gfs2/file.c b/fs/gfs2/file.c
index 55ec1cadc9e6..813154d60834 100644
--- a/fs/gfs2/file.c
+++ b/fs/gfs2/file.c
@@ -880,11 +880,38 @@ static ssize_t gfs2_file_buffered_write(struct kiocb *iocb, struct iov_iter *fro
 {
 	struct file *file = iocb->ki_filp;
 	struct inode *inode = file_inode(file);
+	struct gfs2_inode *ip = GFS2_I(inode);
+	struct gfs2_sbd *sdp = GFS2_SB(inode);
 	ssize_t ret;
 
+	gfs2_holder_init(ip->i_gl, LM_ST_EXCLUSIVE, 0, &ip->i_gh);
+	ret = gfs2_glock_nq(&ip->i_gh);
+	if (ret)
+		goto out_uninit;
+
+	if (inode == sdp->sd_rindex) {
+		struct gfs2_inode *m_ip = GFS2_I(sdp->sd_statfs_inode);
+
+		ret = gfs2_glock_nq_init(m_ip->i_gl, LM_ST_EXCLUSIVE,
+					 GL_NOCACHE, &m_ip->i_gh);
+		if (ret)
+			goto out_unlock;
+	}
+
 	current->backing_dev_info = inode_to_bdi(inode);
 	ret = iomap_file_buffered_write(iocb, from, &gfs2_iomap_ops);
 	current->backing_dev_info = NULL;
+
+	if (inode == sdp->sd_rindex) {
+		struct gfs2_inode *m_ip = GFS2_I(sdp->sd_statfs_inode);
+
+		gfs2_glock_dq_uninit(&m_ip->i_gh);
+	}
+
+out_unlock:
+	gfs2_glock_dq(&ip->i_gh);
+out_uninit:
+	gfs2_holder_uninit(&ip->i_gh);
 	return ret;
 }
 
-- 
2.26.3


_______________________________________________
Ocfs2-devel mailing list
Ocfs2-devel@oss.oracle.com
https://oss.oracle.com/mailman/listinfo/ocfs2-devel
