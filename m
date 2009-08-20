From: Tao Ma <tao.ma@oracle.com>
Date: Thu, 20 Aug 2009 10:03:52 +0800
Subject: [Ocfs2-devel] [PATCH 0/14] ocfs2: Unify the setting of extended
	attributes
In-Reply-To: <1250711679-12441-1-git-send-email-joel.becker@oracle.com>
References: <1250711679-12441-1-git-send-email-joel.becker@oracle.com>
Message-ID: <4A8CAF08.6090403@oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

Hi Joel,

Joel Becker wrote:
> ocfs2 can store extended attributes in many ways.  They can live inside
> the inode's inline data area, they can be stored in a single external
> block, or they can be in a "bucket" hanging off of a lookup tree.  There
> are differences in how each storage type manages the attributes, and the
> current ocfs2 code reflects this.
> 
> There are two entirely separate code paths for setting extended
> attributes.  The first code path handles "block" storage - the inline
> inode or the external block.  The second handles "bucket" storage.  They
> do very similar things, but they go about them in very different ways.
> This makes reading and understanding the ocfs2 xattr code harder than it
> needs to be.  Worse, updating the xattr code requires understanding and
> modifying both paths.
> 
> This patch series unifies the xattr set code such that inodes, block,
> and buckets make the same call.  It removes most of the redundant code,
> like the repeated implementations of truncating externally stored values.
Due to some historical reasons, the setting of xattrs has been divided 
into 2 parts. I am so sorry for that and to be frank, I want to change 
it for a very long time. So thanks for doing this.
> 
> The core of the implementation is the ocfs2_xa_loc structure.  This is
> an in-memory representation of an ocfs2_xattr_entry.  It has operations
> that allow blocks and buckets to behave differently during the xattr
> modification process.  Blocks and buckets are different enough that
> ocfs2_xa_loc_operations has ten different ops!  But with these
> differences encapsulated, we can have a single code path to modify an
> entry.
> 
> The changes don't reduce the size of the source code perceptibly (~10
> lines of actual code without comments or blanks), but to my mind they
> greatly improve the readability and maintainability.
> 
> The current series is based on the 'fixes' branch; I'll need to rebase
> it atop cachme before it can go upstream.  I wanted to send it out as it
> stands now so that the concept can be reviewed while I work on
> merge-window.
> 
> Tao and Tiger, I'd really appreciate you going over the changes with a
> find-toothed comb.  Make sure I have my ideas about block and bucket
> stuff correct, etc.  Let me know if you think this is a stupid change,
> too :-)
the idea is cool and it is really helpful and I will review it carefully.

Regards,
Tao
