Return-Path: <SRS0=ZEQb=M2=oss.oracle.com=ocfs2-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7E23DC4338F
	for <ocfs2-devel@archiver.kernel.org>; Tue,  3 Aug 2021 19:19:08 +0000 (UTC)
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id 240BC60F56
	for <ocfs2-devel@archiver.kernel.org>; Tue,  3 Aug 2021 19:19:08 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org 240BC60F56
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=oss.oracle.com
Received: from pps.filterd (m0246630.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 173JBx99003120;
	Tue, 3 Aug 2021 19:19:07 GMT
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
	by mx0b-00069f02.pphosted.com with ESMTP id 3a70pjsyh6-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 03 Aug 2021 19:19:06 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
	by userp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 173JBOc8193830;
	Tue, 3 Aug 2021 19:19:06 GMT
Received: from oss.oracle.com (oss-old-reserved.oracle.com [137.254.22.2])
	by userp3030.oracle.com with ESMTP id 3a4un07scd-1
	(version=TLSv1 cipher=AES256-SHA bits=256 verify=NO);
	Tue, 03 Aug 2021 19:19:05 +0000
Received: from localhost ([127.0.0.1] helo=lb-oss.oracle.com)
	by oss.oracle.com with esmtp (Exim 4.63)
	(envelope-from <ocfs2-devel-bounces@oss.oracle.com>)
	id 1mAzwO-00005G-Nn; Tue, 03 Aug 2021 12:19:04 -0700
Received: from userp3020.oracle.com ([156.151.31.79])
	by oss.oracle.com with esmtp (Exim 4.63)
	(envelope-from <agruenba@redhat.com>) id 1mAzvv-0008U0-7B
	for ocfs2-devel@oss.oracle.com; Tue, 03 Aug 2021 12:18:35 -0700
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
	by userp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id
	173JBL8b079701
	for <ocfs2-devel@oss.oracle.com>; Tue, 3 Aug 2021 19:18:34 GMT
Received: from mx0a-00069f01.pphosted.com (mx0a-00069f01.pphosted.com
	[205.220.165.26]) by userp3020.oracle.com with ESMTP id 3a5g9vm5qu-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
	for <ocfs2-devel@oss.oracle.com>; Tue, 03 Aug 2021 19:18:33 +0000
Received: from pps.filterd (m0246573.ppops.net [127.0.0.1])
	by mx0b-00069f01.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id
	173JE8TC016821
	for <ocfs2-devel@oss.oracle.com>; Tue, 3 Aug 2021 19:18:32 GMT
Received: from us-smtp-delivery-124.mimecast.com
	(us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by mx0b-00069f01.pphosted.com with ESMTP id 3a77nvav25-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
	for <ocfs2-devel@oss.oracle.com>; Tue, 03 Aug 2021 19:18:32 +0000
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
	[209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
	us-mta-102-F09b58fmOROfEYdP18qfSQ-1; Tue, 03 Aug 2021 15:18:29 -0400
X-MC-Unique: F09b58fmOROfEYdP18qfSQ-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com
	[10.5.11.12])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id C48F83E741;
	Tue,  3 Aug 2021 19:18:27 +0000 (UTC)
Received: from max.com (unknown [10.40.193.155])
	by smtp.corp.redhat.com (Postfix) with ESMTP id EC59860C0F;
	Tue,  3 Aug 2021 19:18:20 +0000 (UTC)
From: Andreas Gruenbacher <agruenba@redhat.com>
To: Linus Torvalds <torvalds@linux-foundation.org>,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        Christoph Hellwig <hch@infradead.org>,
        "Darrick J. Wong" <djwong@kernel.org>,
        Paul Mackerras <paulus@ozlabs.org>
Date: Tue,  3 Aug 2021 21:18:06 +0200
Message-Id: <20210803191818.993968-1-agruenba@redhat.com>
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
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=10065
	signatures=668682
X-Proofpoint-Spam-Reason: safe
X-Spam: OrgSafeList
X-SpamRule: orgsafelist
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=10065
	signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0
	malwarescore=0 phishscore=0
	spamscore=0 adultscore=0 suspectscore=0 mlxlogscore=999 bulkscore=0
	classifier=spam adjust=0 reason=mlx scancount=1
	engine=8.12.0-2107140000 definitions=main-2108030123
Cc: Jan Kara <jack@suse.cz>, Andreas Gruenbacher <agruenba@redhat.com>,
        linux-kernel@vger.kernel.org, cluster-devel@redhat.com,
        kvm-ppc@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        ocfs2-devel@oss.oracle.com
Subject: [Ocfs2-devel] [PATCH v5 00/12] gfs2: Fix mmap + page fault deadlocks
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
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=10065 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 phishscore=0 malwarescore=0
 suspectscore=0 mlxscore=0 adultscore=0 mlxlogscore=999 spamscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2107140000
 definitions=main-2108030123
X-Proofpoint-GUID: RRkUPneoTTVh4wyfKX69bh74xSgYWL9E
X-Proofpoint-ORIG-GUID: RRkUPneoTTVh4wyfKX69bh74xSgYWL9E

Hi all,

here's another update on top of v5.14-rc4.  There seems to be a bug in
get_user_pages_fast when called with FOLL_FAST_ONLY; please see below.

Changes:

 * Change fault_in_pages_{readable,writeable} to return the number of
   bytes that should be accessible instead of failing outright when
   part of the requested region cannot be faulted in.  Change
   iov_iter_fault_in_readable to those same semantics.

 * Add fault_in_iov_iter_writeable for safely faulting in pages for
   writing without modifying the pages.


With this patch queue, fstest generic/208 (aio-dio-invalidate-failure.c)
endlessly spins in gfs2_file_direct_write.  It looks as if there's a bug
in get_user_pages_fast when called with FOLL_FAST_ONLY:

 (1) The test case performs an aio write into a 32 MB buffer.

 (2) The buffer is initially not in memory, so when iomap_dio_rw() ->
     ... -> bio_iov_iter_get_pages() is called with the iter->noio flag
     set, we get to get_user_pages_fast() with FOLL_FAST_ONLY set.
     get_user_pages_fast() returns 0, which causes
     bio_iov_iter_get_pages to return -EFAULT.

 (3) Then gfs2_file_direct_write faults in the entire buffer with
     fault_in_iov_iter_readable(), which succeeds.

 (4) With the buffer in memory, we retry the iomap_dio_rw() ->
     ... -> bio_iov_iter_get_pages() -> ... -> get_user_pages_fast().
     This should succeed now, but get_user_pages_fast() still returns 0.

 (5) Thus we end up in step (3) again.

The buffered writes generic/208 performs are unrelated to this hang.


Apart from the generic/208 hang, gfs2 still needs a better strategy for
faulting in more reasonable chunks of memory at a time and for resuming
requests after faulting in pages.  We've got some of the pieces in place
for safely allowing that, but more work remains to be done.


For immediate consideration by Al Viro:

  iov_iter: Fix iov_iter_get_pages{,_alloc} page fault return value


For immediate consideration by Paul Mackerras:

  powerpc/kvm: Fix kvm_use_magic_page


Thanks,
Andreas


Andreas Gruenbacher (12):
  iov_iter: Fix iov_iter_get_pages{,_alloc} page fault return value
  powerpc/kvm: Fix kvm_use_magic_page
  Turn fault_in_pages_{readable,writeable} into
    fault_in_{readable,writeable}
  Turn iov_iter_fault_in_readable into fault_in_iov_iter_readable
  iov_iter: Introduce fault_in_iov_iter_writeable
  gfs2: Add wrapper for iomap_file_buffered_write
  gfs2: Fix mmap + page fault deadlocks for buffered I/O
  iomap: Fix iomap_dio_rw return value for user copies
  iomap: Support restarting direct I/O requests after user copy failures
  iomap: Add done_before argument to iomap_dio_rw
  iov_iter: Introduce noio flag to disable page faults
  gfs2: Fix mmap + page fault deadlocks for direct I/O

 arch/powerpc/kernel/kvm.c           |   3 +-
 arch/powerpc/kernel/signal_32.c     |   4 +-
 arch/powerpc/kernel/signal_64.c     |   2 +-
 arch/x86/kernel/fpu/signal.c        |   8 +-
 drivers/gpu/drm/armada/armada_gem.c |   7 +-
 fs/btrfs/file.c                     |   8 +-
 fs/btrfs/ioctl.c                    |   7 +-
 fs/ext4/file.c                      |   5 +-
 fs/f2fs/file.c                      |   6 +-
 fs/fuse/file.c                      |   2 +-
 fs/gfs2/file.c                      |  95 ++++++++++++++++++++---
 fs/iomap/buffered-io.c              |   2 +-
 fs/iomap/direct-io.c                |  28 +++++--
 fs/ntfs/file.c                      |   2 +-
 fs/xfs/xfs_file.c                   |   6 +-
 fs/zonefs/super.c                   |   4 +-
 include/linux/iomap.h               |  11 ++-
 include/linux/pagemap.h             |  58 +-------------
 include/linux/uio.h                 |   4 +-
 lib/iov_iter.c                      | 107 ++++++++++++++++++++------
 mm/filemap.c                        |   4 +-
 mm/gup.c                            | 113 ++++++++++++++++++++++++++++
 22 files changed, 360 insertions(+), 126 deletions(-)

-- 
2.26.3


_______________________________________________
Ocfs2-devel mailing list
Ocfs2-devel@oss.oracle.com
https://oss.oracle.com/mailman/listinfo/ocfs2-devel
