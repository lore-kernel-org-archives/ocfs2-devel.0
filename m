Received: from mx0b-0064b401.pphosted.com (mx0b-0064b401.pphosted.com [205.220.178.238])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D3E1A1D2F6E
	for <ocfs2-devel@lists.linux.dev>; Thu, 17 Oct 2024 08:55:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.178.238
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729155352; cv=none; b=T5QT8ClLTvlulPpuuq21uFDw1jKuPsZRDyUpMxv9iV/xVbZ0gz76CTqrZN7V8cbm/1bEJ5xbIWIPDFKZadya3XBv7TxqElrhfyvwm1Rgq9FtUMOx+uqnczhCu9CHzMPBQpyNqIti8D2NfKFW4Mc7FtUsZ+nZea2WVygQSyOMaKE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729155352; c=relaxed/simple;
	bh=+FezMZLxjziIMPCcMOkvt/OlmuF57a+YxfW570Foqec=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=FCeeq9B1FbIgr8w09GWMBhdaIDS07iOUH5x9VZidC4EGbETAQ1nxyjIRTlTBzCwFSFtcyPWxpat4gypbH8lBkW+F20s4sIX/Gvd6N4otZudsj4k/kGpEH9Qp3noc8medtT/JtBGZNsnZUvRrF+oNAZVsnMDkADWnjqRtAffQ4KY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=windriver.com; spf=pass smtp.mailfrom=windriver.com; arc=none smtp.client-ip=205.220.178.238
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=windriver.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=windriver.com
Received: from pps.filterd (m0250811.ppops.net [127.0.0.1])
	by mx0a-0064b401.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 49H5h3bC031007;
	Thu, 17 Oct 2024 08:55:23 GMT
Received: from ala-exchng01.corp.ad.wrs.com (ala-exchng01.wrs.com [147.11.82.252])
	by mx0a-0064b401.pphosted.com (PPS) with ESMTPS id 42a3eshpwd-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
	Thu, 17 Oct 2024 08:55:23 +0000 (GMT)
Received: from ala-exchng01.corp.ad.wrs.com (147.11.82.252) by
 ala-exchng01.corp.ad.wrs.com (147.11.82.252) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39; Thu, 17 Oct 2024 01:55:21 -0700
Received: from pek-lpd-ccm6.wrs.com (147.11.136.210) by
 ala-exchng01.corp.ad.wrs.com (147.11.82.252) with Microsoft SMTP Server id
 15.1.2507.39 via Frontend Transport; Thu, 17 Oct 2024 01:55:19 -0700
From: Lizhi Xu <lizhi.xu@windriver.com>
To: <syzbot+ca440b457d21568f8021@syzkaller.appspotmail.com>
CC: <jlbec@evilplan.org>, <joseph.qi@linux.alibaba.com>,
        <linux-kernel@vger.kernel.org>, <mark@fasheh.com>,
        <ocfs2-devel@lists.linux.dev>, <syzkaller-bugs@googlegroups.com>
Subject: [PATCH] ocfs2: Fix possible deadlock in ocfs2_fiemap
Date: Thu, 17 Oct 2024 16:55:19 +0800
Message-ID: <20241017085519.524401-1-lizhi.xu@windriver.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <66f90737.050a0220.4a974.001b.GAE@google.com>
References: <66f90737.050a0220.4a974.001b.GAE@google.com>
Precedence: bulk
X-Mailing-List: ocfs2-devel@lists.linux.dev
List-Id: <ocfs2-devel.lists.linux.dev>
List-Subscribe: <mailto:ocfs2-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:ocfs2-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Proofpoint-GUID: 7yYmVkgDBK4suOj3UJ5o-KKQVM3C2uk-
X-Proofpoint-ORIG-GUID: 7yYmVkgDBK4suOj3UJ5o-KKQVM3C2uk-
X-Authority-Analysis: v=2.4 cv=cPWysUeN c=1 sm=1 tr=0 ts=6710d0fb cx=c_pps a=/ZJR302f846pc/tyiSlYyQ==:117 a=/ZJR302f846pc/tyiSlYyQ==:17 a=DAUX931o1VcA:10 a=hSkVLCK3AAAA:8 a=edf1wS77AAAA:8 a=t7CeM3EgAAAA:8 a=PiBT8KzVUjZKPuU8j2wA:9 a=cQPPKAXgyycSBL8etih5:22
 a=DcSpbTIhAlouE1Uv7lRv:22 a=FdTzh2GWekK77mhwV6Dw:22
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1051,Hydra:6.0.680,FMLib:17.12.62.30
 definitions=2024-10-17_08,2024-10-17_01,2024-09-30_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 lowpriorityscore=0 mlxscore=0
 suspectscore=0 phishscore=0 adultscore=0 priorityscore=1501 spamscore=0
 clxscore=1015 malwarescore=0 impostorscore=0 bulkscore=0 mlxlogscore=999
 classifier=spam authscore=0 adjust=0 reason=mlx scancount=1
 engine=8.21.0-2409260000 definitions=main-2410170059

