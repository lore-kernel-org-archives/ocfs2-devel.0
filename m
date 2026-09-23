Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AE2C83B895A;
	Wed, 23 Sep 2026 21:22:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790198551; cv=none; b=dhlYgozrdbAkz3ywavUBsO3WJH06HpwuzoBc+CIWfhWm8kHGgCZ2NG9IVZCMPLpjO4tVeYiwTS8fKtrHbOdmIaAHQaOCflnTirFQcnm7RiywCbGhJdjBjBiSld4JJ3DOoRokpm4DFoWtQBYxyjbXHuRaUF7up8GZUXIpEEy2AJ0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790198551; c=relaxed/simple;
	bh=3VDMq1yRySAjrvpFfTz3Kcr+OFso2eX52PyUckI5VHs=;
	h=Date:From:To:Cc:Subject:Message-Id:In-Reply-To:References:
	 Mime-Version:Content-Type; b=I1JUb4MmsZexnqjXPe+/MTMwlp6CqdT6kcPasmTpzytCaWATIFECwI5qksfpVAfjvADrshpFFdASpPeWwot3brPYEMEN1Z5Y4VrOGTe+REhC0mqgXcUTeIPFxohFnEHBnEltTBmFyNbIW0jO7pS2TTXIkCZQV6TRD1fI99e0f/0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=bRhoKlt3; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="bRhoKlt3"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2DE3A1F000FF;
	Wed, 23 Sep 2026 21:22:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1790198547;
	bh=mDuuDfWt5XPUEfsZUsZ3e2fdKp/gTNRlThYQAeTCgTE=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References;
	b=bRhoKlt3sY3+1NVHrwQsWoaaWIKhJ+/PLG27/s+v7Ih7m63V3IpU4XdBECnsuemdf
	 mYYvJ2XHrJ/yXyywI9owIrYwlEmcTd4OZS2o11YYSRDjEDW9UV2wanqgCjbM9ehAX8
	 DLdW/JwEGHq+NjgOBXqOYUS18obohja+LSzSTKF8=
Date: Wed, 23 Sep 2026 14:22:26 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Joseph Qi <joseph.qi@linux.alibaba.com>
Cc: Karl Mehltretter <kmehltretter@gmail.com>, Mark Fasheh
 <mark@fasheh.com>, Joel Becker <jlbec@evilplan.org>, Cen Zhang
 <zzzccc427@gmail.com>, ocfs2-devel@lists.linux.dev,
 linux-kernel@vger.kernel.org, Sashiko <sashiko-bot@kernel.org>
Subject: Re: [PATCH] ocfs2/cluster: hold a reference on the heartbeat thread
Message-Id: <20260923142226.9a4d0eb4c71128b34e9aa10c@linux-foundation.org>
In-Reply-To: <e06390dc-fdfb-4bad-85ba-6baf361fac18@linux.alibaba.com>
References: <20260923010149.14391-1-kmehltretter@gmail.com>
	<e06390dc-fdfb-4bad-85ba-6baf361fac18@linux.alibaba.com>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Precedence: bulk
X-Mailing-List: ocfs2-devel@lists.linux.dev
List-Id: <ocfs2-devel.lists.linux.dev>
List-Subscribe: <mailto:ocfs2-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:ocfs2-devel+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Wed, 23 Sep 2026 10:45:10 +0800 Joseph Qi <joseph.qi@linux.alibaba.com> wrote:

> 
> 
> On 9/23/26 9:01 AM, Karl Mehltretter wrote:
> > Since commit 688bc88e2046 ("ocfs2/cluster: keep heartbeat local node
> > stable"), o2hb_thread() leaves its loop and returns when the local node
> > changes, for example after "echo 0 > node/<name>/local". The thread
> > was started with kthread_run() and nothing holds a reference to its
> > task_struct, so the task is freed once it exits, while reg->hr_task
> > still points to it.
> > 
> > Reading the region's pid attribute then reads the freed task, and
> > removing the region calls kthread_stop() on it:
> > 
> >   BUG: KASAN: slab-use-after-free in o2hb_region_pid_show+0xb3/0xc0
> >   refcount_t: addition on 0; use-after-free.
> >   Oops: Oops: 0000 [#1] SMP KASAN NOPTI
> >   RIP: 0010:kthread_stop+0xb1/0x390
> > 
> > The thread could already return by itself before, when heartbeat start
> > was aborted or on an unclean stop, but the local node change makes it
> > reachable from userspace at any time.
> > 
> > Create the thread parked, take a reference on it and only then wake it,
> 
> Just a wording nit. kthread_create() doesn't leave the thread parked in
> the kthread_park() sense. __kthread_parkme() only runs after the first
> wake_up_process(), so "parked" here may be a little confused.

I simply did s/parked //.

> The change looks fine to me.
> Reviewed-by: Joseph Qi <joseph.qi@linux.alibaba.com>

Thanks as always.
