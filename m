Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5B3612EAB72;
	Fri,  3 Apr 2026 19:28:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775244527; cv=none; b=qPVzLDOiciOXNZ21kotmwM94KvV+BlMPXvsvrLsHMvph3vubKHqL7/F6Vh3vsaCEv6wQl8nwfctaninlXJosZvlIWZBHBsszQzrwzXfOWfP7WRR0e0VkSfKYgyTSfiXW018SwjbfznkM2dz6VpkZjD21TVz3vfzQ3cLhsowneVE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775244527; c=relaxed/simple;
	bh=twqZKGWgGyoIEC6W+aLi6dbvmNdBK81wbihQWZ34SgU=;
	h=Date:From:To:Cc:Subject:Message-Id:In-Reply-To:References:
	 Mime-Version:Content-Type; b=uQ8/rirnk2hP4ApzYY9tWxDtlW2tb/RM2hKBPmzgwXraa37+qo5ryaPGS587v/ODCMfB0GtIU9dmDeNA96yVXhDzy9zlFtf5RyIiv1Vzuk/8r+weyNBurantwsmkqpUqIVt/8FqHnpNQqv8CEM8Fa9mUvtd4KfrFdBUSRzKcWlg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=L8f4QOVs; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="L8f4QOVs"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DCB51C4CEF7;
	Fri,  3 Apr 2026 19:28:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1775244527;
	bh=twqZKGWgGyoIEC6W+aLi6dbvmNdBK81wbihQWZ34SgU=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=L8f4QOVsxbDYZmf3AKIxCWkaSg8iNUSf82sborl+J0J2qsUBGtOdl4PY1ywr83ctT
	 R3WhD+cYntOHT4w9a2lzHpTJgUOkBRODYnlTNomTBeFycFNartY7Ry8svVDTzhVytv
	 soCUOAEF4L7MMNmfLD9KGwjsrpBGxBzqyWSiv6bM=
Date: Fri, 3 Apr 2026 12:28:46 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Joseph Qi <joseph.qi@linux.alibaba.com>
Cc: Heming Zhao <heming.zhao@suse.com>, ocfs2-devel@lists.linux.dev,
 linux-kernel@vger.kernel.org
Subject: Re: [PATCH] ocfs2: fix out-of-bounds write in
 ocfs2_write_end_inline
Message-Id: <20260403122846.daf61b872e045baee9470f3a@linux-foundation.org>
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

AI review had a question:
	https://sashiko.dev/#/patchset/20260403063830.3662739-1-joseph.qi@linux.alibaba.com
