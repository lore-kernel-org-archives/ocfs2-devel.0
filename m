From: Joel Becker <Joel.Becker@oracle.com>
Date: Thu May 27 05:45:19 2004
Subject: [Ocfs2-devel] [IMPORTANT] OCFS2 revision 946
In-Reply-To: <3ACA40606221794F80A5670F0AF15F8404737EAE@PDSMSX403.ccr.corp.intel.com>
References: <3ACA40606221794F80A5670F0AF15F8404737EAE@PDSMSX403.ccr.corp.intel.com>
Message-ID: <20040527104303.GX879@ca-server1.us.oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

On Thu, May 27, 2004 at 02:52:21PM +0800, Ling, Xiaofeng wrote:
> So seems the file_entry struct is much like the ext2_inode struct in ext2/3 file system now.

	Yup.  And the directories *are* ext3 directories.  Literally.
Yay open source.

> Another effect is we lose a simple way to list the all files without going to each directory recursively.:)

	Do you mean that you scan the dir alloc file and dump the names
you see there?  That's crack, I'm glad it no longer works :-)

> How about the root, is there a file_entry for root directory and as the first one in "inode alloc" file?

	Yes, there is.  It's block 3.

Joel

-- 

Life's Little Instruction Book #396

	"Never give anyone a fruitcake."

Joel Becker
Senior Member of Technical Staff
Oracle Corporation
E-mail: joel.becker@oracle.com
Phone: (650) 506-8127
