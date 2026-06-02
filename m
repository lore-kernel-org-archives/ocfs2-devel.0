Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3631C24A078;
	Tue,  2 Jun 2026 04:40:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780375240; cv=none; b=E7tJGBbBmqidDDCjjGos/1kVYXgm/5L3xkPUiAso90FqrVyzKOqA1zpQ/1ySK2frFHi3KJtci6JnqNmo09ed3G1rtOvatUpNnn6wvLHgl/5sc5AfWRBCwCm5sXzmA0jUMxhdQvcntpcxMI57d29IBSwCZwLZAG7qfwm32BaAZ/Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780375240; c=relaxed/simple;
	bh=FZnsvbLL6GZARx7InGx864SP8NrLVaHSnFx7Tu2hrQE=;
	h=Date:From:To:Cc:Subject:Message-Id:In-Reply-To:References:
	 Mime-Version:Content-Type; b=MU6ouYBadfx++bWUE+Yiepc4OoVa2NrVERBZE/u0zRg01TJXiG/zSQlbQNbLra8HGRx2GmtOEKYbjRGRZlLcZ5hfZLVPpvHieMvTvIlMKj8jI1GO7wckTlmHq3FP+9v3077ggAGL68b1jtUUZOP0bfZnUPgTKYRj9ApUCGBUi0I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=leuFqK5H; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="leuFqK5H"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B0C201F00893;
	Tue,  2 Jun 2026 04:40:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1780375238;
	bh=EERip6jqoYfqg+JeKt/4HbNx1SXTUpJWvoUPgBstMCs=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References;
	b=leuFqK5HWdd7dkuoh9XDIh90AWV2OsGcBpnvlHfBMrpPGFIXn50oe4TL3TIldk9Wv
	 paNjG5ieaSqgk9EC4Twv3H1Oj70dpcaCNh1/rCxi8S1j+In7gR3El1PLJUG0XTGvhj
	 dVRBoRMLODLtjtZSVkp3pnGcFDnsD/VoqczlgqtQ=
Date: Mon, 1 Jun 2026 21:40:38 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Heming Zhao <heming.zhao@suse.com>
Cc: Joseph Qi <joseph.qi@linux.alibaba.com>, Ginger
 <ginger.jzllee@gmail.com>, ocfs2-devel@lists.linux.dev,
 linux-kernel@vger.kernel.org
Subject: Re: [PATCH] ocfs2: fix race between ocfs2_control_install_private()
 and ocfs2_control_release()
Message-Id: <20260601214038.33b6d96002327d82c7637bf9@linux-foundation.org>
In-Reply-To: <ah5ZMguK4Pzh1DfX@p15>
References: <20260601121618.1263346-1-joseph.qi@linux.alibaba.com>
	<ah5ZMguK4Pzh1DfX@p15>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Precedence: bulk
X-Mailing-List: ocfs2-devel@lists.linux.dev
List-Id: <ocfs2-devel.lists.linux.dev>
List-Subscribe: <mailto:ocfs2-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:ocfs2-devel+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Tue, 2 Jun 2026 12:18:59 +0800 Heming Zhao <heming.zhao@suse.com> wrote:

> On Mon, Jun 01, 2026 at 08:16:18PM +0800, Joseph Qi wrote:
> > Move atomic_inc(&ocfs2_control_opened) and the handshake state update
> > inside ocfs2_control_lock to close a race window where
> > ocfs2_control_release() can observe ocfs2_control_opened dropping to
> > zero (resetting ocfs2_control_this_node and running_proto) while
> > ocfs2_control_install_private() is about to bump the counter and mark
> > the connection valid.
> > 
> > Fixes: 3cfd4ab6b6b4 ("ocfs2: Add the local node id to the handshake.")
> > Reported-by: Ginger <ginger@gmail.com>
> 
> The code looks good to me, but above email address is not valid.
> The correct should be: <ginger.jzllee@gmail.com>

Updated, thanks.
