Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 68D901B32A2;
	Wed, 14 Aug 2024 15:05:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723647919; cv=none; b=UKz2+SRSpqIbW6K8ktGeUvJrTlTuARCoTib/rfRDWlQsUi66yYT453GX0KFifhpCXzML2DzKQHWxI6I0sKALtVtgOTSIv+VoAEUGxD60RLr4ftgP7ZxhuNIVlNFIXnL+pMhtB0H6J70O4VrTO8bQtDoGFxyyhZyqArGS2fIGDWA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723647919; c=relaxed/simple;
	bh=MYDfH0M7J1lMiWzMMSVfNAWR1ETaXt4hjUvZylezENQ=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=IgDn6zuidqzzkkQPfxOCYsmwW9FJHJx3OBdmTSpCKMeKFfZposLnlDmqdVNXRRMi/Mr+1aYhcybz8t9zjITaQKf4NY+lY8G8ARtzz+9ZMfZhwoK23MwGKXQMzJJM+l2pz9doPo+ohw9DjSyVtOdx6pvgnCE1+8rBtkKLERg38Rw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=HtKIxCSb; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="HtKIxCSb"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4F605C116B1;
	Wed, 14 Aug 2024 15:05:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1723647918;
	bh=MYDfH0M7J1lMiWzMMSVfNAWR1ETaXt4hjUvZylezENQ=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=HtKIxCSbvKhiawx3gtXVKdN62ivvJQ3rlrWXmK75gabDL/wyx2jU0M29Mf+kfKzlc
	 5IWKqI0gkDsbVew2VDhH1I3l/ILGa4f0BczYaPw20lfpEtjUK+XmSTlDcfzjTdg1ng
	 +L2zAX8gAEMn+LDE+MppkbDdAPNwsELnFFR/lDHM=
Date: Wed, 14 Aug 2024 17:05:10 +0200
From: Greg KH <gregkh@linuxfoundation.org>
To: Alexander Aring <aahringo@redhat.com>
Cc: teigland@redhat.com, gfs2@lists.linux.dev, song@kernel.org,
	yukuai3@huawei.com, agruenba@redhat.com, mark@fasheh.com,
	jlbec@evilplan.org, joseph.qi@linux.alibaba.com, rafael@kernel.org,
	akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
	linux-raid@vger.kernel.org, ocfs2-devel@lists.linux.dev,
	lucien.xin@gmail.com
Subject: Re: [RFC dlm/next 09/12] kobject: export generic helper ops
Message-ID: <2024081445-coffee-antiques-e9cc@gregkh>
References: <20240814143414.1877505-1-aahringo@redhat.com>
 <20240814143414.1877505-10-aahringo@redhat.com>
Precedence: bulk
X-Mailing-List: ocfs2-devel@lists.linux.dev
List-Id: <ocfs2-devel.lists.linux.dev>
List-Subscribe: <mailto:ocfs2-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:ocfs2-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240814143414.1877505-10-aahringo@redhat.com>

On Wed, Aug 14, 2024 at 10:34:11AM -0400, Alexander Aring wrote:
> This patch exports generic helpers like kset_release() and
> kset_get_ownership() so users can use them in their own struct kobj_type
> implementation instead of implementing their own functions that do the
> same.

Why is anyone needing these?  What raw kobjects require this type of
stuff?

thanks,

greg k-h
