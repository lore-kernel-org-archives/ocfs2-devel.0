Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793776342;
	b=smYgtGWe+kknpnLIYO32mMuwUlMq1M/QePMS3FCqjawFo2DhDyeFr/7iL0qlPtUtN3Nc
	 CsRZ2rbeKbIAoPQhHSFJdnQQse7mmS8lfvjD3hWlvzT0MfKeTx5AF40sv17mI4uOmyRXM
	 uHMtnqqabcpzm4k0V2MZGPROPbzBlDPG3qfz21tw5AFUi6oyRwuHkUjtpQcFAJnnSa66w
	 GTI6yGKr/FXCKSRIvVYqi3wxQPhNK+rKjL6fnBDS+csMc37JQXC0B6G7L3Fvsfgh5ivvc
	 EdRBRcXVw6pnEOntgYOCaEroJPoFGtsy8OCsvVlB0dh+AJtLx5PQRThw0Uc/+4nzgKw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793776342;
	h=Received:DKIM-Signature:Date:From:To:Cc:Subject:Message-ID:
	 References:MIME-Version:Content-Type:Content-Disposition:In-Reply-To;
	bh=F2tsUnoCbF4C0jFcyr7I+SzH2RbDwhL0YBPHuEA2uXY=;
	b=u4JUaI4/7BY1GUvBFT+IY3BTWRKVFhtYz2j3EQZ5oG1ZR9PC48Jl9jvuUHFhI2sjjgnn
	 FmDlenZ/MQ3YfKrVyv7dY5ZYaiT/OJMDxMAfO6I+plxtbiiy40cIdHwl1OmHl+dOaWcgS
	 bVv9X2xPpN7D9Eqjx5jMNs7nWmmPm+ghL1gzpKPqnDkJOOqvPlV/YEKEdKxuNfxdyD14s
	 ix2nT0cSFirITxwofqDpdHOwekdjdC1zcOEhUp21enXCTJqN1sirL44BjnkQ3TqK3J0qM
	 irhrTysNB0ds7pZkcW6puM/EWpz2PrN57/3yM+ptqrOP/KZctjsrTqz2x5T6NYLpczQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=oAdfy7LJ;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9BAE9606A326
	for <ocfs2-devel@lists.linux.dev>; Wed,  4 Nov 2026 07:12:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=oAdfy7LJ
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 798E11F000C1;
	Wed,  4 Nov 2026 07:12:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793776342;
	bh=F2tsUnoCbF4C0jFcyr7I+SzH2RbDwhL0YBPHuEA2uXY=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=oAdfy7LJgqq7B+FFSdEORic2AuACoY3wLdgtVOVDSdTIuOCx3s+e4mY+bUxKaE+NL
	 fr8R8DLi/5NRc0bXUhzgQ1wEHyh8GVejK2NofWYJx8zQs5lQagT99jCJovEnmbCokl
	 nnUDl73MZqoIZpjDIB2Esl/+W/LSsaLIbY6yGv+g03ySDY+ql3FpyuuhEjhuVJaxkS
	 X9eaKSG1iOzQHfsVKXzChFSPB8Vdcnww/S4awvi8b2owafnYTkvlHXEZP06BVT6sH9
	 b0EY4qV3YypXOFV5SfpYUzVdqxDl5LPQEGWs5A8yxqu7mwoJD4gHmW9i5u07FvvAq9
	 K76b2SZzyO4VQ==
Date: Wed, 4 Nov 2026 08:12:19 +0100
From: Krzysztof Kozlowski <krzk@kernel.org>
To: Wentao Liang <vulab@iscas.ac.cn>
Cc: Heming Zhao <heming.zhao@suse.com>, Mark Fasheh <mark@fasheh.com>, 
	Joel Becker <jlbec@evilplan.org>, ocfs2-devel@lists.linux.dev, 
	Joseph Qi <joseph.qi@linux.alibaba.com>
Subject: Re: [PATCH] ocfs2: put the new lock when recovery data has a
 duplicate
Message-ID: <20261104-fuzzy-lively-bobcat-fab4a2@quoll>
References: <20261104022805.1484045-1-vulab@iscas.ac.cn>
X-Mailing-List: ocfs2-devel@lists.linux.dev
List-Id: <ocfs2-devel.lists.linux.dev>
List-Post: <mailto:ocfs2-devel@lists.linux.dev>
List-Help: <mailto:ocfs2-devel+help@lists.linux.dev>
List-Subscribe: <mailto:ocfs2-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:ocfs2-devel+unsubscribe@lists.linux.dev>
List-Owner: <mailto:ocfs2-devel+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20261104022805.1484045-1-vulab@iscas.ac.cn>


On Wed, 04 Nov 2026 02:28:05 +0000, Wentao Liang wrote:
> dlm_process_recovery_data() allocates a new dlm_lock for every lock
> carried in the recovery message.  When the cookie is already present on
> the target queue the entry is only marked bad, so the lock returned by
> dlm_new_lock() keeps its initial reference and never reaches a queue
> that would later release it.  The lockres reference taken by
> dlm_lock_attach_lockres() leaks with it.
> 
> Drop the reference on that path so a duplicate entry cannot pin the lock
> and its lockres.
> 
> Fixes: c3187ce5e335 ("ocfs2: only recover one dead node at a time")
> Cc: stable@vger.kernel.org
> Assisted-by: DeepSeek-V4.1-Flash and OpenAI Codex
> Signed-off-by: Wentao Liang <vulab@iscas.ac.cn>
> ---
>  fs/ocfs2/dlm/dlmrecovery.c | 3 +++
>  1 file changed, 3 insertions(+)
> 

Multiple things here:
1. Your team ignored completely previous feedback. Multiple times.

2. You use multiple identities with this email address, thus I doubt that we
   speak with an actual person.

3. Your bot does not even bother running checkpatch, right?

4. Nothing of this was reproduced nor tested.

5. Finally, the same feedback:
You sent multiple independent patches, to multiple independent
subsystems. The amount of these patches clearly suggest this was
AI generated and most likely not tested.

More importantly, you sent all this work without properly organizing
relevant patches into patchsets. This makes reviewing difficult
and might cause multiple reviewers to address the same issue.
Replying to the entire set is impossible and requires handling each
patch independently, instead of applying or discarding the set.
Maintainers also won't see the bigger picture of your work. Quite
worrying.

This is on the verge of hostile patch: bomb us with so many
contributions, we won't be able to handle them in efficient manner,
like responding ONCE to ask you to slow down.  Considering all this
is untested and LLM generated, I have even more doubts whether this
should be considered for review.

Please read kernel documentation BEFORE posting more work. It will
explain you how to identify subsystems, how to organize your work per
subsystem (so a patchset grouping multiple patches with a short cover
letter), how to document the issue discovery method and what was
or was not tested.

Best regards,
Krzysztof




