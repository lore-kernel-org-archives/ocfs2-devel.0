From: Joel Becker <Joel.Becker@oracle.com>
Date: Fri, 19 Jun 2009 16:31:35 -0700
Subject: [Ocfs2-devel] [PATCH 1/5] ocfs2: Pin journal head before
 accessing jh->b_committed_data
In-Reply-To: <1245447958-12996-1-git-send-email-sunil.mushran@oracle.com>
References: <1245447958-12996-1-git-send-email-sunil.mushran@oracle.com>
Message-ID: <20090619233135.GN29140@mail.oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

On Fri, Jun 19, 2009 at 02:45:54PM -0700, Sunil Mushran wrote:
> This patch adds jbd_lock_bh_state() and jbd_unlock_bh_state() around accessses
> to jh->b_committed_data.
> 
> Fixes oss bugzilla#1131
> http://oss.oracle.com/bugzilla/show_bug.cgi?id=1131
> 
> Signed-off-by: Sunil Mushran <sunil.mushran@oracle.com>

This is now in the fixes branch of ocfs2.git.

Joel

-- 

Life's Little Instruction Book #207

	"Swing for the fence."

Joel Becker
Principal Software Developer
Oracle
E-mail: joel.becker at oracle.com
Phone: (650) 506-8127
