From: Mark Fasheh <mark.fasheh@oracle.com>
Date: Mon Jan 28 22:00:08 2008
Subject: [Ocfs2-devel] Re: [git pull] Fix recent Ocfs2 breakage
In-Reply-To: <20080129050804.GA2285@suse.de>
References: <20080129033307.GE23506@ca-server1.us.oracle.com>
	<20080129050804.GA2285@suse.de>
Message-ID: <20080129055825.GG23506@ca-server1.us.oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Greg KH <gregkh@suse.de>
Cc: Linus Torvalds <torvalds@linux-foundation.org>, Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org, ocfs2-devel@oss.oracle.com, Joel Becker <Joel.Becker@oracle.com>

On Mon, Jan 28, 2008 at 09:08:04PM -0800, Greg KH wrote:
> > Joel Becker (1):
> >       ocfs2: Fix userspace ABI breakage in sysfs
> 
> This is fine with me, for now.

Great, thanks.


> > From: Joel Becker <Joel.Becker@oracle.com>
> > 
> > ocfs2: Fix userspace ABI breakage in sysfs
> > 
> > The userspace ABI of ocfs2's internal cluster stack (o2cb) was broken by
> > commit c60b71787982cefcf9fa09aa281fa8c4c685d557 "kset: convert ocfs2 to
> > use kset_create".  Specifically, the '/sys/o2cb' kset was moved to
> > '/sys/fs/o2cb'.  This breaks all ocfs2 tools and renders the
> > filesystem unmountable.
> > 
> > This fix moves '/sys/o2cb' back where it belongs.
> 
> "belongs" is pretty odd here.  This is a filesystem specific thing,
> right?  Why not put it in /sys/fs/ then?

We had it there before /sys/fs and as has been noted, it's ABI so we can't
change it right away. In theory, it's actually outside the fs, but in
reality it's pretty tied to Ocfs2, so I have no objection to the idea of it
being eventually moved there.


> And yes, I understand about legacy userspace tools, that's why I have no
> objection to it going back.  But you can put it in both places (with a
> symlink) and change your userspace code, and in a year or so, drop the
> symlink, right?

Yeah, that sounds entirely reasonable. It shouldn't be too hard for us to
fix up ocfs2-tools to look in both places. So long as there's enough lead
time for users to upgrade their toolchain (we can do releases for all
branches of ocfs2-tools, make annoucements on lists, etc), I think the
impact shouldn't be too bad.


> And please please please please document stuff like this, and all of the
> different files you have in this subdirectory in Documentation/ABI/ so
> those of us who are trying to figure out the code (and there's still
> parts of the kobject usage I'm pretty sure is not correct) can have a
> chance to understand exactly how this stuff is being used and expected
> to work.

No problem. I'll get us some patches to symlink things, and add docs in
Documentation/ABI/ explaining how Ocfs2 and userspace communicate. In the
future, as we add ABI it'll be documented there.
	--Mark

--
Mark Fasheh
Principal Software Developer, Oracle
mark.fasheh@oracle.com
