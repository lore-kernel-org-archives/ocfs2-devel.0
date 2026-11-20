Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=213.95.11.211
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795199660;
	b=HPZ2NllpHoqNUoNCvj16rz3O9/QqovxayY8pHTLUjNG2rhduiqXA5gWnFI/6ahpUW7h6
	 TiTfHR421shxxcO6tfqcpK7XMrX6GlhplhLc9EOFQcwRjXoSf5OvrESiN4k35DZktguZd
	 PJTIVssBJzfPwmLZmRSHUr3SbzWjlW2NCuCD4O7xKcEv6+YyDfX5PZqJUKFtq5gqfnaZ4
	 JLfFFkncBR5h0FfWQqZgBCJlB5VcBdIh7HiVYYr1EPzk6NChN+K7gpOrq15v7I6nUFp2d
	 e6si/P4xhVYUufeKFa3Mzglrgn6bLyfM4Lzx7o1fHOgJsQfRHcCUFByMvqYjxprlTJA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795199660;
	h=DMARC-Filter:Received:Date:From:To:Cc:Subject:Message-ID:References:
	 MIME-Version:Content-Type:Content-Disposition:In-Reply-To:User-Agent;
	bh=IEZ0ox5r8LdG2Sd8SJBg61Hr10YfqdEQnggc1lNOx3c=;
	b=peIWGoGIbeMAYf2cIzJxpC0n2jl/KM2tBKzEe3JV4evUgpytVGREpD1pVjweYeD3U68N
	 mOXW9f72T+PaV5zYKaPU3QEUOAbbKe5SiESVdpspRK1GvuCzsrMAPVpBr82oMtIInKJth
	 e4qha0ajrnwosVUmAFKFnjKzUiIBrIZJKShaqP4X0YVUEi3FTgOrLPUQks2kfVHTVUhxq
	 VvFqCZ+a22z5kKAZSzi1n8fx6veig2Janq4PuVW/f46kV1IACv5ZguxqAwmJorq8Oru8e
	 7dUmjylVdxNL/eh3EAbAJRPInkwb4Jypxo5bytr4By5pHFf5q49VGZ3lfjLmx/lBRqg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=lst.de;
	spf=pass smtp.mailfrom=lst.de;
	arc=none smtp.remote-ip=213.95.11.211
Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 35F1460A2601
	for <ocfs2-devel@lists.linux.dev>; Fri, 20 Nov 2026 18:34:20 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 35F1460A2601
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id D42086732A; Fri, 20 Nov 2026 19:34:15 +0100 (CET)
Date: Fri, 20 Nov 2026 19:34:15 +0100
From: Christoph Hellwig <hch@lst.de>
To: Heming Zhao <heming.zhao@suse.com>
Cc: joseph.qi@linux.alibaba.com, mark@fasheh.com, jlbec@evilplan.org,
	ocfs2-devel@lists.linux.dev, linux-kernel@vger.kernel.org
Subject: Re: [RFC PATCH v9 1/3] ocfs2: Add new ocfs2_map_blocks() to
 introduce iomap feature
Message-ID: <20261120183415.GA2450@lst.de>
References: <20261120060014.12087-1-heming.zhao@suse.com> <20261120060014.12087-2-heming.zhao@suse.com>
X-Mailing-List: ocfs2-devel@lists.linux.dev
List-Id: <ocfs2-devel.lists.linux.dev>
List-Post: <mailto:ocfs2-devel@lists.linux.dev>
List-Help: <mailto:ocfs2-devel+help@lists.linux.dev>
List-Subscribe: <mailto:ocfs2-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:ocfs2-devel+unsubscribe@lists.linux.dev>
List-Owner: <mailto:ocfs2-devel+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20261120060014.12087-2-heming.zhao@suse.com>
User-Agent: Mutt/1.5.17 (2007-11-01)

On Fri, Nov 20, 2026 at 02:00:11PM +0800, Heming Zhao wrote:
> As part of migrating OCFS2 DIO read/write code paths towards the modern
> and performant iomap framework, here introduces ocfs2_map_blocks() to
> replace the legacy, high-overhead buffer_head based block mapping
> routines.

Do you have numbers to antiy the high overhead?  Or should this be toned
down a bit?

> In addition, OCFS2_MAP_* flags are defined to gridge OCFS2 internal block
> mapping flags with the iomap API requirements.

"gridge"?

Otherwise looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>