Syzbot reported a possible circular locking dependency.
WARNING: possible circular locking dependency detected
6.12.0-rc2-syzkaller-00205-g1d227fcc7222 #0 Not tainted
------------------------------------------------------
syz-executor161/5226 is trying to acquire lock:
ffff88807e907398 (&mm->mmap_lock){++++}-{3:3}, at: __might_fault+0xaa/0x120 mm/memory.c:6700

but task is already holding lock:
ffff8880720d0660 (&oi->ip_alloc_sem){++++}-{3:3}, at: ocfs2_fiemap+0x377/0xf80 fs/ocfs2/extent_map.c:755

which lock already depends on the new lock.


the existing dependency chain (in reverse order) is:

-> #2 (&oi->ip_alloc_sem){++++}-{3:3}:
       lock_acquire+0x1ed/0x550 kernel/locking/lockdep.c:5825
       down_write+0x99/0x220 kernel/locking/rwsem.c:1577
       ocfs2_page_mkwrite+0x346/0xed0 fs/ocfs2/mmap.c:142
       do_page_mkwrite+0x198/0x480 mm/memory.c:3162
       do_shared_fault mm/memory.c:5358 [inline]
       do_fault mm/memory.c:5420 [inline]
       do_pte_missing mm/memory.c:3965 [inline]
       handle_pte_fault+0x11fa/0x6800 mm/memory.c:5751
       __handle_mm_fault mm/memory.c:5894 [inline]
       handle_mm_fault+0x1053/0x1ad0 mm/memory.c:6062
       do_user_addr_fault arch/x86/mm/fault.c:1389 [inline]
       handle_page_fault arch/x86/mm/fault.c:1481 [inline]
       exc_page_fault+0x2b9/0x8c0 arch/x86/mm/fault.c:1539
       asm_exc_page_fault+0x26/0x30 arch/x86/include/asm/idtentry.h:623

-> #1 (sb_pagefaults){.+.+}-{0:0}:
       lock_acquire+0x1ed/0x550 kernel/locking/lockdep.c:5825
       percpu_down_read include/linux/percpu-rwsem.h:51 [inline]
       __sb_start_write include/linux/fs.h:1716 [inline]
       sb_start_pagefault include/linux/fs.h:1881 [inline]
       ocfs2_page_mkwrite+0x222/0xed0 fs/ocfs2/mmap.c:122
       do_page_mkwrite+0x198/0x480 mm/memory.c:3162
       do_shared_fault mm/memory.c:5358 [inline]
       do_fault mm/memory.c:5420 [inline]
       do_pte_missing mm/memory.c:3965 [inline]
       handle_pte_fault+0x11fa/0x6800 mm/memory.c:5751
       __handle_mm_fault mm/memory.c:5894 [inline]
       handle_mm_fault+0x1053/0x1ad0 mm/memory.c:6062
       do_user_addr_fault arch/x86/mm/fault.c:1389 [inline]
       handle_page_fault arch/x86/mm/fault.c:1481 [inline]
       exc_page_fault+0x2b9/0x8c0 arch/x86/mm/fault.c:1539
       asm_exc_page_fault+0x26/0x30 arch/x86/include/asm/idtentry.h:623

-> #0 (&mm->mmap_lock){++++}-{3:3}:
       check_prev_add kernel/locking/lockdep.c:3161 [inline]
       check_prevs_add kernel/locking/lockdep.c:3280 [inline]
       validate_chain+0x18ef/0x5920 kernel/locking/lockdep.c:3904
       __lock_acquire+0x1384/0x2050 kernel/locking/lockdep.c:5202
       lock_acquire+0x1ed/0x550 kernel/locking/lockdep.c:5825
       __might_fault+0xc6/0x120 mm/memory.c:6700
       _inline_copy_to_user include/linux/uaccess.h:183 [inline]
       _copy_to_user+0x2a/0xb0 lib/usercopy.c:26
       copy_to_user include/linux/uaccess.h:216 [inline]
       fiemap_fill_next_extent+0x235/0x410 fs/ioctl.c:145
       ocfs2_fiemap+0x9f1/0xf80 fs/ocfs2/extent_map.c:796
       ioctl_fiemap fs/ioctl.c:220 [inline]
       do_vfs_ioctl+0x1bf8/0x2e40 fs/ioctl.c:841
       __do_sys_ioctl fs/ioctl.c:905 [inline]
       __se_sys_ioctl+0x81/0x170 fs/ioctl.c:893
       do_syscall_x64 arch/x86/entry/common.c:52 [inline]
       do_syscall_64+0xf3/0x230 arch/x86/entry/common.c:83
       entry_SYSCALL_64_after_hwframe+0x77/0x7f

