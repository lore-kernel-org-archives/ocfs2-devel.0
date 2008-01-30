From: wengang wang <wen.gang.wang@oracle.com>
Date: Wed Jan 30 18:39:33 2008
Subject: [Ocfs2-devel] [PATCH 1/1]ocfs2: add dlm_ctxt printing for dlm
	debugging
In-Reply-To: <478FC633.6010603@oracle.com>
References: <478EF8F7.2080806@oracle.com> <478FC633.6010603@oracle.com>
Message-ID: <47A131F6.40805@oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

revised patch.

add dlm_ctxt printing for dlm debugging
cat /proc/fs/ocfs2_dlm/<domain>/ctxt shows dlm_ctxt
shows stuff as:
purge_count=0, node_num=1, joining_node=255, reco.new_master=255, 
reco.dead_node=255, reco.state=0
refs=1, state=1, num_joins=1, live_nodes_map=1 , domain_map=1 , 
recovery_map=

this patch is against ocfs2-1.2 svn head.

Signed-off-by: wengang wang <wen.gang.wang@oracle.com>

 dlmdebug.c |   59 
+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 59 insertions(+)


-------------- next part --------------
A non-text attachment was scrubbed...
Name: ocfs2_dlm_ctxt_dump.patch
Type: text/x-patch
Size: 2968 bytes
Desc: not available
Url : http://oss.oracle.com/pipermail/ocfs2-devel/attachments/20080131/4a1bada0/ocfs2_dlm_ctxt_dump.bin
