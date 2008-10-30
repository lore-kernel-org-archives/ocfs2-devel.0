From: Jan Kara <jack@suse.cz>
Date: Thu, 30 Oct 2008 08:33:39 +0100
Subject: [Ocfs2-devel] [PATCH 25/29] ocfs2: Implementation of local
	and	global quota file handling
In-Reply-To: <20081029105139.GA10080@ca-server1.us.oracle.com>
References: <122488610212-git-send-email-jack@suse.cz>
	<12248861041077-git-send-email-jack@suse.cz>
	<20081028193652.GD17578@mail.oracle.com>
	<20081029022902.GE24732@duck.suse.cz>
	<20081029105139.GA10080@ca-server1.us.oracle.com>
Message-ID: <20081030073339.GD14500@duck.suse.cz>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

On Wed 29-10-08 03:51:39, Joel Becker wrote:
> On Wed, Oct 29, 2008 at 03:29:02AM +0100, Jan Kara wrote:
> > > > +/* Structure with global user / group information. We reserve some space
> > > > + * for future use. */
> > > > +struct ocfs2_global_disk_dqblk {
> > > > +/*00*/	__le32 dqb_id;          /* ID the structure belongs to */
> > > > +	__le32 dqb_use_count;   /* Number of nodes having reference to this structure */
> > > > +	__le64 dqb_ihardlimit;  /* absolute limit on allocated inodes */
> > > > +/*10*/	__le64 dqb_isoftlimit;  /* preferred inode limit */
> > > > +	__le64 dqb_curinodes;   /* current # allocated inodes */
> > > > +/*20*/	__le64 dqb_bhardlimit;  /* absolute limit on disk space */
> > > > +	__le64 dqb_bsoftlimit;  /* preferred limit on disk space */
> > > > +/*30*/	__le64 dqb_curspace;    /* current space occupied */
> > > > +	__le64 dqb_btime;       /* time limit for excessive disk use */
> > > > +/*40*/	__le64 dqb_itime;       /* time limit for excessive inode use */
> > > > +	__le64 dqb_pad1;
> > > > +/*50*/	__le64 dqb_pad2;
> > > > +};
> > > 
> > > 	We also need space for the ecc data here.  It looks like ecc
> > > space wasn't added to this series.  Rather than comment on each
> > > structure, just let me know when that's ready.
> >   What I did is, that in the end of each quotafile block there are 8 bytes
> > reserved for OCFS2 use (both in local and global quota files). So these
> > bytes are intended to be used for ECC. I hope that's fine.
> 
> 	So every block type (disk header, dq_block, etc) has the last 8
> bytes free?
  Yes.

> This seems like something we should find a way to mention
> in the disk header.
  You mean like in the ocfs2_fs.h file? There is already a constant and
a comment in quota.h, but probably it makes sence to move it to ocfs2_fs.h.

								Honza
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR
