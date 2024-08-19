Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EF3B815DBC1;
	Mon, 19 Aug 2024 22:12:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724105550; cv=none; b=oKEHAQ7VMrtAwNviEU8uuLqJs/cdIDTto3CShr5xNZQAonp/C0i9Jz/c/+ZSlFKdr//vINfhCJWoJ+yyX25rZ9vp801LMsN/zdmIQvHKKmavRJ59WtPW+FYKKAFHmsi/leWsy3YjKvUqeTW8F2eCDLp628xt3iGHfCk8kj7Nqfo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724105550; c=relaxed/simple;
	bh=mOCSROjK77ZUEQOVe4BWD0EOfDX+YvbVKxsURSW04xs=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=plAWQXaSvIOKmQwTLTbu02LDN3wTxaj/+zxBbSWbRysmWeJznL91I4asztu/Pzuc4nmNhFIvqKzgqe0Ut0N7IuHtuShIGJ/SdT5+mHpB9wNETYxyfo98s0CvpZXwUob5HaWrUKR1pwU5piIDli7RFu2CMxlxKaGH+iiacdpyMmc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=PeXJCiNY; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="PeXJCiNY"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C73DCC32782;
	Mon, 19 Aug 2024 22:12:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1724105549;
	bh=mOCSROjK77ZUEQOVe4BWD0EOfDX+YvbVKxsURSW04xs=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=PeXJCiNY7p8gFVHA/JqXkV4txa1ieQg1VHwf0npNL5pTt1ematMVCGI9z2itHoarr
	 OEPT9hZaQcPFA1KKKeQFg7xKkAiVrh5rIXW0CaIPzQ3A08bn0s2MHWtFTPojwsE7Am
	 5yApOQUHQ7rGKzzduviJgpiA8HnAjW3h/+7VUC+4lut/cLQKxKEOTzZQUDaG3u3skm
	 3Rd4azSz8fH4W2rUAW+Upc5PtXFz6fjOW9N7oh0TpH7n29LLDHsMapIcmkqKeMTFn2
	 4pcnm+E6qz7sd7mptNlVbbmJ/z9r8TBZ2JUuHutcECUzbGBlIDiiXaE6cmBSdeJZId
	 HKmFJMrqeMkOw==
Date: Mon, 19 Aug 2024 15:12:27 -0700
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
Message-ID: <20240819151227.4d7f9e99@kernel.org>
In-Reply-To: <20240819183742.2263895-12-aahringo@redhat.com>
References: <20240819183742.2263895-1-aahringo@redhat.com>
	<20240819183742.2263895-12-aahringo@redhat.com>
Precedence: bulk
X-Mailing-List: ocfs2-devel@lists.linux.dev
List-Id: <ocfs2-devel.lists.linux.dev>
List-Subscribe: <mailto:ocfs2-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:ocfs2-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Mon, 19 Aug 2024 14:37:41 -0400 Alexander Aring wrote:
> Recent patches introduced support to separate DLM lockspaces on a per
> net-namespace basis. Currently the file based configfs mechanism is used
> to configure parts of DLM. Due the lack of namespace awareness (and it's
> probably complicated to add support for this) in configfs we introduce a
> socket based UAPI using "netlink". As the DLM subsystem offers now a
> config layer it can simultaneously being used with configfs, just that
> nldlm is net-namespace aware.
> 
> Most of the current configfs functionality that is necessary to
> configure DLM is being adapted for now. The nldlm netlink interface
> offers also a multicast group for lockspace events NLDLM_MCGRP_EVENT.
> This event group can be used as alternative to the already existing udev
> event behaviour just it only contains DLM related subsystem events.
> 
> Attributes e.g. nodeid, port, IP addresses are expected from the user
> space to fill those numbers as they appear on the wire. In case of DLM
> fields it is using little endian byte order.
> 
> The dumps are being designed to scale in future with high numbers of
> members in a lockspace. E.g. dump members require an unique lockspace
> identifier (currently only the name) and nldlm is using a netlink dump
> behaviour to be prepared if all entries may not fit into one netlink
> message.

Did you consider using the YAML spec stuff to code gen the policies 
and make user space easier?
