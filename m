From: Mark Fasheh <mark.fasheh@oracle.com>
Date: Mon Jan 28 15:31:51 2008
Subject: [Ocfs2-devel] Re: [2.6 patch] fs/ocfs2/: possible cleanups
In-Reply-To: <20080128221141.GA8767@does.not.exist>
References: <20080128221141.GA8767@does.not.exist>
Message-ID: <20080128233107.GB23506@ca-server1.us.oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Adrian Bunk <bunk@kernel.org>
Cc: kurt.hackel@oracle.com, ocfs2-devel@oss.oracle.com, linux-kernel@vger.kernel.org

On Tue, Jan 29, 2008 at 12:11:41AM +0200, Adrian Bunk wrote:
> This patch contains the following cleanups that are now possible:
> - make the following needlessly global functions static:
>   - dlmglue.c:ocfs2_process_blocked_lock()
>   - heartbeat.c:ocfs2_node_map_init()
> - #if 0 the following unused global function plus support functions:
>   - heartbeat.c:ocfs2_node_map_is_only()
> 
> Signed-off-by: Adrian Bunk <bunk@kernel.org>


This all looks good - thanks Adrian.
	--Mark

--
Mark Fasheh
Principal Software Developer, Oracle
mark.fasheh@oracle.com
