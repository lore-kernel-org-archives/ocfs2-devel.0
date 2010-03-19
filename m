From: Joel Becker <Joel.Becker@oracle.com>
Date: Fri, 19 Mar 2010 14:50:59 -0700
Subject: [Ocfs2-devel] [PATCH 1/2] ocfs2: Increase name_offset for the
	removed xattr.
In-Reply-To: <1268982264-28121-1-git-send-email-tao.ma@oracle.com>
References: <1268982264-28121-1-git-send-email-tao.ma@oracle.com>
Message-ID: <20100319215059.GC15539@mail.oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

On Fri, Mar 19, 2010 at 03:04:23PM +0800, Tao Ma wrote:
> When replacing a xattr's value, in some case we wipe
> its name/value first and then adding them. The wipe
> is done by ocfs2_xa_block_wipe_namevalue when xattr
> is in inode or block. we decrease name_offset for all
> the entries which have offset < name_offset. This isn't
> enough in case the replaced one has the smallest offset.
> So the next time we will find the wrong free_start in
> ocfs2_xa_get_free_start and we will overflow finally.
> The solution is to increase the name_offset for the
> replaced one also so that we can survive.

	This patch is now in the fixes branch of ocfs2.git.  Good catch!

Joel

-- 

Life's Little Instruction Book #464

	"Don't miss the magic of the moment by focusing on what's
	 to come."

Joel Becker
Principal Software Developer
Oracle
E-mail: joel.becker at oracle.com
Phone: (650) 506-8127
