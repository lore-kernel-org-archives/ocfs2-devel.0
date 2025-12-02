Received: from mail-wm1-f50.google.com (mail-wm1-f50.google.com [209.85.128.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B879B2AD35
	for <ocfs2-devel@lists.linux.dev>; Tue,  2 Dec 2025 03:16:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.50
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764645377; cv=none; b=lO5RgcrEp0sFOv5dXqQ7PHPi0FnzEGAp/gnwh/33dKD+j5e3P2RkELNL3ssecjmxdURIKsP8pYbNZRa0TE8A3fm5krbQgBwudfyu+/IW/8eDwzBl7KVML7R0/FhMZVv0koAPcmbrGQcGkgvIx8ogne1BNVtDmE8mhtbEnpoj844=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764645377; c=relaxed/simple;
	bh=XbnZwMSqw2a851HuppR1+WT8OE6q3mSKHb00vt+GRsU=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=XJd7NrhD06K4gplHb1LWWhzkc6yr8TYXAI2Xa6GD1RNUPrsxAqK1Fb/amuljf4tjOQuKomDGJtPldGkVjCRpl29ipIsDMtYBHncsu7uCRsogkPzACruTwmWyfYdZbrmRFQU8KcaVxk3mMXlIzKZiAr1YjEQNEtu7y2Yp1vnI+OA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=HHrsMvGp; arc=none smtp.client-ip=209.85.128.50
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="HHrsMvGp"
Received: by mail-wm1-f50.google.com with SMTP id 5b1f17b1804b1-4779fd615a3so4854275e9.0
        for <ocfs2-devel@lists.linux.dev>; Mon, 01 Dec 2025 19:16:13 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1764645372; x=1765250172; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=fu5u38ITWf5iTXZNIG6ZQjqoCLUXDYKhzmLMsHYomR4=;
        b=HHrsMvGpYhxmZ0R6E8hkoQ9SzcthYXCSUIAHGOuR+ANsTcyOeKIOdoJasDYD/T2RwQ
         hpb0vbs/RZ2wWs4K6E+Q1wzDG5qOOxyR+nZ2UPdM/M/K53NdyDlWnR3sP4mkdDd5DeXP
         rduap25hQdz6Eu83cu1LcJpteEkCHZf+0nwI6V0t/fiG8U0Z4oMDDEIsxD40Nf6qT7FN
         cT2GvNQkjedWciI5OwTcPv8xQJ/KLSV/QMMhOcr0xIBWEm5kcweWwgxLGRgl8OyfR53k
         cm5hpbSytRm2nMPB8TsEirsvx3P4ulRUTmVl4hnNDTHg5rnssvS+EwxLDmurUTmcWvXI
         Uxag==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1764645372; x=1765250172;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=fu5u38ITWf5iTXZNIG6ZQjqoCLUXDYKhzmLMsHYomR4=;
        b=ryUatkUAI4wjxI8mDE1XIe9bckh+Qrao5UpsXrjwfuIR7ydN+TyDrUv4abpkIIId13
         exlt5UtXg2nclGuFxVIEHYOR9aywzNN4GNFV6tlVRFcQA51cTUgvMFlD1YChWpOs560Q
         495KoaKTssfK4rdnOEsy/Lub5gLuGc2avj0+y3zUdXvqHGRNxn2bcYkVTQKV5biu3U70
         t5DJv/DNh5i57MiH/gCu80Qk3INR+Zo6XNXYPaedV2+m/bnBaJ3L54dvI8TvMCHNNu73
         KyTeuArlK4V1lYOq7zkfQYk7rbi1VY2JWBcSrWvoYCXGa0oaOfSfXuR39nFELGFD2BRy
         o8Ow==
X-Forwarded-Encrypted: i=1; AJvYcCXVnXyX5/+Xhyxqw06JnrlVBsqujIDvqffbGV5IQcxuSqGgEJeV31bDllOHs1P0QwDwdW/fi8sHZtJVuw==@lists.linux.dev
X-Gm-Message-State: AOJu0YwIBvipOWWU6qKT2tQYrDwja7QpKWVMq+EF3zsFFyNf7E3/nxu4
	MOhVwtDqm5bA4QqioBBSX6qNcD5WkF5J1u9caUaMYTf3zrwgAR83u3jQvIcUPbYTkZ4=
X-Gm-Gg: ASbGncurz1SMwf7oU4XwrzTKKX0zqYeqEzwWfN0n3xnqTHhUavgN59Q801B0HWoTclu
	sxyBUO9chDtskHd6D3KS1ygRBLV+MzThAAPj2Nx97RdrfuQxQouSx2ReOWvILp/RNxpLo7m6VSN
	1gqNhJEIK4fO3SyOLzKzmXFUHMU6pzf525Jebl10SqLcVnJCiTKdWapZFjoY8zrT7ZNKaVa6mSs
	U8+AQoRN+5jhYaTtwoV0LYdOBgbuC2CLtItJVARdiQ5BJ2JxivFHdIz/MDAUw1vDJ8ahoh/AsPH
	etW9wFfUiJXoUiod09P2BIz7YLcD5iJpJfPiFPxozq/w/psdDr1vvHVpxRubp3/i2vfstTMSFOu
	Kf+v23495m2HV7+VESI/tisHmM5wTWALSoUst06tZLKwTQcMA01hrEpRQcplcj76QGJ6KiKqhPo
	++zImMSfRKkA==
X-Google-Smtp-Source: AGHT+IE8tYGtiS3lO/qNG2wRpHjLBleIfeepIeKYnHsF7xHP09ifwkWX0KwxT1/Ko/Jp4OkWiWWtTg==
X-Received: by 2002:a05:600c:45d1:b0:477:9c73:268a with SMTP id 5b1f17b1804b1-477c01da8c0mr247642445e9.6.1764645372083;
        Mon, 01 Dec 2025 19:16:12 -0800 (PST)
Received: from localhost ([202.127.77.110])
        by smtp.gmail.com with ESMTPSA id 41be03b00d2f7-be508b06606sm13264737a12.18.2025.12.01.19.16.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 01 Dec 2025 19:16:11 -0800 (PST)
Date: Tue, 2 Dec 2025 11:16:08 +0800
From: Heming Zhao <heming.zhao@suse.com>
To: Ahmet Eray Karadag <eraykrdg1@gmail.com>
Cc: mark@fasheh.com, jlbec@evilplan.org, joseph.qi@linux.alibaba.com, 
	ocfs2-devel@lists.linux.dev, linux-kernel@vger.kernel.org, david.hunter.linux@gmail.com, 
	skhan@linuxfoundation.org, Albin Babu Varghese <albinbabuvarghese20@gmail.com>
Subject: Re: [PATCH v3 1/2] ocfs2: Add ocfs2_emergency_state helper and apply
 to setattr
Message-ID: <3nfa5owmhk27lphplfnwvfagum2y2mvn3yn65nh3mrw7fzipcm@zutf6ljpz3b3>
References: <cover.1764643790.git.eraykrdg1@gmail.com>
 <8a26b007729e3f3f813f754eda6eed59431502e1.1764643790.git.eraykrdg1@gmail.com>
Precedence: bulk
X-Mailing-List: ocfs2-devel@lists.linux.dev
List-Id: <ocfs2-devel.lists.linux.dev>
List-Subscribe: <mailto:ocfs2-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:ocfs2-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <8a26b007729e3f3f813f754eda6eed59431502e1.1764643790.git.eraykrdg1@gmail.com>

On Tue, Dec 02, 2025 at 05:54:57AM +0300, Ahmet Eray Karadag wrote:
> To centralize error checking, follow the pattern of other filesystems
> like ext4 (which uses `ext4_emergency_state()`), and prepare for
> future enhancements, this patch introduces a new helper function:
> `ocfs2_emergency_state()`.
> 
> The purpose of this helper is to provide a single, unified location
> for checking all filesystem-level emergency conditions. In this
> initial implementation, the function only checks for the existing
> hard and soft read-only modes, returning -EROFS if either is set.
> 
> This provides a foundation where future checks (e.g., for fatal error
> states returning -EIO, or shutdown states) can be easily added in
> one place.
> 
> This patch also adds this new check to the beginning of
> `ocfs2_setattr()`. This ensures that operations like `ftruncate`
> (which triggered the original BUG) fail-fast with -EROFS when the
> filesystem is already in a read-only state.
> 
> Suggested-by: Heming Zhao <heming.zhao@suse.com>
> Co-developed-by: Albin Babu Varghese <albinbabuvarghese20@gmail.com>
> Signed-off-by: Albin Babu Varghese <albinbabuvarghese20@gmail.com>
> Signed-off-by: Ahmet Eray Karadag <eraykrdg1@gmail.com>

Reviewed-by: Heming Zhao <heming.zhao@suse.com>
> ---
> v2:
>  - Introducing new function `ocfs2_is_readonly` to lower the cost
>  - Using unlikely for status check
> ---
> v3:
>  - Fix compilation error (missing semicolon).
> ---
>  fs/ocfs2/file.c  |  6 ++++++
>  fs/ocfs2/ocfs2.h | 18 ++++++++++++++++++
>  2 files changed, 24 insertions(+)
> 
> diff --git a/fs/ocfs2/file.c b/fs/ocfs2/file.c
> index 21d797ccccd0..253b4f300127 100644
> --- a/fs/ocfs2/file.c
> +++ b/fs/ocfs2/file.c
> @@ -1137,6 +1137,12 @@ int ocfs2_setattr(struct mnt_idmap *idmap, struct dentry *dentry,
>  					from_kgid(&init_user_ns, attr->ia_gid) : 0);
>  
>  	/* ensuring we don't even attempt to truncate a symlink */
> +	status = ocfs2_emergency_state(osb);
> +	if (unlikely(status)) {
> +		mlog_errno(status);
> +		goto bail;
> +	}
> +
>  	if (S_ISLNK(inode->i_mode))
>  		attr->ia_valid &= ~ATTR_SIZE;
>  
> diff --git a/fs/ocfs2/ocfs2.h b/fs/ocfs2/ocfs2.h
> index 6aaa94c554c1..91a861babf74 100644
> --- a/fs/ocfs2/ocfs2.h
> +++ b/fs/ocfs2/ocfs2.h
> @@ -680,6 +680,24 @@ static inline int ocfs2_is_soft_readonly(struct ocfs2_super *osb)
>  	return ret;
>  }
>  
> +static inline int ocfs2_is_readonly(struct ocfs2_super *osb)
> +{
> +	int ret;
> +	spin_lock(&osb->osb_lock);
> +	ret = osb->osb_flags & (OCFS2_OSB_SOFT_RO | OCFS2_OSB_HARD_RO);
> +	spin_unlock(&osb->osb_lock);
> +
> +	return ret;
> +}
> +
> +static inline int ocfs2_emergency_state(struct ocfs2_super *osb)
> +{
> +	if (ocfs2_is_readonly(osb)) {
> +		return -EROFS;
> +	}
> +	return 0;
> +}
> +
>  static inline int ocfs2_clusterinfo_valid(struct ocfs2_super *osb)
>  {
>  	return (osb->s_feature_incompat &
> -- 
> 2.43.0
> 
