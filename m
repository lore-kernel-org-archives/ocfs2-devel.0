From: Joel Becker <Joel.Becker@oracle.com>
Date: Wed, 9 Jun 2010 03:12:07 -0700
Subject: [Ocfs2-devel] [PATCH] ocfs2: Remove the deprecated
	inode_setattr.
In-Reply-To: <20100609093804.GY26335@laptop>
References: <1276073300-7360-1-git-send-email-tao.ma@oracle.com>
	<20100609091604.GX26335@laptop> <4C0F5F01.8010807@oracle.com>
	<20100609093804.GY26335@laptop>
Message-ID: <20100609101207.GB21239@mail.oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Nick Piggin <npiggin@suse.de>
Cc: Tao Ma <tao.ma@oracle.com>, ocfs2-devel@oss.oracle.com, linux-fsdevel@vger.kernel.org, Christoph Hellwig <hch@lst.de>

On Wed, Jun 09, 2010 at 07:38:04PM +1000, Nick Piggin wrote:
> On Wed, Jun 09, 2010 at 05:29:37PM +0800, Tao Ma wrote:
> > We have a inode_newsize_ok check at the top of ocfs2_setattr when we
> > do the real work of truncate(it is far above, so the patch can't
> > have it. ;) ). So we don't need to worry about that actually.
> 
> OK, can you comment that or just open-code the truncate part of
> simple_setsize? It should be helpful for example with Christoph's
> truncate cleanup work.

	Just open-code it.  The void calls are much nicer than useless
return code boilerplate. 

Joel

-- 

 One look at the From:
 understanding has blossomed
 .procmailrc grows
	- Alexander Viro

Joel Becker
Principal Software Developer
Oracle
E-mail: joel.becker at oracle.com
Phone: (650) 506-8127
