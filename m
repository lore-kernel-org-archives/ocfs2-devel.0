Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 132D928691;
	Tue,  7 Jan 2025 02:12:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736215975; cv=none; b=N8qewfPt2B0zeGYVFjwExzVyEwYXIaHi2kPAACCGKFitz4NZgqrzGORCa+Ip99BdC6UbzEMNgDwzpRmLWxWJ7cZgBt5U2P86HB2SURhFYxfADSPQkLDdPwc7ePvcKFAYVik1MUnE/J6iFG/yjNO1+WNnfy2NXmecfjmU2oUoVgk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736215975; c=relaxed/simple;
	bh=oenYNeG+gnXZ4H5JoJghjClCQ0G0h7QENPx8F3zC6oA=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=nk7KLapTyd4w8EI+fUDFENzotfW384F7/+FgBT9jREXHDgat/A24kXqZuM2YQrfxc0yRPrLrNFUfbdPsWvFRmf7Q//6ao+D2GRDU7UkgANMHANhr9e0RkHpm28mHo8hzTxk+7IBl3z5P50+Fmj4BtdOjteULRYKCvLbZs16vqPw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=O58M++VH; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="O58M++VH"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CE644C4CED2;
	Tue,  7 Jan 2025 02:12:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1736215974;
	bh=oenYNeG+gnXZ4H5JoJghjClCQ0G0h7QENPx8F3zC6oA=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=O58M++VHHsjec9HmfX80PLUbkeogEBmxU3IXcwXUP8HwB7kgRB311AeL7wAdziY4B
	 ks1/1faN/+9ynybDxBxX7WoK680NeqVg0fKEXpVIQf1oD/XWcxAm1TT7oKDdd+nkDT
	 oFgA8yj8cF3tg2ZpxWTrYf5wLW7UgFrwv9KII+mk/BVru3H2zxrOgqYjXI5azdIs8J
	 gCVsL9e2nlB+XNP48llBfM696gEd7MwHVXs4DxUzemiSujny4dPwaDQivGKw7W9UpV
	 vMLlRTagyQxbY+Ktl3B2rFD4ErrKefd+ErWrtt3AG5Xyi1up83klxDgXozXnKZyl91
	 5/VUDpCR9kYlA==
Date: Mon, 6 Jan 2025 18:12:54 -0800
From: "Darrick J. Wong" <djwong@kernel.org>
To: Su Yue <glass.su@suse.com>
Cc: fstests@vger.kernel.org, ocfs2-devel@lists.linux.dev
Subject: Re: [PATCH] generic/620: add '-J block64' mkfs option for ocfs2
Message-ID: <20250107021254.GP6160@frogsfrogsfrogs>
References: <20250106140104.91880-1-glass.su@suse.com>
Precedence: bulk
X-Mailing-List: ocfs2-devel@lists.linux.dev
List-Id: <ocfs2-devel.lists.linux.dev>
List-Subscribe: <mailto:ocfs2-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:ocfs2-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250106140104.91880-1-glass.su@suse.com>

On Mon, Jan 06, 2025 at 10:01:04PM +0800, Su Yue wrote:
> mkfs.ocfs2 is using 32bit journal as default.
> For 16T size device support, '-J block64' should be used.
> 
> Signed-off-by: Su Yue <glass.su@suse.com>
> ---
>  tests/generic/620 | 3 +++
>  1 file changed, 3 insertions(+)
> 
> diff --git a/tests/generic/620 b/tests/generic/620
> index 3f1ce45a55fd..60e5a2cacdda 100755
> --- a/tests/generic/620
> +++ b/tests/generic/620
> @@ -41,6 +41,9 @@ sectors=$((2*1024*1024*1024*17))
>  chunk_size=128
>  
>  _dmhugedisk_init $sectors $chunk_size
> +
> +[ "$FSTYP" = "ocfs2"  ] && MKFS_OPTIONS="$MKFS_OPTIONS -J block64"

Won't mkfs.ocfs2 turn on block64 on a > 16T volume without prompting?

--D

> +
>  _mkfs_dev $DMHUGEDISK_DEV
>  _mount $DMHUGEDISK_DEV $SCRATCH_MNT || _fail "mount failed for $DMHUGEDISK_DEV $SCRATCH_MNT"
>  testfile=$SCRATCH_MNT/testfile-$seq
> -- 
> 2.47.1
> 
> 
