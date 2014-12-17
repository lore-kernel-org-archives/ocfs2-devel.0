From: Mark Fasheh <mfasheh@suse.de>
Date: Wed, 17 Dec 2014 15:58:56 -0800
Subject: [Ocfs2-devel] ocfs patches for review
In-Reply-To: <20141215144945.268d08467edc223e7ef12281@linux-foundation.org>
References: <20141215144945.268d08467edc223e7ef12281@linux-foundation.org>
Message-ID: <20141217235856.GU7238@wotan.suse.de>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

On Mon, Dec 15, 2014 at 02:49:45PM -0800, Andrew Morton wrote:
> 
> Another round of jolly patch reviewing, please.  A number of these
> patches have been stalled for quite a long time.
> 
> I have the following notes:
> 
> o2dlm-fix-null-pointer-dereference-in-o2dlm_blocking_ast_wrapper.patch:
>    - Joseph Qi had issues
> 
> ocfs2-free-inode-when-i_count-becomes-zero.patch:
>    - Mark is finding a better way of doing this
> 
> ocfs2-call-ocfs2_journal_access_di-before-ocfs2_journal_dirty-in-ocfs2_write_end_nolock.patch:
>    - Mark requested changes


Aside from these three I believe I'm left with the O_DIRECT changes (patches
8-15). FYI I don't see those going upstream yet as we need to add a feature
flag for them. I'll have individual review for each of those shortly (it's a
big feature).
	--Mark

--
Mark Fasheh
