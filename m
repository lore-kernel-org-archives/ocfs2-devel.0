From: David Weber <wb@munzinger.de>
Date: Wed, 28 Jan 2015 08:43:06 +0000
Subject: [Ocfs2-devel] [RFC] ocfs2/dlm: support range lock
Message-ID: <0005282F.54C8AF2A@pegasus.munzinger.de>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

Hi,

On 01/26/2015 04:28 AM, yangwenfang wrote:
> 
> What:
> Byte range lock is applied to lock a region of a file to accelerate
> reading/writing concurrently.
> 
> Why:		
> Currently ocfs2 does not support byte range lock. Since multiple nodes
> may concurrently update/write at different positions of the same file
> in database workloads, the performance(tpmc) of DB+ocfs2 is much poorer 
> than
> DB+GPFS in running TPCC.
> Aiming at improving the efficiency of parallel accesses to the same file,
> we have implemented a demo of range lock feature which has been supported
> by lustre and GPFS, so that a file can be updated by different nodes in
> the cluster when they are visiting different blocks.

would this also make cluster aware fcntl(2) locks with the o2cb stack possible?

Cheers,
David
