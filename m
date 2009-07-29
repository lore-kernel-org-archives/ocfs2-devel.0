From: Jan Kara <jack@suse.cz>
Date: Wed, 29 Jul 2009 11:58:46 +0200
Subject: [Ocfs2-devel] [PATCH 4/8] Write out quota info changes on
	ocfs2_close()
In-Reply-To: <20090728225356.GB20595@mail.oracle.com>
References: <1248717216-26617-1-git-send-email-jack@suse.cz>
	<1248717216-26617-5-git-send-email-jack@suse.cz>
	<20090728225356.GB20595@mail.oracle.com>
Message-ID: <20090729095846.GC19209@duck.suse.cz>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

On Tue 28-07-09 15:53:56, Joel Becker wrote:
> On Mon, Jul 27, 2009 at 07:53:32PM +0200, Jan Kara wrote:
> > We don't write out change of information in quota file header on each change,
> > we rather cache it in ocfs2_filesys structure. So write out all the
> > information when ocfs2_close() is called.
> > 
> > Signed-off-by: Jan Kara <jack@suse.cz>
> 
> This looks good as long as all quota ops keep those ocfs2_cached_inodes
> up to date.
  Yes, all quota ops use only these cached inodes so it should be fine.

									Honza
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR
