Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 758C43D5235;
	Fri,  3 Apr 2026 19:32:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775244760; cv=none; b=DYglArC2YffuQHJWfSnps+dqke/5SwYL070EQQ9ZXKsOLLNFCGZs/eaaK9Y5ivtfsLfcNg8Bt4Ml8DG4ZTD6NKclKPymwBpSsYdwc32Gw/4xd3eqNHia1jUAkLFnt1WdfUSpcT4X+Z8Xl5r7qpYe6jr8F8Zy59vdzGdVV5Psm1w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775244760; c=relaxed/simple;
	bh=9EiPW59Tl/qzchVpA+lefSb0hh8vy5R+w6PAVBfucao=;
	h=Date:From:To:Cc:Subject:Message-Id:In-Reply-To:References:
	 Mime-Version:Content-Type; b=PliMQ2/Pf0l+MwnmmxGN6OrFCgCl9T5BqskbQCUoMojytcJiMggl/D63Nw8UNbTQyT4QEMKkXEbHYLKq/sO7vVLUPuCZ4WEFj0ChtuiYiya2W4sNixwp/lFrUg0v9xPBUOlxMuMo7aujkHX/pnZwnhLNyQUvpXd9pv4dgkEt9Zw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=TDNAigcK; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="TDNAigcK"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 06915C19424;
	Fri,  3 Apr 2026 19:32:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1775244760;
	bh=9EiPW59Tl/qzchVpA+lefSb0hh8vy5R+w6PAVBfucao=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=TDNAigcK/zAKlUiyCWUJUERD/4C6iaucfLT7WzRQ6ZeGEw2bNQF5uqpw78XAfPtGi
	 iufXGU2jy4CZAezAQz2toaSmqaGk7AS4tqJhwtx8Yu9pO6oUmg5D0lIFHBPDT4fCfG
	 dZ3QARlj2RVZrnL+nCpFJxQXOAmuKR5BqfzpOb4c=
Date: Fri, 3 Apr 2026 12:32:39 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Heming Zhao <heming.zhao@suse.com>
Cc: joseph.qi@linux.alibaba.com, ocfs2-devel@lists.linux.dev,
 linux-kernel@vger.kernel.org, jack@suse.cz, glass.su@suse.com
Subject: Re: [PATCH v8 1/1] ocfs2: split transactions in dio completion to
 avoid credit exhaustion
Message-Id: <20260403123239.5e49f98fc752b24cf309f453@linux-foundation.org>
In-Reply-To: <20260402134328.27334-2-heming.zhao@suse.com>
References: <20260402134328.27334-1-heming.zhao@suse.com>
	<20260402134328.27334-2-heming.zhao@suse.com>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Precedence: bulk
X-Mailing-List: ocfs2-devel@lists.linux.dev
List-Id: <ocfs2-devel.lists.linux.dev>
List-Subscribe: <mailto:ocfs2-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:ocfs2-devel+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Thu,  2 Apr 2026 21:43:27 +0800 Heming Zhao <heming.zhao@suse.com> wrote:

> During ocfs2 dio operations, JBD2 may report warnings via following
> call trace:
> ocfs2_dio_end_io_write
>  ocfs2_mark_extent_written
>   ocfs2_change_extent_flag
>    ocfs2_split_extent
>     ocfs2_try_to_merge_extent
>      ocfs2_extend_rotate_transaction
>       ocfs2_extend_trans
>        jbd2__journal_restart
>         start_this_handle
>          output: JBD2: kworker/6:2 wants too many credits credits:5450 rsv_credits:0 max:5449
> 
> To prevent exceeding the credits limit, modify ocfs2_dio_end_io_write() to
> handle extents in a batch of transaction.
> 
> Additionally, relocate ocfs2_del_inode_from_orphan(). The orphan inode should
> only be removed from the orphan list after the extent tree update is complete.
> This ensures that if a crash occurs in the middle of extent tree updates, we
> won't leave stale blocks beyond EOF.
> 
> This patch also changes the logic for updating the inode size and removing
> orphan, making it similar to ext4_dio_write_end_io(). Both operations are
> performed only when everything looks good.
> 
> Finally, thanks to Jans and Joseph for providing the bug fix prototype and
> suggestions.

AI review has a question:
	https://sashiko.dev/#/patchset/20260402134328.27334-2-heming.zhao@suse.com
