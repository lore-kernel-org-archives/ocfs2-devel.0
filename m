Received: from mail-wr2-f12.google.com (mail-wr2-f12.google.com [74.125.225.76])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 49F1B4A3F19
	for <ocfs2-devel@lists.linux.dev>; Sat,  5 Sep 2026 14:45:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.225.76
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788619517; cv=none; b=uNGHG1zjzhUaSih5plniBgIC+/ltZ4nMrPN/b1XHn4tLK4LPqrmNhfZQ9TCUd9Ye3rLz2UwYLxrlTleIICBZuA40QB7ZBERA3pzRIm8ZsTFZ6avYoLx/Y1/LmGeouXGs8ptLWfisnVQOxrnEZqwNk2e3fkS32dB5NgiwZ/Xaiq8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788619517; c=relaxed/simple;
	bh=3dSaD3qzEawWjYdUkb2MHJo1tgSjCE1Kkoj7/OKb2TQ=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=aLcvGe+2VhBzYW9FqWrbIhkV/D9OhdF8lblIVN8MwpHp/vERY8dSoWHJSd2/5LXXm4Kumy458ekDlyRG0VWxqP5lQkMKW7sgX+BKZxf98n0sljsOW5MwLhtF8MJfyTFZvW+Vhu6rya/Tfe0aypvih21SxAwbWhAh9HX6/j0HafY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=LzSkxdsj; arc=none smtp.client-ip=74.125.225.76
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="LzSkxdsj"
Received: by mail-wr2-f12.google.com with SMTP id ffacd0b85a97d-484399babcaso89196f8f.0
        for <ocfs2-devel@lists.linux.dev>; Sat, 05 Sep 2026 07:45:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1788619513; x=1789224313; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=up/rgxumaxsCy5JEMTBUZLpY+yoJXx9XvOAZd1MctPw=;
        b=LzSkxdsjWwUueBrRkeXs9s5cO6E0jqRRqO6HNvtU9vIDvOkBHVldMNM+JAdEixIcNh
         KGCR15zci4ErV+5C8LlpFrOHcFlpbLv8Ne4/T7wRY6eoLXqhNf9ToITjhud24asQgTNP
         nCnM4fKz1ooxm5PuVwK+Ti5iUyfvtbYRzTcsVwV0Pl3bV36G9rCKVtiO+K13DEUc5t8W
         By/PDB726zEuTgeDVn422MPYHc0DFTeQ5SuvhCR0BikO3mMdyrI1aqCMraftd3O0v83m
         fO8qHENnCZP8GqHH21wY3UXxEzfY6V1W9UgF90wnurbmOFzhBNRenCdUkGFskxaaOi+4
         wnWg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1788619513; x=1789224313;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=up/rgxumaxsCy5JEMTBUZLpY+yoJXx9XvOAZd1MctPw=;
        b=DYnzTX1uuaP2kZOYhatdaacWqTLwX00auGVnUfdzgzJHJabhIGstsTHCOQrZf0sgis
         9bZFiKb9iSUIgMK/adJ8SuYJBrG0lj62dMVnCZp+XbT2xgXMKPeMtX6qCj0Plc0vx9NX
         uNyVmbjzqWmHEcd0tdmzaxriZyTd82d9gWsi/7KDow1tyE0rv3MydaPCtvFFuIxvwH6d
         URxXPwd5H/2IIohDOPd+6lEQ7T6PoO0BMV6imLlEUrNHvwVOZ2SvOW3mY1FR4lLE8Ujk
         GrJWVdoalgW9c7jiNWbri1atM3PqiWq1Hf7Qf39ch1fQRy+OFb/+qXPi66pkCS1E6jmw
         nV6g==
X-Forwarded-Encrypted: i=1; AKwUvBwRDSNQnZ6vWoqwTXgWN34E04HF3dYluzpEolVB2V/98FHy1fqkooSmc4wx7yxE2BbME09G+8unF0pizg==@lists.linux.dev
X-Gm-Message-State: AFuF++libyX1GZThLDSL1f2A5/q5vRuP7Z1kEdHhwISq4zVwF1SFaBBi
	9A7Y1eYtEuKXED5SGOG4vj1FtqhlEtJwIHl1anSQ1A3uy6QXi+2sbmB7AqfVOkiKD983iATY8ge
	oaW4jUHruCQ==
X-Gm-Gg: AYBFou0TGzFp4L1/8lOijSrYxorDdHkbIpL83PBh1StgHtWH3t10oAYxfVx5LRFNLdo
	2FwFbAJID3UbFhVzQysV3cGLwu+ViopqJYgwmYkjh613MDi7iG7fl95CyN5L9bEXuyrX1OwjosQ
	jvlEkP5CqpJKcHRUqsYcHfh/OQfBuvirE3uwI54DBgqVLMZt92gKwrEobCYU+SkVeG/6Olt+TDK
	EuQkm8cyAKSVRgbB7DCKnjbGWWz/8l6Xfnwsf/WxDRmS+NCYn0lH24n5BBmUWqkP2zadEB9nugh
	hdeL8vLjjsmWrsWSd457WVvwyqDYVjUMHlirkK9ERBUvNmPN/W435TWlP1QagYHBxo9MCMQc1qg
	vgTnL1TDeR4r2ILy6q/cL/cxei21UktapBr61G858X7NSTR7oEPWaTeSZXrhZ/flkxsJ+H3eljn
	IKKfdUQLgfEuYXmg4019TlfC/VcWrHbQFBG6+bn3Y0zaxj4VmrxB3nEhyF2P2I5V4h53QVrQ==
