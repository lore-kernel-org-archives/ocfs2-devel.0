From: Joel Becker <Joel.Becker@oracle.com>
Date: Tue Mar 29 13:45:06 2005
Subject: [Ocfs2-devel] xattr/acl support
In-Reply-To: <200503291219.20281.mason@suse.com>
References: <200503290904.18742.mason@suse.com>
	<20050329160305.GA9619@ca-server1.us.oracle.com>
	<200503291219.20281.mason@suse.com>
Message-ID: <20050329193913.GA28010@ca-server1.us.oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

On Tue, Mar 29, 2005 at 12:19:19PM -0500, Chris Mason wrote:
> ;) Does the disk format already have all the slots reserved for such a thing?  
> It looks like you've probably got some extra room on the end of the inode, 
> I'm hoping for something that can pack in tiny files directly and perhaps 
> store small acls/xattrs in there.

	We've not agreed yet on how we want to implement them.  We go
back and forth.  Could be internal to the inode reserved space for a few
small xattrs, expanding to a whole cluster for larger ones.  Or it could
be block-based, copying the code directly from ext3.  We just haven't
decided yet.
	Note that there is no extra room at the "end" of the inode, as
the extent list fills to the end.  The extra room is in the reserved
fields.

Joel

-- 

"One of the symptoms of an approaching nervous breakdown is the
 belief that one's work is terribly important."
         - Bertrand Russell 

Joel Becker
Senior Member of Technical Staff
Oracle
E-mail: joel.becker@oracle.com
Phone: (650) 506-8127
