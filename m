From: Mark Fasheh <mfasheh@suse.com>
Date: Tue, 22 Jun 2010 09:53:42 -0700
Subject: [Ocfs2-devel] [PATCH] Track negative dentries
In-Reply-To: <20100622032333.GA2403@laptop.cn.oracle.com>
References: <AANLkTilwWhweSS4BxXZCQxCAicETuZ2rjFb_BHMM3YGZ@mail.gmail.com>
	<20100621042716.GA2735@laptop.us.oracle.com>
	<4C1F9C74.1060403@oracle.com>
	<20100622032333.GA2403@laptop.cn.oracle.com>
Message-ID: <20100622165342.GH28091@wotan.suse.de>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

On Tue, Jun 22, 2010 at 11:23:33AM +0800, Wengang Wang wrote:
> Actually I meant two dentries in the two run of 'ls -l'.
> At the first run, a dentry, dentry A, is created. Because fileA doesn't exist,
> dentry->d_inode is NULL.

Ok so you do a lookup on a name which doesn't exist, which results in a
negative dentry for fileA.

> Then a do_revalidate() is run, ocfs2_dentry_revalidate() returns "not
> valid" since d_inode is NULL. Thus the dentry A is unhashed from cache by
> d_invalidate().

Part of the patch is to change this behavior right here.

ocfs2_dentry_revalidate() is seeing the NULL inode and forcing the dentry to
be invalidated (thus requiring another lookup).


The patch needs to handle this by comparing sequence numbers with the parent
dentry and ONLY if they're different should it force the dentry to be
invalidated. Otherwise it can allow the dentry to stay hashed (and
negative).
	--Mark

--
Mark Fasheh
