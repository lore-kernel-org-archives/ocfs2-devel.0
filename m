From: Greg KH <gregkh@suse.de>
Date: Tue, 29 Jan 2008 18:51:19 -0000
Subject: [Ocfs2-devel] [git pull] Fix recent Ocfs2 breakage
In-Reply-To: <20080129074402.GA27097@ca-server1.us.oracle.com>
References: <20080129033307.GE23506@ca-server1.us.oracle.com>
	<20080129050804.GA2285@suse.de>
	<20080129074402.GA27097@ca-server1.us.oracle.com>
Message-ID: <20080129185448.GA358@suse.de>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Mark Fasheh <mark.fasheh@oracle.com>, Linus Torvalds <torvalds@linux-foundation.org>, Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org, ocfs2-devel@oss.oracle.com

On Mon, Jan 28, 2008 at 11:44:02PM -0800, Joel Becker wrote:
> On Mon, Jan 28, 2008 at 09:08:04PM -0800, Greg KH wrote:
> > And please please please please document stuff like this, and all of the
> > different files you have in this subdirectory in Documentation/ABI/ so
> 
> 	Huh, I didn't know Documentation/ABI existed.  That would
> certainly help in the future.

Yeah, not many people know about it, despite being present for over a
year now :(

So I'm starting to poke people to fix this.  I'd like to see all new
sysfs attributes (and syscalls and other stuff that is an ABI) be
documented here.  As well as creating the information for the ABI we
currently have, but I know that will take longer.

> > those of us who are trying to figure out the code (and there's still
> > parts of the kobject usage I'm pretty sure is not correct) can have a
> 
> 	ocfs2 kobject usage, or other folks'?  If there's anything in
> the ocfs2 usage that you are unsure of, feel free to ask!

Ok, great.  Here's a few questions:

  - ocfs2/cluster/sys.c creates a single kset, o2cb, that is in
    /sys/o2cb (and I had moved it to /sys/fs/o2cb/)  In that directory
    it seems there is only 1 file, O2NM_API_VERSION.  Is that really all
    that goes into that directory?  If so, this can be cleaned up even
    further and only a single kobject is needed, a kset is overkill.

  - that kset is then passed to the mlog_sys_init() file to chain
    another subdirectory off of this.  Here's where the meat of the
    sysfs files are.  You use a custom kset and show/store operations to
    describe some bit fields?  You never use the kobject here, but only
    go off of the name of the attribute file, which is fine.  But again,
    using a ktype/kset is way overkill for this.  It can be all
    simplified to only have 1 kobject for the directory, and then the
    individual attributes can be a kobj_attribute.


Actually that wasn't too bad.  It was gfs2 that I was thinking about
with regard to totally strange kobject abuse, I'll go poke those
developers about it while I'm remembering :)

thanks,

greg k-h
