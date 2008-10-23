From: wengang wang <wen.gang.wang@oracle.com>
Date: Thu, 23 Oct 2008 17:22:26 +0800
Subject: [Ocfs2-devel] [PATCH 1/1] OCFS2: fix for nfs getting stale
	inode.
In-Reply-To: <20081023090954.GC1580@mail.oracle.com>
References: <200810230419.m9N4JLpn012453@localhost.localdomain>
	<20081023081650.GA1580@mail.oracle.com>
	<490036DC.8000406@oracle.com>
	<20081023090954.GC1580@mail.oracle.com>
Message-ID: <49004252.7070603@oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com



Joel Becker wrote:
> On Thu, Oct 23, 2008 at 04:33:32PM +0800, wengang wang wrote:
>   
>> Joel Becker wrote:
>>     
>>> 	What's the problem other than ESTALE?  That's perfectly valid in
>>> the world of NFS.
>>>
>>>   
>>>       
>> ESTALE is not a big problem, what is important is that:
>> it cause kernel panic during ocfs2_meta_lock_update() at later 
>> operations when it updates metadata from disk.
>>     
>
> 	This is the bug.  Why is a stale inode getting meta_lock called
> against it?  That's what we should be preventing, no?
>
>   
for the time, system doesn't know whether it's stale yet.
the fix just makes the inode to be stale(OCFS2_INODE_DELETE), or make 
sure there is no such a
stale inode in memory when it's stale(deleted or a new different inode 
occupies the same block).
