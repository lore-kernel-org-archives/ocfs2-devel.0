Received: from mail-ed2-f12.google.com (mail-ed2-f12.google.com [74.125.228.76])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 837A719644B
	for <ocfs2-devel@lists.linux.dev>; Wed, 16 Sep 2026 03:15:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.228.76
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789528549; cv=none; b=KeD9JQOZU6O2OqrwITUtKzPPyrmlh0CVxdJ0UjeRwQ2ES8FNsiTGGlOHC+m+r2ZXVqzhNdJFMkhNVE+GHccRUFT3xO2xCOhYy/7nhl/dg9HMbgERUMUpjl2p1x//C1pfW5oXUqK1XbzYl/5gyh35ZOmybbHK694Q4OvbydIhgXQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789528549; c=relaxed/simple;
	bh=2DMTHqNo/YrBjlOPs9L4DlYZblEow21QBXS/VCk+PAA=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=tOPphXfJxozvdSib2azznUAc8oIc83CzwVmX5WiSU7gj28nrf7L0MgqB7L/TiZKOWsKM8dULQpKV4rzLVFsYF5QGmB2ATmWwqNmiIy7zJA5CfcfPZ/r9EamDmXADZiK6e4DPphJH/mHuWmY0QGZ1C2289E8j5el//nBazg79vIE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=g8b9FnUu; arc=none smtp.client-ip=74.125.228.76
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="g8b9FnUu"
Received: by mail-ed2-f12.google.com with SMTP id 4fb4d7f45d1cf-6a9c0e04b34so91996a12.0
        for <ocfs2-devel@lists.linux.dev>; Tue, 15 Sep 2026 20:15:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1789528546; x=1790133346; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=FcPj6UypMhtVmJS8EzkJC494UUpd0cHMVw0El/Mb7fw=;
        b=g8b9FnUuweb5PGptC3XHm2XpmAJB+XaOpuuc4u4G2TeQIpTCcsuDhXV5JbaauC1UHK
         IOx+ojPrbMUnsW7clSvF+2qWSgB5oYxp9ZZ13gCRRXzH9PjGItz3FOwXhObRytIaKlUj
         kuPtLn7gtWjmCeGDoNCAI3Ze64WjBCw4ZPG8tZoBe/AEe7VxthRWF5KZd6TrQynJWiyU
         Uh/bqvnzkwKEH4onwj4HcFscardHaTPYoHMRrKb4SEEWOtkYFq24wVlRMyvkc1t2/6Q8
         LEyHua7wCEffXD1tvkzm1yoryWRcbCLwLEn9DrgF/WPoaJKWqTurNwmkCEynRcRWiyye
         cVQA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1789528546; x=1790133346;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=FcPj6UypMhtVmJS8EzkJC494UUpd0cHMVw0El/Mb7fw=;
        b=ua9gW8s4bW41fJmdG0Ndp7uPwNnpBrA0qLvWZQShnGXcyZJbstW3wxkhREIisjQzLr
         HSlLtp/hHRCjV/r/72YfsXFGYE19reQXlXgYg9gSJ1WUsR5mqwqNrLLMpWV2HUn3l/hn
         5x7Spw7jVdTINEZTZc90keoga51mwP58S+HT+PzWKwPo5aVnZhKJCsj759u8EAVt5mzf
         0AfWdSzZzHewlS6i/H4XxTMFyjztIjGxESK1CN6jCYLRohum7dz73XBn5MNyOYv/PAt4
         c6KtUvJKxUcbnw9fQyFZYcPCo1fMrQqCjiF/j+5hX8xivTAOvc+2kWmdyNU/jltJ4KoO
         9xXA==
X-Gm-Message-State: AFuF++kWO0znhGVzM141vu800yVrVlyjwO7LnhibsDQWcyD+RCF1qY+w
	1es8xopyypG0C21PaTumaJ3zpVIj+0qGSVQv21+i7yHciM1tObtbhwJb9OU5d7opGf82dPS6Y1g
	fhg58faGJWg==
X-Gm-Gg: AYBFou0BOfM1UE1Vg7mn098sUl3emSQHDpIhDFU9hV2RjF1wzWtnQ20Gz0ZZAzxU2lj
	ZmYcpf8MUXY3fK6zzuwGknYG0dJFi1hQBRCcoLrMlaRYRUoeIz1BcQs9rM0A9/y1Q7GPCDZIrdM
	RKxtBZxbip7x9ohaQ+1ZwEqxiJss3Y5C/TDqS6vUR5XqRJcFBPjzey6R74u1m6YYLzE1mxeaYS1
	Bz0dqJ2JF6lDb72SmVfiU2P6JZXhp8chUWrQ3feRubePh/OE8WebkXqRZoAtzShOzjcyd4Bf0iu
	YzNUuPPqvTv1cVA9xvGD3K8BGIx2YTcRvBXKQw9WbArf8zNFiU+9WNARtBypCv5edQfuNXa2Vuh
	2E2v23BZ3EEWGVRXCCEoVDCypCT/mZVkqoougzOEY+WZFgBxa1Yq/+Av3/YEgAVwrb6+GlqOBoV
	b579eH/C9wiPT5PE30eaDEu3skxS66EXzbdY/GQZeOPiEswxDB8jXRZGCdh2YlajxHP4iHVA==
X-Received: by 2002:a05:6402:5d4:b0:6aa:12e8:13a0 with SMTP id 4fb4d7f45d1cf-6aa22241932mr553545a12.1.1789528545670;
        Tue, 15 Sep 2026 20:15:45 -0700 (PDT)
Received: from localhost ([202.127.77.110])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-87201d1da2fsm430140b3a.52.2026.09.15.20.15.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 15 Sep 2026 20:15:44 -0700 (PDT)
Date: Wed, 16 Sep 2026 11:15:41 +0800
From: Heming Zhao <heming.zhao@suse.com>
To: Su Yue <glass.su@suse.com>
Cc: ocfs2-devel@lists.linux.dev, joseph.qi@linux.alibaba.com
Subject: Re: [PATCH v2] ocfs2: update xattr count before moving bucket entries
Message-ID: <aqoJuNSmtQO1nihQ@p15>
References: <20260916024750.9450-1-glass.su@suse.com>
Precedence: bulk
X-Mailing-List: ocfs2-devel@lists.linux.dev
List-Id: <ocfs2-devel.lists.linux.dev>
List-Subscribe: <mailto:ocfs2-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:ocfs2-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260916024750.9450-1-glass.su@suse.com>

On Wed, Sep 16, 2026 at 10:47:50AM +0800, Su Yue wrote:
> Since commit 2f26f58df041 ("ocfs2: annotate flexible array members
> with __counted_by_le()"), the xh_entries array is annotated with
> __counted_by_le(xh_count), so FORTIFY uses xh_count to determine its
> bounds. When inserting an entry into a bucket, ocfs2_xa_bucket_add_entry()
> shifts existing entries before incrementing xh_count.
> The destination therefore extends one entry past the bounds described
> by the old count.
> 
> With CONFIG_CC_HAS_COUNTED_BY and CONFIG_FORTIFY_SOURCE enabled,
> ocfs2-test: single_run-WIP.sh -t reflink triggers the following failure
> while adding an extended attribute:
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
> Signed-off-by: Su Yue <glass.su@suse.com>

LGTM.
Reviewed-by: Heming Zhao <heming.zhao@suse.com>
> ---
> Changelog:
> v2:
>    Remove fixes tag, mention the commit id in message.
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
