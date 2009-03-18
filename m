From: Joel Becker <Joel.Becker@oracle.com>
Date: Wed, 18 Mar 2009 10:07:13 -0700
Subject: [Ocfs2-devel] shutdown by o2net_idle_timer causes Xen to hang
In-Reply-To: <8C38B97A-7440-4F01-ADFE-FCF3777D6486@zeec.biz>
References: <8C38B97A-7440-4F01-ADFE-FCF3777D6486@zeec.biz>
Message-ID: <20090318170713.GB23209@mail.oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

On Wed, Mar 18, 2009 at 12:17:36PM +0100, David Winter wrote:
> Hello,
> 
> we've had some serious trouble with a two-node Xen-based OCFS2  
> cluster. In brief: we had two incidents where one node detects an idle  
> timeout and shuts the other node down which causes the other node and  
> the Dom0 to hang. Both times this could only be resolved by rebooting  
> the whole machine using the built-in IPMI card.
> 
> All machines (including the other DomUs) run Centos 5.2 and the OCFS2  
> nodes use ocfs2-tools-1.4.1-1.el5 and  
> ocfs2-2.6.18-92.1.13.el5xen-1.4.1-1.el5.
> 
> Unfortunately there wasn't logged much of relevance, except for the / 
> var/log/messages of the node that issued the shutdown (see below) and  
> the nearly five hour gap in the logs of the other node.

	Just to clarify, the o2cb stack doesn't shut down other nodes.
Nodes can only self-fence.  The 'shutting it down' message in the logs
is about the connection.  In other words, cod-2 is already hanging.
ugc-1 notices and closes the network connection.
	So you want to figure out why cod-2 hung or crashed.  Sunil is
right that you'll want netconsole for a better idea of what's going on.
We can't diagnose cod-2 from this information.
	If your dom0 is hanging, that's a separate issue.  A hanging
domU, no matter the cause, shouldn't hang dom0.

Joel

-- 

"Sometimes when reading Goethe I have the paralyzing suspicion
 that he is trying to be funny."
         - Guy Davenport

Joel Becker
Principal Software Developer
Oracle
E-mail: joel.becker at oracle.com
Phone: (650) 506-8127
