Received: from outgoing.mit.edu (outgoing-auth-1.mit.edu [18.9.28.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1C58E20F15
	for <ocfs2-devel@lists.linux.dev>; Wed, 23 Aug 2023 04:02:22 +0000 (UTC)
Received: from letrec.thunk.org (c-73-8-226-230.hsd1.il.comcast.net [73.8.226.230])
	(authenticated bits=0)
        (User authenticated as tytso@ATHENA.MIT.EDU)
	by outgoing.mit.edu (8.14.7/8.12.4) with ESMTP id 37N41VC1022318
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 23 Aug 2023 00:01:33 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=mit.edu; s=outgoing;
	t=1692763295; bh=OzWMJg/ydyEcrUOOeGzh76mItaztrAmxDAll6g6UEOY=;
	h=Date:From:Subject:Message-ID:MIME-Version:Content-Type;
	b=JZ9J1w8jaOjfWVA2hyMs9KvcWit+G8V+4pDEjFWSo+JhSOM7pdK/MWK9IOzo5FXAE
	 IC+FBW8OkmJxEH4WeZWlowoG2VBeyOTw7nJa9ClNRchL2sQw7/Xv0/jcTzF5dQCXtR
	 id+PZ7OlCv6ZapfVzBfdLIuBCpwOOGGJC4Esvqrbfy8I4vNEu8bFNz7QL5bXgm235N
	 0sv6lKqRGLfG5F9fpx5clEnFPk7akJ1pA31FDK9Lbn0Kz3JpuPMu0CWwX8ZipsHH1u
	 cE5u5grcYLodhmQpoWuUSb/aoKw8D8V8FpY8zX7rtSQ8Q0I38y9DD3M7Xyk5dsUSOs
	 HfFj2UKjZBSfQ==
Received: by letrec.thunk.org (Postfix, from userid 15806)
	id EAC928C0227; Wed, 23 Aug 2023 00:01:30 -0400 (EDT)
Date: Wed, 23 Aug 2023 00:01:30 -0400
From: "Theodore Ts'o" <tytso@mit.edu>
To: Yang Yingliang <yangyingliang@huawei.com>
Cc: ocfs2-devel@lists.linux.dev, mark@fasheh.com, jlbec@evilplan.org,
        joseph.qi@linux.alibaba.com, yi.zhang@huawei.com, jack@suse.cz
Subject: Re: [PATCH -next] jbd2,ocfs2: fix wrong pointer pass to PTR_ERR()
Message-ID: <ZOWEmsimCgWY+bT0@mit.edu>
References: <20230822030018.644419-1-yangyingliang@huawei.com>
Precedence: bulk
X-Mailing-List: ocfs2-devel@lists.linux.dev
List-Id: <ocfs2-devel.lists.linux.dev>
List-Subscribe: <mailto:ocfs2-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:ocfs2-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230822030018.644419-1-yangyingliang@huawei.com>

Thanks for pointing this out; I've folded your fix into buggy commit
("jbd2: jbd2_journal_init_{dev,inode} return proper error return
value").

						- Ted
