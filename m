From: Joel Becker <Joel.Becker@oracle.com>
Date: Thu, 23 Sep 2010 14:23:49 -0700
Subject: [Ocfs2-devel] [PATCH 1/1] o2dlm: force free mles during dlm exit
In-Reply-To: <1285111646-23955-1-git-send-email-srinivas.eeda@oracle.com>
References: <1285111646-23955-1-git-send-email-srinivas.eeda@oracle.com>
Message-ID: <20100923212349.GE6609@mail.oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

On Tue, Sep 21, 2010 at 04:27:26PM -0700, Srinivas Eeda wrote:
> While umounting, a block mle doesn't get freed if dlm is shutdown after
> master request is received but before assert master. This results in unclean
> shutdown of dlm domain.
> 
> This patch frees all mles that lie around after other nodes were notified about
> exiting the dlm and marking dlm state as leaving. Only block mles are expected
> to be around, so we log ERROR for other mles but still free them.
> 
> Signed-off-by: Srinivas Eeda <srinivas.eeda@oracle.com>

        This patch is now in the 'fixes' branch of ocfs2.git.

Joel

-- 

To spot the expert, pick the one who predicts the job will take the
longest and cost the most.

Joel Becker
Consulting Software Developer
Oracle
E-mail: joel.becker at oracle.com
Phone: (650) 506-8127
