From: Joel Becker <Joel.Becker@oracle.com>
Date: Fri, 19 Jun 2009 16:31:47 -0700
Subject: [Ocfs2-devel] [PATCH 2/5] ocfs2: Fix ocfs2_osb_dump()
In-Reply-To: <1245447958-12996-2-git-send-email-sunil.mushran@oracle.com>
References: <1245447958-12996-1-git-send-email-sunil.mushran@oracle.com>
	<1245447958-12996-2-git-send-email-sunil.mushran@oracle.com>
Message-ID: <20090619233147.GO29140@mail.oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

On Fri, Jun 19, 2009 at 02:45:55PM -0700, Sunil Mushran wrote:
> Skip printing information that is not valid for local mounts.
> 
> Signed-off-by: Sunil Mushran <sunil.mushran@oracle.com>

This is now in the fixes branch of ocfs2.git.

Joel


-- 

"I inject pure kryptonite into my brain.
 It improves my kung fu, and it eases the pain."


Joel Becker
Principal Software Developer
Oracle
E-mail: joel.becker at oracle.com
Phone: (650) 506-8127
