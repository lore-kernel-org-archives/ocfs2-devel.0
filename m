From: Joel Becker <Joel.Becker@oracle.com>
Date: Fri, 19 Jun 2009 23:04:52 -0700
Subject: [Ocfs2-devel] [PATCH 3/5] ocfs2: Stop orphan scan as early as
 possible during umount
In-Reply-To: <1245455599-23348-2-git-send-email-sunil.mushran@oracle.com>
References: <1245455599-23348-1-git-send-email-sunil.mushran@oracle.com>
	<1245455599-23348-2-git-send-email-sunil.mushran@oracle.com>
Message-ID: <20090620060451.GC1993@mail.oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

On Fri, Jun 19, 2009 at 04:53:17PM -0700, Sunil Mushran wrote:
> Currently if the orphan scan fires a tick before the user issues the umount,
> the umount will wait for the queued orphan scan tasks to complete.
> 
> This patch makes the umount stop the orphan scan as early as possible so as
> to reduce the probability of the queued tasks slowing down the umount.
> 
> Signed-off-by: Sunil Mushran <sunil.mushran@oracle.com>

this is now in the fixes branch of ocfs2.git

Joel

-- 

"Reality is merely an illusion, albeit a very persistent one."
        - Albert Einstien

Joel Becker
Principal Software Developer
Oracle
E-mail: joel.becker at oracle.com
Phone: (650) 506-8127
