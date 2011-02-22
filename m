From: Joel Becker <jlbec@evilplan.org>
Date: Tue, 22 Feb 2011 01:36:30 -0800
Subject: [Ocfs2-devel] [PATCH 2/2] ocfs2/dlm: Move kmalloc() outside the
 spinlock
In-Reply-To: <1298327125-4045-2-git-send-email-sunil.mushran@oracle.com>
References: <1298327125-4045-1-git-send-email-sunil.mushran@oracle.com>
	<1298327125-4045-2-git-send-email-sunil.mushran@oracle.com>
Message-ID: <20110222093629.GH30966@noexit>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

On Mon, Feb 21, 2011 at 02:25:25PM -0800, Sunil Mushran wrote:
> In dlm_query_region_handler(), move the kmalloc outside the spinlock.
> This allows us to use GFP_KERNEL instead of GFP_ATOMIC.
> 
> Signed-off-by: Sunil Mushran <sunil.mushran@oracle.com>

	This patch is now in the merge-window branch of ocfs2.git.

Joel

-- 

"Conservative, n.  A statesman who is enamoured of existing evils,
 as distinguished from the Liberal, who wishes to replace them
 with others."
	- Ambrose Bierce, The Devil's Dictionary

			http://www.jlbec.org/
			jlbec at evilplan.org
