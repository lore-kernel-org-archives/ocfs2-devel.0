From: Joel Becker <Joel.Becker@oracle.com>
Date: Tue, 18 May 2010 12:15:42 -0700
Subject: [Ocfs2-devel] [PATCH] ocfs2:dlm: avoid dlm->ast_lock
 lockres->spinlock dependency break
In-Reply-To: <201005171221.o4H8oUwB022995@rcsinet13.oracle.com>
References: <201005171221.o4H8oUwB022995@rcsinet13.oracle.com>
Message-ID: <20100518191542.GC3239@mail.oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

On Mon, May 17, 2010 at 08:20:44PM +0800, Wengang Wang wrote:
> Currently we process a dirty lockres with the lockres->spinlock taken. While
> during the process, we may need to lock on dlm->ast_lock. This breaks the
> dependency of dlm->ast_lock(lock first) and lockres->spinlock(lock second).
> 
> This patch fixes the problem.
> Since we can't release lockres->spinlock, we have to take dlm->ast_lock
> just before taking the lockres->spinlock and release it after lockres->spinlock
> is released. And use __dlm_queue_bast()/__dlm_queue_ast(), the nolock version,
> in dlm_shuffle_lists(). There are no too many locks on a lockres, so there is no
> performance harm.
> 
> Signed-off-by: Wengang Wang <wen.gang.wang@oracle.com>

This patch is now in the 'fixes' branch of ocfs2.git.

Joel

-- 

"One of the symptoms of an approaching nervous breakdown is the
 belief that one's work is terribly important."
         - Bertrand Russell 

Joel Becker
Principal Software Developer
Oracle
E-mail: joel.becker at oracle.com
Phone: (650) 506-8127
