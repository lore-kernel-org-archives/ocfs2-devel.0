From: Jan Kara <jack@suse.cz>
Date: Fri, 31 Oct 2008 06:00:43 +0100
Subject: [Ocfs2-devel] [PATCH 25/29] ocfs2: Implementation of local
	and	global quota file handling
In-Reply-To: <20081030203121.GA32103@mail.oracle.com>
References: <122488610212-git-send-email-jack@suse.cz>
	<12248861041077-git-send-email-jack@suse.cz>
	<20081028193652.GD17578@mail.oracle.com>
	<20081029022902.GE24732@duck.suse.cz>
	<20081029105139.GA10080@ca-server1.us.oracle.com>
	<20081030073339.GD14500@duck.suse.cz>
	<20081030203121.GA32103@mail.oracle.com>
Message-ID: <20081031050043.GB4476@duck.suse.cz>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

On Thu 30-10-08 13:31:21, Joel Becker wrote:
> On Thu, Oct 30, 2008 at 08:33:39AM +0100, Jan Kara wrote:
> > On Wed 29-10-08 03:51:39, Joel Becker wrote:
> > > On Wed, Oct 29, 2008 at 03:29:02AM +0100, Jan Kara wrote:
> > > >   What I did is, that in the end of each quotafile block there are 8 bytes
> > > > reserved for OCFS2 use (both in local and global quota files). So these
> > > > bytes are intended to be used for ECC. I hope that's fine.
> > > 
> > > 	So every block type (disk header, dq_block, etc) has the last 8
> > > bytes free?
> >   Yes.
> > 
> > > This seems like something we should find a way to mention
> > > in the disk header.
> >   You mean like in the ocfs2_fs.h file? There is already a constant and
> > a comment in quota.h, but probably it makes sence to move it to ocfs2_fs.h.
> 
> 	Well, if other filesystems get it via quota.h too, it should
> stay there.  Perhaps just a comment in ocfs2_fs.h about it so readers
> are aware.
  No - it is OCFS2-specific constant in OCFS2-specific quota header. I've
moved the constant to ocfs2_fs.h since it defines disk format in a way...

								Honza
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR
