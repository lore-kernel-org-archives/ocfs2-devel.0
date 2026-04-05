Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 521232EF67A;
	Sun,  5 Apr 2026 00:50:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775350241; cv=none; b=UZxPJDhsjDP9B+t55HKAvAT4ZU2sYYEsiyc3m47qB+ordJM7vKM8gYemD8acMzpFf1pFXPJA+4TSY436jIlSHphPSCfjxamDvlQrPjhaNSFgq90LcH0wWSgFeEJH6QUr8b+s/ORqL/paIqwD9JjTnxl8n/mgbrwdE7N517h7Pbc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775350241; c=relaxed/simple;
	bh=SbhhwNVrp5/1gtDGXdM4lR4GcyYNdAQxRJjqoBWzZmA=;
	h=Date:From:To:Cc:Subject:Message-Id:In-Reply-To:References:
	 Mime-Version:Content-Type; b=D27y9XOzruCNr1CXgIBWPrVcj270FqmkR1XKTIsrxiajEeQ0squKrsq+5c8445x8TyRqCoLhC/mVKefTTMew76uY1ASz5UxlGcEplYkTfRDV32QDmL2UjUPs8T2Uod8cgfnPgMG676aJHuSXAbLtxdHhhq72y8UYTZeSAcKAHZM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=2m6T1DQq; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="2m6T1DQq"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AA12BC19421;
	Sun,  5 Apr 2026 00:50:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1775350241;
	bh=SbhhwNVrp5/1gtDGXdM4lR4GcyYNdAQxRJjqoBWzZmA=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=2m6T1DQqjrw8r/6ngKXdQeZczTLQKb8wO1GsPAJFmbdPajTgmy9jQyRxio3uNyW9w
	 hnq38ISvUa5LCSv84I+9uwfDq7Ej4uo4BPFkP+poDUtAsbx4AGfXT2MfWSEbjtspYc
	 nr/NN5HZzHW3SLiLVIcc7hShhAnAFuroORgf0KJI=
Date: Sat, 4 Apr 2026 17:50:40 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: tejas bharambe <tejas.bharambe@outlook.com>
Cc: Tejas Bharambe <thbharam@gmail.com>, "ocfs2-devel@lists.linux.dev"
 <ocfs2-devel@lists.linux.dev>, "mark@fasheh.com" <mark@fasheh.com>,
 "jlbec@evilplan.org" <jlbec@evilplan.org>, "joseph.qi@linux.alibaba.com"
 <joseph.qi@linux.alibaba.com>, "linux-kernel@vger.kernel.org"
 <linux-kernel@vger.kernel.org>,
 "syzbot+a49010a0e8fcdeea075f@syzkaller.appspotmail.com"
 <syzbot+a49010a0e8fcdeea075f@syzkaller.appspotmail.com>,
 "stable@vger.kernel.org" <stable@vger.kernel.org>
Subject: Re: [PATCH v4] ocfs2: fix use-after-free in ocfs2_fault() when
 VM_FAULT_RETRY
Message-Id: <20260404175040.40a746040ddb0cb5ce347fe3@linux-foundation.org>
In-Reply-To: <JH0PR06MB66320ABCFAD8F239FE5112B2895CA@JH0PR06MB6632.apcprd06.prod.outlook.com>
References: <20260403035333.136824-1-tejas.bharambe@outlook.com>
	<20260403122947.2afc337b5333fb1990a78a65@linux-foundation.org>
	<JH0PR06MB66320ABCFAD8F239FE5112B2895CA@JH0PR06MB6632.apcprd06.prod.outlook.com>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Precedence: bulk
X-Mailing-List: ocfs2-devel@lists.linux.dev
List-Id: <ocfs2-devel.lists.linux.dev>
List-Subscribe: <mailto:ocfs2-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:ocfs2-devel+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Sun, 5 Apr 2026 00:30:14 +0000 tejas bharambe <tejas.bharambe@outlook.com> wrote:

> Following is my response for question posted on https://sashiko.dev/#/patchset/20260403035333.136824-1-tejas.bharambe%40outlook.com
> 
> 
> No. For ocfs2_fault() to be executing, the file must be open and
> the process holds an active file descriptor. The inode's lifetime
> is tied to the file's reference count, which remains held by the
> file descriptor for the duration of the fault handler. munmap()
> can free the VMA (decrementing vm_file's refcount) but cannot
> free the inode as long as the file descriptor is open. The faulting
> thread cannot call close() while it is inside the fault handler,
> so the inode is guaranteed to outlive the trace call.

I don't think that's the scenario which Sashiko is suggesting.

Suppose userspace does

	fd = open(...);
	p = mmap(fd, ...);
	close(fd);

Now, that mmap is the only ref against fd.

Now, suppose that userspace does munmap() while another thread is in
the fault handler.

