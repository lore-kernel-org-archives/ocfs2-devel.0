Received: from mail-ej1-f49.google.com (mail-ej1-f49.google.com [209.85.218.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E416BB665
	for <ocfs2-devel@lists.linux.dev>; Tue, 20 Jan 2026 01:46:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.49
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768873591; cv=none; b=Jax3nieU5tUUrW9prLlxQi5VGBwr7+en9yKim5qT+WTWWVeHXwlwcwGWsjIzpJLkzlW18slSPDTUUbah2RAo0MKOXeJNCg1aoP+wb3Np08nZeqbn38i5Ue/Lx3zurRN01MIXAkLKT28hB3/pHvxtlbCkl+1pn6yXrCwja0JYhqs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768873591; c=relaxed/simple;
	bh=NV1XK5DTeNi6LQOVq/T9stq9BnltAFwzjHxGVbsffVk=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=A+asDzOgJMYYzfT3uTgo6d1EwcGh3vJfbCopbsZ/sK/hdXsSUPW53jwnQVnQdGFgZOMANXEIkxFN2dN38ZzJvYRjB991CE/Bc8B/IZ1DHkomJ3BVDDj1xAkwylIeDl3B6qMvDZMnR8L6QGdW5D09DaPWW0Mhr/2hb12gRSS/GFA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=fdkYlCqS; arc=none smtp.client-ip=209.85.218.49
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="fdkYlCqS"
Received: by mail-ej1-f49.google.com with SMTP id a640c23a62f3a-b87d3bdedaaso23789766b.0
        for <ocfs2-devel@lists.linux.dev>; Mon, 19 Jan 2026 17:46:29 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1768873588; x=1769478388; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=MQt1wwCkdomtSo4Fk3c1mzfRLL9lpeMiuEEz/RxHSaI=;
        b=fdkYlCqS9+UVimaK022jK/sdlr3kWRoelOvgWWsBlpDys+7flPFj2GT6D/smRiLzk/
         1Bl1enPnwluk7xDiie0Imuzf7rMPNq8lcTUXT5/lzdDQJMMC3AjJGQC05TaB1h+nZK4g
         cI2sOFOis53WtZHcVG9HNr2zQpDsiABxy0HDQNRJM/c6j2jV8zs2Y/OUiZKiTXSl4ALE
         6BjKeLesKEoYbvJyHNz5cS8LdFceUawM5tOMKr5uP8rtP34vcY9yY/TWsGBKJ0puvUMU
         Djhpqfkg1TE2zcaHmnlULz6/BqTfklBj8e8QYcju0rcmA5dypLpKfFT3BTcEDNFboTL0
         CPjw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1768873588; x=1769478388;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=MQt1wwCkdomtSo4Fk3c1mzfRLL9lpeMiuEEz/RxHSaI=;
        b=tfSkNZkjxwwrNpeCMRzBfcxYaL+yRHMc09/IH1mdw/yNWUBRkDoBp/C8E0P1sH3jy4
         IIvyr6Q0K6pT7Ykvu2ttwW3xillauzY19k4rjasTlKl1QLTVNKaU1jLiTkTsoFlO2mSe
         xgPbUmEub0ECqP7TssvWsAiiWPj/B2dD0or7VRev5yrR+EW/wisBSM8kyvvE449qXCzH
         GrzZHTOC4pWs5/poIld22n8v4cpB7u2+0AwPKr74CCYy9y+GhBUuZZsyFjrPIGmNM9C2
         hZknIOZku0jYRAZAZ0Xg4b1oUXWyHQ+yRqCXOnw8Lt+fVXMFJS5d25By/W2Fo72pTBXZ
         masw==
X-Forwarded-Encrypted: i=1; AJvYcCXRiCZkuAN6te+lKHxYDncQjsNy2RJFgPhxsk7VxgtxDFyTGf9sJfhBauQb565AlNhDcewApH41DkFVmg==@lists.linux.dev
X-Gm-Message-State: AOJu0YwAiMiRwveeskQgI8/sqoKl+cvWPbvUxmNep8ELqeg7Bwn/83Wu
	QRFFAsq3IVfBXRCjpWj4C/vhffUOGrUwvdf1mDLuBK3eiOIStB2gX4QrNfLmzoOF4jw=
X-Gm-Gg: AY/fxX6tynOnwWtBfzdbuOzqvx0JYAougD6jwpAHAgklPAd+6JGL0SfxoDjCSRATBKJ
	bXbtUupAd1nYTx/KZksSDWQDu2U9LS6lKgIG3m7RGVFWqTYQNMk8TDN8+yAoEZpugvCvx2fso2A
	WbW20w8es38Z0lIWRxJeNR+TcyAm39u5Ol0UKgMf4P7f/QOrkOJxUatQrEqxgjRdOg44OZaQQ03
	0d6huRGWS+royy3V8NhAT6Ir/xgaX+BwQYIarRpYXPyNpyWZcs9DNzBnhmyHqv+j6Yyau+1kLKz
	N5SMKcrHVjazTTCrY9nPJ0J5HM/VfCLD/5uHQdYN2/kirpyWObloCmZW47IO1PUfKTeh20Xirc6
	2q/hpoIvlNUy71Zl1T9uS7JEe0qIeAwc6O33fxXuHVtkjAKwuwaUVXqG/TW1wmF+BCJVPzIAOfL
	C/NCtPu4Wndw==
X-Received: by 2002:a17:907:9410:b0:b87:17d1:a98f with SMTP id a640c23a62f3a-b879302dee9mr610870766b.3.1768873588270;
        Mon, 19 Jan 2026 17:46:28 -0800 (PST)
Received: from localhost ([202.127.77.110])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-352733f7ad4sm4972030a91.2.2026.01.19.17.46.27
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 19 Jan 2026 17:46:27 -0800 (PST)
Date: Tue, 20 Jan 2026 09:46:24 +0800
From: Heming Zhao <heming.zhao@suse.com>
To: Jiasheng Jiang <jiashengjiangcool@gmail.com>
Cc: jlbec@evilplan.org, joseph.qi@linux.alibaba.com, 
	linux-kernel@vger.kernel.org, mark@fasheh.com, ocfs2-devel@lists.linux.dev
Subject: Re: [PATCH v2] ocfs2: Fix NULL pointer dereference in
 ocfs2_get_refcount_rec()
Message-ID: <xdoixnwdnplg4zo7zyzkuzaqakc66rsnyqjap4axeevcc3tf7e@rgqnmdhmqsqi>
References: <5bflve5fog7jreyjzn4po47t2wzd6vomsmlkd6km44joogcybl@6vd2h5orgwge>
 <20260119171215.1076-1-jiashengjiangcool@gmail.com>
Precedence: bulk
X-Mailing-List: ocfs2-devel@lists.linux.dev
List-Id: <ocfs2-devel.lists.linux.dev>
List-Subscribe: <mailto:ocfs2-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:ocfs2-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260119171215.1076-1-jiashengjiangcool@gmail.com>

On Mon, Jan 19, 2026 at 05:12:15PM +0000, Jiasheng Jiang wrote:
> On Mon, 19 Jan 2026 22:43:26 +0800, Heming Zhao wrote:
> > On Sun, Jan 18, 2026 at 07:05:23PM +0000, Jiasheng Jiang wrote:
> >> In ocfs2_get_refcount_rec(), the 'rec' pointer is initialized to NULL.
> >> If the extent list is empty (el->l_next_free_rec == 0), the loop skips
> >> assignment, leaving 'rec' as NULL and 'found' as 0.
> >> 
> >> Currently, the code skips the 'if (found)' block but proceeds directly to
> >> dereference 'rec' at line 767 (le64_to_cpu(rec->e_blkno)), causing a
> >> NULL pointer dereference panic.
> > 
> > Do you have reproduction steps to support your analysis?
> > 
> 
> Thanks for your review. We found this issue through static analysis and
> code review. We do not have a specific reproduction script or a corrupted
> filesystem image to trigger this at the moment.
> 
> > there are two types of 'rb': leaf or tree.
> > the check 'if (!(le32_to_cpu(rb->rf_flags) & OCFS2_REFCOUNT_TREE_FL))'
> > handles leaf case and returns to the caller.
> > the subsequent code handles the 'tree' type, therefore, in theory,
> > el->l_next_free_rec should be ">= 1", and the execution should enter the
> > for-loop to assign the 'rec'.
> > 
> > Thanks,
> > Heming
> > 
> 
> You are absolutely correct. Theoretically, if the OCFS2_REFCOUNT_TREE_FL
> flag is set, the extent list should not be empty, and el->l_next_free_rec
> should be >= 1.
> 
> However, if the filesystem metadata is corrupted (e.g., due to bit rot or
> software bugs), it is possible that l_next_free_rec reads as 0 even for a
> tree root. In the current implementation, such inconsistency leads to a
> NULL pointer dereference and panics the system.
> 
> This patch is intended as a hardening measure. Instead of crashing the
> kernel when encountering such invalid on-disk data, it is safer to report
> a filesystem error via ocfs2_error and abort the operation gracefully.
> 
> This approach aligns with recent fixes in OCFS2. For example, Commit
> 44acc46d182f ("ocfs2: avoid NULL pointer dereference in
> dx_dir_lookup_rec()") addressed an identical issue where an empty extent
> list left the 'rec' pointer NULL.
> 
> I will update the commit message in the next version to explicitly state
> that this is a hardening measure against on-disk corruption, ensuring the
> rationale is accurate.

I am quoting the rule from Documentation/process/stable-kernel-rules.rst:

Rules on what kind of patches are accepted, and which ones are not, into the
"-stable" tree:
  ... ...
  - No "This could be a problem..." type of things like a "theoretical race
    condition", unless an explanation of how the bug can be exploited is also
    provided.

This principle applies to your case as well (even though you are targeting
the mainline tree). I don't believe the issues mentioned in these patches
are worth fixing without proof. Please provide reproduction steps for all
your patches before we continue the review.

Thanks,
Heming

> 
> >> 
> >> This patch adds an 'else' branch to the 'if (found)' check. If no valid
> >> record is found, it reports a filesystem error and exits, preventing
> >> the invalid memory access.
> >> 
> >> Fixes: e73a819db9c2 ("ocfs2: Add support for incrementing refcount in the tree.")
> >> Signed-off-by: Jiasheng Jiang <jiashengjiangcool@gmail.com>
> >> ---
> >> Changelog:
> >> 
> >> v1 -> v2:
> >> 
> >> 1. Add a Fixes tag.
> >> ---
> >>  fs/ocfs2/refcounttree.c | 5 +++++
> >>  1 file changed, 5 insertions(+)
> >> 
> >> diff --git a/fs/ocfs2/refcounttree.c b/fs/ocfs2/refcounttree.c
> >> index c92e0ea85bca..464bdd6e0a8e 100644
> >> --- a/fs/ocfs2/refcounttree.c
> >> +++ b/fs/ocfs2/refcounttree.c
> >> @@ -1122,6 +1122,11 @@ static int ocfs2_get_refcount_rec(struct ocfs2_caching_info *ci,
> >>  
> >>  		if (cpos_end < low_cpos + len)
> >>  			len = cpos_end - low_cpos;
> >> +	} else {
> >> +		ret = ocfs2_error(sb, "Refcount tree %llu has no extent record covering cpos %u\n",
> >> +				  (unsigned long long)ocfs2_metadata_cache_owner(ci),
> >> +				  low_cpos);
> >> +		goto out;
> >>  	}
> >>  
> >>  	ret = ocfs2_read_refcount_block(ci, le64_to_cpu(rec->e_blkno),
> >> -- 
> >> 2.25.1
> >> 
> >> 
