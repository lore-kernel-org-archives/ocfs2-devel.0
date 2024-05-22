Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E3181811E0
	for <ocfs2-devel@lists.linux.dev>; Wed, 22 May 2024 22:15:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716416113; cv=none; b=inVjB0QsZFyHOiaKMyUIriMMYsKYBqor1hWtxhaimQpaDuMbPVYps/F0+Z1olWj19GusYt2AP/rtk8U/Fzd1QhoiMEZ5ubQ+/4nQfSEqWo4r0ogq//MwcpmKiTp9GmT8bMjySaO1G4r4X3JY9lMO/E98ebi6PykKwJJHmmZEBfg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716416113; c=relaxed/simple;
	bh=wv2NzI9nq1Km8SDN16SUaymZCAwULNjXvJcSM5WCDkA=;
	h=Date:From:To:Cc:Subject:Message-Id:In-Reply-To:References:
	 Mime-Version:Content-Type; b=ra7PgsWxWgsbgR9qA0C7LqcZeIkMtwZmMs1IVYsNaRsUSJKUpoAnTQat510WtISO2ZjNMt5fyWHhQqMPsHJrs9+vvlFITIp5Fd7ls+VSwFmgLcd4Yy6LZJr9LGflIpKh0qgladB1fb79dOxV1GgE16SGouUmaImtbeQLRF/Fr88=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=Z2tBHFST; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="Z2tBHFST"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 84DE0C2BBFC;
	Wed, 22 May 2024 22:15:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1716416112;
	bh=wv2NzI9nq1Km8SDN16SUaymZCAwULNjXvJcSM5WCDkA=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=Z2tBHFSTbmANA2z3Uwu/i0TOYwspm7jXbiHeFtOQHH+eOV9vYM7ZoGc4BYNbIC2hg
	 1jKuzFXTMkmqEoYQl5RTKs0wjRR7ZMduwoDiE5XC8UO34ob+YM5Jpe+ynYMkbcZ8JK
	 QZ77cKEXqncnINCOwHtWcJGP9AdFFomyWlUlUrS4=
Date: Wed, 22 May 2024 15:15:12 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Joseph Qi <joseph.qi@linux.alibaba.com>
Cc: Ferry Meng <mengferry@linux.alibaba.com>, lei lu <llfamsec@gmail.com>,
 ocfs2-devel@lists.linux.dev
Subject: Re: [PATCH RESEND 1/2] ocfs2: add bounds checking to
 ocfs2_xattr_find_entry()
Message-Id: <20240522151512.e4ea8f2cd23037520cacc6d7@linux-foundation.org>
In-Reply-To: <20240520024024.1976129-1-joseph.qi@linux.alibaba.com>
References: <20240520024024.1976129-1-joseph.qi@linux.alibaba.com>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Precedence: bulk
X-Mailing-List: ocfs2-devel@lists.linux.dev
List-Id: <ocfs2-devel.lists.linux.dev>
List-Subscribe: <mailto:ocfs2-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:ocfs2-devel+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Mon, 20 May 2024 10:40:23 +0800 Joseph Qi <joseph.qi@linux.alibaba.com> wrote:

> From: Ferry Meng <mengferry@linux.alibaba.com>
> 
> From: Ferry Meng <mengferry@linux.alibaba.com>
> 
> Add a paranoia check to make sure it doesn't stray beyond valid memory
> region containing ocfs2 xattr entries when scanning for a match.
> It will prevent out-of-bound access in case of crafted images.
> 
> Reported-by: lei lu <llfamsec@gmail.com>
> Signed-off-by: Ferry Meng <mengferry@linux.alibaba.com>
> Reviewed-by: Joseph Qi <joseph.qi@linux.alibaba.com>

This should have had your signed-off-by, as you were on the patch
delivery path.  Documentation/process/submitting-patches.rst,
"Developer's Certificate of Origin 1.1".  I have made that change to
the mm.git copies of these two patches.

