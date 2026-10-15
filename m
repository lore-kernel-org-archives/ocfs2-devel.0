Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8B3065540A2;
	Thu, 15 Oct 2026 19:32:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792092722; cv=none; b=KlxtpriWESYSPegn0CBVAKJLLa6qxVWdwrGgi2hLSdBRjid8iyOAuTk3or05iWf6xdcQdv2kuW0pEX6Gqzii+SJo+A1QB/+UOxCJIWtCAgEkjnOSLMn8bI9SCX6ebXnO/q0V1LXGT5dTVE0IfUPm16BxaWmn4UJ+0ee/aJ9hH9U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792092722; c=relaxed/simple;
	bh=2Q+cimhHKhI/VeaWxNwEHQLFAvb2miY1YkqAZxtTGbw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=R3ShoGiAX0ldQ9ACMMdyFEE/9LvxwraPt2OsMRpX14ixqY6gBkMLQkLIuDfKaYCozMq+ee93IZ/hddBFhAVHqNoB7EbdUgqdrhGYplqWT2ROzniR8xl/dHP/czR5yrtPrX9PAsDgENv6l65hoS1LbctgWYeB5OOCRgTdlZRj/yc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=ePtsflbu; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="ePtsflbu"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4AE8B1F000C4;
	Thu, 15 Oct 2026 19:32:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792092720;
	bh=1eok6myQUDqp+XsFCNTMkIw/ums/eYdOjqaV10hDc/c=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=ePtsflbuNf9UEoG/rwTMSZvfZ6h6UWU4Itj4R8NXNKw2Q6UDMkeRdf7OmxOcfnizr
	 1tYEC1zOUa25g5b3aYC8WEy/weG4E0XcLT4lzjleqHr+Cd3YXSdWhxhxdf1unu2dF4
	 KOCPghA66bokRNDE5rmoZCWtPmEjbaaqsHvtTg0ftn4NcIfQG2JKSsmAbHIFdrPDee
	 xibH4NV8BeJILjTSEk9plczPmy2K/mpzfSn+H/0ViQ0vrPcWUvy34oet9OYWJOizKa
	 0pGp/W7JAWJfkaroHNDsLGYTB6/AhpHqI2pTen857SE7DIT2JgUYcpITiFhNl7wgpm
	 WhholyEULRBMA==
Date: Thu, 15 Oct 2026 12:31:59 -0700
From: Kees Cook <kees@kernel.org>
To: Cen Zhang <zzzccc427@gmail.com>
Cc: mark@fasheh.com, jlbec@evilplan.org, joseph.qi@linux.alibaba.com,
	heming.zhao@suse.com, akpm@linux-foundation.org,
	kmehltretter@gmail.com, christophe.jaillet@wanadoo.fr,
	ericterminal@gmail.com, rppt@kernel.org, rollkingzzc@gmail.com,
	brauner@kernel.org, sunil.mushran@oracle.com,
	kurt.hackel@oracle.com, jack@suse.cz, ocfs2-devel@lists.linux.dev,
	linux-kernel@vger.kernel.org, stable@vger.kernel.org,
	baijiaju1990@gmail.com, jjzuming@gmail.com
Subject: Re: [PATCH v2] ocfs2: Pin owning modules for open debugfs files
Message-ID: <202610151231.3D8F9A63@keescook>
References: <pm-ocfs2-objects-candidate-0089-v5-076c780eeaf45afb2a53@gmail.com>
Precedence: bulk
X-Mailing-List: ocfs2-devel@lists.linux.dev
List-Id: <ocfs2-devel.lists.linux.dev>
List-Subscribe: <mailto:ocfs2-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:ocfs2-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <pm-ocfs2-objects-candidate-0089-v5-076c780eeaf45afb2a53@gmail.com>

On Fri, Oct 16, 2026 at 12:42:32AM +0800, Cen Zhang wrote:
>  static const struct file_operations o2hb_debug_fops = {
> +	.owner = THIS_MODULE,
>  	.open =		o2hb_debug_open,
>  	.release =	o2hb_debug_release,
>  	.read =		o2hb_debug_read,

Please match the indentation of neighboring member assignments through-out.

-- 
Kees Cook
