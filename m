Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 609D234B19F;
	Fri,  3 Apr 2026 19:29:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775244588; cv=none; b=cxsokldVssavROWiPNN6X6zlXawgYbJsUK2GuqgIDExunrPbVfvskuXLDRjSXkUpGmXEYxYb2c+WALoUHMAQsPUhrFK1vWVRSpCZWUOXOJ8W3QETiZqCTeb7BqzUpVwyBAwVIgOtlF0bKYI0ESzCj7q03Zn9YEv5ugPQHNn1fsc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775244588; c=relaxed/simple;
	bh=KVUOBm/XJXH3v16GB6JhY07VnRDXsYp6At0wwZo7LgE=;
	h=Date:From:To:Cc:Subject:Message-Id:In-Reply-To:References:
	 Mime-Version:Content-Type; b=ewBgLiuwcms/l61Rp8cWIA/8zUKlZzcY0Ulood4GWMdwrB/+CNVD5aQp7IkRMVsmJKPDJH4cV5YxkK71aogS0ptwbnEn1Wja4sDkgZqUxRvWGnCiTotRUTaP3n3tO8in1zyAd96phmxrchJY9fvDkkuVPQCJlKb4Jo25v+NaZwE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=XmHcnQM5; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="XmHcnQM5"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C000BC4CEF7;
	Fri,  3 Apr 2026 19:29:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1775244588;
	bh=KVUOBm/XJXH3v16GB6JhY07VnRDXsYp6At0wwZo7LgE=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=XmHcnQM5tBJuavm3UYXl1I6gZ5Do35IbN8BEgTgDFOl/a5894drXD1hbbWQK6iTpj
	 +Ha1GPT3mv4EEfaQBjwPAzscrG9qAf+gOQp+9xsdIGG8Xp2CDRsMNNjzwMRPuIMDcW
	 sHyZPIm96xsFvjd8bdUlJEDnb7qR47gDf8GZB9wQ=
Date: Fri, 3 Apr 2026 12:29:47 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Tejas Bharambe <thbharam@gmail.com>
Cc: ocfs2-devel@lists.linux.dev, mark@fasheh.com, jlbec@evilplan.org,
 joseph.qi@linux.alibaba.com, linux-kernel@vger.kernel.org,
 syzbot+a49010a0e8fcdeea075f@syzkaller.appspotmail.com, Tejas Bharambe
 <tejas.bharambe@outlook.com>, stable@vger.kernel.org
Subject: Re: [PATCH v4] ocfs2: fix use-after-free in ocfs2_fault() when
 VM_FAULT_RETRY
Message-Id: <20260403122947.2afc337b5333fb1990a78a65@linux-foundation.org>
In-Reply-To: <20260403035333.136824-1-tejas.bharambe@outlook.com>
References: <20260403035333.136824-1-tejas.bharambe@outlook.com>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Precedence: bulk
X-Mailing-List: ocfs2-devel@lists.linux.dev
List-Id: <ocfs2-devel.lists.linux.dev>
List-Subscribe: <mailto:ocfs2-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:ocfs2-devel+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Thu,  2 Apr 2026 20:53:33 -0700 Tejas Bharambe <thbharam@gmail.com> wrote:

> filemap_fault() may drop the mmap_lock before returning VM_FAULT_RETRY,
> as documented in mm/filemap.c:
> 
>   "If our return value has VM_FAULT_RETRY set, it's because the mmap_lock
>   may be dropped before doing I/O or by lock_folio_maybe_drop_mmap()."
> 
> When this happens, a concurrent munmap() can call remove_vma() and free
> the vm_area_struct via RCU. The saved 'vma' pointer in ocfs2_fault() then
> becomes a dangling pointer, and the subsequent trace_ocfs2_fault() call
> dereferences it -- a use-after-free.
> 
> Fix this by saving the inode reference before calling filemap_fault(),
> and removing vma from the trace event. The inode remains valid across
> the lock drop since the file is still open, so the trace can fire in
> all cases without dereferencing the potentially freed vma.

There's one question from the Sashiko AI reviewbot:
	https://sashiko.dev/#/patchset/20260403035333.136824-1-tejas.bharambe@outlook.com
