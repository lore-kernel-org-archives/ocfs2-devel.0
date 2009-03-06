From: Joel Becker <Joel.Becker@oracle.com>
Date: Fri, 6 Mar 2009 09:33:57 -0800
Subject: [Ocfs2-devel] [PATCH 1/1] Patch to recover orphans in
	offline	slots during recovery and mount (revised)
In-Reply-To: <1236330081-27217-1-git-send-email-srinivas.eeda@oracle.com>
References: <1236330081-27217-1-git-send-email-srinivas.eeda@oracle.com>
Message-ID: <20090306173357.GD24621@ca-server1.us.oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

On Fri, Mar 06, 2009 at 01:01:21AM -0800, Srinivas Eeda wrote:
> During recovery, a node recovers orphans in it's slot and the dead node(s). But
> if the dead nodes were holding orphans in offline slots, they will be left
> unrecovered.
> 
> If the dead node is the last one to die and is holding orphans in other slots
> and is the first one to mount, then it only recovers it's own slot, which
> leaves orphans in offline slots.
> 
> This patch queues complete_recovery to clean orphans for all offline slots
> during mount and node recovery.
> 
> Signed-off-by: Srinivas Eeda <srinivas.eeda@oracle.com>
Acked-by: Joel Becker <joel.becker@oracle.com>

-- 

"If the human brain were so simple we could understand it, we would
 be so simple that we could not."
	- W. A. Clouston

Joel Becker
Principal Software Developer
Oracle
E-mail: joel.becker at oracle.com
Phone: (650) 506-8127
