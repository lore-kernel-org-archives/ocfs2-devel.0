From: Joel Becker <Joel.Becker@oracle.com>
Date: Fri, 19 Jun 2009 23:05:15 -0700
Subject: [Ocfs2-devel] [PATCH 4/5] ocfs2: Do not initialize lvb in
 ocfs2_orphan_scan_lock_res_init()
In-Reply-To: <1245455599-23348-3-git-send-email-sunil.mushran@oracle.com>
References: <1245455599-23348-1-git-send-email-sunil.mushran@oracle.com>
	<1245455599-23348-3-git-send-email-sunil.mushran@oracle.com>
Message-ID: <20090620060515.GD1993@mail.oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

On Fri, Jun 19, 2009 at 04:53:18PM -0700, Sunil Mushran wrote:
> No need to call ocfs2_dlm_lvb() in ocfs2_orphan_scan_lock_res_init().
> 
> Signed-off-by: Sunil Mushran <sunil.mushran@oracle.com>

This is now in the fixes branch of ocfs2.git.

Joel


-- 

Viro's Razor:
	Any race condition, no matter how unlikely, will occur just
	often enough to bite you.

Joel Becker
Principal Software Developer
Oracle
E-mail: joel.becker at oracle.com
Phone: (650) 506-8127
