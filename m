Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 502383A2E2B
	for <ocfs2-devel@lists.linux.dev>; Tue, 28 Jul 2026 04:18:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785212334; cv=none; b=hGW9BB8BJcXYaWG1pa6hxJBIDfnTT9vcLPiRjRTj+E27lSSjigbNlWJugF8A927w9T3zO+W2yE9LJfeTR5uSIM//RCeZjva1Pbhm/Jdt968m256cgpiRDycFsztrXUkyspMSv7/dcX2YcNoNLAQ2/cdjTHbUrwD0mjFD7kixAn4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785212334; c=relaxed/simple;
	bh=Wu6qHAqCpZEgiLkaXywvL3VG+9hcmbOAOAORE65Asgs=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=lRt8Uq5e+f2rEcYrZHdI+z48HVd5kZA8cXg7gtn+UO8UUWRHy2ju1CaBAWtPF2QmIFLar2wEIJrPDiw3BtvYp60aDk9jyDhDPv9Vl8eiOH4QcEbi9WwiaqIk/+PPZ6xdiZuxtyZYFDBPdh7//wOIXTqoV4qJDwAOdaIyNYnIDOo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id A08E468AFE; Tue, 28 Jul 2026 06:18:49 +0200 (CEST)
Date: Tue, 28 Jul 2026 06:18:49 +0200
From: Christoph Hellwig <hch@lst.de>
To: Heming Zhao <heming.zhao@suse.com>
Cc: joseph.qi@linux.alibaba.com, mark@fasheh.com, jlbec@evilplan.org,
	hch@lst.de, ocfs2-devel@lists.linux.dev,
	linux-kernel@vger.kernel.org
Subject: Re: [RFC PATCH v2 3/4] ocfs2: switch dio write path from
 buffer_head to iomap
Message-ID: <20260728041849.GC19573@lst.de>
References: <20260727061802.18485-1-heming.zhao@suse.com> <20260727061802.18485-4-heming.zhao@suse.com>
Precedence: bulk
X-Mailing-List: ocfs2-devel@lists.linux.dev
List-Id: <ocfs2-devel.lists.linux.dev>
List-Subscribe: <mailto:ocfs2-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:ocfs2-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260727061802.18485-4-heming.zhao@suse.com>
User-Agent: Mutt/1.5.17 (2007-11-01)

On Mon, Jul 27, 2026 at 02:17:59PM +0800, Heming Zhao wrote:
> This patch converts OCFS2's DIO write path from the legacy
> buffer_head infrastructure to the modern iomap framework.
> 
> Key modifications and designs are as follows:
> 
> 1. Dynamic Context Allocation:

This reads like complete AI slop.  Please turn this into a coherent
commit message without the lists and exaggerations.

I'll try to read that before reading the commit, because it kinda
implies a lack of understing by anyone what actually happens.

So please try to understand what you're doing or had your tool do,
then write it down and re-review if the code makes sense based
on that.

