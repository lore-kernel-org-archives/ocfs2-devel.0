Received: from outgoing.mit.edu (outgoing-auth-1.mit.edu [18.9.28.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9EB9137C
	for <ocfs2-devel@lists.linux.dev>; Tue,  8 Aug 2023 14:38:22 +0000 (UTC)
Received: from cwcc.thunk.org (pool-173-48-112-100.bstnma.fios.verizon.net [173.48.112.100])
	(authenticated bits=0)
        (User authenticated as tytso@ATHENA.MIT.EDU)
	by outgoing.mit.edu (8.14.7/8.12.4) with ESMTP id 378EXcUK010681
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 8 Aug 2023 10:33:40 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=mit.edu; s=outgoing;
	t=1691505224; bh=POsuLKf+nXyR7IYhWeM46kPBqQcMGC9ufKCQTBFFtf0=;
	h=Date:From:Subject:Message-ID:MIME-Version:Content-Type;
	b=cOrIQ7oNj6T1c0fsinQ9p/311Q2F4m5/0q05C1455WuPyH2K8UBnhKJSDFgrMhlQ2
	 95TCUswKGgeZ93icN/qFXvZ4PFIeVLvTqCyGJSkr5/Hz0zYndnZqjL+0GCFPb23rJo
	 mjok7gxFN5RVi2v0bSORo46pgcUAdq3jATQ1GBTdLppGxI2uy1+snUAiJHOa6PXRdA
	 j1Bzi2Llx5MGVf77KB/v6kg5g7aPiYYs5cyk5rkLLtv475/vyR4enLzw5BWIelvh61
	 K1tPTIQp1NAuPNLVO7zDo+czKmufwg3QuqGqX35UsCq0La0KCC/YHTY44JHDVK3fYl
	 a89nfd/rhOeZQ==
Received: by cwcc.thunk.org (Postfix, from userid 15806)
	id ABF4415C04F2; Tue,  8 Aug 2023 10:33:38 -0400 (EDT)
Date: Tue, 8 Aug 2023 10:33:38 -0400
From: "Theodore Ts'o" <tytso@mit.edu>
To: Christoph Hellwig <hch@lst.de>
Cc: Al Viro <viro@zeniv.linux.org.uk>, Christian Brauner <brauner@kernel.org>,
        Andreas Dilger <adilger.kernel@dilger.ca>,
        Mark Fasheh <mark@fasheh.com>, Joel Becker <jlbec@evilplan.org>,
        Joseph Qi <joseph.qi@linux.alibaba.com>, Jens Axboe <axboe@kernel.dk>,
        linux-fsdevel@vger.kernel.org, linux-ext4@vger.kernel.org,
        ocfs2-devel@lists.linux.dev, linux-block@vger.kernel.org
Subject: Re: [PATCH 2/4] ext4: don't use bdev->bd_super in
 __ext4_journal_get_write_access
Message-ID: <20230808143338.GA1523259@mit.edu>
References: <20230807112625.652089-1-hch@lst.de>
 <20230807112625.652089-3-hch@lst.de>
Precedence: bulk
X-Mailing-List: ocfs2-devel@lists.linux.dev
List-Id: <ocfs2-devel.lists.linux.dev>
List-Subscribe: <mailto:ocfs2-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:ocfs2-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230807112625.652089-3-hch@lst.de>

On Mon, Aug 07, 2023 at 12:26:23PM +0100, Christoph Hellwig wrote:
> __ext4_journal_get_write_access already has a super_block available,
> and there is no need to go from that to the bdev to go back to the
> owning super_block.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>

Acked-by: Theodore Ts'o <tytso@mit.edu>
