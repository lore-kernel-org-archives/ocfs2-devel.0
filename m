Received: from out203-205-221-155.mail.qq.com (out203-205-221-155.mail.qq.com [203.205.221.155])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EA9912DEA9E
	for <ocfs2-devel@lists.linux.dev>; Fri, 19 Dec 2025 07:00:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=203.205.221.155
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1766127625; cv=none; b=AJCyQwisPtUyIqXnfCYIo6+Of4VC3DeJ0Yu47ttYuWTYovQrgWIyab6aWYyNtFiln34W5AryG0VYiQ4XNN3CjbzlqKBO3ca1HmUDBL6fj7sseQzTUclg3GG0aYp+sQhOXGYoI/U6vvHJZo8oeu/z/mvx3kxG/EXXyCnjD9vfvG0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1766127625; c=relaxed/simple;
	bh=NIwuu5acOZxpnzjbjg8K1xK54/f7LSO20UpgmDVM9FI=;
	h=Message-ID:From:To:Cc:Subject:Date:In-Reply-To:References:
	 MIME-Version; b=se4f0JYCVFzgedHZRPndQzlEAEZkHGDOpYbtQenA+mCOp21NteZ8t0gjgZvSJib7jC49Q6YxsutIpxslAUM9Yhc1/2vsc/nXXlyNelS/IZ1rRIylz81vzcEo7yvEwxePsDUF6X8V4LUnuhH+bUxkZA+lzuGy4BDkfVydvYgPAUY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=qq.com; spf=pass smtp.mailfrom=qq.com; dkim=pass (1024-bit key) header.d=qq.com header.i=@qq.com header.b=BVUHfqM6; arc=none smtp.client-ip=203.205.221.155
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=qq.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=qq.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=qq.com header.i=@qq.com header.b="BVUHfqM6"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qq.com; s=s201512;
	t=1766127605; bh=J9K4i56J4Eg3Z171VDxhyNiW4WLmSk6XPfhKxavzWmw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=BVUHfqM6CB0rpt8oQovloCfxhfV/Uk8KVVyClNZ9zHFEByyBKcy99w6pRdNFkQ1Ov
	 0zgaLmIZNuplk8G4NIuKSYgjjlRcvYeFI+cWmoEh2LmxDyg54CuwkqeeHXxU6zvlro
	 sT36GNU3LOGagubp1mt9brdCy4W/Z0byZFlYQimM=
Received: from lxu-ped-host.. ([111.201.7.117])
	by newxmesmtplogicsvrsza56-0.qq.com (NewEsmtp) with SMTP
	id 291E63; Fri, 19 Dec 2025 15:00:02 +0800
