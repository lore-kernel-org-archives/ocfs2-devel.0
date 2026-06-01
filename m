Received: from zeniv.linux.org.uk (zeniv.linux.org.uk [62.89.141.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 85A8B30C34A;
	Mon,  1 Jun 2026 18:19:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=62.89.141.173
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780337976; cv=none; b=kDy+OGVacX5XmU1CgtxxNQfH/NRh52hQeox7Ze9tvCN9/MGZx+4N5uaQ/nWyPS3kilkWDqwZKQfavehYqIbTbtlTlstSUudVFeVFmCDRigpEtQsNl/cID1Mx1cmwGMDWhRCiRCRlVyQwlJbLZkvIpetfVwGHinbvp6GpQ/NiXW8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780337976; c=relaxed/simple;
	bh=fqCUwK9S/4Z74ikCozKzPpJRYSUHCkuzeLJ5KSKoHVA=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Q99JPYXQjH8tnDRZFZPdgnnxPhNrRbSsTAghqGzGB8ehP2s0QwIpimqnHaZBgPafqaLmxE4NSCihbwDeSm3zu049BIZLwZnYvsJOkdNQhKxDJkqLla8rHEr/fs5EamXsUY7zbcwW1TlviZ+hVjAt4FPDs8fWk0acRIvvuxdFKk4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=evilplan.org; spf=none smtp.mailfrom=ftp.linux.org.uk; dkim=fail (0-bit key) header.d=infradead.org header.i=@infradead.org header.b=XSCE8hpj reason="key not found in DNS"; arc=none smtp.client-ip=62.89.141.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=evilplan.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=ftp.linux.org.uk
Authentication-Results: smtp.subspace.kernel.org;
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=infradead.org header.i=@infradead.org header.b="XSCE8hpj"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=zeniv-20220401; h=Sender:In-Reply-To:Content-Type:
	MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=hXlUjqTZ08grzxUw4uR6js5w8dxnCvZsu3kcAwCEqsE=; b=XSCE8hpjR04GvNxLvCmdOsjQOS
	ybRxSHwmROjzDEYatZXsoYDoStYqj0SGNHmjXQX4/2ElCzRh7KoHFZWXO3BC09hl6pwpMvUVGhpAg
	hxO3Nvt++YpgLwS0OoqcWATmlHB3bPgoQ0J17KHPXdJnVneYL+ZG+2YrTXosVqP5ROkKxjqIKuyum
	tHb17NY5km7j4kTd/DgRqFostFm/MedBppL3y2h976hjicygeDIPN1jlHPqHEt55E1RFYokXXOr4r
	1PBoe/FabH+WiuUeaj5RU9dvlI8+4L6NoGEufLM/UNDeIeu+RbR9aZ8rrb020U7CS9qwEfExk0AIZ
	Tq2wyPSg==;
Received: from jlbec by zeniv.linux.org.uk with local (Exim 4.99.2 #2 (Red Hat Linux))
	id 1wU7EZ-00000003YKr-0Qm7;
	Mon, 01 Jun 2026 18:19:31 +0000
Date: Mon, 1 Jun 2026 11:19:27 -0700
From: Joel Becker <jlbec@evilplan.org>
To: Michael Bommarito <michael.bommarito@gmail.com>
Cc: Joseph Qi <joseph.qi@linux.alibaba.com>, Mark Fasheh <mark@fasheh.com>,
	ZhengYuan Huang <gality369@gmail.com>, ocfs2-devel@lists.linux.dev,
	linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 1/3] ocfs2: reject dinodes with non-canonical i_mode
 type
Message-ID: <ah3NLyxb8IYiPo2U@google.com>
Mail-Followup-To: Michael Bommarito <michael.bommarito@gmail.com>,
	Joseph Qi <joseph.qi@linux.alibaba.com>,
	Mark Fasheh <mark@fasheh.com>,
	ZhengYuan Huang <gality369@gmail.com>, ocfs2-devel@lists.linux.dev,
	linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20260519110404.1803902-1-michael.bommarito@gmail.com>
 <20260519110404.1803902-2-michael.bommarito@gmail.com>
Precedence: bulk
X-Mailing-List: ocfs2-devel@lists.linux.dev
List-Id: <ocfs2-devel.lists.linux.dev>
List-Subscribe: <mailto:ocfs2-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:ocfs2-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260519110404.1803902-2-michael.bommarito@gmail.com>
X-Burt-Line: Trees are cool.
X-Red-Smith: Ninety feet between bases is perhaps as close as man has ever
 come to perfection.
Sender: Joel Becker <jlbec@ftp.linux.org.uk>

On Tue, May 19, 2026 at 07:04:02AM -0400, Michael Bommarito wrote:
> ocfs2_validate_inode_block() currently accepts any non-zero i_mode value.
> ocfs2_populate_inode() then copies that mode verbatim into inode->i_mode
> and dispatches on i_mode & S_IFMT to the file/dir/symlink/special_file
> iops; an unrecognised type falls through to ocfs2_special_file_iops and
> init_special_inode().
> 
> Reject dinodes whose type bits do not name one of the seven canonical
> POSIX file types.  Use fs_umode_to_ftype(), the same generic file-type
> conversion helper OCFS2 already uses for directory entries, so the
> accepted inode type set matches the kernel file-type vocabulary instead
> of open-coding a local switch.
> 
> Apply the same structural check to the online filecheck read path.
> filecheck keeps its own error namespace, so it reports malformed i_mode
> through the filecheck logger and OCFS2_FILECHECK_ERR_INVALIDINO instead
> of calling ocfs2_error(), but it must not allow a malformed dinode to
> proceed into ocfs2_populate_inode().
> 
> Fixes: b657c95c1108 ("ocfs2: Wrap inode block reads in a dedicated function.")
> Cc: stable@vger.kernel.org
> Link: https://sashiko.dev/#/patchset/20260517111015.3187935-1-michael.bommarito%40gmail.com
> Signed-off-by: Michael Bommarito <michael.bommarito@gmail.com>
> Assisted-by: Claude:claude-opus-4-7

Reviewed-by: Joel Becker <jlbec@evilplan.org>

Side question: What "Assistance" did Claude provide?  Was the snippet
generated entirely by prompt?  No objection, just curious about the
workflow you're using.

Thanks,
Joel

-- 

"Born under a bad sign.
 I been down since I began to crawl.
 If it wasn't for bad luck,
 I wouldn't have no luck at all."

			http://www.jlbec.org/
			jlbec@evilplan.org
