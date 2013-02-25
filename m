From: Zach Brown <zab@zabbo.net>
Date: Mon, 25 Feb 2013 09:14:35 -0800
Subject: [Ocfs2-devel] [RFC PATCH 0/3] copy-on-write extents mapping
In-Reply-To: <20130225132844.GB8232@quack.suse.cz>
References: <51244A15.2060508@oracle.com>
	<20130221152520.GA17067@quack.suse.cz>
	<20130221180039.GX22221@lenny.home.zabbo.net>
	<512A18C6.6090601@oracle.com> <20130225132844.GB8232@quack.suse.cz>
Message-ID: <20130225171435.GF22221@lenny.home.zabbo.net>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Jan Kara <jack@suse.cz>
Cc: Jeff Liu <jeff.liu@oracle.com>, "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>, Alexander Viro <viro@zeniv.linux.org.uk>, Andreas Dilger <adilger@dilger.ca>, Dave Chinner <david@fromorbit.com>, Mark Fasheh <mfasheh@suse.com>, Joel Becker <jlbec@evilplan.org>, Chris Mason <chris.mason@fusionio.com>, Christoph Hellwig <hch@infradead.org>, ocfs2-devel@oss.oracle.com

> > Does the results above looks make sense?  If yes, I still felt that it's
> > not a formal approach to detect reflinked files.  IMHO, if we can improve
> > the stat(2)->getattr() to fill the mode member with a flag to indicate
> > that a file is reflinked/cow or not, it would be more convenient to check
> > as like S_ISREFLINK(stat.st_mode) from the user space since du(1) always
> > fetching the statistics per file disk space accounting.

>   I agree that adding filtering to FIEMAP just to accomodate the only
> practical use case of checking whether a file has any shared extent is
> really an overkill. But changing stat(2) the way you describe is ugly hack.
> st_mode has logically nothing to do with whether file has shared extents or
> not. If anything you could use ioctl IOC_GETFLAGS for that. I'm not 100%
> sure that's the right interface but at least it isn't that ugly.

Agreed: avoiding the fiemap extent walk entirely is reasonable, and
st_mode is a strange place to put a flag that indicates that some
extents might have the SHARED bit :).  GETFLAGS doesn't seem so bad.

It seems like the real fix, though, is to have the fs track shared
logical file offset regions with a counter in the inode like it does for
size and blocks.  Extending stat() to report this to userspace would
probably be very annoying; maybe a synthetic xattr would work.

- z
