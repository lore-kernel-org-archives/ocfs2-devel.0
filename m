From: Christoph Hellwig <hch@lst.de>
Date: Fri Oct 21 04:09:31 2005
Subject: [Ocfs2-devel] [RFC] Integration with external clustering
In-Reply-To: <20051020154244.GD11488@ca-server1.us.oracle.com>
References: <43556F8B.3060105@suse.com>
	<20051018221849.GN11488@ca-server1.us.oracle.com>
	<20051018230323.GE2813@marowsky-bree.de>
	<20051018232752.GO11488@ca-server1.us.oracle.com>
	<20051019132624.GI24589@marowsky-bree.de>
	<4356BBE8.2080904@suse.com>
	<20051020102358.GB11726@marowsky-bree.de>
	<20051020150341.GC11488@ca-server1.us.oracle.com>
	<20051020152606.GB16745@redhat.com>
	<20051020154244.GD11488@ca-server1.us.oracle.com>
Message-ID: <20051021090937.GA30904@lst.de>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

On Thu, Oct 20, 2005 at 08:42:44AM -0700, Joel Becker wrote:
> On Thu, Oct 20, 2005 at 10:26:06AM -0500, David Teigland wrote:
> > For some reason we've never used a mount.gfs so it didn't even cross my
> > mind -- it sounds like the obvious way to go.  That description I sent of
> > how gfs mount interacts with the cluster bits may be changing now...
> 
> 	Hehe, when you said "mount process..." in your description, I
> assumed mount.gfs :-)  You might want to rip off the
> generic-mount-option-parsing code from mount.ocfs2 (which we ripped off
> from mount.smb).

Heh.  Maybe you would be kind enough to rip it out from all of them
and submit a patch to create a libmount or similar to the util-linux
maintainer? ;-)
