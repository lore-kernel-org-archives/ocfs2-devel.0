Received: from cstnet.cn (smtp21.cstnet.cn [159.226.251.21])
	(using TLSv1.2 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E23A12BDC2A
	for <ocfs2-devel@lists.linux.dev>; Sat,  9 May 2026 04:28:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=159.226.251.21
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778300930; cv=none; b=VfKqHPv+h+mGJ81Gvp9lGRWQP9zh+o7JwU5HzZsQA1lp4oZbxXiClr2ij8ziMCP1RPbGgnKW42+3wLVgLzIr1cKWe0XNrkocF0FTjtH0Pk22fZO9rhZxHHxhdqvQKgOE8zUs+GYMHbiZVsw61sbfoz0hPcybvJXVfrJkJcJuMCM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778300930; c=relaxed/simple;
	bh=eTiHSx1HzzKxKESWLa+8ROHCie3rGY/obeMnCXGkEa4=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version:Content-Type; b=dr4tfmCn2iBmeOgp0iRObjm3ogCe1bnx9GPt62reulQJOeOzs+yzEQ+ntdfrUrwEaH0j9uxbEA8ZFi63SIN9ceXlqzTxRN8k9oSi+Rkxl7JN9hDGxRGl8glaUdFZzscUepquhfM85ekppgNPSjkS20egpX10/g4oUmSvRM67Oa8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=mails.ucas.ac.cn; spf=pass smtp.mailfrom=mails.ucas.ac.cn; arc=none smtp.client-ip=159.226.251.21
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=mails.ucas.ac.cn
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=mails.ucas.ac.cn
Received: from fric.. (unknown [36.110.52.2])
	by APP-01 (Coremail) with SMTP id qwCowADnjGj5t_5pag2sDw--.10593S2;
	Sat, 09 May 2026 12:28:41 +0800 (CST)
From: Jiakai Xu <xujiakai24@mails.ucas.ac.cn>
To: joseph.qi@linux.alibaba.com
Cc: heming.zhao@suse.com,
	jlbec@evilplan.org,
	kurt.hackel@oracle.com,
	linux-kernel@vger.kernel.org,
	mark@fasheh.com,
	ocfs2-devel@lists.linux.dev,
	xujiakai24@mails.ucas.ac.cn
Subject: Re: [PATCH] ocfs2: fix use-after-free in ocfs2_inode_lock_full_nested during unmount
Date: Sat,  9 May 2026 04:28:41 +0000
Message-Id: <20260509042841.2038191-1-xujiakai24@mails.ucas.ac.cn>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <75570681-a25a-4cec-9874-b76fec6167e8@linux.alibaba.com>
References: <75570681-a25a-4cec-9874-b76fec6167e8@linux.alibaba.com>
Precedence: bulk
X-Mailing-List: ocfs2-devel@lists.linux.dev
List-Id: <ocfs2-devel.lists.linux.dev>
List-Subscribe: <mailto:ocfs2-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:ocfs2-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:qwCowADnjGj5t_5pag2sDw--.10593S2
X-Coremail-Antispam: 1UD129KBjvJXoWxCw4UtF1xtw4fuFW8Jr1DJrb_yoW5Gw15pF
	WjvryYkwnFvr109ws7XaykZryxuwsrCayDGr1rG34UZas8Jr1xt39Yyr429FyYg397Gw4S
	qr40qry7Gw4UCaDanT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDU0xBIdaVrnRJUUUvK14x267AKxVW8JVW5JwAFc2x0x2IEx4CE42xK8VAvwI8IcIk0
	rVWrJVCq3wAFIxvE14AKwVWUJVWUGwA2ocxC64kIII0Yj41l84x0c7CEw4AK67xGY2AK02
	1l84ACjcxK6xIIjxv20xvE14v26r4j6ryUM28EF7xvwVC0I7IYx2IY6xkF7I0E14v26r4j
	6F4UM28EF7xvwVC2z280aVAFwI0_Cr1j6rxdM28EF7xvwVC2z280aVCY1x0267AKxVWxJr
	0_GcWlnxkEFVAIw20F6cxK64vIFxWle2I262IYc4CY6c8Ij28IcVAaY2xG8wAqx4xG64xv
	F2IEw4CE5I8CrVC2j2WlYx0E2Ix0cI8IcVAFwI0_Jr0_Jr4lYx0Ex4A2jsIE14v26r4j6F
	4UMcvjeVCFs4IE7xkEbVWUJVW8JwACjcxG0xvY0x0EwIxGrwACjI8F5VA0II8E6IAqYI8I
	648v4I1lc7CjxVAaw2AFwI0_JF0_Jw1l42xK82IYc2Ij64vIr41l4I8I3I0E4IkC6x0Yz7
	v_Jr0_Gr1lx2IqxVAqx4xG67AKxVWUJVWUGwC20s026x8GjcxK67AKxVWUGVWUWwC2zVAF
	1VAY17CE14v26r1q6r43MIIYrxkI7VAKI48JMIIF0xvE2Ix0cI8IcVAFwI0_Jr0_JF4lIx
	AIcVC0I7IYx2IY6xkF7I0E14v26r1j6r4UMIIF0xvE42xK8VAvwI8IcIk0rVWUJVWUCwCI
	42IY6I8E87Iv67AKxVWUJVW8JwCI42IY6I8E87Iv6xkF7I0E14v26r1j6r4UYxBIdaVFxh
	VjvjDU0xZFpf9x0JU-zVUUUUUU=
X-CM-SenderInfo: 50xmxthndljko6pdxz3voxutnvoduhdfq/

> It seems this is not enough, or TOCTOU still exists. Say:
> 
> Thread A			Thread B
> osb = OCFS2_SB(inode->i_sb)
> 				ocfs2_dismount_volume()
> 				-> sb->s_fs_info = NULL
> 				-> kfree(osb)
> use freed osb
> 

Hi Joseph,

Thank you very much for the review! You are absolutely right about the
TOCTOU issue — simply adding a NULL check after OCFS2_SB() cannot
prevent the race where thread A reads a valid osb pointer before thread
B frees it.

> BTW, how did you find this issue?

I found this issue through fuzzing. The crash report shows a page fault 
at __pv_queued_spin_lock_slowpath via the call path:

  ocfs2_permission -> ocfs2_inode_lock_tracker ->
  ocfs2_inode_lock_full_nested -> ocfs2_is_hard_readonly ->
  spin_lock(&osb->osb_lock)

The fault address was in the kernel static data region, indicating that
the osb structure had been freed and its memory reused.

I have been thinking about a more robust fix and would like to get your
opinion on the following approach:

Currently, ocfs2_dismount_volume() is called from ocfs2_put_super(),
which runs inside generic_shutdown_super() while s_umount is still held.
The osb structure is freed at this point, but inodes with elevated
refcounts (e.g., held by inotify) survive evict_inodes() and may still
trigger filesystem operations (like ocfs2_permission) that access osb.

The idea is to move the osb cleanup out of ocfs2_dismount_volume() and
into an ocfs2-specific ->kill_sb() callback, so that the cleanup happens
after generic_shutdown_super() has completed and all concurrent VFS
operations have drained.

Specifically:

1. Remove ocfs2_delete_osb(), kfree(osb), and sb->s_fs_info = NULL from
   ocfs2_dismount_volume(). Keep all the subsystem shutdown (journal,
   dlm, recovery, quota, etc.) there.

2. Add a new ocfs2_kill_sb() that wraps kill_block_super():

   static void ocfs2_kill_sb(struct super_block *sb)
   {
       struct ocfs2_super *osb = OCFS2_SB(sb);

       kill_block_super(sb);
       // At this point generic_shutdown_super() has completed,
       // SB_DYING is set, and no new VFS operations can enter.

       if (osb) {
           ocfs2_delete_osb(osb);
           kfree(osb);
           sb->s_fs_info = NULL;
       }
   }

3. Update ocfs2_fs_type to use ocfs2_kill_sb instead of kill_block_super.

4. The NULL check in ocfs2_inode_lock_full_nested() can optionally be
   kept as a defense-in-depth measure, though it is no longer strictly
   necessary if the life-cycle ordering is correct.

This pattern is similar to ext4 — ext4_kill_sb() calls kill_block_super()
first and then handles cleanup after (e.g., journal_bdev_file).

Does this approach make sense?

Best regards,
Jiakai

