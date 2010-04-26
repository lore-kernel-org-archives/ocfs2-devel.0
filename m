From: Joel Becker <Joel.Becker@oracle.com>
Date: Sun, 25 Apr 2010 23:55:03 -0700
Subject: [Ocfs2-devel] [PATCH] ocfs2/trivial: Code cleanup for
	allocation reservation.
In-Reply-To: <1270543606-5338-1-git-send-email-tao.ma@oracle.com>
References: <1270543606-5338-1-git-send-email-tao.ma@oracle.com>
Message-ID: <20100426065503.GB17377@mail.oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

On Tue, Apr 06, 2010 at 04:46:46PM +0800, Tao Ma wrote:
> Two tiny cleanup for allocation reservation.
> 1. Remove some extra codes in ocfs2_local_alloc_find_clear_bits.
> 2. Remove an unuseful variables in ocfs2_find_resv_lhs.
> 
> Cc: Mark Fasheh <mfasheh@suse.com>
> Signed-off-by: Tao Ma <tao.ma@oracle.com>

	This is now in the 'merge-window' branch of ocfs2.git.

Joel

-- 

"Against stupidity the Gods themselves contend in vain."
	- Friedrich von Schiller

Joel Becker
Principal Software Developer
Oracle
E-mail: joel.becker at oracle.com
Phone: (650) 506-8127
