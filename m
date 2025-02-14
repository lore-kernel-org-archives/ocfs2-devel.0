Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 547251922DE;
	Fri, 14 Feb 2025 23:55:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739577316; cv=none; b=CfvgkPEZWkUdXBjd42vb/2eEusb83/v+B8ATvDFTC/gWRcDZi9ijC9FTu+cItCe/4ZLogLdDcc0EjmFA3r1x2rNBgJ+Z2CtHMCwa0iMWZxxQEK7hfrzNB/z5sFHnh7WRtXMNORLX95HFD7zYS+mGU0PO6nn7aUC02gQtNZFWzRU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739577316; c=relaxed/simple;
	bh=LOrgP2GBZzTB/pBJ6maZqV8jSpcnBwpbXGa9l3n7VD0=;
	h=Date:From:To:Cc:Subject:Message-Id:In-Reply-To:References:
	 Mime-Version:Content-Type; b=kXN2+rwJVvn7wJ0l6P9RnRXpER/rRX+nhqVjHoNyGYYDsDZ68qEsk2Z74VTu8zm4N9mzUvWPal0/YzUCcAHHDJ16HfSrhAVpqOG7cIhF88P/6h0LLJRMlQAMWUK2I4PLAUY2e9jv1DfkngFl14h9Ze8WBY0bmyAmZYHiG6q+kJY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=GIEoyJh0; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="GIEoyJh0"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9BA60C4CED1;
	Fri, 14 Feb 2025 23:55:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1739577315;
	bh=LOrgP2GBZzTB/pBJ6maZqV8jSpcnBwpbXGa9l3n7VD0=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=GIEoyJh02x/WA7joBFGX34vUq9LZ+XhWRQrIwhNHtvyS7JCheHlvR5f6S+2k7fiPL
	 1vBX7XJPvbP8gWlNvsRvOlfK2ejPeflBcsSgkhlI4X/7GJCf9R25IAnsQpnh3KcjfC
	 g1rg6I6uktN/Dk/7mt3DEBy4HwzaKgOESXgEl4EY=
Date: Fri, 14 Feb 2025 15:55:15 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Joseph Qi <joseph.qi@linux.alibaba.com>
Cc: Wengang Wang <wen.gang.wang@oracle.com>, "ocfs2-devel@lists.linux.dev"
 <ocfs2-devel@lists.linux.dev>, "linux-kernel@vger.kernel.org"
 <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] ocfs2: update seq_file index in ocfs2_dlm_seq_next
Message-Id: <20250214155515.6283b71e47730d0e2e6c9664@linux-foundation.org>
In-Reply-To: <6c468b6c-c449-444d-90af-fd2a6c7c1993@linux.alibaba.com>
References: <20241108192829.58813-1-wen.gang.wang@oracle.com>
	<614f6304-f096-41f7-b0a4-05127904e601@linux.alibaba.com>
	<72E849B5-ECE7-4304-AF90-A60784B4EEFF@oracle.com>
	<6c468b6c-c449-444d-90af-fd2a6c7c1993@linux.alibaba.com>
X-Mailer: Sylpheed 3.7.0 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Precedence: bulk
X-Mailing-List: ocfs2-devel@lists.linux.dev
List-Id: <ocfs2-devel.lists.linux.dev>
List-Subscribe: <mailto:ocfs2-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:ocfs2-devel+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

On Mon, 11 Nov 2024 17:35:49 +0800 Joseph Qi <joseph.qi@linux.alibaba.com> wrote:

> 
> 
> On 11/11/24 3:04 PM, Wengang Wang wrote:
> > 
> > 
> >> On Nov 10, 2024, at 5:38 PM, Joseph Qi <joseph.qi@linux.alibaba.com> wrote:
> >>
> >>
> >>
> >> On 11/9/24 3:28 AM, Wengang Wang wrote:
> >>> The following INFO level message was seen:
> >>>
> >>> seq_file: buggy .next function ocfs2_dlm_seq_next [ocfs2] did not
> >>> update position index
> >>>
> >>> Fix:
> >>> Updata m->index to make seq_read_iter happy though the index its self makes
> >>> no sense to ocfs2_dlm_seq_next.
> >>>
> >>> Signed-off-by: Wengang Wang <wen.gang.wang@oracle.com>
> >>> ---
> >>> fs/ocfs2/dlmglue.c | 1 +
> >>> 1 file changed, 1 insertion(+)
> >>>
> >>> diff --git a/fs/ocfs2/dlmglue.c b/fs/ocfs2/dlmglue.c
> >>> index 60df52e4c1f8..349d131369cf 100644
> >>> --- a/fs/ocfs2/dlmglue.c
> >>> +++ b/fs/ocfs2/dlmglue.c
> >>> @@ -3120,6 +3120,7 @@ static void *ocfs2_dlm_seq_next(struct seq_file *m, void *v, loff_t *pos)
> >>> }
> >>> spin_unlock(&ocfs2_dlm_tracking_lock);
> >>>
> >>> + m->index++;
> >>
> >> We can directly use '(*pos)++' instead.
> >>
> > 
> > The input/output "pos” indicates more an offset into the file. Actually the output for an item is not really 1 byte in length, so incrementing the offset by 1 sounds a bit strange to me. Instead If we increment the “index”, It would be easier to understand it as  for next item. Though updating “index” or updating “*pos” instead makes no difference to binary running, the code understanding is different.  I know other seq_operations.next functions are directly incrementing the “*pos”, I think updating “index” is better. Well, if you persist (*pos)++, I will also let it go.
> > 
> >From seq_read_iter(), the input pos is equivalent to '&m->index'. So the
> above two ways seems have no functional difference.
> IMO, we'd better hide the m->index logic into seqfile and just use pos
> instead like other .next implementations.

Did we ever fix this?
