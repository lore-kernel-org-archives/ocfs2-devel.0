From: Greg KH <gregkh@suse.de>
Date: Tue, 29 Jan 2008 05:12:04 -0000
Subject: [Ocfs2-devel] [git pull] Fix recent Ocfs2 breakage
In-Reply-To: <20080129033307.GE23506@ca-server1.us.oracle.com>
References: <20080129033307.GE23506@ca-server1.us.oracle.com>
Message-ID: <20080129050804.GA2285@suse.de>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Mark Fasheh <mark.fasheh@oracle.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>, Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org, ocfs2-devel@oss.oracle.com, Joel Becker <Joel.Becker@oracle.com>

On Mon, Jan 28, 2008 at 07:33:07PM -0800, Mark Fasheh wrote:
> Greg's commit c60b71787982cefcf9fa09aa281fa8c4c685d557 inadvertantly broke
> Ocfs2 userspace ABI, so I have a rather high priority single line patch from
> Joel to fix things up for you to pull. A copy of the patch is attached to
> the bottom of this e-mail. Embarassingly enough, I missed this while acking
> the patch late last week :(
> 
> Please pull from 'upstream-linus' branch of
> git://git.kernel.org/pub/scm/linux/kernel/git/mfasheh/ocfs2.git upstream-linus
> 
> to receive the following updates:
> 
>  fs/ocfs2/cluster/sys.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
> 
> Joel Becker (1):
>       ocfs2: Fix userspace ABI breakage in sysfs

This is fine with me, for now.

> From: Joel Becker <Joel.Becker@oracle.com>
> 
> ocfs2: Fix userspace ABI breakage in sysfs
> 
> The userspace ABI of ocfs2's internal cluster stack (o2cb) was broken by
> commit c60b71787982cefcf9fa09aa281fa8c4c685d557 "kset: convert ocfs2 to
> use kset_create".  Specifically, the '/sys/o2cb' kset was moved to
> '/sys/fs/o2cb'.  This breaks all ocfs2 tools and renders the
> filesystem unmountable.
> 
> This fix moves '/sys/o2cb' back where it belongs.

"belongs" is pretty odd here.  This is a filesystem specific thing,
right?  Why not put it in /sys/fs/ then?

And yes, I understand about legacy userspace tools, that's why I have no
objection to it going back.  But you can put it in both places (with a
symlink) and change your userspace code, and in a year or so, drop the
symlink, right?

And please please please please document stuff like this, and all of the
different files you have in this subdirectory in Documentation/ABI/ so
those of us who are trying to figure out the code (and there's still
parts of the kobject usage I'm pretty sure is not correct) can have a
chance to understand exactly how this stuff is being used and expected
to work.

thanks,

greg k-h
