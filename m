Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7178C26E71F;
	Mon, 19 Jan 2026 06:37:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768804642; cv=none; b=clbbVvbQjb/DwxlDmDLre3HPBjYw00RdDRZCCaigrbcNlS38JANYqHWqHPdzo12cUDcKhAVhHfbGnfJ3QhPaImYZiPWp8CIxEl25UAQIXQS6wXJyzw9G8GwetZaBkEBSshEumnicoe0zPhfQrOGhT88LQyuOvH3Jg/+p/cWNqRc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768804642; c=relaxed/simple;
	bh=yr6uKVuCiptnlQroaAFCqju/NCHYFiKAZ0oJYz2Vf70=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=IMk/QHvNj/hiUOrSSfVqOEgmcgdQbayit5wx9MtCfE7QbMvNFguq7PvZMGVoZU3X/vuYXLQCBF/PD2VSjriusfppkkSEzicWvs2jAREOOebfUBUc6eUMPo1nYWKEUBYAT7Pgr4kcGHilB12vNIlBVE6S5hr0cNXH5VuNyG2rKbE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=anoHe/Zz; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="anoHe/Zz"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8AF0CC116C6;
	Mon, 19 Jan 2026 06:37:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1768804641;
	bh=yr6uKVuCiptnlQroaAFCqju/NCHYFiKAZ0oJYz2Vf70=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=anoHe/ZzKZlDbxaxS1TO5UnlHqlaENmgq8PCSXEAYG5IKdsOrDf4N4Ir/ex7SHs03
	 WS5yvz89e4VcNE+7FAtn3z/s/T7TIYgfBHu0b1uQoMfGdpKC5yzCUIX/nk4p84XoOX
	 TGXideqqJvL8JO7zqTSuBFOqkJ1L9EOqXhIr6j+8=
Date: Mon, 19 Jan 2026 07:37:17 +0100
From: Greg KH <gregkh@linuxfoundation.org>
To: Jiasheng Jiang <jiashengjiangcool@gmail.com>
Cc: Mark Fasheh <mark@fasheh.com>, Joel Becker <jlbec@evilplan.org>,
	Joseph Qi <joseph.qi@linux.alibaba.com>,
	linux-kernel@vger.kernel.org, ocfs2-devel@lists.linux.dev,
	stable@vger.kernel.org
Subject: Re: [PATCH] ocfs2: fix potential OOB access in
 ocfs2_adjust_adjacent_records()
Message-ID: <2026011911-baboon-gazing-3e15@gregkh>
References: <20260118192318.44212-1-jiashengjiangcool@gmail.com>
Precedence: bulk
X-Mailing-List: ocfs2-devel@lists.linux.dev
List-Id: <ocfs2-devel.lists.linux.dev>
List-Subscribe: <mailto:ocfs2-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:ocfs2-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260118192318.44212-1-jiashengjiangcool@gmail.com>

On Sun, Jan 18, 2026 at 07:23:18PM +0000, Jiasheng Jiang wrote:
> In ocfs2_adjust_adjacent_records(), the code dereferences
> right_child_el->l_recs[0] without verifying that the extent list
> actually contains any records.
> 
> If right_child_el->l_next_free_rec is 0 (e.g., due to a corrupted
> filesystem image), this results in an out-of-bounds access when
> accessing l_recs[0].e_cpos.
> 
> In contrast, ocfs2_adjust_rightmost_records() explicitly validates
> that l_next_free_rec is non-zero before accessing records.
> 
> This patch adds a check to ensure l_next_free_rec is not zero before
> proceeding. If the list is empty, we log an error and return to avoid
> reading invalid data.
> 
> Fixes: dcd0538ff4e8 ("ocfs2: sparse b-tree support")
> Signed-off-by: Jiasheng Jiang <jiashengjiangcool@gmail.com>
> ---
>  fs/ocfs2/alloc.c | 5 +++++
>  1 file changed, 5 insertions(+)
> 
> diff --git a/fs/ocfs2/alloc.c b/fs/ocfs2/alloc.c
> index 58bf58b68955..bc6f26613e6e 100644
> --- a/fs/ocfs2/alloc.c
> +++ b/fs/ocfs2/alloc.c
> @@ -1974,6 +1974,11 @@ static void ocfs2_adjust_adjacent_records(struct ocfs2_extent_rec *left_rec,
>  {
>  	u32 left_clusters, right_end;
>  
> +	if (le16_to_cpu(right_child_el->l_next_free_rec) == 0) {
> +		mlog(ML_ERROR, "Extent list has no records\n");
> +		return;
> +	}
> +
>  	/*
>  	 * Interior nodes never have holes. Their cpos is the cpos of
>  	 * the leftmost record in their child list. Their cluster
> -- 
> 2.25.1
> 
> 

<formletter>

This is not the correct way to submit patches for inclusion in the
stable kernel tree.  Please read:
    https://www.kernel.org/doc/html/latest/process/stable-kernel-rules.html
for how to do this properly.

</formletter>
