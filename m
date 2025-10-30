Received: from out30-124.freemail.mail.aliyun.com (out30-124.freemail.mail.aliyun.com [115.124.30.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1F31A285406
	for <ocfs2-devel@lists.linux.dev>; Thu, 30 Oct 2025 03:38:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=115.124.30.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761795516; cv=none; b=gAtYgBmN+hKT9Sf8Ujd/ThofmyX8XC8FjCbKWW5G7bPKIriv567d1pVLyPoP/+bUJpbVO3CaUPSgwzYTZUbxfbyoRapyD8u6sUG4oAbQa0KHQw38bKVRwoC4ew5IgIMOfJGUvYvZYDv8lmX5Bg9aPN/5mZCFXYH36LQNiQzQRGs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761795516; c=relaxed/simple;
	bh=ebmXUwLpLe6Ry/bDZydKQWEC5L2F+saXzSfZnWOUvaA=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=u/q0MJeMrb7zUkXhlEBS9wiHPy/L6dV0ce2OLsRpAB1+XWQdvq0pDP3vzyA4mQO3xSFSNb1vlqm0Kw7dzCMjziNJ0/0XYAwd1F3L/ytQtmYvNjtKdBeQ55jNLycAbyqzkYBxXkeMTqebs+W3bsHfWLJ8U49UM6apxigfoTnGF+U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com; spf=pass smtp.mailfrom=linux.alibaba.com; dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b=Rh45qPVP; arc=none smtp.client-ip=115.124.30.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b="Rh45qPVP"
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1761795505; h=Message-ID:Date:MIME-Version:Subject:To:From:Content-Type;
	bh=+0oV6FHGtxC8mCZlUEepdck6Qgr5vJIdpKAfM/OqKJs=;
	b=Rh45qPVPWL3ZFNyzC8D2MjOaYNJTMGqdoIXUhoS3Fvxdl/N+/ygdT0/lpTVqmg4G+atC4KciLlnOe+Z/UWOpBW6Hl82W9/Bd1BqSIlj8ou4DpIAuXnr1jrZ/ALgDpxOyJC/fzLJZwgA8Kq+A9vs8pwygPc0tDZhsszLD4ww+oFE=
Received: from 30.221.128.133(mailfrom:joseph.qi@linux.alibaba.com fp:SMTPD_---0WrISo6e_1761795504 cluster:ay36)
          by smtp.aliyun-inc.com;
          Thu, 30 Oct 2025 11:38:24 +0800
Message-ID: <eba45ee8-1268-4c55-bfa1-c690b28c2e21@linux.alibaba.com>
Date: Thu, 30 Oct 2025 11:38:22 +0800
Precedence: bulk
X-Mailing-List: ocfs2-devel@lists.linux.dev
List-Id: <ocfs2-devel.lists.linux.dev>
List-Subscribe: <mailto:ocfs2-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:ocfs2-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 2/2] ocfs2: validate cl_bpc in allocator inodes to prevent
 divide-by-zero
To: Deepanshu Kartikey <kartikey406@gmail.com>
Cc: Heming Zhao <heming.zhao@suse.com>, Dmitry Antipov <dmantipov@yandex.ru>,
 akpm <akpm@linux-foundation.org>, Mark Fasheh <mark@fasheh.com>,
 Joel Becker <jlbec@evilplan.org>, ocfs2-devel@lists.linux.dev,
 lvc-project@linuxtesting.org,
 syzbot+fd8af97c7227fe605d95@syzkaller.appspotmail.com
References: <9461385f-235d-40fc-8da6-b1f2dfb47d6c@linux.alibaba.com>
 <20251029055338.1192000-1-dmantipov@yandex.ru>
 <20251029055338.1192000-2-dmantipov@yandex.ru>
 <632f9f46-785d-4da9-a422-546fe3d91af3@linux.alibaba.com>
 <523f1272-8bf8-41d4-afb1-36a7ceb11494@yandex.ru>
 <ruygrlyh5vq5tbcsolpgyxgs6r36yiyph4rzgoti4txq5d6xky@k2q2smssjekq>
 <CADhLXY6rVF8+gVCT3=SjRXB3EerBT3yC8qsk25VU+tjVRkWrcQ@mail.gmail.com>
 <eeee7189-c9ed-4c80-8312-d4d15e0260e4@linux.alibaba.com>
 <CADhLXY5TPHyVkgB3f9ZNzWUursXcOByEAEch7w4GpqP6CTzv6g@mail.gmail.com>
 <CADhLXY5zFHjm81iU5Jkv2iVYuUNg_18rYqVUmZ+-V=v=P6KjFQ@mail.gmail.com>
From: Joseph Qi <joseph.qi@linux.alibaba.com>
In-Reply-To: <CADhLXY5zFHjm81iU5Jkv2iVYuUNg_18rYqVUmZ+-V=v=P6KjFQ@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit



On 2025/10/30 11:30, Deepanshu Kartikey wrote:
> Hi Joseph, Heming, and Dmitry,
> 
> Investigation complete. Here are the full test results:
> 
> **Test Setup:**
> - Kernel: Custom build with cl_bpc validation patch
> - Filesystems: Created with mkfs.ocfs2 -b [512|1024|2048|4096] -M
> local --fs-features=metaecc
> 
> **Results:**
> 
> 512-byte blocks (4KB cluster):
>   inode=20: cl_bpc=8, expected=8 (cluster_bits=12, block_bits=9)  : PASS
>   inode=23: cl_bpc=1, expected=8 (cluster_bits=12, block_bits=9) :FAIL

I've also seen this. From debugfs.ocfs2, inode 23 is global_bitmap:

[root@localhost ~]# debugfs.ocfs2 /dev/vdc
debugfs.ocfs2 1.8.7
debugfs: ls //
        18              16   1    2  .
        18              16   2    2  ..
        19              24   10   1  bad_blocks
        20              32   18   1  global_inode_alloc
        21              20   8    1  slot_map
        22              24   9    1  heartbeat
        23              28   13   1  global_bitmap
        24              28   15   2  orphan_dir:0000
        25              32   17   1  extent_alloc:0000
        26              28   16   1  inode_alloc:0000
        27              24   12   1  journal:0000
        28              28   16   1  local_alloc:0000
        29              148  17   1  truncate_log:0000

And this can be verified in mkfs:

if (rec->cluster_bitmap) {
	...
	di->id2.i_chain.cl_bpc = 1;
	...
}

So this check conflicts with global bitmap.

Joseph

>   → Validation detects corruption
> 
> 1024-byte blocks (4KB cluster):
>   inode=12: cl_bpc=4, expected=4 (cluster_bits=12, block_bits=10) :PASS
>   inode=15: cl_bpc=1, expected=4 (cluster_bits=12, block_bits=10) :FAIL
>   → Validation detects corruption
> 
> 2048-byte blocks (4KB cluster):
>   inode=10: cl_bpc=2, expected=2 (cluster_bits=12, block_bits=11) : PASS
>   inode=13: cl_bpc=1, expected=2 (cluster_bits=12, block_bits=11): FAIL
>   → Validation detects corruption
> 
> 4096-byte blocks (4KB cluster):
>   inode=8:  cl_bpc=1, expected=1 (cluster_bits=12, block_bits=12) : PASS
>   inode=11: cl_bpc=1, expected=1 (cluster_bits=12, block_bits=12) :PASS
>   → All inodes correct, mount succeeds
> 
> **Analysis:**
> 
> 1. The validation calculates expected cl_bpc as:
>    expected_bpc = 1 << (cluster_size_bits - block_size_bits)
> 
>    This matches the mkfs.ocfs2 source code you referenced:
>    di->id2.i_chain.cl_bpc = s->cluster_size / s->blocksize
> 
> 2. For non-4K block sizes, some allocator inodes (20, 12, 10, 8) have
>    correct cl_bpc values, while others (23, 15, 13) consistently have
>    cl_bpc=1.
> 
> 3. For 4K blocks, all allocator inodes have the correct value (1).
> 
> The improved error message now includes:
>   "Inode %llu has corrupted cl_bpc: ondisk=%u expected=%u
>    (cluster_size_bits=%u block_size_bits=%u)"
> 
> Please advise on next steps.
> 
> Thanks,
> Deepanshu

