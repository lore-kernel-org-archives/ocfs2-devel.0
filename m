Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 94E172080D8;
	Thu, 12 Dec 2024 12:28:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734006527; cv=none; b=SZzk8M1wBfmcVigdmSHyX2MiQZU1Rke7wIvxOc5e8qEIcptF3td9BxGR5vY2Ey7NV5Pe7vO4NPsUAqIVUtj5VwgL8/f5mhjzGj1Re+Ow4IBy8+5uAjUgrKC3mvVad8ifnuizWp1V+znYFIEmyZAwQm0N9scTmkuQ/P1/MqWDWkg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734006527; c=relaxed/simple;
	bh=10g3ha4JKAYA0ztLc7nC/DOB+xEE8kE9e7uj/1H8Avc=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=GPS13OxIHox1fpgymv2QplVjtSM22ocqX089MaDx4hVOlkXbUA1uL1/Phz/5dPpQlJkrnCqX6Riapz/lYCTFI6IijxgI3rRhAlIK+fyGOxwYCYb3RiW61GejMRxOCf24hfUy2v/phlQa5I8k4wjlxp+lMHzdVcRH7VWV4tH1G/Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=dpMhMc5v; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="dpMhMc5v"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 72F4DC4CECE;
	Thu, 12 Dec 2024 12:28:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1734006527;
	bh=10g3ha4JKAYA0ztLc7nC/DOB+xEE8kE9e7uj/1H8Avc=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=dpMhMc5vUFFyfGN16/6/fOQxmdkBO4SKlgGFT2/TVvrp33bkgro9/o2n/4Rgn65xL
	 PZP1uOLqTry4JG8ino7SYT7BJw66n7EyYVLZHKFvT9PoMoiSo72ksRwa5EuHQ49/KT
	 pkJoI3NGfe7VahKXcApjtIpEeh06XVjJ0KF1E1s4=
Date: Thu, 12 Dec 2024 13:28:43 +0100
From: Greg KH <gregkh@linuxfoundation.org>
To: Heming Zhao <heming.zhao@suse.com>
Cc: joseph.qi@linux.alibaba.com, linux-kernel@vger.kernel.org,
	stable@vger.kernel.org, ocfs2-devel@lists.linux.dev
Subject: Re: [PATCH] ocfs2: Revert "ocfs2: fix the la space leak when
 unmounting an ocfs2 volume"
Message-ID: <2024121222-smoked-gossip-d970@gregkh>
References: <20241212113107.9792-1-heming.zhao@suse.com>
 <92d413be-286e-49b7-a234-b6e2c8c94581@suse.com>
Precedence: bulk
X-Mailing-List: ocfs2-devel@lists.linux.dev
List-Id: <ocfs2-devel.lists.linux.dev>
List-Subscribe: <mailto:ocfs2-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:ocfs2-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <92d413be-286e-49b7-a234-b6e2c8c94581@suse.com>

On Thu, Dec 12, 2024 at 07:45:11PM +0800, Heming Zhao wrote:
> Hi Greg,
> 
> The 4.19 branch also needs this patch.

4.19.y is end-of-life, sorry (see the front page of kernel.org for the
current list.)

thanks,

greg k-h
