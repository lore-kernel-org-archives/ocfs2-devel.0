From: Joel Becker <Joel.Becker@oracle.com>
Date: Tue, 23 Mar 2010 12:54:55 -0700
Subject: [Ocfs2-devel] [PATCH 1/1] ocfs2: Fix a race in o2dlm lockres
 mastery(backport to 1.4)
In-Reply-To: <1269367679-22584-1-git-send-email-srinivas.eeda@oracle.com>
References: <1269367679-22584-1-git-send-email-srinivas.eeda@oracle.com>
Message-ID: <20100323195455.GB31783@mail.oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

On Tue, Mar 23, 2010 at 11:07:59AM -0700, Srinivas Eeda wrote:
> In o2dlm, the master of a lock resource keeps a map of all interested
> nodes.  This prevents the master from purging the resource before an
> interested node can create a lock.
> 
> A race between the mastery thread and the mastery handler allowed an
> interested node to discover who the master is without informing the
> master directly.  This is easily fixed by holding the dlm spinlock a
> little longer in the mastery handler.
> 
> Signed-off-by: Srinivas Eeda <srinivas.eeda@oracle.com>

	Has this patch changed at all since the one I took earlier?

Joel

-- 

"I don't even butter my bread; I consider that cooking."
         - Katherine Cebrian

Joel Becker
Principal Software Developer
Oracle
E-mail: joel.becker at oracle.com
Phone: (650) 506-8127
