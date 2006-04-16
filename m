From: Mark Fasheh <mark.fasheh@oracle.com>
Date: Sat, 15 Apr 2006 20:34:23 -0700
Subject: [Ocfs2-devel] [RFC: 2.6 patch] fs/ocfs2/: remove unused exports
In-Reply-To: <20060414113409.GJ4162@stusta.de>
References: <20060414113409.GJ4162@stusta.de>
Message-ID: <20060416033423.GH25194@ca-server1.us.oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Adrian Bunk <bunk@stusta.de>
Cc: kurt.hackel@oracle.com, ocfs2-devel@oss.oracle.com, linux-kernel@vger.kernel.org

Hi Adrian,
	These are all cluster stack functions and the OCFS2 cluster stack is
pretty much OCFS2 specific right now. So technically one could say they can
all be unexported until used by another related module. I'd rather leave
some of the ones that could make sense as exports though.

On Fri, Apr 14, 2006 at 01:34:09PM +0200, Adrian Bunk wrote:
> This patch removes the following unused EXPORT_SYMBOL_GPL's:
> - cluster/heartbeat.c: o2hb_check_node_heartbeating_from_callback
Completes an API. Lets keep this one please :)

> - cluster/heartbeat.c: o2hb_stop_all_regions
Hmm, called by the quorum stuff, which right now is embedded in the same
module as heartbeat anyway. Can probably go.

> - cluster/nodemanager.c: o2nm_get_node_by_num
> - cluster/nodemanager.c: o2nm_configured_node_map
> - cluster/nodemanager.c: o2nm_get_node_by_ip
I could definitely see the file system using these.

> - cluster/nodemanager.c: o2nm_node_put
> - cluster/nodemanager.c: o2nm_node_get
Can go for now.

> - dlm/dlmmaster.c: dlm_migrate_lockres
Was exported for debugging only anyway AFAIR. Can go.

Thanks,
	--Mark

--
Mark Fasheh
Senior Software Developer, Oracle
mark.fasheh at oracle.com
