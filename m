From: Mark Fasheh <mark.fasheh@oracle.com>
Date: Fri Mar 14 10:37:15 2008
Subject: [Ocfs2-devel] New dlm debug infrastructure - 3rd attempt
In-Reply-To: <1205187389-3563-1-git-send-email-sunil.mushran@oracle.com>
References: <1205187389-3563-1-git-send-email-sunil.mushran@oracle.com>
Message-ID: <20080314173633.GA23981@ca-server1.us.oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

On Mon, Mar 10, 2008 at 03:16:18PM -0700, Sunil Mushran wrote:
> The following patches follow:

Ok, these are all in ocfs2.git now.
	--Mark


> 
> [PATCH 01/11] ocfs2/dlm: Rename slabcache dlm_mle_cache to o2dlm_mle
> [PATCH 02/11] ocfs2/dlm: Creates slabcaches for lock and lockres
> [PATCH 03/11] ocfs2/dlm: Link all lockres' to a tracking list
> [PATCH 04/11] ocfs2/dlm: Create debugfs dirs
> [PATCH 05/11] ocfs2/dlm: Dump the dlm state in a debugfs file
> [PATCH 06/11] ocfs2/dlm: Dumps the lockres' into a debugfs file
> [PATCH 07/11] ocfs2/dlm: Move struct dlm_master_list_entry to dlmcommon.h
> [PATCH 08/11] ocfs2/dlm: Dumps the mles into a debugfs file
> [PATCH 09/11] ocfs2/dlm: Dumps the purgelist into a debugfs file
> [PATCH 10/11] ocfs2/dlm: Move dlm_print_one_mle() from dlmmaster.c to dlmdebug.c
> [PATCH 11/11] ocfs2/dlm: Fix lockname in lockres print function
> 
> Changes suggested by Joel Becker have been incorporated.
> 
> This patch series has been tested with ocfs2.git upstream-linus branch.
> 
> Sunil
> 
> 
> _______________________________________________
> Ocfs2-devel mailing list
> Ocfs2-devel@oss.oracle.com
> http://oss.oracle.com/mailman/listinfo/ocfs2-devel
--
Mark Fasheh
Principal Software Developer, Oracle
mark.fasheh@oracle.com
