Return-Path: <SRS0=h27U=MK=oss.oracle.com=ocfs2-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6D025C636CD
	for <ocfs2-devel@archiver.kernel.org>; Sun, 18 Jul 2021 22:43:35 +0000 (UTC)
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id 20FCB6101A
	for <ocfs2-devel@archiver.kernel.org>; Sun, 18 Jul 2021 22:43:35 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 20FCB6101A
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=ocfs2-devel-bounces@oss.oracle.com
Received: from pps.filterd (m0246627.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 16IMh7dK029562;
	Sun, 18 Jul 2021 22:43:34 GMT
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
	by mx0b-00069f02.pphosted.com with ESMTP id 39vrn5g4u2-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Sun, 18 Jul 2021 22:43:34 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
	by userp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 16IMeK5l156190;
	Sun, 18 Jul 2021 22:43:33 GMT
Received: from oss.oracle.com (oss-old-reserved.oracle.com [137.254.22.2])
	by userp3030.oracle.com with ESMTP id 39umavr05x-1
	(version=TLSv1 cipher=AES256-SHA bits=256 verify=NO);
	Sun, 18 Jul 2021 22:43:33 +0000
Received: from localhost ([127.0.0.1] helo=lb-oss.oracle.com)
	by oss.oracle.com with esmtp (Exim 4.63)
	(envelope-from <ocfs2-devel-bounces@oss.oracle.com>)
	id 1m5FSQ-0002Wn-Hh; Sun, 18 Jul 2021 15:40:22 -0700
Received: from aserp3020.oracle.com ([141.146.126.70])
	by oss.oracle.com with esmtp (Exim 4.63)
	(envelope-from <agruenba@redhat.com>) id 1m5FSE-0002TW-6k
	for ocfs2-devel@oss.oracle.com; Sun, 18 Jul 2021 15:40:10 -0700
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
	by aserp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id
	16IMUxaa137541
	for <ocfs2-devel@oss.oracle.com>; Sun, 18 Jul 2021 22:40:10 GMT
Received: from mx0a-00069f01.pphosted.com (mx0a-00069f01.pphosted.com
	[205.220.165.26]) by aserp3020.oracle.com with ESMTP id 39uq13m4cf-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
	for <ocfs2-devel@oss.oracle.com>; Sun, 18 Jul 2021 22:40:09 +0000
Received: from pps.filterd (m0246575.ppops.net [127.0.0.1])
	by mx0b-00069f01.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id
	16IMWQ95029353
	for <ocfs2-devel@oss.oracle.com>; Sun, 18 Jul 2021 22:40:08 GMT
Received: from us-smtp-delivery-124.mimecast.com
	(us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by mx0b-00069f01.pphosted.com with ESMTP id 39upt43fuv-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
	for <ocfs2-devel@oss.oracle.com>; Sun, 18 Jul 2021 22:40:08 +0000
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
	[209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
	us-mta-120-XHO2893sNPeaRVaucOuwnQ-1; Sun, 18 Jul 2021 18:40:03 -0400
X-MC-Unique: XHO2893sNPeaRVaucOuwnQ-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com
	[10.5.11.12])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 1BB991084F57;
	Sun, 18 Jul 2021 22:40:02 +0000 (UTC)
Received: from max.com (unknown [10.40.195.75])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 51AC860C0F;
	Sun, 18 Jul 2021 22:39:56 +0000 (UTC)
From: Andreas Gruenbacher <agruenba@redhat.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Date: Mon, 19 Jul 2021 00:39:31 +0200
Message-Id: <20210718223932.2703330-6-agruenba@redhat.com>
In-Reply-To: <20210718223932.2703330-1-agruenba@redhat.com>
References: <20210718223932.2703330-1-agruenba@redhat.com>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
X-Proofpoint-SPF-Result: pass
X-Proofpoint-SPF-Record: v=spf1 ip4:103.23.64.2 ip4:103.23.65.2
	ip4:103.23.66.26 ip4:103.23.67.26
	ip4:107.21.15.141 ip4:108.177.8.0/21 ip4:128.17.0.0/20
	ip4:128.17.128.0/20
	ip4:128.17.192.0/20 ip4:128.17.64.0/20 ip4:128.245.0.0/20
	ip4:128.245.64.0/20 ip4:13.110.208.0/21 ip4:13.111.0.0/16
	ip4:136.147.128.0/20 ip4:136.147.176.0/20 ip4:148.105.8.0/21
	ip4:148.139.0.2 include:spf1.redhat.com -all
X-Proofpoint-SPF-VenPass: Allowed
X-Source-IP: 170.10.133.124
X-ServerName: us-smtp-delivery-124.mimecast.com
X-Proofpoint-SPF-Result: pass
X-Proofpoint-SPF-Record: v=spf1 ip4:103.23.64.2 ip4:103.23.65.2
	ip4:103.23.66.26 ip4:103.23.67.26
	ip4:107.21.15.141 ip4:108.177.8.0/21 ip4:128.17.0.0/20
	ip4:128.17.128.0/20
	ip4:128.17.192.0/20 ip4:128.17.64.0/20 ip4:128.245.0.0/20
	ip4:128.245.64.0/20 ip4:13.110.208.0/21 ip4:13.111.0.0/16
	ip4:136.147.128.0/20 ip4:136.147.176.0/20 ip4:148.105.8.0/21
	ip4:148.139.0.2 include:spf1.redhat.com -all
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=10049
	signatures=668682
X-Proofpoint-Spam-Reason: safe
X-Spam: OrgSafeList
X-SpamRule: orgsafelist
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=10049
	signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0
	malwarescore=0
	mlxlogscore=738 suspectscore=0 bulkscore=0 spamscore=0 phishscore=0
	mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
	engine=8.12.0-2104190000 definitions=main-2107180153
Cc: cluster-devel@redhat.com, Jan Kara <jack@suse.cz>,
        Andreas Gruenbacher <agruenba@redhat.com>,
        linux-kernel@vger.kernel.org, Christoph Hellwig <hch@infradead.org>,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        linux-fsdevel@vger.kernel.org, ocfs2-devel@oss.oracle.com
Subject: [Ocfs2-devel] [PATCH v2 5/6] iov_iter: Introduce
	ITER_FLAG_FAST_ONLY flag
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
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=10049 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 malwarescore=0 spamscore=0
 mlxscore=0 adultscore=0 mlxlogscore=999 suspectscore=0 bulkscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2104190000
 definitions=main-2107180154
X-Proofpoint-GUID: 1V0ccyh6SFFFNKYshgge5Hw1ifcb0DwK
X-Proofpoint-ORIG-GUID: 1V0ccyh6SFFFNKYshgge5Hw1ifcb0DwK

Introduce a new ITER_FLAG_FAST_ONLY flag to indicate to get_user_pages to use
the FOLL_FAST_ONLY flag.  This will cause get_user_pages to fail when it would
otherwise fault in a page.

Currently, the ITER_FLAG_FAST_ONLY flag is only checked in iov_iter_get_pages
and iov_iter_get_pages_alloc.  This is enough for iomaop_dio_rw(), but it may
make sense to check for this flag in other contexts as well.

Signed-off-by: Andreas Gruenbacher <agruenba@redhat.com>
---
 include/linux/uio.h | 15 ++++++++++++---
 lib/iov_iter.c      | 20 +++++++++++++++-----
 2 files changed, 27 insertions(+), 8 deletions(-)

diff --git a/include/linux/uio.h b/include/linux/uio.h
index 74f819c41735..d3d629c2153a 100644
--- a/include/linux/uio.h
+++ b/include/linux/uio.h
@@ -18,6 +18,9 @@ struct kvec {
 };
 
 enum iter_type {
+	/* set if get_user_pages should use FOLL_FAST_ONLY */
+	ITER_FLAG_FAST_ONLY = 2,
+
 	/* iter types */
 	ITER_IOVEC = 4,
 	ITER_KVEC = 8,
@@ -30,8 +33,9 @@ enum iter_type {
 struct iov_iter {
 	/*
 	 * Bit 0 is the read/write bit, set if we're writing.
-	 * Bit 1 is the BVEC_FLAG_NO_REF bit, set if type is a bvec and
-	 * the caller isn't expecting to drop a page reference when done.
+	 * Bit 1 is the ITER_FLAG_FAST_ONLY bit, set if get_user_pages
+	 * should use the FOLL_FAST_ONLY flag when trying to fault in pages
+	 * (only useful for type ITER_IOVEC).
 	 */
 	unsigned int type;
 	size_t iov_offset;
@@ -55,7 +59,7 @@ struct iov_iter {
 
 static inline enum iter_type iov_iter_type(const struct iov_iter *i)
 {
-	return i->type & ~(READ | WRITE);
+	return i->type & ~(READ | WRITE | ITER_FLAG_FAST_ONLY);
 }
 
 static inline bool iter_is_iovec(const struct iov_iter *i)
@@ -93,6 +97,11 @@ static inline unsigned char iov_iter_rw(const struct iov_iter *i)
 	return i->type & (READ | WRITE);
 }
 
+static inline bool iov_iter_is_fast_only(const struct iov_iter *i)
+{
+	return i->type & ITER_FLAG_FAST_ONLY;
+}
+
 /*
  * Total number of bytes covered by an iovec.
  *
diff --git a/lib/iov_iter.c b/lib/iov_iter.c
index 3beecf8f77de..182ff2afed19 100644
--- a/lib/iov_iter.c
+++ b/lib/iov_iter.c
@@ -1538,6 +1538,8 @@ ssize_t iov_iter_get_pages(struct iov_iter *i,
 		   struct page **pages, size_t maxsize, unsigned maxpages,
 		   size_t *start)
 {
+	unsigned int gup_flags = 0;
+
 	if (maxsize > i->count)
 		maxsize = i->count;
 
@@ -1548,6 +1550,11 @@ ssize_t iov_iter_get_pages(struct iov_iter *i,
 	if (unlikely(iov_iter_is_discard(i)))
 		return -EFAULT;
 
+	if (iov_iter_rw(i) != WRITE)
+		gup_flags |= FOLL_WRITE;
+	if (iov_iter_is_fast_only(i))
+		gup_flags |= FOLL_FAST_ONLY;
+
 	iterate_all_kinds(i, maxsize, v, ({
 		unsigned long addr = (unsigned long)v.iov_base;
 		size_t len = v.iov_len + (*start = addr & (PAGE_SIZE - 1));
@@ -1558,9 +1565,7 @@ ssize_t iov_iter_get_pages(struct iov_iter *i,
 			len = maxpages * PAGE_SIZE;
 		addr &= ~(PAGE_SIZE - 1);
 		n = DIV_ROUND_UP(len, PAGE_SIZE);
-		res = get_user_pages_fast(addr, n,
-				iov_iter_rw(i) != WRITE ?  FOLL_WRITE : 0,
-				pages);
+		res = get_user_pages_fast(addr, n, gup_flags, pages);
 		if (unlikely(res < 0))
 			return res;
 		return (res == n ? len : res * PAGE_SIZE) - *start;
@@ -1665,6 +1670,7 @@ ssize_t iov_iter_get_pages_alloc(struct iov_iter *i,
 		   struct page ***pages, size_t maxsize,
 		   size_t *start)
 {
+	unsigned int gup_flags = 0;
 	struct page **p;
 
 	if (maxsize > i->count)
@@ -1677,6 +1683,11 @@ ssize_t iov_iter_get_pages_alloc(struct iov_iter *i,
 	if (unlikely(iov_iter_is_discard(i)))
 		return -EFAULT;
 
+	if (iov_iter_rw(i) != WRITE)
+		gup_flags |= FOLL_WRITE;
+	if (iov_iter_is_fast_only(i))
+		gup_flags |= FOLL_FAST_ONLY;
+
 	iterate_all_kinds(i, maxsize, v, ({
 		unsigned long addr = (unsigned long)v.iov_base;
 		size_t len = v.iov_len + (*start = addr & (PAGE_SIZE - 1));
@@ -1688,8 +1699,7 @@ ssize_t iov_iter_get_pages_alloc(struct iov_iter *i,
 		p = get_pages_array(n);
 		if (!p)
 			return -ENOMEM;
-		res = get_user_pages_fast(addr, n,
-				iov_iter_rw(i) != WRITE ?  FOLL_WRITE : 0, p);
+		res = get_user_pages_fast(addr, n, gup_flags, p);
 		if (unlikely(res < 0)) {
 			kvfree(p);
 			return res;
-- 
2.26.3


_______________________________________________
Ocfs2-devel mailing list
Ocfs2-devel@oss.oracle.com
https://oss.oracle.com/mailman/listinfo/ocfs2-devel
