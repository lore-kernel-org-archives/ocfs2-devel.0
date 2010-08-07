From: Joel Becker <Joel.Becker@oracle.com>
Date: Sat, 7 Aug 2010 11:39:34 -0700
Subject: [Ocfs2-devel] [PATCH] ocfs2: Count more refcount records in
 file system fragmentation.
In-Reply-To: <1279778205-7428-1-git-send-email-tao.ma@oracle.com>
References: <1279778205-7428-1-git-send-email-tao.ma@oracle.com>
Message-ID: <20100807183934.GC3699@mail.oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

On Thu, Jul 22, 2010 at 01:56:45PM +0800, Tao Ma wrote:
> The refcount record calculation in ocfs2_calc_refcount_meta_credits
> is too optimistic that we can always allocate contiguous clusters
> and handle an already existed refcount rec as a whole. Actually
> because of file system fragmentation, we may have the chance to split
> a refcount record into 3 parts during the transaction. So consider
> the worst case in record calculation.
> 
> Cc: stable at kernel.org
> Signed-off-by: Tao Ma <tao.ma@oracle.com>

This patch is now in the fixes branch of ocfs2.git.

Joel

-- 

Life's Little Instruction Book #347

	"Never waste the oppourtunity to tell someone you love them."

Joel Becker
Consulting Software Developer
Oracle
E-mail: joel.becker at oracle.com
Phone: (650) 506-8127
