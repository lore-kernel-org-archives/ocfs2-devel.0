From: Joel Becker <Joel.Becker@oracle.com>
Date: Tue, 12 Aug 2008 12:48:26 -0700
Subject: [Ocfs2-devel] [PATCH] ocfs2console: Allow ocfs2console
	to	enumerate device mapper devices
In-Reply-To: <48A1E677.4070009@suse.com>
References: <48A1A9C7.1080906@suse.com>
	<20080812192523.GA11744@mail.oracle.com>
	<48A1E677.4070009@suse.com>
Message-ID: <20080812194826.GC11744@mail.oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

On Tue, Aug 12, 2008 at 03:37:27PM -0400, Jeff Mahoney wrote:
> > 	Nice!  I've not played with libdevmapper - I assume that the
> > enumerator returns "preferred" names when there are 10 different
> > symlinks for the same volume?  :-)
> 
> It uses the canonical device mapper names. The symlinks are added by
> add-on tools like multipath or LVM. This enumerates the names that
> device mapper knows about. It's the same list that "dmsetup ls" would
> show, especially since I used that code as a template. :)
> 
> So, for example, it won't show you /dev/system/root, but instead will do
> /dev/mapper/system-root. I'd have preferred to have the former, but not
> so much that I want to teach ocfs2console about every DM add-on out there.

	Ahh.  Fabbione and I have put together a different iterator, one
that uses sysfs *and* procfs to find 'live' devices, then matches them
to all possible names in /dev.  He's using it for qdiskd, I'm going to
integrate it with oracleasm-support's scandisks op.  Eventually I was
going to add it to ocfs2console.  With your patch, I was thinking of
leveraging your change to provide better names.

Joel

-- 

Life's Little Instruction Book #450

	"Don't be afraid to say, 'I need help.'"

Joel Becker
Principal Software Developer
Oracle
E-mail: joel.becker at oracle.com
Phone: (650) 506-8127
