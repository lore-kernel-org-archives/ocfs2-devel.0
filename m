Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8B46B21D591;
	Wed, 12 Aug 2026 02:22:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786501353; cv=none; b=jsBIHunVmY0xnNg0lOIywoGqw4zAULsTf8K0cfWAvC1tIrm6e4Ndilv1Ho/dTuiKZuk4j73y7I/6L2O6CX78HxoVhXwt9vOQ2PEsJKrW9+pKRLhm8SfIYsl6GY/XNcY8tk4u/0wSF3YjAN+u2hViZb1M8iWiulpvAMgtXfhMAME=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786501353; c=relaxed/simple;
	bh=rcecKH6WA8lZK11oJWWr2KBwovhIB373AfQge6FtdGU=;
	h=Date:From:To:Cc:Subject:Message-Id:In-Reply-To:References:
	 Mime-Version:Content-Type; b=edIPAw8syqJwuq0eBkwQ1RGH6895atAWxGnxlG4xHOTRjyStOKY4H+IxCwnMPSRQ3u3vRjDRyo22qUrPg4IsaEXXIPsv9dGlwQechEEgv2phtCH6a0PHL4k4i4rYhlpb0bS9Nspb+CSYHia2JFPDGdi/tsYQs+mosN5zyzjscso=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=tYkPyOZ2; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="tYkPyOZ2"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BA26C1F000E9;
	Wed, 12 Aug 2026 02:22:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1786501352;
	bh=k9r4WDNbRLN8npfeho3BfHvwM2c5YMOe29TzK0O3mxY=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References;
	b=tYkPyOZ2cxd5yMYE083fsaILM5WoP+aSF4fUDbJS6hfcrE8A/jrabfClXPFjo0sJV
	 QwChsTAwUpg8xAJmd7ZYAWKV/c+91lZXgA2eK8Br4RscjvwFNGydCtqQEo0krTGRd1
	 fFCXRmgjVvfsqxwHpUnWHG4GkSJybGv7eaS+YIRs=
Date: Tue, 11 Aug 2026 19:22:31 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Zhan Xusheng <zhanxusheng1024@gmail.com>
Cc: Joseph Qi <joseph.qi@linux.alibaba.com>, Mark Fasheh <mark@fasheh.com>,
 Joel Becker <jlbec@evilplan.org>, Junxiao Bi <junxiao.bi@oracle.com>,
 Changwei Ge <gechangwei@live.cn>, Jun Piao <piaojun@huawei.com>, Heming
 Zhao <heming.zhao@suse.com>, ocfs2-devel@lists.linux.dev,
 linux-kernel@vger.kernel.org, zhanxusheng@xiaomi.com
Subject: Re: [PATCH v2 1/2] ocfs2: bound-check dir entries in the readdir
 re-validation scan
Message-Id: <20260811192231.b0998aaf15f4fe9c8681cfe6@linux-foundation.org>
In-Reply-To: <20260811024337.3972976-2-zhanxusheng@xiaomi.com>
References: <20260811024337.3972976-1-zhanxusheng@xiaomi.com>
	<20260811024337.3972976-2-zhanxusheng@xiaomi.com>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Precedence: bulk
X-Mailing-List: ocfs2-devel@lists.linux.dev
List-Id: <ocfs2-devel.lists.linux.dev>
List-Subscribe: <mailto:ocfs2-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:ocfs2-devel+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Tue, 11 Aug 2026 10:43:36 +0800 Zhan Xusheng <zhanxusheng1024@gmail.com> wrote:

> From: Zhan Xusheng <zhanxusheng1024@gmail.com>
> ...
> Signed-off-by: Zhan Xusheng <zhanxusheng@xiaomi.com>

checkpatch:

WARNING: From:/Signed-off-by: email address mismatch: 'From: Zhan Xusheng <zhanxusheng1024@gmail.com>' != 'Signed-off-by: Zhan Xusheng <zhanxusheng@xiaomi.com>'


This can be prevented by using an explicit From: line at
start-of-changelog.  Please let me know which address should be used
and I'll make the edit, thanks.


