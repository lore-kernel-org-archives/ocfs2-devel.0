From: Andrew Beekhof <abeekhof@suse.de>
Date: Fri Dec  1 00:16:14 2006
Subject: [Ocfs2-devel] [patch 0/1] OCFS Configurable timeouts - Revision 2
In-Reply-To: <20061201015023.GG26014@ca-server1.us.oracle.com>
References: <20061129085130.004252000@suse.de>
	<20061201015023.GG26014@ca-server1.us.oracle.com>
Message-ID: <BA6A2C1F-BCFD-4889-A79E-DBDEF7E23FBD@suse.de>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com


On Dec 1, 2006, at 2:50 AM, Joel Becker wrote:

> On Wed, Nov 29, 2006 at 09:51:30AM +0100, abeekhof@suse.de wrote:
>> Added a global spinlock around modifications to  
>> o2net_connected_peer (as discussed with Mark).
>>
>> I have a separate patch that uses to_o2nm_cluster_from_node() but  
>> since I cant reproduce the problem mentioned in Jeff's comment (it  
>> apparently needs the userspace heartbeating modifications), I'd  
>> prefer to leave it out.
>
> 	Which problem do you mean?  I'm trying to know if the callback
> changes (->disconnect_notify()) make you happy and are good enough to
> push towards mainline.  Have you tested with them, etc?

I'm referring to this problem noted by Jeff

/*
* FIXME: These should use to_o2nm_cluster_from_node(), but we end up
* losing our parent link to the cluster during shutdown. This can be
* solved by adding a pre-removal callback to configfs, or passing
* around the cluster with the node. -jeffm
*/

Without the userspace heartbeat code I can't seem to create this  
situation and everything works nicely.
So I'm not yet in a position to really comment on  
the .disconnect_notify changes.

--
Andrew Beekhof

"Would the last person to leave please turn out the enlightenment?" -  
TISM
