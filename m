From: Chris Mason <mason@suse.com>
Date: Tue Mar 29 11:19:29 2005
Subject: [Ocfs2-devel] xattr/acl support
In-Reply-To: <20050329160305.GA9619@ca-server1.us.oracle.com>
References: <200503290904.18742.mason@suse.com>
	<20050329160305.GA9619@ca-server1.us.oracle.com>
Message-ID: <200503291219.20281.mason@suse.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

On Tuesday 29 March 2005 11:03, Wim Coekaerts wrote:
> well I think there is enough there to be able to add support it and it's
> been discussed/future feature however we haven't had the time to work on
> it. certainly would be cool to have ;)

;) Does the disk format already have all the slots reserved for such a thing?  
It looks like you've probably got some extra room on the end of the inode, 
I'm hoping for something that can pack in tiny files directly and perhaps 
store small acls/xattrs in there.

-chris
