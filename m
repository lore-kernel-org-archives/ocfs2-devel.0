Received: from zeniv.linux.org.uk (zeniv.linux.org.uk [62.89.141.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 29A951C860A;
	Thu,  7 Aug 2025 19:23:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=62.89.141.173
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1754594645; cv=none; b=cdoY6AVf+/dkHKC6CwmWf0O5ITVCNXCCeOm3vt/evjUDHiUbucbzMOjtCnZ04497DCYb7gRwe7sD8SazdJrVOHGLNGgqpaeoYigzJexkv09bYm390VuEuEWxFfyOiOK6SwDtOu7lwM+Qa1W5fNqBbt6tODqM8NMrz7f1eHQqUKs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1754594645; c=relaxed/simple;
	bh=9jSjr+EURfU5xfxNvcaPXMxpgN/NZuM4BFqn0flPaZs=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=kYSvylHx8WJ2Oez1S+9wBRpq+bTMn22J5m6tqKae+9voBbo2fn2u+xhaNpf5n4GvrSQB2sprbthkizecIbcHjxM53h7oOIidS0mGUJBIPHm0f4BwHoXdZLHpgLNf4/GCE5Ynsa+avoUufAKX6M4zMhvNe7JifkG+xNoHbphqcsI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=evilplan.org; spf=none smtp.mailfrom=ftp.linux.org.uk; dkim=fail (0-bit key) header.d=infradead.org header.i=@infradead.org header.b=fuorNKpl reason="key not found in DNS"; arc=none smtp.client-ip=62.89.141.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=evilplan.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=ftp.linux.org.uk
Authentication-Results: smtp.subspace.kernel.org;
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=infradead.org header.i=@infradead.org header.b="fuorNKpl"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=zeniv-20220401; h=Sender:In-Reply-To:Content-Type:
	MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=Skjp0sBpmtDbsb/1j6FQvMUsRdB+FKZ6YT6MzZJmPPA=; b=fuorNKplXxA/NCLxvJcR/K2XY8
	B4kyxLsLQ7bLwKiHe5Pj6ykHrIrYu4ez8wSUuQSGQaE8E33qky5kkRt2S6Lsu8z54ONm78KDJc/4s
	47EOHiLztuivpi8VRVcRUVClq0KraaOb6h1nqt9yxex+K1f8UOlx2iCxfqsH3+lCD3hEfphZWa8mY
	rlhK2+o5k1U8ROFADLIn7LwAZWSbpFtNXbs2xHUqf7b74V7mAezoMOpnVKIaTTZ3BW+3REQNJp+OI
	be3ohtQJeNcZ+2Ng7P2jth4xTlHXsWsDyhkulMJwLTnlXstssxP++waYgFW+o8LCFwKWZEFn1OiPG
	Y/7KN8pQ==;
Received: from jlbec by zeniv.linux.org.uk with local (Exim 4.98.2 #2 (Red Hat Linux))
	id 1uk6DS-00000007los-22rE;
	Thu, 07 Aug 2025 19:23:54 +0000
Date: Thu, 7 Aug 2025 12:23:50 -0700
From: Joel Becker <jlbec@evilplan.org>
To: yili <yili@winhong.com>
Cc: joseph.qi@linux.alibaba.com, mark@fasheh.com,
	ocfs2-devel@lists.linux.dev, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] ocfs2: Fix super block reserved field offset comment
Message-ID: <aJT9RpG19PWIcLe-@google.com>
Mail-Followup-To: yili <yili@winhong.com>, joseph.qi@linux.alibaba.com,
	mark@fasheh.com, ocfs2-devel@lists.linux.dev,
	linux-kernel@vger.kernel.org
References: <20250807155749.164481-1-yili@winhong.com>
Precedence: bulk
X-Mailing-List: ocfs2-devel@lists.linux.dev
List-Id: <ocfs2-devel.lists.linux.dev>
List-Subscribe: <mailto:ocfs2-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:ocfs2-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250807155749.164481-1-yili@winhong.com>
X-Burt-Line: Trees are cool.
X-Red-Smith: Ninety feet between bases is perhaps as close as man has ever
 come to perfection.
Sender: Joel Becker <jlbec@ftp.linux.org.uk>

Yep.  And 140 - (sizeof(s_reserved2) aka 8 * F) = C8.

Reviewed-by: Joel Becker <jlbec@evilplan.org>

On Thu, Aug 07, 2025 at 11:57:49PM +0800, yili wrote:
> The offset annotation for s_reserved2 in struct ocfs2_super_block
> was incorrect. After the preceding fields:
> - s_xattr_inline_size (2 bytes at 0xB8)
> - s_reserved0 (2 bytes at 0xBA)
> - s_dx_seed[3] (12 bytes at 0xBC)
> 
> The actual offset of s_reserved2 is at 0xC8,
> when calculating from the start of the structure.
> 
> Correct the offset comment from C0 to C8 to reflect the proper
> location in the super block structure.
> 
> Signed-off-by: yili <yili@winhong.com>
> ---
>  fs/ocfs2/ocfs2_fs.h | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/fs/ocfs2/ocfs2_fs.h b/fs/ocfs2/ocfs2_fs.h
> index e8e94599e907..ae0e44e5f2ad 100644
> --- a/fs/ocfs2/ocfs2_fs.h
> +++ b/fs/ocfs2/ocfs2_fs.h
> @@ -614,7 +614,7 @@ struct ocfs2_super_block {
>  	__le16 s_reserved0;
>  	__le32 s_dx_seed[3];		/* seed[0-2] for dx dir hash.
>  					 * s_uuid_hash serves as seed[3]. */
> -/*C0*/  __le64 s_reserved2[15];		/* Fill out superblock */
> +/*C8*/  __le64 s_reserved2[15];		/* Fill out superblock */
>  /*140*/
>  
>  	/*
> -- 
> 2.43.0
> 

-- 

Life's Little Instruction Book #15

	"Own a great stereo system."

			http://www.jlbec.org/
			jlbec@evilplan.org
