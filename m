Received: from mail-wr1-f47.google.com (mail-wr1-f47.google.com [209.85.221.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 02103D2FB
	for <ocfs2-devel@lists.linux.dev>; Fri, 19 Dec 2025 07:25:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.47
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1766129139; cv=none; b=Q5oNu5FwBwV93pxsjrNRIGkluzF6blGWWN03FSmbsvvJfSWAy1gUc3Z7jDvyks+fYV/RHI4E4s7pJ3rY1TOLMTIj2Bm4QV7y7Cx/HjEFwlqzafLEo5+G8WduBYqlSdsB2B9oid7smubIgLy1XGjFHe/9xWO4GsLpOENGlHxkmao=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1766129139; c=relaxed/simple;
	bh=mkkuQ7p67ZoJeIb92mYfowvDUs93y16sCoIBrYegKpY=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=IOg6djIh4UQL7PhT4+tkcfX4Lsh/jVzdojU93tUMfzWFNfPtQMWBnu3Do5bNaLTOZ7JMelx7vQuMe0bEIcXIe0LM3AV0rg6/JkeZZ2NmcA7281/qCrOhAoMSdkqPHuaCqMJ4PI2xfpZDsLyVAb9dwZAFR/UOn5aB0sDx36rtHUA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=elrEY/hL; arc=none smtp.client-ip=209.85.221.47
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="elrEY/hL"
Received: by mail-wr1-f47.google.com with SMTP id ffacd0b85a97d-4308d87782dso193795f8f.2
        for <ocfs2-devel@lists.linux.dev>; Thu, 18 Dec 2025 23:25:36 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1766129135; x=1766733935; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=xGJ06ao7BHavSRgWtOMdv0SMDwHwMaJLHfjXM/qS9zQ=;
        b=elrEY/hL2V8MeE31lPJtKc8yE2uXJ+BvwpmA3To93u3hL8EZ2KjUFGWHb6hQJgmjwM
         x/6YyG9mQjpjSqROeeJhGfAxZEdsXpCG4c7U1u+WqZvPTP+xYwki2dy2E6n05jtZs88C
         M7wET0NXyrJMU754l5NwEDLyPKEnhPvnHVBvT05v1qFq3eErF1s+t8vTu95HJZbmoRqZ
         ZygTO2OBZdPtDnHWEstCTcsOFJIijA0A3bkV+urFAVir8hoijqNJSEjiJuhTN7MYUqXE
         odfESlos1sc3rAAEnBNd+twzrpD6dt9ny3m/vFVEDRVCa/di2sOlwZytskIyDBhTBvOJ
         Q6iw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1766129135; x=1766733935;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=xGJ06ao7BHavSRgWtOMdv0SMDwHwMaJLHfjXM/qS9zQ=;
        b=QOYsmUu3wUXGoi2rankGjY9lS4b+InSbCV+YEnbMTRg69UEmAREzZ7p2zuMiCVpYAD
         ogq05QPLH3HEUcwKPqaShaNX6L66j42WMBkee8kZhLuCapIMmn4HDdWPFHLX26CDEv5C
         nB9ciWhCDN2BHCMYrpbxzG2AKmSdOQ4l2rBivL4Vh834rbnsgrIrp0JObVbc77uP1veO
         2zFo995OnxUHG7dgtlD1fEHQe1ERF7jmnPiJVOlA965TSZ6gZaKvEkXGvBKJ0ndod6h4
         ypxoj/5akJfPGA8luS+vZ/BZwzAW9gKeoy0RMHfFt0oAItfbAv9E00YkOqJttFHWvYBA
         Bzeg==
X-Forwarded-Encrypted: i=1; AJvYcCWC6UhVFuGqsAqDzuc2tRweHpP2zXWbPJaJDNW9lz47zej/qpXpSKOJBpMLq2zqNQ00Lae61kp+FNjVxQ==@lists.linux.dev
X-Gm-Message-State: AOJu0Yz8jo85slA/XqDovs8hSB05GpqFH2mgEPQet6n3HgmWdDUrqk97
	6ECx3IEz+4RTdPdMK+5yF7F1Q+3i+wprG1iXlBDvFFc8CqCTTt6WGZkyYv1C34JxZdY=
X-Gm-Gg: AY/fxX5nRBs5WyobvCkz2xMbo7o7/WnKmEGoNFya6JyRvTfd9HB4LgRSStHue2KhiNu
	cHl4WLeKZrlq1Tr2tXKZGz0+LglYzPJ2yRUgqXqSnpvWsWdUYxEIvYZCQL/tv+qRfK7EJcxzQdg
	TRASq3cqtEMHM4bQoSP7XstuX51ePEB/MSa1ASseBei+xvp7qrBiVJ+ZPmRE3L/KsPM7GGYbG8v
	NJZvVZH1bmaB78MS7BacquKnPUUxb7x2hn/RNQaROZJ7oX1gJexUqnR6fQDHNquxNNM4BOc3/9q
	MKxwm10Lfvi78uvm57HfGnw6z5WWeB1ZQls8xr5ggpepgpA7VXoJDad0ILSuPLQr+Rq53tPZfiI
	EbTw3E0uGXjgO6TLbyjC5pRChOBWjnLqkKS44BLq+wtK5fdJnL0q373/F+NReQNrop2cO067H1j
	vH7Wc8YqVuh0WwwUuGYONe
X-Google-Smtp-Source: AGHT+IHuiw56paT8xacQyCKgS9WOZzvH6YQcqQsTmSOoqY55tlOm9hqDqSigdXNZi1r/Is7X7MmRgw==
X-Received: by 2002:a05:600c:1ca0:b0:477:563a:fc9c with SMTP id 5b1f17b1804b1-47d1952a73bmr10561765e9.1.1766129135303;
        Thu, 18 Dec 2025 23:25:35 -0800 (PST)
Received: from localhost ([202.127.77.110])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-34e70ddf58dsm4357544a91.17.2025.12.18.23.25.33
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 18 Dec 2025 23:25:34 -0800 (PST)
Date: Fri, 19 Dec 2025 15:25:31 +0800
From: Heming Zhao <heming.zhao@suse.com>
To: Edward Adam Davis <eadavis@qq.com>
Cc: eadavis@qq.org, jlbec@evilplan.org, joseph.qi@linux.alibaba.com, 
	linux-kernel@vger.kernel.org, mark@fasheh.com, ocfs2-devel@lists.linux.dev, 
	syzkaller-bugs@googlegroups.com
Subject: Re: [PATCH v2] ocfs2: fix oob in __ocfs2_find_path
Message-ID: <5hyc4g4g6uxix5jncqi7ukhmdzq6xoxvou5dkvpj2o5y6v7zoe@qgvucbpcvbqn>
References: <rb73ttkcynklsuqf4nf6qg265v2sjun7p6g65cmkai3pzekpai@3ntwvmr34tsr>
 <tencent_9DE23D9537AC96BA36C24B3C740776336709@qq.com>
Precedence: bulk
X-Mailing-List: ocfs2-devel@lists.linux.dev
List-Id: <ocfs2-devel.lists.linux.dev>
List-Subscribe: <mailto:ocfs2-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:ocfs2-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <tencent_9DE23D9537AC96BA36C24B3C740776336709@qq.com>

On Fri, Dec 19, 2025 at 03:00:02PM +0800, Edward Adam Davis wrote:
> On Fri, 19 Dec 2025 14:31:58 +0800, Heming Zhao wrote:
> > > Patch 2f26f58df041 modifies the definition of the array l_recs, specifying
> > > the number of its members as l_count. In the path shown in [1], it will
> > > first read the inode block where the system file directory is located
> > > from the disk, and then read the l_count of each extension block from
> > > the disk according to the extension list of the directory. Then the
> > > value is 0 before l_count is read. If the array l_recs member is directly
> > > accessed, the oob in [1] will be triggered.
> > 
> > Please revise the commit log.
> > I noticed a mistake in my previous email. While __ocfs2_find_path() does issue
> > IOs via ocfs2_read_extent_block(), the claim that "the value is 0 before
> > l_count is read" cannot be true in this context. All data for struct
> > ocfs2_extent_list (el) is fully read from the disk before the OOB issue is
> > triggered.
> Upon closer inspection, yes, the root extent list has been read from
> the disk, and e_blkno is being retrieved to read subsequent extension
> blocks. However, an error occurred while reading e_blkno because the
> l_count value of the root extent list is 0.
> Therefore, the Fix tag is incorrect; it shouldn't be 2f26f58df041,
> but rather dcd0538ff4e8 ("ocfs2: sparse b-tree support").
> > 
> > > The loop terminates when l_count is 0, similar to when next_free is 0.
> > >
> > > [1]
> > > UBSAN: array-index-out-of-bounds in fs/ocfs2/alloc.c:1838:11
> > > index 0 is out of range for type 'struct ocfs2_extent_rec[] __counted_by(l_count)' (aka 'struct ocfs2_extent_rec[]')
> > > Call Trace:
> > >  __ocfs2_find_path+0x606/0xa40 fs/ocfs2/alloc.c:1838
> > >  ocfs2_find_leaf+0xab/0x1c0 fs/ocfs2/alloc.c:1946
> > >  ocfs2_get_clusters_nocache+0x172/0xc60 fs/ocfs2/extent_map.c:418
> > >  ocfs2_get_clusters+0x505/0xa70 fs/ocfs2/extent_map.c:631
> > >  ocfs2_extent_map_get_blocks+0x202/0x6a0 fs/ocfs2/extent_map.c:678
> > >  ocfs2_read_virt_blocks+0x286/0x930 fs/ocfs2/extent_map.c:1001
> > >  ocfs2_read_dir_block fs/ocfs2/dir.c:521 [inline]
> > >  ocfs2_find_entry_el fs/ocfs2/dir.c:728 [inline]
> > >  ocfs2_find_entry+0x3e4/0x2090 fs/ocfs2/dir.c:1120
> > >  ocfs2_find_files_on_disk+0xdf/0x310 fs/ocfs2/dir.c:2023
> > >  ocfs2_lookup_ino_from_name+0x52/0x100 fs/ocfs2/dir.c:2045
> > >  _ocfs2_get_system_file_inode fs/ocfs2/sysfile.c:136 [inline]
> > >  ocfs2_get_system_file_inode+0x326/0x770 fs/ocfs2/sysfile.c:112
> > >  ocfs2_init_global_system_inodes+0x319/0x660 fs/ocfs2/super.c:461
> > >  ocfs2_initialize_super fs/ocfs2/super.c:2196 [inline]
> > >  ocfs2_fill_super+0x4432/0x65b0 fs/ocfs2/super.c:993
> > >  get_tree_bdev_flags+0x40e/0x4d0 fs/super.c:1691
> > >  vfs_get_tree+0x92/0x2a0 fs/super.c:1751
> > >  fc_mount fs/namespace.c:1199 [inline]
> > >
> > > Fixes: 2f26f58df041 ("ocfs2: annotate flexible array members with __counted_by_le()")

This commit doesn't introduce any bugs, rather, it introduces stricter sanity
checks for struct usage. Please remove the 'Fixes' tag.

The code logic of this function is correct. This issue is triggered by a
syzbot-crafted image and is very unlikely to occur in the real world. I would
prefer not to add a 'Fixes:' tag, as doing so would increase the backporting
workload for Linux distribution maintainers.

> > > Reported-by: syzbot+151afab124dfbc5f15e6@syzkaller.appspotmail.com
> > > Closes: https://syzkaller.appspot.com/bug?extid=151afab124dfbc5f15e6
> > > Signed-off-by: Edward Adam Davis <eadavis@qq.com>
> > > ---
> > > v1 -> v2: check l_count and update comments
> > >
> > >  fs/ocfs2/alloc.c | 10 ++++++----
> > >  1 file changed, 6 insertions(+), 4 deletions(-)
> > >
> > > diff --git a/fs/ocfs2/alloc.c b/fs/ocfs2/alloc.c
> > > index 58bf58b68955..44bbc51276de 100644
> > > --- a/fs/ocfs2/alloc.c
> > > +++ b/fs/ocfs2/alloc.c
> > > @@ -1812,14 +1812,16 @@ static int __ocfs2_find_path(struct ocfs2_caching_info *ci,
> > >  			ret = -EROFS;
> > >  			goto out;
> > >  		}
> > > -		if (le16_to_cpu(el->l_next_free_rec) == 0) {
> > > +		if (le16_to_cpu(el->l_next_free_rec) == 0 ||
> > > +		    le16_to_cpu(el->l_count) == 0) {
> > 
> > please restore the code above to my original patch. Since the value is expected
> > to be zero, converting from le16 to cpu endian is a redundant operation and
> > waste of cpu cycles.
> My view remains unchanged, because l_count/l_next_free_rec originates
> from the disk, not from memory.
> 

What are the bits representation of zero? Is byte-swapping necessary for
different-endian architectures?" We just need to perform the conversion in the
error msg log. 

- Heming
