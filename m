Received: from out203-205-221-192.mail.qq.com (out203-205-221-192.mail.qq.com [203.205.221.192])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3CAA720B212
	for <ocfs2-devel@lists.linux.dev>; Fri, 19 Dec 2025 04:52:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=203.205.221.192
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1766119975; cv=none; b=OzXU7GyQAEy1Xk5hn/0QT8Dm3kmoiadRIZtR4UtbPxiQesrpKSyoiZ7qWCL1DW5uiD7yTLBaJnjey+UPNAUOC4FfZrX8+mW+LJeEy5t2BQHUETDy8J/xpyPeRfnIvAeUhwTjTFIsf7LtbOEwtP8iOz0v6q4P/TW0Kn5dzepcSHA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1766119975; c=relaxed/simple;
	bh=/h9c93f0wW9RmHGW/Imeq3DlmIE5kjlywDNR+7n53EU=;
	h=Message-ID:From:To:Cc:Subject:Date:In-Reply-To:References:
	 MIME-Version; b=ng3/qVVyO1nFWvF3RtefJzkTT42km6RHe7aHzoFtpQ8NQ06o0//O9S9eAJiWOykszwQ+gssWKHeRK+I8fitc+54ZhROGuF+S+lQcyaS0md1dRBGWanME/YXuhZ7PGQI8ao+7i01BDo6Q/MAo5hXA45PQhRgiewQqo4O0a7aETbI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=qq.com; spf=pass smtp.mailfrom=qq.com; dkim=pass (1024-bit key) header.d=qq.com header.i=@qq.com header.b=WQbfE6it; arc=none smtp.client-ip=203.205.221.192
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=qq.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=qq.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=qq.com header.i=@qq.com header.b="WQbfE6it"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qq.com; s=s201512;
	t=1766119968; bh=852PNLRgY/lHTCkAmMARkzUj18IMs5gOydpBmSSxT+Q=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=WQbfE6itf0mifqqQ9Skq442ANLlZGnJozwbk/ufJdYZvq3qVixZveznTkyY+1lOFN
	 WZ0fOgqFjdKBOwuA935KScWRHZkImNAcYyNPDW6+gk6rcTjVzQM7l1igkW5Tmn8mAA
	 MjRP/kLihNMfjMNJkcPf0ooQJRii+ZcCGKO7lQHA=
Received: from lxu-ped-host.. ([111.201.7.117])
	by newxmesmtplogicsvrszb51-1.qq.com (NewEsmtp) with SMTP
	id D2CB8C73; Fri, 19 Dec 2025 12:52:44 +0800
X-QQ-mid: xmsmtpt1766119964txhi47ju2
Message-ID: <tencent_1BFE8C84E7E146CE52F0C660C9B4AEC9EE06@qq.com>
X-QQ-XMAILINFO: N/WmRbclY25G+NistPK+O9i7jsf0GrL43sxxpFGCjlztxUWH8MkDT+xPfKdJp7
	 utdP1j4zRu6FmMmVznVdxM6PqLeII2xA0KdCIV++mIMNulkcKhnxoDQpjzBGe6fJPCN5VDQjorNl
	 uzxEtv1n09c7oR4sGx5vZ3dj6ODKzQu0JlDoGo1GsMrgf/zpT7lPcrahbLGxVxMHp17zq94Q1jiO
	 2HJ3OerAO2drsZ9J0jBjMn18DZ5ECYZ2j1RMpIRuHZomfC2zccwGPWdCfwDyBoGREeug7/Whn7E4
	 2gGr+fOPlP9T7acWfLlM6R2u34EmqC0dJj2EDnO6xoDntJksuzrwv/3LXwyr2GUKoFmqHyJs6rOC
	 QLwC1lHWI3T/z7ZTbqncOVbE+0nGq6TtHOCvqNFxa1tfsdjDX3xJLFlxvvaq1PTkh0f3ndibJvSt
	 Y2M/IWd9qsWx1a/R1OpcpemJgMBHLHj87EjDW4Qly7ZbvdK5A+iIkB78ytzoYjayFvB3NwweFfkd
	 MrCBDXEOSHidYZTMz3QryyEbzisYpLIDJFdn8nf6XZcDee46S7byCsYy+km7NDgt9/mMxK4uchbS
	 ZGe7J+KLGz/jcCoV9SVxZ+HlN63KlqQAQU2CfMDgWLluP1gBdwXJ+eMJ1i+v25gVZUg36DaJsbtF
	 1TUo6EhGpyecMKMqBJlNOEiOQIUpaH/g7eVWQQnjSCFwvzVkB90+1mQzA4GyxLFvwsfuE37tCqDS
	 P7JLWPOj8jSpQrlg0jpymoumiBcGTN9DqMoIsGgil7eo5xNvPqbwrZ2K2D+s9bYxpBTQXVjbXsMD
	 +eOGCSf9Vvq7xONAJirsDZ6XvLGotliM+3p8IBpxthEOMY9ON4i2APp4BHfB2ZTf0NwwCsr+Tyk/
	 AH5W7w6vq8Bp5mjElmDwYpwSRYZ3lpQNc4tqkyJP9fzWv0Xha4Qg+YVNzvjzNf28HcQz0iwWTpt0
	 zPY0rIfd/feApVZ/J3WVt0pNLqPUJy/psUq4Y5XdMmb8HpR/w14nAppiLg0b8yf2lT6+VwIYxtq9
	 uumxivc+/5k7EJSXs/
