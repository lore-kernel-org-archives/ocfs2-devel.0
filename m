From: Joel Becker <Joel.Becker@oracle.com>
Date: Fri, 27 Feb 2009 18:37:35 -0800
Subject: [Ocfs2-devel] [PATCH 1/1] Patch to recover orphans from
	the	slot during mount
In-Reply-To: <1235786484-17784-1-git-send-email-srinivas.eeda@oracle.com>
References: <1235786484-17784-1-git-send-email-srinivas.eeda@oracle.com>
Message-ID: <20090228023735.GM10695@mail.oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

On Fri, Feb 27, 2009 at 06:01:24PM -0800, Srinivas Eeda wrote:
> Currently we only queue recovery during mount if the journal is dirty.
> 
> If the last node holding orphans in other node's orphan directory dies and
> is the first one to mount then it only recovers its orphan directory which
> leaves the orphans in other nodes slots. Since the other nodes journals are
> clean they will not queue to recover their orphan directory.
> 
> This patch queues to recover orphans when the slot is next used.
> 
> Signed-off-by: Srinivas Eeda <srinivas.eeda@oracle.com>

This is always safe to do.
Acked-by: Joel Becker <joel.becker@oracle.com>

Joel

-- 

"In the long run...we'll all be dead."
                                        -Unknown

Joel Becker
Principal Software Developer
Oracle
E-mail: joel.becker at oracle.com
Phone: (650) 506-8127
