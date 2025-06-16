Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 406183208;
	Mon, 16 Jun 2025 14:21:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750083703; cv=none; b=a9mO+eETSwPKLyXR3e6IEklIZXrddYNJIRn1UZ7L4kCPX4xOlI3UCvXWh6v3LAp5KqLEUZQjS0jtySHiXDF+l0ZDH6iu7rtVCOUf7HZPRTYKQ/bX5dnrPJ3vdLkYfSd40EKbEtMvLepyUTb++B4VwMPV141WHMzeYgq0hKhSp+8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750083703; c=relaxed/simple;
	bh=2Qt7ERd9ouPSyh1fbRfZngZBg05tXAh4XB4ap7STxjA=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=EYWxo5kCdVbOGvCGXFB/5g/MwMAHsvKumwCueHLTKr0SK7N/vAG3LwnIpxfXAJx+8qCcCbB9LyoSkk+E9y0tr/3WA8Hf4AIc9K+i0UJu4KNPJKxVHtZgTI4ii2TM5ORXeGMX2Lahph3ZrT1bL0DXJ262Qn+bq/rWoyR9wt5ZNEY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=oehqIBkw; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="oehqIBkw"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A85B8C4CEEA;
	Mon, 16 Jun 2025 14:21:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750083703;
	bh=2Qt7ERd9ouPSyh1fbRfZngZBg05tXAh4XB4ap7STxjA=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=oehqIBkwoDeX9ogj7alduxpr4eoga4dJFpPLQvBzc/57XIfZuZHrBRJdf/l2m7i7R
	 7i4dSeYkydEnQO3IYZa5/CaNLn07rbRznkN5k1QFltXbnBkZWcHnc78aBo5qlJFGUb
	 InZ+UDAyUiO9iFpB+L/fc5Mnygv/6+KrNk6UiMH0=
Date: Mon, 16 Jun 2025 16:21:40 +0200
From: Greg KH <gregkh@linuxfoundation.org>
To: Pranav Tyagi <pranav.tyagi03@gmail.com>
Cc: mark@fasheh.com, jlbec@evilplan.org, joseph.qi@linux.alibaba.com,
	skhan@linuxfoundation.org, ocfs2-devel@lists.linux.dev,
	linux-kernel@vger.kernel.org, linux-kernel-mentees@lists.linux.dev
Subject: Re: [PATCH] fs/ocfs2: use scnprintf() in show functions
Message-ID: <2025061626-amusable-grove-e6e4@gregkh>
References: <20250616105028.371633-1-pranav.tyagi03@gmail.com>
Precedence: bulk
X-Mailing-List: ocfs2-devel@lists.linux.dev
List-Id: <ocfs2-devel.lists.linux.dev>
List-Subscribe: <mailto:ocfs2-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:ocfs2-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250616105028.371633-1-pranav.tyagi03@gmail.com>

On Mon, Jun 16, 2025 at 04:20:28PM +0530, Pranav Tyagi wrote:
> Replace all snprintf() instances with scnprintf(). snprintf() returns
> the number of bytes that would have been written had there been enough
> space. For sysfs attributes, snprintf() should not be used for the
> show() method. Instead use scnprintf() which returns the number of bytes
> actually written.
> 
> Signed-off-by: Pranav Tyagi <pranav.tyagi03@gmail.com>
> ---
>  fs/ocfs2/cluster/masklog.c |  2 +-
>  fs/ocfs2/cluster/sys.c     |  2 +-
>  fs/ocfs2/stackglue.c       | 14 +++++++-------
>  3 files changed, 9 insertions(+), 9 deletions(-)
> 
> diff --git a/fs/ocfs2/cluster/masklog.c b/fs/ocfs2/cluster/masklog.c
> index 563881ddbf00..0bc21dc71d29 100644
> --- a/fs/ocfs2/cluster/masklog.c
> +++ b/fs/ocfs2/cluster/masklog.c
> @@ -28,7 +28,7 @@ static ssize_t mlog_mask_show(u64 mask, char *buf)
>  	else
>  		state = "off";
>  
> -	return snprintf(buf, PAGE_SIZE, "%s\n", state);
> +	return scnprintf(buf, PAGE_SIZE, "%s\n", state);

sysfs_emit() or no change at all please.
