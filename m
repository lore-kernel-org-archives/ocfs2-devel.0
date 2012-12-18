From: Theodore Ts'o <tytso@mit.edu>
Date: Tue, 18 Dec 2012 15:51:27 -0500
Subject: [Ocfs2-devel] [RFC PATCH] ext3, ext4,
	ocfs2: remove unused macro NAMEI_RA_INDEX
In-Reply-To: <20121218174811.GC5987@quack.suse.cz>
References: <1355820999-27972-1-git-send-email-yan@linux.vnet.ibm.com>
	<20121218174811.GC5987@quack.suse.cz>
Message-ID: <20121218205127.GA5125@thunk.org>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Jan Kara <jack@suse.cz>
Cc: Mark Fasheh <mfasheh@suse.com>, akpm@linux-foundation.org, linux-ext4@vger.kernel.org, Guo Chao <yan@linux.vnet.ibm.com>, ocfs2-devel@oss.oracle.com

On Tue, Dec 18, 2012 at 06:48:11PM +0100, Jan Kara wrote:
> On Tue 18-12-12 16:56:39, Guo Chao wrote:
> > This macro, initially introduced by ext2 in v0.99.15, does not
> > have any users from the beginning. It has been removed in later
> > ext2 version but still remains in the code of ext3, ext4, ocfs2.
> > Remove this macro there.
>   Thanks. I've merged the patch into my tree. Since it's trivial, I guess
> other fs maintainers won't mind.

Acked-by: "Theodore Ts'o" <tytso@mit.edu>

Thanks, Jan!

					- Ted
