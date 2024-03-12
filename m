Received: from valentin-vidic.from.hr (valentin-vidic.from.hr [116.203.65.182])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 24242141988;
	Tue, 12 Mar 2024 18:37:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=116.203.65.182
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1710268659; cv=none; b=qrzNP8o3cFJ0klzikwEMIYygfjnv7T0MHgwZs7tJg3JD6wa/ppxm2nZrTeTTlOxr4XK2UrbgNeW2rbarHaI3O0sWJb7Pbfgf+fqp1vfjMWytQaYzDi/OaO0EScmh6+3orxEcz+tg3OZIRDqZibA90JcE6mwnWgzas3filgqn6Sk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1710268659; c=relaxed/simple;
	bh=GlEZz1koZYjgGTgkn/efgianMullk3Cu3ujfMccRtXI=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=fXOiCuICaxL0I5uW88AN9en75l72qF1ANgUEBvxwtu7KgE12swuBnxfhKxfJwLISeZATwPQFidOtfwxCFOp8z71Z7p3H9e+VxGbiRiLJw8fSprar7wddd6rWnNfxGbCY1qX0WpHBo+UYg77QIfAAtSjfHPXnIqHaocbznpT5bOs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=valentin-vidic.from.hr; spf=pass smtp.mailfrom=valentin-vidic.from.hr; dkim=pass (4096-bit key) header.d=valentin-vidic.from.hr header.i=@valentin-vidic.from.hr header.b=EapyKtSw; arc=none smtp.client-ip=116.203.65.182
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=valentin-vidic.from.hr
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=valentin-vidic.from.hr
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (4096-bit key) header.d=valentin-vidic.from.hr header.i=@valentin-vidic.from.hr header.b="EapyKtSw"
X-Virus-Scanned: Debian amavis at valentin-vidic.from.hr
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
	d=valentin-vidic.from.hr; s=2020; t=1710268650;
	bh=GlEZz1koZYjgGTgkn/efgianMullk3Cu3ujfMccRtXI=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=EapyKtSwJY8+JE0BipBggPLOpvEZ8tVrK2w+Hi43rGr3GpduTheGxfGVVsZr1cZlo
	 BL3s3tOdP9lIooGJ7WTAeRCniZJ2+HiceUMW/FHvpm54+uzhhnEhnyGhS7p6yuyWos
	 b198927VYtO6gMYbDZs4GcpGbs8O6fbwcGDDa7/X7uMP3fonBfMfY4yqywWUpGyWAU
	 wqx6ossNylgapQcjLMLJSaoazsjL0wbaNk+2IH+x4+2mh7iu4ogTmNcBMMG8V9Dkd0
	 MbCWger4CjKS9msB2zrH46GnK9zGCHtvz7wA0jPbkx0d3SCnHMaGoQxXQdfTdSgIoc
	 QQ7eYCWFNK8ZuHHaxTBRcl1d0H2iJnS6CQq6o3/uarpWCcBjTZu3uEdIn0IVuQhEjl
	 d87AQofAJ+xhMpbp2aCj9JSG0xLrPZvaNLAXp/HekG2QWw0sOAHoUJ8zBu1o3G4E7Q
	 NTAEeYQxtU/vr1xh69J8KsrMYuMbIPgTSituQO2Rvn44t7vvAFgvrWBhNyTijTWui7
	 gNNprzXO3CjyzKtR5zBOiRJQ+/q6qDZpRA0jiK40g5fwUqA6H1CIbYUQD4fMZrJNmA
	 HwN57a707Jd21QGb+w2CkueWSU5E9lLCvYXilcwNQIL3VrZuve/MIcs0fcnGD/67Me
	 YGUQoDOJ5dOh1uAP2LRn1igw=
Received: by valentin-vidic.from.hr (Postfix, from userid 1000)
	id BF0DC2D2E6; Tue, 12 Mar 2024 19:37:30 +0100 (CET)
Date: Tue, 12 Mar 2024 19:37:30 +0100
From: Valentin =?utf-8?B?VmlkacSH?= <vvidic@valentin-vidic.from.hr>
To: Alexander Aring <aahringo@redhat.com>
Cc: Joseph Qi <joseph.qi@linux.alibaba.com>, ocfs2-devel@oss.oracle.com,
	David Teigland <teigland@redhat.com>, gfs2@lists.linux.dev,
	ocfs2-devel@lists.linux.dev
Subject: Re: ocfs2 mount error
Message-ID: <ZfCg6o3Kmkq78SIG@valentin-vidic.from.hr>
References: <Ze4qSvzGJDt5yxC3@valentin-vidic.from.hr>
 <49396145-712d-44eb-884e-58eb19b1f4f2@linux.alibaba.com>
 <Ze7IiZmlhRaOgdhm@valentin-vidic.from.hr>
 <CAK-6q+jFv8tK4rF-xY6okTwhK87zMtOKP6fthzCQ-H8-4q=wbQ@mail.gmail.com>
 <Ze9bIiT3rAWTtPJp@valentin-vidic.from.hr>
 <CAK-6q+j2UDh0mi0KUTdtsRE8pj4+tuw_SU+yjzjsR3GCLURz=w@mail.gmail.com>
 <ZfANyOkQh4SgXoty@valentin-vidic.from.hr>
 <CAK-6q+hBa08LoAEhsdiiG4DarCGF-CWy41zDjU3zB81P7hHx1A@mail.gmail.com>
Precedence: bulk
X-Mailing-List: ocfs2-devel@lists.linux.dev
List-Id: <ocfs2-devel.lists.linux.dev>
List-Subscribe: <mailto:ocfs2-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:ocfs2-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAK-6q+hBa08LoAEhsdiiG4DarCGF-CWy41zDjU3zB81P7hHx1A@mail.gmail.com>

On Tue, Mar 12, 2024 at 01:55:54PM -0400, Alexander Aring wrote:
> I was able to reproduce the issue and sent a fix out.

Yay, thanks a lot for testing, I can confirm the patches fix the problem
for me!

> If you want to extend your debian testing using different approach
> (not libdlm) this can be done by:
> 
> mount -t ocfs2_dlmfs none /dlm

I tried that but fsck than fails to make a lock, so I think ocfs2_dlmfs
is only relevant when used with o2cb cluster type instead of corosync.

> I am curious about your testing at debian cluster, do you also test gfs2?

Yes, a similar test for gfs2 would be this:

https://salsa.debian.org/ha-team/gfs2-utils/-/blob/master/debian/tests/corosync?ref_type=heads

It is not really a cluster test since it only runs on one KVM
machine. But as a package test it works well because even for
1-node cluster all the code (userspace and kernel) still needs
to work correctly.

-- 
Valentin
