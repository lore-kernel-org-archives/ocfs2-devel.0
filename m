From: Pierre Dinh-van <pierre@qsdf.org>
Date: Thu, 21 May 2020 19:02:23 +0200
Subject: [Ocfs2-devel] NFS clients crash OCFS2 nodes (general protection
 fault: 0000 [#1] SMP PTI)
In-Reply-To: <c1c0b293-2c25-a936-5e2a-7fa1089c3eb9@linux.alibaba.com>
References: <19bc32c6-a84e-8416-119c-9a1279bfd968@qsdf.org>
	<c1c0b293-2c25-a936-5e2a-7fa1089c3eb9@linux.alibaba.com>
Message-ID: <fe1c8848-f25b-193e-d488-dedfb37d45b7@qsdf.org>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

On 5/20/20 4:52 AM, Changwei Ge wrote:
> Hi Pierre,

Hi Changwei,

> You indeed provide detailed information on this problem and the
research looks very nice.

Thank you

> On 5/19/20 6:48 PM, Pierre Dinh-van wrote:
>>
> Hi,
>
> I'm experiencing quite reproducable crashs on my OCFS2 cluster the last
> weeks, and I think I found out part of the Problem. But before I make a
> bug report (I'm not sure where), I though I could post my research here
> in case someone understands it better than I.
>
> When it happens, the kernel is giving me a 'general protection fault:
> 0000 [#1] SMP PTI' or ' BUG: unable to handle page fault for address:'
> message, local access to the OCFS2 volumes are all hanging forever, and
> the load is getting so high that only a hard reset "solves" the problem.
> It happened the same way on both nodes (always on the active node
> serving NFS). It happens when both nodes are up, or when only one is
> active.
>
> > This makes me a little puzzled, you mean you crash the kernel
> manually or ocfs2 crash the kernel itself? From the backtrace you
> posted, I assume that you crash the kernel manually to migrate NFS
> export IP to the other standby node, right?
>
I'm not crashing the kernel manually (I don't know how I could do).
Ocfs2 is crashing the kernel as soon as some NFS requests are coming in,
after the node started to serve NFS.

Maybe I'm using the term "crash the kernel" a wrong way. Actually, only
the OCFS2 part of the system is not responding after this crash. I can
still log in with SSH and try to do things.


> First, a few words about my setup :

> In fact, I am not quite experienced in this kind of setup where ocfs2
serves as NFS/Samba backend filesystem, but the use case seems no
problem to me. But considering that you have hundreds of clients
connected to a single NFS/v4 server, do you have a performance
limitation. This has nothing with the problem, just my personal curiosity.

Most of the NFS clients are Linux desktop clients. Some MacOSX too. The
accesses are not really I/O intensive so I don't have preformance issues
of having only 1 active node. Actually, the performance problem we had
first was because of o2cb speaking over a 1Gb ethernet link, which was
increasing the lstat() time a lot compared to XFS we had before. The
cluster setup was mostly designed to have an easy failover system, and
OCFS2 gave the impression of reducing the risk of corrupt file system
(and allowed samba to be load balanced too)


> 4) nodeB's load is getting high
>
> > I suppose the reason is that ocfs2 can't successfully acquire
> spin_lock of a system inode(ocfs2 internal mechanism to store its
> metadata, not visible to end users ). As you know, locking path won't
> stop trying until it get the lock, so it consumes a lot of CPU cycles,
> you probably observed a high system workload.


So a possible path would be something like this ? (I don't know much
about internals auf NFS locking and POSIX locking, so it's a guess):

NFS client has a lock -> server is rebooted and forgets about the locks
-> NFS clients requests the lock (maybe ignores the grace time or races
with the nfsd restart). nfsd ask the FS about an unknown lock and it
crashes the OCFS2 module somehow.


> Most of the time, when the IP jumps to the other node, I get some of
> this messages :
>
>
> [? 501.707566] (nfsd,2133,14):ocfs2_test_inode_bit:2841 ERROR: unable to
> get alloc inode in slot 65535
>
> > This is very strange, I think ocfs2 passes the invalid slot number
> to subsequent consumer function, which makes it use a dangling pointer
> to a fake/illegal system inode. In other word, this why ocfs2 can't
> acquire the spin_lock of system inode.
>
>
> > Can you try to fix the logic in `ocfs2_get_suballoc_slot_bit`
> judging if slot number is valid? And perform your case once more?
>
> > Feel free to ask my help if you need. :-)
>
I never looked at the code of OCFS2 and I'm not familiar with filesystem
internals. I actually wrote to ocfs2-devel because ocfs2-users is not
letting my mails go through :).

For testing the case, I will try to do something on the standby node on
the original ocfs2 volumes, as soon as I'm sure that it's safe for the
productive server. But for checking the logic in
ocfs2_get_suballoc_slot_bit, I looked at the code and don't really
understand it


>
> [? 501.716660] (nfsd,2133,14):ocfs2_test_inode_bit:2867 ERROR: status
> = -22
>
> > Why this happens and if it is another issue needs further investigation.
>
> [? 501.726585] (nfsd,2133,6):ocfs2_test_inode_bit:2841 ERROR: unable to
> get alloc inode in slot 65535
> [? 501.735579] (nfsd,2133,6):ocfs2_test_inode_bit:2867 ERROR: status = -22
>
> But it also happens when the node is not crashing, so I think it's
> another Problem.
>
> Last night, I saved a few of the kernel output while the servers where
> crashing one after the other like in a ping-pong game :
>
>
> -----8< on nodeB? 8<-----
>
> [? 502.070431] nfsd: nfsv4 idmapping failing: has idmapd not been started?
> [? 502.475747] general protection fault: 0000 [#1] SMP PTI
> [? 502.481027] CPU: 6 PID: 2104 Comm: nfsd Not tainted
> 5.5.0-0.bpo.2-amd64 #1 Debian 5.5.17-1~bpo10+1
> []...
> I also made some record of NFS traffic with tcpdump when the crashs are
> occuring, but I didn't had time to analyse it. I can provide them if it
> helps (but I might have to clean them up first to avoid some data leaks :)
>
> After this happening a few times, I had one case where one of the few
> NFSv4 client was involved, and I took as aworkaround to migrate the
> NFSv4 share to XFS since I though it could be NFSv4 related. Now that I
> looked at the kernel dumps, I think it's also NFSv3 related.
>
> Is it a kernel bug or am I missing something ?
>
> > Probably a ocfs2 internal error handling bug. :-(

I'll check if I can reproduce it in a safe testing environment.

Is there any things I should also make while reproducing to have a
better understanding of the failure path ? I never did kernel debugging
before.


>
> For now, I will switch back to XFS with a failover setup of my cluster,
> cause I cannot afford this kind of crashes of a central file server.
>
>
>
> > Interesting, do you mean you can use XFS as a NFSv4 backend
> filesystem which is formatted on a shared SCSI LUN with more than one
> host attached without filesystem corruption?
>
>
I switched back to a single active node setup. the second node is in
standby and don't touch the XFS until the first node is not using them
anymore.

Should be safe for now.


Cheers


Pierre



-------------- next part --------------
A non-text attachment was scrubbed...
Name: signature.asc
Type: application/pgp-signature
Size: 833 bytes
Desc: OpenPGP digital signature
Url : http://oss.oracle.com/pipermail/ocfs2-devel/attachments/20200521/5cc7d0b6/attachment.bin 