other info that might help us debug this:

Chain exists of:
  &mm->mmap_lock --> sb_pagefaults --> &oi->ip_alloc_sem

 Possible unsafe locking scenario:

       CPU0                    CPU1
       ----                    ----
  rlock(&oi->ip_alloc_sem);
                               lock(sb_pagefaults);
                               lock(&oi->ip_alloc_sem);
  rlock(&mm->mmap_lock);

 *** DEADLOCK ***

Fix it by reordering locks sb_pagefaults and ip_alloc_sem, because
fiemap_fill_next_extent() does not need to be in the lock ip_alloc_sem,
cancel and retrieve ip_alloc_sem before and after the execution of it.

Reported-and-tested-by: syzbot+ca440b457d21568f8021@syzkaller.appspotmail.com
Closes: https://syzkaller.appspot.com/bug?extid=ca440b457d21568f8021
Signed-off-by: Lizhi Xu <lizhi.xu@windriver.com>
---
 fs/ocfs2/extent_map.c |  2 ++
 fs/ocfs2/mmap.c       | 14 +++++++-------
 2 files changed, 9 insertions(+), 7 deletions(-)

diff --git a/fs/ocfs2/extent_map.c b/fs/ocfs2/extent_map.c
index f7672472fa82..6d5ffa803b31 100644
--- a/fs/ocfs2/extent_map.c
+++ b/fs/ocfs2/extent_map.c
@@ -793,8 +793,10 @@ int ocfs2_fiemap(struct inode *inode, struct fiemap_extent_info *fieinfo,
 		phys_bytes = le64_to_cpu(rec.e_blkno) << osb->sb->s_blocksize_bits;
 		virt_bytes = (u64)le32_to_cpu(rec.e_cpos) << osb->s_clustersize_bits;
 
+		up_read(&OCFS2_I(inode)->ip_alloc_sem);
 		ret = fiemap_fill_next_extent(fieinfo, virt_bytes, phys_bytes,
 					      len_bytes, fe_flags);
+		down_read(&OCFS2_I(inode)->ip_alloc_sem);
 		if (ret)
 			break;
 
diff --git a/fs/ocfs2/mmap.c b/fs/ocfs2/mmap.c
index 6ef4cb045ccd..f7863f7fb4a1 100644
--- a/fs/ocfs2/mmap.c
+++ b/fs/ocfs2/mmap.c
@@ -119,9 +119,6 @@ static vm_fault_t ocfs2_page_mkwrite(struct vm_fault *vmf)
 	int err;
 	vm_fault_t ret;
 
-	sb_start_pagefault(inode->i_sb);
-	ocfs2_block_signals(&oldset);
-
 	/*
 	 * The cluster locks taken will block a truncate from another
 	 * node. Taking the data lock will also ensure that we don't
@@ -131,7 +128,7 @@ static vm_fault_t ocfs2_page_mkwrite(struct vm_fault *vmf)
 	if (err < 0) {
 		mlog_errno(err);
 		ret = vmf_error(err);
-		goto out;
+		return ret;
 	}
 
 	/*
@@ -141,16 +138,19 @@ static vm_fault_t ocfs2_page_mkwrite(struct vm_fault *vmf)
 	 */
 	down_write(&OCFS2_I(inode)->ip_alloc_sem);
 
+	sb_start_pagefault(inode->i_sb);
+	ocfs2_block_signals(&oldset);
+
 	ret = __ocfs2_page_mkwrite(vmf->vma->vm_file, di_bh, page);
 
+	ocfs2_unblock_signals(&oldset);
+	sb_end_pagefault(inode->i_sb);
+
 	up_write(&OCFS2_I(inode)->ip_alloc_sem);
 
 	brelse(di_bh);
 	ocfs2_inode_unlock(inode, 1);
 
-out:
-	ocfs2_unblock_signals(&oldset);
-	sb_end_pagefault(inode->i_sb);
 	return ret;
 }
 
-- 
2.43.0

