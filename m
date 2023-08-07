Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 96656D52D
	for <ocfs2-devel@lists.linux.dev>; Mon,  7 Aug 2023 12:45:47 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 716E5C433C8;
	Mon,  7 Aug 2023 12:45:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1691412347;
	bh=pMGmT/Pou6cIXNxMdsIaUSmMDmATLx/PEP2zAeUDuX8=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=sHETf0uokHvoUHbhzYLDcSFcC4vi7PEbJ04Mo71aUABVSfk/V/PTwVS/UIpHyGprP
	 ryL5sQTIUOdivJhNyFqjhwODP9uuPU9AG7EezC9YSOOMiNKFak20m4Bvj6qCw8AxM2
	 TKpK97mhg6k13SPOyKAKRDNOqxSGcLobCxbKmqFnemyN4RlEcQVYt9LkKx/D7BYxEh
	 nickfShRB+v2c59KrbiC8PyUWm5fCJBjBC9RjR8IynGY4hccKZZgd/V7jKMcWAs5hJ
	 dr+EjnVtVddP6eLRKkm74zfm5vr2wW5pdnvnFgKmOSVJBR1455bwqCdUVVebLc4XgF
	 GPVbin0EDplrQ==
Date: Mon, 7 Aug 2023 14:45:41 +0200
From: Christian Brauner <brauner@kernel.org>
To: Christoph Hellwig <hch@lst.de>
Cc: Al Viro <viro@zeniv.linux.org.uk>, Theodore Ts'o <tytso@mit.edu>,
	Andreas Dilger <adilger.kernel@dilger.ca>,
	Mark Fasheh <mark@fasheh.com>, Joel Becker <jlbec@evilplan.org>,
	Joseph Qi <joseph.qi@linux.alibaba.com>,
	Jens Axboe <axboe@kernel.dk>, linux-fsdevel@vger.kernel.org,
	linux-ext4@vger.kernel.org, ocfs2-devel@lists.linux.dev,
	linux-block@vger.kernel.org
Subject: Re: [PATCH 4/4] fs, block: remove bdev->bd_super
Message-ID: <20230807-riesig-wehrlos-9f90c87d9a09@brauner>
References: <20230807112625.652089-1-hch@lst.de>
 <20230807112625.652089-5-hch@lst.de>
Precedence: bulk
X-Mailing-List: ocfs2-devel@lists.linux.dev
List-Id: <ocfs2-devel.lists.linux.dev>
List-Subscribe: <mailto:ocfs2-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:ocfs2-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20230807112625.652089-5-hch@lst.de>

On Mon, Aug 07, 2023 at 12:26:25PM +0100, Christoph Hellwig wrote:
> bdev->bd_super is unused now, remove it.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> ---

Looks good to me,
Reviewed-by: Christian Brauner <brauner@kernel.org>
