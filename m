From: J. Bruce Fields <bfields@fieldses.org>
Date: Tue, 29 Sep 2009 17:20:42 -0400
Subject: [Ocfs2-devel] [NFS] Trouble exporting OCFS2 via NFS
In-Reply-To: <20090929210011.GB24249@mail.oracle.com>
References: <710118.59930.qm@web43139.mail.sp1.yahoo.com>
	<20090929153126.GA388@fieldses.org>
	<20090929210011.GB24249@mail.oracle.com>
Message-ID: <20090929212042.GG3155@fieldses.org>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

On Tue, Sep 29, 2009 at 02:00:11PM -0700, Joel Becker wrote:
> On Tue, Sep 29, 2009 at 11:31:26AM -0400, J. Bruce Fields wrote:
> > On Mon, Sep 28, 2009 at 07:15:40PM +0000, Tim Cullen wrote:
> > > I've been attempting to export an OCFS2 filesystem via NFS without success. My NFS client mounts the exported filesystem without problem but all subsequent access to the mount point results in Stale NFS File Handle error. On the NFS server in /var/log/messages I see error messages like the ones below complaining about attempts to access beyond the end of the disk.
> > > 
> > > I've spoken with a supporting engineer at Oracle who didn't know what the problem might be and suggested I try this list. I'm hoping somebody here might be familiar with this problem.
> > 
> > If I had to guess I would've said it was an ocfs2 problem; maybe
> > somebody on ocfs2-devel (cc'd) can help?
> 
> 	Can you file a bug report at oss.oracle.com/bugzilla?  We could
> use the message files, your export and mount options, and anything you
> do to reproduce it.

And maybe cc: that here too.

--b.

> 	Walking off the end of the device is weird.
> 
> Joel
> 
> -- 
> 
> "Conservative, n.  A statesman who is enamoured of existing evils,
>  as distinguished from the Liberal, who wishes to replace them
>  with others."
> 	- Ambrose Bierce, The Devil's Dictionary
> 
> Joel Becker
> Principal Software Developer
> Oracle
> E-mail: joel.becker at oracle.com
> Phone: (650) 506-8127
