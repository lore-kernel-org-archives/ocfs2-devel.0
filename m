From: Joel Becker <Joel.Becker@oracle.com>
Date: Thu, 30 Oct 2008 13:31:21 -0700
Subject: [Ocfs2-devel] [PATCH 25/29] ocfs2: Implementation of local
	and	global quota file handling
In-Reply-To: <20081030073339.GD14500@duck.suse.cz>
References: <122488610212-git-send-email-jack@suse.cz>
	<12248861041077-git-send-email-jack@suse.cz>
	<20081028193652.GD17578@mail.oracle.com>
	<20081029022902.GE24732@duck.suse.cz>
	<20081029105139.GA10080@ca-server1.us.oracle.com>
	<20081030073339.GD14500@duck.suse.cz>
Message-ID: <20081030203121.GA32103@mail.oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

On Thu, Oct 30, 2008 at 08:33:39AM +0100, Jan Kara wrote:
> On Wed 29-10-08 03:51:39, Joel Becker wrote:
> > On Wed, Oct 29, 2008 at 03:29:02AM +0100, Jan Kara wrote:
> > >   What I did is, that in the end of each quotafile block there are 8 bytes
> > > reserved for OCFS2 use (both in local and global quota files). So these
> > > bytes are intended to be used for ECC. I hope that's fine.
> > 
> > 	So every block type (disk header, dq_block, etc) has the last 8
> > bytes free?
>   Yes.
> 
> > This seems like something we should find a way to mention
> > in the disk header.
>   You mean like in the ocfs2_fs.h file? There is already a constant and
> a comment in quota.h, but probably it makes sence to move it to ocfs2_fs.h.

	Well, if other filesystems get it via quota.h too, it should
stay there.  Perhaps just a comment in ocfs2_fs.h about it so readers
are aware.

Joel

-- 

 The zen have a saying:
 "When you learn how to listen, ANYONE can be your teacher."

Joel Becker
Principal Software Developer
Oracle
E-mail: joel.becker at oracle.com
Phone: (650) 506-8127
