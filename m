Return-Path: <SRS0=iO0D=PV=oss.oracle.com=ocfs2-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 35BB8C433F5
	for <ocfs2-devel@archiver.kernel.org>; Tue,  2 Nov 2021 13:54:50 +0000 (UTC)
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id CA3DA60EDF
	for <ocfs2-devel@archiver.kernel.org>; Tue,  2 Nov 2021 13:54:49 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org CA3DA60EDF
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=oss.oracle.com
Received: from pps.filterd (m0246630.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 1A2DOxGL001780;
	Tue, 2 Nov 2021 13:54:48 GMT
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
	by mx0b-00069f02.pphosted.com with ESMTP id 3c27r5f58t-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 02 Nov 2021 13:54:48 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
	by userp3030.oracle.com (8.16.1.2/8.16.1.2) with SMTP id 1A2DogAY058146;
	Tue, 2 Nov 2021 13:54:47 GMT
Received: from oss.oracle.com (oss-old-reserved.oracle.com [137.254.22.2])
	by userp3030.oracle.com with ESMTP id 3c27k514wm-1
	(version=TLSv1 cipher=AES256-SHA bits=256 verify=NO);
	Tue, 02 Nov 2021 13:54:47 +0000
Received: from localhost ([127.0.0.1] helo=lb-oss.oracle.com)
	by oss.oracle.com with esmtp (Exim 4.63)
	(envelope-from <ocfs2-devel-bounces@oss.oracle.com>)
	id 1mhuFS-0002O8-DM; Tue, 02 Nov 2021 06:54:46 -0700
Received: from userp3030.oracle.com ([156.151.31.80])
	by oss.oracle.com with esmtp (Exim 4.63)
	(envelope-from <agruenba@redhat.com>) id 1mhuFQ-0002Ni-J0
	for ocfs2-devel@oss.oracle.com; Tue, 02 Nov 2021 06:54:44 -0700
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
	by userp3030.oracle.com (8.16.1.2/8.16.1.2) with SMTP id 1A2Dohqq058207
	for <ocfs2-devel@oss.oracle.com>; Tue, 2 Nov 2021 13:54:44 GMT
Received: from mx0b-00069f01.pphosted.com (mx0b-00069f01.pphosted.com
	[205.220.177.26]) by userp3030.oracle.com with ESMTP id 3c27k514v1-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
	for <ocfs2-devel@oss.oracle.com>; Tue, 02 Nov 2021 13:54:44 +0000
Received: from pps.filterd (m0246580.ppops.net [127.0.0.1])
	by mx0b-00069f01.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id
	1A2C8d9O018214
	for <ocfs2-devel@oss.oracle.com>; Tue, 2 Nov 2021 13:54:43 GMT
Received: from us-smtp-delivery-124.mimecast.com
	(us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by mx0b-00069f01.pphosted.com with ESMTP id 3c3530hbvw-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
	for <ocfs2-devel@oss.oracle.com>; Tue, 02 Nov 2021 13:54:42 +0000
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
	[209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
	us-mta-36-MREFlxGwObSgtBCBzsMCpg-1; Tue, 02 Nov 2021 09:54:38 -0400
X-MC-Unique: MREFlxGwObSgtBCBzsMCpg-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com
	[10.5.11.22])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 3AD4E100C665;
	Tue,  2 Nov 2021 13:54:36 +0000 (UTC)
Received: from max.localdomain (unknown [10.40.195.95])
	by smtp.corp.redhat.com (Postfix) with ESMTP id BBD771017CF5;
	Tue,  2 Nov 2021 13:54:23 +0000 (UTC)
From: Andreas Gruenbacher <agruenba@redhat.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Date: Tue,  2 Nov 2021 14:54:22 +0100
Message-Id: <20211102135422.121093-1-agruenba@redhat.com>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
X-Proofpoint-SPF-Result: pass
X-Proofpoint-SPF-Record: v=spf1 ip4:107.21.15.141 ip4:108.177.8.0/21
	ip4:128.17.0.0/20
	ip4:128.17.128.0/20 ip4:128.17.192.0/20 ip4:128.17.64.0/20
	ip4:128.245.0.0/20 ip4:128.245.64.0/20 ip4:13.110.208.0/21
	ip4:13.110.216.0/22 ip4:13.110.224.0/20 ip4:13.111.0.0/16
	ip4:136.147.128.0/20 ip4:136.147.176.0/20 ip4:148.105.8.0/21
	ip4:148.139.0.2 ip4:148.139.1.2 include:spf1.redhat.com -all
X-Proofpoint-SPF-VenPass: Allowed
X-Source-IP: 170.10.133.124
X-ServerName: us-smtp-delivery-124.mimecast.com
X-Proofpoint-SPF-Result: pass
X-Proofpoint-SPF-Record: v=spf1 ip4:107.21.15.141 ip4:108.177.8.0/21
	ip4:128.17.0.0/20
	ip4:128.17.128.0/20 ip4:128.17.192.0/20 ip4:128.17.64.0/20
	ip4:128.245.0.0/20 ip4:128.245.64.0/20 ip4:13.110.208.0/21
	ip4:13.110.216.0/22 ip4:13.110.224.0/20 ip4:13.111.0.0/16
	ip4:136.147.128.0/20 ip4:136.147.176.0/20 ip4:148.105.8.0/21
	ip4:148.139.0.2 ip4:148.139.1.2 include:spf1.redhat.com -all
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10155
	signatures=668683
X-Proofpoint-Spam-Reason: safe
X-Spam: OrgSafeList
X-SpamRule: orgsafelist
Cc: kvm-ppc@vger.kernel.org, Paul Mackerras <paulus@ozlabs.org>,
        cluster-devel@redhat.com, Jan Kara <jack@suse.cz>,
        Andreas Gruenbacher <agruenba@redhat.com>,
        Catalin Marinas <catalin.marinas@arm.com>,
        linux-kernel@vger.kernel.org, Christoph Hellwig <hch@infradead.org>,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        linux-fsdevel@vger.kernel.org, linux-btrfs@vger.kernel.org,
        ocfs2-devel@oss.oracle.com
Subject: [Ocfs2-devel] [GIT PULL] gfs2: Fix mmap + page fault deadlocks
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
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10155 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 mlxscore=0 spamscore=0
 malwarescore=0 mlxlogscore=999 adultscore=0 phishscore=0 bulkscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2110150000
 definitions=main-2111020082
X-Proofpoint-ORIG-GUID: 1-ZcUKDgT4k0RKmtcY_Fi0h1Wv_UOUTD
X-Proofpoint-GUID: 1-ZcUKDgT4k0RKmtcY_Fi0h1Wv_UOUTD

Hi Linus,

please consider pulling these fixes for the gfs2 memory map + page fault
deadlocks.

Stephen Rothwell has pointed out the following merge conflict between
commit:

  bb523b406c84 ("gup: Turn fault_in_pages_{readable,writeable} into fault_in_{readable,writeable}")

from this patch set and the following two commits in your tree:

  fcfb7163329c ("x86/fpu/signal: Move xstate clearing out of copy_fpregs_to_sigframe()")
  a2a8fd9a3efd ("x86/fpu/signal: Change return code of restore_fpregs_from_user() to boolean")

This is due to the fault_in_{pages_ =>}readable rename, and commit
fcfb7163329c eliminating the call to fault_in_pages_writeable() from
copy_fpstate_to_sigframe().  Stephen's conflict notification can be
found here:

https://lore.kernel.org/linux-next/20211015150420.617125bd@canb.auug.org.au/

Thanks,
Andreas


The following changes since commit 64570fbc14f8d7cb3fe3995f20e26bc25ce4b2cc:

  Linux 5.15-rc5 (2021-10-10 17:01:59 -0700)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/gfs2/linux-gfs2.git tags/gfs2-v5.15-rc5-mmap-fault

for you to fetch changes up to b01b2d72da25c000aeb124bc78daf3fb998be2b6:

  gfs2: Fix mmap + page fault deadlocks for direct I/O (2021-10-25 08:42:14 +0200)

----------------------------------------------------------------
gfs2: Fix mmap + page fault deadlocks

Functions gfs2_file_read_iter and gfs2_file_write_iter are both
accessing the user buffer to write to or read from while holding the
inode glock.  In the most basic scenario, that buffer will not be
resident and it will be mapped to the same file.  Accessing the buffer
will trigger a page fault, and gfs2 will deadlock trying to take the
same inode glock again while trying to handle that fault.

Fix that and similar, more complex scenarios by disabling page faults
while accessing user buffers.  To make this work, introduce a small
amount of new infrastructure and fix some bugs that didn't trigger so
far, with page faults enabled.

----------------------------------------------------------------
Andreas Gruenbacher (16):
      iov_iter: Fix iov_iter_get_pages{,_alloc} page fault return value
      powerpc/kvm: Fix kvm_use_magic_page
      gup: Turn fault_in_pages_{readable,writeable} into fault_in_{readable,writeable}
      iov_iter: Turn iov_iter_fault_in_readable into fault_in_iov_iter_readable
      iov_iter: Introduce fault_in_iov_iter_writeable
      gfs2: Add wrapper for iomap_file_buffered_write
      gfs2: Clean up function may_grant
      gfs2: Move the inode glock locking to gfs2_file_buffered_write
      gfs2: Eliminate ip->i_gh
      gfs2: Fix mmap + page fault deadlocks for buffered I/O
      iomap: Fix iomap_dio_rw return value for user copies
      iomap: Support partial direct I/O on user copy failures
      iomap: Add done_before argument to iomap_dio_rw
      gup: Introduce FOLL_NOFAULT flag to disable page faults
      iov_iter: Introduce nofault flag to disable page faults
      gfs2: Fix mmap + page fault deadlocks for direct I/O

Bob Peterson (1):
      gfs2: Introduce flag for glock holder auto-demotion

 arch/powerpc/kernel/kvm.c           |   3 +-
 arch/powerpc/kernel/signal_32.c     |   4 +-
 arch/powerpc/kernel/signal_64.c     |   2 +-
 arch/x86/kernel/fpu/signal.c        |   7 +-
 drivers/gpu/drm/armada/armada_gem.c |   7 +-
 fs/btrfs/file.c                     |   7 +-
 fs/btrfs/ioctl.c                    |   5 +-
 fs/erofs/data.c                     |   2 +-
 fs/ext4/file.c                      |   5 +-
 fs/f2fs/file.c                      |   2 +-
 fs/fuse/file.c                      |   2 +-
 fs/gfs2/bmap.c                      |  60 +------
 fs/gfs2/file.c                      | 252 ++++++++++++++++++++++++---
 fs/gfs2/glock.c                     | 330 +++++++++++++++++++++++++++---------
 fs/gfs2/glock.h                     |  20 +++
 fs/gfs2/incore.h                    |   4 +-
 fs/iomap/buffered-io.c              |   2 +-
 fs/iomap/direct-io.c                |  29 +++-
 fs/ntfs/file.c                      |   2 +-
 fs/ntfs3/file.c                     |   2 +-
 fs/xfs/xfs_file.c                   |   6 +-
 fs/zonefs/super.c                   |   4 +-
 include/linux/iomap.h               |  11 +-
 include/linux/mm.h                  |   3 +-
 include/linux/pagemap.h             |  58 +------
 include/linux/uio.h                 |   4 +-
 lib/iov_iter.c                      | 103 ++++++++---
 mm/filemap.c                        |   4 +-
 mm/gup.c                            | 139 ++++++++++++++-
 29 files changed, 793 insertions(+), 286 deletions(-)


_______________________________________________
Ocfs2-devel mailing list
Ocfs2-devel@oss.oracle.com
https://oss.oracle.com/mailman/listinfo/ocfs2-devel
