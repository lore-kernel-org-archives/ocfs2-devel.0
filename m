From: Mark Fasheh <mfasheh@suse.com>
Date: Wed, 27 Aug 2008 16:04:10 -0700
Subject: [Ocfs2-devel] [PATCH 38/59] CRED: Wrap task credential accesses
	in the OCFS2 filesystem
In-Reply-To: <20080827134858.19980.65277.stgit@warthog.procyon.org.uk>
References: <20080827134541.19980.61042.stgit@warthog.procyon.org.uk>
	<20080827134858.19980.65277.stgit@warthog.procyon.org.uk>
Message-ID: <20080827230410.GP4563@wotan.suse.de>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: David Howells <dhowells@redhat.com>
Cc: linux-kernel@vger.kernel.org, linux-security-module@vger.kernel.org, Serge Hallyn <serue@us.ibm.com>, Joel Becker <joel.becker@oracle.com>, ocfs2-devel@oss.oracle.com

On Wed, Aug 27, 2008 at 02:48:58PM +0100, David Howells wrote:
> Wrap access to task credentials so that they can be separated more easily from
> the task_struct during the introduction of COW creds.
> 
> Change most current->(|e|s|fs)[ug]id to current_(|e|s|fs)[ug]id().
> 
> Change some task->e?[ug]id to task_e?[ug]id().  In some places it makes more
> sense to use RCU directly rather than a convenient wrapper; these will be
> addressed by later patches.
> 
> Signed-off-by: David Howells <dhowells@redhat.com>
> Reviewed-by: James Morris <jmorris@namei.org>
> Acked-by: Serge Hallyn <serue@us.ibm.com>
Acked-by: Mark Fasheh <mfasheh@suse.com>

--
Mark Fasheh
