Received: from valentin-vidic.from.hr (valentin-vidic.from.hr [116.203.65.182])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 67CE3382;
	Tue, 12 Mar 2024 20:42:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=116.203.65.182
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1710276180; cv=none; b=WY2JWd4QS02igr8yhHwcnFtgx1LxA5H0zFsZa4NIrLI057olGstUIjqBV7ViBJyUs3mSTBGIskR5wm/WgJ9VjFqYSMRr9OMWE7Nq4R4IjcpiSBQn47tKuovcfBqTf8mYfk3TuncZE/6I3WMarXLlYpSdO9zjAFGpjRi8oQ+Yhlg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1710276180; c=relaxed/simple;
	bh=4sbFHc3XOZP9OGRL7sUTmRV2VkeNbIXd+l2AcYMu/S8=;
	h=Date:From:To:Cc:Subject:Message-ID:MIME-Version:Content-Type:
	 Content-Disposition:In-Reply-To; b=asVw/U1VbU0zmOHd4IEGizhFMv4H9Zbj9h9ryBjqIclnKcsggOK7xt4XUYMUK3WoD8QzmyQgYhNYasp/+9WOnMqIfyQNttSxzXIYfpuBWa0SFtpzlhpxHgjJ0W7d+iEenOrJR+QXSehmf+EeCGa9Xgo7rtmc1/5LHjDUmynnezY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=valentin-vidic.from.hr; spf=pass smtp.mailfrom=valentin-vidic.from.hr; dkim=pass (4096-bit key) header.d=valentin-vidic.from.hr header.i=@valentin-vidic.from.hr header.b=T8vSRtBY; arc=none smtp.client-ip=116.203.65.182
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=valentin-vidic.from.hr
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=valentin-vidic.from.hr
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (4096-bit key) header.d=valentin-vidic.from.hr header.i=@valentin-vidic.from.hr header.b="T8vSRtBY"
X-Virus-Scanned: Debian amavis at valentin-vidic.from.hr
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
	d=valentin-vidic.from.hr; s=2020; t=1710276174;
	bh=4sbFHc3XOZP9OGRL7sUTmRV2VkeNbIXd+l2AcYMu/S8=;
	h=Date:From:To:Cc:Subject:In-Reply-To:From;
	b=T8vSRtBYl4guHOlZBgoY67Fvi/h1RpAhgfc/sd2ScfFnvc+uS90L4awZH6FpcTr6s
	 BAwHrz4V27m8UG2rfPpsE/9ZXJZlpcq8MizU4MkNw3GG77o5ltp6/JJ5nqCpAGH6Or
	 GEcqfxB7xfxkbhc9wVjeevVa1MDQLz+4CHv0Dbp1mxL0OBktC9BFtl1wbwtQZUkg0N
	 yALqE0dYyWuqpCHBq/Cu+4tmT8pSWpvAdWkl5vBRdGAxKyqSXts7ouxJPFDeVRTQLI
	 Wir/CNuuM3D7ladl93GDTWgxvP7/2iMkrREYhVOz8psIzzPEI3vJCnxFRm+hzt/LdL
	 JwVQqTN6v6YNd5j6s96FnU5MKYW/N2ptq/YxMDk1NsCcOE3WOkweQoK0Xlub7HguXS
	 GolmIyzEXbXoUahsnwTRIJpXodF3Xskt2vzXn+CUFsbDCJtIL6TGtWQoa4+8csrr4v
	 1N9DuSpIn7XwFaAPXQkDDVsu7Vzse7fUsQpkKHySBenZNwNSv0shqif+VwPuo6JIUD
	 H1vjgTcZPEo6wKYnYV1oRly7BWF8qa5X26rsD93cBpXdJvA7cK8AEj1dESnnytKaF4
	 ft8Iikyg+I0h5APzBWnXWS9bzsQRqCZwnm3pvEP45C2hTaaCHtaMSYS8xTLAOIntpj
	 CGU9YwauKva6E7q0pnD19s7o=
Received: by valentin-vidic.from.hr (Postfix, from userid 1000)
	id 9A64F2D2F2; Tue, 12 Mar 2024 21:42:54 +0100 (CET)
Date: Tue, 12 Mar 2024 21:42:54 +0100
From: Valentin =?utf-8?B?VmlkacSH?= <vvidic@valentin-vidic.from.hr>
To: Alexander Aring <aahringo@redhat.com>
Cc: Joseph Qi <joseph.qi@linux.alibaba.com>, ocfs2-devel@oss.oracle.com,
	David Teigland <teigland@redhat.com>, gfs2@lists.linux.dev,
	ocfs2-devel@lists.linux.dev
Subject: Re: ocfs2 mount error
Message-ID: <ZfC-TjBz9xBIqZb-@valentin-vidic.from.hr>
Precedence: bulk
X-Mailing-List: ocfs2-devel@lists.linux.dev
List-Id: <ocfs2-devel.lists.linux.dev>
List-Subscribe: <mailto:ocfs2-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:ocfs2-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAK-6q+iWzE_QgH3sYK6v8JS+p9KxaEGihoe-6WD1-pfz964bCw@mail.gmail.com>
 <CAK-6q+j8Ag5yj6pn0P4wC2kRSNMVaHGmVY+G6+H5aYD1-ygzSw@mail.gmail.com>

On Tue, Mar 12, 2024 at 03:55:46PM -0400, Alexander Aring wrote:
> Then you can reply to the mail with:
> 
> Tested-by: Valentin Vidić <vvidic@valentin-vidic.from.hr>
> 
> that would help to bring the fix upstream.

Sure, replied to the other thread.

> I see, I currently have plans/ideas to add namespace support into
> kernel DLM that might help you by extending your testing. The general
> idea would be that you can do something like:
> 
> ...
> ip netns exec node1 mount /dev/fake_shared_block /mnt/node1
> ip netns exec node2 mount /dev/fake_shared_block /mnt/node2
> ip netns exec node3 mount /dev/fake_shared_block /mnt/node3
> ...

Yeah, that would definitely be cool. And thanks for the pointers,
I will definitely try to use namespaces for some simpler corosync
tests first.

> It also requires a ocfs2-tools tool at a specific location:
> 
> /sbin/ocfs2_hb_ctl
> 
> maybe this is your issue why it wasn't working. My kernel was
> complaining about it because it was missing in /sbin/

That binary is already in the Debian package. I think the error
fsck reported was something like "Could not create domain".

-- 
Valentin
