From: Joel Becker <Joel.Becker@oracle.com>
Date: Mon, 22 Mar 2010 18:15:24 -0700
Subject: [Ocfs2-devel] [PATCH 1/1] dlm: fix a race in lockres mastery
In-Reply-To: <4BA80E47.70307@oracle.com>
References: <1269301847-32101-1-git-send-email-srinivas.eeda@oracle.com>
	<4BA80E47.70307@oracle.com>
Message-ID: <20100323011523.GA12279@mail.oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

On Mon, Mar 22, 2010 at 05:41:43PM -0700, Sunil Mushran wrote:
> =================================================================
> In o2dlm, the resource master maintains a (ref)map of all nodes that
> are informed of the fact that that node masters that resource. This is
> done to prevent the master from purging the resource before the other
> node can create a lock.
> 
> This patch plugs a race between the mastery handler thread and the
> mastery thread that allows the node to discover the master of the
> resource without informing the master node.
> 
> Fixes ossbz#1012
> http://oss.oracle.com/bugzilla/show_bug.cgi?id=1012
> =================================================================
> 
> Add my sob and change the comment to the above.
> Signed-off-by: Sunil Mushran <sunil.mushran@oracle.com>

	The comment above makes even less sense to me than Srini's.
Hiss, while a little confusing to read, made me feel like I would get it
if I just looked at the code.  This text is...mumbo-jumbo.  "the
resource master maintains a map of all nodes that are informed of the
fact that that node masters that resource" indeed.
	Let me see if I can parse it:

------------------------------------------
In o2dlm, the master of a lock resource keeps a map of all interested
nodes.  This prevents the master from purging the resource before an
interested node can create a lock.

A race between the mastery thread and the mastery handler allowed an
interested node to discover the who the master is without informing the
master directly.  This is easily fixed by holding the dlm spinlock a
little longer in the mastery handler.
------------------------------------------

How's that?
	I also had a question about the patch.  It is safe to hold the
dlm spinlock across all the other spinlocks, right?  I believe that the
dlm spinlock is toplevel, so I'm pretty sure it is, but I wanted to
verify.

Joel

-- 

"Friends may come and go, but enemies accumulate." 
        - Thomas Jones

Joel Becker
Principal Software Developer
Oracle
E-mail: joel.becker at oracle.com
Phone: (650) 506-8127
