Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 14B2E168497;
	Wed, 21 Aug 2024 22:57:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724281058; cv=none; b=ZWzrAeUV9hA6/J6q9h31yVQHJ97E0W33xnOSmglBWYgBLNbpEJlo/sBAHPxyzh3cZgfENsV7RNAewxDimLf8A5X6J+6xtENJT4NJyQbIg/Us+4gB8i82lLC6qYo5rlNmrmDhkEFARNEnKLmIIcCpEp8UFNuUVzHiK1SwySCoWJc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724281058; c=relaxed/simple;
	bh=CQbjtuMOeSh9AmKi2kF6EWr5v9mmXD/mis1t5FfkenU=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=n3NCC4pHJgcrOuK5P41uDoIV4kPSZtxKPAPasVRSFvYEf1ShJY2RPIAUOapN9pdyKoPndcrbo+sSWyzSxJ7ci5gn6QAXgNxH1tA77EFHDEbtf1qyYkPpaedONmCOgeGbGfSdtI9QUkUBXOg4Xp6tZZq1Y36qb95Vn2zaOJaFTkY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=a0qYM/gD; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="a0qYM/gD"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F094DC32781;
	Wed, 21 Aug 2024 22:57:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1724281057;
	bh=CQbjtuMOeSh9AmKi2kF6EWr5v9mmXD/mis1t5FfkenU=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=a0qYM/gDynuqwWPxM5MvVyn23rgCtOXxcqD5PYQsgVyrRfHMgR6fx6jSWwzImOLGs
	 cvNolQGYATxBEQp3mK4vIW0HcQkTHre5yKIVwwwa0aTlsGzFchvs+2J242TSwKD4Uz
	 RSAPdH0zHtBxGselG9TD+PtyuqDIdG82kVYoT8pM8H4XNFgTTFzNFoviNfGn2vOXjz
	 ztwFciWbrEbX8MISOhDdc6d31pjExvIdrEhTLWtU/nsKGcXFO+NQOXLgrZaOiGY50h
	 nSj/lPUl9GrjFnU5WYTC8nAYHm0USFOsiQ7acDHskrB+KeFszGIMIVCIMwTCmnSH13
	 nNCD6NM5X7Pww==
Date: Wed, 21 Aug 2024 15:57:36 -0700
From: Jakub Kicinski <kuba@kernel.org>
To: Alexander Aring <aahringo@redhat.com>
Cc: teigland@redhat.com, gfs2@lists.linux.dev, song@kernel.org,
 yukuai3@huawei.com, agruenba@redhat.com, mark@fasheh.com,
 jlbec@evilplan.org, joseph.qi@linux.alibaba.com,
 gregkh@linuxfoundation.org, rafael@kernel.org, akpm@linux-foundation.org,
 linux-kernel@vger.kernel.org, linux-raid@vger.kernel.org,
 ocfs2-devel@lists.linux.dev, netdev@vger.kernel.org,
 vvidic@valentin-vidic.from.hr, heming.zhao@suse.com, lucien.xin@gmail.com
Subject: Re: [PATCH dlm/next 11/12] dlm: add nldlm net-namespace aware UAPI
Message-ID: <20240821155736.64d0350c@kernel.org>
In-Reply-To: <CAK-6q+hx8MNeZCc0T-sTPdMgXH=ZcpLVqc2-5+psMCoQ_W0FxA@mail.gmail.com>
References: <20240819183742.2263895-1-aahringo@redhat.com>
	<20240819183742.2263895-12-aahringo@redhat.com>
	<20240819151227.4d7f9e99@kernel.org>
	<CAK-6q+hx8MNeZCc0T-sTPdMgXH=ZcpLVqc2-5+psMCoQ_W0FxA@mail.gmail.com>
Precedence: bulk
X-Mailing-List: ocfs2-devel@lists.linux.dev
List-Id: <ocfs2-devel.lists.linux.dev>
List-Subscribe: <mailto:ocfs2-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:ocfs2-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Wed, 21 Aug 2024 09:13:21 -0400 Alexander Aring wrote:
> > Did you consider using the YAML spec stuff to code gen the policies
> > and make user space easier?
> 
> I will try to take a look into that and prepare a spec for PATCHv2. I
> saw that there is a documentation about it at [0].
> 
> I did a kind of "prototype" libnldlm [1] to have easy access to the
> netlink api but if there are more common ways to generate code to
> easily access it, I am happy to give it a try.

Right, even if you don't end up using it on the user space side, having
YNL generate the kernel boiler plate simplifies the human review, if
nothing else :) YNL always uses the latest and safest kernel constructs.