X-QQ-XMRINFO: MSVp+SPm3vtS1Vd6Y4Mggwc=
From: Edward Adam Davis <eadavis@qq.com>
To: heming.zhao@suse.com
Cc: eadavis@qq.org,
	jlbec@evilplan.org,
	joseph.qi@linux.alibaba.com,
	linux-kernel@vger.kernel.org,
	mark@fasheh.com,
	ocfs2-devel@lists.linux.dev,
	syzkaller-bugs@googlegroups.com
Subject: Re: [PATCH] ocfs2: fix oob in __ocfs2_find_path
Date: Fri, 19 Dec 2025 12:52:44 +0800
X-OQ-MSGID: <20251219045243.110641-2-eadavis@qq.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <5wws3jiutruexkk4wl34wootqtfggj2h6ezrbemvtn7ykgsumq@3komfzq36st4>
References: <5wws3jiutruexkk4wl34wootqtfggj2h6ezrbemvtn7ykgsumq@3komfzq36st4>
Precedence: bulk
X-Mailing-List: ocfs2-devel@lists.linux.dev
List-Id: <ocfs2-devel.lists.linux.dev>
List-Subscribe: <mailto:ocfs2-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:ocfs2-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

On Fri, 19 Dec 2025 12:12:47 +0800, Heming Zhao wrote:
> On Mon, Dec 15, 2025 at 10:09:32PM +0800, Edward Adam Davis wrote:
> > Patch d358e5254674 modifies the definition of the array l_recs, specifying
> > the number of its members as l_count. In the path shown in [1], it will
> > first read the inode block where the system file directory is located
> > from the disk, and then read the l_count of each extension block from
> > the disk according to the extension list of the directory. Then the
> > value is 0 before l_count is read. If the array l_recs member is directly
> > accessed, the oob in [1] will be triggered.
> > 
> > Use the rec pointer directly to access the extension block number to
> > prevent the oob reported in [1].
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
> > Fixes: d358e5254674 ("ocfs2: annotate flexible array members with __counted_by_le()")
> > Reported-by: syzbot+151afab124dfbc5f15e6@syzkaller.appspotmail.com
> > Closes: https://syzkaller.appspot.com/bug?extid=151afab124dfbc5f15e6
> > Signed-off-by: Edward Adam Davis <eadavis@qq.com>
> 
> First, the commit id d358e5254674 is incorrect, the correct one is
> 2f26f58df041bbcf692730ff4d8ab0f250d9670d.
Oh, yes, I wrote the ID incorrectly.
> 
> All __ocfs2_find_path() operations occur in memory, meaning there are no I/O
> operations involeved.
> From the error msg "index 0 is out of range ...", we can deduce that both 'i'
> and 'el->l_count' are zero. This is an impossible scenario in normal volume.
> Therefore, the syzbot may have crafted a struct ocfs2_extent_rec where
> el->l_count is 0.
> 
> I suggest you use this patch as a fix:
> https://syzkaller.appspot.com/text?tag=Patch&x=14eb331a580000
This patch is consistent with my analysis, but it simply uses the
condition l_count == 0 to exit early. I will modify this patch slightly
to include the version after applying `le16_to_cpu`.

Thanks,
Edward

