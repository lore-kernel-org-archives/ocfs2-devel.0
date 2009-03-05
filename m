From: Joel Becker <Joel.Becker@oracle.com>
Date: Wed, 4 Mar 2009 17:37:06 -0800
Subject: [Ocfs2-devel] [PATCH 1/2] ocfs2: reserve xattr block for
	directory inode in	mknod
In-Reply-To: <1236136873-3980-1-git-send-email-tiger.yang@oracle.com>
References: <49ADF2FB.6060503@oracle.com>
	<1236136873-3980-1-git-send-email-tiger.yang@oracle.com>
Message-ID: <20090305013706.GB8700@mail.oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

On Wed, Mar 04, 2009 at 11:21:13AM +0800, Tiger Yang wrote:
> As we set directory inode starting with inline data,
> there is no place in inode for ACLs or security extended
> attributes entries. In this case, we have to reserve
> xattr block at the begining of mknod.
> 
> Signed-off-by: Tiger Yang <tiger.yang@oracle.com>

	This is fine, but can you update the comment above?  Something
like "If this is a new directory with inline data, we choose to reserve
the entire inline area for directory contents and force an external
xattr block."

Joel

-- 

"War doesn't determine who's right; war determines who's left."

Joel Becker
Principal Software Developer
Oracle
E-mail: joel.becker at oracle.com
Phone: (650) 506-8127
