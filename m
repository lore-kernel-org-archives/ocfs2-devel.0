From: Sage Weil <sage@newdream.net>
Date: Tue, 12 May 2009 09:16:29 -0700 (PDT)
Subject: [Ocfs2-devel] [RFC] The reflink(2) system call v4.
In-Reply-To: <4A09945C.2080002@hp.com>
References: <1241331303-23753-1-git-send-email-joel.becker@oracle.com>
	<20090507221535.GA31624@mail.oracle.com> <4A039FF8.7090807@hp.com>
	<20090508031018.GB8611@mail.oracle.com>
	<20090511204011.GB30293@mail.oracle.com>
	<Pine.LNX.4.64.0905120748310.18625@cobra.newdream.net>
	<4A09945C.2080002@hp.com>
Message-ID: <Pine.LNX.4.64.0905120838040.18625@cobra.newdream.net>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: jim owens <jowens@hp.com>
Cc: Joel Becker <Joel.Becker@oracle.com>, jmorris@namei.org, ocfs2-devel@oss.oracle.com, viro@zeniv.linux.org.uk, mtk.manpages@gmail.com, linux-security-module@vger.kernel.org, linux-fsdevel@vger.kernel.org

On Tue, 12 May 2009, jim owens wrote:
> Sage Weil wrote:
> > On Mon, 11 May 2009, Joel Becker wrote:
> > > 	Here's v4 of reflink().  If you have the privileges, you get the
> > > full snapshot.  If you don't, you must have read access, and then you
> > > get the entire snapshot (data and extended attributes) except that the
> > > security context is reinitialized.  That's it.  It fits with most of the
> > > other ops, and it's a clean degradation.
> > 
> > What would a 'cp' without '-p' be expected to do here when it has the
> > privileges?  Call reflink(2), then explicitly clear out any copied security
> > attributes ensure that any copied attributes are removed, and otherwise jump
> > through hoops to make the newly created file look like it should?  Should it
> > check whether it has the privileges and act accordingly (_can_ it even do
> > that reliably/atomically?), or unconditionally verify the attributes look
> > like a new file's should?
> 
> I don't understand what you think is hard about cp doing the
> "if not preserve then update attributes".  It does not have to check
> the reflink() attr result, it just assigns the expected new attributes.

I assume it's possible, but not being familiar with how the SELinux etc 
attributes look, my guess is that any tool that wants to cow file data 
to a new file (even if root) would need to do something like

 reflink(src, dst)
 chown(dst, getuid(), getgid())
 listxattr and rmxattr each.  or just delete selinux/whatever attributes.
 create generic 'new file' selinux/whatever attributes, if needed.

The chown bit isn't even right, since it doesn't follow the directory 
sticky bit rules.  And is there some generic way to assign an existing 
file 'new file'-like security attributes?  It's a mess.

> Only the -p snapshot needs atomicity.

My point is that the process creating the cow file should unconditionally 
do the above checks (and needed fixups) because it can't atomically verify 
the attribute copy won't happen andke the reflink call.

> > To me, a simple 'cp' type operation (assuming it gets wired up the way it
> > could) seems like at least as common a use case than a 'snapshot' 
> 
> I don't think changing "cp" is a good idea since users have a
> long history that cp means make a data copy, not cow.  Adding
> a new flag is IMO not be as good as a new utility.  Particularly
> since we can not do directories.

Maybe not, but that's a separate question from the interface issue.  We 
shouldn't preclude the possibility creating tools that preserve attributes 
(or warn if they can't) and tools that simply want to cow data to a new 
file.  AFAICS reflink(2) as proposed doesn't quite let you do either one 
without extra hackery to compensate for its dual-mode behavior. If this 
thread has demonstrated anything, it's that some users want snapshot-like 
semantics (cp -p) and some want cowfile()-like semantics (cp).  What is 
the benefit of combining the two into a single call?  If I want 
snapshot-like semantics, I would rather get -EPERM if I lack the necessary 
permissions than silently get an approximation.  Then I can at least issue 
a warning to the user.  If I really want to gracefully 'degrade', I can 
always do something like

err = reflink(src, dst);
if (err == -EPERM) {
	err = cowfile(src, dst);
	if (!err)
		printf("warning: failed to preserve all file attributes\n");
}

sage


> 
> jim
> --
> To unsubscribe from this list: send the line "unsubscribe linux-fsdevel" in
> the body of a message to majordomo at vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
> 