X-Received: by 2002:a05:600c:8b2e:b0:49c:cbf4:572b with SMTP id 5b1f17b1804b1-49d01dcc1fdmr48391805e9.2.1788619513504;
        Sat, 05 Sep 2026 07:45:13 -0700 (PDT)
Received: from localhost ([202.127.77.110])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-39b2612d3f1sm10186499a91.13.2026.09.05.07.45.10
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 05 Sep 2026 07:45:11 -0700 (PDT)
Date: Sat, 5 Sep 2026 22:45:08 +0800
From: Heming Zhao <heming.zhao@suse.com>
To: Joseph Qi <joseph.qi@linux.alibaba.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, 
	Mark Fasheh <mark@fasheh.com>, Joel Becker <jlbec@evilplan.org>, ocfs2-devel@lists.linux.dev, 
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 2/2] ocfs2: validate dl_blkno and dl_fs_generation of
 dir index leaf blocks
Message-ID: <apwp-6JMpJckN3If@p15>
References: <20260905142144.2869105-1-joseph.qi@linux.alibaba.com>
 <20260905142144.2869105-2-joseph.qi@linux.alibaba.com>
Precedence: bulk
X-Mailing-List: ocfs2-devel@lists.linux.dev
List-Id: <ocfs2-devel.lists.linux.dev>
List-Subscribe: <mailto:ocfs2-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:ocfs2-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260905142144.2869105-2-joseph.qi@linux.alibaba.com>

On Sat, Sep 05, 2026 at 10:21:44PM +0800, Joseph Qi wrote:
> ocfs2_validate_dx_leaf() checks the checksum, the signature and the
> entry list counts, but it never checks dl_blkno or dl_fs_generation.
> The inode, extent block, xattr block, refcount block and dir index root
> validators all check the on-disk block number against bh->b_blocknr and
> the generation against the superblock, and both dir index leaf fields
> are documented as "Must match super block".
> 
> Without the checks, a stale dir index leaf block left on the device from
> a previously formatted filesystem at the same physical block number can
> pass validation as long as its signature, entry counts and checksum
> match.  Its index entries would then be used in the new filesystem
> context.
> 
> Both fields are written unconditionally when a leaf block is formatted
> in ocfs2_dx_dir_format_cluster(), from the live superblock generation
> and the real block number, so a correctly formatted filesystem cannot
> trip the new checks.  The leaf block number read back here comes from
> on-disk dir index root extent records.
> 
> Reject dir index leaf blocks whose dl_blkno or dl_fs_generation does not
> match, like the dir index root validator does.
> 
> Signed-off-by: Joseph Qi <joseph.qi@linux.alibaba.com>
> ---
>  fs/ocfs2/dir.c | 12 ++++++++++++
>  1 file changed, 12 insertions(+)
> 
> diff --git a/fs/ocfs2/dir.c b/fs/ocfs2/dir.c
> index 329680b46227..55c4a305a282 100644
> --- a/fs/ocfs2/dir.c
> +++ b/fs/ocfs2/dir.c
> @@ -733,6 +733,18 @@ static int ocfs2_validate_dx_leaf(struct super_block *sb,
>  		return ocfs2_error(sb, "Dir Index Leaf has bad signature %.*s\n",
>  				   7, dx_leaf->dl_signature);
>  
> +	if (le64_to_cpu(dx_leaf->dl_blkno) != bh->b_blocknr)
> +		return ocfs2_error(sb,
> +				   "Dir Index Leaf # %llu has an invalid dl_blkno of %llu\n",
> +				   (unsigned long long)bh->b_blocknr,
> +				   (unsigned long long)le64_to_cpu(dx_leaf->dl_blkno));

The patch looks fine to me.
Reviewed-by: Heming Zhao <heming.zhao@suse.com>

Only question: Do we add the same check for dl_blkno in ocfs2_validate_dx_root()?

Thanks,
Heming
> +
> +	if (le32_to_cpu(dx_leaf->dl_fs_generation) != OCFS2_SB(sb)->fs_generation)
> +		return ocfs2_error(sb,
> +				   "Dir Index Leaf # %llu has an invalid dl_fs_generation of #%u\n",
> +				   (unsigned long long)bh->b_blocknr,
> +				   le32_to_cpu(dx_leaf->dl_fs_generation));
> +
>  	if (le16_to_cpu(dx_leaf->dl_list.de_count) !=
>  	    ocfs2_dx_entries_per_leaf(sb))
>  		return ocfs2_error(sb,
> -- 
> 2.39.3
> 