X-QQ-mid: xmsmtpt1766127602tg73cf8je
Message-ID: <tencent_9DE23D9537AC96BA36C24B3C740776336709@qq.com>
X-QQ-XMAILINFO: N/WmRbclY25G+NistPK+O9gD8o+X929fXRmB8Ei1QrFNh297EV7FY78ilVrw4h
	 6VNvCj4kI7qmg6c4HzXperbNvaPlSI5ZneORXVK7qF9bI38hSIyfs2t5TUrFzej7LlGnU8LCtGsw
	 TtXUMi66AzVh3jxKw9xc/fe8sIIuvrH+sfrAxILmXQwwhBVKkyikGppbrXyJ+xThEPS1avXxg4dC
	 d3z3KTMH8qxgtLD6YKxa5+E5WDZCjtLrHtceQug8zbIJb6tubhcom+Z214nQLo8npl5TE+cK8+EV
	 8LKZkr5Qa5iy9ZQWyj3X321r1+SlmI283/ZVKxtUogFYksJI+k39hym3CUswngLL/vGyRoC55Fy0
	 NUFFQ0TQVqusIZEEWspj2Noic9xoCsICloVvHaL+RmGJz5K9EIU9feilnaHEygJpfRxag6jqCe+L
	 sY2ED0pSoB9ZaT4kM8asH1xQTzj+hDlwJdbj+YwEJ2u54UpmsfL80H4DAYHsFqlnQ9L18m9MgQHn
	 5W0YYRGgwNBXpAgpKre8gQCabln6pzJG2qaBGgs0OvzLufLM1TyqkL/LhYgebimaerhp3yampcAw
	 Ok0M2+JeID+WFZ4WXklxFHDqtKGOTAdu76INtuKKHasZY11oFGON6G5ZX6hR4QHSJP9X5R0bliHk
	 4g0WxJ2gx8zWfE/VYrD4hvFPteKQnTZiJ/Aj518TejHzI9dE0rbSZw9+sIMXAzKjC8hdinCrHQK5
	 FgkAosJihBsqrYkyW5teT+O7PxwKlIHqSDvcVp0SyK3iLZTu3jATxC87xJnW+J6ZQvmcPa/k7VbZ
	 QXBzF4ss9/KSlxnZZXSXNN4nKx+EScauj8YfaU5lMm3CMVV94g3m4iyi0h+nAo7MxinTjzyIsaJB
	 LgUOuPQ7XEODe83OYh8o9sxkutQuw7+DdAiZFC/VHvBfzMoZmP/Kf/tmuKmSnIpsKYpi5IvatLoi
	 XRafg7QC6qChSDYuDcjhdE+gSB4+ylceoG337ofXcG3ZJYjedcb5g9p0aZA9r1nYYL0OShJ/1aqa
	 5v2qT12w==
X-QQ-XMRINFO: OD9hHCdaPRBwq3WW+NvGbIU=
From: Edward Adam Davis <eadavis@qq.com>
To: heming.zhao@suse.com
Cc: eadavis@qq.org,
	jlbec@evilplan.org,
	joseph.qi@linux.alibaba.com,
	linux-kernel@vger.kernel.org,
	mark@fasheh.com,
	ocfs2-devel@lists.linux.dev,
	syzkaller-bugs@googlegroups.com
Subject: Re: [PATCH v2] ocfs2: fix oob in __ocfs2_find_path
Date: Fri, 19 Dec 2025 15:00:02 +0800
X-OQ-MSGID: <20251219070001.116433-2-eadavis@qq.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <rb73ttkcynklsuqf4nf6qg265v2sjun7p6g65cmkai3pzekpai@3ntwvmr34tsr>
References: <rb73ttkcynklsuqf4nf6qg265v2sjun7p6g65cmkai3pzekpai@3ntwvmr34tsr>
Precedence: bulk
X-Mailing-List: ocfs2-devel@lists.linux.dev
List-Id: <ocfs2-devel.lists.linux.dev>
List-Subscribe: <mailto:ocfs2-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:ocfs2-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

