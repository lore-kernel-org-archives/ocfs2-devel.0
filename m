From: Mark Fasheh <mark.fasheh@oracle.com>
Date: Thu Aug 31 20:26:05 2006
Subject: [Ocfs2-devel] a patch for ocfs2_link
In-Reply-To: <20060901030633.GX7715@ca-server1.us.oracle.com>
References: <44F79A94.3040101@oracle.com>
	<20060901030633.GX7715@ca-server1.us.oracle.com>
Message-ID: <20060901032602.GB8792@ca-server1.us.oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

On Thu, Aug 31, 2006 at 08:06:33PM -0700, Joel Becker wrote:
> > -       if (inode->i_nlink >= OCFS2_LINK_MAX) {
> > -               err = -EMLINK;
> > -               goto bail;
> > -       }
> > -
> 
> 	Why is this redundant?  Is someone doing it for us?  I see we
> check the fe->i_links_count below, but that's after the expense of a
> cluster lock.  Don't we save some effort here?
It's wrong because the i_nlink might be stale. We might actually be able to
insert, but we don't know until we have the cluster lock.


> > @@ -661,6 +656,11 @@ static int ocfs2_link(struct dentry *old
> >                goto bail;
> >        }
> > 
> > +       if (!dir->i_nlink) {
> > +               err = -ENOENT;
> > +               goto bail;
> > +       }
> > +
> 
> 	And what does this do?  If a directory...oh, wait, is this to
> check for a directory that's going away?  Can this actually happen?  I'd
> think that the VFS would protect it.
Again, the link count might be stale, so we have to double check after
getting the lock. The way I imagine this could happen is if the dir inode is
orphaned and a process attempts to do a create (imagine if it was unlinked
while someone still had a shell open there)

There are similar checks in ocfs2_symlink() and ocfs2_mknod() which Tiger is
basing that one on.


Granted, neither of these conditions are particularly likely, but we should
protect against them nonetheless.
	--Mark

--
Mark Fasheh
Senior Software Developer, Oracle
mark.fasheh@oracle.com
