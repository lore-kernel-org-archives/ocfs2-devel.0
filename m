Return-Path: <SRS0=myWd=PO=oss.oracle.com=ocfs2-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2ABADC433EF
	for <ocfs2-devel@archiver.kernel.org>; Tue, 26 Oct 2021 09:45:00 +0000 (UTC)
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id CCA8B60FC2
	for <ocfs2-devel@archiver.kernel.org>; Tue, 26 Oct 2021 09:44:59 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org CCA8B60FC2
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=oss.oracle.com
Received: from pps.filterd (m0246629.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 19Q9f6bD020036;
	Tue, 26 Oct 2021 09:44:59 GMT
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
	by mx0b-00069f02.pphosted.com with ESMTP id 3bx4g12c16-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 26 Oct 2021 09:44:59 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
	by userp3020.oracle.com (8.16.1.2/8.16.1.2) with SMTP id 19Q9Zri9056283;
	Tue, 26 Oct 2021 09:44:57 GMT
Received: from oss.oracle.com (oss-old-reserved.oracle.com [137.254.22.2])
	by userp3020.oracle.com with ESMTP id 3bx4gp0bhd-1
	(version=TLSv1 cipher=AES256-SHA bits=256 verify=NO);
	Tue, 26 Oct 2021 09:44:57 +0000
Received: from localhost ([127.0.0.1] helo=lb-oss.oracle.com)
	by oss.oracle.com with esmtp (Exim 4.63)
	(envelope-from <ocfs2-devel-bounces@oss.oracle.com>)
	id 1mfJ0q-0000be-JY; Tue, 26 Oct 2021 02:44:56 -0700
Received: from userp3020.oracle.com ([156.151.31.79])
	by oss.oracle.com with esmtp (Exim 4.63)
	(envelope-from <agruenba@redhat.com>) id 1mfJ0o-0000bH-Et
	for ocfs2-devel@oss.oracle.com; Tue, 26 Oct 2021 02:44:54 -0700
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
	by userp3020.oracle.com (8.16.1.2/8.16.1.2) with SMTP id 19Q9Zr2L056312
	for <ocfs2-devel@oss.oracle.com>; Tue, 26 Oct 2021 09:44:54 GMT
Received: from mx0b-00069f01.pphosted.com (mx0b-00069f01.pphosted.com
	[205.220.177.26]) by userp3020.oracle.com with ESMTP id 3bx4gp0bfb-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
	for <ocfs2-devel@oss.oracle.com>; Tue, 26 Oct 2021 09:44:54 +0000
Received: from pps.filterd (m0246578.ppops.net [127.0.0.1])
	by mx0b-00069f01.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id
	19Q7Nvjf001888
	for <ocfs2-devel@oss.oracle.com>; Tue, 26 Oct 2021 09:44:53 GMT
Received: from us-smtp-delivery-124.mimecast.com
	(us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by mx0b-00069f01.pphosted.com with ESMTP id 3bxd8hs9p5-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
	for <ocfs2-devel@oss.oracle.com>; Tue, 26 Oct 2021 09:44:52 +0000
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
	[209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
	us-mta-153-saoAI_GvNBugHIjyLU4dsQ-1; Tue, 26 Oct 2021 05:44:42 -0400
X-MC-Unique: saoAI_GvNBugHIjyLU4dsQ-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com
	[10.5.11.23])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 0955887950D;
	Tue, 26 Oct 2021 09:44:40 +0000 (UTC)
Received: from max.com (unknown [10.40.193.143])
	by smtp.corp.redhat.com (Postfix) with ESMTP id D9B8419C79;
	Tue, 26 Oct 2021 09:44:31 +0000 (UTC)
From: Andreas Gruenbacher <agruenba@redhat.com>
To: "Theodore Ts'o" <tytso@mit.edu>
Date: Tue, 26 Oct 2021 11:44:30 +0200
Message-Id: <20211026094430.3669156-1-agruenba@redhat.com>
In-Reply-To: <YXeOVZqer+GFBkXO@mit.edu>
References: <YXeOVZqer+GFBkXO@mit.edu>
	<20211019134204.3382645-1-agruenba@redhat.com>
	<CAHk-=wh0_3y5s7-G74U0Pcjm7Y_yHB608NYrQSvgogVNBxsWSQ@mail.gmail.com>
	<YXBFqD9WVuU8awIv@arm.com>
	<CAHk-=wgv=KPZBJGnx_O5-7hhST8CL9BN4wJwtVuycjhv_1MmvQ@mail.gmail.com>
	<YXCbv5gdfEEtAYo8@arm.com>
	<CAHk-=wgP058PNY8eoWW=5uRMox-PuesDMrLsrCWPS+xXhzbQxQ@mail.gmail.com>
	<YXL9tRher7QVmq6N@arm.com>
	<CAHc6FU6JC4ZOwA8t854WbNdmuiNL9DPq0FPga8guATaoCtvsaw@mail.gmail.com>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
X-Proofpoint-SPF-Result: pass
X-Proofpoint-SPF-Record: v=spf1 ip4:103.23.64.2 ip4:103.23.65.2
	ip4:103.23.66.26 ip4:103.23.67.26
	ip4:107.21.15.141 ip4:108.177.8.0/21 ip4:128.17.0.0/20
	ip4:128.17.128.0/20
	ip4:128.17.192.0/20 ip4:128.17.64.0/20 ip4:128.245.0.0/20
	ip4:128.245.64.0/20 ip4:13.110.208.0/21 ip4:13.110.216.0/22
	ip4:13.110.224.0/20 ip4:13.111.0.0/16 ip4:136.147.128.0/20
	include:spf1.redhat.com -all
X-Proofpoint-SPF-VenPass: Allowed
X-Source-IP: 170.10.129.124
X-ServerName: us-smtp-delivery-124.mimecast.com
X-Proofpoint-SPF-Result: pass
X-Proofpoint-SPF-Record: v=spf1 ip4:103.23.64.2 ip4:103.23.65.2
	ip4:103.23.66.26 ip4:103.23.67.26
	ip4:107.21.15.141 ip4:108.177.8.0/21 ip4:128.17.0.0/20
	ip4:128.17.128.0/20
	ip4:128.17.192.0/20 ip4:128.17.64.0/20 ip4:128.245.0.0/20
	ip4:128.245.64.0/20 ip4:13.110.208.0/21 ip4:13.110.216.0/22
	ip4:13.110.224.0/20 ip4:13.111.0.0/16 ip4:136.147.128.0/20
	include:spf1.redhat.com -all
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10148
	signatures=668683
X-Proofpoint-Spam-Reason: safe
X-Spam: OrgSafeList
X-SpamRule: orgsafelist
Cc: kvm-ppc@vger.kernel.org, Christoph Hellwig <hch@infradead.org>,
        cluster-devel <cluster-devel@redhat.com>, Jan Kara <jack@suse.cz>,
        Andreas Gruenbacher <agruenba@redhat.com>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Paul Mackerras <paulus@ozlabs.org>,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>,
        linux-btrfs <linux-btrfs@vger.kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        ocfs2-devel@oss.oracle.com
Subject: Re: [Ocfs2-devel] [PATCH v8 00/17] gfs2: Fix mmap + page fault
	deadlocks
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
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 malwarescore=0
 adultscore=0 suspectscore=0 bulkscore=0 mlxscore=0 spamscore=0
 mlxlogscore=999 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2110150000 definitions=main-2110260054
X-Proofpoint-ORIG-GUID: P7jPRiQGFPBUiuKUBtkB5xNcA9VUFk0q
X-Proofpoint-GUID: P7jPRiQGFPBUiuKUBtkB5xNcA9VUFk0q

Ted,

here's an updated version of Dave Hansen's original commit, but note
that generic/208 won't run on ext4 with data journaling enabled:

  $ MOUNT_OPTIONS='-o data=journal' TEST_DIR=/mnt/test TEST_DEV=/dev/vdb ./tests/generic/208
  QA output created by 208
  208 not run: ext4 data journaling doesn't support O_DIRECT

Thanks,
Andreas

--

Based on commit 998ef75ddb57 ("fs: do not prefault sys_write() user
buffer pages") by Dave Hansen <dave.hansen@linux.intel.com>, but:

* Fix generic_perform_write as well as iomap_write_iter.

* copy_page_from_iter_atomic() doesn't trigger page faults, so there's no need
  to disable page faults around it [see commit 9e8c2af96e0d ("callers of
  iov_copy_from_user_atomic() don't need pagecache_disable()")].

* If fault_in_iov_iter_readable() fails to fault in the entire buffer,
  we still want to read everything up to the fault position.  This depends on
  commit a6294593e8a1 ("iov_iter: Turn iov_iter_fault_in_readable into
  fault_in_iov_iter_readable").

Signed-off-by: Andreas Gruenbacher <agruenba@redhat.com>
---
 fs/iomap/buffered-io.c | 20 +++++++-------------
 mm/filemap.c           | 20 +++++++-------------
 2 files changed, 14 insertions(+), 26 deletions(-)

diff --git a/fs/iomap/buffered-io.c b/fs/iomap/buffered-io.c
index 1753c26c8e76..d8809cd9ab31 100644
--- a/fs/iomap/buffered-io.c
+++ b/fs/iomap/buffered-io.c
@@ -744,17 +744,6 @@ static loff_t iomap_write_iter(struct iomap_iter *iter, struct iov_iter *i)
 		if (bytes > length)
 			bytes = length;
 
-		/*
-		 * Bring in the user page that we'll copy from _first_.
-		 * Otherwise there's a nasty deadlock on copying from the
-		 * same page as we're writing to, without it being marked
-		 * up-to-date.
-		 */
-		if (unlikely(fault_in_iov_iter_readable(i, bytes))) {
-			status = -EFAULT;
-			break;
-		}
-
 		status = iomap_write_begin(iter, pos, bytes, &page);
 		if (unlikely(status))
 			break;
@@ -777,9 +766,14 @@ static loff_t iomap_write_iter(struct iomap_iter *iter, struct iov_iter *i)
 			 * halfway through, might be a race with munmap,
 			 * might be severe memory pressure.
 			 */
-			if (copied)
+			if (copied) {
 				bytes = copied;
-			goto again;
+				goto again;
+			}
+			if (fault_in_iov_iter_readable(i, bytes) != bytes)
+				goto again;
+			status = -EFAULT;
+			break;
 		}
 		pos += status;
 		written += status;
diff --git a/mm/filemap.c b/mm/filemap.c
index 4dd5edcd39fd..467cdb7d086d 100644
--- a/mm/filemap.c
+++ b/mm/filemap.c
@@ -3751,17 +3751,6 @@ ssize_t generic_perform_write(struct file *file,
 						iov_iter_count(i));
 
 again:
-		/*
-		 * Bring in the user page that we will copy from _first_.
-		 * Otherwise there's a nasty deadlock on copying from the
-		 * same page as we're writing to, without it being marked
-		 * up-to-date.
-		 */
-		if (unlikely(fault_in_iov_iter_readable(i, bytes))) {
-			status = -EFAULT;
-			break;
-		}
-
 		if (fatal_signal_pending(current)) {
 			status = -EINTR;
 			break;
@@ -3794,9 +3783,14 @@ ssize_t generic_perform_write(struct file *file,
 			 * halfway through, might be a race with munmap,
 			 * might be severe memory pressure.
 			 */
-			if (copied)
+			if (copied) {
 				bytes = copied;
-			goto again;
+				goto again;
+			}
+			if (fault_in_iov_iter_readable(i, bytes) != bytes)
+				goto again;
+			status = -EFAULT;
+			break;
 		}
 		pos += status;
 		written += status;
-- 
2.26.3


_______________________________________________
Ocfs2-devel mailing list
Ocfs2-devel@oss.oracle.com
https://oss.oracle.com/mailman/listinfo/ocfs2-devel
