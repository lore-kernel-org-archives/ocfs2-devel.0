From: =?utf-8?B?SsO2cm4=?= Engel <joern@logfs.org>
Date: Tue, 5 May 2009 18:46:20 +0200
Subject: [Ocfs2-devel] [PATCH 1/3] fs: Document the reflink(2) system
	call.
In-Reply-To: <20090505153629.GB31100@shareable.org>
References: <1241331303-23753-1-git-send-email-joel.becker@oracle.com>
	<1241331303-23753-2-git-send-email-joel.becker@oracle.com>
	<20090505010703.GA12731@shareable.org>
	<20090505071608.GB10258@mail.oracle.com>
	<20090505130114.GD17486@mit.edu>
	<20090505131907.GF25328@shareable.org>
	<1241530798.7244.65.camel@think.oraclecorp.com>
	<20090505153629.GB31100@shareable.org>
Message-ID: <20090505164619.GA32180@logfs.org>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Jamie Lokier <jamie@shareable.org>
Cc: Chris Mason <chris.mason@oracle.com>, Theodore Tso <tytso@mit.edu>, linux-fsdevel@vger.kernel.org, jmorris@namei.org, ocfs2-devel@oss.oracle.com, viro@zeniv.linux.org.uk

On Tue, 5 May 2009 16:36:29 +0100, Jamie Lokier wrote:
> 
> I'm wondering why reflink() is needed at all.  Can't it be done in
> userspace, using the BTRFS ioctl?  The hard part in userspace seems to
> be copying the file attributes, but "cp -a" and other tools manage.
> 
> What is the advantage of adding the system call for the special case
> of reflink(), when we choose not to have, say, a copyfile() system
> call which does what "cp -a" does because doing it in user space is
> good enough?

Given an ignorant filesystem, copyfile() will simply do the read/write
loop in kernelspace.  So either copyfile() is just a fancy name for
splice() or copyfile() will also have to create a tempfile, rename the
tempfile when the copy is done and deal with all possible errors.  And
if the system crashes, who will remove the tempfile on reboot?  Will the
tempfile have a well-known name, allowing for easy DoS?  Or will it be
random, causing much fun locating it after reboot.

In short, copyfile() for ignorant filesystems is steaming load of it.  I
know, I've written it [1].

When implemented in the filesystem itself, copyfile() can be quite nice.
The filesystem can create a temporary inode without visibly exposing it
to userspace.  It can delete temporary inodes in journal replay after a
crash.  And depending on the fs design, the read/write loop can be
replaced with finer-grained reference counting.

[1] Not a year or two ago, but in 2004, btw.

J?rn

-- 
Do not stop an army on its way home.
-- Sun Tzu
