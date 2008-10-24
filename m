From: Joel Becker <Joel.Becker@oracle.com>
Date: Fri, 24 Oct 2008 15:45:24 -0700
Subject: [Ocfs2-devel] Bug in OCFS2 umount code
In-Reply-To: <20081024224025.GF9302@mail.oracle.com>
References: <20081024215702.GA10038@duck.suse.cz>
	<20081024224025.GF9302@mail.oracle.com>
Message-ID: <20081024224523.GG9302@mail.oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

On Fri, Oct 24, 2008 at 03:40:25PM -0700, Joel Becker wrote:
> On Fri, Oct 24, 2008 at 11:57:02PM +0200, Jan Kara wrote:
> >   while playing with quota support I found two bugs in OCFS2 mount/umount
> > code. The first problem is, that if mount fails, we call
> > ocfs2_dismount_volume(). That is fine but after fill_super() returns an
> > error, VFS calls sync_fs() and ocfs2_put_super() again - not a good idea.
> > We usually oops...
<snip> 
> 	So I don't see a bug in the code as I have it here in my tree.
> I'm going to go check your quota patches to see if perhaps you jump to
> read_super_error after s_root is set.  If so, we can just reorganize
> that.  If not, we'll have to figure out what particular mount failure is
> causing your problem, so we can see what's happening.

	Yeah, you're bailing after setting s_root:

@@ -745,6 +899,13 @@ static int ocfs2_fill_super(struct super_block *sb,
void *data, int silent) 
 
        sb->s_root = root;
 
+       /* Initialize quotas before we start truncation log recovery */
+       status = ocfs2_enable_quotas(osb); 
+       if (status < 0) {
+               mlog_errno(status);
+               goto read_super_error;
+       }

	I don't see why you can't move that above the s_root line.  The
filesystem isn't accessible to userspace yet.  Then your error is safe
to jump to read_super_error.

Joel

-- 

Bram's Law:
	The easier a piece of software is to write, the worse it's
	implemented in practice.

Joel Becker
Principal Software Developer
Oracle
E-mail: joel.becker@oracle.com
Phone: (650) 506-8127
