Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E03491A2389;
	Tue,  6 Jan 2026 01:37:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767663433; cv=none; b=Spo5GhxE8jynQZ9UjvT12Ncply/T2aSLV1oQTnfeBw3unaHMw96cigvSSK9QVa0uw7wSmgDDKjmYv2WtNq3FdUG8BrNNIAxi2E4MiHs06/DhuAgRUlIz0PKLx5SAI80K0BSD8Oa0TZn5rJucz77UuTZ6uPgnwolGlHG/JvuIl6k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767663433; c=relaxed/simple;
	bh=K9iUbgpslLLTx6D7Yx3lzQ7QC8CP/qj9zPebieS0lDI=;
	h=Date:From:To:Cc:Subject:Message-Id:In-Reply-To:References:
	 Mime-Version:Content-Type; b=MRNCiOg1cLBmcBZgIP39n40XSyGytDRvgYELmp7WDXnNKs4eOvM/4YKoviG4kPwyNwxKNqsdOnPgf7gzzrlYoP+Ymu3vn+epwy/V3HAIsDaq0T5Of1mq5Vxac9ehDuVh8mF5QscjfHh7rjL85fMIBQCb1TNpgg4M5COa+no3bKs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=qu86JsEs; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="qu86JsEs"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 30D61C16AAE;
	Tue,  6 Jan 2026 01:37:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1767663432;
	bh=K9iUbgpslLLTx6D7Yx3lzQ7QC8CP/qj9zPebieS0lDI=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=qu86JsEsI00SXBkYje4I1f2QaMTk1BEb+fL8gomAvAAdz9ErtRNEntCfATJ/UCXwI
	 wQm0mjIp/eUfFUg76Qt7qJpllH1Ekt7/Pina+0Czxjgwsi5Ue8D25Hb4hv/0bYvRzE
	 RhCzA9qd8yl4g5Ic2nADeRtaH9BFYeAL3/mcMEyA=
Date: Mon, 5 Jan 2026 17:37:11 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Szymon Wilczek <swilczek.lx@gmail.com>
Cc: ocfs2-devel@lists.linux.dev, mark@fasheh.com, jlbec@evilplan.org,
 joseph.qi@linux.alibaba.com, linux-kernel@vger.kernel.org,
 syzkaller-bugs@googlegroups.com,
 syzbot+51244a05705883616c95@syzkaller.appspotmail.com
Subject: Re: [PATCH] ocfs2: fix circular locking dependency in
 ocfs2_acquire_dquot
Message-Id: <20260105173711.b33d85c7f72544876c8dcfd3@linux-foundation.org>
In-Reply-To: <20251227174251.121668-1-swilczek.lx@gmail.com>
References: <20251227174251.121668-1-swilczek.lx@gmail.com>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Precedence: bulk
X-Mailing-List: ocfs2-devel@lists.linux.dev
List-Id: <ocfs2-devel.lists.linux.dev>
List-Subscribe: <mailto:ocfs2-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:ocfs2-devel+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Sat, 27 Dec 2025 18:42:51 +0100 Szymon Wilczek <swilczek.lx@gmail.com> wrote:

> Move ocfs2_extend_no_holes() to execute before ocfs2_lock_global_qf() to
> fix a circular locking dependency reported by syzbot.
> 
> The issue occurs because ocfs2_extend_no_holes() internally calls
> ocfs2_extend_allocation() which starts a transaction (acquiring
> sb_start_intwrite). When called while holding the global quota file
> lock, this conflicts with mount-time operations that acquire
> sb_internal first, creating the following circular dependency:
> 
>   sb_internal -> ocfs2_sysfile_lock_key -> ocfs2_quota_ip_alloc_sem_key
> 
> By moving the quota file extension before acquiring the global quota
> file lock, we ensure that any internal transactions complete before
> quota locks are held, breaking the circular dependency.

Thanks.  This might have escaped reviewer attention due to the holiday
season.  I'll add it to mm.git's mm-nonmm-unstable branch for runtime
testing while we await review (please!).
