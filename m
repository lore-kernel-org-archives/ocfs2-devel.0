Received: from valentin-vidic.from.hr (valentin-vidic.from.hr [116.203.65.182])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 90A5113AC0;
	Mon, 11 Mar 2024 09:02:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=116.203.65.182
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1710147733; cv=none; b=FuQT/FoUOYX7n6PcUvoNxQI2leE/Gx457x3Q9eZlQb7/Ag7Xv2gSQjPqig70wOdamtUdesJAl+TclnMekwkfntGGefDXX1K/T+eeNVlDIiix03yEZ9diVD0mFytAxRZQ8wxHHuIyFSgcut9aVaGi0IZRSOnu3J5V7NLuWLKfoDE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1710147733; c=relaxed/simple;
	bh=S09szmafs7jjOaqSKi0Bqvlh6s1OEW3Q2TZcfx1g8w8=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=OO1tV8qS5STdp2EqR2j9EPC9AsULGnZFzVDW5iixSXk4cho9WSGz4bHrKwP49iuNnVrSbqWETHOCeZr3Q4LinDolFOIQhcIiLx9ZVxDGQcFTnSm6zJ1Neu4j8wH0pqfSp/gGA7iy7Z1ZMzomwgEdhwJaGSy/Ugd8VReE/TXim4Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=valentin-vidic.from.hr; spf=pass smtp.mailfrom=valentin-vidic.from.hr; dkim=pass (4096-bit key) header.d=valentin-vidic.from.hr header.i=@valentin-vidic.from.hr header.b=eu35VxhB; arc=none smtp.client-ip=116.203.65.182
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=valentin-vidic.from.hr
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=valentin-vidic.from.hr
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (4096-bit key) header.d=valentin-vidic.from.hr header.i=@valentin-vidic.from.hr header.b="eu35VxhB"
X-Virus-Scanned: Debian amavis at valentin-vidic.from.hr
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
	d=valentin-vidic.from.hr; s=2020; t=1710147721;
	bh=S09szmafs7jjOaqSKi0Bqvlh6s1OEW3Q2TZcfx1g8w8=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=eu35VxhBMA1YGydwNb7JhOvckxGzjFkraybp8REydh+lmzPYZudgomMu3NhE0hhvo
	 FLnMeMgVSG/dDlYCUAE1+2tQ3CxvqDIfTkDDJfreYyuplPJ0UBuWtbOuk5YhcfSx47
	 t/2kB8XAMhRb9i4jqfuvUI+4c62+Ra85GR9zmeVh6Rx0QafkKxv1yrMNHjiIj9MuVq
	 nbba71xCYQII3zYnI6YTNYvCnJ/8TVO1WexpdmMoOSyEP2Wf1kitsATe6a5v9ehF2Y
	 WF7kXOdSq8PM/k9Q6KQ+fdEddHTiH6P8RUlzjZvxnnRb5cjFWnGkFQxXq5nJ3x/AcP
	 MhfVAMVmUF6cssRm1ZQ6sA9Y00R0Dej/wDJ1avtCAQMXqf7PohFO/xTQ2IVGR9TDH6
	 o1APCDPE+i+g6YLzOdFngjXwlSmIveL1cp7jr7tp/U7+c/28dkJXd0vACIc8EzhK7u
	 qEgKDuNbt40UUeLuZMarnsgMLiE8iDoBbC1a2lxMT4IopISQUpBuAO6o9VkcV9pI6M
	 Gx1V5jtBBqVdtCmxZ5ogtCjeeTRuZUrp8cQBaeoTVALFDVYW3/H6jojDFW6+1pPRdi
	 km9XBdxOUFBEoKIys50Hpk89gfMMzxZcj4I98vcmYkJhfJ6b1tuMlg6OvptSA/ZnuD
	 t+F2bQ6oPK1CK8afuZCpdHmI=
Received: by valentin-vidic.from.hr (Postfix, from userid 1000)
	id E47632CDCE; Mon, 11 Mar 2024 10:02:01 +0100 (CET)
Date: Mon, 11 Mar 2024 10:02:01 +0100
From: Valentin =?utf-8?B?VmlkacSH?= <vvidic@valentin-vidic.from.hr>
To: Joseph Qi <joseph.qi@linux.alibaba.com>
Cc: ocfs2-devel@oss.oracle.com, Alexander Aring <aahringo@redhat.com>,
	David Teigland <teigland@redhat.com>, gfs2@lists.linux.dev,
	ocfs2-devel@lists.linux.dev
Subject: Re: ocfs2 mount error
Message-ID: <Ze7IiZmlhRaOgdhm@valentin-vidic.from.hr>
References: <Ze4qSvzGJDt5yxC3@valentin-vidic.from.hr>
 <49396145-712d-44eb-884e-58eb19b1f4f2@linux.alibaba.com>
Precedence: bulk
X-Mailing-List: ocfs2-devel@lists.linux.dev
List-Id: <ocfs2-devel.lists.linux.dev>
List-Subscribe: <mailto:ocfs2-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:ocfs2-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <49396145-712d-44eb-884e-58eb19b1f4f2@linux.alibaba.com>

On Mon, Mar 11, 2024 at 04:37:39PM +0800, Joseph Qi wrote:
> It seems that you are using fsdlm.
> But from your running commands, I don't see how fsdlm get involved.
> Could you please give more detail on how to reproduce it?

Sure, this is the original Pacemaker test script that failed:

https://salsa.debian.org/ha-team/ocfs2-tools/-/blob/master/debian/tests/pcmk?ref_type=heads

Basically it starts Corosync and DLM services and than calls:

mkfs.ocfs2
fsck.ocfs2
mount.ocfs2

-- 
Valentin
