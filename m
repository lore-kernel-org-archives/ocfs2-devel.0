From: Joel Becker <Joel.Becker@oracle.com>
Date: Thu, 15 Oct 2009 02:21:07 -0700
Subject: [Ocfs2-devel] [PATCH 0/2] ocfs2:  Some patches for reflink. v3
In-Reply-To: <4AD691CD.4080400@oracle.com>
References: <4AD691CD.4080400@oracle.com>
Message-ID: <20091015092106.GD14500@mail.oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

On Thu, Oct 15, 2009 at 11:06:53AM +0800, Tao Ma wrote:
> 	This patch set integrate the fix for the bug tristan found.

	These both look good.  You know, if an inode is inline and has
no xattrs, ie:

(oi->i_dyn_flags & (OCFS2_HAS_XATTR_FL | OCFS2_HAS_INLINE_DATA_FL)) ==
  OCFS2_HAS_INLINE_DATA_FL

you can just skip the refcount tree entirely.  Copy the inode.  Reinit
the security if !preserve.  Call it a day.
	But this is a later optimization.

Joel

-- 

Life's Little Instruction Book #450

	"Don't be afraid to say, 'I need help.'"

Joel Becker
Principal Software Developer
Oracle
E-mail: joel.becker at oracle.com
Phone: (650) 506-8127
