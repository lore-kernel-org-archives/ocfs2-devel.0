Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C723A227EA8;
	Mon, 19 Jan 2026 06:37:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768804654; cv=none; b=kCllrfk/4EYukioRM94Ov+A1oywaKqZicHK5Ctlyc11MS1mpP2oLf4aEKomj74v6aT5CWOYvTrRJ7js/S5MdVsnvvoL6fNsjdXvSBNHPYTyEFobPlnBT/BXfh7OMr2VuAdaHbVMuMIWNtyepIiu9ht8npzCS92WkQO5U0Ekd0LY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768804654; c=relaxed/simple;
	bh=AhJjdOzGJVH0pvW8yjDK8PE7lWTgqcB62z0r7UIwp8g=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=ilq+gCRoYAx/DHzCX9JJqO9KqUN3lPfDx51DdkdmUHiD5ZOKeYyHNnd9zQ5EeAMwYoStE3pOpF9FDBz6tMhuXnHmEkq+rPHDHWislIPPcsZ1YPr3ZrsW6mGQXvsdOxkQojoyHQr4lW33FnZr4/ubGSbP4zO8/o6XTD3zk4maEN0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=CK1lSM0v; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="CK1lSM0v"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2240BC116C6;
	Mon, 19 Jan 2026 06:37:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1768804654;
	bh=AhJjdOzGJVH0pvW8yjDK8PE7lWTgqcB62z0r7UIwp8g=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=CK1lSM0vzrt9HFWrd9Tn2gZ6DPYFWopypbuohFyrfc+54Buf/6H83m23A6fS+zOfY
	 Kv6/MjTKjiSyMmHsUIWXeIzahS8GgsFpH45iIjkFa5kKS5/Z7H6R1E0x5faofvZw+n
	 N5te5PlKph3fGb8C5zRJmAYYEy0trL364EDgHI5g=
Date: Mon, 19 Jan 2026 07:37:29 +0100
From: Greg KH <gregkh@linuxfoundation.org>
To: Jiasheng Jiang <jiashengjiangcool@gmail.com>
Cc: markus.elfring@web.de, jlbec@evilplan.org, joseph.qi@linux.alibaba.com,
	linux-kernel@vger.kernel.org, mark@fasheh.com,
	ocfs2-devel@lists.linux.dev, stable@vger.kernel.org
Subject: Re: [PATCH v2] ocfs2: fix NULL pointer dereference in
 ocfs2_get_refcount_rec
Message-ID: <2026011925-canon-helium-65c6@gregkh>
References: <cfd0e0eb-894e-48c7-948e-9300a19b9db7@web.de>
 <20260118190523.42581-1-jiashengjiangcool@gmail.com>
Precedence: bulk
X-Mailing-List: ocfs2-devel@lists.linux.dev
List-Id: <ocfs2-devel.lists.linux.dev>
List-Subscribe: <mailto:ocfs2-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:ocfs2-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260118190523.42581-1-jiashengjiangcool@gmail.com>

On Sun, Jan 18, 2026 at 07:05:23PM +0000, Jiasheng Jiang wrote:
> In ocfs2_get_refcount_rec(), the 'rec' pointer is initialized to NULL.
> If the extent list is empty (el->l_next_free_rec == 0), the loop skips
> assignment, leaving 'rec' as NULL and 'found' as 0.
> 
> Currently, the code skips the 'if (found)' block but proceeds directly to
> dereference 'rec' at line 767 (le64_to_cpu(rec->e_blkno)), causing a
> NULL pointer dereference panic.
> 
> This patch adds an 'else' branch to the 'if (found)' check. If no valid
> record is found, it reports a filesystem error and exits, preventing
> the invalid memory access.
> 
> Fixes: e73a819db9c2 ("ocfs2: Add support for incrementing refcount in the tree.")
> Signed-off-by: Jiasheng Jiang <jiashengjiangcool@gmail.com>
> ---
> Changelog:
> 
> v1 -> v2:
> 
> 1. Add a Fixes tag.
> ---
>  fs/ocfs2/refcounttree.c | 5 +++++
>  1 file changed, 5 insertions(+)
> 
> diff --git a/fs/ocfs2/refcounttree.c b/fs/ocfs2/refcounttree.c
> index c92e0ea85bca..464bdd6e0a8e 100644
> --- a/fs/ocfs2/refcounttree.c
> +++ b/fs/ocfs2/refcounttree.c
> @@ -1122,6 +1122,11 @@ static int ocfs2_get_refcount_rec(struct ocfs2_caching_info *ci,
>  
>  		if (cpos_end < low_cpos + len)
>  			len = cpos_end - low_cpos;
> +	} else {
> +		ret = ocfs2_error(sb, "Refcount tree %llu has no extent record covering cpos %u\n",
> +				  (unsigned long long)ocfs2_metadata_cache_owner(ci),
> +				  low_cpos);
> +		goto out;
>  	}
>  
>  	ret = ocfs2_read_refcount_block(ci, le64_to_cpu(rec->e_blkno),
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
