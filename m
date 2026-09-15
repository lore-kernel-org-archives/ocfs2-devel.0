Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B12013E0083;
	Tue, 15 Sep 2026 16:26:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789489565; cv=none; b=H3vSmXmjeIm1zxpg9uaxrHDaM2x3+LE2z4PXAkQqv5NyVY71dtfbcGwDoI/x3J65q+SdChyk/jAhcKlK55MlFTT8o6HYNqsJ+xtb0/OBS98qJakR1m8+jR3Qy+HKu7qvWuzuaUzCBlmfiDJ+gvlVaivcTGuvP/IvHvRx/hWQQxw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789489565; c=relaxed/simple;
	bh=IWZ5r2i9VMZGwcpxwjx8vGKPLpzHbdV65HINqx7pl1E=;
	h=Content-Type:MIME-Version:Message-Id:In-Reply-To:References:
	 Subject:From:To:Cc:Date; b=thOIZiPjEPCYLJ05Qh72YjrhpB9boUSRY+NO8akUfHUihjIpV0LyJvWPedLpdyYDDRNnswphlpwgz1q67soyvYFpG80X2b2j9NGI8jh1bFQ3X1PlzaCxRLadEzNarVo4bpqpA1Tik/ChQi3C16qgE84ZwvGPM0dmaAVtx+wzr7g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Wyuj2nQB; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Wyuj2nQB"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 96A701F000FF;
	Tue, 15 Sep 2026 16:26:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789489564;
	bh=TPfPTU1hTfOkA3Y3cBRAZUUhMVTXtNeqZyk4bvJBbsM=;
	h=In-Reply-To:References:Subject:From:To:Cc:Date;
	b=Wyuj2nQBLvjHCPsJv196FEV0ghYDVMZyMk0QPjktK+nqFJK2e0gqqTAcQHd4Pe1pV
	 5+fB3JB1xOFYcpSI9NHXk0br1ATUh6iOgGbVgN0zvN3VS8tCieIwbACsRyyFcmb3k+
	 CevBWaNfGhefPkXfyyS+KNdxIqVxZ+if03Phx7XFdNs/XRbRoGIpVPY/Gk1a0OYvzK
	 vdUNVn88gTiIxNWOjortB3BU515wg20zzpxF8QNnCHDQhyn3vvtg2q4fsKYULoIVx2
	 1rkm7JYmWo4SA23j8DlHlrDPwZwAqdw1JQl87HdrHcCxJT12KfGUbAMCFX4DUBzP/e
	 RW4MvcMKBWmWg==
Content-Type: multipart/mixed; boundary="===============1551566520676195583=="
Precedence: bulk
X-Mailing-List: ocfs2-devel@lists.linux.dev
List-Id: <ocfs2-devel.lists.linux.dev>
List-Subscribe: <mailto:ocfs2-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:ocfs2-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Message-Id: <c3c3d956a7ee6ac3e08b9e352c6d9d635d188971de79bb9037972a74a910012d@mail.kernel.org>
In-Reply-To: <20260915150739.284189-2-daniel@iogearbox.net>
References: <20260915150739.284189-2-daniel@iogearbox.net>
Subject: Re: [PATCH bpf-next 1/8] ocfs2: Copy the xattr name in ocfs2_initxattrs
From: bot+bpf-ci@kernel.org
To: daniel@iogearbox.net,alexei.starovoitov@gmail.com
Cc: brauner@kernel.org,dwindsor@gmail.com,john.fastabend@gmail.com,memxor@gmail.com,kpsingh@kernel.org,matt@bobrowski.net,bpf@vger.kernel.org,zhanxusheng@xiaomi.com,joseph.qi@linux.alibaba.com,ocfs2-devel@lists.linux.dev,ast@kernel.org,andrii@kernel.org,daniel@iogearbox.net,martin.lau@kernel.org,eddyz87@gmail.com,yonghong.song@linux.dev,mason@kernel.org,ihor.solodrai@linux.dev
Date: Tue, 15 Sep 2026 16:26:03 +0000 (UTC)

--===============1551566520676195583==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit

> ocfs2: Copy the xattr name in ocfs2_initxattrs
>
> ocfs2_mknod() and ocfs2_symlink() ask for the security xattr up front
> through a struct ocfs2_security_xattr_info, so that they can size the
> transaction before setting it. ocfs2_initxattrs() duplicates the value
> since the array security_inode_init_security() hands is freed on return,
> but keeps the name pointer as-is, given so far every LSM stored a string
> constant there. bpf_inode_init_xattr() places the name in the same
> allocation as the value, which security_inode_init_security() frees on
> its way out. Copy the name alongside the value and free both together.
> This is the only special case wrt xattrs in the bpf_inode_init_xattr()
> context.
>
> Signed-off-by: Daniel Borkmann <daniel@iogearbox.net>
> Cc: Zhan Xusheng <zhanxusheng@xiaomi.com>
> Cc: Joseph Qi <joseph.qi@linux.alibaba.com>
> Cc: ocfs2-devel@lists.linux.dev

Should this include:

  Fixes: 9722955b54307 ("bpf: Add simple xattr support to bpffs")


---
AI reviewed your patch. Please fix the bug or email reply why it's not a bug.
See: https://github.com/kernel-patches/vmtest/blob/master/ci/claude/README.md

CI run summary: https://github.com/kernel-patches/bpf/actions/runs/34989961168
--===============1551566520676195583==--
