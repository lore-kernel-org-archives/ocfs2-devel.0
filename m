From: Tao Ma <tm@tao.ma>
Date: Thu, 23 Aug 2012 11:44:25 +0800
Subject: [Ocfs2-devel] RFC: OCFS2 heartbeat improvements
In-Reply-To: <5034EA17.107@oracle.com>
References: <5034EA17.107@oracle.com>
Message-ID: <5035A719.1000707@tao.ma>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

Hi Jeff,
On 08/22/2012 10:17 PM, Jie Liu wrote:
> Hi All,
> 
> These days, I am investigating an issue regarding OCFS2 unexpected
> reboot in some real world use cases.
> This problem occurred when the network status goes south, when the disk
> IO load is too high, etc...
> I suspect it might caused by ocfs2 fencing if it's BIO reading/writing
> can not be scheduled and processed quickly, or
> something like this happened in the network IO heartbeat thread.
> 
> Now am trying to reproduce this problem locally.  In the meantime, I'd
> like to ping you guys with some rough ideas
> to improve the disk IO heartbeat to see if they are sounds reasonable or
> not.
> 
> Firstly, if an OCFS2 node is suffer from heavy disk IO, how about to fix
> the bio read/write to make this IO request can not
> be preempted by other requests? e.g,  for o2hb_issue_node_write(),
> currently, it do bio submission with WRITE only,
> 'submit_bio(WRITE, bio)'.   If we change the flag to WRITE_SYNC, or even
> submit the request combine with REQ_FUA,
> maybe could get highest priority for disk IO request.
yes, WRITE is too much easy to be preempted in cfq since it is in the
async queue, so if we have a lot of read or sync write, the heartbeat
write will be delayed a lot.

So as Srini has said in another e-mail, WRITE_SYNC should help in case
it will let you have the chance of be a sync write and be treated the
same as the read. Please check it first to see whether it is OK.

I guess the final solution will be WRITE_FUA, and I see btrfs uses it to
write out the superblock. It will be handled differently by the
underlying block layer so that it will not be in the elevator queue. It
should work but I am not sure whether we need to be so aggressive. Maybe
some test will show.

Thanks
Tao

> 
> Secondly, the comments for bio allocation at o2hb_setup_one_bio()
> indicates that we can pre-allocate bio instead of
> acquire for each time.  But I have not saw any code snippet doing such
> things in kernel. :(
> how about creating a private bio set for each o2hb_region, so that we
> can do allocation out of it?
> maybe it's faster than do allocation from global bio sets.  Also, does
> it make sense if creating a memory pool
> on each o2hb_region, so that we can have continuous pages bind to those
> bios?
> 
> 
> Any comments are appreciated!
> 
> Thanks,
> -Jeff
> 
> 
> 
> 
> 
> 
