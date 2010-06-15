From: Joel Becker <Joel.Becker@oracle.com>
Date: Tue, 15 Jun 2010 16:46:51 -0700
Subject: [Ocfs2-devel] [PATCH 15/17] fs/ocfs2/dlm: Add missing
	spin_unlock
In-Reply-To: <Pine.LNX.4.64.1005261758290.23743@ask.diku.dk>
References: <Pine.LNX.4.64.1005261758290.23743@ask.diku.dk>
Message-ID: <20100615234651.GE30497@mail.oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Julia Lawall <julia@diku.dk>
Cc: Mark Fasheh <mfasheh@suse.com>, ocfs2-devel@oss.oracle.com, linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org

On Wed, May 26, 2010 at 05:58:53PM +0200, Julia Lawall wrote:
> From: Julia Lawall <julia@diku.dk>
> 
> Add a spin_unlock missing on the error path.  Unlock as in the other code
> that leads to the leave label.
> 
> The semantic match that finds this problem is as follows:
> (http://coccinelle.lip6.fr/)
> 
> // <smpl>
> @@
> expression E1;
> @@
> 
> * spin_lock(E1,...);
>   <+... when != E1
>   if (...) {
>     ... when != E1
> *   return ...;
>   }
>   ...+>
> * spin_unlock(E1,...);
> // </smpl>
> 
> Signed-off-by: Julia Lawall <julia@diku.dk>

This patch is now in the 'fixes' branch of ocfs2.git.

Joel

-- 

"In the arms of the angel, fly away from here,
 From this dark, cold hotel room and the endlessness that you fear.
 You are pulled from the wreckage of your silent reverie.
 In the arms of the angel, may you find some comfort here."

Joel Becker
Principal Software Developer
Oracle
E-mail: joel.becker at oracle.com
Phone: (650) 506-8127
