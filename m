From: Sunil Mushran <sunil.mushran@gmail.com>
Date: Sun, 6 Jan 2013 08:16:26 +0530
Subject: [Ocfs2-devel] o2cb_ctl -D option
In-Reply-To: <50E8A6B5.5020403@flexiant.com>
References: <50E8A6B5.5020403@flexiant.com>
Message-ID: <79D0D610-8930-4A7B-94F4-E9D1481874B7@gmail.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

Use latest tools. 1.8.x. It includes a new tool 'o2cb'  that allows removal of nodes, global heartbeat, etc. 

On Jan 6, 2013, at 3:48 AM, Gihan Munasinghe <gihan@flexiant.com> wrote:

> Hi
> 
> I am trying to manage the ocfs2 cluster set up using the o2cb_ctl tool 
> to create cluster add nodes etc.
> But I see that "o2cb_ctl -D" to delete a node it says the option is not 
> yet supported.
> 
> Looking at the code (according to my very limited knowledge of it) I can 
> see that two helper functions need to delete a node is actually implemented
> 
> 1) in o2cb_config.h "gint o2cb_cluster_delete_node(O2CBCluster *cluster, 
> const gchar *name);".  Which I think will do the deletion from the 
> config structure
> 
> 2) in o2cb.h "errcode_t o2cb_del_node(const char *cluster_name, const 
> char *node_name);". Which seems to be removing the node from /sys/
> 
> So my question is there anything else that need to be done except for 
> calling the above 2 functions and checking for error etc. Or do I need 
> to worry about hart beat, locking etc.
> 
> If someone can put me in the correct direction I am more than happy to 
> add that code in.
> 
> Thanks
> Gihan
> 
> 
> 
> 
> 
> _______________________________________________
> Ocfs2-devel mailing list
> Ocfs2-devel at oss.oracle.com
> https://oss.oracle.com/mailman/listinfo/ocfs2-devel
