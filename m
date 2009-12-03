From: Joel Becker <Joel.Becker@oracle.com>
Date: Wed, 2 Dec 2009 17:37:26 -0800
Subject: [Ocfs2-devel] [PATCH] ocfs2: Find proper end cpos for a leaf
	refcount block.
In-Reply-To: <1259562739-9767-1-git-send-email-tao.ma@oracle.com>
References: <1259562739-9767-1-git-send-email-tao.ma@oracle.com>
Message-ID: <20091203013726.GC31647@mail.oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

On Mon, Nov 30, 2009 at 02:32:19PM +0800, Tao Ma wrote:
> The reason is that if the ocfs2_extent_rec is the last record
> in a leaf extent block, the old solution fails to find the
> suitable end cpos. So this patch try to walk through the b-tree,
> find the next sub root and get the c_pos the next sub-tree starts
> from.

	This is now in the fixes branch of ocfs2.git

Joel

-- 

"I don't even butter my bread; I consider that cooking."
         - Katherine Cebrian

Joel Becker
Principal Software Developer
Oracle
E-mail: joel.becker at oracle.com
Phone: (650) 506-8127
