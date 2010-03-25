From: Sunil Mushran <sunil.mushran@oracle.com>
Date: Thu, 25 Mar 2010 13:35:07 -0700
Subject: [Ocfs2-devel] Question of rejecting a downconvert
In-Reply-To: <4BABA23A.2060308@oracle.com>
References: <4BAC1F6B020000460001CAEE@novprvlin0050.provo.novell.com>
	<4BABA23A.2060308@oracle.com>
Message-ID: <4BABC8FB.7090203@oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

Sorry. Ignore the suggestion in the last email.

What I meant was that we should prevent the unlink in the vfs itself.
That is, the unlink() for such directories should not touch ocfs2.

To do that, we have to propagate dentry->d_mounted to all nodes.
If a node does a submount, make it take an EX on that dentry lock.
If so, then we can propagate this count using lvb. When another
node takes a PR on that lock, it will get the count via the lvb.

Unresolved is handling recovery. What if the node that has the sub-mount
crashes. How do we handle that. The scheme has to allow for the fact that
all nodes may have sub-mounts in the same dir.

Sunil

Sunil Mushran wrote:
> As I said... there are no means to reject a downconvert.
>
> May I suggest a different approach. Look at DCACHE_NFSFS_RENAMED.
> That's nfs's silly rename hack. NFS prevents unlinking of a file
> by setting this dentry flag.
>
> Investigate how we can set/unset this flag in the mount/umount path.
> Or, another flag that is specific to clustered file systems.
>
> Also, see gfs2. See how it handles this.
>
> Sunil
>
> Dong Yang Li wrote:
>> but just re-queuing the downconvert when the dentry is used as a mount point won't work for this case,
>> because when the other node wanna up-convert its dentry_lock to EX, it has already got the EX lock on
>>
>> the inode of the dentry's parent. so when we wanna get a PR lock on the inode(this could happen during a umount on the mountpoint),
>> we'll block on that and both the nodes will wait for each other forever. I see two options on this:
>> 1. make a node could reject the downconvert when it requires so.
>> 2. blocking the other node when it wanna unlink the dentry we used as a mount point,
>> and make us could get a PR on the inode of the mount point's parent, so after umount
>> we can finally do the downconvert and unblock the other node.
>> Comments?
>> Br,
>> Li Dongyang
>>
>>>>> Sunil Mushran  03/25/10 2:51 AM >>>
>> While the fs can delay the downconvert of any resource, there are
>> no means of explicitly rejecting it. And no rejection means the
>> requesting node will keep waiting for the downconvert.
>>
>> Li Dongyang wrote:
>>> Hi, list
>>> I've read 
>>> http://opendlm.sourceforge.net/cvsmirror/opendlm/docs/dlmbook_final.pdf but 
>>> still confused, why a node can not reject a downconvert when it gets a bast in 
>>> o2dlm?
>>> and if we can, we could fix this bug: 
>>> http://oss.oracle.com/bugzilla/show_bug.cgi?id=1075
>>> ocfs2: a busy mount point can be removed from another node
>>> by adding a check in check_downconvert callback:
>>> if the dentry->d_mounted is not zero, then just reject the downconvert.
>>>
>>> Any hints? :-)
>>> Thanks
>>>
>>> _______________________________________________
>>> Ocfs2-devel mailing list
>>> Ocfs2-devel at oss.oracle.com
>>> http://oss.oracle.com/mailman/listinfo/ocfs2-devel
>>>   
>>
>
>
> _______________________________________________
> Ocfs2-devel mailing list
> Ocfs2-devel at oss.oracle.com
> http://oss.oracle.com/mailman/listinfo/ocfs2-devel
