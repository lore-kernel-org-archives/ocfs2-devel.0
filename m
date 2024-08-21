Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2E5D313A3E8;
	Wed, 21 Aug 2024 21:39:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724276353; cv=none; b=Wt6KnJd0Ds00A0WXsYrPgWcKmHJfXt+Ermrd4i53dWvgB2BeyJSwc+vsfMQo2zFvF+H3FXKwVdctH35vV92y5NOax289rYnHwdjsg1U0vO06GfSw2Ly903cyeQb2N/QILoF0eqRFFG9XoMIoaFxmZCmFdbaNT9wL2Tmfq9QFII4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724276353; c=relaxed/simple;
	bh=8N3R/jM2u1aV7N9gATduU3N9owwvaf/M1iYG0k8evRQ=;
	h=Date:From:To:Cc:Subject:Message-Id:In-Reply-To:References:
	 Mime-Version:Content-Type; b=p1AfMN38XJRZHM7CYtNpiVufU7I78k++dDZT/Tm/RTUbICWfz7pOW07rLxKH+hqPbODpj2oHtF8Z2TtTR3IG9QoZwWIX4M1y3/4T8M4h8F3CDCI+x/M3Y/Z9WQ111lM0eBmxblffiu81jjOC6MhnkPkkdHyQ89Rq7vve+nvSANQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=uYAdiAcd; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="uYAdiAcd"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0F0F1C4AF0E;
	Wed, 21 Aug 2024 21:39:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1724276352;
	bh=8N3R/jM2u1aV7N9gATduU3N9owwvaf/M1iYG0k8evRQ=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=uYAdiAcdRiek0VLtXJFN7hNmdz3Mb8KjaPu/QE+55QLMv6IhwUYLCMSdyqcB+XceK
	 74/HHQ1up4ByljJtJVzWApadGL+eZQUnsSpkvsZKBgJz20FiWARzmc3Fgr/sHi/YpU
	 ZhcNvqg3E0C3YnkvLx694w5SN7Qi3vWNc7NWILdc=
Date: Wed, 21 Aug 2024 14:39:11 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Heming Zhao <heming.zhao@suse.com>
Cc: Lizhi Xu <lizhi.xu@windriver.com>, joseph.qi@linux.alibaba.com,
 jlbec@evilplan.org, linux-kernel@vger.kernel.org, mark@fasheh.com,
 ocfs2-devel@lists.linux.dev,
 syzbot+ab134185af9ef88dfed5@syzkaller.appspotmail.com,
 syzkaller-bugs@googlegroups.com
Subject: Re: [PATCH V4 2/2] ocfs2: Fix possible null-ptr-deref in
 ocfs2_set_buffer_uptodate
Message-Id: <20240821143911.cec82fac50c08947523da2e6@linux-foundation.org>
In-Reply-To: <25f2be6c-3e9c-4484-a44e-d26e9c4c8a74@suse.com>
References: <1a063827-5cf3-42df-a690-f3c644c10996@linux.alibaba.com>
	<20240821091459.681136-1-lizhi.xu@windriver.com>
	<25f2be6c-3e9c-4484-a44e-d26e9c4c8a74@suse.com>
X-Mailer: Sylpheed 3.7.0 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Precedence: bulk
X-Mailing-List: ocfs2-devel@lists.linux.dev
List-Id: <ocfs2-devel.lists.linux.dev>
List-Subscribe: <mailto:ocfs2-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:ocfs2-devel+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

OK I think I found the correct patches - v3 of [1/2] and v4 of [2/2].

For clarity can we please have a full resend of both patches?

And let's please have a [0/n] cover letter which describes the problems
which are being addressed and which also briefly describes how they
were addressed.

Also, it appears that both of these fixes should be backported into
-stable kernels.  So let's please try to identify when these bugs were
introduced and to add a suitable Fixes: to the individual changelogs.

Thanks.
