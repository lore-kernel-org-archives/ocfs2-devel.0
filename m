From: Joel Becker <Joel.Becker@oracle.com>
Date: Mon, 11 Oct 2010 14:16:43 -0700
Subject: [Ocfs2-devel] [PATCH 1/1] Ocfs2: Add a mount option
 "coherency=*" to handle cluster coherency for O_DIRECT writes.
In-Reply-To: <1286786799-10230-1-git-send-email-tristan.ye@oracle.com>
References: <1286786799-10230-1-git-send-email-tristan.ye@oracle.com>
Message-ID: <20101011211643.GH4255@mail.oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

On Mon, Oct 11, 2010 at 04:46:39PM +0800, Tristan Ye wrote:
> Currently, default behavior of O_DIRECT writes was allowing
> concurrent writing among nodes, no cluster coherency guaranteed
> (no EX locks was taken), it hurts buffered reads on other nodes
> by reading stale data from cache.
> 
> The new mount option introduce a chance to choose two different
> behaviors for O_DIRECT writes:
> 
>     * coherency=full, as the default value, will disallow
>                       concurrent O_DIRECT writes by taking
>                       EX locks.
> 
>     * coherency=buffered, allow concurrent O_DIRECT writes
>                           without EX lock among nodes, which
>                           gains high performance at risk of
>                           getting stale data on other nodes.
> 
> Signed-off-by: Tristan Ye <tristan.ye@oracle.com>

	This patch is now in the merge-window branch of ocfs2.git.

Joel

-- 

Life's Little Instruction Book #173

	"Be kinder than necessary."

Joel Becker
Consulting Software Developer
Oracle
E-mail: joel.becker at oracle.com
Phone: (650) 506-8127