On Fri, 19 Dec 2025 14:31:58 +0800, Heming Zhao wrote:
> > Patch 2f26f58df041 modifies the definition of the array l_recs, specifying
> > the number of its members as l_count. In the path shown in [1], it will
> > first read the inode block where the system file directory is located
> > from the disk, and then read the l_count of each extension block from
> > the disk according to the extension list of the directory. Then the
> > value is 0 before l_count is read. If the array l_recs member is directly
> > accessed, the oob in [1] will be triggered.
> 
> Please revise the commit log.
> I noticed a mistake in my previous email. While __ocfs2_find_path() does issue
> IOs via ocfs2_read_extent_block(), the claim that "the value is 0 before
> l_count is read" cannot be true in this context. All data for struct
> ocfs2_extent_list (el) is fully read from the disk before the OOB issue is
> triggered.
Upon closer inspection, yes, the root extent list has been read from
the disk, and e_blkno is being retrieved to read subsequent extension
blocks. However, an error occurred while reading e_blkno because the
l_count value of the root extent list is 0.
Therefore, the Fix tag is incorrect; it shouldn't be 2f26f58df041,
but rather dcd0538ff4e8 ("ocfs2: sparse b-tree support").
> 
> > The loop terminates when l_count is 0, similar to when next_free is 0.
> >
> > [1]
> > UBSAN: array-index-out-of-bounds in fs/ocfs2/alloc.c:1838:11
> > index 0 is out of range for type 'struct ocfs2_extent_rec[] __counted_by(l_count)' (aka 'struct ocfs2_extent_rec[]')
> > Call Trace:
> >  __ocfs2_find_path+0x606/0xa40 fs/ocfs2/alloc.c:1838
> >  ocfs2_find_leaf+0xab/0x1c0 fs/ocfs2/alloc.c:1946
> >  ocfs2_get_clusters_nocache+0x172/0xc60 fs/ocfs2/extent_map.c:418
> >  ocfs2_get_clusters+0x505/0xa70 fs/ocfs2/extent_map.c:631
> >  ocfs2_extent_map_get_blocks+0x202/0x6a0 fs/ocfs2/extent_map.c:678
> >  ocfs2_read_virt_blocks+0x286/0x930 fs/ocfs2/extent_map.c:1001
> >  ocfs2_read_dir_block fs/ocfs2/dir.c:521 [inline]
> >  ocfs2_find_entry_el fs/ocfs2/dir.c:728 [inline]
> >  ocfs2_find_entry+0x3e4/0x2090 fs/ocfs2/dir.c:1120
> >  ocfs2_find_files_on_disk+0xdf/0x310 fs/ocfs2/dir.c:2023
> >  ocfs2_lookup_ino_from_name+0x52/0x100 fs/ocfs2/dir.c:2045
> >  _ocfs2_get_system_file_inode fs/ocfs2/sysfile.c:136 [inline]
> >  ocfs2_get_system_file_inode+0x326/0x770 fs/ocfs2/sysfile.c:112
> >  ocfs2_init_global_system_inodes+0x319/0x660 fs/ocfs2/super.c:461
> >  ocfs2_initialize_super fs/ocfs2/super.c:2196 [inline]
> >  ocfs2_fill_super+0x4432/0x65b0 fs/ocfs2/super.c:993
> >  get_tree_bdev_flags+0x40e/0x4d0 fs/super.c:1691
> >  vfs_get_tree+0x92/0x2a0 fs/super.c:1751
> >  fc_mount fs/namespace.c:1199 [inline]
> >
> > Fixes: 2f26f58df041 ("ocfs2: annotate flexible array members with __counted_by_le()")
> > Reported-by: syzbot+151afab124dfbc5f15e6@syzkaller.appspotmail.com
> > Closes: https://syzkaller.appspot.com/bug?extid=151afab124dfbc5f15e6
> > Signed-off-by: Edward Adam Davis <eadavis@qq.com>
> > ---
> > v1 -> v2: check l_count and update comments
> >
> >  fs/ocfs2/alloc.c | 10 ++++++----
> >  1 file changed, 6 insertions(+), 4 deletions(-)
> >
> > diff --git a/fs/ocfs2/alloc.c b/fs/ocfs2/alloc.c
> > index 58bf58b68955..44bbc51276de 100644
> > --- a/fs/ocfs2/alloc.c
> > +++ b/fs/ocfs2/alloc.c
> > @@ -1812,14 +1812,16 @@ static int __ocfs2_find_path(struct ocfs2_caching_info *ci,
> >  			ret = -EROFS;
> >  			goto out;
> >  		}
> > -		if (le16_to_cpu(el->l_next_free_rec) == 0) {
> > +		if (le16_to_cpu(el->l_next_free_rec) == 0 ||
> > +		    le16_to_cpu(el->l_count) == 0) {
> 
> please restore the code above to my original patch. Since the value is expected
> to be zero, converting from le16 to cpu endian is a redundant operation and
> waste of cpu cycles.
My view remains unchanged, because l_count/l_next_free_rec originates
from the disk, not from memory.

