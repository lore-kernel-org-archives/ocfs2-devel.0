From: Miklos Szeredi <miklos@szeredi.hu>
Date: Tue, 15 Sep 2009 08:44:36 +0200
Subject: [Ocfs2-devel] [GIT PULL] ocfs2 changes for 2.6.32
In-Reply-To: <alpine.LFD.2.01.0909141417180.4950@localhost.localdomain>
	(message from Linus Torvalds on Mon, 14 Sep 2009 14:32:36 -0700 (PDT))
References: <20090911200458.GA15416@mail.oracle.com>
	<alpine.LFD.2.01.0909141417180.4950@localhost.localdomain>
Message-ID: <E1MnRmG-0005j1-Bs@pomaz-ex.szeredi.hu>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: torvalds@linux-foundation.org
Cc: Joel.Becker@oracle.com, mfasheh@suse.com, akpm@linux-foundation.org, linux-kernel@vger.kernel.org, ocfs2-devel@oss.oracle.com

On Mon, 14 Sep 2009, Linus Torvalds wrote:
> Are we going to add 'freflink[at]()' at some point?

We already have an interface for "freflink()" called splice().  Splice
has all the arguments needed to implement refcounted data copies and
more.

Yes, splice's name implies more of a "piecing data together" type of
operation, but we can look at reflink() or copyfile() as just "splice
one big piece from here to there".

Thanks,
Miklos
