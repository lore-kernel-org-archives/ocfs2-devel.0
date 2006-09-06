From: Mark Fasheh <mark.fasheh@oracle.com>
Date: Wed Sep  6 09:15:11 2006
Subject: [Ocfs2-devel] heartbeat.
In-Reply-To: <44FE73D5.2020602@seanodes.com>
References: <44FE73D5.2020602@seanodes.com>
Message-ID: <20060906161507.GD8792@ca-server1.us.oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

Hi Mathieu,

On Wed, Sep 06, 2006 at 09:08:05AM +0200, Mathieu Avila wrote:
> Hello OCFS2 team,
> 
> I'm currently looking at the OCFS2 code in linux-2.6.17.11, and i wander 
> why OCFS2 performs its heartbeat on a disk region unlike on the network 
> like many clustered services stack do. What is the requirement for a 
> disk heartbeat ? Is there any way to tune this behaviour and change it 
> into a network heartbeat ?
The OCFS2 cluster stack heartbeats on both disk and network. Disk is
generally thought to have the final say as to whether a node is alive or
not. The reason we heartbeat on disk is because we want to be sure a
connection to the disk is maintained. Otherwise, the cluster could hang
indefinitely if the disk cable from one mounted node is unplugged - it
wouldn't be able to write out shared meta data for other nodes to read.

That all said, we're likely to remove the disk heartbeat in favor of a read
only mechanism in a future release of OCFS2.
	--Mark

--
Mark Fasheh
Senior Software Developer, Oracle
mark.fasheh@oracle.com
