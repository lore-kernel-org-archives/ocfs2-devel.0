Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 94BF92DF134;
	Fri,  3 Apr 2026 06:48:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775198896; cv=none; b=ZxXc13xKBEpUNIdfw7qWJB30Xujun4ppLDmti2wgqKAxiIeOTtFO+/GuTe3bIe4YM+vnv8z3fbliOkj5tMuLofiNmMILFp2rJcM29i8Ee1MRkg7+N/RehMKKbcYdCZJjr2Qb9GIkDJAE3Fcx9Nxb6HrD1mDo4+If57mSAYWMfig=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775198896; c=relaxed/simple;
	bh=Z0K3I3LNygPHo83AHwIn7P/oYy5b6ZoZY5w/hiTOPpU=;
	h=Date:From:To:Cc:Subject:Message-Id:In-Reply-To:References:
	 Mime-Version:Content-Type; b=fvP1R2oI8C0Kgu8Witjn9lmV0AMPtbmCAxp/8kZjV22SF9B90/d88sEBYLI8jcTaBGLCr2GP5G1IkrtBZui49tMCXuXVqKLFff9+ujUO8dWoD/XELX6+mn6is7mndqhH5sTkRGc/dfFvfG1rpD1g/2DilXhqKzLHd/1JJbW6rmI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=r71Z3gc9; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="r71Z3gc9"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 017DCC2BCAF;
	Fri,  3 Apr 2026 06:48:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1775198896;
	bh=Z0K3I3LNygPHo83AHwIn7P/oYy5b6ZoZY5w/hiTOPpU=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=r71Z3gc9Y69IQBV7hrDgqOMG9jybi7xwGBvEuwsqvJYKyzh2NoaiWxjV+U8NC4dYC
	 wCIhMaRNBJnMFGKNKXlwyl2InbnDr/vheiMXBMzmbI7Z64N3eEKMbgzm2jpBJyQ19B
	 8/6isEt1qwrq930J6bNL9JlU165hXQjyst4yuL/E=
Date: Thu, 2 Apr 2026 23:48:15 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Joseph Qi <joseph.qi@linux.alibaba.com>
Cc: Heming Zhao <heming.zhao@suse.com>, ocfs2-devel@lists.linux.dev,
 linux-kernel@vger.kernel.org
Subject: Re: [PATCH] ocfs2: fix out-of-bounds write in
 ocfs2_write_end_inline
Message-Id: <20260402234815.1c0070c4e379c6c244314949@linux-foundation.org>
In-Reply-To: <20260403063830.3662739-1-joseph.qi@linux.alibaba.com>
References: <20260403063830.3662739-1-joseph.qi@linux.alibaba.com>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Precedence: bulk
X-Mailing-List: ocfs2-devel@lists.linux.dev
List-Id: <ocfs2-devel.lists.linux.dev>
List-Subscribe: <mailto:ocfs2-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:ocfs2-devel+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Fri,  3 Apr 2026 14:38:30 +0800 Joseph Qi <joseph.qi@linux.alibaba.com> wrote:

> KASAN reports a use-after-free write of 4086 bytes in
> ocfs2_write_end_inline, called from ocfs2_write_end_nolock during a
> copy_file_range splice fallback on a corrupted ocfs2 filesystem mounted
> on a loop device. The actual bug is an out-of-bounds write past the
> inode block buffer, not a true use-after-free. The write overflows into
> an adjacent freed page, which KASAN reports as UAF.
> 
> The root cause is that ocfs2_try_to_write_inline_data trusts the
> on-disk id_count field to determine whether a write fits in inline
> data. On a corrupted filesystem, id_count can exceed the physical
> maximum inline data capacity, causing writes to overflow the inode
> block buffer.
> 
> Call trace (crash path):
> 
>    vfs_copy_file_range (fs/read_write.c:1634)
>      do_splice_direct
>        splice_direct_to_actor
>          iter_file_splice_write
>            ocfs2_file_write_iter
>              generic_perform_write
>                ocfs2_write_end
>                  ocfs2_write_end_nolock (fs/ocfs2/aops.c:1949)
>                    ocfs2_write_end_inline (fs/ocfs2/aops.c:1915)
>                      memcpy_from_folio     <-- KASAN: write OOB
> 
> So add id_count upper bound check in ocfs2_validate_inode_block() to
> alongside the existing i_size check to fix it.

Thanks.

> --- a/fs/ocfs2/inode.c
> +++ b/fs/ocfs2/inode.c
> @@ -1505,6 +1505,16 @@ int ocfs2_validate_inode_block(struct super_block *sb,
>  			goto bail;
>  		}
>  
> +		if (le16_to_cpu(data->id_count) >
> +		    ocfs2_max_inline_data_with_xattr(sb, di)) {
> +			rc = ocfs2_error(sb,
> +					 "Invalid dinode #%llu: inline data id_count %u exceeds max %d\n",
> +					 (unsigned long long)bh->b_blocknr,
> +					 le16_to_cpu(data->id_count),
> +					 ocfs2_max_inline_data_with_xattr(sb, di));
> +			goto bail;
> +		}
> +
>  		if (le64_to_cpu(di->i_size) > le16_to_cpu(data->id_count)) {
>  			rc = ocfs2_error(sb,
>  					 "Invalid dinode #%llu: inline data i_size %llu exceeds id_count %u\n",

Even though the surrounding code is from 2025 (1524af3685b35), I think
this bug predates 1524af3685b35?

If so, I expect the -stable people will have trouble backporting this. 
If so, they'll report it and shall ask for a reworked version.
