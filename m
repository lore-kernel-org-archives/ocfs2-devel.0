Received: from mail-ej2-f12.google.com (mail-ej2-f12.google.com [74.125.228.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5A30F31DD97
	for <ocfs2-devel@lists.linux.dev>; Tue, 15 Sep 2026 07:42:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.228.140
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789458137; cv=none; b=RFwSw0E0p9JpbK3J7WC+qwkrthsLE5m093E90YK0Q9Jnp96X+eedodMh0MgITdhwcG6KVChc6Sq21WdYKvo/X226F412cYpeMGrXpn9D1/r47OTe8k2ju5/DA0yrryGpNAg6QA9KX95AqVhzBkXgZEjqepCroPCBr6dq3BSsTSo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789458137; c=relaxed/simple;
	bh=euDljarMEFR51LJrQNTgr1IkoseD2wP5+hJmPeGJY9Q=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=iesN8mKmYUgDWrky+Fl77rqkPznLuk4QZpt9THhN8UJAE1bbY3e1Nx2Pl+l9a4tlWsNF3b2NMhivGWxp2OhxPf1JidVfmqzWF2lIzEuya4S4FntimYyG+FyKDsc34Xbr/QXNXpIyCW3acIqN7ICBdf0rgAfBZZTq/ZZg77Sur34=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=I+NVpoNR; arc=none smtp.client-ip=74.125.228.140
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="I+NVpoNR"
Received: by mail-ej2-f12.google.com with SMTP id a640c23a62f3a-c29573ad296so38086266b.1
        for <ocfs2-devel@lists.linux.dev>; Tue, 15 Sep 2026 00:42:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1789458133; x=1790062933; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=Ipaw+WO/xNUFlEuRlZi+JSTZ4mX5i8rU52Vkj/j9Kcw=;
        b=I+NVpoNR4YZJPgqciT5pg7YtAqPChewTPDcFgdXBStniPuZ5szyAOZYXKmsmB4M91P
         6aVneZSq7Y5zBjWpLeNC+/YVi3Bv7+fFG2ToPK+baE9MbKDfU6lHVDzs9hDOfNfeQh8T
         9h72+O+gAqUzOlluBKN+QEHELwBOndDDs1AfxF9C7qpezYhH5EoEQ104SzMCmvcs5f55
         1pF6Xw8n8hFJQMWARNbiCR0XoRo2LDk9rOINjiAV1AYYq8X0OWGXqeUd7rac7KYEOB9R
         CwzeGrNzQHyxKDUswj2TqoCewMJuIoU1fw6cK7bJeFhMDSqOPVjCxWzAnk5P/Qzzak67
         exXQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1789458133; x=1790062933;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=Ipaw+WO/xNUFlEuRlZi+JSTZ4mX5i8rU52Vkj/j9Kcw=;
        b=NlgjZpCTBkuNRsCz6kkAQI7kYs1+OwG1Dsa0bLQj2YuDjePWR7zK5Ky5zCjBbCeCtT
         e/1D6Az/bDvDwR/XjNX3ZUNuGDk40i1pRPwgd1eY8gPEDvx9Rocg2DqRk8YyKE+L33PN
         q3E81+tPJXYw644gVtUdKCmWa6xGP1HX6ybEsggDImdF1FWLNfrN9iWYsjGWYf4bmUNT
         E8tR4Txuxy+HH5V7Am3aX33StAmmkCgiN/7ok4IuBjp9SynukXD+tJPYkMm9oq++zlRS
         OuWSfbrhMkh/gJAwYDmRFxje4ahtT97s+bTYkR7nhfqbVTAl1vyL9BjbMvAVXm0Z0oy5
         VCPw==
X-Gm-Message-State: AFuF++kPcjucYsZw1SA7yhy6jMCzZn31j0X8Pj34qK8uoEjyu2WHTqTl
	BYqxLr9lHK9Zv4Fp1ojWbZVsj+Ke3VQl7VKn1/J30f9JrPqsyUjPTVzba8XKG7PdfYg=
X-Gm-Gg: AYBFou04ChgK9JF1YFqS/y6LZc7CMiIIfHiM6KmjU9bNO+tqNm2KuYWo2g0yhNXqZBA
	8IvJo4qA7nMOcl967kaoTTzo1VGqyw+tbTBIgFAPhbcpHzbBFwzDl8exxa8cdfRwssGaAhaUo3W
	LyKa/0xW0Ds4aguEtJcTJfYtUPKnxmvPr6ay6pd3i3JpdvqlyebRwpRswRl5i3k0jo+Sv0fQmZu
	G/ObuxyfGTsN7caPokdbOuRfeFp865QPxzCgzE/sJD0PIqxnGKJZ2YWvbM9yU28n0BkcwC8nrNg
	N4baq1xO4eFEMSxo2Yb0o/3JXYyhJQan7N5UHB+UvxfwrqofLpbgNr0NNFPQcFWhNmZvbkjg25Y
	hK49vOHyChHT9DeJqLmBs4oJogktVcC2a2lsju4oWIzONnfEPhTxMgjRQ9fe/1mFEM0tDGYl75Q
	W6BrfYJVu70X7N00nYeMbCxbTelNOdxmeuhCK2SUQ1jAQBDiNuJE7PNzXe8urQoXdvV9fNuA==
X-Received: by 2002:a17:907:c649:20b0:c29:cfce:1933 with SMTP id a640c23a62f3a-c29cfce2ecdmr58211066b.2.1789458133357;
        Tue, 15 Sep 2026 00:42:13 -0700 (PDT)
Received: from localhost ([202.127.77.110])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-86b250c1443sm5818215b3a.4.2026.09.15.00.42.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 15 Sep 2026 00:42:12 -0700 (PDT)
Date: Tue, 15 Sep 2026 15:42:08 +0800
From: Heming Zhao <heming.zhao@suse.com>
To: Su Yue <glass.su@suse.com>, joseph.qi@linux.alibaba.com
Cc: ocfs2-devel@lists.linux.dev
Subject: Re: [PATCH] ocfs2: update xattr count before moving bucket entries
Message-ID: <aqj05U-1FXW3293I@p15>
References: <20260915041633.93575-1-glass.su@suse.com>
Precedence: bulk
X-Mailing-List: ocfs2-devel@lists.linux.dev
List-Id: <ocfs2-devel.lists.linux.dev>
List-Subscribe: <mailto:ocfs2-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:ocfs2-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260915041633.93575-1-glass.su@suse.com>

On Tue, Sep 15, 2026 at 12:16:33PM +0800, Su Yue wrote:
> The xh_entries array is annotated with __counted_by_le(xh_count), so
> FORTIFY uses xh_count to determine its bounds. When inserting an entry
> into a bucket, ocfs2_xa_bucket_add_entry() shifts existing entries before
> incrementing xh_count. The destination therefore extends one entry past
> the bounds described by the old count.
> 
> With CONFIG_CC_HAS_COUNTED_BY and CONFIG_FORTIFY_SOURCE enabled,
> ocfs2-test: single_run-WIP.sh -t reflink triggers the following failure while
> adding an extended attribute:
> 
> [  150.156484] memmove: detected buffer overflow: 352 byte write of buffer size 336
> [  150.156487] WARNING: lib/string_helpers.c:1036 at __fortify_report+0x3d/0x50, CPU#15: reflink_test/2336
> [  150.160496] RIP: 0010:__fortify_report+0x40/0x50
> [  150.164031] Call Trace:
> [  150.164141]  <TASK>
> [  150.164232]  __fortify_panic+0x9/0xb
> [  150.164383]  ocfs2_xa_bucket_add_entry.cold+0x17/0x28 [ocfs2]
> [  150.164661]  ocfs2_xa_set+0x8fb/0xf40 [ocfs2]
> 
> Increment xh_count before memmove() so the destination bounds include
> the new entry. Keep the local count unchanged to calculate the insertion
> position and move length from the original number of entries. The caller
> has already checked that there is enough space for the new entry.
> 
> Fixes: 2f26f58df041b ("ocfs2: annotate flexible array members with __counted_by_le()")

The code looks good to me. Just one note:
commit 2f26f58df041b introduced stricter bounds checking rather than fixing a bug.
This reference should go into the commit log instead of a Fixes tag.

Thanks,
Heming
> Signed-off-by: Su Yue <glass.su@suse.com>
> ---
>  fs/ocfs2/xattr.c | 7 ++++++-
>  1 file changed, 6 insertions(+), 1 deletion(-)
> 
> diff --git a/fs/ocfs2/xattr.c b/fs/ocfs2/xattr.c
> index 35bcbb0ff607b..49d82ea5a1271 100644
> --- a/fs/ocfs2/xattr.c
> +++ b/fs/ocfs2/xattr.c
> @@ -2076,12 +2076,17 @@ static void ocfs2_xa_bucket_add_entry(struct ocfs2_xa_loc *loc, u32 name_hash)
>  		}
>  	}
>  
> +	/*
> +	 * Increment xh_count before memmove() so __counted_by_le(xh_count)
> +	 * includes the new entry in the destination bounds.
> +	 */
> +	le16_add_cpu(&xh->xh_count, 1);
> +
>  	if (low != count)
>  		memmove(&xh->xh_entries[low + 1],
>  			&xh->xh_entries[low],
>  			((count - low) * sizeof(struct ocfs2_xattr_entry)));
>  
> -	le16_add_cpu(&xh->xh_count, 1);
>  	loc->xl_entry = &xh->xh_entries[low];
>  	memset(loc->xl_entry, 0, sizeof(struct ocfs2_xattr_entry));
>  }
> -- 
> 2.55.0
> 
