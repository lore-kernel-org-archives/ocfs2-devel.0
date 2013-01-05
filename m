From: Gihan Munasinghe <gihan@flexiant.com>
Date: Sat, 05 Jan 2013 22:18:29 +0000
Subject: [Ocfs2-devel] o2cb_ctl -D option
Message-ID: <50E8A6B5.5020403@flexiant.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

Hi

I am trying to manage the ocfs2 cluster set up using the o2cb_ctl tool 
to create cluster add nodes etc.
But I see that "o2cb_ctl -D" to delete a node it says the option is not 
yet supported.

Looking at the code (according to my very limited knowledge of it) I can 
see that two helper functions need to delete a node is actually implemented

1) in o2cb_config.h "gint o2cb_cluster_delete_node(O2CBCluster *cluster, 
const gchar *name);".  Which I think will do the deletion from the 
config structure

2) in o2cb.h "errcode_t o2cb_del_node(const char *cluster_name, const 
char *node_name);". Which seems to be removing the node from /sys/

So my question is there anything else that need to be done except for 
calling the above 2 functions and checking for error etc. Or do I need 
to worry about hart beat, locking etc.

If someone can put me in the correct direction I am more than happy to 
add that code in.

Thanks
Gihan
